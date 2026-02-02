<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nutrit.models.Appointment" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Rendez-vous - Nutritionniste</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
    <style>
        .fc {
            font-family: 'Inter', sans-serif;
        }
        .fc-toolbar-title {
            font-size: 1.25rem !important;
            font-weight: 600;
        }
        .fc-button {
            background-color: var(--primary) !important;
            border-color: var(--primary) !important;
            font-weight: 500 !important;
            text-transform: capitalize !important;
        }
        .fc-button:hover {
            background-color: var(--primary-dark) !important;
            border-color: var(--primary-dark) !important;
        }
        .fc-button-active {
            background-color: var(--primary-dark) !important;
            border-color: var(--primary-dark) !important;
        }
        .fc-event {
            border: none !important;
            padding: 2px 4px;
            cursor: pointer;
            transition: transform 0.1s;
        }
        .fc-event:hover {
            transform: scale(1.02);
        }
        /* Status colors */
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
                <div class="page-header">
                    <h1>Mes Rendez-vous</h1>
                    <p>Consultez vos rendez-vous passés et à venir avec vos patients.</p>
                </div>

                <div class="card animate-fade-in" style="padding: 1.5rem;">
                    <div id='calendar'></div>
                </div>
                
                <% 
                    // Serialize appointments to JSON
                    List<Appointment> appts = (List<Appointment>) request.getAttribute("appointments");
                    StringBuilder jsonEvents = new StringBuilder("[");
                    if (appts != null && !appts.isEmpty()) {
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                        for (int i = 0; i < appts.size(); i++) {
                            Appointment app = appts.get(i);
                            String status = app.getStatus() != null ? app.getStatus().toLowerCase() : "default";
                            String className = "status-default";
                            
                            if ("confirmed".equals(status) || "upcoming".equals(status)) className = "status-confirmed";
                            else if ("pending".equals(status)) className = "status-pending";
                            else if ("cancelled".equals(status)) className = "status-cancelled";
                            else if ("completed".equals(status)) className = "status-completed";
                            
                            jsonEvents.append("{");
                            jsonEvents.append("'id': '").append(app.getId()).append("',");
                            jsonEvents.append("'title': '").append(app.getPatientName() != null ? app.getPatientName().replace("'", "\\'") : "Patient").append("',");
                            jsonEvents.append("'start': '").append(sdf.format(app.getScheduledTime())).append("',");
                            jsonEvents.append("'className': '").append(className).append("',");
                            jsonEvents.append("'extendedProps': {");
                            jsonEvents.append("'patientId': ").append(app.getPatientId()).append(",");
                            jsonEvents.append("'status': '").append(status).append("'");
                            jsonEvents.append("}");
                            
                            jsonEvents.append("}");
                            if (i < appts.size() - 1) jsonEvents.append(",");
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
                            locale: 'fr', // French Locale
                            buttonText: {
                                today: "Aujourd'hui",
                                month: 'Mois',
                                week: 'Semaine',
                                day: 'Jour',
                                list: 'Liste'
                            },
                            events: <%= jsonEvents.toString() %>,
                            eventClick: function(info) {
                                var patientId = info.event.extendedProps.patientId;
                                if (patientId) {
                                    window.location.href = '${pageContext.request.contextPath}/nutritionist/viewPatientProfile?patientId=' + patientId;
                                }
                            },
                            eventContent: function(arg) {
                                var timeText = arg.timeText;
                                // Custom inner HTML
                                var title = arg.event.title;
                                var status = arg.event.extendedProps.status;
                                var icon = 'user';
                                
                                return {
                                    html: '<div class="fc-content">' +
                                          '<div class="fc-title" style="font-weight:600;">' + title + '</div>' + 
                                          '</div>'
                                };
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
