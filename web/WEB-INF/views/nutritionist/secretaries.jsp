<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.User" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Mes Secrétaires - Nutrit</title>
                <meta name="description"
                    content="Gérez votre personnel de secrétariat et leur accès à la planification des rendez-vous.">
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
                            <div class="page-header flex items-center justify-between">
                                <div>
                                    <h1>Mes Secrétaires</h1>
                                    <p>Gérez les membres de votre équipe qui vous aident à planifier les rendez-vous.</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/nutritionist/createSecretary"
                                    class="btn btn-primary">
                                    <i class="ph ph-user-plus"></i>
                                    Ajouter un Secrétaire
                                </a>
                            </div>

                            <!-- Secretaries Table Card -->
                            <div class="card animate-fade-in">
                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Nom</th>
                                                <th>Contact</th>
                                                <th>Inscrit le</th>
                                                <th>Statut</th>
                                    <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<User> secretaries = (List<User>)
                                                    request.getAttribute("secretaries");
                                                    if (secretaries != null && !secretaries.isEmpty()) {
                                                    for(User u : secretaries) {
                                                    String[] names = u.getFullName().split(" ");
                                                    String initials = names[0].substring(0, 1);
                                                    if (names.length > 1) initials += names[names.length -
                                                    1].substring(0, 1);
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <div class="flex items-center gap-3">
                                                                <div
                                                                    style="width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, #E0E7FF, #EEF2FF); display: flex; align-items: center; justify-content: center; color: #4F46E5; font-weight: 600; font-size: 0.875rem; flex-shrink: 0;">
                                                                    <%= initials.toUpperCase() %>
                                                                </div>
                                                                <div>
                                                                    <div style="font-weight: 600;">
                                                                        <%= u.getFullName() %>
                                                                    </div>
                                                                    <span class="badge badge-gray">Secrétaire</span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="flex flex-col gap-1">
                                                                <div class="flex items-center gap-2">
                                                                    <i class="ph ph-envelope text-gray"></i>
                                                                    <span>
                                                                        <%= u.getEmail() %>
                                                                    </span>
                                                                </div>
                                                                <% if (u.getPhone() !=null && !u.getPhone().isEmpty()) {
                                                                    %>
                                                                    <div class="flex items-center gap-2">
                                                                        <i class="ph ph-phone text-gray"></i>
                                                                        <span class="text-sm text-gray">
                                                                            <%= u.getPhone() %>
                                                                        </span>
                                                                    </div>
                                                                    <% } %>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="text-gray">
                                                                <i class="ph ph-calendar mr-1"></i>
                                                                <%= u.getCreatedAt() %>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge badge-success">
                                                                <i class="ph ph-check-circle mr-1"></i>
                                                                Actif
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="flex gap-2">
                                                                <a href="${pageContext.request.contextPath}/nutritionist/editSecretary?id=<%= u.getId() %>" 
                                                                   class="btn-icon" title="Modifier">
                                                                    <i class="ph ph-pencil-simple"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/nutritionist/deleteSecretary?id=<%= u.getId() %>" 
                                                                   class="btn-icon text-error" title="Supprimer"
                                                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce secrétaire ?');">
                                                                    <i class="ph ph-trash"></i>
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="4">
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <i class="ph ph-address-book"></i>
                                                                    </div>
                                                                    <div class="empty-state-title">Aucun Secrétaire</div>
                                                                    <div class="empty-state-text">Créez un compte secrétaire pour vous aider à gérer vos rendez-vous.</div>
                                                                    <a href="${pageContext.request.contextPath}/nutritionist/createSecretary"
                                                                        class="btn btn-primary mt-4">
                                                                        <i class="ph ph-user-plus"></i>
                                                                        Ajouter un Secrétaire
                                                                    </a>
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