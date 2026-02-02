package com.nutrit.controllers;

import com.nutrit.dao.*;
import com.nutrit.models.*;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.*;

/**
 * Servlet for handling meal plan operations.
 * Replaces the old DietServlet with new flexible meal assignment system.
 */
@WebServlet(urlPatterns = {
    "/nutritionist/mealPlan",
    "/nutritionist/mealPlan/create",
    "/nutritionist/mealPlan/delete",
    "/patient/mealPlan",
    "/api/foods",
    "/api/foods/search",
    "/api/patient/progress"
})
public class MealPlanServlet extends HttpServlet {
    
    private PatientMealPlanDAO mealPlanDAO;
    private FoodItemDAO foodItemDAO;
    private PortionUnitDAO portionUnitDAO;
    private UserDAO userDAO;
    private PatientRequestDAO patientRequestDAO;
    private MealTrackingDAO mealTrackingDAO;
    private DailyProgressDAO dailyProgressDAO;
    private Gson gson;

    @Override
    public void init() {
        mealPlanDAO = new PatientMealPlanDAO();
        foodItemDAO = new FoodItemDAO();
        portionUnitDAO = new PortionUnitDAO();
        userDAO = new UserDAO();
        patientRequestDAO = new PatientRequestDAO();
        mealTrackingDAO = new MealTrackingDAO();
        dailyProgressDAO = new DailyProgressDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // API endpoints for AJAX
        if (path.startsWith("/api/")) {
            handleApiRequest(request, response, path);
            return;
        }

        switch (path) {
            case "/nutritionist/mealPlan":
                showNutritionistMealPlans(request, response, user);
                break;
            case "/nutritionist/mealPlan/create":
                showCreateMealPlanForm(request, response, user);
                break;
            case "/patient/mealPlan":
                showPatientMealPlan(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Allow patient access only for specific paths
        if (!"nutritionist".equals(user.getRole()) && !path.equals("/patient/saveMealTracking")) {
             response.sendError(HttpServletResponse.SC_FORBIDDEN);
             return;
        }

        switch (path) {
            case "/nutritionist/mealPlan/create":
                createMealPlan(request, response, user);
                break;
            case "/nutritionist/mealPlan/delete":
                deleteMealPlan(request, response, user);
                break;
            case "/patient/saveMealTracking":
                saveMealTracking(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Show list of meal plans for nutritionist
     */
    private void showNutritionistMealPlans(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        List<PatientMealPlan> mealPlans = mealPlanDAO.getMealPlansByNutritionist(user.getId());
        List<User> patients = patientRequestDAO.getPatientsByNutritionist(user.getId());
        
        request.setAttribute("mealPlans", mealPlans);
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/WEB-INF/views/nutritionist/meal_plan.jsp").forward(request, response);
    }

    /**
     * Show create meal plan form
     */
    private void showCreateMealPlanForm(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        // Get patient ID from parameter
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null || patientIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/nutritionist/mealPlan?error=noPatient");
            return;
        }
        
        int patientId = Integer.parseInt(patientIdStr);
        User patient = userDAO.getUserById(patientId);
        
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/nutritionist/mealPlan?error=patientNotFound");
            return;
        }
        
        // Load all data needed for the form
        List<FoodItem> foodItems = foodItemDAO.getAllFoodItems();
        List<PortionUnit> portionUnits = portionUnitDAO.getAllPortionUnits();
        List<String> categories = foodItemDAO.getAllCategories();
        
        // Check if patient has an existing active plan
        PatientMealPlan existingPlan = mealPlanDAO.getActiveMealPlanByPatient(patientId);
        
        request.setAttribute("patient", patient);
        request.setAttribute("foodItems", foodItems);
        request.setAttribute("portionUnits", portionUnits);
        request.setAttribute("categories", categories);
        request.setAttribute("existingPlan", existingPlan);
        request.setAttribute("mealTimes", PatientMealPlan.ALL_MEAL_TIMES);
        
        request.getRequestDispatcher("/WEB-INF/views/nutritionist/meal_plan_create.jsp").forward(request, response);
    }

    /**
     * Create a new meal plan
     */
    private void createMealPlan(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            
            // Create the meal plan object
            PatientMealPlan plan = new PatientMealPlan();
            plan.setPatientId(patientId);
            plan.setNutritionistId(user.getId());
            plan.setNotes(request.getParameter("notes"));
            
            // Parse dates if provided
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                plan.setStartDate(Date.valueOf(startDateStr));
            }
            if (endDateStr != null && !endDateStr.isEmpty()) {
                plan.setEndDate(Date.valueOf(endDateStr));
            }
            
            // Validate dates
            if (plan.getStartDate() != null && plan.getEndDate() != null) {
                if (plan.getStartDate().after(plan.getEndDate())) {
                    response.sendRedirect(request.getContextPath() + "/nutritionist/mealPlan/create?patientId=" + patientId + "&error=invalidDates");
                    return;
                }
            }
            
            // Parse calorie targets
            try {
                plan.setCaloriesMatin(parseCalorie(request.getParameter("caloriesMatin"), 400));
                plan.setCaloriesMidi(parseCalorie(request.getParameter("caloriesMidi"), 600));
                plan.setCaloriesSoir(parseCalorie(request.getParameter("caloriesSoir"), 500));
                plan.setCaloriesCollation(parseCalorie(request.getParameter("caloriesCollation"), 200));
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Parse target weight (scale/balance)
            String targetWeightStr = request.getParameter("targetWeight");
            if (targetWeightStr != null && !targetWeightStr.trim().isEmpty()) {
                try {
                    double tw = Double.parseDouble(targetWeightStr);
                    plan.setTargetWeight(tw);
                } catch (NumberFormatException e) {
                    plan.setTargetWeight(0);
                }
            }

            // Parse enabled meal times
            String[] enabledTimes = request.getParameterValues("mealTimes");
            if (enabledTimes != null) {
                for (String time : enabledTimes) {
                    plan.enableMealTime(time);
                }
            }
            
            // Parse meal items for each time
            for (String mealTime : PatientMealPlan.ALL_MEAL_TIMES) {
                // These parameter names must match the JSP changes
                String[] mainFoodIds = request.getParameterValues("food_" + mealTime + "_1");
                String[] qtys1 = request.getParameterValues("qty_" + mealTime + "_1");
                
                String[] alt1FoodIds = request.getParameterValues("food_" + mealTime + "_2");
                String[] qtys2 = request.getParameterValues("qty_" + mealTime + "_2");
                
                String[] alt2FoodIds = request.getParameterValues("food_" + mealTime + "_3");
                String[] qtys3 = request.getParameterValues("qty_" + mealTime + "_3");

                String[] alt3FoodIds = request.getParameterValues("food_" + mealTime + "_4");
                String[] qtys4 = request.getParameterValues("qty_" + mealTime + "_4");
                
                String[] notes = request.getParameterValues("notes_" + mealTime);
                
                if (mainFoodIds != null) {
                    for (int i = 0; i < mainFoodIds.length; i++) {
                        if (mainFoodIds[i] != null && !mainFoodIds[i].isEmpty()) {
                            MealPlanItem item = new MealPlanItem();
                            item.setMealTime(mealTime);
                            item.setSortOrder(i);
                            
                            try {
                                // Option 1 (Required)
                                item.setFoodItemId1(Integer.parseInt(mainFoodIds[i]));
                                item.setQuantity1(parseQuantity(qtys1[i]));
                                
                                // Option 2 (Optional)
                                if (alt1FoodIds != null && i < alt1FoodIds.length && alt1FoodIds[i] != null && !alt1FoodIds[i].isEmpty()) {
                                    item.setFoodItemId2(Integer.parseInt(alt1FoodIds[i]));
                                    item.setQuantity2(parseQuantity(qtys2[i]));
                                }
                                
                                // Option 3 (Optional)
                                if (alt2FoodIds != null && i < alt2FoodIds.length && alt2FoodIds[i] != null && !alt2FoodIds[i].isEmpty()) {
                                    item.setFoodItemId3(Integer.parseInt(alt2FoodIds[i]));
                                    item.setQuantity3(parseQuantity(qtys3[i]));
                                }

                                // Option 4 (Optional)
                                if (alt3FoodIds != null && i < alt3FoodIds.length && alt3FoodIds[i] != null && !alt3FoodIds[i].isEmpty()) {
                                    item.setFoodItemId4(Integer.parseInt(alt3FoodIds[i]));
                                    item.setQuantity4(parseQuantity(qtys4[i]));
                                }
                                
                                if (notes != null && i < notes.length) {
                                    item.setNotes(notes[i]);
                                }
                                
                                plan.addItem(item);
                            } catch (NumberFormatException e) {
                                continue; // Skip invalid rows
                            }
                        }
                    }
                }
            }
            
            // Deactivate existing plans for this patient first
            mealPlanDAO.deactivatePatientPlans(patientId);
            
            // Create the new plan
            int planId = mealPlanDAO.createMealPlan(plan);
            
            if (planId > 0) {
                response.sendRedirect(request.getContextPath() + "/nutritionist/mealPlan?success=created");
            } else {
                response.sendRedirect(request.getContextPath() + "/nutritionist/mealPlan/create?patientId=" + patientId + "&error=failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/nutritionist/mealPlan?error=exception");
        }
    }

    /**
     * Delete a meal plan
     */
    private void deleteMealPlan(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        String planIdStr = request.getParameter("planId");
        if (planIdStr != null) {
            int planId = Integer.parseInt(planIdStr);
            mealPlanDAO.deleteMealPlan(planId);
        }
        response.sendRedirect(request.getContextPath() + "/nutritionist/mealPlan?success=deleted");
    }

    /**
     * Show patient's current meal plan
     */
    private void showPatientMealPlan(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        PatientMealPlan mealPlan = mealPlanDAO.getActiveMealPlanByPatient(user.getId());
        request.setAttribute("mealPlan", mealPlan);
        request.setAttribute("mealTimes", PatientMealPlan.ALL_MEAL_TIMES);
        
        // Fetch daily tracking
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        java.sql.Date today = new java.sql.Date(cal.getTimeInMillis());
        
        if (mealPlan != null) {
            Map<String, MealTracking> trackingMap = mealTrackingDAO.getTrackingByMealPlan(mealPlan.getId(), today);
            request.setAttribute("mealTracking", trackingMap);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/patient/meal_plan.jsp").forward(request, response);
    }

    /**
     * Handle API requests for AJAX calls
     */
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, String path) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        switch (path) {
            case "/api/foods":
                // Get all foods or by category
                String category = request.getParameter("category");
                List<FoodItem> foods;
                if (category != null && !category.isEmpty()) {
                    foods = foodItemDAO.getFoodItemsByCategory(category);
                } else {
                    foods = foodItemDAO.getAllFoodItems();
                }
                out.print(gson.toJson(foods));
                break;
                
            case "/api/foods/search":
                // Search foods
                String query = request.getParameter("q");
                if (query != null && !query.isEmpty()) {
                    List<FoodItem> results = foodItemDAO.searchFoodItems(query);
                    out.print(gson.toJson(results));
                } else {
                    out.print("[]");
                }
                break;

            case "/api/patient/progress":
                try {
                    String pIdStr = request.getParameter("patientId");
                    if (pIdStr != null && !pIdStr.isEmpty()) {
                        int pId = Integer.parseInt(pIdStr);
                        List<DailyProgress> history = dailyProgressDAO.getProgressHistory(pId, 30);
                        out.print(gson.toJson(history));
                    } else {
                        out.print("{\"error\":\"Missing patientId\"}");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.print("{\"error\":\"Server error\"}");
                }
                break;
                
            default:
                out.print("{\"error\":\"Unknown endpoint\"}");
        }
        out.flush();
    }



    private String formatMealItems(List<MealPlanItem> items) {
        if (items == null || items.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (MealPlanItem item : items) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(item.getDisplayText());
        }
        return sb.toString();
    }

    /**
     * Save meal tracking data
     */
    private void saveMealTracking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int mealPlanId = Integer.parseInt(request.getParameter("mealPlanId"));
            String mealType = request.getParameter("mealType");
            boolean completed = Boolean.parseBoolean(request.getParameter("completed"));
            String alternativeMeal = request.getParameter("alternativeMeal");
            
            MealTracking tracking = new MealTracking();
            tracking.setMealPlanId(mealPlanId);
            tracking.setPatientId(user.getId());
            tracking.setTrackingDate(new java.sql.Date(System.currentTimeMillis()));
            tracking.setMealType(mealType);
            tracking.setCompleted(completed);
            tracking.setAlternativeMeal(alternativeMeal);
            
            boolean success = mealTrackingDAO.saveTracking(tracking);
            
            if (success) {
                out.print("{\"status\":\"success\", \"success\": true, \"message\": \"Tracking saved!\"}");
            } else {
                out.print("{\"status\":\"error\", \"success\": false, \"message\":\"Database error: Check server logs\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
    }
    private int parseCalorie(String val, int def) {
        if (val == null || val.trim().isEmpty()) return def;
        try {
            return Integer.parseInt(val);
        } catch (Exception e) {
            return def;
        }
    }
    
    private double parseQuantity(String val) {
        if (val == null || val.trim().isEmpty()) return 100.0;
        try {
            return Double.parseDouble(val);
        } catch (Exception e) {
            return 100.0;
        }
    }
}
