package com.nutrit.controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/patient/*")
public class PatientServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) action = "/dashboard";

        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/nutritionists":
                showNutritionists(request, response);
                break;
            case "/nutritionist-profile":
                showNutritionistProfile(request, response);
                break;
            case "/requestNutritionist":
                handleRequestNutritionist(request, response);
                break;
            case "/health-profile":
                showHealthProfile(request, response);
                break;
            case "/bookAppointment":
                showBookAppointment(request, response);
                break;
            case "/appointmentRequests":
                showAppointmentRequests(request, response);
                break;
            case "/editAppointment":
                showEditAppointment(request, response);
                break;
            case "/invoices":
                showInvoices(request, response);
                break;
            case "/invoice":
                viewInvoice(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if ("/addReview".equals(action)) {
            handleAddReview(request, response);
        } else if ("/saveHealthProfile".equals(action)) {
            saveHealthProfile(request, response);
        } else if ("/saveMealTracking".equals(action)) {
            saveMealTracking(request, response);
        } else if ("/logProgress".equals(action)) {
            handleLogProgress(request, response);
        } else if ("/bookAppointment".equals(action)) {
            submitAppointmentRequest(request, response);
        } else if ("/editAppointment".equals(action)) {
            handleEditAppointment(request, response);
        } else if ("/cancelAppointment".equals(action)) {
            handleCancelAppointment(request, response);
        } else if ("/processPayment".equals(action)) {
            processPayment(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void handleAddReview(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String nutritionistIdStr = request.getParameter("nutritionistId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        
        if (nutritionistIdStr != null && ratingStr != null) {
            int nutritionistId = Integer.parseInt(nutritionistIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            com.nutrit.dao.NutritionistReviewDAO reviewDAO = new com.nutrit.dao.NutritionistReviewDAO();
            
            // Check if already reviewed
            if (reviewDAO.hasReviewed(user.getId(), nutritionistId)) {
                request.setAttribute("errorMessage", "You have already reviewed this nutritionist.");
            } else {
                com.nutrit.models.NutritionistReview review = new com.nutrit.models.NutritionistReview();
                review.setNutritionistId(nutritionistId);
                review.setPatientId(user.getId());
                review.setRating(rating);
                review.setComment(comment);
                
                if (reviewDAO.addReview(review)) {
                    request.setAttribute("successMessage", "Review submitted successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to submit review.");
                }
            }
        }
        
        // Show the profile again with the review result
        request.setAttribute("nutritionistId", nutritionistIdStr);
        showNutritionistProfile(request, response);
    }
    
    private void handleRequestNutritionist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String nutIdStr = request.getParameter("nutritionistId");
        String fromProfile = request.getParameter("fromProfile");
        
        if (nutIdStr != null) {
            int nutritionistId = Integer.parseInt(nutIdStr);
            com.nutrit.dao.PatientRequestDAO dao = new com.nutrit.dao.PatientRequestDAO();
            boolean success = dao.createRequest(user.getId(), nutritionistId);
            
            if (success) {
                request.setAttribute("successMessage", "Request sent successfully!");
            } else {
                request.setAttribute("errorMessage", "Request failed or already exists.");
            }
            
            // If from profile page, go back there
            if ("true".equals(fromProfile)) {
                request.setAttribute("nutritionistId", nutIdStr);
                showNutritionistProfile(request, response);
                return;
            }
        }
        
        showNutritionists(request, response);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // 1. Next Appointment
        com.nutrit.dao.AppointmentDAO appointmentDAO = new com.nutrit.dao.AppointmentDAO();
        com.nutrit.models.Appointment nextAppointment = appointmentDAO.getNextAppointmentForPatient(user.getId());
        request.setAttribute("nextAppointment", nextAppointment);

        // 2. Meal Plan & Tracking
        com.nutrit.dao.PatientMealPlanDAO mealPlanDAO = new com.nutrit.dao.PatientMealPlanDAO();
        com.nutrit.models.PatientMealPlan mealPlan = mealPlanDAO.getActiveMealPlanByPatient(user.getId());
        
        request.setAttribute("mealPlan", mealPlan);
        
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        java.sql.Date today = new java.sql.Date(cal.getTimeInMillis());
        
        // 2b. Get tracking data for today
        if (mealPlan != null) {
            com.nutrit.dao.MealTrackingDAO trackingDAO = new com.nutrit.dao.MealTrackingDAO();
            java.util.Map<String, com.nutrit.models.MealTracking> mealTracking = trackingDAO.getTrackingByMealPlan(mealPlan.getId(), today);
            request.setAttribute("mealTracking", mealTracking);
            
            // Get compliance stats
            java.util.Map<String, Object> complianceStats = trackingDAO.getPatientComplianceStats(user.getId());
            request.setAttribute("complianceStats", complianceStats);
        }

    // 3. Current Weight / Latest Progress
    com.nutrit.dao.DailyProgressDAO progressDAO = new com.nutrit.dao.DailyProgressDAO();
    com.nutrit.models.DailyProgress latestProgress = progressDAO.getLatestProgress(user.getId());
    request.setAttribute("latestProgress", latestProgress);

    // 3b. Progress History for Charts (Last 30 entries)
    java.util.List<com.nutrit.models.DailyProgress> historyRaw = progressDAO.getProgressHistory(user.getId(), 30);
    request.setAttribute("progressHistory", historyRaw); // Newest first for table
    
    // Create copy for charts and reverse it
    java.util.List<com.nutrit.models.DailyProgress> chartHistory = new java.util.ArrayList<>(historyRaw);
    java.util.Collections.reverse(chartHistory); 
    request.setAttribute("chartHistory", chartHistory);
        
        // 4. Patient Health Profile for stats
        com.nutrit.dao.PatientProfileDAO profileDAO = new com.nutrit.dao.PatientProfileDAO();
        com.nutrit.models.PatientProfile healthProfile = profileDAO.getProfile(user.getId());
        request.setAttribute("healthProfile", healthProfile);
        
        // 5. Check for pending appointment requests
        com.nutrit.dao.AppointmentRequestDAO requestDAO = new com.nutrit.dao.AppointmentRequestDAO();
        com.nutrit.models.AppointmentRequest pendingRequest = requestDAO.getLatestPendingRequest(user.getId());
        request.setAttribute("pendingAppointmentRequest", pendingRequest);
        
        // 6. Get assigned nutritionist ID for booking
        com.nutrit.dao.PatientRequestDAO patientReqDAO = new com.nutrit.dao.PatientRequestDAO();
        int assignedNutritionistId = patientReqDAO.getAssignedNutritionistId(user.getId());
        request.setAttribute("assignedNutritionistId", assignedNutritionistId);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/dashboard.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showNutritionists(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        com.nutrit.dao.NutritionistReviewDAO reviewDAO = new com.nutrit.dao.NutritionistReviewDAO();
        
        java.util.List<com.nutrit.models.User> nutritionists = userDAO.getNutritionists();
        
        // Build rating map for each nutritionist
        java.util.Map<Integer, Double> ratings = new java.util.HashMap<>();
        java.util.Map<Integer, Integer> reviewCounts = new java.util.HashMap<>();
        
        for (com.nutrit.models.User n : nutritionists) {
            ratings.put(n.getId(), reviewDAO.getAverageRating(n.getId()));
            reviewCounts.put(n.getId(), reviewDAO.getReviewCount(n.getId()));
        }
        
        request.setAttribute("nutritionists", nutritionists);
        request.setAttribute("ratings", ratings);
        request.setAttribute("reviewCounts", reviewCounts);
        
        // Check for current nutritionist
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        int currentNutritionistId = requestDAO.getAssignedNutritionistId(user.getId());
        request.setAttribute("currentNutritionistId", currentNutritionistId);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/nutritionists.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showNutritionistProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String idStr = request.getParameter("nutritionistId");
        if (idStr == null) {
            idStr = (String) request.getAttribute("nutritionistId");
        }
        
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/patient/nutritionists");
            return;
        }
        
        int nutritionistId = Integer.parseInt(idStr);
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        com.nutrit.dao.NutritionistReviewDAO reviewDAO = new com.nutrit.dao.NutritionistReviewDAO();
        
        com.nutrit.models.User nutritionist = userDAO.getUserById(nutritionistId);
        com.nutrit.models.NutritionistProfile profile = userDAO.getNutritionistProfile(nutritionistId);
        java.util.List<com.nutrit.models.NutritionistReview> reviews = reviewDAO.getReviewsByNutritionist(nutritionistId);
        double avgRating = reviewDAO.getAverageRating(nutritionistId);
        int reviewCount = reviewDAO.getReviewCount(nutritionistId);
        boolean hasReviewed = reviewDAO.hasReviewed(user.getId(), nutritionistId);
        
        request.setAttribute("nutritionist", nutritionist);
        request.setAttribute("profile", profile);
        request.setAttribute("reviews", reviews);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("hasReviewed", hasReviewed);
        
        // Check for current nutritionist
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        request.setAttribute("currentNutritionistId", requestDAO.getAssignedNutritionistId(user.getId()));
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/nutritionist-profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showHealthProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        com.nutrit.dao.PatientProfileDAO profileDAO = new com.nutrit.dao.PatientProfileDAO();
        com.nutrit.models.PatientProfile healthProfile = profileDAO.getProfile(user.getId());
        
        request.setAttribute("healthProfile", healthProfile);
        request.setAttribute("isComplete", profileDAO.isProfileComplete(user.getId()));
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/health-profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void saveHealthProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        com.nutrit.models.PatientProfile profile = new com.nutrit.models.PatientProfile();
        profile.setId(user.getId());
        
        // Basic Information
        String dobStr = request.getParameter("dateOfBirth");
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                profile.setDateOfBirth(java.sql.Date.valueOf(dobStr));
            } catch (IllegalArgumentException e) {}
        }
        profile.setGender(getParamOrNull(request, "gender"));
        String heightStr = request.getParameter("height");
        if (heightStr != null && !heightStr.isEmpty()) {
            try {
                profile.setHeight(new java.math.BigDecimal(heightStr));
            } catch (NumberFormatException e) {}
        }
        String currentWeightStr = request.getParameter("currentWeight");
        if (currentWeightStr != null && !currentWeightStr.isEmpty()) {
            try {
                java.math.BigDecimal val = new java.math.BigDecimal(currentWeightStr);
                if (val.compareTo(java.math.BigDecimal.ZERO) > 0) {
                    profile.setCurrentWeight(val);
                }
            } catch (NumberFormatException e) {}
        }
        String targetWeightStr = request.getParameter("targetWeight");
        if (targetWeightStr != null && !targetWeightStr.isEmpty()) {
            try {
                java.math.BigDecimal val = new java.math.BigDecimal(targetWeightStr);
                if (val.compareTo(java.math.BigDecimal.ZERO) > 0) {
                    profile.setTargetWeight(val);
                }
            } catch (NumberFormatException e) {}
        }
        
        // Lifestyle
        profile.setActivityLevel(getParamOrNull(request, "activityLevel"));
        profile.setOccupation(request.getParameter("occupation"));
        String sleepStr = request.getParameter("sleepHours");
        if (sleepStr != null && !sleepStr.isEmpty()) {
            try {
                profile.setSleepHours(Integer.parseInt(sleepStr));
            } catch (NumberFormatException e) {}
        }
        profile.setStressLevel(getParamOrNull(request, "stressLevel"));
        profile.setSmokingStatus(getParamOrNull(request, "smokingStatus"));
        profile.setAlcoholConsumption(getParamOrNull(request, "alcoholConsumption"));
        profile.setExerciseFrequency(getParamOrNull(request, "exerciseFrequency"));
        profile.setExerciseType(request.getParameter("exerciseType"));
        
        // Medical History
        profile.setMedicalConditions(request.getParameter("medicalConditions"));
        profile.setAllergies(request.getParameter("allergies"));
        profile.setCurrentMedications(request.getParameter("currentMedications"));
        profile.setPreviousSurgeries(request.getParameter("previousSurgeries"));
        profile.setFamilyMedicalHistory(request.getParameter("familyMedicalHistory"));
        profile.setDigestiveIssues(request.getParameter("digestiveIssues"));
        
        // Dietary Information
        profile.setDietaryRestrictions(request.getParameter("dietaryRestrictions"));
        profile.setFoodPreferences(request.getParameter("foodPreferences"));
        profile.setFoodsToAvoid(request.getParameter("foodsToAvoid"));
        String waterStr = request.getParameter("dailyWaterIntake");
        if (waterStr != null && !waterStr.isEmpty()) {
            try {
                profile.setDailyWaterIntake(Integer.parseInt(waterStr));
            } catch (NumberFormatException e) {}
        }
        String mealsStr = request.getParameter("mealsPerDay");
        if (mealsStr != null && !mealsStr.isEmpty()) {
            try {
                profile.setMealsPerDay(Integer.parseInt(mealsStr));
            } catch (NumberFormatException e) {}
        }
        profile.setSnackingHabits(getParamOrNull(request, "snackingHabits"));
        profile.setPreviousDietHistory(request.getParameter("previousDietHistory"));
        
        // Health Goals
        profile.setPrimaryGoal(getParamOrNull(request, "primaryGoal"));
        profile.setSecondaryGoals(request.getParameter("secondaryGoals"));
        profile.setMotivationLevel(getParamOrNull(request, "motivationLevel"));
        
        // Additional
        profile.setAdditionalNotes(request.getParameter("additionalNotes"));
        
        com.nutrit.dao.PatientProfileDAO profileDAO = new com.nutrit.dao.PatientProfileDAO();
        if (profileDAO.saveProfile(profile)) {
            request.setAttribute("successMessage", "Health profile saved successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to save health profile. Please try again.");
        }
        
        showHealthProfile(request, response);
    }

    private String getParamOrNull(HttpServletRequest request, String paramName) {
        String val = request.getParameter(paramName);
        return (val == null || val.isEmpty()) ? null : val;
    }
    
    /**
     * Handle saving meal tracking status (done/not done with alternative)
     */
    private void saveMealTracking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Not logged in\"}");
            return;
        }
        
        String mealPlanIdStr = request.getParameter("mealPlanId");
        String mealType = request.getParameter("mealType");
        String completedStr = request.getParameter("completed");
        String alternativeMeal = request.getParameter("alternativeMeal");
        String notes = request.getParameter("notes");
        
        if (mealPlanIdStr == null || mealType == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }
        
        int mealPlanId = Integer.parseInt(mealPlanIdStr);
        boolean completed = "true".equals(completedStr) || "on".equals(completedStr);
        
        com.nutrit.models.MealTracking tracking = new com.nutrit.models.MealTracking();
        tracking.setMealPlanId(mealPlanId);
        tracking.setPatientId(user.getId());
        
        // Normalize date to midnight to match dashboard retrieval
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        tracking.setTrackingDate(new java.sql.Date(cal.getTimeInMillis()));
        
        tracking.setMealType(mealType);
        tracking.setCompleted(completed);
        tracking.setAlternativeMeal(alternativeMeal);
        tracking.setNotes(notes);
        
        com.nutrit.dao.MealTrackingDAO trackingDAO = new com.nutrit.dao.MealTrackingDAO();
        boolean success = false;
        String errorMessage = "Failed to save tracking";
        
        try {
            success = trackingDAO.saveTracking(tracking);
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Database error: " + e.getMessage();
        }
        
        response.setContentType("application/json");
        if (success) {
            response.getWriter().write("{\"success\": true, \"message\": \"Tracking saved!\"}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"" + errorMessage + "\"}");
        }
    }
    
    /**
     * Handle logging daily progress (weight, water intake, etc.)
     */
    private void handleLogProgress(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String weightStr = request.getParameter("weight");
        String waterIntakeStr = request.getParameter("waterIntake");
        String caloriesStr = request.getParameter("calories");
        String notes = request.getParameter("notes");
        
        com.nutrit.models.DailyProgress progress = new com.nutrit.models.DailyProgress();
        progress.setPatientId(user.getId());
        progress.setDate(new java.sql.Date(System.currentTimeMillis()));
        
        if (weightStr != null && !weightStr.isEmpty()) {
            double w = Double.parseDouble(weightStr);
            if (w <= 0) {
                 request.setAttribute("errorMessage", "Weight must be positive.");
                 showDashboard(request, response);
                 return;
            }
            progress.setWeight(w);
        }
        if (waterIntakeStr != null && !waterIntakeStr.isEmpty()) {
            progress.setWaterIntake(Integer.parseInt(waterIntakeStr));
        }
        if (caloriesStr != null && !caloriesStr.isEmpty()) {
            progress.setCaloriesConsumed(Integer.parseInt(caloriesStr));
        }
        progress.setNotes(notes);
        
        com.nutrit.dao.DailyProgressDAO progressDAO = new com.nutrit.dao.DailyProgressDAO();
        if (progressDAO.saveProgress(progress)) {
            request.setAttribute("successMessage", "Progress logged successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to log progress. Please try again.");
        }
        
        showDashboard(request, response);
    }
    
    /**
     * Show appointment booking page with available time slots
     */
    private void showBookAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        // Get assigned nutritionist
        com.nutrit.dao.PatientRequestDAO patientReqDAO = new com.nutrit.dao.PatientRequestDAO();
        int nutritionistId = patientReqDAO.getAssignedNutritionistId(user.getId());
        
        if (nutritionistId == -1) {
            request.setAttribute("errorMessage", "You need to be assigned to a nutritionist first.");
            showDashboard(request, response);
            return;
        }
        
        // Get nutritionist info
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        com.nutrit.models.User nutritionist = userDAO.getUserById(nutritionistId);
        com.nutrit.models.NutritionistProfile profile = userDAO.getNutritionistProfile(nutritionistId);
        request.setAttribute("nutritionist", nutritionist);
        request.setAttribute("nutritionistProfile", profile);
        
        // Check if patient already has a pending request
        com.nutrit.dao.AppointmentRequestDAO requestDAO = new com.nutrit.dao.AppointmentRequestDAO();
        if (requestDAO.hasPendingRequest(user.getId(), nutritionistId)) {
            request.setAttribute("hasPendingRequest", true);
            com.nutrit.models.AppointmentRequest pendingReq = requestDAO.getLatestPendingRequest(user.getId());
            request.setAttribute("pendingRequest", pendingReq);
        }
        
        // Get availability for next 14 days
        com.nutrit.dao.NutritionistAvailabilityDAO availDAO = new com.nutrit.dao.NutritionistAvailabilityDAO();
        java.util.Map<String, java.util.List<java.sql.Timestamp>> availableSlots = new java.util.LinkedHashMap<>();
        
        java.time.LocalDate startDate = java.time.LocalDate.now();
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("EEE, MMM dd, yyyy");
        
        for (int i = 0; i < 14; i++) {
            java.time.LocalDate checkDate = startDate.plusDays(i);
            java.util.Date date = java.sql.Date.valueOf(checkDate);
            java.util.List<java.sql.Timestamp> slots = availDAO.getAvailableSlotsForDate(nutritionistId, date);
            if (!slots.isEmpty()) {
                String dateKey = dateFormat.format(date);
                availableSlots.put(dateKey, slots);
            }
        }
        request.setAttribute("availableSlots", availableSlots);
        
        // Get next available slot for quick display
        java.sql.Timestamp nextSlot = availDAO.getNextAvailableSlot(nutritionistId);
        request.setAttribute("nextAvailableSlot", nextSlot);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/book_appointment.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Submit an appointment request
     */
    private void submitAppointmentRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String slotStr = request.getParameter("selectedSlot");
        String notes = request.getParameter("notes");
        String paymentMethod = request.getParameter("paymentMethod");
        String amountStr = request.getParameter("amount");
        
        if (slotStr == null || slotStr.isEmpty()) {
            request.setAttribute("errorMessage", "Please select a time slot.");
            showBookAppointment(request, response);
            return;
        }
        
        // Handle Online Payment Flow
        if ("online".equals(paymentMethod)) {
            request.setAttribute("slot", slotStr);
            request.setAttribute("notes", notes);
            request.setAttribute("amount", amountStr);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/payment_gateway.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Handle In-Office Payment Flow (Regular booking)
        com.nutrit.dao.PatientRequestDAO patientReqDAO = new com.nutrit.dao.PatientRequestDAO();
        int nutritionistId = patientReqDAO.getAssignedNutritionistId(user.getId());
        
        if (nutritionistId == -1) {
            request.setAttribute("errorMessage", "You need to be assigned to a nutritionist first.");
            showDashboard(request, response);
            return;
        }
        
        com.nutrit.dao.AppointmentRequestDAO requestDAO = new com.nutrit.dao.AppointmentRequestDAO();
        if (requestDAO.hasPendingRequest(user.getId(), nutritionistId)) {
            request.setAttribute("errorMessage", "You already have a pending appointment request.");
            showBookAppointment(request, response);
            return;
        }
        
        com.nutrit.models.AppointmentRequest apptRequest = new com.nutrit.models.AppointmentRequest();
        apptRequest.setPatientId(user.getId());
        apptRequest.setNutritionistId(nutritionistId);
        apptRequest.setRequestedTime(java.sql.Timestamp.valueOf(slotStr));
        apptRequest.setPatientNotes(notes);
        
        apptRequest.setPaymentMethod("in_office");
        apptRequest.setPaymentStatus("pending");
        
        // Fetch nutritionist price directly from DB to ensure accuracy (and fix 0.00 issue)
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        com.nutrit.models.NutritionistProfile profile = userDAO.getNutritionistProfile(nutritionistId);
        if (profile != null && profile.getPrice() != null) {
            apptRequest.setPaymentAmount(profile.getPrice());
        } else if (amountStr != null && !amountStr.isEmpty()) {
            // Fallback to parameter if profile price retrieval fails (unlikely)
            apptRequest.setPaymentAmount(new java.math.BigDecimal(amountStr));
        }
        
        if (apptRequest.getRequestedTime().before(new java.sql.Timestamp(System.currentTimeMillis()))) {
            request.setAttribute("errorMessage", "Cannot book appointments in the past.");
            showBookAppointment(request, response);
            return;
        }

        if (requestDAO.createRequest(apptRequest)) {
            request.setAttribute("successMessage", "Appointment request submitted! Pay at the office when you arrive.");
        } else {
            request.setAttribute("errorMessage", "Failed to submit request. Please try again.");
        }
        
        showBookAppointment(request, response);
    }
    
    /**
     * Process online payment and create request
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String slotStr = request.getParameter("slot");
        String notes = request.getParameter("notes");
        String amountStr = request.getParameter("amount");
        String cardLastFour = request.getParameter("cardLastFour");
        String transactionRef = request.getParameter("transactionRef");
        
        // Get assigned nutritionist
        com.nutrit.dao.PatientRequestDAO patientReqDAO = new com.nutrit.dao.PatientRequestDAO();
        int nutritionistId = patientReqDAO.getAssignedNutritionistId(user.getId());
        
        // Create Appointment Request First
        com.nutrit.models.AppointmentRequest apptRequest = new com.nutrit.models.AppointmentRequest();
        apptRequest.setPatientId(user.getId());
        apptRequest.setNutritionistId(nutritionistId);
        apptRequest.setRequestedTime(java.sql.Timestamp.valueOf(slotStr));
        
        // Validate time
        if (apptRequest.getRequestedTime().before(new java.sql.Timestamp(System.currentTimeMillis()))) {
            request.setAttribute("errorMessage", "Cannot book appointments in the past.");
             request.setAttribute("success", false);
             request.setAttribute("error", "Invalid appointment time."); 
             RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/payment_confirmation.jsp");
             dispatcher.forward(request, response);
             return;
        }

        apptRequest.setPatientNotes(notes);
        apptRequest.setPaymentMethod("online");
        apptRequest.setPaymentStatus("paid");
        
        java.math.BigDecimal amount = new java.math.BigDecimal(amountStr);
        
        // --- CRITICAL SECURITY: Validate Amount ---
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        com.nutrit.models.NutritionistProfile profile = userDAO.getNutritionistProfile(nutritionistId);
        if (profile != null && profile.getPrice() != null) {
            if (amount.compareTo(profile.getPrice()) < 0) {
                 request.setAttribute("errorMessage", "Payment amount mismatch.");
                 request.setAttribute("success", false);
                 request.setAttribute("error", "Invalid payment amount. Expected: " + profile.getPrice()); 
                 RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/payment_confirmation.jsp");
                 dispatcher.forward(request, response);
                 return;
            }
        }
        // ------------------------------------------
        
        apptRequest.setPaymentAmount(amount);
        
        com.nutrit.dao.AppointmentRequestDAO requestDAO = new com.nutrit.dao.AppointmentRequestDAO();
        
        boolean success = false;
        com.nutrit.models.Payment payment = new com.nutrit.models.Payment();
        
        if (requestDAO.createRequest(apptRequest)) {
            // Create Payment Record
            payment.setAppointmentRequestId(apptRequest.getId());
            payment.setPatientId(user.getId());
            payment.setAmount(amount);
            payment.setPaymentMethod("online");
            payment.setStatus("completed");
            payment.setTransactionRef(transactionRef);
            payment.setCardLastFour(cardLastFour);
            payment.setCompletedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            
            com.nutrit.dao.PaymentDAO paymentDAO = new com.nutrit.dao.PaymentDAO();
            if (paymentDAO.createPayment(payment)) {
                success = true;
            }
        }
        
        request.setAttribute("success", success);
        request.setAttribute("payment", payment);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/payment_confirmation.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Show patient's appointment request history
     */
    private void showAppointmentRequests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        com.nutrit.dao.AppointmentRequestDAO requestDAO = new com.nutrit.dao.AppointmentRequestDAO();
        java.util.List<com.nutrit.models.AppointmentRequest> requests = requestDAO.getRequestsByPatient(user.getId());
        request.setAttribute("appointmentRequests", requests);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/appointment_requests.jsp");
        dispatcher.forward(request, response);
    }
    
    // =====================================================
    // PATIENT EDIT/CANCEL APPOINTMENTS
    // =====================================================
    
    private void showEditAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            return;
        }
        
        int appointmentId = Integer.parseInt(appointmentIdStr);
        com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
        com.nutrit.models.Appointment appointment = apptDAO.getAppointmentById(appointmentId);
        
        // Verify this appointment belongs to the patient
        if (appointment == null || appointment.getPatientId() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            return;
        }
        
        request.setAttribute("appointment", appointment);
        request.setAttribute("canCancel", apptDAO.canCancel(appointmentId));
        
        // Get available slots for rescheduling
        com.nutrit.dao.NutritionistAvailabilityDAO availDAO = new com.nutrit.dao.NutritionistAvailabilityDAO();
        java.util.Map<String, java.util.List<java.sql.Timestamp>> availableSlots = new java.util.LinkedHashMap<>();
        java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("EEEE, MMM dd");
        
        java.util.Calendar cal = java.util.Calendar.getInstance();
        for (int i = 0; i < 14; i++) {
            java.sql.Date date = new java.sql.Date(cal.getTimeInMillis());
            java.util.List<java.sql.Timestamp> slots = availDAO.getAvailableSlotsForDate(appointment.getNutritionistId(), date);
            if (!slots.isEmpty()) {
                availableSlots.put(dayFormat.format(date), slots);
            }
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
        }
        request.setAttribute("availableSlots", availableSlots);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/edit_appointment.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleEditAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String appointmentIdStr = request.getParameter("appointmentId");
        String newTimeStr = request.getParameter("newTime");
        String notes = request.getParameter("notes");
        
        if (appointmentIdStr != null && newTimeStr != null) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            
            com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
            com.nutrit.models.Appointment appt = apptDAO.getAppointmentById(appointmentId);
            
            // Verify ownership
            if (appt == null || appt.getPatientId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            java.sql.Timestamp newTime = java.sql.Timestamp.valueOf(newTimeStr);

             if (newTime.before(new java.sql.Timestamp(System.currentTimeMillis()))) {
                request.setAttribute("error", "Cannot reschedule to a past date.");
                request.setAttribute("appointment", appt);
                showEditAppointment(request, response);
                return;
            }
            
            // Check if new slot is available
            if (!appt.getScheduledTime().equals(newTime)) {
                if (apptDAO.isSlotBooked(appt.getNutritionistId(), newTime)) {
                    request.setAttribute("error", "The new time slot is already booked.");
                    request.setAttribute("appointment", appt);
                    showEditAppointment(request, response);
                    return;
                }
            }
            
            if (apptDAO.updateAppointment(appointmentId, newTime, notes)) {
                request.setAttribute("success", "Appointment updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update appointment.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/appointments");
    }
    
    private void handleCancelAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String appointmentIdStr = request.getParameter("appointmentId");
        
        if (appointmentIdStr != null) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
            com.nutrit.models.Appointment appt = apptDAO.getAppointmentById(appointmentId);
            
            // Verify ownership
            if (appt == null || appt.getPatientId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            }
            
            int result = apptDAO.cancelAppointment(appointmentId);
            if (result == 0) {
                request.setAttribute("success", "Appointment cancelled successfully.");
            } else if (result == 1) {
                request.setAttribute("error", "Cannot cancel appointments less than 2 hours before scheduled time.");
            } else {
                request.setAttribute("error", "Failed to cancel appointment.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/appointments");
    }
    
    // =====================================================
    // INVOICES
    // =====================================================
    
    /**
     * Show list of patient's invoices
     */
    private void showInvoices(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.InvoiceDAO invoiceDAO = new com.nutrit.dao.InvoiceDAO();
        java.util.List<com.nutrit.models.Invoice> invoices = invoiceDAO.getInvoicesByPatient(user.getId());
        
        request.setAttribute("invoices", invoices);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/my_invoices.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * View/Print a specific invoice
     */
    private void viewInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String apptIdStr = request.getParameter("appointmentId");
        if (apptIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/patient/invoices");
            return;
        }
        
        int appointmentId = Integer.parseInt(apptIdStr);
        com.nutrit.dao.InvoiceDAO invoiceDAO = new com.nutrit.dao.InvoiceDAO();
        com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
        
        // Fetch invoice and verify ownership
        com.nutrit.models.Invoice invoice = invoiceDAO.getInvoiceByAppointmentId(appointmentId);
        com.nutrit.models.Appointment appt = apptDAO.getAppointmentById(appointmentId);
        
        // Security check: Must belong to logged-in user
        if (appt == null || appt.getPatientId() != user.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to view this invoice.");
            return;
        }
        
        // If paid but no invoice exists (should be rare now), simulate strictly for view
        if (invoice == null && "paid".equals(appt.getPaymentStatus())) {
             invoice = new com.nutrit.models.Invoice();
             invoice.setInvoiceNumber("INV-TEMP-" + appointmentId);
             invoice.setAmount(appt.getPaymentAmount());
             invoice.setPaymentMethod(appt.getPaymentMethod());
             // Set other temporary fields if needed
        }
        
        if (invoice == null) {
            request.setAttribute("error", "Invoice not found or payment not yet processed.");
            showInvoices(request, response);
            return;
        }
        
        request.setAttribute("invoice", invoice);
        request.setAttribute("appointment", appt);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/invoice.jsp");
        dispatcher.forward(request, response);
    }
}
