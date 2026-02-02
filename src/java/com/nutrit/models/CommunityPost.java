package com.nutrit.models;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CommunityPost {
    private int id;
    private int patientId;
    private String content;
    private String image;
    private Timestamp createdAt;
    
    // Display fields
    private String patientName;
    private String patientProfilePicture;
    private String patientBio;
    
    // Like and comment tracking
    private int likeCount;
    private int commentCount;
    private boolean userHasLiked;
    private List<PostComment> comments;
    
    // Bookmark tracking
    private int bookmarkCount;
    private boolean userHasBookmarked;
    
    // Share tracking
    private int shareCount;

    public CommunityPost() {
        this.comments = new ArrayList<>();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getPatientProfilePicture() { return patientProfilePicture; }
    public void setPatientProfilePicture(String patientProfilePicture) { this.patientProfilePicture = patientProfilePicture; }
    public String getPatientBio() { return patientBio; }
    public void setPatientBio(String patientBio) { this.patientBio = patientBio; }
    
    // Like and comment getters/setters
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
    public boolean isUserHasLiked() { return userHasLiked; }
    public void setUserHasLiked(boolean userHasLiked) { this.userHasLiked = userHasLiked; }
    public List<PostComment> getComments() { return comments; }
    public void setComments(List<PostComment> comments) { this.comments = comments; }
    
    // Bookmark getters/setters
    public int getBookmarkCount() { return bookmarkCount; }
    public void setBookmarkCount(int bookmarkCount) { this.bookmarkCount = bookmarkCount; }
    public boolean isUserHasBookmarked() { return userHasBookmarked; }
    public void setUserHasBookmarked(boolean userHasBookmarked) { this.userHasBookmarked = userHasBookmarked; }
    
    // Share getters/setters
    public int getShareCount() { return shareCount; }
    public void setShareCount(int shareCount) { this.shareCount = shareCount; }
}
