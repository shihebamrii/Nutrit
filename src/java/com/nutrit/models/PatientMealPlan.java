package com.nutrit.models;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.*;

/**
 * Model representing a patient's meal plan.
 * Contains which meal times are enabled and the food items for each time.
 */
public class PatientMealPlan {
    private int id;
    private int patientId;
    private int nutritionistId;
    private String patientName;  // Loaded from users table
    private String nutritionistName;  // Loaded from users table
    private Date startDate;
    private Date endDate;
    private String notes;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Enabled meal times
    private Set<String> enabledMealTimes = new HashSet<>();
    
    // Food items organized by meal time
    private Map<String, List<MealPlanItem>> mealItems = new HashMap<>();
    
    // Constants for meal times
    public static final String MEAL_MORNING = "morning";
    public static final String MEAL_NOON = "noon";
    public static final String MEAL_NIGHT = "night";
    public static final String MEAL_SNACKS = "snacks";
    
    public static final String[] ALL_MEAL_TIMES = {MEAL_MORNING, MEAL_NOON, MEAL_NIGHT, MEAL_SNACKS};

    // Calorie targets
    private int caloriesMatin;
    private int caloriesMidi;
    private int caloriesSoir;
    private int caloriesCollation;
    
    // Target weight (scale/balance)
    private double targetWeight;

    public PatientMealPlan() {
        // Initialize meal items map with empty lists
        for (String mealTime : ALL_MEAL_TIMES) {
            mealItems.put(mealTime, new ArrayList<>());
        }
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getNutritionistId() { return nutritionistId; }
    public void setNutritionistId(int nutritionistId) { this.nutritionistId = nutritionistId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getNutritionistName() { return nutritionistName; }
    public void setNutritionistName(String nutritionistName) { this.nutritionistName = nutritionistName; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public Set<String> getEnabledMealTimes() { return enabledMealTimes; }
    public void setEnabledMealTimes(Set<String> enabledMealTimes) { this.enabledMealTimes = enabledMealTimes; }

    public Map<String, List<MealPlanItem>> getMealItems() { return mealItems; }
    public void setMealItems(Map<String, List<MealPlanItem>> mealItems) { this.mealItems = mealItems; }

    // Convenience methods
    public boolean isMealTimeEnabled(String mealTime) {
        return enabledMealTimes.contains(mealTime);
    }
    
    /**
     * Returns a Map for JSTL EL access like ${mealPlan.mealTimeEnabled['morning']}
     */
    public Map<String, Boolean> getMealTimeEnabled() {
        Map<String, Boolean> result = new HashMap<>();
        for (String time : ALL_MEAL_TIMES) {
            result.put(time, enabledMealTimes.contains(time));
        }
        return result;
    }

    public void enableMealTime(String mealTime) {
        enabledMealTimes.add(mealTime);
    }

    public void disableMealTime(String mealTime) {
        enabledMealTimes.remove(mealTime);
    }

    public List<MealPlanItem> getItemsForMealTime(String mealTime) {
        return mealItems.getOrDefault(mealTime, new ArrayList<>());
    }

    public void addItem(MealPlanItem item) {
        String mealTime = item.getMealTime();
        if (!mealItems.containsKey(mealTime)) {
            mealItems.put(mealTime, new ArrayList<>());
        }
        mealItems.get(mealTime).add(item);
    }

    /**
     * Get display label for meal time
     */
    public static String getMealTimeLabel(String mealTime) {
        switch (mealTime) {
            case MEAL_MORNING: return "Morning (Breakfast)";
            case MEAL_NOON: return "Noon (Lunch)";
            case MEAL_NIGHT: return "Night (Dinner)";
            case MEAL_SNACKS: return "Snacks";
            default: return mealTime;
        }
    }

    /**
     * Get icon class for meal time (Phosphor icons)
     */
    public static String getMealTimeIcon(String mealTime) {
        switch (mealTime) {
            case MEAL_MORNING: return "ph-sun-horizon";
            case MEAL_NOON: return "ph-sun";
            case MEAL_NIGHT: return "ph-moon-stars";
            case MEAL_SNACKS: return "ph-cookie";
            default: return "ph-fork-knife";
        }
    }

    public int getCaloriesMatin() { return caloriesMatin; }
    public void setCaloriesMatin(int caloriesMatin) { this.caloriesMatin = caloriesMatin; }

    public int getCaloriesMidi() { return caloriesMidi; }
    public void setCaloriesMidi(int caloriesMidi) { this.caloriesMidi = caloriesMidi; }

    public int getCaloriesSoir() { return caloriesSoir; }
    public void setCaloriesSoir(int caloriesSoir) { this.caloriesSoir = caloriesSoir; }

    public int getCaloriesCollation() { return caloriesCollation; }
    public void setCaloriesCollation(int caloriesCollation) { this.caloriesCollation = caloriesCollation; }

    public double getTargetWeight() { return targetWeight; }
    public void setTargetWeight(double targetWeight) { this.targetWeight = targetWeight; }
}

