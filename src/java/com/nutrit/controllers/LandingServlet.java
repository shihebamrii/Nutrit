package com.nutrit.controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.nutrit.models.User;
import com.nutrit.dao.UserDAO;
import java.io.IOException;

/**
 * Servlet to handle landing page and redirect logged-in users to their dashboard
 */
@WebServlet(urlPatterns = {"/home", "/landing"})
public class LandingServlet extends HttpServlet {

    private UserDAO userDAO;
    private com.nutrit.dao.DietPlanDAO dietPlanDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        dietPlanDAO = new com.nutrit.dao.DietPlanDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                // Redirect to appropriate dashboard
                switch (user.getRole()) {
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                        return;
                    case "patient":
                        response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                        return;
                    case "nutritionist":
                        response.sendRedirect(request.getContextPath() + "/nutritionist/dashboard");
                        return;
                    case "secretary":
                        response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
                        return;
                }
            }
        }
        
        // Fetch featured nutritionists for the landing page
        java.util.List<User> featured = userDAO.getFeaturedNutritionists(3);
        request.setAttribute("featuredNutritionists", featured);
        
        // Forward to the JSP instead of redirecting to the static HTML
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
