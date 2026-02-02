package com.nutrit.models;

import java.sql.Time;

/**
 * Represents a nutritionist's availability slot for a specific day of the week.
 * Used to generate available appointment time slots for patients.
 */
public class NutritionistAvailability {
    private int id;
    private int nutritionistId;
    private String dayOfWeek; // monday, tuesday, etc.
    private Time startTime;
    private Time endTime;
    private int slotDurationMinutes;
    private boolean isActive;

    public NutritionistAvailability() {
        this.slotDurationMinutes = 30; // Default 30-minute slots
        this.isActive = true;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getNutritionistId() { return nutritionistId; }
    public void setNutritionistId(int nutritionistId) { this.nutritionistId = nutritionistId; }
    
    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }
    
    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }
    
    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
    
    public int getSlotDurationMinutes() { return slotDurationMinutes; }
    public void setSlotDurationMinutes(int slotDurationMinutes) { this.slotDurationMinutes = slotDurationMinutes; }
    
    // Alias methods for DAO compatibility
    public int getSlotDuration() { return slotDurationMinutes; }
    public void setSlotDuration(int slotDuration) { this.slotDurationMinutes = slotDuration; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    
    // Alias for setActive for DAO compatibility
    public void setAvailable(boolean available) { this.isActive = available; }
    
    /**
     * Get display-friendly day name (e.g., "Monday" instead of "monday")
     */
    public String getDayOfWeekDisplay() {
        if (dayOfWeek == null || dayOfWeek.isEmpty()) return "";
        return dayOfWeek.substring(0, 1).toUpperCase() + dayOfWeek.substring(1);
    }
}
