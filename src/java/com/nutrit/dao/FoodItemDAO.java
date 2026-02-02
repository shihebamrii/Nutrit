package com.nutrit.dao;

import com.nutrit.models.FoodItem;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for aliments table (French schema).
 * Handles all food item operations for meal planning.
 */
public class FoodItemDAO {

    /**
     * Get all active food items.
     */
    public List<FoodItem> getAllFoodItems() {
        List<FoodItem> items = new ArrayList<>();
        String sql = "SELECT * FROM aliments WHERE est_actif = TRUE ORDER BY categorie, nom_fr";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                items.add(mapFoodItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Get food items by category.
     */
    public List<FoodItem> getFoodItemsByCategory(String category) {
        List<FoodItem> items = new ArrayList<>();
        String sql = "SELECT * FROM aliments WHERE categorie = ? AND est_actif = TRUE ORDER BY nom_fr";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(mapFoodItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Search food items by name (partial match in French or Arabic).
     */
    public List<FoodItem> searchFoodItems(String query) {
        List<FoodItem> items = new ArrayList<>();
        String sql = "SELECT * FROM aliments WHERE (nom_fr LIKE ? OR nom_ar LIKE ?) AND est_actif = TRUE ORDER BY nom_fr LIMIT 50";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(mapFoodItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Get a single food item by ID.
     */
    public FoodItem getFoodItemById(int id) {
        String sql = "SELECT * FROM aliments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapFoodItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all distinct categories.
     */
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT categorie FROM aliments WHERE est_actif = TRUE ORDER BY categorie";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("categorie"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Add a new food item (admin feature).
     */
    public boolean addFoodItem(FoodItem item) {
        String sql = "INSERT INTO aliments (nom_fr, nom_ar, categorie, calories_100g, proteines_g, glucides_g, lipides_g, est_actif) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, TRUE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, item.getName());
            stmt.setString(2, item.getNameAr());
            stmt.setString(3, item.getCategory());
            stmt.setInt(4, item.getCaloriesPer100g());
            stmt.setDouble(5, item.getProteinG());
            stmt.setDouble(6, item.getCarbsG());
            stmt.setDouble(7, item.getFatG());
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    item.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Count total food items.
     */
    public int countFoodItems() {
        String sql = "SELECT COUNT(*) FROM aliments WHERE est_actif = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Map ResultSet to FoodItem object.
     * Note: The FoodItem model uses English field names for compatibility.
     */
    private FoodItem mapFoodItem(ResultSet rs) throws SQLException {
        FoodItem item = new FoodItem();
        item.setId(rs.getInt("id"));
        item.setName(rs.getString("nom_fr"));
        item.setNameAr(rs.getString("nom_ar"));
        item.setCategory(rs.getString("categorie"));
        item.setIdealMoment(rs.getString("moment_ideal")); // Load ideal meal time
        
        // Load portion unit and default portion (with safe fallback)
        try {
            String unit = rs.getString("unite_portion");
            item.setPortionUnit(unit != null ? unit : "g");
            item.setDefaultPortion(rs.getInt("portion_defaut"));
        } catch (SQLException e) {
            // Columns may not exist yet - use defaults
            item.setPortionUnit("g");
            item.setDefaultPortion(100);
        }
        
        item.setCaloriesPer100g(rs.getInt("calories_100g"));
        item.setProteinG(rs.getDouble("proteines_g"));
        item.setCarbsG(rs.getDouble("glucides_g"));
        item.setFatG(rs.getDouble("lipides_g"));
        // Note: fiber_g and description are not in new schema
        item.setFiberG(0);
        item.setDescription("");
        item.setActive(rs.getBoolean("est_actif"));
        
        // Load image path (with safe fallback)
        try {
            item.setImagePath(rs.getString("image_path"));
        } catch (SQLException e) {
            // Column may not exist yet - leave null
            item.setImagePath(null);
        }
        
        // Note: created_at is not in new schema
        item.setCreatedAt(null);
        return item;
    }
}
