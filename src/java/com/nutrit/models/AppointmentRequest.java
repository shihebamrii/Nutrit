package com.nutrit.models;

import java.sql.Timestamp;

/**
 * Represents a patient's request for an appointment with their nutritionist.
 * Requests require secretary approval before becoming confirmed appointments.
 */
public class AppointmentRequest {
    private int id;
    private int patientId;
    private int nutritionistId;
    private Timestamp requestedTime;
    private String status; // pending, approved, rejected
    private String patientNotes;
    private String secretaryNotes;
    private Timestamp createdAt;
    private Timestamp reviewedAt;
    private int reviewedBy;
    
    // Display fields (populated by JOINs)
    private String patientName;
    private String patientEmail;
    private String patientProfilePicture;
    private String nutritionistName;
    private String secretaryName;

    public AppointmentRequest() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    
    public int getNutritionistId() { return nutritionistId; }
    public void setNutritionistId(int nutritionistId) { this.nutritionistId = nutritionistId; }
    
    public Timestamp getRequestedTime() { return requestedTime; }
    public void setRequestedTime(Timestamp requestedTime) { this.requestedTime = requestedTime; }
    
    // Alias methods for DAO compatibility
    public Timestamp getPreferredTime() { return requestedTime; }
    public void setPreferredTime(Timestamp preferredTime) { this.requestedTime = preferredTime; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getPatientNotes() { return patientNotes; }
    public void setPatientNotes(String patientNotes) { this.patientNotes = patientNotes; }
    
    public String getSecretaryNotes() { return secretaryNotes; }
    public void setSecretaryNotes(String secretaryNotes) { this.secretaryNotes = secretaryNotes; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }
    
    public int getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(int reviewedBy) { this.reviewedBy = reviewedBy; }
    
    // Alias for secretary ID (same as reviewedBy in the schema)
    public void setSecretaryId(int secretaryId) { this.reviewedBy = secretaryId; }
    
    // Display field getters/setters
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    
    public String getPatientEmail() { return patientEmail; }
    public void setPatientEmail(String patientEmail) { this.patientEmail = patientEmail; }
    
    public String getPatientProfilePicture() { return patientProfilePicture; }
    public void setPatientProfilePicture(String patientProfilePicture) { this.patientProfilePicture = patientProfilePicture; }
    
    public String getNutritionistName() { return nutritionistName; }
    public void setNutritionistName(String nutritionistName) { this.nutritionistName = nutritionistName; }
    
    public String getSecretaryName() { return secretaryName; }
    public void setSecretaryName(String secretaryName) { this.secretaryName = secretaryName; }
    
    // Payment fields
    private String paymentMethod; // 'online', 'in_office'
    private String paymentStatus; // 'pending', 'paid', 'failed'
    private java.math.BigDecimal paymentAmount;
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public java.math.BigDecimal getPaymentAmount() { return paymentAmount; }
    public void setPaymentAmount(java.math.BigDecimal paymentAmount) { this.paymentAmount = paymentAmount; }
}
