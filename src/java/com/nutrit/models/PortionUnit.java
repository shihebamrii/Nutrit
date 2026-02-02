package com.nutrit.models;

/**
 * Model representing a portion/measurement unit.
 * Used for specifying quantities of food items.
 */
public class PortionUnit {
    private int id;
    private String name;
    private String abbreviation;
    private Double gramsEquivalent;  // null if context-dependent (like "piece" or "portion")

    public PortionUnit() {}

    public PortionUnit(int id, String name, String abbreviation) {
        this.id = id;
        this.name = name;
        this.abbreviation = abbreviation;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAbbreviation() { return abbreviation; }
    public void setAbbreviation(String abbreviation) { this.abbreviation = abbreviation; }

    public Double getGramsEquivalent() { return gramsEquivalent; }
    public void setGramsEquivalent(Double gramsEquivalent) { this.gramsEquivalent = gramsEquivalent; }

    /**
     * Get display string for this unit
     */
    public String getDisplayName() {
        return name + " (" + abbreviation + ")";
    }
}
