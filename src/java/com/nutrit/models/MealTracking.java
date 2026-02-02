package com.nutrit.models;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model for tracking patient meal completion status
 */
public class MealTracking {
    private int id;
    private int mealPlanId;
    private int patientId;
    private Date trackingDate;
    private String mealType; // breakfast, lunch, dinner, snacks
    private boolean completed;
    private String alternativeMeal; // What the patient ate instead if not completed
    private String notes;
    private Timestamp createdAt;

    public MealTracking() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getMealPlanId() { return mealPlanId; }
    public void setMealPlanId(int mealPlanId) { this.mealPlanId = mealPlanId; }
    
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    
    public Date getTrackingDate() { return trackingDate; }
    public void setTrackingDate(Date trackingDate) { this.trackingDate = trackingDate; }
    
    public String getMealType() { return mealType; }
    public void setMealType(String mealType) { this.mealType = mealType; }
    
    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }
    
    public String getAlternativeMeal() { return alternativeMeal; }
    public void setAlternativeMeal(String alternativeMeal) { this.alternativeMeal = alternativeMeal; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
