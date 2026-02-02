package com.nutrit.controllers;

import com.nutrit.dao.AppointmentDAO;
import com.nutrit.models.Appointment;
import com.nutrit.models.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/patient/appointments", "/nutritionist/appointments", "/secretary/appointments"})
public class AppointmentServlet extends HttpServlet {
    
    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        List<Appointment> appointments = appointmentDAO.getAppointmentsByRole(user.getRole(), user.getId());
        request.setAttribute("appointments", appointments);

        String view = "/WEB-INF/views/common/appointments.jsp"; 
        // Could be role specific if designs differ greatly. Using common for now.
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(view);
        dispatcher.forward(request, response);
    }
}
