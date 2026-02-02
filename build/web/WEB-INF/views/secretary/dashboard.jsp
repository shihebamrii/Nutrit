<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.Appointment" %>
        <%@ page import="com.nutrit.models.PatientRequest" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tableau de Bord Secrétaire - Nutrit</title>
                <meta name="description"
                    content="Gérez les rendez-vous, la planification des patients et accompagnez votre pratique nutritionnelle.">
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
                                <h1>Tableau de Bord Réception</h1>
                                <p>Gérez les rendez-vous quotidiens et les plannings patients.</p>
                            </div>

                            <!-- Stats Grid -->
                            <div class="stats-grid">
                                <div class="card stat-card animate-fade-in">
                                    <div class="stat-icon">
                                        <i class="ph ph-calendar-dots"></i>
                                    </div>
                                    <div class="stat-value">
                                        <%= request.getAttribute("todayCount") %>
                                    </div>
                                    <div class="stat-label">Rendez-vous du Jour</div>
                                    <div class="stat-change positive">
                                        <i class="ph ph-check"></i>
                                        <%= request.getAttribute("completedCount") %> Terminés
                                    </div>
                                </div>

                                <div class="card stat-card animate-fade-in" style="animation-delay: 0.1s;">
                                    <div class="stat-icon"
                                        style="background: linear-gradient(135deg, #FEE2E2, #FEF2F2); color: #DC2626;">
                                        <i class="ph ph-x-circle"></i>
                                    </div>
                                    <div class="stat-value">
                                        <%= request.getAttribute("cancelledCount") %>
                                    </div>
                                    <div class="stat-label">Annulations</div>
                                    <% if ((long)request.getAttribute("cancelledCount")> 0) { %>
                                        <div class="stat-change" style="color: var(--error);">
                                            <i class="ph ph-warning"></i>
                                            Action requise
                                        </div>
                                        <% } else { %>
                                            <div class="stat-change positive">
                                                <i class="ph ph-check-circle"></i>
                                                Aucune annulation aujourd'hui
                                            </div>
                                            <% } %>
                                </div>
                                </div>

                                <div class="card stat-card animate-fade-in" style="animation-delay: 0.2s;">
                                    <div class="stat-icon"
                                        style="background: linear-gradient(135deg, #FEF3C7, #FFFBEB); color: #D97706;">
                                        <i class="ph ph-user-plus"></i>
                                    </div>
                                    <div class="stat-value">
                                        <%= request.getAttribute("pendingCount") %>
                                    </div>
                                    <div class="stat-label">Demandes en Attente</div>
                                    <% if ((int)request.getAttribute("pendingCount")> 0) { %>
                                        <div class="stat-change" style="color: var(--warning);">
                                            <i class="ph ph-warning"></i>
                                            Action requise
                                        </div>
                                        <% } else { %>
                                            <div class="stat-change positive">
                                                <i class="ph ph-check-circle"></i>
                                                Tout est à jour
                                            </div>
                                                            <% } %>
                                </div>

                                <div class="card stat-card animate-fade-in" style="animation-delay: 0.3s;">
                                    <div class="stat-icon"
                                        style="background: linear-gradient(135deg, #DBEAFE, #EFF6FF); color: #3B82F6;">
                                        <i class="ph ph-clock-countdown"></i>
                                    </div>
                                    <div class="stat-value">
                                        <%= request.getAttribute("pendingApptRequestsCount") != null ? request.getAttribute("pendingApptRequestsCount") : 0 %>
                                    </div>
                                    <div class="stat-label">Demandes de RDV</div>
                                    <% Integer apptReqCount = (Integer) request.getAttribute("pendingApptRequestsCount");
                                       if (apptReqCount != null && apptReqCount > 0) { %>
                                        <a href="${pageContext.request.contextPath}/secretary/appointmentRequests" 
                                           class="stat-change" style="color: var(--info); text-decoration: none;">
                                            <i class="ph ph-arrow-right"></i>
                                            Examiner les demandes
                                        </a>
                                    <% } else { %>
                                        <div class="stat-change positive">
                                            <i class="ph ph-check-circle"></i>
                                            Aucune demande en attente
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                            
                            <div class="content-grid" style="display: grid; grid-template-columns: 1fr; gap: 1.5rem;">
                                <!-- Patient Requests Card -->
                                <div class="card animate-fade-in" style="animation-delay: 0.3s;">
                                    <div class="card-header flex items-center justify-between">
                                        <h3>
                                            <i class="ph ph-user-circle-plus mr-2"
                                                style="color: var(--primary);"></i>
                                            Demandes Patients
                                        </h3>
                                        <span class="badge badge-primary">
                                            <%= request.getAttribute("pendingCount") %> en attente
                                        </span>
                                    </div>

                                    <% List<PatientRequest> requests = (List<PatientRequest>)
                                            request.getAttribute("pendingRequests");
                                            if (requests != null && !requests.isEmpty()) {
                                            for(PatientRequest req : requests) { %>
                                            <div class="list-item">
                                                <div class="list-item-info">
                                                    <span class="list-item-title">
                                                        <%= req.getPatientName() %>
                                                    </span>
                                                    <span class="list-item-subtitle">
                                                        <%= req.getPatientEmail() %>
                                                    </span>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/secretary/acceptRequest?id=<%= req.getId() %>"
                                                    class="btn btn-success btn-sm">
                                                    <i class="ph ph-check"></i>
                                                    Accepter
                                                </a>
                                            </div>
                                            <% } } else { %>
                                                <div class="empty-state">
                                                    <div class="empty-state-icon">
                                                        <i class="ph ph-user-circle-check"></i>
                                                    </div>
                                                    <div class="empty-state-title">Aucune Demande en Attente</div>
                                                    <div class="empty-state-text">Les nouvelles demandes patients
                                                        apparaîtront ici.</div>
                                                </div>
                                                <% } %>
                                </div>

                            <!-- Appointments Table Card -->
                            <div class="card animate-fade-in" style="animation-delay: 0.2s;">
                                <div class="card-header flex items-center justify-between">
                                    <h3>
                                        <i class="ph ph-clock mr-2" style="color: var(--primary);"></i>
                                        Planning à Venir
                                    </h3>
                                    <a href="${pageContext.request.contextPath}/secretary/appointments"
                                        class="btn btn-primary btn-sm">
                                        <i class="ph ph-plus"></i>
                                        Nouveau RDV
                                    </a>
                                </div>

                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Heure</th>
                                                <th>Patient</th>
                                                <th>Statut</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<Appointment> appointments = (List<Appointment>)
                                                    request.getAttribute("todayAppointments");
                                                    if (appointments != null && !appointments.isEmpty()) {
                                                    for(Appointment appt : appointments) { %>
                                                    <tr>
                                                        <td>
                                                            <div class="flex items-center gap-2">
                                                                <div
                                                                    style="width: 4px; height: 36px; background: var(--gradient-primary); border-radius: 2px;">
                                                                </div>
                                                                <span style="font-weight: 600; color: var(--primary);">
                                                                    <%= new
                                                                        java.text.SimpleDateFormat("HH:mm").format(appt.getScheduledTime())
                                                                        %>
                                                                </span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div style="font-weight: 500;">
                                                                <%= appt.getPatientName() %>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <% if ("confirmed".equalsIgnoreCase(appt.getStatus())
                                                                || "upcoming" .equalsIgnoreCase(appt.getStatus())) { %>
                                                                <span class="badge badge-success">
                                                                    <i class="ph ph-check-circle mr-1"></i>
                                                                    Confirmé
                                                                </span>
                                                                <% } else if
                                                                    ("pending".equalsIgnoreCase(appt.getStatus())) { %>
                                                                    <span class="badge badge-warning">
                                                                        <i class="ph ph-clock mr-1"></i>
                                                                        En attente
                                                                    </span>
                                                                    <% } else if
                                                                        ("cancelled".equalsIgnoreCase(appt.getStatus()))
                                                                        { %>
                                                                        <span class="badge badge-danger">
                                                                            <i class="ph ph-x-circle mr-1"></i>
                                                                            Annulé
                                                                        </span>
                                                                        <% } else { %>
                                                                            <span class="badge badge-gray">
                                                                                <%= appt.getStatus() %>
                                                                            </span>
                                                                            <% } %>
                                                        </td>
                                                        <td>
                                                            <div class="flex gap-2">
                                                                <button class="btn btn-ghost btn-sm" title="Edit">
                                                                    <i class="ph ph-pencil-simple"></i>
                                                                </button>
                                                                <button class="btn btn-ghost btn-sm"
                                                                    title="View Details">
                                                                    <i class="ph ph-eye"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="4">
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <i class="ph ph-calendar-blank"></i>
                                                                    </div>
                                                                    <div class="empty-state-title">Aucun Rendez-vous Aujourd'hui
                                                                    </div>
                                                                    <div class="empty-state-text">Le planning est libre.
                                                                        Ajoutez un nouveau rendez-vous pour commencer.
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                </div>
                            </div>
                            </div>
                        </div>
                    </main>
                </div>
            </body>

            </html>