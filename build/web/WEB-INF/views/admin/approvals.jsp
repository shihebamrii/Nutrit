<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.nutrit.models.User" %>
        <%@ page import="java.util.List" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Approbations en attente - Admin | Nutrit</title>
                <meta name="description" content="Examiner et approuver les inscriptions de nutritionnistes en attente.">
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
                                <h1>Approbations en attente</h1>
                                <p>Examiner et approuver les demandes d'inscription des nutritionnistes.</p>
                            </div>

                            <!-- Pending Approvals Card -->
                            <div class="card animate-fade-in">
                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Nutritionniste</th>
                                                <th>Contact</th>
                                                <th>Date d'inscription</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<User> pendingUsers = (List<User>)
                                                    request.getAttribute("pendingUsers");
                                                    if (pendingUsers != null && !pendingUsers.isEmpty()) {
                                                    for(User u : pendingUsers) {
                                                    String[] names = u.getFullName().split(" ");
                                                    String initials = names[0].substring(0, 1);
                                                    if (names.length > 1) initials += names[names.length -
                                                    1].substring(0, 1);
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <div class="flex items-center gap-3">
                                                                <div
                                                                    style="width: 44px; height: 44px; border-radius: 50%; background: var(--gradient-accent); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 600; font-size: 0.875rem; flex-shrink: 0;">
                                                                    <%= initials.toUpperCase() %>
                                                                </div>
                                                                <div>
                                                                    <div style="font-weight: 600;">
                                                                        <%= u.getFullName() %>
                                                                    </div>
                                                                    <span class="badge badge-warning">
                                                                        <i class="ph ph-clock mr-1"></i>
                                                                        <%= u.getStatus() %>
                                                                    </span>
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
                                                            <div class="flex items-center gap-2 text-gray">
                                                                <i class="ph ph-calendar"></i>
                                                                <%= u.getCreatedAt() %>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="flex gap-2">
                                                                <a href="${pageContext.request.contextPath}/admin/approve?id=<%= u.getId() %>"
                                                                    class="btn btn-success btn-sm">
                                                                    <i class="ph ph-check-circle"></i>
                                                                    Approuver
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/reject?id=<%= u.getId() %>"
                                                                    class="btn btn-danger btn-sm"
                                                                    onclick="return confirm('Êtes-vous sûr de vouloir rejeter cette demande ?');">
                                                                    <i class="ph ph-x-circle"></i>
                                                                    Rejeter
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="4">
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <i class="ph ph-seal-check"></i>
                                                                    </div>
                                                                    <div class="empty-state-title">Tout est à jour !</div>
                                                                    <div class="empty-state-text">Il n'y a pas de demandes d'approbation en attente pour le moment.</div>
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