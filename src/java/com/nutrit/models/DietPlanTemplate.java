package com.nutrit.models;

import java.sql.Timestamp;

public class DietPlanTemplate {
    private int id;
    private String name;
    private String category;  // weight_loss, weight_gain, muscle_building, diabetes, heart_health, etc.
    private String targetGoal; // Description of what this diet aims to achieve
    private int caloriesPerDay;
    private String breakfast;
    private String morningSnack;
    private String lunch;
    private String afternoonSnack;
    private String dinner;
    private String eveningSnack;
    private String restrictions; // vegetarian, vegan, gluten-free, lactose-free, halal, kosher
    private String suitableFor; // Description of who this diet is suitable for
    private String nutritionInfo; // Macros breakdown (protein, carbs, fat percentages)
    private String notes;
    private int durationDays; // Recommended duration in days
    private Timestamp createdAt;

    public DietPlanTemplate() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getTargetGoal() { return targetGoal; }
    public void setTargetGoal(String targetGoal) { this.targetGoal = targetGoal; }

    public int getCaloriesPerDay() { return caloriesPerDay; }
    public void setCaloriesPerDay(int caloriesPerDay) { this.caloriesPerDay = caloriesPerDay; }

    public String getBreakfast() { return breakfast; }
    public void setBreakfast(String breakfast) { this.breakfast = breakfast; }

    public String getMorningSnack() { return morningSnack; }
    public void setMorningSnack(String morningSnack) { this.morningSnack = morningSnack; }

    public String getLunch() { return lunch; }
    public void setLunch(String lunch) { this.lunch = lunch; }

    public String getAfternoonSnack() { return afternoonSnack; }
    public void setAfternoonSnack(String afternoonSnack) { this.afternoonSnack = afternoonSnack; }

    public String getDinner() { return dinner; }
    public void setDinner(String dinner) { this.dinner = dinner; }

    public String getEveningSnack() { return eveningSnack; }
    public void setEveningSnack(String eveningSnack) { this.eveningSnack = eveningSnack; }

    public String getRestrictions() { return restrictions; }
    public void setRestrictions(String restrictions) { this.restrictions = restrictions; }

    public String getSuitableFor() { return suitableFor; }
    public void setSuitableFor(String suitableFor) { this.suitableFor = suitableFor; }

    public String getNutritionInfo() { return nutritionInfo; }
    public void setNutritionInfo(String nutritionInfo) { this.nutritionInfo = nutritionInfo; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
