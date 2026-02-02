package com.nutrit.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        // Check for environment variables (Cloud hosting support)
        String envUrl = System.getenv("DB_URL");
        String envUser = System.getenv("DB_USER");
        String envPassword = System.getenv("DB_PASSWORD");

        if (envUrl != null && !envUrl.isEmpty()) {
            URL = envUrl;
            USER = envUser != null ? envUser : "root";
            PASSWORD = envPassword != null ? envPassword : "";
        } else {
            // Localhost fallback
            URL = "jdbc:mysql://localhost:3306/nutrit?useSSL=false&serverTimezone=UTC";
            USER = "root";
            PASSWORD = ""; 
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error loading MySQL Driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
