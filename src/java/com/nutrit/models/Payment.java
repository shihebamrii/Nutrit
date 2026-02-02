package com.nutrit.models;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Represents a payment transaction for an appointment.
 */
public class Payment {
    private int id;
    private Integer appointmentId;
    private Integer appointmentRequestId;
    private int patientId;
    private BigDecimal amount;
    private String paymentMethod; // 'online', 'in_office'
    private String status; // 'pending', 'completed', 'failed'
    private String transactionRef;
    private String cardLastFour;
    private Timestamp createdAt;
    private Timestamp completedAt;
    
    // Display fields
    private String patientName;

    public Payment() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Integer getAppointmentId() { return appointmentId; }
    public void setAppointmentId(Integer appointmentId) { this.appointmentId = appointmentId; }
    
    public Integer getAppointmentRequestId() { return appointmentRequestId; }
    public void setAppointmentRequestId(Integer appointmentRequestId) { this.appointmentRequestId = appointmentRequestId; }
    
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }
    
    public String getCardLastFour() { return cardLastFour; }
    public void setCardLastFour(String cardLastFour) { this.cardLastFour = cardLastFour; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }
    
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
}
