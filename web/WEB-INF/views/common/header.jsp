<%@ page import="com.nutrit.models.User" %>
    <% User currentUser=(User) session.getAttribute("user"); String role=(currentUser !=null) ? currentUser.getRole()
        : "guest" ; 
        String roleDisplay = role;
        if ("admin".equalsIgnoreCase(role)) roleDisplay = "Administrateur";
        else if ("nutritionist".equalsIgnoreCase(role)) roleDisplay = "Nutritionniste";
        else if ("patient".equalsIgnoreCase(role)) roleDisplay = "Patient";
        else if ("secretary".equalsIgnoreCase(role)) roleDisplay = "Secrétaire";
        
        String initials="" ; if (currentUser !=null && currentUser.getFullName() !=null &&
        !currentUser.getFullName().isEmpty()) { String[] names=currentUser.getFullName().split(" ");
        initials = names[0].substring(0, 1).toUpperCase();
        if (names.length > 1) {
            initials += names[names.length - 1].substring(0, 1).toUpperCase();
        }
    }
%>

<header class="header">
        <div class="flex items-center gap-3">
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Open Menu">
                <i class="ph ph-list"></i>
            </button>
            <span class="brand-text">Nutrit</span>
        </div>

        <% if (currentUser !=null) { %>
            <div class="user-section">
                <span class="role-badge">
                    <i class="ph ph-shield-check mr-1" style="font-size: 0.875rem;"></i>
                    <%= roleDisplay %>
                </span>
                <span class="user-name">
                    <%= currentUser.getFullName() %>
                </span>
                <div class="user-avatar" style="overflow: hidden;">
                    <% if (currentUser.getProfilePicture() != null && !currentUser.getProfilePicture().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/<%= currentUser.getProfilePicture() %>" alt="<%= currentUser.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                    <% } else { %>
                        <%= initials %>
                    <% } %>
                </div>
            </div>
            <% } %>
                </header>