package com.nutrit.models;

import java.sql.Timestamp;

/**
 * Model representing a food item in the catalog.
 * Contains nutritional information per 100g.
 */
public class FoodItem {
    private int id;
    private String name;
    private String nameAr;  // Arabic name
    private String category;  // protein, carbs, vegetables, fruits, dairy, etc.
    private String idealMoment;  // When to eat: matin,midi,soir,collation (comma-separated)
    private String portionUnit;  // Unit: g, ml, unité, tranche, cuillère, etc.
    private int defaultPortion;  // Default portion size (e.g., 100g, 200ml, 1 unit)
    private int caloriesPer100g;
    private double proteinG;
    private double carbsG;
    private double fatG;
    private double fiberG;
    private String description;
    private String imagePath;  // Path to food image in assets/food_images/
    private boolean isActive;
    private Timestamp createdAt;

    public FoodItem() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getNameAr() { return nameAr; }
    public void setNameAr(String nameAr) { this.nameAr = nameAr; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getIdealMoment() { return idealMoment; }
    public void setIdealMoment(String idealMoment) { this.idealMoment = idealMoment; }

    public String getPortionUnit() { return portionUnit != null ? portionUnit : "g"; }
    public void setPortionUnit(String portionUnit) { this.portionUnit = portionUnit; }

    public int getDefaultPortion() { return defaultPortion > 0 ? defaultPortion : 100; }
    public void setDefaultPortion(int defaultPortion) { this.defaultPortion = defaultPortion; }

    public int getCaloriesPer100g() { return caloriesPer100g; }
    public void setCaloriesPer100g(int caloriesPer100g) { this.caloriesPer100g = caloriesPer100g; }

    public double getProteinG() { return proteinG; }
    public void setProteinG(double proteinG) { this.proteinG = proteinG; }

    public double getCarbsG() { return carbsG; }
    public void setCarbsG(double carbsG) { this.carbsG = carbsG; }

    public double getFatG() { return fatG; }
    public void setFatG(double fatG) { this.fatG = fatG; }

    public double getFiberG() { return fiberG; }
    public void setFiberG(double fiberG) { this.fiberG = fiberG; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    /**
     * Get display name (Arabic if available, otherwise English)
     */
    public String getDisplayName() {
        if (nameAr != null && !nameAr.isEmpty()) {
            return name + " (" + nameAr + ")";
        }
        return name;
    }
}
