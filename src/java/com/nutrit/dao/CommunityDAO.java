package com.nutrit.dao;

import com.nutrit.models.CommunityPost;
import com.nutrit.models.User;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for community posts (French schema).
 * Uses the 'interactions' table with type_interaction = 'publication'.
 * 
 * NOTE: The new French schema consolidates posts into the 'interactions' table
 * and does NOT include separate tables for likes, comments, bookmarks, or follows.
 * These social features are currently simplified/disabled until additional tables are added.
 */
public class CommunityDAO {

    private static final String TYPE_PUBLICATION = "publication";

    /**
     * Get all posts.
     * @param currentUserId The ID of the current user (for context), or -1 if not logged in
     */
    public List<CommunityPost> getAllPosts(int currentUserId) {
        List<CommunityPost> posts = new ArrayList<>();
        String sql = "SELECT i.*, u.nom_complet as patient_name, u.photo_profil as patient_profile_picture " +
                     "FROM interactions i " +
                     "JOIN utilisateurs u ON i.expediteur_id = u.id " +
                     "WHERE i.type_interaction = ? " +
                     "ORDER BY i.date_creation DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_PUBLICATION);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CommunityPost post = mapResultSetToPost(rs, currentUserId);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    /**
     * Get posts by a specific user.
     */
    public List<CommunityPost> getPostsByUser(int userId, int currentUserId) {
        List<CommunityPost> posts = new ArrayList<>();
        String sql = "SELECT i.*, u.nom_complet as patient_name, u.photo_profil as patient_profile_picture " +
                     "FROM interactions i " +
                     "JOIN utilisateurs u ON i.expediteur_id = u.id " +
                     "WHERE i.type_interaction = ? AND i.expediteur_id = ? " +
                     "ORDER BY i.date_creation DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_PUBLICATION);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CommunityPost post = mapResultSetToPost(rs, currentUserId);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    /**
     * Get a single post by ID.
     */
    public CommunityPost getPostById(int postId, int currentUserId) {
        String sql = "SELECT i.*, u.nom_complet as patient_name, u.photo_profil as patient_profile_picture " +
                     "FROM interactions i " +
                     "JOIN utilisateurs u ON i.expediteur_id = u.id " +
                     "WHERE i.id = ? AND i.type_interaction = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            stmt.setString(2, TYPE_PUBLICATION);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToPost(rs, currentUserId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private CommunityPost mapResultSetToPost(ResultSet rs) throws SQLException {
        CommunityPost post = new CommunityPost();
        post.setId(rs.getInt("id"));
        post.setPatientId(rs.getInt("expediteur_id"));
        post.setContent(rs.getString("contenu"));
        post.setImage(rs.getString("image_jointe"));
        post.setCreatedAt(rs.getTimestamp("date_creation"));
        post.setPatientName(rs.getString("patient_name"));
        try {
            post.setPatientProfilePicture(rs.getString("patient_profile_picture"));
        } catch (SQLException e) {
            // Column may not exist
        }
        // Social features not available in new schema
        // Social features
        post.setLikeCount(getLikeCount(post.getId()));
        post.setCommentCount(getCommentCount(post.getId()));
        
        // Contextual user data not passed yet, need to fix method signature or use other method
        // For now, simpler retrieval
        post.setUserHasLiked(false); 
        
        return post;
    }
    
    private CommunityPost mapResultSetToPost(ResultSet rs, int currentUserId) throws SQLException {
        CommunityPost post = mapResultSetToPost(rs);
        if (currentUserId > 0) {
            post.setUserHasLiked(hasUserLiked(post.getId(), currentUserId));
            // post.setUserHasBookmarked(hasUserBookmarked(post.getId(), currentUserId)); // Tables missing for now
        }
        return post;
    }
    
    /**
     * Legacy method - get all posts without user context.
     */
    public List<CommunityPost> getAllPosts() {
        return getAllPosts(-1);
    }

    /**
     * Create a new post.
     */
    public boolean createPost(CommunityPost post) {
        String sql = "INSERT INTO interactions (type_interaction, expediteur_id, contenu, image_jointe) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, TYPE_PUBLICATION);
            stmt.setInt(2, post.getPatientId());
            stmt.setString(3, post.getContent());
            stmt.setString(4, post.getImage());
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    post.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a post - only owner or admin can delete.
     */
    public boolean deletePost(int postId, int userId, boolean isAdmin) {
        String sql;
        if (isAdmin) {
            sql = "DELETE FROM interactions WHERE id = ? AND type_interaction = ?";
        } else {
            sql = "DELETE FROM interactions WHERE id = ? AND type_interaction = ? AND expediteur_id = ?";
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            stmt.setString(2, TYPE_PUBLICATION);
            if (!isAdmin) {
                stmt.setInt(3, userId);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ==================== LIKES (Disabled - no table in new schema) ====================
    
    // ==================== LIKES (Refactored for Single Schema) ====================
    // Mapped to 'interactions' table: type='avis', content='LIKE', destinataire_id=post_id, note_etoiles=NULL
    
    public boolean toggleLike(int postId, int userId) {
        if (hasUserLiked(postId, userId)) {
            return removeLike(postId, userId);
        } else {
            return addLike(postId, userId);
        }
    }
    
    public boolean hasUserLiked(int postId, int userId) {
        String sql = "SELECT 1 FROM interactions WHERE type_interaction = 'avis' AND destinataire_id = ? AND expediteur_id = ? AND contenu = 'LIKE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean addLike(int postId, int userId) {
        String sql = "INSERT INTO interactions (type_interaction, expediteur_id, destinataire_id, contenu, note_etoiles) VALUES ('avis', ?, ?, 'LIKE', NULL)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, postId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean removeLike(int postId, int userId) {
        String sql = "DELETE FROM interactions WHERE type_interaction = 'avis' AND destinataire_id = ? AND expediteur_id = ? AND contenu = 'LIKE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getLikeCount(int postId) {
        String sql = "SELECT COUNT(*) FROM interactions WHERE type_interaction = 'avis' AND destinataire_id = ? AND contenu = 'LIKE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ==================== COMMENTS (Refactored for Single Schema) ====================
    // Mapped to 'interactions' table: type='avis', content!=LIKE, destinataire_id=post_id, note_etoiles=NULL
    
    public boolean addComment(int postId, int userId, String content) {
        String sql = "INSERT INTO interactions (type_interaction, expediteur_id, destinataire_id, contenu, note_etoiles) VALUES ('avis', ?, ?, ?, NULL)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, postId);
            stmt.setString(3, content);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteComment(int commentId, int userId) {
        String sql = "DELETE FROM interactions WHERE id = ? AND expediteur_id = ? AND type_interaction = 'avis'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, commentId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public java.util.List<com.nutrit.models.PostComment> getCommentsByPostId(int postId) {
        java.util.List<com.nutrit.models.PostComment> comments = new java.util.ArrayList<>();
        // Only select where note_etoiles IS NULL to avoid mixing with Nutritionist Reviews
        String sql = "SELECT i.*, u.nom_complet as user_name " +
                     "FROM interactions i " +
                     "JOIN utilisateurs u ON i.expediteur_id = u.id " +
                     "WHERE i.type_interaction = 'avis' AND i.destinataire_id = ? AND i.contenu != 'LIKE' AND i.note_etoiles IS NULL " +
                     "ORDER BY i.date_creation ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    com.nutrit.models.PostComment comment = new com.nutrit.models.PostComment();
                    comment.setId(rs.getInt("id"));
                    comment.setPostId(rs.getInt("destinataire_id"));
                    comment.setUserId(rs.getInt("expediteur_id"));
                    comment.setContent(rs.getString("contenu"));
                    comment.setCreatedAt(rs.getTimestamp("date_creation"));
                    comment.setUserName(rs.getString("user_name"));
                    comments.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }
    
    public int getCommentCount(int postId) {
        String sql = "SELECT COUNT(*) FROM interactions WHERE type_interaction = 'avis' AND destinataire_id = ? AND contenu != 'LIKE' AND note_etoiles IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ==================== BOOKMARKS (Disabled) ====================
    
    public boolean toggleBookmark(int postId, int userId) {
        return false;
    }
    
    public boolean hasUserBookmarked(int postId, int userId) {
        return false;
    }
    
    public boolean addBookmark(int postId, int userId) {
        return false;
    }
    
    public boolean removeBookmark(int postId, int userId) {
        return false;
    }
    
    public int getBookmarkCount(int postId) {
        return 0;
    }
    
    public List<CommunityPost> getBookmarkedPosts(int userId) {
        return new ArrayList<>();
    }
    
    // ==================== REPORTS (Disabled) ====================
    
    public boolean createReport(int postId, int reporterId, String reason, String description) {
        return false;
    }
    
    public boolean hasUserReported(int postId, int userId) {
        return false;
    }
    
    public List<com.nutrit.models.PostReport> getAllReports() {
        return new ArrayList<>();
    }
    
    public List<com.nutrit.models.PostReport> getPendingReports() {
        return new ArrayList<>();
    }
    
    public int getReportCountByStatus(String status) {
        return 0;
    }
    
    public boolean updateReportStatus(int reportId, String status, int reviewedBy) {
        return false;
    }
    
    // ==================== USER FOLLOWS (Disabled) ====================
    
    public boolean toggleFollow(int followerId, int followingId) {
        if (isFollowing(followerId, followingId)) {
            return unfollowUser(followerId, followingId);
        } else {
            return followUser(followerId, followingId);
        }
    }
    
    public boolean isFollowing(int followerId, int followingId) {
        String sql = "SELECT 1 FROM interactions WHERE type_interaction = 'follow' AND expediteur_id = ? AND destinataire_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, followerId);
            stmt.setInt(2, followingId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean followUser(int followerId, int followingId) {
        String sql = "INSERT INTO interactions (type_interaction, expediteur_id, destinataire_id, contenu) VALUES ('follow', ?, ?, 'FOLLOW')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, followerId);
            stmt.setInt(2, followingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean unfollowUser(int followerId, int followingId) {
        String sql = "DELETE FROM interactions WHERE type_interaction = 'follow' AND expediteur_id = ? AND destinataire_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, followerId);
            stmt.setInt(2, followingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getFollowersCount(int userId) {
        String sql = "SELECT COUNT(*) FROM interactions WHERE type_interaction = 'follow' AND destinataire_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getFollowingCount(int userId) {
        String sql = "SELECT COUNT(*) FROM interactions WHERE type_interaction = 'follow' AND expediteur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getPostCount(int userId) {
        String sql = "SELECT COUNT(*) FROM interactions WHERE expediteur_id = ? AND type_interaction = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, TYPE_PUBLICATION);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<CommunityPost> getTrendingPosts(int currentUserId, int limit) {
        // Without detailed stats table, return most recent
        List<CommunityPost> posts = getAllPosts(currentUserId);
        if (posts.size() > limit) {
            return posts.subList(0, limit);
        }
        return posts;
    }
    
    public List<User> getFollowers(int userId) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.* FROM utilisateurs u " +
                     "JOIN interactions i ON u.id = i.expediteur_id " +
                     "WHERE i.type_interaction = 'follow' AND i.destinataire_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public List<User> getFollowing(int userId) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.* FROM utilisateurs u " +
                     "JOIN interactions i ON u.id = i.destinataire_id " +
                     "WHERE i.type_interaction = 'follow' AND i.expediteur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public List<User> getFriends(int userId) {
        List<User> users = new ArrayList<>();
        // Mutual follows
        String sql = "SELECT u.* FROM utilisateurs u " +
                     "JOIN interactions i1 ON u.id = i1.expediteur_id " + // They follow me
                     "JOIN interactions i2 ON u.id = i2.destinataire_id " + // I follow them
                     "WHERE i1.type_interaction = 'follow' AND i1.destinataire_id = ? " +
                     "AND i2.type_interaction = 'follow' AND i2.expediteur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("nom_complet"));
        user.setRole(rs.getString("role"));
        user.setProfilePicture(rs.getString("photo_profil"));
        return user;
    }
}
