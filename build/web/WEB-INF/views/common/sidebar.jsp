<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.nutrit.models.User" %>

    <% User user=(User) session.getAttribute("user"); String userRole=(user !=null) ? user.getRole() : "" ; String
            currentPath=request.getRequestURI(); // Pre-compute active states to avoid quote issues in attributes
            String dashboardActive=currentPath.contains("/dashboard") ? "nav-item active" : "nav-item" ; String
            dietActive=currentPath.contains("/diet") ? "nav-item active" : "nav-item" ; String
            appointmentActive=currentPath.contains("/appointment") ? "nav-item active" : "nav-item" ; String
            chatActive=currentPath.contains("/chat") ? "nav-item active" : "nav-item" ; String
            postsActive=currentPath.contains("/posts") ? "nav-item active" : "nav-item" ; String
            patientsActive=currentPath.contains("/patients") ? "nav-item active" : "nav-item" ; String
            secretariesActive=currentPath.contains("/secretaries") ? "nav-item active" : "nav-item" ; String
            createSecretaryActive=currentPath.contains("/createSecretary") ? "nav-item active" : "nav-item" ; String
            usersActive=currentPath.contains("/users") ? "nav-item active" : "nav-item" ; String
            approvalsActive=currentPath.contains("/approvals") ? "nav-item active" : "nav-item" ; String
            profileActive=currentPath.contains("/profile") ? "nav-item active" : "nav-item" ; %>

            <div class="sidebar-overlay" id="sidebarOverlay"></div>
            <aside class="sidebar" id="sidebar">
                    <div class="sidebar-brand">
                            <span class="brand-name"><i class="ph-fill ph-plant"></i> Nutrit</span>
                            <button class="sidebar-close" id="sidebarClose" aria-label="Close Menu">
                                <i class="ph ph-x"></i>
                            </button>
                    </div>

                    <nav>
                            <ul>
                                    <li>
                                            <a href="${pageContext.request.contextPath}/<%= userRole %>/dashboard"
                                                    class="<%= dashboardActive %>">
                                                    <i class="ph ph-squares-four"></i>
                                                    Tableau de bord
                                            </a>
                                    </li>

                                    <% if ("patient".equals(userRole)) { %>
                                            <div class="nav-section">Santé</div>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/health-profile"
                                                            class="<%= currentPath.contains(" /health-profile")
                                                            ? "nav-item active" : "nav-item" %>">
                                                            <i class="ph ph-heart"></i>
                                                            Profil de santé
                                                    </a>
                                            </li>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/mealPlan"
                                                            class="<%= currentPath.contains("/mealPlan") || currentPath.contains("/diet") ? "nav-item active" : "nav-item" %>">
                                                            <i class="ph ph-bowl-food"></i>
                                                            Plan alimentaire
                                                    </a>
                                            </li>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/appointments"
                                                            class="<%= appointmentActive %>">
                                                            <i class="ph ph-calendar-dots"></i>
                                                            Rendez-vous
                                                    </a>
                                            </li>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/invoices"
                                                            class="<%= currentPath.contains("/invoices") || currentPath.contains("/invoice") ? "nav-item active" : "nav-item" %>">
                                                            <i class="ph ph-receipt"></i>
                                                            Mes factures
                                                    </a>
                                            </li>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/bookAppointment"
                                                            class="<%= currentPath.contains("/bookAppointment") ? "nav-item active" : "nav-item" %>">
                                                            <i class="ph ph-calendar-plus"></i>
                                                            Prendre rendez-vous
                                                    </a>
                                            </li>

                                            <div class="nav-section">Connecter</div>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/nutritionists"
                                                            class="<%= currentPath.contains(" /nutritionist")
                                                            ? "nav-item active" : "nav-item" %>">
                                                            <i class="ph ph-stethoscope"></i>
                                                            Trouver un nutritionniste
                                                    </a>
                                            </li>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/chat"
                                                            class="<%= chatActive %>">
                                                            <i class="ph ph-chat-circle-dots"></i>
                                                            Messages
                                                    </a>
                                            </li>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/posts"
                                                            class="<%= postsActive %>">
                                                            <i class="ph ph-users-three"></i>
                                                            Communauté
                                                    </a>
                                            </li>
                                            <li>
                                                    <a href="${pageContext.request.contextPath}/patient/friends"
                                                            class="<%= currentPath.contains("/friends") ? "nav-item active" : "nav-item" %>">
                                                            <i class="ph ph-users"></i>
                                                            Amis
                                                    </a>
                                            </li>

                                            <% } else if ("nutritionist".equals(userRole)) { %>
                                                    <div class="nav-section">Cabinet</div>
                                                    <li>
                                                            <a href="${pageContext.request.contextPath}/nutritionist/patients"
                                                                    class="<%= patientsActive %>">
                                                                    <i class="ph ph-users"></i>
                                                                    Patients
                                                            </a>
                                                    </li>
                                                    <li>
                                                            <a href="${pageContext.request.contextPath}/nutritionist/appointments"
                                                                    class="<%= appointmentActive %>">
                                                                    <i class="ph ph-calendar-dots"></i>
                                                                    Rendez-vous
                                                            </a>
                                                    </li>
                                                    <li>
                                                            <a href="${pageContext.request.contextPath}/chat"
                                                                    class="<%= chatActive %>">
                                                                    <i class="ph ph-chat-circle-dots"></i>
                                                                    Messages
                                                            </a>
                                                    </li>
                                                    <li>
                                                            <a href="${pageContext.request.contextPath}/nutritionist/mealPlan"
                                                                    class="<%= currentPath.contains("/mealPlan") ? "nav-item active" : "nav-item" %>">
                                                                    <i class="ph ph-bowl-food"></i>
                                                                    Plans alimentaires
                                                            </a>
                                                    </li>
                                                    <li>
                                                            <a href="${pageContext.request.contextPath}/nutritionist/posts"
                                                                    class="<%= postsActive %>">
                                                                    <i class="ph ph-users-three"></i>
                                                                    Communauté
                                                            </a>
                                                    </li>

                                                    <div class="nav-section">Équipe</div>
                                                    <li>
                                                            <a href="${pageContext.request.contextPath}/nutritionist/secretaries"
                                                                    class="<%= secretariesActive %>">
                                                                    <i class="ph ph-address-book"></i>
                                                                    Mes secrétaires
                                                            </a>
                                                    </li>
                                                    <li>
                                                            <a href="${pageContext.request.contextPath}/nutritionist/createSecretary"
                                                                    class="<%= createSecretaryActive %>">
                                                                    <i class="ph ph-user-plus"></i>
                                                                    Ajouter secrétaire
                                                            </a>
                                                    </li>

                                                    <% } else if ("secretary".equals(userRole)) { %>
                                                            <div class="nav-section">Gestion</div>
                                                            <li>
                                                                    <a href="${pageContext.request.contextPath}/secretary/appointments"
                                                                            class="<%= appointmentActive %>">
                                                                            <i class="ph ph-calendar-dots"></i>
                                                                            Rendez-vous
                                                                    </a>
                                                            </li>
                                                            <li>
                                                                    <a href="${pageContext.request.contextPath}/secretary/bookDirect"
                                                                            class="<%= currentPath.contains("/bookDirect") ? "nav-item active" : "nav-item" %>">
                                                                            <i class="ph ph-calendar-plus"></i>
                                                                            Réserver un rendez-vous
                                                                    </a>
                                                            </li>
                                                            <li>
                                                                    <a href="${pageContext.request.contextPath}/secretary/patients"
                                                                            class="<%= patientsActive %>">
                                                                            <i class="ph ph-users"></i>
                                                                            Patients
                                                                    </a>
                                                            </li>
                                                                    <a href="${pageContext.request.contextPath}/secretary/appointmentRequests"
                                                                            class="<%= currentPath.contains("/appointmentRequest") ? "nav-item active" : "nav-item" %>">
                                                                            <i class="ph ph-clock-countdown"></i>
                                                                            Demandes de rendez-vous
                                                                    </a>
                                                            </li>
                                                            <li>
                                                                    <a href="${pageContext.request.contextPath}/chat"
                                                                            class="<%= chatActive %>">
                                                                            <i class="ph ph-chat-circle-dots"></i>
                                                                            Messages
                                                                    </a>
                                                            </li>

                                                            <% } else if ("admin".equals(userRole)) { %>
                                                                    <div class="nav-section">Administration</div>
                                                                    <li>
                                                                            <a href="${pageContext.request.contextPath}/admin/users"
                                                                                    class="<%= usersActive %>">
                                                                                    <i
                                                                                            class="ph ph-users-three"></i>
                                                                                    Gestion des utilisateurs
                                                                            </a>
                                                                    </li>
                                                                    <li>
                                                                            <a href="${pageContext.request.contextPath}/admin/approvals"
                                                                                    class="<%= approvalsActive %>">
                                                                                    <i class="ph ph-seal-check"></i>
                                                                                    Approbations en attente
                                                                            </a>
                                                                    </li>
                                                                    <li>
                                                                            <a href="${pageContext.request.contextPath}/admin/reports"
                                                                                    class="<%= currentPath.contains("/reports") ? "nav-item active" : "nav-item" %>">
                                                                                    <i class="ph ph-flag"></i>
                                                                                    Signalements
                                                                            </a>
                                                                    </li>
                                                                    <% } %>

                                                                            <div class="nav-section">Compte</div>
                                                                            <li>
                                                                                    <a href="${pageContext.request.contextPath}/profile"
                                                                                            class="<%= profileActive %>">
                                                                                            <i
                                                                                                    class="ph ph-gear"></i>
                                                                                             Paramètres
                                                                                    </a>
                                                                            </li>
                            </ul>
                    </nav>

                    <div class="sidebar-footer">
                            <a href="${pageContext.request.contextPath}/auth/logout" class="logout-btn">
                                    <i class="ph ph-sign-out"></i>
                                    Déconnexion
                            </a>
                    </div>
            </aside>

            <script>
            document.addEventListener('DOMContentLoaded', function() {
                const mobileNavToggle = document.getElementById('mobileNavToggle');
                const sidebarClose = document.getElementById('sidebarClose');
                const sidebar = document.getElementById('sidebar');
                const sidebarOverlay = document.getElementById('sidebarOverlay');

                if (mobileNavToggle && sidebar && sidebarOverlay) {
                    mobileNavToggle.addEventListener('click', function() {
                        sidebar.classList.add('open');
                        sidebarOverlay.classList.add('active');
                    });
                }

                if (sidebarClose && sidebar && sidebarOverlay) {
                    sidebarClose.addEventListener('click', function() {
                        sidebar.classList.remove('open');
                        sidebarOverlay.classList.remove('active');
                    });
                }

                if (sidebarOverlay && sidebar) {
                    sidebarOverlay.addEventListener('click', function() {
                        sidebar.classList.remove('open');
                        sidebarOverlay.classList.remove('active');
                    });
                }
            });
            </script>