package com.nutrit.dao;

import com.nutrit.models.ChatMessage;
import com.nutrit.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for chat messages (French schema).
 * Uses the 'interactions' table with type_interaction = 'chat'.
 */
public class ChatDAO {

    private static final String TYPE_CHAT = "chat";

    /**
     * Get conversation between two users.
     */
    public List<ChatMessage> getConversation(int user1Id, int user2Id) {
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT * FROM interactions " +
                     "WHERE type_interaction = ? " +
                     "AND ((expediteur_id = ? AND destinataire_id = ?) OR (expediteur_id = ? AND destinataire_id = ?)) " +
                     "ORDER BY date_creation ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_CHAT);
            stmt.setInt(2, user1Id);
            stmt.setInt(3, user2Id);
            stmt.setInt(4, user2Id);
            stmt.setInt(5, user1Id);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ChatMessage msg = new ChatMessage();
                msg.setId(rs.getInt("id"));
                msg.setSenderId(rs.getInt("expediteur_id"));
                msg.setReceiverId(rs.getInt("destinataire_id"));
                msg.setMessage(rs.getString("contenu"));
                msg.setRead(rs.getBoolean("est_lu"));
                msg.setCreatedAt(rs.getTimestamp("date_creation"));
                messages.add(msg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    /**
     * Send a chat message.
     */
    public boolean sendMessage(ChatMessage msg) {
        String sql = "INSERT INTO interactions (type_interaction, expediteur_id, destinataire_id, contenu, est_lu) " +
                     "VALUES (?, ?, ?, ?, FALSE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, TYPE_CHAT);
            stmt.setInt(2, msg.getSenderId());
            stmt.setInt(3, msg.getReceiverId());
            stmt.setString(4, msg.getMessage());
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    msg.setId(rs.getInt(1));
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
     * Mark messages as read.
     */
    public boolean markAsRead(int senderId, int receiverId) {
        String sql = "UPDATE interactions SET est_lu = TRUE " +
                     "WHERE type_interaction = ? AND expediteur_id = ? AND destinataire_id = ? AND est_lu = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_CHAT);
            stmt.setInt(2, senderId);
            stmt.setInt(3, receiverId);
            return stmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get unread message count.
     */
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM interactions " +
                     "WHERE type_interaction = ? AND destinataire_id = ? AND est_lu = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, TYPE_CHAT);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
