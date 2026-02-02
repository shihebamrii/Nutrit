package com.nutrit.controllers;

import com.nutrit.dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    
    // private UserDAO userDAO; // Will be used for user management later

    @Override
    public void init() {
        // userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) action = "/dashboard";

        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/users":
                showUsers(request, response);
                break;
            case "/deleteUser":
                deleteUser(request, response);
                break;
            case "/approvals":
                showApprovals(request, response);
                break;
            case "/approve":
                approveNutritionist(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        request.setAttribute("countAllUsers", dao.countAllUsers());
        request.setAttribute("countPatients", dao.countPatients());
        request.setAttribute("countNutritionists", dao.countNutritionists());
        request.setAttribute("recentUsers", dao.getRecentUsers(5));
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        request.setAttribute("users", dao.getNutritionists());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        UserDAO dao = new UserDAO();
        if (dao.deleteUser(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=UserDeleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=DeleteFailed");
        }
    }

    private void showApprovals(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        request.setAttribute("pendingUsers", dao.getPendingNutritionists());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/approvals.jsp");
        dispatcher.forward(request, response);
    }

    private void approveNutritionist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        UserDAO dao = new UserDAO();
        if (dao.approveNutritionist(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/approvals?success=Approved");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/approvals?error=Failed");
        }
    }
}
