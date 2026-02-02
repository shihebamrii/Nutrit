package com.nutrit.controllers;

import com.nutrit.dao.UserDAO;
import com.nutrit.models.User;
import com.nutrit.utils.EmailService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) action = "/login";

        switch (action) {
            case "/login":
                showLoginForm(request, response);
                break;
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/admin/login":
                showAdminLoginForm(request, response);
                break;
            case "/forgot-password":
                showForgotPasswordForm(request, response);
                break;
            case "/reset-password":
                showResetPasswordForm(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                showLoginForm(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        switch (action) {
            case "/login":
                handleLogin(request, response);
                break;
            case "/register":
                handleRegister(request, response);
                break;
            case "/admin/login":
                handleAdminLogin(request, response);
                break;
            case "/forgot-password":
                handleForgotPassword(request, response);
                break;
            case "/reset-password":
                handleResetPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
                break;
        }
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp");
        dispatcher.forward(request, response);
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp");
        dispatcher.forward(request, response);
    }

    private void showAdminLoginForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/admin-login.jsp");
        dispatcher.forward(request, response);
    }

    private void showForgotPasswordForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp");
        dispatcher.forward(request, response);
    }

    private void showResetPasswordForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || userDAO.validateResetToken(token) == null) {
            request.setAttribute("error", "Lien de réinitialisation invalide ou expiré.");
            showForgotPasswordForm(request, response);
            return;
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp");
        dispatcher.forward(request, response);
    }

    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            // Admin portal: Only allow admin role
            if (!"admin".equals(user.getRole())) {
                request.setAttribute("error", "Accès réservé aux administrateurs.");
                showAdminLoginForm(request, response);
                return;
            }

            // Check status
            if ("pending".equals(user.getStatus())) {
                request.setAttribute("error", "Votre compte est en attente d'approbation.");
                showAdminLoginForm(request, response);
                return;
            } else if ("rejected".equals(user.getStatus())) {
                request.setAttribute("error", "Votre demande a été rejetée.");
                showAdminLoginForm(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            System.out.println("DEBUG: Admin login successful for " + user.getEmail());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect.");
            showAdminLoginForm(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            // Check status
            if ("pending".equals(user.getStatus())) {
                request.setAttribute("error", "Your account is pending Admin approval. Please wait.");
                showLoginForm(request, response);
                return;
            } else if ("rejected".equals(user.getStatus())) {
                request.setAttribute("error", "Your registration request was rejected.");
                showLoginForm(request, response);
                return;
            }

            // Role Validation
            String selectedRole = request.getParameter("role");
            if (selectedRole != null && !selectedRole.isEmpty()) {
                if (!user.getRole().equals(selectedRole) && !"admin".equals(user.getRole())) {
                     request.setAttribute("error", "Access Denied: This account is registered as a " + capitalize(user.getRole()) + ".");
                     showLoginForm(request, response);
                     return;
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect based on role
            System.out.println("DEBUG: Login successful for " + user.getEmail() + " | Role: " + user.getRole());
            switch (user.getRole()) {
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case "patient":
                    response.sendRedirect(request.getContextPath() + "/patient/posts");
                    break;
                case "nutritionist":
                    response.sendRedirect(request.getContextPath() + "/nutritionist/dashboard");
                    break;
                case "secretary":
                    response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
                    break;
                default:
                    System.out.println("DEBUG: Unknown role " + user.getRole() + ", redirecting to login");
                    response.sendRedirect(request.getContextPath() + "/auth/login");
            }
        } else {
            request.setAttribute("error", "Invalid email or password");
            showLoginForm(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String full_name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        String role = request.getParameter("role"); // dynamic
        if (role == null) role = "patient";

        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (full_name == null || email == null || password == null) {
             request.setAttribute("error", "Missing required fields");
             showRegisterForm(request, response);
             return;
        }
        
        // Input Validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Invalid email format.");
            showRegisterForm(request, response);
            return;
        }
        
        if (password.length() < 8) {
             request.setAttribute("error", "Password must be at least 8 characters long.");
             showRegisterForm(request, response);
             return;
        }

        User newUser = new User();
        newUser.setFullName(full_name);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setRole(role);
        newUser.setPhone(phone);
        newUser.setAddress(address);

        com.nutrit.models.NutritionistProfile profile = null;
        if ("nutritionist".equals(role)) {
            profile = new com.nutrit.models.NutritionistProfile();
            profile.setSpecialization(request.getParameter("specialization"));
            try { profile.setYearsExperience(Integer.parseInt(request.getParameter("years_experience"))); } catch(Exception e) {}
            profile.setLicenseNumber(request.getParameter("license_number"));
            profile.setClinicAddress(request.getParameter("clinic_address"));
            profile.setWorkingHours(request.getParameter("working_hours")); 
            try { profile.setPrice(new java.math.BigDecimal(request.getParameter("price"))); } catch(Exception e) {}
            
            // New fields
            profile.setClinicName(request.getParameter("clinic_name"));
            profile.setGovernorate(request.getParameter("governorate"));
            profile.setCity(request.getParameter("city"));
            
            String[] specs = request.getParameterValues("specialties_multi");
            if (specs != null) profile.setMultipleSpecialties(String.join(",", specs));
            
            String[] langs = request.getParameterValues("languages");
            if (langs != null) profile.setLanguages(String.join(",", langs));
            
            profile.setConsultationType(request.getParameter("consultation_type"));
            profile.setKeywords(request.getParameter("keywords"));
            profile.setDiplomas(request.getParameter("diplomas"));
            
            try {
                // Optional GPS
                 String lat = request.getParameter("latitude");
                 String lon = request.getParameter("longitude");
                 if(lat!=null && !lat.isEmpty()) profile.setLatitude(new java.math.BigDecimal(lat));
                 if(lon!=null && !lon.isEmpty()) profile.setLongitude(new java.math.BigDecimal(lon));
            } catch(Exception e) {}
        }

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already in use. Please use a different email.");
            showRegisterForm(request, response);
            return;
        }

        if (userDAO.register(newUser, profile)) {
            String msg = "Registration successful.";
            if ("nutritionist".equals(role)) {
                // Nutritionists are pending
                msg = "Registration successful. Your account is pending Admin approval.";
                request.setAttribute("success", msg);
                showLoginForm(request, response);
            } else {
                // Auto-login for Patient and Secretary
                HttpSession session = request.getSession();
                // Need to fetch the full user object with ID (registration returns boolean but we need the object)
                // Assuming email is unique, fetch it back
                User registeredUser = userDAO.authenticate(email, password);
                if (registeredUser != null) {
                    session.setAttribute("user", registeredUser);
                    
                    // Redirect based on role
                    if ("patient".equals(role)) {
                         response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                    } else if ("secretary".equals(role)) {
                         response.sendRedirect(request.getContextPath() + "/secretary/dashboard");
                    } else {
                         // Default fallback
                         response.sendRedirect(request.getContextPath() + "/auth/login");
                    }
                } else {
                     // Should not simplify happen if register returned true
                     request.setAttribute("success", "Registration successful. Please login.");
                     showLoginForm(request, response);
                }
            }
        } else {
            request.setAttribute("error", "Registration failed. Please check your input or try again.");
            showRegisterForm(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        String redirectUrl = request.getContextPath() + "/auth/login"; // Default

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && "admin".equals(user.getRole())) {
                redirectUrl = request.getContextPath() + "/"; // Admin goes to Home
            }
            session.invalidate();
        }
        response.sendRedirect(redirectUrl);
    }

    private String capitalize(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }


    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || !userDAO.emailExists(email)) {
            request.setAttribute("error", "Aucun compte n'est associé à cette adresse e-mail.");
            showForgotPasswordForm(request, response);
            return;
        }

        String token = UUID.randomUUID().toString();
        if (userDAO.setResetToken(email, token)) {
            String scheme = request.getScheme();
            String serverName = request.getServerName();
            int serverPort = request.getServerPort();
            String contextPath = request.getContextPath();
            String resetLink = scheme + "://" + serverName + ":" + serverPort + contextPath + "/auth/reset-password?token=" + token;

            if (EmailService.sendPasswordResetEmail(email, resetLink)) {
                request.setAttribute("success", "Un lien de réinitialisation a été envoyé à votre adresse e-mail.");
            } else {
                request.setAttribute("error", "Échec de l'envoi de l'e-mail. Veuillez réessayer plus tard.");
            }
        } else {
            request.setAttribute("error", "Une erreur est survenue lors de la génération du lien.");
        }
        showForgotPasswordForm(request, response);
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (token == null || userDAO.validateResetToken(token) == null) {
            request.setAttribute("error", "Le lien a expiré ou est invalide.");
            showForgotPasswordForm(request, response);
            return;
        }

        if (password == null || password.length() < 8) {
            request.setAttribute("error", "Le mot de passe doit contenir au moins 8 caractères.");
            showResetPasswordForm(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas.");
            showResetPasswordForm(request, response);
            return;
        }

        if (userDAO.updatePasswordByToken(token, password)) {
            request.setAttribute("success", "Mot de passe réinitialisé avec succès. Vous pouvez maintenant vous connecter.");
            showLoginForm(request, response);
        } else {
            request.setAttribute("error", "Échec de la mise à jour du mot de passe.");
            showResetPasswordForm(request, response);
        }
    }
}
