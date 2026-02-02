<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.Appointment" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Rendez-vous - Nutrit</title>
                <meta name="description" content="Consultez et gérez tous vos rendez-vous.">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <script src="https://unpkg.com/@phosphor-icons/web"></script>
                <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
                <style>
                    .fc { font-family: 'Inter', sans-serif; }
                    .fc-toolbar-title { font-size: 1.25rem !important; font-weight: 600; }
                    .fc-button { background-color: var(--primary) !important; border-color: var(--primary) !important; }
                    .status-confirmed { background-color: #10B981 !important; }
                    .status-pending { background-color: #F59E0B !important; }
                    .status-cancelled { background-color: #EF4444 !important; }
                    .status-completed { background-color: #3B82F6 !important; }
                    .status-default { background-color: #6B7280 !important; }
                </style>
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
                                    <h1>Rendez-vous</h1>
                                    <p>Consultez et gérez tous les rendez-vous planifiés.</p>
                                </div>
                            </div>

                            <!-- Appointments Calendar -->
                            <div class="card animate-fade-in" style="padding: 1.5rem;">
                                <div id='calendar'></div>
                            </div>
                            
                            <% 
                                // Serialize appointments to JSON
                                List<Appointment> list = (List<Appointment>) request.getAttribute("appointments");
                                StringBuilder jsonEvents = new StringBuilder("[");
                                if (list != null && !list.isEmpty()) {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                                    for (int i = 0; i < list.size(); i++) {
                                        Appointment app = list.get(i);
                                        String status = app.getStatus() != null ? app.getStatus().toLowerCase() : "default";
                                        String className = "status-default";
                                        
                                        if ("confirmed".equals(status) || "upcoming".equals(status)) className = "status-confirmed";
                                        else if ("pending".equals(status)) className = "status-pending";
                                        else if ("cancelled".equals(status)) className = "status-cancelled";
                                        else if ("completed".equals(status)) className = "status-completed";
                                        
                                        // Determine title based on current user role (if secretary/admin, show patient + nutritionist?)
                                        String title = (app.getPatientName() != null ? app.getPatientName() : "Patient");
                                        
                                        jsonEvents.append("{");
                                        jsonEvents.append("'id': '").append(app.getId()).append("',");
                                        jsonEvents.append("'title': '").append(title.replace("'", "\\'")).append("',");
                                        jsonEvents.append("'start': '").append(sdf.format(app.getScheduledTime())).append("',");
                                        jsonEvents.append("'className': '").append(className).append("',");
                                        jsonEvents.append("'extendedProps': {");
                                        jsonEvents.append("'patientId': ").append(app.getPatientId()).append(",");
                                        jsonEvents.append("'status': '").append(status).append("'");
                                        jsonEvents.append("}");
                                        jsonEvents.append("}");
                                        if (i < list.size() - 1) jsonEvents.append(",");
                                    }
                                }
                                jsonEvents.append("]");
                            %>

                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    var calendarEl = document.getElementById('calendar');
                                    var calendar = new FullCalendar.Calendar(calendarEl, {
                                        initialView: 'dayGridMonth',
                                        headerToolbar: {
                                            left: 'prev,next today',
                                            center: 'title',
                                            right: 'dayGridMonth,timeGridWeek,timeGridDay'
                                        },
                                        locale: 'fr',
                                        buttonText: {
                                            today: "Aujourd'hui",
                                            month: 'Mois',
                                            week: 'Semaine',
                                            day: 'Jour',
                                            list: 'Liste'
                                        },
                                        events: <%= jsonEvents.toString() %>,
                                        eventClick: function(info) {
                                            // Handle click based on role? For now redirect to generic view or patient profile if possible
                                            var patientId = info.event.extendedProps.patientId;
                                            if (patientId) {
                                                // Try to detect context? Defaulting to nutritionist path as requested, 
                                                // but for secretary it might need secretary path.
                                                // We can use JS to check current path or just try one.
                                                // Safer: just alert details or ensure the link is correct?
                                                // The previous table had logic for editUrl based on role.
                                                
                                                <% 
                                                    com.nutrit.models.User sUser = (com.nutrit.models.User) session.getAttribute("user");
                                                    String r = sUser != null ? sUser.getRole() : "";
                                                    String pathPrefix = "secretary".equals(r) ? "secretary" : "nutritionist";
                                                %>
                                                window.location.href = '${pageContext.request.contextPath}/<%= pathPrefix %>/viewPatientProfile?patientId=' + patientId;
                                            }
                                        }
                                    });
                                    calendar.render();
                                });
                            </script>
                        </div>
                    </main>
                </div>
            </body>

            </html>