package com.nutrit.models;

import java.sql.Timestamp;
import java.sql.Date;

public class DailyProgress {
    private int id;
    private int patientId;
    private Date date;
    private double weight;
    private int caloriesConsumed;
    private int waterIntake;
    private String notes;
    private java.util.List<MealTracking> mealTrackings;

    public DailyProgress() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }
    public int getCaloriesConsumed() { return caloriesConsumed; }
    public void setCaloriesConsumed(int caloriesConsumed) { this.caloriesConsumed = caloriesConsumed; }
    public int getWaterIntake() { return waterIntake; }
    public void setWaterIntake(int waterIntake) { this.waterIntake = waterIntake; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public java.util.List<MealTracking> getMealTrackings() { return mealTrackings; }
    public void setMealTrackings(java.util.List<MealTracking> mealTrackings) { this.mealTrackings = mealTrackings; }
}
