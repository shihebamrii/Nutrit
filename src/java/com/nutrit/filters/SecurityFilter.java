package com.nutrit.filters;

import com.nutrit.models.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter to enforce authentication and role-based authorization.
 */
@WebFilter("/*")
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Public resources that don't need login
        boolean isPublic = path.startsWith("/assets/") || 
                           path.startsWith("/auth/") || 
                           path.equals("/") || 
                           path.equals("/home") || 
                           path.startsWith("/public/") ||
                           path.startsWith("/landing") ||
                           path.startsWith("/experts") ||
                           path.startsWith("/profile") ||
                           path.equals("/service-worker.js") ||
                           path.equals("/manifest.json");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Check Authentication
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Check Authorization (Role-Based)
        String role = user.getRole();
        
        // Admin Pages
        if (path.startsWith("/admin/") && !"admin".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // Nutritionist Pages
        if (path.startsWith("/nutritionist/") && !"nutritionist".equals(role)) {
            // Special exemption: Patient seeing nutritionist profile (usually /patient/nutritionist-profile, handled by path prefix)
            // But if there are shared resources, handle here.
            
            // Allow secretaries to access some nutritionist resources?
            // Current logic: strict separation. Secretaries have their own /secretary/ path.
            if (!"nutritionist".equals(role)) {
                 res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                 return;
            }
        }
        
        // Secretary Pages
        if (path.startsWith("/secretary/") && !"secretary".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // Patient Pages
        if (path.startsWith("/patient/") && !"patient".equals(role)) {
             res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
             return;
        }

        // If all checks pass
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup
    }
}
