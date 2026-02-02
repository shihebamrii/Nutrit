package com.nutrit.models;

import java.sql.Date;

public class DietPlan {
    private int id;
    private int patientId;
    private int nutritionistId;
    private Date dayDate; // java.sql.Date
    private String breakfast;
    private String lunch;
    private String dinner;
    private String snacks;
    private String notes;

    public DietPlan() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public int getNutritionistId() { return nutritionistId; }
    public void setNutritionistId(int nutritionistId) { this.nutritionistId = nutritionistId; }
    public Date getDayDate() { return dayDate; }
    public void setDayDate(Date dayDate) { this.dayDate = dayDate; }
    public String getBreakfast() { return breakfast; }
    public void setBreakfast(String breakfast) { this.breakfast = breakfast; }
    public String getLunch() { return lunch; }
    public void setLunch(String lunch) { this.lunch = lunch; }
    public String getDinner() { return dinner; }
    public void setDinner(String dinner) { this.dinner = dinner; }
    public String getSnacks() { return snacks; }
    public void setSnacks(String snacks) { this.snacks = snacks; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
