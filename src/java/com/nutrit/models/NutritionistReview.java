package com.nutrit.models;

import java.sql.Timestamp;

public class NutritionistReview {
    private int id;
    private int nutritionistId;
    private int patientId;
    private int rating; // 1-5 stars
    private String comment;
    private Timestamp createdAt;
    
    // For display purposes
    private String patientName;
    private String patientProfilePicture;

    public NutritionistReview() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getNutritionistId() { return nutritionistId; }
    public void setNutritionistId(int nutritionistId) { this.nutritionistId = nutritionistId; }
    
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    
    public String getPatientProfilePicture() { return patientProfilePicture; }
    public void setPatientProfilePicture(String patientProfilePicture) { this.patientProfilePicture = patientProfilePicture; }
}
