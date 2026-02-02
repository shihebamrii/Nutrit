package com.nutrit.models;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Represents an invoice for an appointment consultation.
 */
public class Invoice {
    private int id;
    private String invoiceNumber;
    private int appointmentId;
    private int patientId;
    private int nutritionistId;
    private BigDecimal amount;
    private String paymentMethod; // 'online', 'in_office'
    private String paymentStatus; // 'paid', 'unpaid'
    private Integer generatedBy; // Secretary ID
    private Timestamp createdAt;
    
    // Display fields from JOINs
    private String patientName;
    private String patientEmail;
    private String patientPhone;
    private String patientAddress;
    private String nutritionistName;
    private String nutritionistSpecialization;
    private String clinicAddress;
    private Timestamp appointmentTime;

    public Invoice() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }
    
    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
    
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    
    public int getNutritionistId() { return nutritionistId; }
    public void setNutritionistId(int nutritionistId) { this.nutritionistId = nutritionistId; }
    
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    
    // Alias methods for DAO compatibility
    public BigDecimal getTotalAmount() { return amount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.amount = totalAmount; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public Integer getGeneratedBy() { return generatedBy; }
    public void setGeneratedBy(Integer generatedBy) { this.generatedBy = generatedBy; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    // Display field getters/setters
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    
    public String getPatientEmail() { return patientEmail; }
    public void setPatientEmail(String patientEmail) { this.patientEmail = patientEmail; }
    
    public String getPatientPhone() { return patientPhone; }
    public void setPatientPhone(String patientPhone) { this.patientPhone = patientPhone; }
    
    public String getPatientAddress() { return patientAddress; }
    public void setPatientAddress(String patientAddress) { this.patientAddress = patientAddress; }
    
    public String getNutritionistName() { return nutritionistName; }
    public void setNutritionistName(String nutritionistName) { this.nutritionistName = nutritionistName; }
    
    public String getNutritionistSpecialization() { return nutritionistSpecialization; }
    public void setNutritionistSpecialization(String nutritionistSpecialization) { this.nutritionistSpecialization = nutritionistSpecialization; }
    
    public String getClinicAddress() { return clinicAddress; }
    public void setClinicAddress(String clinicAddress) { this.clinicAddress = clinicAddress; }
    
    public Timestamp getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(Timestamp appointmentTime) { this.appointmentTime = appointmentTime; }
    
    // Alias for appointmentDate (same as appointmentTime)
    public void setAppointmentDate(Timestamp appointmentDate) { this.appointmentTime = appointmentDate; }
}
