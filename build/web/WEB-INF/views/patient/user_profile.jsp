<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nutrit.models.CommunityPost" %>
<%@ page import="com.nutrit.models.User" %>
<% 
    User currentUser = (User) session.getAttribute("user");
    int currentUserId = (currentUser != null) ? currentUser.getId() : -1;
    
    User profileUser = (User) request.getAttribute("profileUser");
    List<CommunityPost> posts = (List<CommunityPost>) request.getAttribute("posts");
    Integer postCount = (Integer) request.getAttribute("postCount");
    Integer followersCount = (Integer) request.getAttribute("followersCount");
    Integer followingCount = (Integer) request.getAttribute("followingCount");
    Boolean isFollowing = (Boolean) request.getAttribute("isFollowing");
    Boolean isFollower = (Boolean) request.getAttribute("isFollower");
    Boolean isOwnProfile = (Boolean) request.getAttribute("isOwnProfile");
    
    String fullName = profileUser.getFullName() != null ? profileUser.getFullName() : "User";
    String[] namesParts = fullName.split(" ");
    String initials = namesParts[0].substring(0, 1);
    if (namesParts.length > 1) initials += namesParts[namesParts.length - 1].substring(0, 1);
    String userRole = (currentUser != null) ? currentUser.getRole() : "patient";
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= fullName %> - Nutrit Community</title>
    <meta name="description" content="View <%= fullName %>'s profile on the Nutrit community.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .profile-page {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 1rem;
        }
        
        .profile-header-card {
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .profile-header-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100px;
            background: var(--gradient-primary);
            opacity: 0.1;
        }
        
        .profile-avatar-xl {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 700;
            font-size: 2.5rem;
            margin: 0 auto 1.25rem;
            box-shadow: var(--shadow-xl);
            border: 4px solid var(--card);
            position: relative;
            z-index: 1;
        }
        
        .profile-name-xl {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 0.25rem;
        }
        
        .profile-role-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 1rem;
            background: linear-gradient(135deg, var(--primary-50), var(--primary-100));
            color: var(--primary-700);
            border-radius: var(--radius-full);
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: capitalize;
            border: 1px solid var(--primary-200);
            margin-bottom: 1rem;
        }
        
        .profile-bio {
            color: var(--gray-600);
            font-size: 0.9375rem;
            line-height: 1.6;
            max-width: 500px;
            margin: 0 auto 1.5rem;
        }
        
        .profile-stats-row {
            display: flex;
            justify-content: center;
            gap: 3rem;
            padding: 1.5rem 0;
            border-top: 1px solid var(--gray-100);
            border-bottom: 1px solid var(--gray-100);
            margin-bottom: 1.5rem;
        }
        
        .profile-stat-item {
            text-align: center;
        }
        
        .profile-stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        
        .profile-stat-text {
            font-size: 0.8125rem;
            color: var(--gray-500);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .profile-actions {
            display: flex;
            justify-content: center;
            gap: 1rem;
        }
        
        .follow-btn {
            min-width: 140px;
        }
        
        .follow-btn.following {
            background: var(--gray-100);
            color: var(--gray-700);
        }
        
        .follow-btn.following:hover {
            background: var(--error-light);
            color: var(--error);
        }
        
        .posts-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
        }
        
        .posts-section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--gray-800);
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
        }

        .post-author {
            font-weight: 600;
            color: var(--gray-800);
        }

        .post-time {
            font-size: 0.8125rem;
            color: var(--gray-500);
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

        .post-actions {
            display: flex;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
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

        .post-action-btn.bookmarked {
            color: var(--warning);
        }

        .post-action-btn i {
            font-size: 1.25rem;
        }

        .empty-posts {
            text-align: center;
            padding: 3rem;
            color: var(--gray-500);
        }
        
        .empty-posts i {
            font-size: 3rem;
            color: var(--gray-300);
            margin-bottom: 1rem;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 1.5rem;
            transition: color var(--transition-fast);
        }
        
        .back-link:hover {
            color: var(--primary);
        }
    </style>
</head>

<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="page-content">
                <div class="profile-page">
                    <a href="${pageContext.request.contextPath}/<%= userRole %>/posts" class="back-link">
                        <i class="ph ph-arrow-left"></i>
                        Retour au fil d'actualité
                    </a>
                    
                    <div class="profile-header-card animate-fade-in">
                        <div class="profile-avatar-xl" style="overflow: hidden;">
                            <% if (profileUser.getProfilePicture() != null && !profileUser.getProfilePicture().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= profileUser.getProfilePicture() %>" alt="<%= profileUser.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                            <% } else { %>
                                <%= initials.toUpperCase() %>
                            <% } %>
                        </div>
                        <h1 class="profile-name-xl"><%= fullName %></h1>
                        <span class="profile-role-badge">
                            <%= profileUser.getRole() != null ? profileUser.getRole() : "Membre" %>
                        </span>
                        <% if (profileUser.getAddress() != null && !profileUser.getAddress().isEmpty()) { %>
                        <p class="profile-bio"><%= profileUser.getAddress() %></p>
                        <% } %>
                        
                        <div class="profile-stats-row">
                            <div class="profile-stat-item">
                                <div class="profile-stat-number"><%= postCount != null ? postCount : 0 %></div>
                                <div class="profile-stat-text">Publications</div>
                            </div>
                            <div class="profile-stat-item">
                                <div class="profile-stat-number" id="followers-count"><%= followersCount != null ? followersCount : 0 %></div>
                                <div class="profile-stat-text">Abonnés</div>
                            </div>
                            <div class="profile-stat-item">
                                <div class="profile-stat-number"><%= followingCount != null ? followingCount : 0 %></div>
                                <div class="profile-stat-text">Abonnements</div>
                            </div>
                        </div>
                        
                        <div class="profile-actions">
                            <% if (isOwnProfile != null && isOwnProfile) { %>
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary">
                                <i class="ph ph-pencil"></i> Modifier le Profil
                            </a>
                            <% } else if (currentUser != null) { %>
                            <button id="follow-btn" class="btn btn-primary follow-btn <%= isFollowing != null && isFollowing ? "following" : "" %>" 
                                    onclick="toggleFollow(<%= profileUser.getId() %>)">
                                <i class="ph <%= isFollowing != null && isFollowing ? "ph-user-minus" : "ph-user-plus" %>"></i>
                                <span>
                                    <% if (isFollowing != null && isFollowing) { %>
                                        Se désabonner
                                    <% } else if (isFollower != null && isFollower) { %>
                                        Suivre en retour
                                    <% } else { %>
                                        Suivre
                                    <% } %>
                                </span>
                            </button>
                            <a href="${pageContext.request.contextPath}/patient/chat?with=<%= profileUser.getId() %>" class="btn btn-ghost">
                                <i class="ph ph-chat-circle"></i> Message
                            </a>
                            <% } else { %>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                Se connecter pour suivre
                            </a>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="posts-section-header">
                        <h2 class="posts-section-title">
                            <i class="ph ph-article"></i> Publications
                        </h2>
                    </div>
                    
                    <div class="posts-list">
                        <% if (posts != null && !posts.isEmpty()) {
                            for (CommunityPost post : posts) {
                                boolean userLiked = post.isUserHasLiked();
                                boolean userBookmarked = post.isUserHasBookmarked();
                        %>
                        <div class="post-card animate-fade-in">
                            <div class="post-header">
                                <div class="post-avatar">
                                    <%= initials.toUpperCase() %>
                                </div>
                                <div>
                                    <div class="post-author"><%= fullName %></div>
                                    <div class="post-time">
                                        <i class="ph ph-clock mr-1"></i>
                                        <%= post.getCreatedAt() %>
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
                                <span>
                                    <i class="ph-fill ph-heart" style="color: #ef4444;"></i>
                                    <span id="like-count-<%= post.getId() %>"><%= post.getLikeCount() %></span> j'aime
                                </span>
                                <span>
                                    <span><%= post.getCommentCount() %></span> commentaires
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
                                <button type="button" class="post-action-btn" onclick="viewPost(<%= post.getId() %>)">
                                    <i class="ph ph-chat-circle"></i>
                                    <span>Commenter</span>
                                </button>
                                <button type="button"
                                    class="post-action-btn<%= userBookmarked ? " bookmarked" : "" %>"
                                    id="bookmark-btn-<%= post.getId() %>"
                                    onclick="toggleBookmark(<%= post.getId() %>)">
                                    <i class="<%= userBookmarked ? "ph-fill" : "ph" %> ph-bookmark-simple"></i>
                                    <span>Enregistrer</span>
                                </button>
                            </div>
                        </div>
                        <% } } else { %>
                        <div class="card">
                            <div class="empty-posts">
                                <i class="ph ph-note-blank"></i>
                                <h3>Aucune publication pour le moment</h3>
                                <p><%= isOwnProfile != null && isOwnProfile ? "Vous n'avez rien partagé pour le moment. Commencez à publier !" : "Cet utilisateur n'a rien partagé pour le moment." %></p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        var contextPath = '<%= request.getContextPath() %>';
        var isLoggedIn = <%= currentUser != null %>;
        var profileUserId = <%= profileUser.getId() %>;
        var userRole = '<%= userRole %>';
        var isTargetFollower = <%= isFollower != null && isFollower %>;
        
        function toggleFollow(userId) {
            if (!isLoggedIn) {
                window.location.href = contextPath + '/login';
                return;
            }
            
            var btn = document.getElementById('follow-btn');
            var icon = btn.querySelector('i');
            var text = btn.querySelector('span');
            var countSpan = document.getElementById('followers-count');
            
            var wasFollowing = btn.classList.contains('following');
            var currentCount = parseInt(countSpan.textContent) || 0;
            
            // Optimistic update
            if (wasFollowing) {
                btn.classList.remove('following');
                icon.className = 'ph ph-user-plus';
                text.textContent = isTargetFollower ? 'Suivre en retour' : 'Suivre';
                countSpan.textContent = Math.max(0, currentCount - 1);
            } else {
                btn.classList.add('following');
                icon.className = 'ph ph-user-minus';
                text.textContent = 'Se désabonner';
                countSpan.textContent = currentCount + 1;
            }
            
            fetch(contextPath + '/' + userRole + '/posts/follow', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'userId=' + userId
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    countSpan.textContent = data.followersCount;
                    if (data.following) {
                        btn.classList.add('following');
                        icon.className = 'ph ph-user-minus';
                        text.textContent = 'Se désabonner';
                    } else {
                        btn.classList.remove('following');
                        icon.className = 'ph ph-user-plus';
                        text.textContent = isTargetFollower ? 'Suivre en retour' : 'Suivre';
                    }
                }
            })
            .catch(function(error) {
                console.error('Error toggling follow:', error);
            });
        }
        
        function toggleLike(postId) {
            if (!isLoggedIn) {
                window.location.href = contextPath + '/login';
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
                }
            });
        }
        
        function toggleBookmark(postId) {
            if (!isLoggedIn) {
                window.location.href = contextPath + '/login';
                return;
            }

            var btn = document.getElementById('bookmark-btn-' + postId);
            var icon = btn.querySelector('i');

            var wasBookmarked = btn.classList.contains('bookmarked');

            if (wasBookmarked) {
                btn.classList.remove('bookmarked');
                icon.className = 'ph ph-bookmark-simple';
            } else {
                btn.classList.add('bookmarked');
                icon.className = 'ph-fill ph-bookmark-simple';
            }

            fetch(contextPath + '/' + userRole + '/posts/bookmark', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'postId=' + postId
            });
        }
        
        function viewPost(postId) {
            window.location.href = contextPath + '/' + userRole + '/posts?highlight=' + postId;
        }
    </script>
</body>

</html>
