package com.nutrit.dao;

import com.nutrit.models.Appointment;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for rendez_vous table (French schema).
 * Handles all appointment operations including payment tracking.
 */
public class AppointmentDAO {
    
    // French status constants
    public static final String STATUS_PENDING = "en_attente";
    public static final String STATUS_APPROVED = "approuve";
    public static final String STATUS_COMPLETED = "termine";
    public static final String STATUS_CANCELLED = "annule";
    public static final String STATUS_REJECTED = "rejete";
    
    // French payment status constants
    public static final String PAYMENT_PENDING = "en_attente";
    public static final String PAYMENT_PAID = "paye";
    public static final String PAYMENT_FAILED = "echoue";
    
    // French payment method constants
    public static final String PAYMENT_ONLINE = "en_ligne";
    public static final String PAYMENT_IN_OFFICE = "au_cabinet";

    /**
     * Get appointments by user role.
     */
    public List<Appointment> getAppointmentsByRole(String role, int userId) {
        List<Appointment> list = new ArrayList<>();
        
        String baseQuery = "SELECT r.*, " +
                           "(SELECT nom_complet FROM utilisateurs WHERE id = r.patient_id) as patient_name, " +
                           "(SELECT photo_profil FROM utilisateurs WHERE id = r.patient_id) as patient_profile_picture, " +
                           "(SELECT nom_complet FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_name, " +
                           "(SELECT photo_profil FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_profile_picture " +
                           "FROM rendez_vous r ";

        String sql = "";
        if ("patient".equals(role)) {
            sql = baseQuery + "WHERE r.patient_id = ? AND r.date_heure_prevue >= NOW() ORDER BY r.date_heure_prevue ASC";
        } else if ("nutritionist".equals(role)) {
            sql = baseQuery + "WHERE r.nutritionniste_id = ? ORDER BY r.date_heure_prevue ASC";
        } else if ("secretary".equals(role)) {
            sql = baseQuery + "WHERE r.secretaire_id = ? ORDER BY r.date_heure_prevue ASC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get today's appointments for a nutritionist.
     */
    public List<Appointment> getTodayAppointments(int nutritionistId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT r.*, u.nom_complet as patient_name, u.photo_profil as patient_profile_picture " +
                     "FROM rendez_vous r " +
                     "JOIN utilisateurs u ON r.patient_id = u.id " +
                     "WHERE r.nutritionniste_id = ? AND DATE(r.date_heure_prevue) = CURRENT_DATE " +
                     "ORDER BY r.date_heure_prevue ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Appointment appt = mapAppointment(rs);
                appt.setPatientName(rs.getString("patient_name"));
                appt.setPatientProfilePicture(rs.getString("patient_profile_picture"));
                list.add(appt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Create a new appointment.
     */
    public boolean createAppointment(Appointment appt) {
        String sql = "INSERT INTO rendez_vous (patient_id, nutritionniste_id, secretaire_id, date_heure_prevue, statut, " +
                     "notes_patient, methode_paiement, statut_paiement, montant_total) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, appt.getPatientId());
            stmt.setInt(2, appt.getNutritionistId());
            
            if (appt.getSecretaryId() > 0) {
                stmt.setInt(3, appt.getSecretaryId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            
            stmt.setTimestamp(4, appt.getScheduledTime());
            
            // Convert status to French
            String frenchStatus = convertStatusToFrench(appt.getStatus());
            stmt.setString(5, frenchStatus);
            
            stmt.setString(6, appt.getNotes());
            
            // Convert payment method to French
            String frenchPaymentMethod = convertPaymentMethodToFrench(appt.getPaymentMethod());
            stmt.setString(7, frenchPaymentMethod);
            
            // Payment status
            stmt.setString(8, PAYMENT_PENDING);
            
            if (appt.getPaymentAmount() != null) {
                stmt.setBigDecimal(9, appt.getPaymentAmount());
            } else {
                stmt.setNull(9, Types.DECIMAL);
            }
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    appt.setId(rs.getInt(1));
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
     * Get all appointments for a nutritionist.
     */
    public List<Appointment> getAllAppointmentsForNutritionist(int nutritionistId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "(SELECT nom_complet FROM utilisateurs WHERE id = r.patient_id) as patient_name, " +
                     "(SELECT photo_profil FROM utilisateurs WHERE id = r.patient_id) as patient_profile_picture, " +
                     "(SELECT nom_complet FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_name, " +
                     "(SELECT photo_profil FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_profile_picture " +
                     "FROM rendez_vous r " +
                     "WHERE r.nutritionniste_id = ? " +
                     "ORDER BY r.date_heure_prevue DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get next appointment for a patient.
     */
    public Appointment getNextAppointmentForPatient(int patientId) {
        String sql = "SELECT r.*, " +
                     "(SELECT nom_complet FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_name, " +
                     "(SELECT photo_profil FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_profile_picture " +
                     "FROM rendez_vous r " +
                     "WHERE r.patient_id = ? AND r.date_heure_prevue >= NOW() AND r.statut != ? " +
                     "ORDER BY r.date_heure_prevue ASC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setString(2, STATUS_CANCELLED);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapAppointment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get appointment by ID.
     */
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT r.*, " +
                     "(SELECT nom_complet FROM utilisateurs WHERE id = r.patient_id) as patient_name, " +
                     "(SELECT photo_profil FROM utilisateurs WHERE id = r.patient_id) as patient_profile_picture, " +
                     "(SELECT nom_complet FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_name, " +
                     "(SELECT photo_profil FROM utilisateurs WHERE id = r.nutritionniste_id) as nutritionist_profile_picture " +
                     "FROM rendez_vous r WHERE r.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapAppointment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Update appointment time and notes.
     */
    public boolean updateAppointment(int appointmentId, Timestamp newTime, String notes) {
        String sql = "UPDATE rendez_vous SET date_heure_prevue = ?, notes_patient = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, newTime);
            stmt.setString(2, notes);
            stmt.setInt(3, appointmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cancel appointment - only allowed if more than 2 hours before scheduled time.
     * Returns: 0 = success, 1 = too late (within 2 hours), -1 = error
     */
    public int cancelAppointment(int appointmentId) {
        Appointment appt = getAppointmentById(appointmentId);
        if (appt == null) return -1;
        
        long now = System.currentTimeMillis();
        long appointmentTime = appt.getScheduledTime().getTime();
        long twoHoursInMs = 2 * 60 * 60 * 1000;
        
        if (appointmentTime - now < twoHoursInMs) {
            return 1; // Too late to cancel
        }
        
        String sql = "UPDATE rendez_vous SET statut = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, STATUS_CANCELLED);
            stmt.setInt(2, appointmentId);
            return stmt.executeUpdate() > 0 ? 0 : -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    /**
     * Check if a slot is already booked for a nutritionist.
     */
    public boolean isSlotBooked(int nutritionistId, Timestamp time) {
        String sql = "SELECT COUNT(*) FROM rendez_vous WHERE nutritionniste_id = ? " +
                     "AND date_heure_prevue = ? AND statut != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setTimestamp(2, time);
            stmt.setString(3, STATUS_CANCELLED);
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
     * Check if more than 2 hours before appointment (for cancel eligibility).
     */
    public boolean canCancel(int appointmentId) {
        Appointment appt = getAppointmentById(appointmentId);
        if (appt == null) return false;
        
        long now = System.currentTimeMillis();
        long appointmentTime = appt.getScheduledTime().getTime();
        long twoHoursInMs = 2 * 60 * 60 * 1000;
        
        return (appointmentTime - now) >= twoHoursInMs;
    }
    
    /**
     * Update payment status for an appointment.
     */
    public boolean updatePaymentStatus(int appointmentId, String status) {
        String sql = "UPDATE rendez_vous SET statut_paiement = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String frenchStatus = convertPaymentStatusToFrench(status);
            stmt.setString(1, frenchStatus);
            stmt.setInt(2, appointmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update appointment status.
     */
    public boolean updateAppointmentStatus(int appointmentId, String status) {
        String sql = "UPDATE rendez_vous SET statut = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String frenchStatus = convertStatusToFrench(status);
            stmt.setString(1, frenchStatus);
            stmt.setInt(2, appointmentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map ResultSet to Appointment object.
     */
    private Appointment mapAppointment(ResultSet rs) throws SQLException {
        Appointment appt = new Appointment();
        appt.setId(rs.getInt("id"));
        appt.setPatientId(rs.getInt("patient_id"));
        appt.setNutritionistId(rs.getInt("nutritionniste_id"));
        appt.setSecretaryId(rs.getInt("secretaire_id"));
        appt.setScheduledTime(rs.getTimestamp("date_heure_prevue"));
        
        // Convert French status to English for application compatibility
        String frenchStatus = rs.getString("statut");
        appt.setStatus(convertStatusToEnglish(frenchStatus));
        
        appt.setNotes(rs.getString("notes_patient"));
        
        // Try to get display names if they exist in the query
        try {
            appt.setPatientName(rs.getString("patient_name"));
            appt.setPatientProfilePicture(rs.getString("patient_profile_picture"));
        } catch (SQLException e) { /* Column not in query */ }
        
        try {
            appt.setNutritionistName(rs.getString("nutritionist_name"));
            appt.setNutritionistProfilePicture(rs.getString("nutritionist_profile_picture"));
        } catch (SQLException e) { /* Column not in query */ }
        
        // Payment fields
        try {
            String frenchPaymentMethod = rs.getString("methode_paiement");
            appt.setPaymentMethod(convertPaymentMethodToEnglish(frenchPaymentMethod));
        } catch (SQLException e) { /* Column not in query */ }
        
        try {
            String frenchPaymentStatus = rs.getString("statut_paiement");
            appt.setPaymentStatus(convertPaymentStatusToEnglish(frenchPaymentStatus));
        } catch (SQLException e) { /* Column not in query */ }
        
        try {
            appt.setPaymentAmount(rs.getBigDecimal("montant_total"));
        } catch (SQLException e) { /* Column not in query */ }
        
        return appt;
    }
    
    // === Status Conversion Helpers ===
    
    private String convertStatusToFrench(String englishStatus) {
        if (englishStatus == null) return STATUS_PENDING;
        switch (englishStatus.toLowerCase()) {
            case "pending":
            case "upcoming": return STATUS_PENDING;
            case "approved":
            case "confirmed": return STATUS_APPROVED;
            case "completed": return STATUS_COMPLETED;
            case "cancelled":
            case "canceled": return STATUS_CANCELLED;
            case "rejected": return STATUS_REJECTED;
            default: return STATUS_PENDING;
        }
    }
    
    private String convertStatusToEnglish(String frenchStatus) {
        if (frenchStatus == null) return "pending";
        switch (frenchStatus.toLowerCase()) {
            case "en_attente": return "pending";
            case "approuve": return "approved";
            case "termine": return "completed";
            case "annule": return "cancelled";
            case "rejete": return "rejected";
            default: return "pending";
        }
    }
    
    private String convertPaymentMethodToFrench(String englishMethod) {
        if (englishMethod == null) return null;
        switch (englishMethod.toLowerCase()) {
            case "online": return PAYMENT_ONLINE;
            case "in_office":
            case "in-office":
            case "office": return PAYMENT_IN_OFFICE;
            default: return PAYMENT_ONLINE;
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
    
    private String convertPaymentStatusToFrench(String englishStatus) {
        if (englishStatus == null) return PAYMENT_PENDING;
        switch (englishStatus.toLowerCase()) {
            case "pending": return PAYMENT_PENDING;
            case "paid": return PAYMENT_PAID;
            case "failed": return PAYMENT_FAILED;
            default: return PAYMENT_PENDING;
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
}
