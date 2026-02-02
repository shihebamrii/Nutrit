package com.nutrit.dao;

import com.nutrit.models.DailyProgress;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for suivi_quotidien table (French schema).
 * Handles daily patient progress tracking (weight/water summary).
 */
public class DailyProgressDAO {

    /**
     * Get latest progress entry for a patient.
     * Filter by moment_repas IS NULL to distinguish daily summary from meal tracking.
     */
    public DailyProgress getLatestProgress(int patientId) {
        String sql = "SELECT * FROM suivi_quotidien WHERE patient_id = ? AND moment_repas IS NULL ORDER BY date_suivi DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Save or update daily progress.
     */
    public boolean saveProgress(DailyProgress progress) {
        DailyProgress existing = getProgressByDate(progress.getPatientId(), progress.getDate());
        
        if (existing == null) {
            return createProgress(progress);
        } else {
            progress.setId(existing.getId());
            return updateProgress(progress);
        }
    }
    
    /**
     * Get progress by date.
     * Filter by moment_repas IS NULL.
     */
    public DailyProgress getProgressByDate(int patientId, Date date) {
        String sql = "SELECT * FROM suivi_quotidien WHERE patient_id = ? AND date_suivi = ? AND moment_repas IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Create new progress entry.
     * Sets moment_repas to NULL to denote a daily summary row.
     */
    private boolean createProgress(DailyProgress progress) {
        String sql = "INSERT INTO suivi_quotidien (patient_id, date_suivi, poids_enregistre, eau_consommee_verres, est_complete, moment_repas) " +
                     "VALUES (?, ?, ?, ?, ?, NULL)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, progress.getPatientId());
            stmt.setDate(2, progress.getDate());
            stmt.setDouble(3, progress.getWeight());
            stmt.setInt(4, progress.getWaterIntake());
            stmt.setBoolean(5, progress.getCaloriesConsumed() > 0); 
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    progress.setId(rs.getInt(1));
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
     * Update existing progress entry.
     */
    private boolean updateProgress(DailyProgress progress) {
        String sql = "UPDATE suivi_quotidien SET poids_enregistre = ?, eau_consommee_verres = ?, est_complete = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, progress.getWeight());
            stmt.setInt(2, progress.getWaterIntake());
            stmt.setBoolean(3, progress.getCaloriesConsumed() > 0);
            stmt.setInt(4, progress.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private MealTrackingDAO mealTrackingDAO = new MealTrackingDAO();

    /**
     * Get progress history for a patient.
     * Filter by moment_repas IS NULL.
     */
    public List<DailyProgress> getProgressHistory(int patientId, int limit) {
        List<DailyProgress> history = new ArrayList<>();
        String sql = "SELECT * FROM suivi_quotidien WHERE patient_id = ? AND moment_repas IS NULL ORDER BY date_suivi DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DailyProgress progress = mapProgress(rs);
                // Fetch meal compliance for this date
                progress.setMealTrackings(mealTrackingDAO.getTrackingByPatientDate(patientId, progress.getDate()));
                history.add(progress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return history;
    }
    
    /**
     * Map ResultSet to DailyProgress object.
     */
    private DailyProgress mapProgress(ResultSet rs) throws SQLException {
        DailyProgress progress = new DailyProgress();
        progress.setId(rs.getInt("id"));
        progress.setPatientId(rs.getInt("patient_id"));
        progress.setDate(rs.getDate("date_suivi"));
        progress.setWeight(rs.getDouble("poids_enregistre"));
        progress.setWaterIntake(rs.getInt("eau_consommee_verres"));
        progress.setCaloriesConsumed(rs.getBoolean("est_complete") ? 1 : 0);
        return progress;
    }
}
