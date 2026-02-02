package com.nutrit.dao;

import com.nutrit.models.*;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object for patient meal plans (French schema).
 * Uses plans_alimentaires and details_plan_repas tables.
 */
public class PatientMealPlanDAO {
    
    private FoodItemDAO foodItemDAO = new FoodItemDAO();
    
    // French meal time constants matching the database
    private static final String MEAL_MATIN = "matin";
    private static final String MEAL_MIDI = "midi";
    private static final String MEAL_SOIR = "soir";
    private static final String MEAL_COLLATION = "collation";

    /**
     * Create a new meal plan with all items.
     * @return the created plan ID, or -1 on failure
     */
    public int createMealPlan(PatientMealPlan plan) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Insert main meal plan record
            String planSql = "INSERT INTO plans_alimentaires (patient_id, nutritionniste_id, date_debut, date_fin, notes_globales, est_actif, repas_activés, calories_matin, calories_midi, calories_soir, calories_collation, balance_cible) " +
                            "VALUES (?, ?, ?, ?, ?, TRUE, ?, ?, ?, ?, ?, ?)";
            PreparedStatement planStmt = conn.prepareStatement(planSql, Statement.RETURN_GENERATED_KEYS);
            planStmt.setInt(1, plan.getPatientId());
            planStmt.setInt(2, plan.getNutritionistId());
            planStmt.setDate(3, plan.getStartDate());
            planStmt.setDate(4, plan.getEndDate());
            planStmt.setString(5, plan.getNotes());
            
            // Build enabled meals string
            String enabledMeals = buildEnabledMealsString(plan);
            planStmt.setString(6, enabledMeals);
            
            // Set calorie targets
            planStmt.setInt(7, plan.getCaloriesMatin());
            planStmt.setInt(8, plan.getCaloriesMidi());
            planStmt.setInt(9, plan.getCaloriesSoir());
            planStmt.setInt(10, plan.getCaloriesCollation());
            
            // Set target weight (scale/balance)
            if (plan.getTargetWeight() > 0) {
                planStmt.setDouble(11, plan.getTargetWeight());
            } else {
                planStmt.setNull(11, java.sql.Types.DECIMAL);
            }
            
            int rows = planStmt.executeUpdate();
            if (rows == 0) {
                conn.rollback();
                return -1;
            }
            
            ResultSet generatedKeys = planStmt.getGeneratedKeys();
            if (!generatedKeys.next()) {
                conn.rollback();
                return -1;
            }
            int planId = generatedKeys.getInt(1);
            plan.setId(planId);
            
            // 2. Insert meal items
            String itemSql = "INSERT INTO details_plan_repas (plan_id, moment_repas, aliment_id_1, quantite_g_1, aliment_id_2, quantite_g_2, aliment_id_3, quantite_g_3, aliment_id_4, quantite_g_4, notes) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement itemStmt = conn.prepareStatement(itemSql);
            
            for (Map.Entry<String, List<MealPlanItem>> entry : plan.getMealItems().entrySet()) {
                String mealTime = convertMealTimeToFrench(entry.getKey());
                for (MealPlanItem item : entry.getValue()) {
                    itemStmt.setInt(1, planId);
                    itemStmt.setString(2, mealTime);
                    
                    // Option 1
                    if (item.getFoodItemId1() > 0) stmtSetInt(itemStmt, 3, item.getFoodItemId1()); else itemStmt.setNull(3, Types.INTEGER);
                    itemStmt.setDouble(4, item.getQuantity1());
                    
                    // Option 2
                    if (item.getFoodItemId2() > 0) stmtSetInt(itemStmt, 5, item.getFoodItemId2()); else itemStmt.setNull(5, Types.INTEGER);
                    itemStmt.setDouble(6, item.getQuantity2());
                    
                    // Option 3
                    if (item.getFoodItemId3() > 0) stmtSetInt(itemStmt, 7, item.getFoodItemId3()); else itemStmt.setNull(7, Types.INTEGER);
                    itemStmt.setDouble(8, item.getQuantity3());
                    
                    // Option 4
                    if (item.getFoodItemId4() > 0) stmtSetInt(itemStmt, 9, item.getFoodItemId4()); else itemStmt.setNull(9, Types.INTEGER);
                    itemStmt.setDouble(10, item.getQuantity4());
                    
                    itemStmt.setString(11, item.getNotes());
                    itemStmt.addBatch();
                }
            }
            itemStmt.executeBatch();
            
            conn.commit();
            return planId;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return -1;
        } finally {
            if (conn != null) {
                try { 
                    conn.setAutoCommit(true);
                    conn.close(); 
                } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    /**
     * Get active meal plan for a patient.
     */
    public PatientMealPlan getActiveMealPlanByPatient(int patientId) {
        String sql = "SELECT pa.*, " +
                    "p.nom_complet as patient_name, " +
                    "n.nom_complet as nutritionist_name " +
                    "FROM plans_alimentaires pa " +
                    "JOIN utilisateurs p ON pa.patient_id = p.id " +
                    "JOIN utilisateurs n ON pa.nutritionniste_id = n.id " +
                    "WHERE pa.patient_id = ? AND pa.est_actif = TRUE " +
                    "ORDER BY pa.id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                PatientMealPlan plan = mapMealPlan(rs);
                loadMealPlanDetails(plan);
                return plan;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get meal plan by ID.
     */
    public PatientMealPlan getMealPlanById(int planId) {
        String sql = "SELECT pa.*, " +
                    "p.nom_complet as patient_name, " +
                    "n.nom_complet as nutritionist_name " +
                    "FROM plans_alimentaires pa " +
                    "JOIN utilisateurs p ON pa.patient_id = p.id " +
                    "JOIN utilisateurs n ON pa.nutritionniste_id = n.id " +
                    "WHERE pa.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, planId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                PatientMealPlan plan = mapMealPlan(rs);
                loadMealPlanDetails(plan);
                return plan;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all meal plans by nutritionist.
     */
    public List<PatientMealPlan> getMealPlansByNutritionist(int nutritionistId) {
        List<PatientMealPlan> plans = new ArrayList<>();
        String sql = "SELECT pa.*, " +
                    "p.nom_complet as patient_name, " +
                    "n.nom_complet as nutritionist_name " +
                    "FROM plans_alimentaires pa " +
                    "JOIN utilisateurs p ON pa.patient_id = p.id " +
                    "JOIN utilisateurs n ON pa.nutritionniste_id = n.id " +
                    "WHERE pa.nutritionniste_id = ? " +
                    "ORDER BY pa.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                PatientMealPlan plan = mapMealPlan(rs);
                loadEnabledMealTimes(plan);
                plans.add(plan);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plans;
    }

    /**
     * Deactivate all existing meal plans for a patient.
     */
    public boolean deactivatePatientPlans(int patientId) {
        String sql = "UPDATE plans_alimentaires SET est_actif = FALSE WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a meal plan.
     */
    public boolean deleteMealPlan(int planId) {
        String sql = "DELETE FROM plans_alimentaires WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, planId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Count meal plans by nutritionist.
     */
    public int countMealPlansByNutritionist(int nutritionistId) {
        String sql = "SELECT COUNT(*) FROM plans_alimentaires WHERE nutritionniste_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
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
     * Load enabled meal times for a plan (from repas_activés field).
     */
    private void loadEnabledMealTimes(PatientMealPlan plan) {
        String sql = "SELECT repas_activés FROM plans_alimentaires WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, plan.getId());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String enabledMeals = rs.getString("repas_activés");
                if (enabledMeals != null) {
                    for (String meal : enabledMeals.split(",")) {
                        String englishMeal = convertMealTimeToEnglish(meal.trim());
                        plan.enableMealTime(englishMeal);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Load full meal plan details (enabled times + food items).
     */
    private void loadMealPlanDetails(PatientMealPlan plan) {
        loadEnabledMealTimes(plan);
        
        // Load meal items with up to 4 alternatives (including image paths)
        String sql = "SELECT dpr.*, " +
                    "a1.nom_fr as nom_1, a1.calories_100g as cal_1, a1.image_path as img_1, " +
                    "a2.nom_fr as nom_2, a2.calories_100g as cal_2, a2.image_path as img_2, " +
                    "a3.nom_fr as nom_3, a3.calories_100g as cal_3, a3.image_path as img_3, " +
                    "a4.nom_fr as nom_4, a4.calories_100g as cal_4, a4.image_path as img_4 " +
                    "FROM details_plan_repas dpr " +
                    "LEFT JOIN aliments a1 ON dpr.aliment_id_1 = a1.id " +
                    "LEFT JOIN aliments a2 ON dpr.aliment_id_2 = a2.id " +
                    "LEFT JOIN aliments a3 ON dpr.aliment_id_3 = a3.id " +
                    "LEFT JOIN aliments a4 ON dpr.aliment_id_4 = a4.id " +
                    "WHERE dpr.plan_id = ? " +
                    "ORDER BY dpr.moment_repas, dpr.id";
                    
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, plan.getId());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                MealPlanItem item = new MealPlanItem();
                item.setId(rs.getInt("id"));
                item.setMealPlanId(plan.getId());
                item.setMealTime(convertMealTimeToEnglish(rs.getString("moment_repas")));
                item.setDayOfWeek(rs.getInt("jour_semaine"));
                
                // Option 1
                item.setFoodItemId1(rs.getInt("aliment_id_1"));
                item.setQuantity1(rs.getDouble("quantite_g_1"));
                if (item.getFoodItemId1() > 0) {
                    FoodItem f1 = new FoodItem();
                    f1.setId(item.getFoodItemId1());
                    f1.setName(rs.getString("nom_1"));
                    f1.setCaloriesPer100g(rs.getInt("cal_1"));
                    f1.setImagePath(rs.getString("img_1"));
                    item.setFoodItem1(f1);
                }
                
                // Option 2
                item.setFoodItemId2(rs.getInt("aliment_id_2"));
                item.setQuantity2(rs.getDouble("quantite_g_2"));
                if (item.getFoodItemId2() > 0) {
                    FoodItem f2 = new FoodItem();
                    f2.setId(item.getFoodItemId2());
                    f2.setName(rs.getString("nom_2"));
                    f2.setCaloriesPer100g(rs.getInt("cal_2"));
                    f2.setImagePath(rs.getString("img_2"));
                    item.setFoodItem2(f2);
                }
                
                // Option 3
                item.setFoodItemId3(rs.getInt("aliment_id_3"));
                item.setQuantity3(rs.getDouble("quantite_g_3"));
                if (item.getFoodItemId3() > 0) {
                    FoodItem f3 = new FoodItem();
                    f3.setId(item.getFoodItemId3());
                    f3.setName(rs.getString("nom_3"));
                    f3.setCaloriesPer100g(rs.getInt("cal_3"));
                    f3.setImagePath(rs.getString("img_3"));
                    item.setFoodItem3(f3);
                }
                
                // Option 4
                item.setFoodItemId4(rs.getInt("aliment_id_4"));
                item.setQuantity4(rs.getDouble("quantite_g_4"));
                if (item.getFoodItemId4() > 0) {
                    FoodItem f4 = new FoodItem();
                    f4.setId(item.getFoodItemId4());
                    f4.setName(rs.getString("nom_4"));
                    f4.setCaloriesPer100g(rs.getInt("cal_4"));
                    f4.setImagePath(rs.getString("img_4"));
                    item.setFoodItem4(f4);
                }
                
                item.setNotes(rs.getString("notes"));
                plan.addItem(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Map ResultSet to PatientMealPlan object.
     */
    private PatientMealPlan mapMealPlan(ResultSet rs) throws SQLException {
        PatientMealPlan plan = new PatientMealPlan();
        plan.setId(rs.getInt("id"));
        plan.setPatientId(rs.getInt("patient_id"));
        plan.setNutritionistId(rs.getInt("nutritionniste_id"));
        plan.setPatientName(rs.getString("patient_name"));
        plan.setNutritionistName(rs.getString("nutritionist_name"));
        plan.setStartDate(rs.getDate("date_debut"));
        plan.setEndDate(rs.getDate("date_fin"));
        plan.setNotes(rs.getString("notes_globales"));
        plan.setActive(rs.getBoolean("est_actif"));
        
        // Map calorie targets
        plan.setCaloriesMatin(rs.getInt("calories_matin"));
        plan.setCaloriesMidi(rs.getInt("calories_midi"));
        plan.setCaloriesSoir(rs.getInt("calories_soir"));
        plan.setCaloriesCollation(rs.getInt("calories_collation"));
        
        // Map target weight (scale/balance)
        plan.setTargetWeight(rs.getDouble("balance_cible"));
        
        return plan;
    }
    
    // Helper for setting int or null
    private void stmtSetInt(PreparedStatement stmt, int index, int value) throws SQLException {
        stmt.setInt(index, value);
    }
    
    /**
     * Build enabled meals string for database.
     */
    private String buildEnabledMealsString(PatientMealPlan plan) {
        List<String> enabled = new ArrayList<>();
        for (String mealTime : PatientMealPlan.ALL_MEAL_TIMES) {
            if (plan.isMealTimeEnabled(mealTime)) {
                enabled.add(convertMealTimeToFrench(mealTime));
            }
        }
        return String.join(",", enabled);
    }
    
    /**
     * Convert English meal time to French.
     */
    private String convertMealTimeToFrench(String englishTime) {
        if (englishTime == null) return MEAL_MATIN;
        switch (englishTime.toLowerCase()) {
            case "morning":
            case "breakfast": return MEAL_MATIN;
            case "noon":
            case "lunch": return MEAL_MIDI;
            case "night":
            case "dinner": return MEAL_SOIR;
            case "snacks":
            case "snack": return MEAL_COLLATION;
            default: return englishTime.toLowerCase(); // Already French
        }
    }
    
    /**
     * Convert French meal time to English.
     */
    private String convertMealTimeToEnglish(String frenchTime) {
        if (frenchTime == null) return "morning";
        switch (frenchTime.toLowerCase()) {
            case "matin": return "morning";
            case "midi": return "noon";
            case "soir": return "night";
            case "collation": return "snacks";
            default: return frenchTime;
        }
    }
}
