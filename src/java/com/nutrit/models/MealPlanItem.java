package com.nutrit.models;

/**
 * Model representing a single food item in a meal plan.
 * Links a food item to a specific meal time with quantity and portion unit.
 */
public class MealPlanItem {
    private int id;
    private int mealPlanId;
    private String mealTime;  // morning, noon, night, snacks
    private int dayOfWeek; // 1=Mon, 7=Sun
    
    // Alternative 1 (Main)
    private int foodItemId1;
    private FoodItem foodItem1;
    private double quantity1; // in grams
    
    // Alternative 2
    private int foodItemId2;
    private FoodItem foodItem2;
    private double quantity2; // in grams
    
    // Alternative 3
    private int foodItemId3;
    private FoodItem foodItem3;
    private double quantity3; // in grams

    // Alternative 4
    private int foodItemId4;
    private FoodItem foodItem4;
    private double quantity4; // in grams
    
    private String notes;
    private int sortOrder;

    public MealPlanItem() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMealPlanId() { return mealPlanId; }
    public void setMealPlanId(int mealPlanId) { this.mealPlanId = mealPlanId; }

    public String getMealTime() { return mealTime; }
    public void setMealTime(String mealTime) { this.mealTime = mealTime; }
    
    public int getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(int dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    // Option 1
    public int getFoodItemId1() { return foodItemId1; }
    public void setFoodItemId1(int foodItemId1) { this.foodItemId1 = foodItemId1; }

    public FoodItem getFoodItem1() { return foodItem1; }
    public void setFoodItem1(FoodItem foodItem1) { this.foodItem1 = foodItem1; }

    public double getQuantity1() { return quantity1; }
    public void setQuantity1(double quantity1) { this.quantity1 = quantity1; }
    
    // Option 2
    public int getFoodItemId2() { return foodItemId2; }
    public void setFoodItemId2(int foodItemId2) { this.foodItemId2 = foodItemId2; }

    public FoodItem getFoodItem2() { return foodItem2; }
    public void setFoodItem2(FoodItem foodItem2) { this.foodItem2 = foodItem2; }

    public double getQuantity2() { return quantity2; }
    public void setQuantity2(double quantity2) { this.quantity2 = quantity2; }
    
    // Option 3
    public int getFoodItemId3() { return foodItemId3; }
    public void setFoodItemId3(int foodItemId3) { this.foodItemId3 = foodItemId3; }

    public FoodItem getFoodItem3() { return foodItem3; }
    public void setFoodItem3(FoodItem foodItem3) { this.foodItem3 = foodItem3; }

    public double getQuantity3() { return quantity3; }
    public void setQuantity3(double quantity3) { this.quantity3 = quantity3; }

    // Option 4
    public int getFoodItemId4() { return foodItemId4; }
    public void setFoodItemId4(int foodItemId4) { this.foodItemId4 = foodItemId4; }

    public FoodItem getFoodItem4() { return foodItem4; }
    public void setFoodItem4(FoodItem foodItem4) { this.foodItem4 = foodItem4; }

    public double getQuantity4() { return quantity4; }
    public void setQuantity4(double quantity4) { this.quantity4 = quantity4; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }

    /**
     * Get display string for this item row (showing alternatives with OR)
     */
    public String getDisplayText() {
        StringBuilder sb = new StringBuilder();
        
        // Item 1
        if (foodItem1 != null) {
            sb.append(formatQty(quantity1)).append("g ").append(foodItem1.getName());
        }
        
        // Item 2
        if (foodItem2 != null) {
            sb.append(" <span class='text-muted'>OR</span> ");
            sb.append(formatQty(quantity2)).append("g ").append(foodItem2.getName());
        }
        
        // Item 3
        if (foodItem3 != null) {
            sb.append(" <span class='text-muted'>OR</span> ");
            sb.append(formatQty(quantity3)).append("g ").append(foodItem3.getName());
        }

        // Item 4
        if (foodItem4 != null) {
            sb.append(" <span class='text-muted'>OR</span> ");
            sb.append(formatQty(quantity4)).append("g ").append(foodItem4.getName());
        }
        
        return sb.toString();
    }
    
    private String formatQty(double qty) {
        return qty == (long) qty ? String.valueOf((long) qty) : String.valueOf(qty);
    }
}
