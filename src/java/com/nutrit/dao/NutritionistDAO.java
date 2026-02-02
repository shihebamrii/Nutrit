package com.nutrit.dao;

import com.nutrit.models.NutritionistProfile;
import com.nutrit.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Data Access Object for nutritionist profiles (French schema).
 * Uses the 'utilisateurs' table where role = 'nutritionniste'.
 */
public class NutritionistDAO {

    /**
     * Get nutritionist profile by user ID.
     * In the French schema, profile data is embedded in the utilisateurs table.
     */
    public NutritionistProfile getProfileByUserId(int userId) {
        String sql = "SELECT * FROM utilisateurs WHERE id = ? AND role = 'nutritionniste'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                NutritionistProfile profile = new NutritionistProfile();
                profile.setId(rs.getInt("id"));
                profile.setSpecialization(rs.getString("specialisation"));
                profile.setYearsExperience(rs.getInt("annees_experience"));
                profile.setLicenseNumber(rs.getString("numero_licence"));
                profile.setClinicAddress(rs.getString("adresse_cabinet"));
                // Working hours not in new schema
                profile.setWorkingHours(null);
                profile.setPrice(rs.getBigDecimal("tarif_consultation"));
                profile.setBio(rs.getString("biographie"));
                return profile;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
