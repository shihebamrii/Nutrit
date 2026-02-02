package com.nutrit.models;

import java.sql.Date;
import java.sql.Timestamp;
import java.math.BigDecimal;

public class PatientProfile {
    private int id; // Same as User ID
    
    // Basic Information
    private Date dateOfBirth;
    private String gender; // male, female, other
    private BigDecimal height; // in cm
    private BigDecimal currentWeight; // in kg
    private BigDecimal targetWeight; // in kg
    
    // Lifestyle
    private String activityLevel; // sedentary, light, moderate, active, very_active
    private String occupation;
    private int sleepHours; // average hours per night
    private String stressLevel; // low, moderate, high
    private String smokingStatus; // never, former, current
    private String alcoholConsumption; // none, occasional, moderate, frequent
    private String exerciseFrequency; // none, 1-2_weekly, 3-4_weekly, 5+_weekly, daily
    private String exerciseType; // cardio, strength, both, yoga, sports, other
    
    // Medical History
    private String medicalConditions; // diabetes, hypertension, heart_disease, etc.
    private String allergies; // food allergies
    private String currentMedications;
    private String previousSurgeries;
    private String familyMedicalHistory;
    private String digestiveIssues; // bloating, constipation, acid_reflux, ibs, none
    
    // Dietary Information
    private String dietaryRestrictions; // vegetarian, vegan, halal, kosher, gluten_free, lactose_free, none
    private String foodPreferences;
    private String foodsToAvoid; // dislikes
    private int dailyWaterIntake; // glasses per day
    private int mealsPerDay; // 1-6
    private String snackingHabits; // never, rarely, sometimes, often, always
    private String previousDietHistory;
    
    // Health Goals
    private String primaryGoal; // weight_loss, weight_gain, muscle_building, health_improvement, disease_management
    private String secondaryGoals;
    private String motivationLevel; // low, moderate, high, very_high
    
    // Additional Notes
    private String additionalNotes;
    private Timestamp updatedAt;
    
    public PatientProfile() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public BigDecimal getHeight() { return height; }
    public void setHeight(BigDecimal height) { this.height = height; }

    public BigDecimal getCurrentWeight() { return currentWeight; }
    public void setCurrentWeight(BigDecimal currentWeight) { this.currentWeight = currentWeight; }

    public BigDecimal getTargetWeight() { return targetWeight; }
    public void setTargetWeight(BigDecimal targetWeight) { this.targetWeight = targetWeight; }

    public String getActivityLevel() { return activityLevel; }
    public void setActivityLevel(String activityLevel) { this.activityLevel = activityLevel; }

    public String getOccupation() { return occupation; }
    public void setOccupation(String occupation) { this.occupation = occupation; }

    public int getSleepHours() { return sleepHours; }
    public void setSleepHours(int sleepHours) { this.sleepHours = sleepHours; }

    public String getStressLevel() { return stressLevel; }
    public void setStressLevel(String stressLevel) { this.stressLevel = stressLevel; }

    public String getSmokingStatus() { return smokingStatus; }
    public void setSmokingStatus(String smokingStatus) { this.smokingStatus = smokingStatus; }

    public String getAlcoholConsumption() { return alcoholConsumption; }
    public void setAlcoholConsumption(String alcoholConsumption) { this.alcoholConsumption = alcoholConsumption; }

    public String getExerciseFrequency() { return exerciseFrequency; }
    public void setExerciseFrequency(String exerciseFrequency) { this.exerciseFrequency = exerciseFrequency; }

    public String getExerciseType() { return exerciseType; }
    public void setExerciseType(String exerciseType) { this.exerciseType = exerciseType; }

    public String getMedicalConditions() { return medicalConditions; }
    public void setMedicalConditions(String medicalConditions) { this.medicalConditions = medicalConditions; }

    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }

    public String getCurrentMedications() { return currentMedications; }
    public void setCurrentMedications(String currentMedications) { this.currentMedications = currentMedications; }

    public String getPreviousSurgeries() { return previousSurgeries; }
    public void setPreviousSurgeries(String previousSurgeries) { this.previousSurgeries = previousSurgeries; }

    public String getFamilyMedicalHistory() { return familyMedicalHistory; }
    public void setFamilyMedicalHistory(String familyMedicalHistory) { this.familyMedicalHistory = familyMedicalHistory; }

    public String getDigestiveIssues() { return digestiveIssues; }
    public void setDigestiveIssues(String digestiveIssues) { this.digestiveIssues = digestiveIssues; }

    public String getDietaryRestrictions() { return dietaryRestrictions; }
    public void setDietaryRestrictions(String dietaryRestrictions) { this.dietaryRestrictions = dietaryRestrictions; }

    public String getFoodPreferences() { return foodPreferences; }
    public void setFoodPreferences(String foodPreferences) { this.foodPreferences = foodPreferences; }

    public String getFoodsToAvoid() { return foodsToAvoid; }
    public void setFoodsToAvoid(String foodsToAvoid) { this.foodsToAvoid = foodsToAvoid; }

    public int getDailyWaterIntake() { return dailyWaterIntake; }
    public void setDailyWaterIntake(int dailyWaterIntake) { this.dailyWaterIntake = dailyWaterIntake; }

    public int getMealsPerDay() { return mealsPerDay; }
    public void setMealsPerDay(int mealsPerDay) { this.mealsPerDay = mealsPerDay; }

    public String getSnackingHabits() { return snackingHabits; }
    public void setSnackingHabits(String snackingHabits) { this.snackingHabits = snackingHabits; }

    public String getPreviousDietHistory() { return previousDietHistory; }
    public void setPreviousDietHistory(String previousDietHistory) { this.previousDietHistory = previousDietHistory; }

    public String getPrimaryGoal() { return primaryGoal; }
    public void setPrimaryGoal(String primaryGoal) { this.primaryGoal = primaryGoal; }

    public String getSecondaryGoals() { return secondaryGoals; }
    public void setSecondaryGoals(String secondaryGoals) { this.secondaryGoals = secondaryGoals; }

    public String getMotivationLevel() { return motivationLevel; }
    public void setMotivationLevel(String motivationLevel) { this.motivationLevel = motivationLevel; }

    public String getAdditionalNotes() { return additionalNotes; }
    public void setAdditionalNotes(String additionalNotes) { this.additionalNotes = additionalNotes; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    // Helper method to calculate BMI
    public BigDecimal getBMI() {
        if (height != null && currentWeight != null && height.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal heightInMeters = height.divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
            return currentWeight.divide(heightInMeters.multiply(heightInMeters), 1, java.math.RoundingMode.HALF_UP);
        }
        return null;
    }
    
    // Helper method to get age from date of birth
    public int getAge() {
        if (dateOfBirth != null) {
            java.time.LocalDate birthDate = dateOfBirth.toLocalDate();
            java.time.LocalDate now = java.time.LocalDate.now();
            return java.time.Period.between(birthDate, now).getYears();
        }
        return 0;
    }
}
