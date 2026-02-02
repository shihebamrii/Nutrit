<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nutrit.models.CommunityPost" %>
<%@ page import="com.nutrit.models.PostComment" %>
<%@ page import="com.nutrit.models.User" %>
<% 
    User currentUser = (User) session.getAttribute("user"); 
    int currentUserId = (currentUser != null) ? currentUser.getId() : -1;
    String pageTitle = (String) request.getAttribute("pageTitle");
    Boolean showingBookmarks = (Boolean) request.getAttribute("showingBookmarks");
    Integer userPostCount = (Integer) request.getAttribute("userPostCount");
    Integer userFollowersCount = (Integer) request.getAttribute("userFollowersCount");
    Integer userFollowingCount = (Integer) request.getAttribute("userFollowingCount");
    List<CommunityPost> trendingPosts = (List<CommunityPost>) request.getAttribute("trendingPosts");
    String userRole = (currentUser != null) ? currentUser.getRole() : "patient";
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle != null ? pageTitle : "Fil d'Actualité" %> - Nutrit</title>
    <meta name="description" content="Partagez votre parcours de santé et connectez-vous avec d'autres patients de la communauté Nutrit.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* Community Feed Layout - Centered 3-Column */
        .community-layout {
            display: flex;
            gap: 1.5rem;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }
        
        .community-sidebar-left {
            width: 280px;
            flex-shrink: 0;
        }
        
        .community-main {
            flex: 1;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .community-sidebar-right {
            width: 300px;
            flex-shrink: 0;
        }
        
        @media (max-width: 1100px) {
            .community-sidebar-right {
                display: none;
            }
        }
        
        @media (max-width: 800px) {
            .community-sidebar-left {
                display: none;
            }
            .community-main {
                max-width: 100%;
            }
        }
        
        /* Profile Card */
        .profile-card {
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            padding: 1.5rem;
            text-align: center;
            position: sticky;
            top: 100px;
        }
        
        .profile-avatar-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 700;
            font-size: 1.75rem;
            margin: 0 auto 1rem;
            box-shadow: var(--shadow-lg);
        }
        
        .profile-name {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 0.25rem;
        }
        
        .profile-role {
            font-size: 0.8125rem;
            color: var(--gray-500);
            margin-bottom: 1rem;
        }
        
        .profile-stats {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            padding: 1rem 0;
            border-top: 1px solid var(--gray-100);
            border-bottom: 1px solid var(--gray-100);
            margin-bottom: 1rem;
        }
        
        .profile-stat {
            text-align: center;
        }
        
        .profile-stat-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        
        .profile-stat-label {
            font-size: 0.75rem;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .profile-nav {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .profile-nav-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: var(--radius-lg);
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 500;
            transition: all var(--transition-fast);
        }
        
        .profile-nav-item:hover {
            background: var(--gray-100);
            color: var(--primary);
        }
        
        .profile-nav-item.active {
            background: var(--primary-100);
            color: var(--primary-700);
        }
        
        .profile-nav-item i {
            font-size: 1.25rem;
        }

        /* Post Card Styles */
        .post-card {
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            margin-bottom: 1.25rem;
            transition: all var(--transition-normal);
        }

        .post-card:hover {
            box-shadow: var(--shadow-lg);
        }

        .post-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--gray-100);
        }

        .post-avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 600;
            font-size: 0.9rem;
            flex-shrink: 0;
            cursor: pointer;
            transition: transform var(--transition-fast);
        }
        
        .post-avatar:hover {
            transform: scale(1.05);
        }

        .post-author {
            font-weight: 600;
            color: var(--gray-800);
            cursor: pointer;
        }
        
        .post-author:hover {
            color: var(--primary);
        }

        .post-time {
            font-size: 0.8125rem;
            color: var(--gray-500);
        }
        
        .post-header-actions {
            margin-left: auto;
            position: relative;
        }
        
        .post-menu-btn {
            background: none;
            border: none;
            padding: 0.5rem;
            cursor: pointer;
            color: var(--gray-400);
            border-radius: var(--radius-md);
            transition: all var(--transition-fast);
        }
        
        .post-menu-btn:hover {
            background: var(--gray-100);
            color: var(--gray-600);
        }
        
        .post-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            min-width: 180px;
            padding: 0.5rem;
            z-index: 100;
            display: none;
        }
        
        .post-menu.show {
            display: block;
        }
        
        .post-menu-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.625rem 0.875rem;
            border-radius: var(--radius-md);
            color: var(--gray-700);
            font-size: 0.875rem;
            cursor: pointer;
            transition: all var(--transition-fast);
            border: none;
            background: none;
            width: 100%;
            text-align: left;
        }
        
        .post-menu-item:hover {
            background: var(--gray-100);
        }
        
        .post-menu-item.danger {
            color: var(--error);
        }
        
        .post-menu-item.danger:hover {
            background: var(--error-light);
        }

        .post-content {
            padding: 1.25rem 1.5rem;
            color: var(--gray-700);
            line-height: 1.7;
        }

        .post-stats {
            display: flex;
            gap: 1rem;
            padding: 0.75rem 1.5rem;
            color: var(--gray-500);
            font-size: 0.8125rem;
            border-bottom: 1px solid var(--gray-100);
        }

        .post-stats span {
            cursor: pointer;
            transition: color var(--transition-fast);
        }

        .post-stats span:hover {
            color: var(--primary);
        }

        .post-actions {
            display: flex;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-top: 1px solid var(--gray-100);
        }

        .post-action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            color: var(--gray-500);
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-fast);
            background: none;
            border: none;
            padding: 0.625rem 1rem;
            border-radius: var(--radius-md);
            flex: 1;
        }

        .post-action-btn:hover {
            background: var(--gray-100);
            color: var(--primary);
        }

        .post-action-btn.liked {
            color: #ef4444;
        }

        .post-action-btn.liked:hover {
            background: rgba(239, 68, 68, 0.1);
        }

        .post-action-btn.liked i {
            animation: heartBeat 0.3s ease-in-out;
        }
        
        .post-action-btn.bookmarked {
            color: var(--warning);
        }
        
        .post-action-btn.bookmarked:hover {
            background: rgba(245, 158, 11, 0.1);
        }

        @keyframes heartBeat {
            0% { transform: scale(1); }
            50% { transform: scale(1.3); }
            100% { transform: scale(1); }
        }

        .post-action-btn i {
            font-size: 1.25rem;
        }

        /* Comments Section */
        .comments-section {
            border-top: 1px solid var(--gray-100);
            padding: 1rem 1.5rem;
            display: none;
        }

        .comments-section.show {
            display: block;
        }

        .comment-form {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .comment-form input {
            flex: 1;
            padding: 0.625rem 1rem;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-full);
            font-size: 0.875rem;
            background: var(--gray-50);
            transition: all var(--transition-fast);
        }

        .comment-form input:focus {
            outline: none;
            border-color: var(--primary);
            background: var(--card);
        }

        .comment-form button {
            padding: 0.625rem 1.25rem;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: var(--radius-full);
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-fast);
        }

        .comment-form button:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .comment-form button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .comments-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .comment-item {
            display: flex;
            gap: 0.75rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--gray-50);
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--gray-400), var(--gray-500));
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 600;
            font-size: 0.7rem;
            flex-shrink: 0;
        }

        .comment-content {
            flex: 1;
            background: var(--gray-50);
            padding: 0.625rem 0.875rem;
            border-radius: var(--radius-lg);
        }

        .comment-author {
            font-weight: 600;
            font-size: 0.8125rem;
            color: var(--gray-800);
            margin-bottom: 0.25rem;
        }

        .comment-text {
            font-size: 0.875rem;
            color: var(--gray-700);
            line-height: 1.5;
        }

        .comment-time {
            font-size: 0.6875rem;
            color: var(--gray-400);
            margin-top: 0.25rem;
        }

        .no-comments {
            text-align: center;
            color: var(--gray-400);
            padding: 1rem;
            font-size: 0.875rem;
        }

        /* Compose Card */
        .compose-card {
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .compose-card textarea {
            border: none;
            background: var(--gray-50);
            resize: none;
        }

        .compose-card textarea:focus {
            box-shadow: none;
            background: var(--gray-100);
        }
        
        /* Trending Card */
        .trending-card {
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            padding: 1.25rem;
            position: sticky;
            top: 100px;
        }
        
        .trending-header {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 1rem;
        }
        
        .trending-header i {
            color: var(--warning);
        }
        
        .trending-post {
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--gray-100);
        }
        
        .trending-post:last-child {
            border-bottom: none;
        }
        
        .trending-author {
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.25rem;
        }
        
        .trending-content {
            font-size: 0.8125rem;
            color: var(--gray-600);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .trending-stats {
            display: flex;
            gap: 1rem;
            margin-top: 0.5rem;
            font-size: 0.75rem;
            color: var(--gray-400);
        }

        /* Report Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .modal-overlay.show {
            display: flex;
        }
        
        .modal-content {
            background: var(--card);
            border-radius: var(--radius-xl);
            padding: 1.5rem;
            width: 100%;
            max-width: 400px;
            box-shadow: var(--shadow-2xl);
        }
        
        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        
        .modal-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--gray-800);
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--gray-400);
            cursor: pointer;
            padding: 0.25rem;
        }
        
        .modal-close:hover {
            color: var(--gray-600);
        }
        
        .report-options {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .report-option {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        
        .report-option:hover {
            border-color: var(--primary);
            background: var(--primary-50);
        }
        
        .report-option.selected {
            border-color: var(--primary);
            background: var(--primary-100);
        }
        
        .report-option input {
            accent-color: var(--primary);
        }

        .loading-spinner {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Page Header */
        .page-header-community {
            margin-bottom: 1.5rem;
        }
        
        .page-header-community h1 {
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }
        
        .page-header-community p {
            color: var(--gray-500);
            font-size: 0.875rem;
        }
        
        /* Tab Navigation */
        .feed-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            background: var(--card);
            padding: 0.5rem;
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
        }
        
        .feed-tab {
            flex: 1;
            padding: 0.75rem 1rem;
            border: none;
            background: none;
            border-radius: var(--radius-lg);
            font-weight: 500;
            color: var(--gray-500);
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        
        .feed-tab:hover {
            color: var(--gray-700);
        }
        
        .feed-tab.active {
            background: var(--primary);
            color: white;
        }
    </style>
</head>

<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="page-content">
                <div class="community-layout">
                    <!-- Left Sidebar - Profile Card -->
                    <aside class="community-sidebar-left">
                        <% if (currentUser != null) { 
                            String fullName = currentUser.getFullName() != null ? currentUser.getFullName() : "User";
                            String[] namesParts = fullName.split(" ");
                            String initials = namesParts[0].substring(0, 1);
                            if (namesParts.length > 1) initials += namesParts[namesParts.length - 1].substring(0, 1);
                        %>
                        <div class="profile-card animate-fade-in">
                            <div class="profile-avatar-large">
                                <%= initials.toUpperCase() %>
                            </div>
                            <div class="profile-name"><%= fullName %></div>
                            <div class="profile-role"><%= currentUser.getRole() != null ? currentUser.getRole().substring(0, 1).toUpperCase() + currentUser.getRole().substring(1) : "Membre" %></div>
                            <div class="profile-stats">
                                <div class="profile-stat">
                                    <div class="profile-stat-value"><%= userPostCount != null ? userPostCount : 0 %></div>
                                    <div class="profile-stat-label">Pub</div>
                                </div>
                                <div class="profile-stat">
                                    <div class="profile-stat-value"><%= userFollowersCount != null ? userFollowersCount : 0 %></div>
                                    <div class="profile-stat-label">Abonnés</div>
                                </div>
                                <div class="profile-stat">
                                    <div class="profile-stat-value"><%= userFollowingCount != null ? userFollowingCount : 0 %></div>
                                    <div class="profile-stat-label">Abonnements</div>
                                </div>
                            </div>
                            <nav class="profile-nav">
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/posts" class="profile-nav-item <%= showingBookmarks == null || !showingBookmarks ? "active" : "" %>">
                                    <i class="ph ph-house"></i>
                                    <span>Feed</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/posts/bookmarks" class="profile-nav-item <%= showingBookmarks != null && showingBookmarks ? "active" : "" %>">
                                    <i class="ph ph-bookmark-simple"></i>
                                    <span>Saved Posts</span>
                                </a>
                                <% if ("nutritionist".equals(userRole)) { %>
                                <a href="${pageContext.request.contextPath}/nutritionist/patients" class="profile-nav-item">
                                    <i class="ph ph-users-three"></i>
                                    <span>My Patients</span>
                                </a>
                                <% } %>
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/friends" class="profile-nav-item">
                                    <i class="ph ph-users"></i>
                                    <span>My Network</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/posts/user?id=<%= currentUser.getId() %>" class="profile-nav-item">
                                    <i class="ph ph-user"></i>
                                    <span>My Profile</span>
                                </a>
                            </nav>
                        </div>
                        <% } %>
                    </aside>
                    
                    <!-- Main Feed -->
                    <div class="community-main">
                        <div class="page-header-community">
                            <h1><%= pageTitle != null ? pageTitle : "Fil d'Actualité" %></h1>
                            <p><%= showingBookmarks != null && showingBookmarks ? "Vos posts sauvegardés" : "Partagez vos progrès et connectez-vous avec d'autres." %></p>
                        </div>

                        <% if (showingBookmarks == null || !showingBookmarks) { %>
                        <div class="compose-card animate-fade-in">
                            <form action="${pageContext.request.contextPath}/<%= userRole %>/posts" method="POST" enctype="multipart/form-data">
                                <div class="form-group" style="margin-bottom: 1rem;">
                                    <textarea name="content" class="input" rows="3"
                                        placeholder="Partagez vos progrès, astuces, ou posez une question..."
                                        required></textarea>
                                </div>
                                <div id="imagePreviewContainer" style="display: none; margin-bottom: 1rem; position: relative; width: fit-content;">
                                    <img id="imagePreview" src="" alt="Preview" style="max-height: 200px; border-radius: var(--radius-lg); border: 1px solid var(--border);">
                                    <button type="button" onclick="clearImage()" style="position: absolute; top: -10px; right: -10px; background: var(--error); color: white; border: none; border-radius: 50%; width: 24px; height: 24px; cursor: pointer; display: flex; align-items: center; justify-content: center;">
                                        <i class="ph ph-x"></i>
                                    </button>
                                </div>
                                <input type="file" name="image" id="postImageInput" style="display: none;" accept="image/*" onchange="previewImage(this)">
                                <div class="flex justify-between items-center">
                                    <div class="flex gap-2">
                                        <button type="button" class="btn btn-ghost btn-sm" title="Ajouter photo" onclick="document.getElementById('postImageInput').click()">
                                            <i class="ph ph-image"></i>
                                            <span>Photo</span>
                                        </button>
                                        <button type="button" class="btn btn-ghost btn-sm" title="Add emoji">
                                            <i class="ph ph-smiley"></i>
                                        </button>
                                    </div>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="ph ph-paper-plane-right"></i> Publier
                                    </button>
                                </div>
                            </form>
                        </div>
                        <% } %>

                        <div class="posts-list">
                            <% List<CommunityPost> posts = (List<CommunityPost>) request.getAttribute("posts");
                                if (posts != null && !posts.isEmpty()) {
                                for(CommunityPost post : posts) {
                                String patientName = post.getPatientName();
                                String[] names = patientName != null ? patientName.split(" ") : new String[]{"U"};
                                String initials = names[0].substring(0, 1);
                                if (names.length > 1) initials += names[names.length - 1].substring(0, 1);
                                boolean userLiked = post.isUserHasLiked();
                                boolean userBookmarked = post.isUserHasBookmarked();
                                boolean isOwnPost = currentUserId == post.getPatientId();
                            %>
                            <div class="post-card animate-fade-in" data-post-id="<%= post.getId() %>">
                                <div class="post-header">
                                    <div class="post-avatar" onclick="viewProfile(<%= post.getPatientId() %>)">
                                        <%= initials.toUpperCase() %>
                                    </div>
                                    <div>
                                        <div class="post-author" onclick="viewProfile(<%= post.getPatientId() %>)">
                                            <%= post.getPatientName() %>
                                        </div>
                                        <div class="post-time">
                                            <i class="ph ph-clock mr-1"></i>
                                            <%= post.getCreatedAt() %>
                                        </div>
                                    </div>
                                    <div class="post-header-actions">
                                        <button class="post-menu-btn" onclick="togglePostMenu(<%= post.getId() %>)">
                                            <i class="ph ph-dots-three"></i>
                                        </button>
                                        <div class="post-menu" id="post-menu-<%= post.getId() %>">
                                            <% if (isOwnPost) { %>
                                            <button class="post-menu-item danger" onclick="deletePost(<%= post.getId() %>)">
                                                <i class="ph ph-trash"></i>
                                                <span>Supprimer</span>
                                            </button>
                                            <% } else { %>
                                            <button class="post-menu-item" onclick="showReportModal(<%= post.getId() %>)">
                                                <i class="ph ph-flag"></i>
                                                <span>Signaler</span>
                                            </button>
                                            <% } %>
                                            <button class="post-menu-item" onclick="copyLink(<%= post.getId() %>)">
                                                <i class="ph ph-link"></i>
                                                <span>Copier le lien</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="post-content">
                                    <%= post.getContent() %>
                                    <% if (post.getImage() != null && !post.getImage().isEmpty()) { %>
                                    <div style="margin-top: 1rem; border-radius: var(--radius-lg); overflow: hidden;">
                                        <img src="${pageContext.request.contextPath}/<%= post.getImage() %>" alt="Post image" style="width: 100%; max-height: 500px; object-fit: cover;">
                                    </div>
                                    <% } %>
                                </div>

                                <div class="post-stats">
                                    <span class="likes-count" onclick="toggleComments(<%= post.getId() %>)">
                                        <i class="ph-fill ph-heart" style="color: #ef4444;"></i>
                                        <span id="like-count-<%= post.getId() %>">
                                            <%= post.getLikeCount() %></span> j'aime
                                    </span>
                                    <span class="comments-count" onclick="toggleComments(<%= post.getId() %>)">
                                        <span id="comment-count-<%= post.getId() %>"><%= post.getCommentCount() %></span> commentaires
                                    </span>
                                    <span class="bookmarks-count">
                                        <span id="bookmark-count-<%= post.getId() %>"><%= post.getBookmarkCount() %></span> sauvegardes
                                    </span>
                                </div>

                                <div class="post-actions">
                                    <button type="button"
                                        class="post-action-btn<%= userLiked ? " liked" : "" %>"
                                        id="like-btn-<%= post.getId() %>" 
                                        onclick="toggleLike(<%= post.getId() %>)">
                                        <i class="<%= userLiked ? "ph-fill" : "ph" %> ph-heart"></i>
                                        <span>J'aime</span>
                                    </button>
                                    <button type="button" class="post-action-btn" onclick="toggleComments(<%= post.getId() %>)">
                                        <i class="ph ph-chat-circle"></i>
                                        <span>Commenter</span>
                                    </button>
                                    <button type="button"
                                        class="post-action-btn<%= userBookmarked ? " bookmarked" : "" %>"
                                        id="bookmark-btn-<%= post.getId() %>"
                                        onclick="toggleBookmark(<%= post.getId() %>)">
                                        <i class="<%= userBookmarked ? "ph-fill" : "ph" %> ph-bookmark-simple"></i>
                                        <span>Sauvegarder</span>
                                    </button>
                                    <button type="button" class="post-action-btn" onclick="sharePost(<%= post.getId() %>)">
                                        <i class="ph ph-share-network"></i>
                                        <span>Partager</span>
                                    </button>
                                </div>

                                <div class="comments-section" id="comments-section-<%= post.getId() %>">
                                    <div class="comment-form">
                                        <input type="text" id="comment-input-<%= post.getId() %>"
                                            placeholder="Écrire un commentaire..."
                                            onkeypress="if(event.key === 'Enter') submitComment(<%= post.getId() %>)">
                                        <button type="button" onclick="submitComment(<%= post.getId() %>)">
                                            <i class="ph ph-paper-plane-right"></i>
                                        </button>
                                    </div>
                                    <div class="comments-list" id="comments-list-<%= post.getId() %>">
                                        <div class="no-comments">Chargement des commentaires...</div>
                                    </div>
                                </div>
                            </div>
                            <% } } else { %>
                            <div class="card animate-fade-in">
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <i class="ph ph-chat-circle-dots"></i>
                                    </div>
                                    <div class="empty-state-title"><%= showingBookmarks != null && showingBookmarks ? "Aucun Post Sauvegardé" : "Aucun Post Pour l'Instant" %></div>
                                    <div class="empty-state-text"><%= showingBookmarks != null && showingBookmarks ? "Les posts que vous sauvegardez apparaîtront ici." : "Soyez le premier à partager quelque chose avec la communauté !" %></div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Right Sidebar - Trending -->
                    <aside class="community-sidebar-right">
                        <% if (trendingPosts != null && !trendingPosts.isEmpty()) { %>
                        <div class="trending-card animate-fade-in">
                            <div class="trending-header">
                                <i class="ph-fill ph-fire"></i>
                                <span>Tendances</span>
                            </div>
                            <% for (CommunityPost tPost : trendingPosts) { %>
                            <div class="trending-post" onclick="scrollToPost(<%= tPost.getId() %>)" style="cursor: pointer;">
                                <div class="trending-author"><%= tPost.getPatientName() %></div>
                                <div class="trending-content"><%= tPost.getContent() %></div>
                                <div class="trending-stats">
                                    <span><i class="ph-fill ph-heart"></i> <%= tPost.getLikeCount() %></span>
                                    <span><i class="ph ph-chat-circle"></i> <%= tPost.getCommentCount() %></span>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    </aside>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Report Modal -->
    <div class="modal-overlay" id="reportModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Signaler le Post</h3>
                <button class="modal-close" onclick="closeReportModal()">&times;</button>
            </div>
            <p style="color: var(--gray-600); font-size: 0.875rem; margin-bottom: 1rem;">
                Pourquoi signalez-vous ce post ?
            </p>
            <div class="report-options" id="reportOptions">
                <label class="report-option">
                    <input type="radio" name="reportReason" value="spam">
                    <span>Spam</span>
                </label>
                <label class="report-option">
                    <input type="radio" name="reportReason" value="harassment">
                    <span>Harcèlement ou intimidation</span>
                </label>
                <label class="report-option">
                    <input type="radio" name="reportReason" value="inappropriate">
                    <span>Contenu inapproprié</span>
                </label>
                <label class="report-option">
                    <input type="radio" name="reportReason" value="misinformation">
                    <span>Désinformation sur la santé</span>
                </label>
                <label class="report-option">
                    <input type="radio" name="reportReason" value="other">
                    <span>Autre</span>
                </label>
            </div>
            <div class="form-group" style="margin-bottom: 1rem;">
                <textarea id="reportDescription" class="input" rows="2" placeholder="Détails supplémentaires (optionnel)"></textarea>
            </div>
            <input type="hidden" id="reportPostId">
            <div class="flex gap-2 justify-end">
                <button class="btn btn-ghost" onclick="closeReportModal()">Annuler</button>
                <button class="btn btn-primary" onclick="submitReport()">Envoyer le signalement</button>
            </div>
        </div>
    </div>

    <script>
        var contextPath = '<%= request.getContextPath() %>';
        var isLoggedIn = <%= currentUser != null %>;
        var currentUserId = <%= currentUserId %>;
        var userRole = '<%= userRole %>';

        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imagePreview').src = e.target.result;
                    document.getElementById('imagePreviewContainer').style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        function clearImage() {
            document.getElementById('postImageInput').value = '';
            document.getElementById('imagePreviewContainer').style.display = 'none';
        }

        function toggleLike(postId) {
            if (!isLoggedIn) {
                alert('Veuillez vous connecter pour aimer les posts');
                return;
            }

            var btn = document.getElementById('like-btn-' + postId);
            var countSpan = document.getElementById('like-count-' + postId);
            var icon = btn.querySelector('i');

            var wasLiked = btn.classList.contains('liked');
            var currentCount = parseInt(countSpan.textContent) || 0;

            if (wasLiked) {
                btn.classList.remove('liked');
                icon.className = 'ph ph-heart';
                countSpan.textContent = Math.max(0, currentCount - 1);
            } else {
                btn.classList.add('liked');
                icon.className = 'ph-fill ph-heart';
                countSpan.textContent = currentCount + 1;
            }

            fetch(contextPath + '/' + userRole + '/posts/like', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'postId=' + postId
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    countSpan.textContent = data.likeCount;
                    if (data.liked) {
                        btn.classList.add('liked');
                        icon.className = 'ph-fill ph-heart';
                    } else {
                        btn.classList.remove('liked');
                        icon.className = 'ph ph-heart';
                    }
                }
            })
            .catch(function(error) {
                console.error('Error toggling like:', error);
            });
        }
        
        function toggleBookmark(postId) {
            if (!isLoggedIn) {
                alert('Veuillez vous connecter pour sauvegarder des posts');
                return;
            }

            var btn = document.getElementById('bookmark-btn-' + postId);
            var countSpan = document.getElementById('bookmark-count-' + postId);
            var icon = btn.querySelector('i');

            var wasBookmarked = btn.classList.contains('bookmarked');
            var currentCount = parseInt(countSpan.textContent) || 0;

            if (wasBookmarked) {
                btn.classList.remove('bookmarked');
                icon.className = 'ph ph-bookmark-simple';
                countSpan.textContent = Math.max(0, currentCount - 1);
            } else {
                btn.classList.add('bookmarked');
                icon.className = 'ph-fill ph-bookmark-simple';
                countSpan.textContent = currentCount + 1;
            }

            fetch(contextPath + '/' + userRole + '/posts/bookmark', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'postId=' + postId
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    countSpan.textContent = data.bookmarkCount;
                    if (data.bookmarked) {
                        btn.classList.add('bookmarked');
                        icon.className = 'ph-fill ph-bookmark-simple';
                    } else {
                        btn.classList.remove('bookmarked');
                        icon.className = 'ph ph-bookmark-simple';
                    }
                }
            })
            .catch(function(error) {
                console.error('Error toggling bookmark:', error);
            });
        }

        function toggleComments(postId) {
            var section = document.getElementById('comments-section-' + postId);
            var isHidden = !section.classList.contains('show');

            if (isHidden) {
                section.classList.add('show');
                loadComments(postId);
            } else {
                section.classList.remove('show');
            }
        }

        function loadComments(postId) {
            var listContainer = document.getElementById('comments-list-' + postId);
            listContainer.innerHTML = '<div class="no-comments">Chargement des commentaires...</div>';

            fetch(contextPath + '/' + userRole + '/posts/comments?postId=' + postId)
                .then(function(response) { return response.json(); })
                .then(function(comments) {
                    if (comments.length === 0) {
                        listContainer.innerHTML = '<div class="no-comments">Aucun commentaire. Soyez le premier !</div>';
                        return;
                    }

                    var html = '';
                    for (var i = 0; i < comments.length; i++) {
                        var comment = comments[i];
                        var names = comment.userName.split(' ');
                        var initials = names[0].charAt(0);
                        if (names.length > 1) initials += names[names.length - 1].charAt(0);

                        html += '<div class="comment-item">' +
                            '<div class="comment-avatar">' + initials.toUpperCase() + '</div>' +
                            '<div class="comment-content">' +
                            '<div class="comment-author">' + escapeHtml(comment.userName) + '</div>' +
                            '<div class="comment-text">' + escapeHtml(comment.content) + '</div>' +
                            '<div class="comment-time">' + formatDate(comment.createdAt) + '</div>' +
                            '</div>' +
                            '</div>';
                    }

                    listContainer.innerHTML = html;
                })
                .catch(function(error) {
                    listContainer.innerHTML = '<div class="no-comments">Error loading comments</div>';
                });
        }

        function submitComment(postId) {
            if (!isLoggedIn) {
                alert('Veuillez vous connecter pour commenter');
                return;
            }

            var input = document.getElementById('comment-input-' + postId);
            var content = input.value.trim();

            if (!content) return;

            var button = input.parentElement.querySelector('button');
            var originalHtml = button.innerHTML;
            button.innerHTML = '<span class="loading-spinner"></span>';
            button.disabled = true;

            fetch(contextPath + '/' + userRole + '/posts/comment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'postId=' + postId + '&content=' + encodeURIComponent(content)
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                button.innerHTML = originalHtml;
                button.disabled = false;

                if (data.success) {
                    input.value = '';
                    document.getElementById('comment-count-' + postId).textContent = data.commentCount;
                    loadComments(postId);
                } else {
                    alert(data.error || 'Échec de l\'ajout du commentaire');
                }
            })
            .catch(function(error) {
                button.innerHTML = originalHtml;
                button.disabled = false;
                alert('Erreur lors de l\'ajout du commentaire');
            });
        }
        
        function togglePostMenu(postId) {
            // Close all other menus
            document.querySelectorAll('.post-menu').forEach(function(menu) {
                if (menu.id !== 'post-menu-' + postId) {
                    menu.classList.remove('show');
                }
            });
            
            var menu = document.getElementById('post-menu-' + postId);
            menu.classList.toggle('show');
        }
        
        // Close menus when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.post-header-actions')) {
                document.querySelectorAll('.post-menu').forEach(function(menu) {
                    menu.classList.remove('show');
                });
            }
        });
        
        function showReportModal(postId) {
            document.getElementById('reportPostId').value = postId;
            document.getElementById('reportModal').classList.add('show');
            document.querySelectorAll('.post-menu').forEach(function(menu) {
                menu.classList.remove('show');
            });
        }
        
        function closeReportModal() {
            document.getElementById('reportModal').classList.remove('show');
            document.getElementById('reportDescription').value = '';
            document.querySelectorAll('input[name="reportReason"]').forEach(function(radio) {
                radio.checked = false;
            });
        }
        
        function submitReport() {
            var postId = document.getElementById('reportPostId').value;
            var reason = document.querySelector('input[name="reportReason"]:checked');
            var description = document.getElementById('reportDescription').value;
            
            if (!reason) {
                alert('Veuillez sélectionner une raison');
                return;
            }
            
            fetch(contextPath + '/' + userRole + '/posts/report', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'postId=' + postId + '&reason=' + reason.value + '&description=' + encodeURIComponent(description)
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    alert(data.message);
                    closeReportModal();
                } else {
                    alert(data.error);
                }
            })
            .catch(function(error) {
                alert('Error submitting report');
            });
        }
        
        function deletePost(postId) {
            if (!confirm('Êtes-vous sûr de vouloir supprimer ce post ? Cette action est irréversible.')) {
                return;
            }
            
            fetch(contextPath + '/' + userRole + '/posts/delete', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'postId=' + postId
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    // Remove the post from the page
                    var postCard = document.querySelector('.post-card[data-post-id="' + postId + '"]');
                    if (postCard) {
                        postCard.style.opacity = '0';
                        postCard.style.transform = 'translateY(-10px)';
                        setTimeout(function() {
                            postCard.remove();
                        }, 300);
                    }
                } else {
                    alert(data.error);
                }
            })
            .catch(function(error) {
                alert('Error deleting post');
            });
        }
        
        function viewProfile(userId) {
            window.location.href = contextPath + '/' + userRole + '/posts/user?id=' + userId;
        }
        
        function sharePost(postId) {
            var url = window.location.origin + contextPath + '/' + userRole + '/posts?highlight=' + postId;
            if (navigator.share) {
                navigator.share({
                    title: 'Découvrez ce post sur Nutrit',
                    url: url
                });
            } else {
                navigator.clipboard.writeText(url).then(function() {
                    alert('Lien copié dans le presse-papiers !');
                });
            }
        }
        
        function copyLink(postId) {
            var url = window.location.origin + contextPath + '/' + userRole + '/posts?highlight=' + postId;
            navigator.clipboard.writeText(url).then(function() {
                alert('Lien copié dans le presse-papiers !');
            });
            document.querySelectorAll('.post-menu').forEach(function(menu) {
                menu.classList.remove('show');
            });
        }
        
        function scrollToPost(postId) {
            var postCard = document.querySelector('.post-card[data-post-id="' + postId + '"]');
            if (postCard) {
                postCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
                postCard.style.boxShadow = '0 0 0 3px var(--primary)';
                setTimeout(function() {
                    postCard.style.boxShadow = '';
                }, 2000);
            }
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function formatDate(dateStr) {
            var date = new Date(dateStr);
            var now = new Date();
            var diffMs = now - date;
            var diffMins = Math.floor(diffMs / 60000);
            var diffHours = Math.floor(diffMs / 3600000);
            var diffDays = Math.floor(diffMs / 86400000);

            if (diffMins < 1) return 'À l\'instant';
            if (diffMins < 60) return 'Il y a ' + diffMins + ' min';
            if (diffHours < 24) return 'Il y a ' + diffHours + ' heure' + (diffHours > 1 ? 's' : '');
            if (diffDays < 7) return 'Il y a ' + diffDays + ' jour' + (diffDays > 1 ? 's' : '');

            return date.toLocaleDateString();
        }
        
        // Select report option
        document.querySelectorAll('.report-option').forEach(function(option) {
            option.addEventListener('click', function() {
                document.querySelectorAll('.report-option').forEach(function(o) {
                    o.classList.remove('selected');
                });
                this.classList.add('selected');
            });
        });
    </script>
</body>

</html>