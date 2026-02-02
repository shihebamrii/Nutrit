package com.nutrit.controllers;

import com.nutrit.dao.NutritionistDAO;
import com.nutrit.dao.UserDAO;
import com.nutrit.models.NutritionistProfile;
import com.nutrit.models.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.nutrit.utils.UploadUtil;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Path;

@WebServlet("/profile")
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private NutritionistDAO nutritionistDAO = new NutritionistDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Refresh user data from DB to ensure latest
        User freshUser = userDAO.getUserById(user.getId());
        // Map nutritionist profile to transient field if applicable
        if ("nutritionist".equals(freshUser.getRole())) {
             NutritionistProfile profile = nutritionistDAO.getProfileByUserId(user.getId());
             request.setAttribute("nutritionistProfile", profile);
             // Also set it on the user object for convenience if needed later
             freshUser.setNutritionistProfile(profile);
        }
        
        request.setAttribute("user", freshUser); // Overwrite session user in request scope for form

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/common/settings.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getParameter("action");
        boolean success = false;

        if ("updateBasic".equals(action)) {
            User updatedUser = new User();
            updatedUser.setId(sessionUser.getId());
            updatedUser.setFullName(request.getParameter("fullName"));
            updatedUser.setPhone(request.getParameter("phone"));
            updatedUser.setAddress(request.getParameter("address"));
            
            // 1. Update basic info
            boolean basicSuccess = userDAO.updateBasicInfo(updatedUser);
            
            // 2. Update bio and profile picture
            String bio = request.getParameter("communityBio");
            String profilePicPath = null; // Don't update if null
            
            jakarta.servlet.http.Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                String fileName = UploadUtil.safeFileName(getFileName(filePart));
                // Simple unique filename
                String uniqueFileName = "user_" + sessionUser.getId() + "_" + System.currentTimeMillis() + "_" + fileName;
                
                String uploadDir = "assets/img";
                Path uploadPath = UploadUtil.ensureUploadDir(getServletContext(), uploadDir);
                filePart.write(uploadPath.resolve(uniqueFileName).toString());
                
                // Store relative path for DB (assets/img/filename)
                profilePicPath = uploadDir + "/" + uniqueFileName;
            }
            
            boolean profileSuccess = userDAO.updateProfileDetails(sessionUser.getId(), bio, profilePicPath);
            
            success = basicSuccess && profileSuccess;
            
            if(success) {
                // Update session
                sessionUser.setFullName(updatedUser.getFullName());
                sessionUser.setPhone(updatedUser.getPhone());
                sessionUser.setAddress(updatedUser.getAddress());
                sessionUser.setBio(bio);
                if (profilePicPath != null) {
                    sessionUser.setProfilePicture(profilePicPath);
                }
            }

        } else if ("updatePassword".equals(action)) {
            String newPass = request.getParameter("newPassword");
            String confirmPass = request.getParameter("confirmPassword");
            
            if (newPass != null && newPass.equals(confirmPass) && !newPass.isEmpty()) {
                success = userDAO.updatePassword(sessionUser.getId(), newPass);
            }

        } else if ("updateNutritionist".equals(action) && "nutritionist".equals(sessionUser.getRole())) {
            NutritionistProfile profile = new NutritionistProfile();
            profile.setSpecialization(request.getParameter("specialization"));
            profile.setYearsExperience(Integer.parseInt(request.getParameter("yearsExperience")));
            profile.setLicenseNumber(request.getParameter("licenseNumber"));
            profile.setClinicAddress(request.getParameter("clinicAddress"));
            profile.setWorkingHours(request.getParameter("workingHours"));
            try {
                profile.setPrice(new BigDecimal(request.getParameter("price")));
            } catch (NumberFormatException e) { profile.setPrice(BigDecimal.ZERO); }
            profile.setBio(request.getParameter("bio"));
            
            success = userDAO.updateNutritionistProfile(sessionUser.getId(), profile);
        }

        if (success) {
            request.setAttribute("successMessage", "Settings updated successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to update settings.");
        }

        doGet(request, response);
    }
    
    private String getFileName(jakarta.servlet.http.Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
