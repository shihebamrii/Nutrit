package com.nutrit.listeners;

import com.nutrit.utils.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Run schema updates
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Add notes column to appointments if missing
            try {
                stmt.execute("ALTER TABLE appointments ADD COLUMN notes TEXT");
                System.out.println("Schema update: Added notes column to appointments table.");
            } catch (Exception e) {
                // Ignore if column already exists or other non-critical error
                System.out.println("Schema update info: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
