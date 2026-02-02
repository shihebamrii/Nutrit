<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.User" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Mes Patients - Nutrit</title>
                <meta name="description"
                    content="Consultez et gérez votre liste de patients, envoyez des messages et attribuez des plans alimentaires.">
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
                                    <h1>Mes Patients</h1>
                                    <p>Gérez votre liste de patients et leurs plans de traitement.</p>
                                </div>
                                <div class="badge badge-primary" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                    <i class="ph ph-users mr-2"></i>
                                    <%= (request.getAttribute("patients") !=null) ?
                                        ((List)request.getAttribute("patients")).size() : 0 %> Patients
                                </div>
                            </div>

                            <!-- Patients Table Card -->
                            <div class="card animate-fade-in">
                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Patient</th>
                                                <th>Contact</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<User> patients = (List<User>) request.getAttribute("patients");
                                                    if (patients != null && !patients.isEmpty()) {
                                                    for(User p : patients) {
                                                    String[] names = p.getFullName().split(" ");
                                                    String initials = names[0].substring(0, 1);
                                                    if (names.length > 1) initials += names[names.length -
                                                    1].substring(0, 1);
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <div class="flex items-center gap-3">
                                                                <div
                                                                    style="width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, #FEE2E2, #FEF2F2); display: flex; align-items: center; justify-content: center; color: #DC2626; font-weight: 600; font-size: 0.875rem; flex-shrink: 0; overflow: hidden;">
                                                                    <% if (p.getProfilePicture() != null && !p.getProfilePicture().isEmpty()) { %>
                                                                        <img src="${pageContext.request.contextPath}/<%= p.getProfilePicture() %>" alt="<%= p.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                                                    <% } else { %>
                                                                        <%= initials.toUpperCase() %>
                                                                    <% } %>
                                                                </div>
                                                                <div>
                                                                    <div style="font-weight: 600;">
                                                                        <%= p.getFullName() %>
                                                                    </div>
                                                                    <div class="text-sm text-gray">
                                                                        <i class="ph ph-calendar mr-1"></i>
                                                                        Patient depuis le <%= p.getCreatedAt() %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="flex flex-col gap-1">
                                                                <div class="flex items-center gap-2">
                                                                    <i class="ph ph-envelope text-gray"></i>
                                                                    <span>
                                                                        <%= p.getEmail() %>
                                                                    </span>
                                                                </div>
                                                                <% if (p.getPhone() !=null && !p.getPhone().isEmpty()) {
                                                                    %>
                                                                    <div class="flex items-center gap-2">
                                                                        <i class="ph ph-phone text-gray"></i>
                                                                        <span class="text-sm text-gray">
                                                                            <%= p.getPhone() %>
                                                                        </span>
                                                                    </div>
                                                                    <% } %>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="flex gap-2">
                                                                <a href="${pageContext.request.contextPath}/nutritionist/viewPatientProfile?patientId=<%= p.getId() %>"
                                                                    class="btn btn-outline btn-sm">
                                                                    <i class="ph ph-heart"></i>
                                                                    Profil
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/chat?userId=<%= p.getId() %>"
                                                                    class="btn btn-secondary btn-sm">
                                                                    <i class="ph ph-chat-circle-text"></i>
                                                                    Message
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/nutritionist/mealPlan/create?patientId=<%= p.getId() %>"
                                                                    class="btn btn-primary btn-sm">
                                                                    <i class="ph ph-fork-knife"></i>
                                                                    Plan Alim.
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="3">
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <i class="ph ph-user-circle-plus"></i>
                                                                    </div>
                                                                    <div class="empty-state-title">Aucun Patient Actif
                                                                    </div>
                                                                    <div class="empty-state-text">Les patients apparaîtront ici une fois qu'ils auront sollicité vos services et que vous les aurez acceptés.</div>
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