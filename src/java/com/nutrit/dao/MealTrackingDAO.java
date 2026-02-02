package com.nutrit.dao;

import com.nutrit.models.MealTracking;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for meal tracking operations (French schema).
 * Uses the 'suivi_quotidien' table.
 */
public class MealTrackingDAO {

    /**
     * Save or update meal tracking entry
     */
    /**
     * Save or update meal tracking entry.
     * To prevent duplicates (since unique constraint might be missing), 
     * we delete any existing entry for this slot before inserting.
     */
    public boolean saveTracking(MealTracking tracking) throws SQLException {
        // Delete any existing entry for this specific slot (plan + date + meal)
        deleteTracking(tracking.getMealPlanId(), tracking.getMealType(), tracking.getTrackingDate());
        return createTracking(tracking);
    }
    
    private void deleteTracking(int mealPlanId, String mealType, Date date) throws SQLException {
        String sql = "DELETE FROM suivi_quotidien WHERE plan_id = ? AND moment_repas = ? AND date_suivi = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, mealPlanId);
            stmt.setString(2, mapMealTypeToFrench(mealType));
            stmt.setDate(3, date);
            stmt.executeUpdate();
        }
    }

    private boolean createTracking(MealTracking tracking) throws SQLException {
        String sql = "INSERT INTO suivi_quotidien (patient_id, plan_id, date_suivi, moment_repas, est_complete, repas_alternatif, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tracking.getPatientId());
            stmt.setInt(2, tracking.getMealPlanId());
            stmt.setDate(3, tracking.getTrackingDate());
            
            // Map meal type to French enum
            stmt.setString(4, mapMealTypeToFrench(tracking.getMealType()));
            stmt.setBoolean(5, tracking.isCompleted());
            stmt.setString(6, tracking.getAlternativeMeal());
            stmt.setString(7, tracking.getNotes());
            return stmt.executeUpdate() > 0;
        }
    }

    private boolean updateTracking(MealTracking tracking) throws SQLException {
        String sql = "UPDATE suivi_quotidien SET est_complete = ?, repas_alternatif = ?, notes = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, tracking.isCompleted());
            stmt.setString(2, tracking.getAlternativeMeal());
            stmt.setString(3, tracking.getNotes());
            stmt.setInt(4, tracking.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get single tracking entry
     */
    public MealTracking getTracking(int mealPlanId, String mealType, Date date) {
        String sql = "SELECT * FROM suivi_quotidien WHERE plan_id = ? AND moment_repas = ? AND date_suivi = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, mealPlanId);
            stmt.setString(2, mapMealTypeToFrench(mealType));
            stmt.setDate(3, date);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapTracking(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all tracking entries for a meal plan on a date
     */
    public Map<String, MealTracking> getTrackingByMealPlan(int mealPlanId, Date date) {
        Map<String, MealTracking> trackingMap = new HashMap<>();
        String sql = "SELECT * FROM suivi_quotidien WHERE plan_id = ? AND date_suivi = ? AND moment_repas IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, mealPlanId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                MealTracking tracking = mapTracking(rs);
                trackingMap.put(tracking.getMealType(), tracking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trackingMap;
    }

    /**
     * Get all tracking entries for a patient on a specific date
     */
    public List<MealTracking> getTrackingByPatientDate(int patientId, Date date) {
        List<MealTracking> trackings = new ArrayList<>();
        String sql = "SELECT * FROM suivi_quotidien WHERE patient_id = ? AND date_suivi = ? AND moment_repas IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                trackings.add(mapTracking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trackings;
    }

    /**
     * Get all tracking entries for a patient (for nutritionist review)
     */
    public List<MealTracking> getTrackingByPatient(int patientId) {
        List<MealTracking> trackings = new ArrayList<>();
        String sql = "SELECT * FROM suivi_quotidien WHERE patient_id = ? AND moment_repas IS NOT NULL " +
                     "ORDER BY date_suivi DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                trackings.add(mapTracking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trackings;
    }

    /**
     * Get tracking summary stats
     */
    public Map<String, Object> getPatientComplianceStats(int patientId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) as total_meals, " +
                     "SUM(CASE WHEN est_complete = 1 THEN 1 ELSE 0 END) as completed_meals, " +
                     "SUM(CASE WHEN est_complete = 0 THEN 1 ELSE 0 END) as missed_meals " +
                     "FROM suivi_quotidien WHERE patient_id = ? AND moment_repas IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int total = rs.getInt("total_meals");
                int completed = rs.getInt("completed_meals");
                int missed = rs.getInt("missed_meals");
                double compliance = total > 0 ? (completed * 100.0 / total) : 0;
                
                stats.put("totalMeals", total);
                stats.put("completedMeals", completed);
                stats.put("missedMeals", missed);
                stats.put("complianceRate", Math.round(compliance));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Get recent deviations
     */
    public List<MealTracking> getRecentDeviations(int patientId, int limit) {
        List<MealTracking> deviations = new ArrayList<>();
        String sql = "SELECT * FROM suivi_quotidien " +
                     "WHERE patient_id = ? AND est_complete = 0 AND moment_repas IS NOT NULL " +
                     "ORDER BY date_suivi DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                deviations.add(mapTracking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return deviations;
    }

    private String mapMealTypeToFrench(String englishType) {
        if (englishType == null) return "collation";
        switch (englishType.toLowerCase()) {
            case "breakfast": 
            case "morning":
                return "matin";
            case "lunch": 
            case "noon":
                return "midi";
            case "dinner": 
            case "night":
                return "soir";
            case "snacks": 
            case "collation":
                return "collation";
            default: return "collation";
        }
    }

    private String mapMealTypeToEnglish(String frenchType) {
        if (frenchType == null) return "snacks";
        switch (frenchType.toLowerCase()) {
            case "matin": return "morning";
            case "midi": return "noon";
            case "soir": return "night";
            case "collation": return "snacks";
            default: return "snacks";
        }
    }

    private MealTracking mapTracking(ResultSet rs) throws SQLException {
        MealTracking tracking = new MealTracking();
        tracking.setId(rs.getInt("id"));
        tracking.setMealPlanId(rs.getInt("plan_id"));
        tracking.setPatientId(rs.getInt("patient_id"));
        tracking.setTrackingDate(rs.getDate("date_suivi"));
        tracking.setMealType(mapMealTypeToEnglish(rs.getString("moment_repas")));
        tracking.setCompleted(rs.getBoolean("est_complete"));
        tracking.setAlternativeMeal(rs.getString("repas_alternatif"));
        tracking.setNotes(rs.getString("notes"));
        // tracking.setCreatedAt(rs.getTimestamp("date_creation")); // Column does not exist
        return tracking;
    }
}
