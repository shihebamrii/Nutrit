package com.nutrit.models;

import java.sql.Timestamp;

/**
 * Model class for post reports (community moderation)
 */
public class PostReport {
    private int id;
    private int postId;
    private int reporterId;
    private String reason;      // spam, harassment, inappropriate, misinformation, other
    private String description;
    private String status;      // pending, reviewed, dismissed, action_taken
    private Integer reviewedBy;
    private Timestamp reviewedAt;
    private Timestamp createdAt;
    
    // Display fields (from JOINs)
    private String reporterName;
    private String postContent;
    private String postAuthorName;
    private int postAuthorId;

    public PostReport() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    
    public int getReporterId() { return reporterId; }
    public void setReporterId(int reporterId) { this.reporterId = reporterId; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }
    
    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    // Display field getters/setters
    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }
    
    public String getPostContent() { return postContent; }
    public void setPostContent(String postContent) { this.postContent = postContent; }
    
    public String getPostAuthorName() { return postAuthorName; }
    public void setPostAuthorName(String postAuthorName) { this.postAuthorName = postAuthorName; }
    
    public int getPostAuthorId() { return postAuthorId; }
    public void setPostAuthorId(int postAuthorId) { this.postAuthorId = postAuthorId; }
    
    // Helper method to get reason display text
    public String getReasonDisplay() {
        if (reason == null) return "Unknown";
        switch (reason) {
            case "spam": return "Spam";
            case "harassment": return "Harassment";
            case "inappropriate": return "Inappropriate Content";
            case "misinformation": return "Misinformation";
            case "other": return "Other";
            default: return reason;
        }
    }
    
    // Helper method to get status display with badge class
    public String getStatusBadgeClass() {
        if (status == null) return "badge-secondary";
        switch (status) {
            case "pending": return "badge-warning";
            case "reviewed": return "badge-info";
            case "dismissed": return "badge-secondary";
            case "action_taken": return "badge-success";
            default: return "badge-secondary";
        }
    }
}
