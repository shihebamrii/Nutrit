package com.nutrit.dao;

import com.nutrit.models.PatientProfile;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.math.BigDecimal;

public class PatientProfileDAO {

    /**
     * Map available columns from utilisateurs table to PatientProfile model.
     * Note: Many fields from the full profile are not supported by the strict schema.
     */
    public PatientProfile getProfile(int patientId) {
        String sql = "SELECT * FROM utilisateurs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapProfile(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Save profile (Update existing user row)
     */
    public boolean saveProfile(PatientProfile profile) {
        // Since user must exist to have a profile, this is always an UPDATE on utilisateurs
        return updateProfile(profile);
    }

    private boolean updateProfile(PatientProfile profile) {
        // Update all health profile columns in 'utilisateurs'
        String sql = "UPDATE utilisateurs SET " +
                     "date_naissance = ?, " +
                     "genre = ?, " +
                     "taille_cm = ?, " +
                     "poids_actuel = ?, " +
                     "poids_cible = ?, " +
                     "niveau_activite = ?, " +
                     "antecedents_medicaux = ?, " +
                     "allergies = ?, " +
                     "preferences_alimentaires = ?, " +
                     "occupation = ?, " +
                     "heures_sommeil = ?, " +
                     "niveau_stress = ?, " +
                     "statut_fumeur = ?, " +
                     "consommation_alcool = ?, " +
                     "frequence_exercice = ?, " +
                     "type_exercice = ?, " +
                     "medicaments_actuels = ?, " +
                     "chirurgies_precedentes = ?, " +
                     "antecedents_familiaux = ?, " +
                     "problemes_digestifs = ?, " +
                     "restrictions_alimentaires = ?, " +
                     "aliments_a_eviter = ?, " +
                     "eau_quotidienne = ?, " +
                     "repas_par_jour = ?, " +
                     "habitudes_grignotage = ?, " +
                     "historique_regimes = ?, " +
                     "objectif_principal = ?, " +
                     "objectifs_secondaires = ?, " +
                     "niveau_motivation = ?, " +
                     "notes_supplementaires = ? " +
                     "WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;
            stmt.setDate(i++, profile.getDateOfBirth());
            stmt.setString(i++, profile.getGender());
            stmt.setBigDecimal(i++, profile.getHeight());
            stmt.setBigDecimal(i++, profile.getCurrentWeight());
            stmt.setBigDecimal(i++, profile.getTargetWeight());
            stmt.setString(i++, profile.getActivityLevel());
            stmt.setString(i++, profile.getMedicalConditions());
            stmt.setString(i++, profile.getAllergies());
            stmt.setString(i++, profile.getFoodPreferences());
            stmt.setString(i++, profile.getOccupation());
            stmt.setInt(i++, profile.getSleepHours());
            stmt.setString(i++, profile.getStressLevel());
            stmt.setString(i++, profile.getSmokingStatus());
            stmt.setString(i++, profile.getAlcoholConsumption());
            stmt.setString(i++, profile.getExerciseFrequency());
            stmt.setString(i++, profile.getExerciseType());
            stmt.setString(i++, profile.getCurrentMedications());
            stmt.setString(i++, profile.getPreviousSurgeries());
            stmt.setString(i++, profile.getFamilyMedicalHistory());
            stmt.setString(i++, profile.getDigestiveIssues());
            stmt.setString(i++, profile.getDietaryRestrictions());
            stmt.setString(i++, profile.getFoodsToAvoid());
            stmt.setInt(i++, profile.getDailyWaterIntake());
            stmt.setInt(i++, profile.getMealsPerDay());
            stmt.setString(i++, profile.getSnackingHabits());
            stmt.setString(i++, profile.getPreviousDietHistory());
            stmt.setString(i++, profile.getPrimaryGoal());
            stmt.setString(i++, profile.getSecondaryGoals());
            stmt.setString(i++, profile.getMotivationLevel());
            stmt.setString(i++, profile.getAdditionalNotes());
            stmt.setInt(i++, profile.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private PatientProfile mapProfile(ResultSet rs) throws SQLException {
        PatientProfile profile = new PatientProfile();
        profile.setId(rs.getInt("id"));
        profile.setDateOfBirth(rs.getDate("date_naissance"));
        profile.setGender(rs.getString("genre"));
        profile.setHeight(rs.getBigDecimal("taille_cm"));
        profile.setCurrentWeight(rs.getBigDecimal("poids_actuel"));
        profile.setTargetWeight(rs.getBigDecimal("poids_cible"));
        profile.setActivityLevel(rs.getString("niveau_activite"));
        profile.setOccupation(rs.getString("occupation"));
        profile.setSleepHours(rs.getInt("heures_sommeil"));
        profile.setStressLevel(rs.getString("niveau_stress"));
        profile.setSmokingStatus(rs.getString("statut_fumeur"));
        profile.setAlcoholConsumption(rs.getString("consommation_alcool"));
        profile.setExerciseFrequency(rs.getString("frequence_exercice"));
        profile.setExerciseType(rs.getString("type_exercice"));
        profile.setMedicalConditions(rs.getString("antecedents_medicaux"));
        profile.setAllergies(rs.getString("allergies"));
        profile.setCurrentMedications(rs.getString("medicaments_actuels"));
        profile.setPreviousSurgeries(rs.getString("chirurgies_precedentes"));
        profile.setFamilyMedicalHistory(rs.getString("antecedents_familiaux"));
        profile.setDigestiveIssues(rs.getString("problemes_digestifs"));
        profile.setDietaryRestrictions(rs.getString("restrictions_alimentaires"));
        profile.setFoodPreferences(rs.getString("preferences_alimentaires"));
        profile.setFoodsToAvoid(rs.getString("aliments_a_eviter"));
        profile.setDailyWaterIntake(rs.getInt("eau_quotidienne"));
        profile.setMealsPerDay(rs.getInt("repas_par_jour"));
        profile.setSnackingHabits(rs.getString("habitudes_grignotage"));
        profile.setPreviousDietHistory(rs.getString("historique_regimes"));
        profile.setPrimaryGoal(rs.getString("objectif_principal"));
        profile.setSecondaryGoals(rs.getString("objectifs_secondaires"));
        profile.setMotivationLevel(rs.getString("niveau_motivation"));
        profile.setAdditionalNotes(rs.getString("notes_supplementaires"));
        
        return profile;
    }

    public boolean isProfileComplete(int patientId) {
        PatientProfile profile = getProfile(patientId);
        if (profile == null) return false;
        // Check only available essential fields
        return profile.getDateOfBirth() != null &&
               profile.getGender() != null &&
               profile.getHeight() != null &&
               profile.getCurrentWeight() != null &&
               profile.getPrimaryGoal() != null;
    }
}
