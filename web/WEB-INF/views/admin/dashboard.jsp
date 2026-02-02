<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.nutrit.models.User" %>
        <%@ page import="java.util.List" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tableau de Bord Admin - Nutrit</title>
                <meta name="description"
                    content="Administrez les utilisateurs, consultez les statistiques système et gérez la plateforme Nutrit.">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <script src="https://unpkg.com/@phosphor-icons/web"></script>
            </head>

            <body>
                <div class="flex">
                    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

                    <main class="main-content">
                        <jsp:include page="/WEB-INF/views/common/header.jsp" />

                        <div class="page-content">
                            <!-- Page Header -->
                            <div class="page-header">
                                <h1>Vue d'Ensemble Admin</h1>
                                <p>Surveillez l'activité de la plateforme et gérez les utilisateurs.</p>
                            </div>

                            <!-- Stats Grid -->
                            <div class="stats-grid">
                                <div class="card stat-card animate-fade-in">
                                    <div class="stat-icon">
                                        <i class="ph ph-users-three"></i>
                                    </div>
                                    <div class="stat-value">
                                        <%= request.getAttribute("countAllUsers") %>
                                    </div>
                                    <div class="stat-label">Total Utilisateurs</div>
                                    <div class="stat-change positive">
                                        <i class="ph ph-chart-line-up"></i>
                                        Tous les rôles
                                    </div>
                                </div>

                                <div class="card stat-card animate-fade-in" style="animation-delay: 0.1s;">
                                    <div class="stat-icon"
                                        style="background: linear-gradient(135deg, #FEE2E2, #FEF2F2); color: #DC2626;">
                                        <i class="ph ph-heartbeat"></i>
                                    </div>
                                    <div class="stat-value">
                                        <%= request.getAttribute("countPatients") %>
                                    </div>
                                    <div class="stat-label">Patients</div>
                                    <div class="stat-change positive">
                                        <i class="ph ph-heart-straight"></i>
                                        Dossiers santé actifs
                                    </div>
                                </div>

                                <div class="card stat-card animate-fade-in" style="animation-delay: 0.2s;">
                                    <div class="stat-icon"
                                        style="background: linear-gradient(135deg, #D1FAE5, #ECFDF5); color: #059669;">
                                        <i class="ph ph-stethoscope"></i>
                                    </div>
                                    <div class="stat-value">
                                        <%= request.getAttribute("countNutritionists") %>
                                    </div>
                                    <div class="stat-label">Nutritionnistes</div>
                                    <div class="stat-change positive">
                                        <i class="ph ph-certificate"></i>
                                        Professionnels certifiés
                                    </div>
                                </div>

                                <div class="card stat-card animate-fade-in" style="animation-delay: 0.3s;">
                                    <div class="stat-icon"
                                        style="background: linear-gradient(135deg, #DBEAFE, #EFF6FF); color: #2563EB;">
                                        <i class="ph ph-activity"></i>
                                    </div>
                                    <div class="stat-value" style="font-size: 1.5rem;">En ligne</div>
                                    <div class="stat-label">État du Système</div>
                                    <div class="stat-change positive">
                                        <i class="ph ph-check-circle"></i>
                                        Tous les services actifs
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Users Card -->
                            <div class="card animate-fade-in" style="animation-delay: 0.4s;">
                                <div class="card-header flex items-center justify-between">
                                    <h3>
                                        <i class="ph ph-user-circle-plus mr-2" style="color: var(--primary);"></i>
                                        Nouveaux Utilisateurs
                                    </h3>
                                    <a href="${pageContext.request.contextPath}/admin/users" class="link text-sm">Voir
                                        tous</a>
                                </div>

                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Détails Utilisateur</th>
                                                <th>Rôle</th>
                                                <th>Inscrit le</th>
                                                <th>Statut</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<User> recentUsers = (List<User>)
                                                    request.getAttribute("recentUsers");
                                                    if (recentUsers != null && !recentUsers.isEmpty()) {
                                                    for(User u : recentUsers) {
                                                    String[] names = u.getFullName().split(" ");
                                                    String initials = names[0].substring(0, 1);
                                                    if (names.length > 1) initials += names[names.length -
                                                    1].substring(0, 1);
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <div class="flex items-center gap-3">
                                                                <div
                                                                    style="width: 40px; height: 40px; border-radius: 50%; background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 600; font-size: 0.875rem; flex-shrink: 0;">
                                                                    <%= initials.toUpperCase() %>
                                                                </div>
                                                                <div>
                                                                    <div style="font-weight: 500;">
                                                                        <%= u.getFullName() %>
                                                                    </div>
                                                                    <div class="text-sm text-gray">
                                                                        <%= u.getEmail() %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                                    <span class="badge <%= "nutritionist".equals(u.getRole())
                                                                        ? "badge-success" : "patient".equals(u.getRole())
                                                                        ? "badge-primary" : "badge-gray" %>">
                                                                        <%= "nutritionist".equalsIgnoreCase(u.getRole()) ? "Nutritionniste" : "patient".equalsIgnoreCase(u.getRole()) ? "Patient" : u.getRole() %>
                                                                    </span>
                                                        </td>
                                                        <td class="text-gray">
                                                            <%= u.getCreatedAt() %>
                                                        </td>
                                                        <td>
                                                            <span class="badge badge-success">
                                                                <i class="ph ph-check-circle mr-1"></i>
                                                                Actif
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="4">
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <i class="ph ph-users"></i>
                                                                    </div>
                                                                    <div class="empty-state-title">Aucun Utilisateur</div>
                                                                    <div class="empty-state-text">Les utilisateurs apparaîtront ici
                                                                        après leur inscription.</div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </body>

            </html>