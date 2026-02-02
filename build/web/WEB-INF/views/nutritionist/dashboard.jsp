<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.PatientRequest" %>
            <%@ page import="com.nutrit.models.Appointment" %>
                <!DOCTYPE html>
                <html lang="fr">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Tableau de Bord Nutritionniste - Nutrit</title>
                    <meta name="description"
                        content="Gérez vos patients, rendez-vous et votre pratique nutritionnelle depuis votre tableau de bord professionnel.">
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
                                    <h1>Tableau de Bord Professionnel</h1>
                                    <p>Bon retour ! Voici un aperçu de votre pratique aujourd'hui.</p>
                                </div>

                                <!-- Stats Grid -->
                                <div class="stats-grid">
                                    <div class="card stat-card animate-fade-in">
                                        <div class="stat-icon">
                                            <i class="ph ph-users"></i>
                                        </div>
                                        <div class="stat-value">
                                            <%= request.getAttribute("activePatients") %>
                                        </div>
                                        <div class="stat-label">Patients Actifs</div>
                                        <div class="stat-change positive">
                                            <i class="ph ph-trend-up"></i>
                                            Actuellement suivis
                                        </div>
                                    </div>

                                    <div class="card stat-card animate-fade-in" style="animation-delay: 0.1s;">
                                        <div class="stat-icon"
                                            style="background: linear-gradient(135deg, #D1FAE5, #ECFDF5); color: #059669;">
                                            <i class="ph ph-calendar-check"></i>
                                        </div>
                                        <div class="stat-value">
                                            <%= request.getAttribute("todayCount") %>
                                        </div>
                                        <div class="stat-label">Rendez-vous du Jour</div>
                                        <div class="stat-change positive">
                                            <i class="ph ph-clock"></i>
                                            Planifiés aujourd'hui
                                        </div>
                                    </div>

                                    <!-- Meal Plans Card -->
                                    <div class="card stat-card animate-fade-in" style="animation-delay: 0.2s; cursor: pointer;"
                                         onclick="window.location.href='${pageContext.request.contextPath}/nutritionist/mealPlan'">
                                        <div class="stat-icon"
                                            style="background: linear-gradient(135deg, #DBEAFE, #EFF6FF); color: #2563EB;">
                                            <i class="ph ph-fork-knife"></i>
                                        </div>
                                        <div class="stat-value">
                                            <i class="ph ph-arrow-right" style="font-size: 1rem;"></i>
                                        </div>
                                        <div class="stat-label">Plans Alimentaires</div>
                                        <div class="stat-change positive">
                                            <i class="ph ph-plus-circle"></i>
                                            Gérer les plans
                                        </div>
                                    </div>


                                </div>

                                <!-- Content Grid -->
                                <div class="content-grid">


                                    <!-- Today's Schedule Card -->
                                    <div class="card animate-fade-in" style="animation-delay: 0.4s;">
                                        <div class="card-header flex items-center justify-between">
                                            <h3>
                                                <i class="ph ph-calendar-dots mr-2" style="color: var(--primary);"></i>
                                                Programme du Jour
                                            </h3>
                                            <a href="${pageContext.request.contextPath}/nutritionist/appointments"
                                                class="link text-sm">
                                                Voir tout
                                            </a>
                                        </div>

                                        <% List<Appointment> appointments = (List<Appointment>)
                                                request.getAttribute("todayAppointments");
                                                if (appointments != null && !appointments.isEmpty()) {
                                                for(Appointment appt : appointments) { %>
                                                <div class="schedule-item">
                                                    <div class="schedule-time">
                                                        <%= new
                                                            java.text.SimpleDateFormat("HH:mm").format(appt.getScheduledTime())
                                                            %>
                                                    </div>
                                                    <div class="schedule-indicator"></div>
                                                    <div class="schedule-content">
                                                        <div class="schedule-title" style="display: flex; align-items: center; gap: 0.5rem;">
                                                            <% if (appt.getPatientProfilePicture() != null && !appt.getPatientProfilePicture().isEmpty()) { %>
                                                                <img src="${pageContext.request.contextPath}/<%= appt.getPatientProfilePicture() %>" 
                                                                     style="width: 24px; height: 24px; border-radius: 50%; object-fit: cover;">
                                                            <% } %>
                                                            <%= appt.getPatientName() %>
                                                        </div>
                                                        <div class="schedule-description">
                                                            <%= appt.getNotes() != null && !appt.getNotes().isEmpty() ? appt.getNotes() : "Séance de consultation" %>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% } } else { %>
                                                    <div class="empty-state">
                                                        <div class="empty-state-icon">
                                                            <i class="ph ph-calendar-blank"></i>
                                                        </div>
                                                        <div class="empty-state-title">Journée Libre !</div>
                                                        <div class="empty-state-text">Aucun rendez-vous prévu pour
                                                            aujourd'hui.</div>
                                                    </div>
                                                    <% } %>
                                    </div>
                                </div>
                            </div>
                        </main>
                    </div>
                </body>

                </html>