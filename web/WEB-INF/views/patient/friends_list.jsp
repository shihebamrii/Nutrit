<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nutrit.models.User" %>
<% 
    User currentUser = (User) session.getAttribute("user"); 
    String pageTitle = (String) request.getAttribute("pageTitle");
    Integer userPostCount = (Integer) request.getAttribute("userPostCount");
    Integer userFollowersCount = (Integer) request.getAttribute("userFollowersCount");
    Integer userFollowingCount = (Integer) request.getAttribute("userFollowingCount");
    String pageDescription = (String) request.getAttribute("pageDescription");
    String activeTab = (String) request.getAttribute("activeTab");
    List<User> friends = (List<User>) request.getAttribute("friends"); // Currently displayed users
    
    if (activeTab == null) activeTab = "friends";
    String userRole = (currentUser != null) ? currentUser.getRole() : "patient";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle != null ? pageTitle : "Mes Amis" %> - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
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
        }
        @media (max-width: 800px) {
            .community-sidebar-left {
                display: none;
            }
        }
        
        /* Profile Card - Reused Style */
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
            overflow: hidden;
        }
        .profile-name { font-weight: 600; color: var(--gray-800); margin-bottom: 0.25rem; }
        .profile-role { font-size: 0.8125rem; color: var(--gray-500); margin-bottom: 1rem; }
        .profile-stats { display: flex; justify-content: center; gap: 1.5rem; padding: 1rem 0; border-top: 1px solid var(--gray-100); border-bottom: 1px solid var(--gray-100); margin-bottom: 1rem; }
        .profile-stat { text-align: center; }
        .profile-stat-value { font-weight: 700; }
        .profile-stat-label { font-size: 0.75rem; color: var(--gray-500); text-transform: uppercase; }
        .profile-nav { display: flex; flex-direction: column; gap: 0.5rem; }
        .profile-nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; border-radius: var(--radius-lg); color: var(--gray-600); text-decoration: none; font-weight: 500; transition: all 0.2s; }
        .profile-nav-item:hover, .profile-nav-item.active { background: var(--gray-100); color: var(--primary); }
        .profile-nav-item.active { background: var(--primary-100); color: var(--primary-700); }

        /* Friends Grid */
        .friends-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        .friend-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 1.5rem;
            text-align: center;
            transition: all 0.2s;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .friend-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }
        .friend-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin-bottom: 1rem;
            overflow: hidden;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.5rem;
            font-weight: 700;
        }
        .friend-name {
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 0.25rem;
            font-size: 1.1rem;
        }
        .friend-role {
            font-size: 0.875rem;
            color: var(--gray-500);
            margin-bottom: 1rem;
            text-transform: capitalize;
        }
        .friend-actions {
            display: flex;
            gap: 0.5rem;
            width: 100%;
            margin-top: auto;
        }
        .friend-btn {
            flex: 1;
            padding: 0.5rem;
            border-radius: var(--radius-md);
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
            transition: all 0.2s;
        }
        .friend-btn-primary {
            background: var(--primary);
            color: white;
            border: none;
        }
        .friend-btn-primary:hover { background: var(--primary-dark); }
        .friend-btn-outline {
            background: transparent;
            border: 1px solid var(--gray-200);
            color: var(--gray-700);
        }
        .friend-btn-outline:hover { border-color: var(--primary); color: var(--primary); }
        
        .empty-friends {
            text-align: center;
            padding: 4rem 1rem;
            color: var(--gray-500);
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
        }
        .empty-friends i { font-size: 3rem; margin-bottom: 1rem; color: var(--gray-300); }
        .network-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            border-bottom: 1px solid var(--gray-200);
            padding-bottom: 1px;
        }
        
        .tab-item {
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            color: var(--gray-500);
            text-decoration: none;
            border-bottom: 2px solid transparent;
            transition: all 0.2s;
        }
        
        .tab-item:hover {
            color: var(--gray-800);
        }
        
        .tab-item.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
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
                                <% if (currentUser.getProfilePicture() != null && !currentUser.getProfilePicture().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/<%= currentUser.getProfilePicture() %>" alt="<%= fullName %>" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <%= initials.toUpperCase() %>
                                <% } %>
                            </div>
                            <div class="profile-name"><%= fullName %></div>
                            <div class="profile-role"><%= currentUser.getRole() != null ? currentUser.getRole().substring(0, 1).toUpperCase() + currentUser.getRole().substring(1) : "Membre" %></div>
                            <div class="profile-stats">
                                <div class="profile-stat">
                                    <div class="profile-stat-value"><%= userPostCount != null ? userPostCount : 0 %></div>
                                    <div class="profile-stat-label">Publications</div>
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
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/posts" class="profile-nav-item">
                                    <i class="ph ph-house"></i>
                                    <span>Fil d'actu</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/posts/bookmarks" class="profile-nav-item">
                                    <i class="ph ph-bookmark-simple"></i>
                                    <span>Messages Enregistrés</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/friends" class="profile-nav-item active">
                                    <i class="ph ph-users"></i>
                                    <span>Mon Réseau</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/<%= userRole %>/posts/user?id=<%= currentUser.getId() %>" class="profile-nav-item">
                                    <i class="ph ph-user"></i>
                                    <span>Mon Profil</span>
                                </a>
                            </nav>
                        </div>
                        <% } %>
                    </aside>
                    
                    <div class="community-main">
                        <div class="mb-6">
                            <h1 style="font-size: 1.5rem; font-weight: 700; color: var(--gray-900);"><%= pageTitle %></h1>
                            <p style="color: var(--gray-500);"><%= pageDescription != null ? pageDescription : "Connectez-vous avec votre réseau." %></p>
                        </div>
                        
                        <div class="network-tabs animate-fade-in">
                            <a href="${pageContext.request.contextPath}/<%= userRole %>/followers" class="tab-item <%= "followers".equals(activeTab) ? "active" : "" %>">Abonnés</a>
                            <a href="${pageContext.request.contextPath}/<%= userRole %>/following" class="tab-item <%= "following".equals(activeTab) ? "active" : "" %>">Abonnements</a>
                            <a href="${pageContext.request.contextPath}/<%= userRole %>/friends" class="tab-item <%= "friends".equals(activeTab) ? "active" : "" %>">Amis Communs</a>
                        </div>

                        <% if (friends != null && !friends.isEmpty()) { %>
                        <div class="friends-grid animate-fade-in">
                            <% for (User friend : friends) { 
                                String fName = friend.getFullName() != null ? friend.getFullName() : "User";
                                String[] fParts = fName.split(" ");
                                String fInitials = fParts[0].substring(0, 1);
                                if (fParts.length > 1) fInitials += fParts[fParts.length - 1].substring(0, 1);
                            %>
                            <div class="friend-card">
                                <div class="friend-avatar">
                                    <% if (friend.getProfilePicture() != null && !friend.getProfilePicture().isEmpty()) { %>
                                        <img src="${pageContext.request.contextPath}/<%= friend.getProfilePicture() %>" alt="<%= fName %>" style="width: 100%; height: 100%; object-fit: cover;">
                                    <% } else { %>
                                        <%= fInitials.toUpperCase() %>
                                    <% } %>
                                </div>
                                <div class="friend-name"><%= fName %></div>
                                <div class="friend-role"><%= friend.getRole() %></div>
                                <div class="friend-actions">
                                    <a href="${pageContext.request.contextPath}/chat?userId=<%= friend.getId() %>" class="friend-btn friend-btn-primary">
                                        <i class="ph ph-chat-circle"></i> Message
                                    </a>
                                    <a href="${pageContext.request.contextPath}/<%= userRole %>/posts/user?id=<%= friend.getId() %>" class="friend-btn friend-btn-outline">
                                        <i class="ph ph-user"></i> Profil
                                    </a>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <% } else { %>
                        <div class="empty-friends animate-fade-in">
                            <i class="ph ph-users-three"></i>
                            <h3>Aucun <%= "following".equals(activeTab) ? "Abonnement" : ("followers".equals(activeTab) ? "Abonné" : "Ami") %> pour le moment</h3>
                            <p>
                                <% if ("following".equals(activeTab)) { %>
                                    Vous ne suivez personne pour le moment. Découvrez des gens dans la communauté !
                                <% } else if ("followers".equals(activeTab)) { %>
                                    Personne ne vous suit pour le moment. Publiez du contenu intéressant pour attirer des abonnés !
                                <% } else { %>
                                    Vous ne vous êtes connecté avec personne pour le moment. Suivez des utilisateurs, et quand ils vous suivront en retour, ils apparaîtront ici !
                                <% } %>
                            </p>
                            <a href="${pageContext.request.contextPath}/<%= userRole %>/posts" class="btn btn-primary mt-4">Explorer la Communauté</a>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
