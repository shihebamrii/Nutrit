<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.nutrit.models.User" %>
        <%@ page import="java.util.List" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Gérer les Utilisateurs - Admin | Nutrit</title>
                <meta name="description" content="Administrer et gérer tous les comptes utilisateurs sur la plateforme Nutrit.">
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
                                    <h1>Gestion des Utilisateurs</h1>
                                    <p>Voir et gérer tous les utilisateurs inscrits sur la plateforme.</p>
                                </div>
                            </div>

                            <!-- Users Table Card -->
                            <div class="card animate-fade-in">
                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Utilisateur</th>
                                                <th>Rôle</th>
                                                <th>Inscrit le</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<User> users = (List<User>) request.getAttribute("users");
                                                    if (users != null && !users.isEmpty()) {
                                                    for(User u : users) {
                                                    String[] names = u.getFullName().split(" ");
                                                    String initials = names[0].substring(0, 1);
                                                    if (names.length > 1) initials += names[names.length -
                                                    1].substring(0, 1);
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <span class="text-gray">#<%= u.getId() %></span>
                                                        </td>
                                                        <td>
                                                            <div class="flex items-center gap-3">
                                                                <div
                                                                    style="width: 40px; height: 40px; border-radius: 50%; background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 600; font-size: 0.875rem; flex-shrink: 0; overflow: hidden;">
                                                                    <% if (u.getProfilePicture() != null && !u.getProfilePicture().isEmpty()) { %>
                                                                        <img src="${pageContext.request.contextPath}/<%= u.getProfilePicture() %>" alt="<%= u.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                                                    <% } else { %>
                                                                        <%= initials.toUpperCase() %>
                                                                    <% } %>
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
                                                            <span class="badge <%= "admin".equals(u.getRole())
                                                                ? "badge-danger" : "nutritionist".equals(u.getRole())
                                                                ? "badge-success" : "patient".equals(u.getRole())
                                                                ? "badge-primary" : "badge-gray" %>">
                                                                <%= "admin".equalsIgnoreCase(u.getRole()) ? "Admin" : "nutritionist".equalsIgnoreCase(u.getRole()) ? "Nutritionniste" : "patient".equalsIgnoreCase(u.getRole()) ? "Patient" : u.getRole() %>
                                                            </span>
                                                        </td>
                                                        <td class="text-gray">
                                                            <%= u.getCreatedAt() %>
                                                        </td>
                                                        <td>
                                                            <% if (!"admin".equals(u.getRole())) { %>
                                                                <a href="${pageContext.request.contextPath}/admin/deleteUser?id=<%= u.getId() %>"
                                                                    class="btn btn-danger btn-sm"
                                                                    onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible.');">
                                                                    <i class="ph ph-trash"></i>
                                                                    Supprimer
                                                                </a>
                                                                <% } else { %>
                                                                    <span class="badge badge-gray"
                                                                        title="Les comptes admin ne peuvent pas être supprimés">
                                                                        <i class="ph ph-lock mr-1"></i>
                                                                        Protégé
                                                                    </span>
                                                                    <% } %>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="5">
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <i class="ph ph-users"></i>
                                                                    </div>
                                                                    <div class="empty-state-title">Aucun Utilisateur Trouvé</div>
                                                                    <div class="empty-state-text">Il n'y a pas d'utilisateurs inscrits dans le système.</div>
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