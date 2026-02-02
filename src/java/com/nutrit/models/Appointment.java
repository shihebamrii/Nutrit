package com.nutrit.models;

import java.sql.Timestamp;

public class Appointment {
    private int id;
    private int patientId;
    private int nutritionistId;
    private int secretaryId;
    private Timestamp scheduledTime;
    private String status;
    
    // Additional fields for display
    private String patientName;
    private String nutritionistName;

    public Appointment() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public int getNutritionistId() { return nutritionistId; }
    public void setNutritionistId(int nutritionistId) { this.nutritionistId = nutritionistId; }
    public int getSecretaryId() { return secretaryId; }
    public void setSecretaryId(int secretaryId) { this.secretaryId = secretaryId; }
    public Timestamp getScheduledTime() { return scheduledTime; }
    public void setScheduledTime(Timestamp scheduledTime) { this.scheduledTime = scheduledTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getNutritionistName() { return nutritionistName; }
    public void setNutritionistName(String nutritionistName) { this.nutritionistName = nutritionistName; }
    
    private String notes;
    private String patientProfilePicture;
    private String nutritionistProfilePicture;

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getPatientProfilePicture() { return patientProfilePicture; }
    public void setPatientProfilePicture(String patientProfilePicture) { this.patientProfilePicture = patientProfilePicture; }

    public String getNutritionistProfilePicture() { return nutritionistProfilePicture; }
    public void setNutritionistProfilePicture(String nutritionistProfilePicture) { this.nutritionistProfilePicture = nutritionistProfilePicture; }
    
    // Payment fields
    private String paymentMethod; // 'online', 'in_office'
    private String paymentStatus; // 'pending', 'paid'
    private java.math.BigDecimal paymentAmount;
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public java.math.BigDecimal getPaymentAmount() { return paymentAmount; }
    public void setPaymentAmount(java.math.BigDecimal paymentAmount) { this.paymentAmount = paymentAmount; }
}
