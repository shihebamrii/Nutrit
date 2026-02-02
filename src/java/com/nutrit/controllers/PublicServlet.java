package com.nutrit.controllers;

import com.nutrit.dao.UserDAO;
import com.nutrit.models.User;
import com.nutrit.models.NutritionistProfile;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.nutrit.dao.NutritionistAvailabilityDAO;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;   
import java.io.IOException;
import java.util.List;

/**
 * Servlet for public pages - browsing nutritionists without login
 */
@WebServlet(urlPatterns = {"/experts", "/profile/*"})
public class PublicServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if ("/experts".equals(path)) {
            showNutritionistsList(request, response);
        } else if ("/profile".equals(path) && pathInfo != null) {
            showNutritionistProfile(request, response, pathInfo);
        } else {
            response.sendRedirect(request.getContextPath() + "/experts");
        }
    }

    private void showNutritionistsList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        
        // Get filter parameters
        String query = request.getParameter("q");
        String governorate = request.getParameter("gov");
        String specialization = request.getParameter("spec");
        String type = request.getParameter("type");
        String gender = request.getParameter("gender");
        
        // Use DAO search
        List<User> nutritionists = userDAO.searchNutritionists(query, governorate, specialization, type, gender);
        
        // Get profiles (already attached in mapUser but ensure consistency if mapUser is sufficient)
        // UserDAO.mapUser attahces proper profile now.
        
        // Pass params back to view for inputs
        request.setAttribute("paramQuery", query);
        request.setAttribute("paramGov", governorate);
        request.setAttribute("paramSpec", specialization);
        request.setAttribute("paramType", type);
        request.setAttribute("paramGender", gender);
        
        // Prepare JSON for the map
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < nutritionists.size(); i++) {
            User n = nutritionists.get(i);
            NutritionistProfile p = n.getNutritionistProfile();
            if (p != null && p.getLatitude() != null && p.getLongitude() != null) {
                if (json.length() > 1) json.append(",");
                json.append("{")
                    .append("\"id\":").append(n.getId()).append(",")
                    .append("\"name\":\"").append(n.getFullName().replace("\"", "\\\"")).append("\",")
                    .append("\"clinic\":\"").append(p.getClinicName() != null ? p.getClinicName().replace("\"", "\\\"") : "").append("\",")
                    .append("\"specialty\":\"").append(p.getSpecialization() != null ? p.getSpecialization().replace("\"", "\\\"") : "").append("\",")
                    .append("\"lat\":").append(p.getLatitude()).append(",")
                    .append("\"lng\":").append(p.getLongitude())
                    .append("}");
            }
        }
        json.append("]");
        request.setAttribute("mapDataJson", json.toString());
        
        request.setAttribute("nutritionists", nutritionists);
        request.setAttribute("totalCount", nutritionists.size());
        
        // Populate filter dropdowns dynamically
        request.setAttribute("specializations", userDAO.getDistinctSpecializations());
        request.setAttribute("governorates", userDAO.getDistinctGovernorates());
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/public/nutritionists.jsp");
        dispatcher.forward(request, response);
    }

    private void showNutritionistProfile(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        
        try {
            // Extract ID from path (e.g., /123)
            int nutritionistId = Integer.parseInt(pathInfo.substring(1));
            
            User nutritionist = userDAO.getUserById(nutritionistId);
            
            if (nutritionist == null || !"nutritionist".equals(nutritionist.getRole())) {
                response.sendRedirect(request.getContextPath() + "/experts");
                return;
            }
            
            NutritionistProfile profile = userDAO.getNutritionistProfile(nutritionistId);
            nutritionist.setNutritionistProfile(profile);
            
            request.setAttribute("nutritionist", nutritionist);
            request.setAttribute("profile", profile);

            // Get availability for next 14 days (copied logic from PatientServlet to expose public availability)
            NutritionistAvailabilityDAO availDAO = new NutritionistAvailabilityDAO();
            Map<String, List<Timestamp>> availableSlots = new LinkedHashMap<>();
            
            LocalDate startDate = LocalDate.now();
            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("EEE, MMM dd, yyyy");
            
            for (int i = 0; i < 14; i++) {
                LocalDate checkDate = startDate.plusDays(i);
                java.util.Date date = java.sql.Date.valueOf(checkDate);
                List<Timestamp> slots = availDAO.getAvailableSlotsForDate(nutritionistId, date);
                if (!slots.isEmpty()) {
                    String dateKey = dateFormat.format(date);
                    availableSlots.put(dateKey, slots);
                }
            }
            request.setAttribute("availableSlots", availableSlots);
            
            // Get secretaries for this nutritionist to display contact info
            List<User> secretaries = userDAO.getSecretariesByNutritionist(nutritionistId);
            request.setAttribute("secretaries", secretaries);

            // Get next available slot for quick display
            Timestamp nextSlot = availDAO.getNextAvailableSlot(nutritionistId);
            request.setAttribute("nextAvailableSlot", nextSlot);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/public/nutritionist-profile.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/experts");
        }
    }
}
