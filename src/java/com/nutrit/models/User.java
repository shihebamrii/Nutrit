package com.nutrit.models;

import java.sql.Timestamp;

public class User {
    private int id;
    private String role;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String status;
    private Timestamp createdAt;
    
    // New profile fields
    private String profilePicture;
    private String bio;
    
    // Transient fields
    private int followersCount;
    private int followingCount;
    
    // Legacy support
    private String profileImage;

    public User() {}

    public User(int id, String role, String fullName, String email, String password, String phone, String address, Timestamp createdAt) {
        this.id = id;
        this.role = role;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.address = address;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { 
        this.profilePicture = profilePicture;
        this.profileImage = profilePicture; // Keep synced
    }
    
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    
    public int getFollowersCount() { return followersCount; }
    public void setFollowersCount(int followersCount) { this.followersCount = followersCount; }
    
    public int getFollowingCount() { return followingCount; }
    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }

    // Transient fields for View/Controller convenience
    private NutritionistProfile nutritionistProfile;
    public NutritionistProfile getNutritionistProfile() { return nutritionistProfile; }
    public void setNutritionistProfile(NutritionistProfile nutritionistProfile) { this.nutritionistProfile = nutritionistProfile; }

    public String getProfileImage() { return profileImage != null ? profileImage : profilePicture; }
    public void setProfileImage(String profileImage) { 
        this.profileImage = profileImage;
        if (this.profilePicture == null) this.profilePicture = profileImage;
    }
}
