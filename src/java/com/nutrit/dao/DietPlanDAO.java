package com.nutrit.dao;

import com.nutrit.models.DietPlan;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DietPlanDAO {

    public List<DietPlan> getDietPlansByPatientId(int patientId) {
        List<DietPlan> plans = new ArrayList<>();
        String sql = "SELECT * FROM diet_plan WHERE patient_id = ? ORDER BY day_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                plans.add(mapDietPlan(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plans;
    }

    public boolean addDietPlan(DietPlan plan) {
        String sql = "INSERT INTO diet_plan (patient_id, nutritionist_id, day_date, breakfast, lunch, dinner, snacks, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, plan.getPatientId());
            stmt.setInt(2, plan.getNutritionistId());
            stmt.setDate(3, plan.getDayDate());
            stmt.setString(4, plan.getBreakfast());
            stmt.setString(5, plan.getLunch());
            stmt.setString(6, plan.getDinner());
            stmt.setString(7, plan.getSnacks());
            stmt.setString(8, plan.getNotes());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private DietPlan mapDietPlan(ResultSet rs) throws SQLException {
        DietPlan plan = new DietPlan();
        plan.setId(rs.getInt("id"));
        plan.setPatientId(rs.getInt("patient_id"));
        plan.setNutritionistId(rs.getInt("nutritionist_id"));
        plan.setDayDate(rs.getDate("day_date"));
        plan.setBreakfast(rs.getString("breakfast"));
        plan.setLunch(rs.getString("lunch"));
        plan.setDinner(rs.getString("dinner"));
        plan.setSnacks(rs.getString("snacks"));
        plan.setNotes(rs.getString("notes"));
        return plan;
    }
    public DietPlan getTodayDietPlan(int patientId, java.sql.Date date) {
        String sql = "SELECT * FROM diet_plan WHERE patient_id = ? AND day_date = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapDietPlan(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Create diet plans from a template for multiple days
     * @param patientId The patient to assign the plan to
     * @param nutritionistId The nutritionist creating the plan
     * @param templateId The template to use
     * @param startDate The start date for the plan
     * @param numberOfDays How many days to create plans for
     * @return number of plans created, or -1 on error
     */
    public int createFromTemplate(int patientId, int nutritionistId, int templateId, java.sql.Date startDate, int numberOfDays) {
        // First get the template
        com.nutrit.dao.DietPlanTemplateDAO templateDAO = new com.nutrit.dao.DietPlanTemplateDAO();
        com.nutrit.models.DietPlanTemplate template = templateDAO.getTemplateById(templateId);
        
        if (template == null) {
            return -1;
        }
        
        // Combine snacks into one field
        StringBuilder snacks = new StringBuilder();
        if (template.getMorningSnack() != null && !template.getMorningSnack().isEmpty()) {
            snacks.append("Morning: ").append(template.getMorningSnack());
        }
        if (template.getAfternoonSnack() != null && !template.getAfternoonSnack().isEmpty()) {
            if (snacks.length() > 0) snacks.append(" | ");
            snacks.append("Afternoon: ").append(template.getAfternoonSnack());
        }
        if (template.getEveningSnack() != null && !template.getEveningSnack().isEmpty()) {
            if (snacks.length() > 0) snacks.append(" | ");
            snacks.append("Evening: ").append(template.getEveningSnack());
        }
        
        // Create notes from template info
        String notes = String.format("Template: %s | Category: %s | Calories: %d kcal/day | %s", 
            template.getName(), 
            template.getCategory(), 
            template.getCaloriesPerDay(),
            template.getNutritionInfo());
        
        String sql = "INSERT INTO diet_plan (patient_id, nutritionist_id, day_date, breakfast, lunch, dinner, snacks, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int created = 0;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(startDate);
            
            for (int i = 0; i < numberOfDays; i++) {
                stmt.setInt(1, patientId);
                stmt.setInt(2, nutritionistId);
                stmt.setDate(3, new java.sql.Date(cal.getTimeInMillis()));
                stmt.setString(4, template.getBreakfast());
                stmt.setString(5, template.getLunch());
                stmt.setString(6, template.getDinner());
                stmt.setString(7, snacks.toString());
                stmt.setString(8, notes);
                
                if (stmt.executeUpdate() > 0) {
                    created++;
                }
                
                // Move to next day
                cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
        return created;
    }
    
    /**
     * Delete existing diet plans for a patient in a date range (for replacing with new template)
     */
    public boolean deletePlansInRange(int patientId, java.sql.Date startDate, java.sql.Date endDate) {
        String sql = "DELETE FROM diet_plan WHERE patient_id = ? AND day_date BETWEEN ? AND ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patientId);
            stmt.setDate(2, startDate);
            stmt.setDate(3, endDate);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countAllPlans() {
        String sql = "SELECT COUNT(*) FROM diet_plan";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

