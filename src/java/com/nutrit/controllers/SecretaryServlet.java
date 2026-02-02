package com.nutrit.controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/secretary/*")
public class SecretaryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if ("/bookAppointment".equals(action)) {
            bookAppointment(request, response);
        } else if ("/approveAppointmentRequest".equals(action)) {
            approveAppointmentRequest(request, response);
        } else if ("/rejectAppointmentRequest".equals(action)) {
            rejectAppointmentRequest(request, response);
        } else if ("/bookDirect".equals(action)) {
            handleDirectBooking(request, response);
        } else if ("/editAppointment".equals(action)) {
            handleEditAppointment(request, response);
        } else if ("/cancelAppointment".equals(action)) {
            handleCancelAppointment(request, response);
        } else if ("/markPaid".equals(action)) {
            handleMarkPaid(request, response);
        } else {
            doGet(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) action = "/dashboard";

        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/appointments":
                showAppointments(request, response);
                break;
            case "/bookAppointment":
                bookAppointment(request, response);
                break;
            case "/patients":
                showPatients(request, response);
                break;
            case "/acceptRequest":
                handleAcceptRequest(request, response);
                break;
            case "/viewPatientProfile":
                viewPatientProfile(request, response);
                break;
            case "/appointmentRequests":
                showAppointmentRequests(request, response);
                break;
            case "/bookDirect":
                showDirectBookingForm(request, response);
                break;
            case "/editAppointment":
                showEditAppointmentForm(request, response);
                break;
            case "/invoice":
                showInvoice(request, response);
                break;
            case "/patientInvoices":
                viewPatientInvoices(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        com.nutrit.dao.AppointmentDAO appointmentDAO = new com.nutrit.dao.AppointmentDAO();
        java.util.List<com.nutrit.models.Appointment> todayAppointments = new java.util.ArrayList<>();
        
        if (nutritionistId != -1) {
            todayAppointments = appointmentDAO.getTodayAppointments(nutritionistId);
        }
        
        request.setAttribute("todayAppointments", todayAppointments);
        request.setAttribute("todayCount", todayAppointments.size());
        
        // Count statuses
        long completedCount = todayAppointments.stream().filter(a -> "completed".equalsIgnoreCase(a.getStatus())).count();
        long cancelledCount = todayAppointments.stream().filter(a -> "cancelled".equalsIgnoreCase(a.getStatus())).count();
        
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("cancelledCount", cancelledCount);

        // Get Pending Requests for the Nutritionist
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        if (nutritionistId != -1) {
            int pendingCount = requestDAO.countPendingRequests(nutritionistId);
            java.util.List<com.nutrit.models.PatientRequest> pendingRequests = requestDAO.getPendingRequests(nutritionistId);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("pendingRequests", pendingRequests);
            
            // Get pending appointment requests count
            com.nutrit.dao.AppointmentRequestDAO apptRequestDAO = new com.nutrit.dao.AppointmentRequestDAO();
            int pendingApptRequests = apptRequestDAO.countPendingRequests(nutritionistId);
            request.setAttribute("pendingApptRequestsCount", pendingApptRequests);
        } else {
            request.setAttribute("pendingCount", 0);
            request.setAttribute("pendingRequests", new java.util.ArrayList<>());
            request.setAttribute("pendingApptRequestsCount", 0);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void showPatients(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId != -1) {
            com.nutrit.dao.PatientRequestDAO dao = new com.nutrit.dao.PatientRequestDAO();
            java.util.List<com.nutrit.models.User> patients = dao.getPatientsByNutritionist(nutritionistId);
            request.setAttribute("patients", patients);
        } else {
            request.setAttribute("patients", new java.util.ArrayList<>());
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/patients.jsp");
        dispatcher.forward(request, response);
    }
    private void showAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId != -1) {
            com.nutrit.dao.AppointmentDAO dao = new com.nutrit.dao.AppointmentDAO();
            // Get today's appointments for the table
            java.util.List<com.nutrit.models.Appointment> todayList = dao.getTodayAppointments(nutritionistId);
            request.setAttribute("appointments", todayList);
            
            // Get all upcoming appointments
            java.util.List<com.nutrit.models.Appointment> allList = dao.getAllAppointmentsForNutritionist(nutritionistId);
            request.setAttribute("allAppointments", allList);
            
            com.nutrit.dao.PatientRequestDAO pDao = new com.nutrit.dao.PatientRequestDAO();
            request.setAttribute("patients", pDao.getPatientsByNutritionist(nutritionistId));
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/appointments.jsp");
        dispatcher.forward(request, response);
    }

    private void bookAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId != -1) {
            String patientIdStr = request.getParameter("patientId");
            String date = request.getParameter("date"); // yyyy-MM-dd
            String time = request.getParameter("time"); // HH:mm
            String reason = request.getParameter("reason");
            String apptType = request.getParameter("apptType");
            String duration = request.getParameter("duration");
            
            if (patientIdStr != null && date != null && time != null) {
                int patientId = Integer.parseInt(patientIdStr);
                
                com.nutrit.models.Appointment appt = new com.nutrit.models.Appointment();
                appt.setPatientId(patientId);
                appt.setNutritionistId(nutritionistId);
                appt.setSecretaryId(user.getId()); // Link appointment to secretary who created it
                try {
                    appt.setScheduledTime(java.sql.Timestamp.valueOf(date + " " + time + ":00"));
                    
                    // Validate not in past
                    if (appt.getScheduledTime().before(new java.sql.Timestamp(System.currentTimeMillis()))) {
                        request.setAttribute("error", "Cannot book appointments in the past.");
                         String source = request.getParameter("source");
                        if ("patients".equals(source)) {
                            showPatients(request, response);
                        } else {
                            showAppointments(request, response);
                        }
                        return;
                    }
                    
                } catch (IllegalArgumentException e) {
                   // Handle parse error
                }
                appt.setStatus("upcoming"); // Must match ENUM: 'upcoming', 'completed', 'cancelled'
                
                // Append type and duration to notes if present
                StringBuilder notesBuilder = new StringBuilder();
                if (apptType != null && !apptType.isEmpty()) {
                    notesBuilder.append("[").append(apptType).append("] ");
                }
                if (duration != null && !duration.isEmpty()) {
                    notesBuilder.append("(").append(duration).append(") ");
                }
                if (reason != null && !reason.isEmpty()) {
                    notesBuilder.append(reason);
                }
                
                appt.setNotes(notesBuilder.toString().trim());
                
                com.nutrit.dao.AppointmentDAO dao = new com.nutrit.dao.AppointmentDAO();
                if (dao.createAppointment(appt)) {
                    request.setAttribute("success", "Appointment booked successfully.");
                } else {
                    request.setAttribute("error", "Failed to book appointment.");
                }
            }
        }
        
        String source = request.getParameter("source");
        if ("patients".equals(source)) {
            showPatients(request, response);
        } else {
            showAppointments(request, response);
        }
    }


    private void handleAcceptRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId == -1) {
             response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
             return;
        }

        String requestIdStr = request.getParameter("id");
        if (requestIdStr != null) {
            int requestId = Integer.parseInt(requestIdStr);
            com.nutrit.dao.PatientRequestDAO dao = new com.nutrit.dao.PatientRequestDAO();
            
            // Security check: Ensure the request belongs to the secretary's nutritionist
            // Ideally should be done in DAO or here, but assuming ID is enough for now with logic check
            if (dao.acceptRequest(requestId)) {
                // Success
            } else {
                // Fail
            }
        }
        response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
    }

    private void viewPatientProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/secretary/patients");
            return;
        }
        
        int patientId = Integer.parseInt(patientIdStr);
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId == -1) {
            response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
            return;
        }

        // Verify that this patient belongs to the secretary's nutritionist
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        java.util.List<com.nutrit.models.User> myPatients = requestDAO.getPatientsByNutritionist(nutritionistId);
        boolean isMyPatient = false;
        for (com.nutrit.models.User p : myPatients) {
            if (p.getId() == patientId) {
                isMyPatient = true;
                break;
            }
        }
        
        if (!isMyPatient) {
            response.sendRedirect(request.getContextPath() + "/secretary/patients");
            return;
        }
        
        // Get patient info and health profile
        com.nutrit.dao.PatientProfileDAO profileDAO = new com.nutrit.dao.PatientProfileDAO();
        
        com.nutrit.models.User patient = userDAO.getUserById(patientId);
        com.nutrit.models.PatientProfile healthProfile = profileDAO.getProfile(patientId);
        boolean isComplete = profileDAO.isProfileComplete(patientId);
        
        request.setAttribute("patient", patient);
        request.setAttribute("healthProfile", healthProfile);
        request.setAttribute("isComplete", isComplete);
        
        // Get meal tracking data (ReadOnly for secretary usually, but useful context)
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
        
        // Get diet plans (ReadOnly)
        com.nutrit.dao.DietPlanDAO dietDAO = new com.nutrit.dao.DietPlanDAO();
        java.util.List<com.nutrit.models.DietPlan> dietPlans = dietDAO.getDietPlansByPatientId(patientId);
        request.setAttribute("dietPlans", dietPlans);
        
        // Get invoices (New)
        com.nutrit.dao.InvoiceDAO invoiceDAO = new com.nutrit.dao.InvoiceDAO();
        java.util.List<com.nutrit.models.Invoice> invoices = invoiceDAO.getInvoicesByPatient(patientId);
        request.setAttribute("invoices", invoices);
        
        // Use the same view as nutritionist since the data is the same
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/patient-profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void viewPatientInvoices(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/secretary/patients");
            return;
        }
        
        int patientId = Integer.parseInt(patientIdStr);
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId == -1) {
            response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
            return;
        }
        
        // Verify patient access
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        java.util.List<com.nutrit.models.User> myPatients = requestDAO.getPatientsByNutritionist(nutritionistId);
        boolean isMyPatient = false;
        for (com.nutrit.models.User p : myPatients) {
            if (p.getId() == patientId) {
                isMyPatient = true;
                break;
            }
        }
        
        if (!isMyPatient) {
            response.sendRedirect(request.getContextPath() + "/secretary/patients");
            return;
        }
        
        // Get patient info for header
        com.nutrit.models.User patient = userDAO.getUserById(patientId);
        request.setAttribute("patient", patient);
        
        // Get invoices
        com.nutrit.dao.InvoiceDAO invoiceDAO = new com.nutrit.dao.InvoiceDAO();
        java.util.List<com.nutrit.models.Invoice> invoices = invoiceDAO.getInvoicesByPatient(patientId);
        request.setAttribute("invoices", invoices);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/patient_invoices.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Show pending appointment requests for approval
     */
    private void showAppointmentRequests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId != -1) {
            com.nutrit.dao.AppointmentRequestDAO apptRequestDAO = new com.nutrit.dao.AppointmentRequestDAO();
            java.util.List<com.nutrit.models.AppointmentRequest> pendingRequests = apptRequestDAO.getPendingRequestsByNutritionist(nutritionistId);
            request.setAttribute("appointmentRequests", pendingRequests);
            
            // Get nutritionist info for display
            com.nutrit.models.User nutritionist = userDAO.getUserById(nutritionistId);
            request.setAttribute("nutritionist", nutritionist);
        } else {
            request.setAttribute("appointmentRequests", new java.util.ArrayList<>());
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/appointment_requests.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Approve an appointment request
     */
    private void approveAppointmentRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String requestIdStr = request.getParameter("requestId");
        String notes = request.getParameter("notes");
        
        if (requestIdStr != null) {
            int requestId = Integer.parseInt(requestIdStr);
            com.nutrit.dao.AppointmentRequestDAO apptRequestDAO = new com.nutrit.dao.AppointmentRequestDAO();
            
            if (apptRequestDAO.approveRequest(requestId, user.getId(), notes)) {
                request.setAttribute("success", "Appointment request approved! The appointment has been created.");
            } else {
                request.setAttribute("error", "Failed to approve the request.");
            }
        }
        
        showAppointmentRequests(request, response);
    }
    
    /**
     * Reject an appointment request
     */
    private void rejectAppointmentRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String requestIdStr = request.getParameter("requestId");
        String reason = request.getParameter("reason");
        
        if (requestIdStr != null) {
            int requestId = Integer.parseInt(requestIdStr);
            com.nutrit.dao.AppointmentRequestDAO apptRequestDAO = new com.nutrit.dao.AppointmentRequestDAO();
            
            if (apptRequestDAO.rejectRequest(requestId, user.getId(), reason)) {
                request.setAttribute("success", "Appointment request rejected.");
            } else {
                request.setAttribute("error", "Failed to reject the request.");
            }
        }
        
        showAppointmentRequests(request, response);
    }
    
    // =====================================================
    // DIRECT BOOKING (same UI as patient)
    // =====================================================
    
    private void showDirectBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        if (nutritionistId == -1) {
            response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
            return;
        }
        
        String patientIdStr = request.getParameter("patientId");
        
        // Get list of patients for this nutritionist
        com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
        java.util.List<com.nutrit.models.User> patients = requestDAO.getPatientsByNutritionist(nutritionistId);
        request.setAttribute("patients", patients);
        
        // Get nutritionist info
        com.nutrit.models.User nutritionist = userDAO.getUserById(nutritionistId);
        request.setAttribute("nutritionist", nutritionist);
        
        // Get available slots for next 14 days
        com.nutrit.dao.NutritionistAvailabilityDAO availDAO = new com.nutrit.dao.NutritionistAvailabilityDAO();
        java.util.Map<String, java.util.List<java.sql.Timestamp>> availableSlots = new java.util.LinkedHashMap<>();
        java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat("EEEE, MMM dd");
        
        java.util.Calendar cal = java.util.Calendar.getInstance();
        for (int i = 0; i < 14; i++) {
            java.sql.Date date = new java.sql.Date(cal.getTimeInMillis());
            java.util.List<java.sql.Timestamp> slots = availDAO.getAvailableSlotsForDate(nutritionistId, date);
            if (!slots.isEmpty()) {
                availableSlots.put(dayFormat.format(date), slots);
            }
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
        }
        request.setAttribute("availableSlots", availableSlots);
        
        // If patient is pre-selected
        if (patientIdStr != null) {
            request.setAttribute("selectedPatientId", Integer.parseInt(patientIdStr));
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/direct_book.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleDirectBooking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        
        String patientIdStr = request.getParameter("patientId");
        String selectedSlot = request.getParameter("selectedSlot");
        String notes = request.getParameter("notes");
        
        if (nutritionistId != -1 && patientIdStr != null && selectedSlot != null) {
            int patientId = Integer.parseInt(patientIdStr);
            java.sql.Timestamp slotTime = java.sql.Timestamp.valueOf(selectedSlot);
            
            // Validate not in past
             if (slotTime.before(new java.sql.Timestamp(System.currentTimeMillis()))) {
                request.setAttribute("error", "Cannot book appointments in the past.");
                showDirectBookingForm(request, response);
                return;
            }
            
            // Check if slot is still available
            com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
            if (apptDAO.isSlotBooked(nutritionistId, slotTime)) {
                request.setAttribute("error", "This slot has already been booked. Please select another.");
                showDirectBookingForm(request, response);
                return;
            }
            
            // Create appointment directly
            com.nutrit.models.Appointment appt = new com.nutrit.models.Appointment();
            appt.setPatientId(patientId);
            appt.setNutritionistId(nutritionistId);
            appt.setSecretaryId(user.getId());
            appt.setScheduledTime(slotTime);
            appt.setStatus("upcoming");
            appt.setNotes(notes);
            
            // Set default consultation fee from nutritionist profile
            com.nutrit.models.User nutritionist = userDAO.getUserById(nutritionistId);
            if (nutritionist != null && nutritionist.getNutritionistProfile() != null) {
                appt.setPaymentAmount(nutritionist.getNutritionistProfile().getPrice());
            }
            
            if (apptDAO.createAppointment(appt)) {
                request.setAttribute("success", "Appointment booked successfully!");
            } else {
                request.setAttribute("error", "Failed to book appointment.");
            }
        }
        
        showDirectBookingForm(request, response);
    }
    
    // =====================================================
    // EDIT APPOINTMENT
    // =====================================================
    
    private void showEditAppointmentForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/secretary/appointments");
            return;
        }
        
        int appointmentId = Integer.parseInt(appointmentIdStr);
        com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
        com.nutrit.models.Appointment appointment = apptDAO.getAppointmentById(appointmentId);
        
        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/secretary/appointments");
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
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/edit_appointment.jsp");
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
            java.sql.Timestamp newTime = java.sql.Timestamp.valueOf(newTimeStr);
            
            com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
            com.nutrit.models.Appointment appt = apptDAO.getAppointmentById(appointmentId);
            
            // Check if new slot is available (unless it's the same time)
            if (appt != null && !appt.getScheduledTime().equals(newTime)) {
                
                // Validate not in past
                if (newTime.before(new java.sql.Timestamp(System.currentTimeMillis()))) {
                    request.setAttribute("error", "Cannot reschedule to a past date.");
                    request.setAttribute("appointment", appt);
                    showEditAppointmentForm(request, response);
                    return;
                }
                
                if (apptDAO.isSlotBooked(appt.getNutritionistId(), newTime)) {
                    request.setAttribute("error", "The new time slot is already booked.");
                    request.setAttribute("appointment", appt);
                    showEditAppointmentForm(request, response);
                    return;
                }
            }
            
            if (apptDAO.updateAppointment(appointmentId, newTime, notes)) {
                request.setAttribute("success", "Appointment updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update appointment.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/secretary/appointments");
    }
    
    private void handleCancelAppointment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String appointmentIdStr = request.getParameter("appointmentId");
        
        if (appointmentIdStr != null) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
            
            // Allow secretary to cancel any time
            if (apptDAO.updateAppointmentStatus(appointmentId, "cancelled")) {
                request.setAttribute("success", "Appointment cancelled successfully.");
            } else {
                request.setAttribute("error", "Failed to cancel appointment.");
            }
        }
        
        showAppointments(request, response);
    }
    
    /**
     * Mark an appointment as paid (in-office)
     */
    private void handleMarkPaid(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String apptIdStr = request.getParameter("appointmentId");
        if (apptIdStr != null) {
            int appointmentId = Integer.parseInt(apptIdStr);
            com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
            com.nutrit.models.Appointment appt = apptDAO.getAppointmentById(appointmentId);
            
            if (appt != null) {
                // Update appointment payment status
                if (apptDAO.updatePaymentStatus(appointmentId, "paid")) {
                    
                    // Create Payment record
                    com.nutrit.models.Payment payment = new com.nutrit.models.Payment();
                    payment.setPatientId(appt.getPatientId());
                    
                    // Use appointment amount, or fallback to nutritionist's tarif_consultation
                    java.math.BigDecimal amount = appt.getPaymentAmount();
                    if (amount == null) {
                        com.nutrit.models.User nutritionist = new com.nutrit.dao.UserDAO().getUserById(appt.getNutritionistId());
                        if (nutritionist != null && nutritionist.getNutritionistProfile() != null) {
                            amount = nutritionist.getNutritionistProfile().getPrice();
                        }
                    }
                    // Final fallback if everything else fails
                    if (amount == null) amount = new java.math.BigDecimal("50.00");
                    
                    payment.setAmount(amount);
                    payment.setPaymentMethod("in_office");
                    payment.setStatus("completed");
                    payment.setTransactionRef(com.nutrit.dao.PaymentDAO.generateTransactionRef());
                    payment.setCompletedAt(new java.sql.Timestamp(System.currentTimeMillis()));
                    
                    com.nutrit.dao.PaymentDAO paymentDAO = new com.nutrit.dao.PaymentDAO();
                    paymentDAO.createPayment(payment);
                    
                    // Create Invoice
                    com.nutrit.models.Invoice invoice = new com.nutrit.models.Invoice();
                    invoice.setAppointmentId(appointmentId);
                    invoice.setPatientId(appt.getPatientId());
                    invoice.setInvoiceNumber(new com.nutrit.dao.InvoiceDAO().generateInvoiceNumber());
                    // Invoice date handled by DB default (created_at)
                    invoice.setAmount(payment.getAmount());
                    invoice.setPaymentStatus("paid");
                    invoice.setPaymentMethod("in_office");
                    
                    new com.nutrit.dao.InvoiceDAO().createInvoice(invoice);
                    
                    request.setAttribute("success", "Payment marked as collected and invoice generated.");
                } else {
                    request.setAttribute("error", "Failed to update payment status.");
                }
            }
        }
        showAppointments(request, response);
    }
    
    /**
     * Show invoice for an appointment
     */
    private void showInvoice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.nutrit.models.User user = (com.nutrit.models.User) request.getSession().getAttribute("user");
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth/login"); return; }
        
        String apptIdStr = request.getParameter("appointmentId");
        if (apptIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/secretary/appointments");
            return;
        }
        
        int appointmentId = Integer.parseInt(apptIdStr);
        com.nutrit.dao.InvoiceDAO invoiceDAO = new com.nutrit.dao.InvoiceDAO();
        com.nutrit.dao.AppointmentDAO apptDAO = new com.nutrit.dao.AppointmentDAO();
        
        com.nutrit.models.Appointment appt = apptDAO.getAppointmentById(appointmentId);
        
        if (appt == null) {
            response.sendRedirect(request.getContextPath() + "/secretary/appointments");
            return;
        }

        // --- IDOR Check ---
        com.nutrit.dao.UserDAO userDAO = new com.nutrit.dao.UserDAO();
        int nutritionistId = userDAO.getNutritionistIdBySecretary(user.getId());
        if (appt.getNutritionistId() != nutritionistId) {
             response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You cannot view invoices for other nutritionists.");
             return;
        }
        // ------------------
        
        com.nutrit.models.Invoice invoice = invoiceDAO.getInvoiceByAppointmentId(appointmentId);
        
        // If paid but no invoice exists (e.g. legacy or direct db update), generate one/mock one for view
        if (invoice == null && "paid".equals(appt.getPaymentStatus())) {
             invoice = new com.nutrit.models.Invoice();
             invoice.setInvoiceNumber("INV-TEMP-" + appointmentId);
             invoice.setAmount(appt.getPaymentAmount());
             invoice.setPaymentMethod(appt.getPaymentMethod());
        }
        
        request.setAttribute("invoice", invoice);
        request.setAttribute("appointment", appt);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/secretary/invoice.jsp");
        dispatcher.forward(request, response);
    }
}
