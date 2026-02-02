package com.nutrit.dao;

import com.nutrit.models.AppointmentRequest;
import com.nutrit.models.Appointment;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for managing patient appointment requests with secretary approval workflow (French schema).
 * Uses the rendez_vous table with statut = 'en_attente' for pending requests.
 */
public class AppointmentRequestDAO {
    
    // French status constants
    private static final String STATUS_PENDING = "en_attente";
    private static final String STATUS_APPROVED = "approuve";
    private static final String STATUS_REJECTED = "rejete";

    /**
     * Create a new appointment request from patient.
     */
    public boolean createRequest(AppointmentRequest request) {
        String sql = "INSERT INTO rendez_vous (patient_id, nutritionniste_id, date_heure_prevue, notes_patient, statut, methode_paiement, statut_paiement, montant_total) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, request.getPatientId());
            stmt.setInt(2, request.getNutritionistId());
            stmt.setTimestamp(3, request.getPreferredTime());
            stmt.setString(4, request.getPatientNotes());
            stmt.setString(5, STATUS_PENDING);
            
            // Map payment details
            String paymentMethod = "in_office";
            if ("online".equalsIgnoreCase(request.getPaymentMethod())) {
                paymentMethod = "en_ligne";
            } else if ("in_office".equalsIgnoreCase(request.getPaymentMethod())) {
                paymentMethod = "au_cabinet";
            }
            stmt.setString(6, paymentMethod);
            
            String paymentStatus = "en_attente";
            if ("paid".equalsIgnoreCase(request.getPaymentStatus())) {
                paymentStatus = "paye";
            }
            stmt.setString(7, paymentStatus);
            
            if (request.getPaymentAmount() != null) {
                stmt.setBigDecimal(8, request.getPaymentAmount());
            } else {
                stmt.setNull(8, Types.DECIMAL);
            }
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    request.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get pending requests for a nutritionist (for secretary to review).
     */
    public List<AppointmentRequest> getPendingRequestsByNutritionist(int nutritionistId) {
        List<AppointmentRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, u.nom_complet as patient_name, u.email as patient_email " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs u ON r.patient_id = u.id " +
                     "WHERE r.nutritionniste_id = ? AND r.statut = ? " +
                     "ORDER BY r.date_creation DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setString(2, STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get all requests by a patient (to show their request status).
     */
    public List<AppointmentRequest> getRequestsByPatient(int patientId) {
        List<AppointmentRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, n.nom_complet as nutritionist_name " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs n ON r.nutritionniste_id = n.id " +
                     "WHERE r.patient_id = ? " +
                     "ORDER BY r.date_creation DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get the most recent pending request for a patient.
     */
    public AppointmentRequest getLatestPendingRequest(int patientId) {
        String sql = "SELECT r.*, n.nom_complet as nutritionist_name " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs n ON r.nutritionniste_id = n.id " +
                     "WHERE r.patient_id = ? AND r.statut = ? " +
                     "ORDER BY r.date_creation DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setString(2, STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRequest(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get request by ID.
     */
    public AppointmentRequest getRequestById(int requestId) {
        String sql = "SELECT r.*, " +
                     "p.nom_complet as patient_name, p.email as patient_email, " +
                     "n.nom_complet as nutritionist_name " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs p ON r.patient_id = p.id " +
                     "JOIN utilisateurs n ON r.nutritionniste_id = n.id " +
                     "WHERE r.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, requestId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRequest(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Approve a request - updates status to approved.
     */
    public boolean approveRequest(int requestId, int secretaryId, String notes) {
        String sql = "UPDATE rendez_vous SET statut = ?, secretaire_id = ?, notes_internes = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, STATUS_APPROVED);
            stmt.setInt(2, secretaryId);
            stmt.setString(3, notes);
            stmt.setInt(4, requestId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Reject a request with a reason.
     */
    public boolean rejectRequest(int requestId, int secretaryId, String reason) {
        String sql = "UPDATE rendez_vous SET statut = ?, secretaire_id = ?, notes_internes = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, STATUS_REJECTED);
            stmt.setInt(2, secretaryId);
            stmt.setString(3, reason);
            stmt.setInt(4, requestId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Count pending requests for a nutritionist.
     */
    public int countPendingRequests(int nutritionistId) {
        String sql = "SELECT COUNT(*) FROM rendez_vous WHERE nutritionniste_id = ? AND statut = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setString(2, STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if patient already has a pending request.
     */
    public boolean hasPendingRequest(int patientId, int nutritionistId) {
        String sql = "SELECT COUNT(*) FROM rendez_vous " +
                     "WHERE patient_id = ? AND nutritionniste_id = ? AND statut = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, nutritionistId);
            stmt.setString(3, STATUS_PENDING);
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
     * Map ResultSet to AppointmentRequest object.
     */
    private AppointmentRequest mapRequest(ResultSet rs) throws SQLException {
        AppointmentRequest request = new AppointmentRequest();
        request.setId(rs.getInt("id"));
        request.setPatientId(rs.getInt("patient_id"));
        request.setNutritionistId(rs.getInt("nutritionniste_id"));
        request.setPreferredTime(rs.getTimestamp("date_heure_prevue"));
        request.setPatientNotes(rs.getString("notes_patient"));
        
        // Convert French status to English
        String frenchStatus = rs.getString("statut");
        request.setStatus(convertStatusToEnglish(frenchStatus));
        
        request.setCreatedAt(rs.getTimestamp("date_creation"));
        
        // Try to get optional fields
        try {
            request.setSecretaryId(rs.getInt("secretaire_id"));
        } catch (SQLException e) { /* Column might not exist */ }
        
        try {
            request.setSecretaryNotes(rs.getString("notes_internes"));
        } catch (SQLException e) { /* Column might not exist */ }
        
        try {
            request.setPatientName(rs.getString("patient_name"));
        } catch (SQLException e) { /* Column might not exist */ }
        
        try {
            request.setPatientEmail(rs.getString("patient_email"));
        } catch (SQLException e) { /* Column might not exist */ }
        
        try {
            request.setNutritionistName(rs.getString("nutritionist_name"));
        } catch (SQLException e) { /* Column might not exist */ }
        
        return request;
    }
    
    private String convertStatusToEnglish(String frenchStatus) {
        if (frenchStatus == null) return "pending";
        switch (frenchStatus.toLowerCase()) {
            case "en_attente": return "pending";
            case "approuve": return "approved";
            case "termine": return "completed";
            case "annule": return "cancelled";
            case "rejete": return "rejected";
            default: return frenchStatus;
        }
    }
}
