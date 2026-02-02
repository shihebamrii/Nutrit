package com.nutrit.dao;

import com.nutrit.models.PatientRequest;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for patient-nutritionist relationships (French schema).
 * 
 * NOTE: The French schema doesn't have a dedicated patient_requests table.
 * Patient-nutritionist relationships are tracked through the rendez_vous table.
 * A patient is considered "assigned" to a nutritionist when they have appointments with them.
 */
public class PatientRequestDAO {

    /**
     * Get pending appointment requests for a nutritionist.
     * In French schema, pending requests are appointments with status 'en_attente'.
     */
    public List<PatientRequest> getPendingRequests(int nutritionistId) {
        List<PatientRequest> list = new ArrayList<>();
        String sql = "SELECT r.id, r.patient_id, r.nutritionniste_id, r.statut, r.date_creation, " +
                     "u.nom_complet, u.email " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs u ON r.patient_id = u.id " +
                     "WHERE r.nutritionniste_id = ? AND r.statut = 'en_attente' " +
                     "ORDER BY r.date_creation DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                PatientRequest req = new PatientRequest();
                req.setId(rs.getInt("id"));
                req.setPatientId(rs.getInt("patient_id"));
                req.setNutritionistId(rs.getInt("nutritionniste_id"));
                // Convert French status to English
                req.setStatus(convertStatusToEnglish(rs.getString("statut")));
                req.setCreatedAt(rs.getTimestamp("date_creation"));
                req.setPatientName(rs.getString("nom_complet"));
                req.setPatientEmail(rs.getString("email"));
                list.add(req);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Count pending requests (appointments with status 'en_attente').
     */
    public int countPendingRequests(int nutritionistId) {
        String sql = "SELECT COUNT(*) FROM rendez_vous WHERE nutritionniste_id = ? AND statut = 'en_attente'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Count active patients (distinct patients with approved/completed appointments).
     */
    public int countActivePatients(int nutritionistId) {
        String sql = "SELECT COUNT(DISTINCT patient_id) FROM rendez_vous " +
                     "WHERE nutritionniste_id = ? AND (statut = 'approuve' OR statut = 'termine')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Accept a request (approve an appointment).
     */
    public boolean acceptRequest(int requestId) {
        String sql = "UPDATE rendez_vous SET statut = 'approuve' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, requestId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Create a new patient request (create a pending appointment).
     */
    public boolean createRequest(int patientId, int nutritionistId) {
        if (hasActiveOrPendingRequest(patientId, nutritionistId)) return false;
        
        String sql = "INSERT INTO rendez_vous (patient_id, nutritionniste_id, statut, date_heure_prevue) " +
                     "VALUES (?, ?, 'en_attente', DATE_ADD(NOW(), INTERVAL 1 DAY))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, nutritionistId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if patient has active or pending appointments with nutritionist.
     */
    public boolean hasActiveOrPendingRequest(int patientId, int nutritionistId) {
        String sql = "SELECT COUNT(*) FROM rendez_vous " +
                     "WHERE patient_id = ? AND nutritionniste_id = ? " +
                     "AND (statut = 'en_attente' OR statut = 'approuve')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get the nutritionist ID for a patient (based on their appointments).
     */
    public int getMyNutritionistId(int patientId) {
        String sql = "SELECT DISTINCT nutritionniste_id FROM rendez_vous " +
                     "WHERE patient_id = ? AND (statut = 'approuve' OR statut = 'termine') " +
                     "ORDER BY date_creation DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("nutritionniste_id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Alias for getMyNutritionistId.
     */
    public int getAssignedNutritionistId(int patientId) {
        return getMyNutritionistId(patientId);
    }
    
    /**
     * Get all patients assigned to a nutritionist (have had appointments).
     */
    public List<com.nutrit.models.User> getPatientsByNutritionist(int nutritionistId) {
        List<com.nutrit.models.User> list = new ArrayList<>();
        String sql = "SELECT DISTINCT u.* FROM utilisateurs u " +
                     "JOIN rendez_vous r ON u.id = r.patient_id " +
                     "WHERE r.nutritionniste_id = ? AND (r.statut = 'approuve' OR r.statut = 'termine')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                com.nutrit.models.User user = new com.nutrit.models.User();
                user.setId(rs.getInt("id"));
                user.setRole(convertRoleToEnglish(rs.getString("role")));
                user.setFullName(rs.getString("nom_complet"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("telephone"));
                user.setAddress(rs.getString("adresse"));
                user.setStatus(convertStatusToEnglish(rs.getString("statut")));
                user.setCreatedAt(rs.getTimestamp("date_creation"));
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // === Conversion Helpers ===
    
    private String convertStatusToEnglish(String frenchStatus) {
        if (frenchStatus == null) return "pending";
        switch (frenchStatus.toLowerCase()) {
            case "en_attente": return "pending";
            case "approuve": return "accepted";
            case "termine": return "completed";
            case "annule": return "rejected";
            default: return frenchStatus;
        }
    }
    
    private String convertRoleToEnglish(String frenchRole) {
        if (frenchRole == null) return "patient";
        switch (frenchRole.toLowerCase()) {
            case "nutritionniste": return "nutritionist";
            case "secretaire": return "secretary";
            case "administrateur": return "admin";
            default: return "patient";
        }
    }
}
