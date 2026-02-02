package com.nutrit.models;

import java.sql.Timestamp;

/**
 * Model class for user follows (social following system)
 */
public class UserFollow {
    private int id;
    private int followerId;
    private int followingId;
    private Timestamp createdAt;
    
    // Display fields (from JOINs)
    private String followerName;
    private String followingName;
    private String followerProfilePicture;
    private String followingProfilePicture;

    public UserFollow() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getFollowerId() { return followerId; }
    public void setFollowerId(int followerId) { this.followerId = followerId; }
    
    public int getFollowingId() { return followingId; }
    public void setFollowingId(int followingId) { this.followingId = followingId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getFollowerName() { return followerName; }
    public void setFollowerName(String followerName) { this.followerName = followerName; }
    
    public String getFollowingName() { return followingName; }
    public void setFollowingName(String followingName) { this.followingName = followingName; }
    
    public String getFollowerProfilePicture() { return followerProfilePicture; }
    public void setFollowerProfilePicture(String followerProfilePicture) { this.followerProfilePicture = followerProfilePicture; }
    
    public String getFollowingProfilePicture() { return followingProfilePicture; }
    public void setFollowingProfilePicture(String followingProfilePicture) { this.followingProfilePicture = followingProfilePicture; }
}
