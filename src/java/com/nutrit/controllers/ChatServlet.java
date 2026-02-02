package com.nutrit.controllers;

import com.nutrit.dao.ChatDAO;
import com.nutrit.dao.UserDAO;
import com.nutrit.models.ChatMessage;
import com.nutrit.models.User;
import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/chat/*")
public class ChatServlet extends HttpServlet {
    
    private ChatDAO chatDAO = new ChatDAO();
    private UserDAO userDAO = new UserDAO();
    private com.nutrit.dao.CommunityDAO communityDAO = new com.nutrit.dao.CommunityDAO();
    private com.nutrit.dao.PatientRequestDAO requestDAO = new com.nutrit.dao.PatientRequestDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        com.nutrit.models.User currentUser = (com.nutrit.models.User) request.getSession().getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (action == null || "/".equals(action)) {
            showChatInterface(request, response, currentUser);
        } else if ("/poll".equals(action)) {
            getMessages(request, response, currentUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if ("/send".equals(action)) {
            sendMessage(request, response);
        }
    }

    @SuppressWarnings("unchecked")
    private void showChatInterface(HttpServletRequest request, HttpServletResponse response, User currentUser) throws ServletException, IOException {
        int otherUserId = -1;
        String otherUserIdParam = request.getParameter("userId");
        
        // Fetch contacts
        List<User> friends = communityDAO.getFriends(currentUser.getId());
        User nutritionist = null;
        
        if ("patient".equals(currentUser.getRole())) {
            int nutritionistId = requestDAO.getMyNutritionistId(currentUser.getId());
            if (nutritionistId > 0) {
                nutritionist = userDAO.getUserById(nutritionistId);
            }
        } else if ("nutritionist".equals(currentUser.getRole())) {
            // Nutritionists see their patients
            List<User> patients = requestDAO.getPatientsByNutritionist(currentUser.getId());
            request.setAttribute("patients", patients);
        } else if ("secretary".equals(currentUser.getRole())) {
            // Secretaries see their nutritionist and the nutritionist's patients
            int nutritionistId = userDAO.getNutritionistIdBySecretary(currentUser.getId());
            if (nutritionistId > 0) {
                 nutritionist = userDAO.getUserById(nutritionistId);
                 List<User> patients = requestDAO.getPatientsByNutritionist(nutritionistId);
                 request.setAttribute("patients", patients);
            }
        }
        
        request.setAttribute("friends", friends);
        request.setAttribute("nutritionist", nutritionist);
        
        if (otherUserIdParam != null) {
            otherUserId = Integer.parseInt(otherUserIdParam);
        } else {
            // Auto-detect default conversation
            if (nutritionist != null) {
                otherUserId = nutritionist.getId();
            } else if (request.getAttribute("patients") != null) {
                List<User> patients = (List<User>) request.getAttribute("patients");
                if (!patients.isEmpty()) otherUserId = patients.get(0).getId();
            } else if (!friends.isEmpty()) {
                otherUserId = friends.get(0).getId();
            }
        }
        
        if (otherUserId != -1) {
            User otherUser = userDAO.getUserById(otherUserId);
            // Verify access (is friend or nutritionist/patient relation) - skipping deep validation for demo
            
            if (otherUser != null) {
                request.setAttribute("otherUser", otherUser);
                List<ChatMessage> history = chatDAO.getConversation(currentUser.getId(), otherUserId);
                request.setAttribute("chatHistory", history);
            }
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/common/chat.jsp");
        dispatcher.forward(request, response);
    }
    
    private void getMessages(HttpServletRequest request, HttpServletResponse response, User currentUser) throws IOException {
        String otherIdStr = request.getParameter("userId");
        if (otherIdStr != null) {
            int otherId = Integer.parseInt(otherIdStr);
            List<ChatMessage> messages = chatDAO.getConversation(currentUser.getId(), otherId);
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(messages));
        }
    }

    private void sendMessage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) return;

        String receiverIdStr = request.getParameter("receiverId");
        String message = request.getParameter("message");
        
        if (receiverIdStr != null && message != null && !message.trim().isEmpty()) {
            int receiverId = Integer.parseInt(receiverIdStr);
            ChatMessage msg = new ChatMessage();
            msg.setSenderId(currentUser.getId());
            msg.setReceiverId(receiverId);
            msg.setMessage(message);
            
            boolean success = chatDAO.sendMessage(msg);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": " + success + "}");
        }
    }
}
