package com.nutrit.models;

import java.math.BigDecimal;

public class NutritionistProfile {
    private int id; // Same as User ID
    private String specialization;
    private int yearsExperience;
    private String licenseNumber;
    private String clinicAddress;
    private String workingHours;
    private BigDecimal price;
    private String bio;

    // New Search Fields
    private String clinicName;
    private String governorate;
    private String city;
    private String multipleSpecialties; // Stored as CSV
    private String languages; // Stored as CSV
    private String consultationType; // en_ligne, presentiel, hybride
    private String keywords;
    private String diplomas;
    private BigDecimal latitude;
    private BigDecimal longitude;

    // Transient fields for display
    private double averageRating;
    private int reviewCount;

    public NutritionistProfile() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }
    
    public int getYearsExperience() { return yearsExperience; }
    public void setYearsExperience(int yearsExperience) { this.yearsExperience = yearsExperience; }
    
    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }
    
    public String getClinicAddress() { return clinicAddress; }
    public void setClinicAddress(String clinicAddress) { this.clinicAddress = clinicAddress; }
    
    public String getWorkingHours() { return workingHours; }
    public void setWorkingHours(String workingHours) { this.workingHours = workingHours; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    // Getters and Setters for new fields
    public String getClinicName() { return clinicName; }
    public void setClinicName(String clinicName) { this.clinicName = clinicName; }
    
    public String getGovernorate() { return governorate; }
    public void setGovernorate(String governorate) { this.governorate = governorate; }
    
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    
    public String getMultipleSpecialties() { return multipleSpecialties; }
    public void setMultipleSpecialties(String multipleSpecialties) { this.multipleSpecialties = multipleSpecialties; }
    
    public String getLanguages() { return languages; }
    public void setLanguages(String languages) { this.languages = languages; }
    
    public String getConsultationType() { return consultationType; }
    public void setConsultationType(String consultationType) { this.consultationType = consultationType; }
    
    public String getKeywords() { return keywords; }
    public void setKeywords(String keywords) { this.keywords = keywords; }
    
    public String getDiplomas() { return diplomas; }
    public void setDiplomas(String diplomas) { this.diplomas = diplomas; }
    
    public BigDecimal getLatitude() { return latitude; }
    public void setLatitude(BigDecimal latitude) { this.latitude = latitude; }
    
    public BigDecimal getLongitude() { return longitude; }
    public void setLongitude(BigDecimal longitude) { this.longitude = longitude; }

    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
}
