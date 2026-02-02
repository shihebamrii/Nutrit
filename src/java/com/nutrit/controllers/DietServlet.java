package com.nutrit.controllers;

import com.nutrit.dao.DietPlanDAO;
import com.nutrit.models.DietPlan;
import com.nutrit.models.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/patient/diet", "/nutritionist/diet"})
public class DietServlet extends HttpServlet {
    
    private DietPlanDAO dietPlanDAO;

    @Override
    public void init() {
        dietPlanDAO = new DietPlanDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if ("patient".equals(user.getRole())) {
            List<DietPlan> plans = dietPlanDAO.getDietPlansByPatientId(user.getId());
            request.setAttribute("dietPlans", plans);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/diet_plan.jsp");
            dispatcher.forward(request, response);
        } else if ("nutritionist".equals(user.getRole())) {
            // For now, simple view or redirect to patient selection
            // In full app, fetch patient ID from params
             RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/nutritionist/diet_manage.jsp");
             dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handling adding diet plan (Nutritionist only)
        // ... Implementation
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        // ...
        response.sendRedirect(request.getContextPath() + "/nutritionist/diet?success=true");
    }
}
