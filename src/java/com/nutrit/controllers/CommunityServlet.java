package com.nutrit.controllers;

import com.nutrit.dao.CommunityDAO;
import com.nutrit.dao.UserDAO;
import com.nutrit.models.CommunityPost;
import com.nutrit.models.PostComment;
import com.nutrit.models.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.nutrit.utils.UploadUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.util.List;

@WebServlet(urlPatterns = {
    "/patient/posts", 
    "/patient/posts/like", 
    "/patient/posts/comment", 
    "/patient/posts/comments",
    "/patient/posts/bookmark",
    "/patient/posts/bookmarks",
    "/patient/posts/report",
    "/patient/posts/delete",
    "/patient/posts/follow",
    "/patient/posts/user",
    "/patient/friends",
    "/nutritionist/posts",
    "/nutritionist/posts/like",
    "/nutritionist/posts/comment",
    "/nutritionist/posts/comments",
    "/nutritionist/posts/bookmark",
    "/nutritionist/posts/bookmarks",
    "/nutritionist/posts/report",
    "/nutritionist/posts/delete",
    "/nutritionist/posts/follow",

    "/nutritionist/posts/user",
    "/patient/followers",
    "/patient/following",
    "/nutritionist/followers",
    "/nutritionist/following"
})
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CommunityServlet extends HttpServlet {
    
    private CommunityDAO communityDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        communityDAO = new CommunityDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = (user != null) ? user.getId() : -1;
        
        switch (path) {
            case "/patient/posts/comments":
            case "/nutritionist/posts/comments":
                // AJAX: Get comments for a post
                handleGetComments(request, response);
                return;
            case "/patient/posts/bookmarks":
            case "/nutritionist/posts/bookmarks":
                // Show user's bookmarked posts
                handleShowBookmarks(request, response, user);
                return;
            case "/patient/posts/user":
            case "/nutritionist/posts/user":
                // Show user profile page
                handleShowUserProfile(request, response, user);
                return;
            case "/patient/friends":
                handleShowNetwork(request, response, user, "friends");
                return;
            case "/patient/followers":
            case "/nutritionist/followers":
                handleShowNetwork(request, response, user, "followers");
                return;
            case "/patient/following":
            case "/nutritionist/following":
                handleShowNetwork(request, response, user, "following");
                return;
            default:
                // Default: Show community feed
                List<CommunityPost> posts = communityDAO.getAllPosts(userId);
                List<CommunityPost> trendingPosts = communityDAO.getTrendingPosts(userId, 5);
                request.setAttribute("posts", posts);
                request.setAttribute("trendingPosts", trendingPosts);
                
                // Get user stats for sidebar
                if (user != null) {
                    request.setAttribute("userPostCount", communityDAO.getPostCount(userId));
                    request.setAttribute("userFollowersCount", communityDAO.getFollowersCount(userId));
                    request.setAttribute("userFollowingCount", communityDAO.getFollowingCount(userId));
                }
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/community.jsp");
                dispatcher.forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login to perform this action");
            return;
        }
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/patient/posts/like":
            case "/nutritionist/posts/like":
                handleLikeToggle(request, response, user);
                break;
            case "/patient/posts/comment":
            case "/nutritionist/posts/comment":
                handleAddComment(request, response, user);
                break;
            case "/patient/posts/bookmark":
            case "/nutritionist/posts/bookmark":
                handleBookmarkToggle(request, response, user);
                break;
            case "/patient/posts/report":
            case "/nutritionist/posts/report":
                handleReportPost(request, response, user);
                break;
            case "/patient/posts/delete":
            case "/nutritionist/posts/delete":
                handleDeletePost(request, response, user);
                break;
            case "/patient/posts/follow":
            case "/nutritionist/posts/follow":
                handleFollowToggle(request, response, user);
                break;
            default:
                handleCreatePost(request, response, user);
                break;
        }
    }
    
    private void handleCreatePost(HttpServletRequest request, HttpServletResponse response, User user) throws IOException, ServletException {
        String content = request.getParameter("content");
        
        if (content != null && !content.trim().isEmpty()) {
            CommunityPost post = new CommunityPost();
            post.setPatientId(user.getId());
            post.setContent(content);
            post.setImage(""); 
            
            // Handle image upload
            jakarta.servlet.http.Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                String fileName = UploadUtil.safeFileName(getFileName(filePart));
                String uniqueFileName = "post_" + user.getId() + "_" + System.currentTimeMillis() + "_" + fileName;
                
                String uploadDir = "assets/img";
                Path uploadPath = UploadUtil.ensureUploadDir(getServletContext(), uploadDir);
                filePart.write(uploadPath.resolve(uniqueFileName).toString());
                post.setImage(uploadDir + "/" + uniqueFileName);
            }
            
            communityDAO.createPost(post);
        }
        
        String redirectPath = "/patient/posts";
        if ("nutritionist".equals(user.getRole())) {
            redirectPath = "/nutritionist/posts";
        }
        response.sendRedirect(request.getContextPath() + redirectPath);
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
    
    private void handleLikeToggle(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            boolean isNowLiked = communityDAO.toggleLike(postId, user.getId());
            int newLikeCount = communityDAO.getLikeCount(postId);
            
            out.print("{\"success\": true, \"liked\": " + isNowLiked + ", \"likeCount\": " + newLikeCount + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
        }
        out.flush();
    }
    
    private void handleAddComment(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String content = request.getParameter("content");
            
            if (content == null || content.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Comment cannot be empty\"}");
                out.flush();
                return;
            }
            
            boolean added = communityDAO.addComment(postId, user.getId(), content.trim());
            int newCommentCount = communityDAO.getCommentCount(postId);
            
            if (added) {
                out.print("{\"success\": true, \"commentCount\": " + newCommentCount + 
                         ", \"userName\": \"" + escapeJson(user.getFullName()) + "\"}");
            } else {
                out.print("{\"success\": false, \"error\": \"Failed to add comment\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
        }
        out.flush();
    }
    
    private void handleGetComments(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            List<PostComment> comments = communityDAO.getCommentsByPostId(postId);
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < comments.size(); i++) {
                PostComment c = comments.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"id\":").append(c.getId()).append(",")
                    .append("\"userId\":").append(c.getUserId()).append(",")
                    .append("\"userName\":\"").append(escapeJson(c.getUserName())).append("\",")
                    .append("\"content\":\"").append(escapeJson(c.getContent())).append("\",")
                    .append("\"createdAt\":\"").append(c.getCreatedAt()).append("\"")
                    .append("}");
            }
            json.append("]");
            
            out.print(json.toString());
        } catch (NumberFormatException e) {
            out.print("[]");
        }
        out.flush();
    }
    
    private void handleBookmarkToggle(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            boolean isNowBookmarked = communityDAO.toggleBookmark(postId, user.getId());
            int newBookmarkCount = communityDAO.getBookmarkCount(postId);
            
            out.print("{\"success\": true, \"bookmarked\": " + isNowBookmarked + ", \"bookmarkCount\": " + newBookmarkCount + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
        }
        out.flush();
    }
    
    private void handleShowBookmarks(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<CommunityPost> posts = communityDAO.getBookmarkedPosts(user.getId());
        request.setAttribute("posts", posts);
        request.setAttribute("pageTitle", "Saved Posts");
        request.setAttribute("showingBookmarks", true);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/community.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleReportPost(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String reason = request.getParameter("reason");
            String description = request.getParameter("description");
            
            if (reason == null || reason.trim().isEmpty()) {
                out.print("{\"success\": false, \"error\": \"Please select a reason for reporting\"}");
                out.flush();
                return;
            }
            
            // Check if already reported
            if (communityDAO.hasUserReported(postId, user.getId())) {
                out.print("{\"success\": false, \"error\": \"You have already reported this post\"}");
                out.flush();
                return;
            }
            
            boolean reported = communityDAO.createReport(postId, user.getId(), reason, description);
            
            if (reported) {
                out.print("{\"success\": true, \"message\": \"Post reported successfully. Our team will review it.\"}");
            } else {
                out.print("{\"success\": false, \"error\": \"Failed to report post\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
        }
        out.flush();
    }
    
    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            boolean isAdmin = "admin".equals(user.getRole());
            
            boolean deleted = communityDAO.deletePost(postId, user.getId(), isAdmin);
            
            if (deleted) {
                out.print("{\"success\": true, \"message\": \"Post deleted successfully\"}");
            } else {
                out.print("{\"success\": false, \"error\": \"Unable to delete post. You may not have permission.\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
        }
        out.flush();
    }
    
    private void handleFollowToggle(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            
            if (targetUserId == user.getId()) {
                out.print("{\"success\": false, \"error\": \"You cannot follow yourself\"}");
                out.flush();
                return;
            }
            
            boolean isNowFollowing = communityDAO.toggleFollow(user.getId(), targetUserId);
            int newFollowersCount = communityDAO.getFollowersCount(targetUserId);
            
            out.print("{\"success\": true, \"following\": " + isNowFollowing + ", \"followersCount\": " + newFollowersCount + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"error\": \"Invalid user ID\"}");
        }
        out.flush();
    }
    
    private void handleShowUserProfile(HttpServletRequest request, HttpServletResponse response, User currentUser) throws ServletException, IOException {
        int currentUserId = (currentUser != null) ? currentUser.getId() : -1;
        
        try {
            int profileUserId = Integer.parseInt(request.getParameter("id"));
            
            // Get user info
            User profileUser = userDAO.getUserById(profileUserId);
            if (profileUser == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            
            // Get user's posts
            List<CommunityPost> posts = communityDAO.getPostsByUser(profileUserId, currentUserId);
            
            // Get user stats
            int postCount = communityDAO.getPostCount(profileUserId);
            int followersCount = communityDAO.getFollowersCount(profileUserId);
            int followingCount = communityDAO.getFollowingCount(profileUserId);
            boolean isFollowing = currentUserId > 0 && communityDAO.isFollowing(currentUserId, profileUserId);
            boolean isFollower = currentUserId > 0 && communityDAO.isFollowing(profileUserId, currentUserId);
            
            request.setAttribute("profileUser", profileUser);
            request.setAttribute("posts", posts);
            request.setAttribute("postCount", postCount);
            request.setAttribute("followersCount", followersCount);
            request.setAttribute("followingCount", followingCount);
            request.setAttribute("isFollowing", isFollowing);
            request.setAttribute("isFollower", isFollower);
            request.setAttribute("isOwnProfile", currentUserId == profileUserId);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/user_profile.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        }
    }
    
    private void handleShowNetwork(HttpServletRequest request, HttpServletResponse response, User user, String type) throws ServletException, IOException {
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<User> users;
        String title;
        String desc;
        
        switch (type) {
            case "followers":
                users = communityDAO.getFollowers(user.getId());
                title = "My Followers";
                desc = "People who follow you.";
                break;
            case "following":
                users = communityDAO.getFollowing(user.getId());
                title = "Following";
                desc = "People you follow.";
                break;
            default: // friends
                users = communityDAO.getFriends(user.getId());
                title = "My Friends";
                desc = "Mutual followers.";
                break;
        }
        
        // Get user stats for sidebar
        request.setAttribute("userPostCount", communityDAO.getPostCount(user.getId()));
        request.setAttribute("userFollowersCount", communityDAO.getFollowersCount(user.getId()));
        request.setAttribute("userFollowingCount", communityDAO.getFollowingCount(user.getId()));
        
        request.setAttribute("friends", users); // Reusing 'friends' attribute for list
        request.setAttribute("pageTitle", title);
        request.setAttribute("pageDescription", desc);
        request.setAttribute("activeTab", type);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/patient/friends_list.jsp");
        dispatcher.forward(request, response);
    }
    
    // Legacy method removed/replaced by handleShowNetwork
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
