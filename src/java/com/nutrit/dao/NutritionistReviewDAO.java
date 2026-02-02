package com.nutrit.dao;

import com.nutrit.models.NutritionistReview;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for nutritionist reviews (French schema).
 * Uses the 'interactions' table with type_interaction = 'avis'.
 */
public class NutritionistReviewDAO {

    private static final String TYPE_REVIEW = "avis";

    /**
     * Add a new review for a nutritionist.
     */
    public boolean addReview(NutritionistReview review) {
        String sql = "INSERT INTO interactions (type_interaction, expediteur_id, destinataire_id, contenu, note_etoiles) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, TYPE_REVIEW);
            stmt.setInt(2, review.getPatientId());
            stmt.setInt(3, review.getNutritionistId());
            stmt.setString(4, review.getComment());
            stmt.setInt(5, review.getRating());
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    review.setId(rs.getInt(1));
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
     * Get all reviews for a nutritionist.
     */
    public List<NutritionistReview> getReviewsByNutritionist(int nutritionistId) {
        List<NutritionistReview> reviews = new ArrayList<>();
        String sql = "SELECT i.*, u.nom_complet as patient_name " +
                     "FROM interactions i " +
                     "JOIN utilisateurs u ON i.expediteur_id = u.id " +
                     "WHERE i.type_interaction = ? AND i.destinataire_id = ? AND i.note_etoiles IS NOT NULL " +
                     "ORDER BY i.date_creation DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_REVIEW);
            stmt.setInt(2, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                NutritionistReview review = new NutritionistReview();
                review.setId(rs.getInt("id"));
                review.setNutritionistId(rs.getInt("destinataire_id"));
                review.setPatientId(rs.getInt("expediteur_id"));
                review.setRating(rs.getInt("note_etoiles"));
                review.setComment(rs.getString("contenu"));
                review.setCreatedAt(rs.getTimestamp("date_creation"));
                review.setPatientName(rs.getString("patient_name"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    /**
     * Get average rating for a nutritionist.
     */
    public double getAverageRating(int nutritionistId) {
        String sql = "SELECT AVG(note_etoiles) as avg_rating FROM interactions " +
                     "WHERE type_interaction = ? AND destinataire_id = ? AND note_etoiles IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_REVIEW);
            stmt.setInt(2, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Get review count for a nutritionist.
     */
    public int getReviewCount(int nutritionistId) {
        String sql = "SELECT COUNT(*) as count FROM interactions " +
                     "WHERE type_interaction = ? AND destinataire_id = ? AND note_etoiles IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_REVIEW);
            stmt.setInt(2, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if patient has already reviewed a nutritionist.
     */
    public boolean hasReviewed(int patientId, int nutritionistId) {
        String sql = "SELECT COUNT(*) as count FROM interactions " +
                     "WHERE type_interaction = ? AND expediteur_id = ? AND destinataire_id = ? AND note_etoiles IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_REVIEW);
            stmt.setInt(2, patientId);
            stmt.setInt(3, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    /**
     * Get recent reviews for landing page.
     */
    public List<NutritionistReview> getRecentReviews(int limit) {
        List<NutritionistReview> reviews = new ArrayList<>();
        String sql = "SELECT i.*, u.nom_complet as patient_name, u.photo_profil as patient_profile_picture " +
                     "FROM interactions i " +
                     "JOIN utilisateurs u ON i.expediteur_id = u.id " +
                     "WHERE i.type_interaction = ? AND i.note_etoiles IS NOT NULL " +
                     "ORDER BY i.date_creation DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_REVIEW);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                NutritionistReview review = new NutritionistReview();
                review.setId(rs.getInt("id"));
                review.setNutritionistId(rs.getInt("destinataire_id"));
                review.setPatientId(rs.getInt("expediteur_id"));
                review.setRating(rs.getInt("note_etoiles"));
                review.setComment(rs.getString("contenu"));
                review.setCreatedAt(rs.getTimestamp("date_creation"));
                review.setPatientName(rs.getString("patient_name"));
                review.setPatientProfilePicture(rs.getString("patient_profile_picture"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
}
