package com.nutrit.dao;

import com.nutrit.models.NutritionistAvailability;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.DayOfWeek;
import java.time.format.TextStyle;
import java.util.Locale;

/**
 * Data Access Object for disponibilites table (French schema).
 * Manages nutritionist availability schedules.
 */
public class NutritionistAvailabilityDAO {
    
    // French day names for the database
    private static final String[] FRENCH_DAYS = {
        "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"
    };

    /**
     * Get all availability slots for a nutritionist.
     */
    public List<NutritionistAvailability> getAvailabilityByNutritionist(int nutritionistId) {
        List<NutritionistAvailability> slots = new ArrayList<>();
        String sql = "SELECT * FROM disponibilites WHERE nutritionniste_id = ? AND est_actif = TRUE ORDER BY FIELD(jour_semaine, 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                slots.add(mapAvailability(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return slots;
    }

    /**
     * Get availability for a specific day.
     */
    public NutritionistAvailability getAvailabilityForDay(int nutritionistId, String dayOfWeek) {
        String frenchDay = convertDayToFrench(dayOfWeek);
        String sql = "SELECT * FROM disponibilites WHERE nutritionniste_id = ? AND jour_semaine = ? AND est_actif = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setString(2, frenchDay);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapAvailability(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Save or update availability for a day.
     */
    public boolean saveAvailability(NutritionistAvailability slot) {
        String frenchDay = convertDayToFrench(slot.getDayOfWeek());
        
        // Check if exists
        NutritionistAvailability existing = getAvailabilityForDay(slot.getNutritionistId(), slot.getDayOfWeek());
        
        String sql;
        if (existing == null) {
            sql = "INSERT INTO disponibilites (nutritionniste_id, jour_semaine, heure_debut, heure_fin, duree_creneau_minutes, est_actif) " +
                  "VALUES (?, ?, ?, ?, ?, TRUE)";
        } else {
            sql = "UPDATE disponibilites SET heure_debut = ?, heure_fin = ?, duree_creneau_minutes = ?, est_actif = TRUE " +
                  "WHERE nutritionniste_id = ? AND jour_semaine = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (existing == null) {
                stmt.setInt(1, slot.getNutritionistId());
                stmt.setString(2, frenchDay);
                stmt.setTime(3, slot.getStartTime());
                stmt.setTime(4, slot.getEndTime());
                stmt.setInt(5, slot.getSlotDuration());
            } else {
                stmt.setTime(1, slot.getStartTime());
                stmt.setTime(2, slot.getEndTime());
                stmt.setInt(3, slot.getSlotDuration());
                stmt.setInt(4, slot.getNutritionistId());
                stmt.setString(5, frenchDay);
            }
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete availability for a day.
     */
    public boolean deleteAvailability(int nutritionistId, String dayOfWeek) {
        String frenchDay = convertDayToFrench(dayOfWeek);
        String sql = "UPDATE disponibilites SET est_actif = FALSE WHERE nutritionniste_id = ? AND jour_semaine = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setString(2, frenchDay);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get available time slots for a specific date.
     */
    public List<java.sql.Timestamp> getAvailableSlotsForDate(int nutritionistId, java.util.Date date) {
        List<java.sql.Timestamp> slots = new ArrayList<>();
        
        LocalDate localDate = new java.sql.Date(date.getTime()).toLocalDate();
        DayOfWeek dayOfWeek = localDate.getDayOfWeek();
        String frenchDay = FRENCH_DAYS[dayOfWeek.getValue() - 1];
        
        // Get availability for the day
        String sql = "SELECT * FROM disponibilites WHERE nutritionniste_id = ? AND jour_semaine = ? AND est_actif = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setString(2, frenchDay);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Time startTime = rs.getTime("heure_debut");
                Time endTime = rs.getTime("heure_fin");
                int slotDuration = rs.getInt("duree_creneau_minutes");
                
                LocalTime start = startTime.toLocalTime();
                LocalTime end = endTime.toLocalTime();
                
                // Get booked slots for this date (as strings for comparison)
                List<String> bookedSlots = getBookedSlotsForDate(nutritionistId, date);
                
                // Generate available slots as Timestamps
                while (start.plusMinutes(slotDuration).compareTo(end) <= 0) {
                    
                    // IF checking today, skip slots that are in the past
                    if (localDate.equals(LocalDate.now()) && start.isBefore(LocalTime.now())) {
                        start = start.plusMinutes(slotDuration);
                        continue;
                    }
                    
                    String slotTime = start.toString();
                    if (!bookedSlots.contains(slotTime)) {
                        // Create Timestamp from LocalDate and LocalTime
                        java.time.LocalDateTime dateTime = java.time.LocalDateTime.of(localDate, start);
                        java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(dateTime);
                        slots.add(timestamp);
                    }
                    start = start.plusMinutes(slotDuration);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return slots;
    }

    /**
     * Get booked slots for a specific date.
     */
    public List<String> getBookedSlotsForDate(int nutritionistId, java.util.Date date) {
        List<String> bookedSlots = new ArrayList<>();
        String sql = "SELECT TIME(date_heure_prevue) as slot_time FROM rendez_vous " +
                     "WHERE nutritionniste_id = ? AND DATE(date_heure_prevue) = ? AND statut != 'annule'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setDate(2, new java.sql.Date(date.getTime()));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Time slotTime = rs.getTime("slot_time");
                if (slotTime != null) {
                    bookedSlots.add(slotTime.toLocalTime().toString());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedSlots;
    }

    /**
     * Get the next available slot for a nutritionist.
     */
    public java.sql.Timestamp getNextAvailableSlot(int nutritionistId) {
        LocalDate today = LocalDate.now();
        for (int i = 0; i < 14; i++) {
            LocalDate checkDate = today.plusDays(i);
            java.util.Date date = java.sql.Date.valueOf(checkDate);
            List<java.sql.Timestamp> slots = getAvailableSlotsForDate(nutritionistId, date);
            if (!slots.isEmpty()) {
                return slots.get(0);
            }
        }
        return null;
    }

    /**
     * Map ResultSet to NutritionistAvailability object.
     */
    private NutritionistAvailability mapAvailability(ResultSet rs) throws SQLException {
        NutritionistAvailability slot = new NutritionistAvailability();
        slot.setId(rs.getInt("id"));
        slot.setNutritionistId(rs.getInt("nutritionniste_id"));
        
        // Convert French day to English
        String frenchDay = rs.getString("jour_semaine");
        slot.setDayOfWeek(convertDayToEnglish(frenchDay));
        
        slot.setStartTime(rs.getTime("heure_debut"));
        slot.setEndTime(rs.getTime("heure_fin"));
        slot.setSlotDuration(rs.getInt("duree_creneau_minutes"));
        slot.setAvailable(rs.getBoolean("est_actif"));
        
        return slot;
    }
    
    /**
     * Convert English day name to French.
     */
    private String convertDayToFrench(String englishDay) {
        if (englishDay == null) return "lundi";
        switch (englishDay.toLowerCase()) {
            case "monday": return "lundi";
            case "tuesday": return "mardi";
            case "wednesday": return "mercredi";
            case "thursday": return "jeudi";
            case "friday": return "vendredi";
            case "saturday": return "samedi";
            case "sunday": return "dimanche";
            default: return englishDay.toLowerCase(); // Already French
        }
    }
    
    /**
     * Convert French day name to English.
     */
    private String convertDayToEnglish(String frenchDay) {
        if (frenchDay == null) return "Monday";
        switch (frenchDay.toLowerCase()) {
            case "lundi": return "Monday";
            case "mardi": return "Tuesday";
            case "mercredi": return "Wednesday";
            case "jeudi": return "Thursday";
            case "vendredi": return "Friday";
            case "samedi": return "Saturday";
            case "dimanche": return "Sunday";
            default: return frenchDay;
        }
    }
}
