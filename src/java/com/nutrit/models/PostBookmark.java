package com.nutrit.models;

import java.sql.Timestamp;

/**
 * Model class for post bookmarks (saved posts)
 */
public class PostBookmark {
    private int id;
    private int postId;
    private int userId;
    private Timestamp createdAt;
    
    // Display field (from JOIN)
    private CommunityPost post;

    public PostBookmark() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public CommunityPost getPost() { return post; }
    public void setPost(CommunityPost post) { this.post = post; }
}
