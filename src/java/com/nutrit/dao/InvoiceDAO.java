package com.nutrit.dao;

import com.nutrit.models.Invoice;
import com.nutrit.utils.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;

/**
 * Data Access Object for invoice operations (French schema).
 * In the French schema, invoice/payment data is embedded in the 'rendez_vous' table.
 * This DAO provides compatibility by querying rendez_vous for invoice data.
 */
public class InvoiceDAO {

    /**
     * Create/Update invoice data for an appointment.
     * In French schema, this updates the payment fields in rendez_vous.
     */
    public boolean createInvoice(Invoice invoice) {
        String sql = "UPDATE rendez_vous SET numero_facture = ?, montant_total = ?, statut_paiement = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String invoiceNumber = invoice.getInvoiceNumber();
            if (invoiceNumber == null || invoiceNumber.isEmpty()) {
                invoiceNumber = generateInvoiceNumber();
            }
            
            stmt.setString(1, invoiceNumber);
            stmt.setBigDecimal(2, invoice.getTotalAmount());
            stmt.setString(3, "en_attente"); // Payment pending
            stmt.setInt(4, invoice.getAppointmentId());
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                invoice.setInvoiceNumber(invoiceNumber);
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get invoice by appointment ID.
     */
    public Invoice getInvoiceByAppointmentId(int appointmentId) {
        String sql = "SELECT r.*, " +
                     "p.nom_complet as patient_name, " +
                     "n.nom_complet as nutritionist_name " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs p ON r.patient_id = p.id " +
                     "JOIN utilisateurs n ON r.nutritionniste_id = n.id " +
                     "WHERE r.id = ?"; // Removed IS NOT NULL check to allow viewing pro-forma/upcoming invoices
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapInvoice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get invoice by ID (appointment ID in French schema).
     */
    public Invoice getInvoiceById(int invoiceId) {
        return getInvoiceByAppointmentId(invoiceId);
    }

    /**
     * Get all invoices for a patient.
     * Includes upcoming appointments as pending invoices.
     */
    public List<Invoice> getInvoicesByPatient(int patientId) {
        List<Invoice> invoices = new ArrayList<>();
        // Include confirmed/upcoming/completed appointments, even if no formal invoice number yet
        // DB Enum for rendezvous status: 'en_attente','approuve','termine','annule','rejete'
        // We want 'approuve' (approved/upcoming) and 'termine' (completed)
        String sql = "SELECT r.*, " +
                     "p.nom_complet as patient_name, " +
                     "n.nom_complet as nutritionist_name " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs p ON r.patient_id = p.id " +
                     "JOIN utilisateurs n ON r.nutritionniste_id = n.id " +
                     "WHERE r.patient_id = ? " +
                     "AND r.statut IN ('approuve', 'termine') " + 
                     "ORDER BY r.date_creation DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                invoices.add(mapInvoice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }

    /**
     * Generate unique invoice number: FACT-YYYY-NNNNN
     */
    public String generateInvoiceNumber() {
        int year = LocalDate.now().getYear();
        String prefix = "FACT-" + year + "-";
        
        String sql = "SELECT numero_facture FROM rendez_vous " +
                     "WHERE numero_facture LIKE ? " +
                     "ORDER BY numero_facture DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, prefix + "%");
            ResultSet rs = stmt.executeQuery();
            
            int nextNumber = 1;
            if (rs.next()) {
                String lastInvoice = rs.getString("numero_facture");
                if (lastInvoice != null) {
                    try {
                        String numberPart = lastInvoice.substring(prefix.length());
                        nextNumber = Integer.parseInt(numberPart) + 1;
                    } catch (Exception e) {
                        // Use default 1
                    }
                }
            }
            
            return String.format("%s%05d", prefix, nextNumber);
        } catch (SQLException e) {
            e.printStackTrace();
            return prefix + "00001";
        }
    }

    /**
     * Update invoice payment status.
     */
    public boolean updatePaymentStatus(int invoiceId, String status) {
        String frenchStatus = convertPaymentStatusToFrench(status);
        String sql = "UPDATE rendez_vous SET statut_paiement = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, frenchStatus);
            stmt.setInt(2, invoiceId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if invoice exists for appointment.
     */
    public boolean invoiceExistsForAppointment(int appointmentId) {
        String sql = "SELECT COUNT(*) FROM rendez_vous WHERE id = ? AND numero_facture IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet to Invoice object.
     */
    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setId(rs.getInt("id"));
        invoice.setAppointmentId(rs.getInt("id"));
        invoice.setInvoiceNumber(rs.getString("numero_facture"));
        invoice.setTotalAmount(rs.getBigDecimal("montant_total"));
        
        // Convert French status to English
        String frenchStatus = rs.getString("statut_paiement");
        invoice.setPaymentStatus(convertPaymentStatusToEnglish(frenchStatus));
        
        // Map payment method
        String frenchPaymentMethod = rs.getString("methode_paiement");
        invoice.setPaymentMethod(convertPaymentMethodToEnglish(frenchPaymentMethod));
        
        try {
            invoice.setGeneratedBy(rs.getInt("secretaire_id"));
            if (rs.wasNull()) invoice.setGeneratedBy(null);
        } catch (SQLException e) { /* Column might not exist */ }
        
        invoice.setCreatedAt(rs.getTimestamp("date_creation"));
        
        // Set patient and nutritionist info
        invoice.setPatientId(rs.getInt("patient_id"));
        invoice.setNutritionistId(rs.getInt("nutritionniste_id"));
        
        try {
            invoice.setPatientName(rs.getString("patient_name"));
            invoice.setNutritionistName(rs.getString("nutritionist_name"));
        } catch (SQLException e) {
            // Columns might not be in query
        }
        
        // Appointment time
        try {
            invoice.setAppointmentDate(rs.getTimestamp("date_heure_prevue"));
        } catch (SQLException e) {
            // Column might not be in query
        }
        
        return invoice;
    }
    
    private String convertPaymentStatusToFrench(String englishStatus) {
        if (englishStatus == null) return "en_attente";
        switch (englishStatus.toLowerCase()) {
            case "pending": return "en_attente";
            case "paid": return "paye";
            case "failed": return "echoue";
            default: return "en_attente";
        }
    }
    
    private String convertPaymentStatusToEnglish(String frenchStatus) {
        if (frenchStatus == null) return "pending";
        switch (frenchStatus.toLowerCase()) {
            case "en_attente": return "pending";
            case "paye": return "paid";
            case "echoue": return "failed";
            default: return "pending";
        }
    }

    private String convertPaymentMethodToFrench(String englishMethod) {
        if (englishMethod == null) return null;
        switch (englishMethod.toLowerCase()) {
            case "online": return "en_ligne";
            case "in_office":
            case "in-office":
            case "office": return "au_cabinet";
            default: return "en_ligne";
        }
    }

    private String convertPaymentMethodToEnglish(String frenchMethod) {
        if (frenchMethod == null) return null;
        switch (frenchMethod.toLowerCase()) {
            case "en_ligne": return "online";
            case "au_cabinet": return "in_office";
            default: return "online";
        }
    }
}
