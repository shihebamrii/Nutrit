package com.nutrit.models;

import java.sql.Timestamp;

/**
 * Model class representing a like on a community post.
 */
public class PostLike {
    private int id;
    private int postId;
    private int userId;
    private Timestamp createdAt;
    
    // Display fields
    private String userName;

    public PostLike() {}

    public PostLike(int postId, int userId) {
        this.postId = postId;
        this.userId = userId;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
