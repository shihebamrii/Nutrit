package com.nutrit.controllers;

import com.nutrit.dao.CommunityDAO;
import com.nutrit.models.PostReport;
import com.nutrit.models.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/reports", "/admin/reports/review"})
public class AdminReportsServlet extends HttpServlet {
    
    private CommunityDAO communityDAO;

    @Override
    public void init() {
        communityDAO = new CommunityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check admin access
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }
        
        String filter = request.getParameter("filter");
        List<PostReport> reports;
        
        if ("pending".equals(filter)) {
            reports = communityDAO.getPendingReports();
        } else {
            reports = communityDAO.getAllReports();
        }
        
        // Get counts for tabs
        int pendingCount = communityDAO.getReportCountByStatus("pending");
        int reviewedCount = communityDAO.getReportCountByStatus("reviewed");
        int dismissedCount = communityDAO.getReportCountByStatus("dismissed");
        int actionTakenCount = communityDAO.getReportCountByStatus("action_taken");
        
        request.setAttribute("reports", reports);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("reviewedCount", reviewedCount);
        request.setAttribute("dismissedCount", dismissedCount);
        request.setAttribute("actionTakenCount", actionTakenCount);
        request.setAttribute("currentFilter", filter != null ? filter : "all");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check admin access
        if (user == null || !"admin".equals(user.getRole())) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"success\": false, \"error\": \"Admin access required\"}");
            return;
        }
        
        String path = request.getServletPath();
        
        if ("/admin/reports/review".equals(path)) {
            handleReviewReport(request, response, user);
        }
    }
    
    private void handleReviewReport(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            String action = request.getParameter("action");
            int postId = Integer.parseInt(request.getParameter("postId"));
            
            String newStatus;
            boolean deletePost = false;
            
            switch (action) {
                case "dismiss":
                    newStatus = "dismissed";
                    break;
                case "delete":
                    newStatus = "action_taken";
                    deletePost = true;
                    break;
                case "review":
                    newStatus = "reviewed";
                    break;
                default:
                    out.print("{\"success\": false, \"error\": \"Invalid action\"}");
                    out.flush();
                    return;
            }
            
            // Update report status
            boolean updated = communityDAO.updateReportStatus(reportId, newStatus, user.getId());
            
            if (updated && deletePost) {
                // Delete the post if action was delete
                communityDAO.deletePost(postId, user.getId(), true);
            }
            
            if (updated) {
                out.print("{\"success\": true, \"message\": \"Report processed successfully\", \"status\": \"" + newStatus + "\"}");
            } else {
                out.print("{\"success\": false, \"error\": \"Failed to update report\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid report or post ID\"}");
        }
        out.flush();
    }
}
