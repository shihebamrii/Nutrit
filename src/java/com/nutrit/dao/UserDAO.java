package com.nutrit.dao;

import com.nutrit.models.User;
import com.nutrit.models.NutritionistProfile;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Data Access Object for utilisateurs table (French schema).
 * Handles all user operations including patients, nutritionists, secretaries, and administrators.
 */
public class UserDAO {
    
    // French role constants for the new schema
    public static final String ROLE_PATIENT = "patient";
    public static final String ROLE_NUTRITIONIST = "nutritionniste";
    public static final String ROLE_SECRETARY = "secretaire";
    public static final String ROLE_ADMIN = "administrateur";
    
    // French status constants
    public static final String STATUS_ACTIVE = "actif";
    public static final String STATUS_PENDING = "en_attente";
    public static final String STATUS_SUSPENDED = "suspendu";

    /**
     * Check if email already exists.
     */
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM utilisateurs WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Authenticate a user by email and password.
     */
    public User authenticate(String email, String password) {
        String sql = "SELECT * FROM utilisateurs WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("mot_de_passe");
                if (BCrypt.checkpw(password, hashedPassword)) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Register a new user with optional nutritionist profile data.
     */
    public boolean register(User user, NutritionistProfile profile) {
        if (emailExists(user.getEmail())) {
            System.err.println("Registration failed: Email " + user.getEmail() + " already exists.");
            return false;
        }

        String sql = "INSERT INTO utilisateurs (role, nom_complet, email, mot_de_passe, telephone, adresse, statut, " +
                     "specialisation, annees_experience, numero_licence, adresse_cabinet, tarif_consultation, biographie, " +
                     "nom_cabinet, gouvernorat, ville, specialites_multiples, langues_parlees, type_consultation, mots_cles, diplomes, latitude, longitude) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Convert role to French if needed
            String frenchRole = convertRoleToFrench(user.getRole());
            stmt.setString(1, frenchRole);
            stmt.setString(2, user.getFullName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getAddress());
            
            // Status: nutritionists need approval, others are active
            String status = ROLE_NUTRITIONIST.equals(frenchRole) ? STATUS_PENDING : STATUS_ACTIVE;
            stmt.setString(7, status);
            
            // Nutritionist-specific fields
            if (profile != null) {
                stmt.setString(8, profile.getSpecialization());
                stmt.setInt(9, profile.getYearsExperience());
                stmt.setString(10, profile.getLicenseNumber());
                stmt.setString(11, profile.getClinicAddress());
                stmt.setBigDecimal(12, profile.getPrice());
                stmt.setString(13, profile.getBio());
                stmt.setString(14, profile.getClinicName());
                stmt.setString(15, profile.getGovernorate());
                stmt.setString(16, profile.getCity());
                stmt.setString(17, profile.getMultipleSpecialties());
                stmt.setString(18, profile.getLanguages());
                stmt.setString(19, profile.getConsultationType());
                stmt.setString(20, profile.getKeywords());
                stmt.setString(21, profile.getDiplomas());
                stmt.setBigDecimal(22, profile.getLatitude());
                stmt.setBigDecimal(23, profile.getLongitude());
            } else {
                for(int i=8; i<=23; i++) stmt.setNull(i, Types.VARCHAR); // Simplified null setting (mostly varchar)
                // Adjust types if strict necessary but for simplicity in this large block:
                // 9 is int, 12 is decimal, 22,23 decimal. But setNull(i, VARCHAR) often works for all in some drivers, 
                // but better be safe:
                // We just set them null. 
                // Actually, let's just loop or set explicitly to be safe.
                stmt.setNull(8, Types.VARCHAR);
                stmt.setNull(9, Types.INTEGER);
                stmt.setNull(10, Types.VARCHAR);
                stmt.setNull(11, Types.VARCHAR);
                stmt.setNull(12, Types.DECIMAL);
                stmt.setNull(13, Types.VARCHAR);
                stmt.setNull(14, Types.VARCHAR);
                stmt.setNull(15, Types.VARCHAR);
                stmt.setNull(16, Types.VARCHAR);
                stmt.setNull(17, Types.VARCHAR);
                stmt.setNull(18, Types.VARCHAR);
                stmt.setNull(19, Types.VARCHAR);
                stmt.setNull(20, Types.VARCHAR);
                stmt.setNull(21, Types.VARCHAR);
                stmt.setNull(22, Types.DECIMAL);
                stmt.setNull(23, Types.DECIMAL);
            }
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Registration SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Register a new user (simple version without profile).
     */
    public boolean register(User user) {
        return register(user, null);
    }
    
    /**
     * Create a secretary linked to a nutritionist.
     */
    public boolean createSecretary(User secretary, int nutritionistId) {
        String sql = "INSERT INTO utilisateurs (role, nom_complet, email, mot_de_passe, telephone, adresse, statut, nutritionniste_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, ROLE_SECRETARY);
            stmt.setString(2, secretary.getFullName());
            stmt.setString(3, secretary.getEmail());
            stmt.setString(4, BCrypt.hashpw(secretary.getPassword(), BCrypt.gensalt()));
            stmt.setString(5, secretary.getPhone());
            stmt.setString(6, secretary.getAddress());
            stmt.setString(7, STATUS_ACTIVE);
            stmt.setInt(8, nutritionistId);
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        secretary.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get secretaries by nutritionist ID.
     */
    public List<User> getSecretariesByNutritionist(int nutritionistId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM utilisateurs WHERE role = ? AND nutritionniste_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ROLE_SECRETARY);
            stmt.setInt(2, nutritionistId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Update secretary details.
     */
    public boolean updateSecretary(User user) {
        String sql = "UPDATE utilisateurs SET nom_complet = ?, email = ?, telephone = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setInt(4, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getNutritionistIdBySecretary(int secretaryId) {
        String sql = "SELECT nutritionniste_id FROM utilisateurs WHERE id = ? AND role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, secretaryId);
            stmt.setString(2, ROLE_SECRETARY);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("nutritionniste_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Get user by ID.
     */
    public User getUserById(int id) {
        String sql = "SELECT * FROM utilisateurs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all active nutritionists.
     */
    public List<User> getNutritionists() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM utilisateurs WHERE role = ? AND statut = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ROLE_NUTRITIONIST);
            stmt.setString(2, STATUS_ACTIVE);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get nutritionist profile data (now embedded in User).
     */
    public NutritionistProfile getNutritionistProfile(int nutritionistId) {
        String sql = "SELECT * FROM utilisateurs WHERE id = ? AND role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nutritionistId);
            stmt.setString(2, ROLE_NUTRITIONIST);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                NutritionistProfile profile = new NutritionistProfile();
                profile.setId(rs.getInt("id"));
                profile.setSpecialization(rs.getString("specialisation"));
                profile.setYearsExperience(rs.getInt("annees_experience"));
                profile.setLicenseNumber(rs.getString("numero_licence"));
                profile.setClinicAddress(rs.getString("adresse_cabinet"));
                profile.setPrice(rs.getBigDecimal("tarif_consultation"));
                profile.setBio(rs.getString("biographie"));
                
                // New fields mapping - CRITICAL FIX
                profile.setClinicName(rs.getString("nom_cabinet"));
                profile.setGovernorate(rs.getString("gouvernorat"));
                profile.setCity(rs.getString("ville"));
                profile.setMultipleSpecialties(rs.getString("specialites_multiples"));
                profile.setLanguages(rs.getString("langues_parlees"));
                profile.setConsultationType(rs.getString("type_consultation"));
                profile.setKeywords(rs.getString("mots_cles"));
                profile.setDiplomas(rs.getString("diplomes"));
                profile.setLatitude(rs.getBigDecimal("latitude"));
                profile.setLongitude(rs.getBigDecimal("longitude"));

                return profile;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Count all users.
     */
    public int countAllUsers() {
        return countByQuery("SELECT COUNT(*) FROM utilisateurs");
    }

    /**
     * Get pending nutritionists awaiting approval.
     */
    public List<User> getPendingNutritionists() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM utilisateurs WHERE role = ? AND statut = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ROLE_NUTRITIONIST);
            stmt.setString(2, STATUS_PENDING);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Approve a nutritionist (change status from pending to active).
     */
    public boolean approveNutritionist(int id) {
        String sql = "UPDATE utilisateurs SET statut = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, STATUS_ACTIVE);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Count patients.
     */
    public int countPatients() {
        return countByQuery("SELECT COUNT(*) FROM utilisateurs WHERE role = '" + ROLE_PATIENT + "'");
    }

    /**
     * Count nutritionists.
     */
    public int countNutritionists() {
        return countByQuery("SELECT COUNT(*) FROM utilisateurs WHERE role = '" + ROLE_NUTRITIONIST + "'");
    }

    private int countByQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get recent users.
     */
    public List<User> getRecentUsers(int limit) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM utilisateurs ORDER BY date_creation DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get all users.
     */
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM utilisateurs ORDER BY date_creation DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Update basic user info.
     */
    public boolean updateBasicInfo(User user) {
        String sql = "UPDATE utilisateurs SET nom_complet = ?, telephone = ?, adresse = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getAddress());
            stmt.setInt(4, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update user password.
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE utilisateurs SET mot_de_passe = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update nutritionist profile.
     */
    public boolean updateNutritionistProfile(int userId, NutritionistProfile profile) {
        String sql = "UPDATE utilisateurs SET specialisation = ?, annees_experience = ?, numero_licence = ?, " +
                     "adresse_cabinet = ?, tarif_consultation = ?, biographie = ?, " +
                     "nom_cabinet = ?, gouvernorat = ?, ville = ?, specialites_multiples = ?, langues_parlees = ?, " +
                     "type_consultation = ?, mots_cles = ?, diplomes = ?, latitude = ?, longitude = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, profile.getSpecialization());
            stmt.setInt(2, profile.getYearsExperience());
            stmt.setString(3, profile.getLicenseNumber());
            stmt.setString(4, profile.getClinicAddress());
            stmt.setBigDecimal(5, profile.getPrice());
            stmt.setString(6, profile.getBio());
            
            stmt.setString(7, profile.getClinicName());
            stmt.setString(8, profile.getGovernorate());
            stmt.setString(9, profile.getCity());
            stmt.setString(10, profile.getMultipleSpecialties());
            stmt.setString(11, profile.getLanguages());
            stmt.setString(12, profile.getConsultationType());
            stmt.setString(13, profile.getKeywords());
            stmt.setString(14, profile.getDiplomas());
            stmt.setBigDecimal(15, profile.getLatitude());
            stmt.setBigDecimal(16, profile.getLongitude());
            
            stmt.setInt(17, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete user.
     */
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM utilisateurs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update profile details (bio and profile picture).
     */
    public boolean updateProfileDetails(int userId, String bio, String profilePicture) {
        StringBuilder sql = new StringBuilder("UPDATE utilisateurs SET biographie = ?");
        if (profilePicture != null) {
            sql.append(", photo_profil = ?");
        }
        sql.append(" WHERE id = ?");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            stmt.setString(1, bio);
            int paramIndex = 2;
            if (profilePicture != null) {
                stmt.setString(paramIndex++, profilePicture);
            }
            stmt.setInt(paramIndex, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Placeholder for backward compatibility.
     */
    public boolean updateUser(User user) {
        return updateBasicInfo(user);
    }

    /**
     * Map ResultSet to User object.
     */
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        
        // Convert French role back to English for application compatibility
        String frenchRole = rs.getString("role");
        user.setRole(convertRoleToEnglish(frenchRole));
        
        user.setFullName(rs.getString("nom_complet"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("mot_de_passe"));
        user.setPhone(rs.getString("telephone"));
        user.setAddress(rs.getString("adresse"));
        
        // Convert French status to English
        String frenchStatus = rs.getString("statut");
        user.setStatus(convertStatusToEnglish(frenchStatus));
        
        user.setCreatedAt(rs.getTimestamp("date_creation"));
        
        try {
            user.setProfilePicture(rs.getString("photo_profil"));
            user.setBio(rs.getString("biographie"));
        } catch (SQLException e) {
            // Columns might not exist in some queries
        }
        
        // If this is a nutritionist, attach the profile data
        if (ROLE_NUTRITIONIST.equals(frenchRole)) {
            NutritionistProfile profile = new NutritionistProfile();
            profile.setId(user.getId());
            profile.setSpecialization(rs.getString("specialisation"));
            profile.setYearsExperience(rs.getInt("annees_experience"));
            profile.setLicenseNumber(rs.getString("numero_licence"));
            profile.setClinicAddress(rs.getString("adresse_cabinet"));
            profile.setPrice(rs.getBigDecimal("tarif_consultation"));
            profile.setBio(rs.getString("biographie"));
            
            // New fields mapping - Fix for Search/Map Logic
            profile.setClinicName(rs.getString("nom_cabinet"));
            profile.setGovernorate(rs.getString("gouvernorat"));
            profile.setCity(rs.getString("ville"));
            profile.setMultipleSpecialties(rs.getString("specialites_multiples"));
            profile.setLanguages(rs.getString("langues_parlees"));
            profile.setConsultationType(rs.getString("type_consultation"));
            profile.setKeywords(rs.getString("mots_cles"));
            profile.setDiplomas(rs.getString("diplomes"));
            profile.setLatitude(rs.getBigDecimal("latitude"));
            profile.setLongitude(rs.getBigDecimal("longitude"));
            
            user.setNutritionistProfile(profile);
        }
        
        return user;
    }
    
    /**
     * Convert English role to French for database storage.
     */
    private String convertRoleToFrench(String englishRole) {
        if (englishRole == null) return ROLE_PATIENT;
        switch (englishRole.toLowerCase()) {
            case "nutritionist": return ROLE_NUTRITIONIST;
            case "secretary": return ROLE_SECRETARY;
            case "admin":
            case "administrator": return ROLE_ADMIN;
            default: return ROLE_PATIENT;
        }
    }
    
    /**
     * Convert French role to English for application use.
     */
    private String convertRoleToEnglish(String frenchRole) {
        if (frenchRole == null) return "patient";
        switch (frenchRole.toLowerCase()) {
            case "nutritionniste": return "nutritionist";
            case "secretaire": return "secretary";
            case "administrateur": return "admin";
            default: return "patient";
        }
    }
    
    /**
     * Convert French status to English for application use.
     */
    private String convertStatusToEnglish(String frenchStatus) {
        if (frenchStatus == null) return "active";
        switch (frenchStatus.toLowerCase()) {
            case "actif": return "active";
            case "en_attente": return "pending";
            case "suspendu": return "suspended";
            default: return "active";
        }
    }

    /**
     * Set a reset token for a user.
     */
    public boolean setResetToken(String email, String token) {
        String sql = "UPDATE utilisateurs SET reset_token = ?, reset_token_expiry = DATE_ADD(NOW(), INTERVAL 24 HOUR) WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Validate a reset token. Returns the user email if valid.
     */
    public String validateResetToken(String token) {
        String sql = "SELECT email FROM utilisateurs WHERE reset_token = ? AND reset_token_expiry > NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("email");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Update password using a reset token.
     */
    public boolean updatePasswordByToken(String token, String newPassword) {
        String sql = "UPDATE utilisateurs SET mot_de_passe = ?, reset_token = NULL, reset_token_expiry = NULL WHERE reset_token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            stmt.setString(2, token);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> searchNutritionists(String query, String governorate, String specialty, String type, String gender) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM utilisateurs WHERE role = ? AND statut = ?");
        List<Object> params = new ArrayList<>();
        params.add(ROLE_NUTRITIONIST);
        params.add(STATUS_ACTIVE);
        
        if (query != null && !query.trim().isEmpty()) {
            String q = "%" + query.trim() + "%";
            sql.append(" AND (nom_complet LIKE ? OR nom_cabinet LIKE ? OR gouvernorat LIKE ? OR ville LIKE ? OR adresse LIKE ? OR adresse_cabinet LIKE ? OR specialisation LIKE ? OR specialites_multiples LIKE ? OR mots_cles LIKE ? OR langues_parlees LIKE ? OR diplomes LIKE ? OR biographie LIKE ?)");
            for(int i=0; i<12; i++) params.add(q);
        }
        
        if (governorate != null && !governorate.isEmpty()) {
            sql.append(" AND gouvernorat = ?");
            params.add(governorate);
        }
        
        if (specialty != null && !specialty.isEmpty()) {
            sql.append(" AND (specialisation LIKE ? OR specialites_multiples LIKE ?)");
            params.add("%"+specialty+"%");
            params.add("%"+specialty+"%");
        }

        if (gender != null && !gender.isEmpty()) {
            sql.append(" AND genre = ?");
            params.add(gender);
        }
        
        if (type != null && !type.isEmpty()) {
            // type could be 'en_ligne', 'presentiel', 'hybride', or 'both'
            // logic needed based on how we store it.
            // If stored as enum: 'en_ligne','presentiel','hybride'.
            // If user searches 'Online', we match 'en_ligne' or 'hybride'.
            // If user searches 'In-person', we match 'presentiel' or 'hybride'.
            
            if ("online".equalsIgnoreCase(type) || "en_ligne".equalsIgnoreCase(type)) {
                sql.append(" AND (type_consultation = 'en_ligne' OR type_consultation = 'hybride')");
            } else if ("person".equalsIgnoreCase(type) || "presentiel".equalsIgnoreCase(type)) {
                sql.append(" AND (type_consultation = 'presentiel' OR type_consultation = 'hybride')");
            }
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get featured nutritionists (limit 3) with their ratings and profiles.
     */
    public List<User> getFeaturedNutritionists(int limit) {
        List<User> list = new ArrayList<>();
        // Select random active nutritionists
        String sql = "SELECT * FROM utilisateurs WHERE role = ? AND statut = ? ORDER BY RAND() LIMIT ?";
        
        NutritionistReviewDAO reviewDAO = new NutritionistReviewDAO();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ROLE_NUTRITIONIST);
            stmt.setString(2, STATUS_ACTIVE);
            stmt.setInt(3, limit);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = mapUser(rs);
                if (user.getNutritionistProfile() != null) {
                    double avgRating = reviewDAO.getAverageRating(user.getId());
                    int count = reviewDAO.getReviewCount(user.getId());
                    user.getNutritionistProfile().setAverageRating(avgRating > 0 ? avgRating : 4.5 + (Math.random() * 0.5)); // Fallback for demo if no reviews
                    user.getNutritionistProfile().setReviewCount(count > 0 ? count : 10 + (int)(Math.random() * 100)); // Fallback
                }
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * Get distinct specializations from nutritionists.
     */
    public List<String> getDistinctSpecializations() {
        List<String> list = new ArrayList<>();
        // Check for both French and English role names to ensure compatibility
        String sql = "SELECT DISTINCT specialisation FROM utilisateurs WHERE (role = 'nutritionniste' OR role = 'nutritionist') AND specialisation IS NOT NULL AND specialisation != '' ORDER BY specialisation";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            // No parameters needed as we hardcoded the OR condition for simplicity and robustness
            System.out.println("DEBUG: Executing spec query for dual roles");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("specialisation"));
            }
            System.out.println("DEBUG: Found " + list.size() + " specs");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get distinct governorates from nutritionists.
     */
    public List<String> getDistinctGovernorates() {
        List<String> list = new ArrayList<>();
        // Check for both French and English role names
        String sql = "SELECT DISTINCT gouvernorat FROM utilisateurs WHERE (role = 'nutritionniste' OR role = 'nutritionist') AND gouvernorat IS NOT NULL AND gouvernorat != '' ORDER BY gouvernorat";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("gouvernorat"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
