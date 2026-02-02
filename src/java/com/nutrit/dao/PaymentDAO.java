package com.nutrit.dao;

import com.nutrit.models.Payment;
import com.nutrit.utils.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * DAO for payment operations.
 * Refactored to use 'rendez_vous' table (French schema).
 * Embeds payment data into appointment records.
 */
public class PaymentDAO {
    
    /**
     * Create a new payment record - in French schema, this updates an appointment or request.
     */
    public boolean createPayment(Payment payment) {
        // In the consolidated schema, payment data is stored in the rendez_vous table.
        // We update the appointment (rendez_vous) entry.
        String sql = "UPDATE rendez_vous SET methode_paiement = ?, statut_paiement = ?, montant_total = ?, notes_internes = ? " +
                     "WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Map payment method to French enum
            String method = "en_ligne";
            if ("in_office".equalsIgnoreCase(payment.getPaymentMethod()) || "au_cabinet".equalsIgnoreCase(payment.getPaymentMethod())) {
                method = "au_cabinet";
            }
            
            // Map status to French enum
            String status = "en_attente";
            if ("completed".equalsIgnoreCase(payment.getStatus()) || "paid".equalsIgnoreCase(payment.getStatus())) {
                status = "paye";
            } else if ("failed".equalsIgnoreCase(payment.getStatus())) {
                status = "echoue";
            }
            
            stmt.setString(1, method);
            stmt.setString(2, status);
            stmt.setBigDecimal(3, payment.getAmount());
            
            // Store extra details in notes_internes
            String extraDetails = "TXN: " + payment.getTransactionRef();
            if (payment.getCardLastFour() != null) {
                extraDetails += " | Card: ****" + payment.getCardLastFour();
            }
            stmt.setString(4, extraDetails);
            
            // Use appointment_id if available, otherwise appointment_request_id (which is the same table ID in French schema)
            int targetId = -1;
            if (payment.getAppointmentId() != null) targetId = payment.getAppointmentId();
            else if (payment.getAppointmentRequestId() != null) targetId = payment.getAppointmentRequestId();
            
            if (targetId == -1) return false;
            
            stmt.setInt(5, targetId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update payment status.
     */
    public boolean updatePaymentStatus(int appointmentId, String status) {
        String sql = "UPDATE rendez_vous SET statut_paiement = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String frenchStatus = "en_attente";
            if ("completed".equalsIgnoreCase(status) || "paye".equalsIgnoreCase(status) || "paid".equalsIgnoreCase(status)) {
                frenchStatus = "paye";
            } else if ("failed".equalsIgnoreCase(status)) {
                frenchStatus = "echoue";
            }
            
            stmt.setString(1, frenchStatus);
            stmt.setInt(2, appointmentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get payment by appointment ID.
     */
    public Payment getPaymentByAppointmentId(int appointmentId) {
        String sql = "SELECT r.*, u.nom_complet as patient_name FROM rendez_vous r " +
                     "JOIN utilisateurs u ON r.patient_id = u.id WHERE r.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapPayment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get payment by appointment request ID.
     */
    public Payment getPaymentByRequestId(int requestId) {
        return getPaymentByAppointmentId(requestId);
    }
    
    /**
     * Get all payments for a patient.
     */
    public List<Payment> getPaymentsByPatient(int patientId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT r.*, u.nom_complet as patient_name FROM rendez_vous r " +
                     "JOIN utilisateurs u ON r.patient_id = u.id " +
                     "WHERE r.patient_id = ? AND r.statut_paiement IS NOT NULL " +
                     "ORDER BY r.date_creation DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                payments.add(mapPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    /**
     * Generate a unique transaction reference.
     */
    public static String generateTransactionRef() {
        return "TXN-" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    /**
     * Link payment to appointment (Dummy for French schema compatibility).
     */
    public boolean linkPaymentToAppointment(int requestId, int appointmentId) {
        return true; // Already same record in French schema
    }
    
    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setAppointmentId(rs.getInt("id"));
        p.setAppointmentRequestId(rs.getInt("id"));
        p.setPatientId(rs.getInt("patient_id"));
        p.setAmount(rs.getBigDecimal("montant_total"));
        
        String method = rs.getString("methode_paiement");
        p.setPaymentMethod("au_cabinet".equals(method) ? "in_office" : "online");
        
        String status = rs.getString("statut_paiement");
        p.setStatus("paye".equals(status) ? "completed" : "pending");
        
        // Extract transaction ref from notes if possible
        String notes = rs.getString("notes_internes");
        if (notes != null && notes.contains("TXN: ")) {
            p.setTransactionRef(notes.split("\\|")[0].replace("TXN: ", "").trim());
        }
        
        p.setCreatedAt(rs.getTimestamp("date_creation"));
        p.setPatientName(rs.getString("patient_name"));
        return p;
    }
}

