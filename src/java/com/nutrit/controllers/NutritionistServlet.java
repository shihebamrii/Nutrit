package com.nutrit.controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/nutritionist/*")
public class NutritionistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) action = "/dashboard";

        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/createSecretary": // GET and POST handled by helper
                handleCreateSecretary(request, response);
                break;
            case "/secretaries":
                showSecretaries(request, response);
                break;
            case "/editSecretary":
                handleEditSecretary(request, response);
                break;
            case "/deleteSecretary":
                handleDeleteSecretary(request, response);
                break;
            case "/appointments":
                showAppointments(request, response);
                break;
            case "/patients":
                showPatients(request, response);
                break;
            // case "/acceptRequest": moved to Secretary

            case "/viewPatientProfile":
                viewPatientProfile(request, response);
                break;
            case "/dietTemplates":
                showDietTemplates(request, response);
                break;
            case "/assignDiet":
                showAssignDietForm(request, response);
                break;
            case "/availability":
                showAvailability(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if ("/createSecretary".equals(action)) {
            handleCreateSecretary(request, response);
        } else if ("/assignDiet".equals(action)) {
            handleAssignDiet(request, response);
        } else if ("/availability".equals(action)) {
            saveAvailability(request, response);
        } else if ("/deleteSecretary".equals(action)) {
            handleDeleteSecretary(request, response);
        } else if ("/editSecretary".equals(action)) {
            handleEditSecretary(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        com.nutrit.dao.AppointmentDAO appointmentDAO = new com.nutrit.dao.AppointmentDAO();
        
        int activePatients = requestDAO.countActivePatients(user.getId());
        // Request fetching logic moved to Secretary dashboard

        java.util.List<com.nutrit.models.Appointment> todayAppointments = appointmentDAO.getTodayAppointments(user.getId());
        
        request.setAttribute("activePatients", activePatients);
        request.setAttribute("pendingCount", 0); // Deprecated for nutritionist
        request.setAttribute("pendingRequests", new java.util.ArrayList<>()); // Deprecated for nutritionist
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("todayCount", todayAppointments.size());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void handleCreateSecretary(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String method = request.getMethod();
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        if ("GET".equalsIgnoreCase(method)) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/create_secretary.jsp");
            dispatcher.forward(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            
            com.nutrit.models.User sec = new com.nutrit.models.User();
            sec.setFullName(fullName);
            sec.setEmail(email);
            sec.setPassword(password);
            sec.setPhone(phone);
            sec.setRole("secretary");
            
            com.nutrit.dao.UserDAO dao = new com.nutrit.dao.UserDAO();
            if (dao.createSecretary(sec, user.getId())) {
                request.setAttribute("success", "Secretary account created successfully.");
                // Redirect or show success on same page
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/create_secretary.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Failed to create secretary. Email might be in use.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/create_secretary.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

    private void handleEditSecretary(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String method = request.getMethod();
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO dao = new com.nutrit.dao.UserDAO();

        if ("GET".equalsIgnoreCase(method)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                com.nutrit.models.User secretary = dao.getUserById(id);
                // Security check: ensure this secretary belongs to this nutritionist
                if (secretary != null && "secretary".equals(secretary.getRole()) && 
                    dao.getNutritionistIdBySecretary(id) == user.getId()) {
                    request.setAttribute("secretary", secretary);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/create_secretary.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/nutritionist/secretaries");
            
        } else if ("POST".equalsIgnoreCase(method)) {
            String idStr = request.getParameter("id");
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                // Verify ownership again
                if (dao.getNutritionistIdBySecretary(id) == user.getId()) {
                    com.nutrit.models.User sec = new com.nutrit.models.User();
                    sec.setId(id);
                    sec.setFullName(fullName);
                    sec.setEmail(email);
                    sec.setPhone(phone);
                    
                    if (dao.updateSecretary(sec)) {
                         request.setAttribute("success", "Secretary updated successfully.");
                    } else {
                         request.setAttribute("error", "Failed to update secretary.");
                    }
                    // Re-fetch to show updated data
                    request.setAttribute("secretary", dao.getUserById(id));
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/create_secretary.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleDeleteSecretary(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }

        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            com.nutrit.dao.UserDAO dao = new com.nutrit.dao.UserDAO();
            // Security: ensure ownership
            if (dao.getNutritionistIdBySecretary(id) == user.getId()) {
                dao.deleteUser(id);
            }
        }
        response.sendRedirect(request.getContextPath() + "/nutritionist/secretaries");
    }

    private void showSecretaries(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO dao = new com.nutrit.dao.UserDAO();
        java.util.List<com.nutrit.models.User> secretaries = dao.getSecretariesByNutritionist(user.getId());
        
        request.setAttribute("secretaries", secretaries);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/secretaries.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showPatients(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.PatientRequestDAO dao = new com.nutrit.dao.PatientRequestDAO();
        java.util.List<com.nutrit.models.User> patients = dao.getPatientsByNutritionist(user.getId());
        
        request.setAttribute("patients", patients);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/patients.jsp");
        dispatcher.forward(request, response);
    }
    
    // handleAcceptRequest moved to SecretaryServlet

    
    private void viewPatientProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/nutritionist/patients");
            return;
        }
        
        int patientId = Integer.parseInt(patientIdStr);
        
        // Verify that this patient belongs to the nutritionist
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        java.util.List<com.nutrit.models.User> myPatients = requestDAO.getPatientsByNutritionist(user.getId());
        boolean isMyPatient = false;
        for (com.nutrit.models.User p : myPatients) {
            if (p.getId() == patientId) {
                isMyPatient = true;
                break;
            }
        }
        
        if (!isMyPatient) {
            response.sendRedirect(request.getContextPath() + "/nutritionist/patients");
            return;
        }
        
        // Get patient info and health profile
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        com.nutrit.dao.PatientProfileDAO profileDAO = new com.nutrit.dao.PatientProfileDAO();
        
        com.nutrit.models.User patient = userDAO.getUserById(patientId);
        com.nutrit.models.PatientProfile healthProfile = profileDAO.getProfile(patientId);
        boolean isComplete = profileDAO.isProfileComplete(patientId);
        
        request.setAttribute("patient", patient);
        request.setAttribute("healthProfile", healthProfile);
        request.setAttribute("isComplete", isComplete);
        
        // Get meal tracking data for nutritionist review
        com.nutrit.dao.MealTrackingDAO trackingDAO = new com.nutrit.dao.MealTrackingDAO();
        java.util.Map<String, Object> complianceStats = trackingDAO.getPatientComplianceStats(patientId);
        java.util.List<com.nutrit.models.MealTracking> recentDeviations = trackingDAO.getRecentDeviations(patientId, 10);
        java.util.List<com.nutrit.models.MealTracking> allTracking = trackingDAO.getTrackingByPatient(patientId);
        
        request.setAttribute("complianceStats", complianceStats);
        request.setAttribute("recentDeviations", recentDeviations);
        request.setAttribute("mealTracking", allTracking);
        
        // Get progress history
        com.nutrit.dao.DailyProgressDAO progressDAO = new com.nutrit.dao.DailyProgressDAO();
        java.util.List<com.nutrit.models.DailyProgress> progressHistory = progressDAO.getProgressHistory(patientId, 14);
        request.setAttribute("progressHistory", progressHistory);
        
        // Get diet plans
        com.nutrit.dao.DietPlanDAO dietDAO = new com.nutrit.dao.DietPlanDAO();
        java.util.List<com.nutrit.models.DietPlan> dietPlans = dietDAO.getDietPlansByPatientId(patientId);
        request.setAttribute("dietPlans", dietPlans);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/patient-profile.jsp");
        dispatcher.forward(request, response);
    }
    
    // =====================================================
    // DIET TEMPLATE METHODS
    // =====================================================
    
    private void showDietTemplates(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.DietPlanTemplateDAO templateDAO = new com.nutrit.dao.DietPlanTemplateDAO();
        
        // Get filter parameters
        String category = request.getParameter("category");
        String search = request.getParameter("search");
        
        java.util.List<com.nutrit.models.DietPlanTemplate> templates;
        
        if (search != null && !search.trim().isEmpty()) {
            templates = templateDAO.searchTemplates(search);
        } else if (category != null && !category.trim().isEmpty()) {
            templates = templateDAO.getTemplatesByCategory(category);
        } else {
            templates = templateDAO.getAllTemplates();
        }
        
        java.util.List<String> categories = templateDAO.getAllCategories();
        
        request.setAttribute("templates", templates);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("searchQuery", search);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/diet-templates.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showAssignDietForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String templateIdStr = request.getParameter("templateId");
        String patientIdStr = request.getParameter("patientId");
        
        com.nutrit.dao.DietPlanTemplateDAO templateDAO = new com.nutrit.dao.DietPlanTemplateDAO();
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        
        // Get all patients for this nutritionist
        java.util.List<com.nutrit.models.User> patients = requestDAO.getPatientsByNutritionist(user.getId());
        request.setAttribute("patients", patients);
        
        // If template is specified, get it
        if (templateIdStr != null) {
            int templateId = Integer.parseInt(templateIdStr);
            com.nutrit.models.DietPlanTemplate template = templateDAO.getTemplateById(templateId);
            request.setAttribute("selectedTemplate", template);
        }
        
        // If patient is specified
        if (patientIdStr != null) {
            request.setAttribute("selectedPatientId", patientIdStr);
        }
        
        // Get all templates for selection
        java.util.List<com.nutrit.models.DietPlanTemplate> templates = templateDAO.getAllTemplates();
        request.setAttribute("templates", templates);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/assign-diet.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleAssignDiet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String patientIdStr = request.getParameter("patientId");
        String templateIdStr = request.getParameter("templateId");
        String startDateStr = request.getParameter("startDate");
        String daysStr = request.getParameter("days");
        String replaceExisting = request.getParameter("replaceExisting");
        
        if (patientIdStr == null || templateIdStr == null || startDateStr == null || daysStr == null) {
            request.setAttribute("error", "All fields are required.");
            showAssignDietForm(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            int templateId = Integer.parseInt(templateIdStr);
            int days = Integer.parseInt(daysStr);
            
            if (days <= 0) {
                request.setAttribute("error", "Duration must be at least 1 day.");
                showAssignDietForm(request, response);
                return;
            }
            
            java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
            
            // Verify patient belongs to this nutritionist
            com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
            java.util.List<com.nutrit.models.User> myPatients = requestDAO.getPatientsByNutritionist(user.getId());
            boolean isMyPatient = false;
            for (com.nutrit.models.User p : myPatients) {
                if (p.getId() == patientId) {
                    isMyPatient = true;
                    break;
                }
            }
            
            if (!isMyPatient) {
                request.setAttribute("error", "Invalid patient selection.");
                showAssignDietForm(request, response);
                return;
            }
            
            com.nutrit.dao.DietPlanDAO dietDAO = new com.nutrit.dao.DietPlanDAO();
            
            // If replacing, delete existing plans in the date range
            if ("on".equals(replaceExisting)) {
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(startDate);
                cal.add(java.util.Calendar.DAY_OF_MONTH, days - 1);
                java.sql.Date endDate = new java.sql.Date(cal.getTimeInMillis());
                dietDAO.deletePlansInRange(patientId, startDate, endDate);
            }
            
            // Create the diet plans from template
            int created = dietDAO.createFromTemplate(patientId, user.getId(), templateId, startDate, days);
            
            if (created > 0) {
                request.setAttribute("success", "Successfully assigned " + created + " days of diet plan to the patient!");
            } else {
                request.setAttribute("error", "Failed to assign diet plan. Please try again.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing request: " + e.getMessage());
        }
        
        showAssignDietForm(request, response);
    }

    private void showAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        int nutritionistId = user.getId();
        
        if (nutritionistId != -1) {
            com.nutrit.dao.AppointmentDAO dao = new com.nutrit.dao.AppointmentDAO();
            java.util.List<com.nutrit.models.Appointment> allApps = dao.getAllAppointmentsForNutritionist(nutritionistId);
            request.setAttribute("appointments", allApps);
        } else {
             request.setAttribute("appointments", new java.util.ArrayList<>());
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/appointments.jsp");
        dispatcher.forward(request, response);
    }
    
    // =====================================================
    // AVAILABILITY MANAGEMENT
    // =====================================================
    
    private void showAvailability(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.NutritionistAvailabilityDAO availDAO = new com.nutrit.dao.NutritionistAvailabilityDAO();
        java.util.List<com.nutrit.models.NutritionistAvailability> availability = availDAO.getAvailabilityByNutritionist(user.getId());
        
        // Create a map for easy access in JSP
        java.util.Map<String, com.nutrit.models.NutritionistAvailability> availByDay = new java.util.HashMap<>();
        for (com.nutrit.models.NutritionistAvailability a : availability) {
            availByDay.put(a.getDayOfWeek(), a);
        }
        
        request.setAttribute("availability", availability);
        request.setAttribute("availByDay", availByDay);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/availability.jsp");
        dispatcher.forward(request, response);
    }
    
    private void saveAvailability(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.NutritionistAvailabilityDAO availDAO = new com.nutrit.dao.NutritionistAvailabilityDAO();
        
        String[] days = {"monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"};
        int savedCount = 0;
        
        for (String day : days) {
            String enabled = request.getParameter(day + "_enabled");
            String startTime = request.getParameter(day + "_start");
            String endTime = request.getParameter(day + "_end");
            String slotDuration = request.getParameter(day + "_duration");
            
            if ("on".equals(enabled) && startTime != null && endTime != null && !startTime.isEmpty() && !endTime.isEmpty()) {
                com.nutrit.models.NutritionistAvailability slot = new com.nutrit.models.NutritionistAvailability();
                slot.setNutritionistId(user.getId());
                slot.setDayOfWeek(day);
                slot.setStartTime(java.sql.Time.valueOf(startTime + ":00"));
                slot.setEndTime(java.sql.Time.valueOf(endTime + ":00"));
                slot.setSlotDurationMinutes(slotDuration != null ? Integer.parseInt(slotDuration) : 30);
                slot.setActive(true);
                
                if (availDAO.saveAvailability(slot)) {
                    savedCount++;
                }
            } else {
                // Day is not enabled, delete if exists
                availDAO.deleteAvailability(user.getId(), day);
            }
        }
        
        if (savedCount > 0) {
            request.setAttribute("success", "Availability saved successfully! " + savedCount + " day(s) configured.");
        } else {
            request.setAttribute("success", "Availability cleared. No days are currently active.");
        }
        
        showAvailability(request, response);
    }
}
