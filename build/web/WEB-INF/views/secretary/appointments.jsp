<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.User" %>
            <%@ page import="com.nutrit.models.Appointment" %>
                <!DOCTYPE html>
                <html lang="fr">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Rendez-vous - Secrétariat Nutrit</title>
                    <meta name="description" content="Prenez et gérez les rendez-vous des patients.">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                    <script src="https://unpkg.com/@phosphor-icons/web"></script>
                    <style>
                        .booking-grid {
                            display: grid;
                            grid-template-columns: 1fr 1.5fr;
                            gap: 1.5rem;
                        }

                        @media (max-width: 1024px) {
                            .booking-grid {
                                grid-template-columns: 1fr;
                            }
                        }

                        .selected-patient-banner {
                            background: linear-gradient(135deg, var(--primary-50), var(--primary-100));
                            border: 1px solid var(--primary-200);
                            border-radius: var(--radius-lg);
                            padding: 1rem 1.25rem;
                            margin-bottom: 1.5rem;
                            display: flex;
                            align-items: center;
                            gap: 0.75rem;
                        }

                        .selected-patient-banner i {
                            color: var(--primary-600);
                            font-size: 1.25rem;
                        }

                        .selected-patient-banner span {
                            color: var(--primary-700);
                            font-weight: 600;
                        }
                    </style>
                </head>

                <body>
                    <div class="flex">
                        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

                        <main class="main-content">
                            <jsp:include page="/WEB-INF/views/common/header.jsp" />

                            <div class="page-content">
                                <!-- Page Header -->
                                <div class="page-header">
                                    <h1>Gérer les Rendez-vous</h1>
                                    <p>Prenez de nouveaux rendez-vous et consultez le planning d'aujourd'hui.</p>
                                </div>

                                <% if (request.getAttribute("success") !=null) { %>
                                    <div class="alert alert-success animate-fade-in">
                                        <i class="ph ph-check-circle" style="font-size: 1.25rem; flex-shrink: 0;"></i>
                                        <span>
                                            <%= request.getAttribute("success") %>
                                        </span>
                                    </div>
                                    <% } %>

                                        <% if (request.getAttribute("error") !=null) { %>
                                            <div class="alert alert-error animate-fade-in">
                                                <i class="ph ph-warning-circle"
                                                    style="font-size: 1.25rem; flex-shrink: 0;"></i>
                                                <span>
                                                    <%= request.getAttribute("error") %>
                                                </span>
                                            </div>
                                            <% } %>

                                                <div class="booking-grid">
                                                    <!-- Booking Form Card -->
                                                    <div class="card animate-fade-in">
                                                        <div class="card-header">
                                                            <h3>
                                                                <i class="ph ph-calendar-plus mr-2"
                                                                    style="color: var(--primary);"></i>
                                                                Prendre un Nouveau RDV
                                                            </h3>
                                                        </div>

                                                        <% List<User> patients = (List<User>)
                                                                request.getAttribute("patients");
                                                                String preId = request.getParameter("patientId");
                                                                String selectedName = null;
                                                                if (patients != null && preId != null) {
                                                                for (User p : patients) {
                                                                if (String.valueOf(p.getId()).equals(preId)) {
                                                                selectedName = p.getFullName();
                                                                break;
                                                                }
                                                                }
                                                                }
                                                                %>

                                                                <% if (selectedName !=null) { %>
                                                                    <div class="selected-patient-banner">
                                                                        <i class="ph ph-user-check"></i>
                                                                        <span>Réservation pour : <%= selectedName %></span>
                                                                    </div>
                                                                    <% } %>

                                                                        <form
                                                                            action="${pageContext.request.contextPath}/secretary/bookAppointment"
                                                                            method="POST">
                                                                            <div class="form-group">
                                                                                <label class="label">
                                                                                    <i
                                                                                        class="ph ph-user-circle mr-1"></i>
                                                                                    Sélectionner un Patient
                                                                                </label>
                                                                                <select name="patientId" class="input"
                                                                                    required>
                                                                                    <option value="" disabled
                                                                                        <%=selectedName==null
                                                                                        ? "selected" : "" %>>Choisir un
                                                                                        patient...</option>
                                                                                    <% if (patients !=null) { for(User p
                                                                                        : patients) { boolean
                                                                                        isSelected=(preId !=null &&
                                                                                        preId.equals(String.valueOf(p.getId())));
                                                                                        %>
                                                                                        <option value="<%= p.getId() %>"
                                                                                            <%=isSelected ? "selected"
                                                                                            : "" %>>
                                                                                            <%= p.getFullName() %> (<%=
                                                                                                    p.getEmail() %>)
                                                                                        </option>
                                                                                        <% } } %>
                                                                                </select>
                                                                            </div>

                                                                            <div class="form-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                                                                                <div class="form-group">
                                                                                    <label class="label">
                                                                                        <i
                                                                                            class="ph ph-calendar mr-1"></i>
                                                                                        Date
                                                                                    </label>
                                                                                    <input type="date" name="date"
                                                                                        class="input" required>
                                                                                </div>
                                                                                <div class="form-group">
                                                                                    <label class="label">
                                                                                        <i class="ph ph-clock mr-1"></i>
                                                                                        Heure
                                                                                    </label>
                                                                                    <input type="time" name="time"
                                                                                        class="input" required>
                                                                                </div>
                                                                            </div>

                                                                            <div class="form-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 1rem;">
                                                                                <div class="form-group">
                                                                                    <label class="label">
                                                                                        <i class="ph ph-tag mr-1"></i>
                                                                                        Type de Rendez-vous
                                                                                    </label>
                                                                                    <select name="apptType" class="input" required>
                                                                                        <option value="Initial Consultation">Consultation Initiale</option>
                                                                                        <option value="Follow-up">Suivi</option>
                                                                                        <option value="Diet Review">Révision Alimentaire</option>
                                                                                        <option value="General Check-in">Bilan Général</option>
                                                                                    </select>
                                                                                </div>
                                                                                <div class="form-group">
                                                                                    <label class="label">
                                                                                        <i class="ph ph-timer mr-1"></i>
                                                                                        Durée
                                                                                    </label>
                                                                                    <select name="duration" class="input" required>
                                                                                        <option value="15m">15 Minutes</option>
                                                                                        <option value="30m" selected>30 Minutes</option>
                                                                                        <option value="45m">45 Minutes</option>
                                                                                        <option value="60m">1 Heure</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>

                                                                            <div class="form-group" style="margin-top: 1rem;">
                                                                                <label class="label">
                                                                                    <i
                                                                                        class="ph ph-note-pencil mr-1"></i>
                                                                                    Raison / Notes
                                                                                </label>
                                                                                <textarea name="reason" class="input"
                                                                                    rows="3"
                                                                                    placeholder="Optionnel : Ajouter des notes spécifiques sur le rendez-vous..."></textarea>
                                                                            </div>

                                                                            <button type="submit"
                                                                                class="btn btn-primary w-full" style="margin-top: 1rem;">
                                                                                <i class="ph ph-calendar-check"></i>
                                                                                Prendre le Rendez-vous
                                                                            </button>
                                                                        </form>
                                                    </div>

                                                    <!-- Schedule Card -->
                                                    <div class="card animate-fade-in" style="animation-delay: 0.1s;">
                                                        <div class="card-header flex items-center justify-between">
                                                            <h3>
                                                                <i class="ph ph-clock mr-2"
                                                                    style="color: var(--primary);"></i>
                                                                Planning d'Aujourd'hui
                                                            </h3>
                                                        </div>

                                                        <div class="today-schedule" style="margin-top: 1rem;">
                                                            <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                                                               if (appointments != null && !appointments.isEmpty()) { 
                                                            %>
                                                            <div style="position: relative; padding-left: 2rem; border-left: 2px solid var(--gray-200); margin-left: 1rem; display: flex; flex-direction: column; gap: 2rem;">
                                                                <% for(Appointment appt : appointments) { 
                                                                    String statusClass = "";
                                                                    String statusText = appt.getStatus();
                                                                    if ("confirmed".equalsIgnoreCase(statusText)) { statusText = "Confirmé"; statusClass = "badge-success"; }
                                                                    else if ("pending".equalsIgnoreCase(statusText)) { statusText = "En attente"; statusClass = "badge-warning"; }
                                                                    else if ("cancelled".equalsIgnoreCase(statusText)) { statusText = "Annulé"; statusClass = "badge-danger"; }
                                                                    else { statusClass = "badge-gray"; }
                                                                %>
                                                                <div class="timeline-item" style="position: relative;">
                                                                    <!-- Timeline Dot -->
                                                                    <div style="position: absolute; left: -2.6rem; top: 0.25rem; width: 1rem; height: 1rem; border-radius: 50%; background: white; border: 2px solid var(--primary); z-index: 1;"></div>
                                                                    
                                                                    <div class="card" style="padding: 1rem; border: 1px solid var(--gray-200); transition: transform 0.2s ease; cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/secretary/viewPatientProfile?patientId=<%= appt.getPatientId() %>'">
                                                                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
                                                                            <span style="font-size: 1.125rem; font-weight: 700; color: var(--primary); font-family: monospace;">
                                                                                <%= new java.text.SimpleDateFormat("HH:mm").format(appt.getScheduledTime()) %>
                                                                            </span>
                                                                            <span class="badge <%= statusClass %>" style="font-size: 0.75rem;">
                                                                                <%= statusText.toUpperCase() %>
                                                                            </span>
                                                                        </div>
                                                                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                                            <% if (appt.getPatientProfilePicture() != null && !appt.getPatientProfilePicture().isEmpty()) { %>
                                                                                <img src="${pageContext.request.contextPath}/<%= appt.getPatientProfilePicture() %>" 
                                                                                     style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                                                                            <% } else { %>
                                                                                <div style="width: 32px; height: 32px; border-radius: 50%; background: var(--gray-100); color: var(--gray-500); display: flex; align-items: center; justify-content: center;">
                                                                                    <i class="ph ph-user"></i>
                                                                                </div>
                                                                            <% } %>
                                                                            <span style="font-weight: 600; color: var(--gray-800);">
                                                                                <%= appt.getPatientName() %>
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <% } %>
                                                            </div>
                                                            <% } else { %>
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon"><i class="ph ph-calendar-blank"></i></div>
                                                                    <div class="empty-state-title">Planning Libre</div>
                                                                    <div class="empty-state-text">Aucun rendez-vous prévu pour aujourd'hui.</div>
                                                                </div>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- All Appointments Table -->
                                                <div class="card animate-fade-in"
                                                    style="margin-top: 1.5rem; animation-delay: 0.2s;">
                                                    <div class="card-header flex items-center justify-between">
                                                        <h3>
                                                            <i class="ph ph-calendar-dots mr-2"
                                                                style="color: var(--primary);"></i>
                                                            Tous les Rendez-vous Planifiés
                                                        </h3>
                                                        <span class="badge badge-primary">
                                                            <% List<Appointment> allAppointments = (List<Appointment>)
                                                                    request.getAttribute("allAppointments"); %>
                                                                    <%= allAppointments !=null ? allAppointments.size()
                                                                        : 0 %> au total
                                                        </span>
                                                    </div>

                                                    <div class="appointment-list" style="display: flex; flex-direction: column; gap: 1rem; margin-top: 1.5rem;">
                                                        <% List<Appointment> allAppointments = (List<Appointment>) request.getAttribute("allAppointments");
                                                           if (allAppointments != null && !allAppointments.isEmpty()) { 
                                                            for(Appointment appt : allAppointments) { 
                                                                String statusClass = "";
                                                                String statusText = appt.getStatus();
                                                                if ("confirmed".equalsIgnoreCase(statusText) || "upcoming".equalsIgnoreCase(statusText)) { statusText = "Confirmé"; statusClass = "badge-success"; }
                                                                else if ("pending".equalsIgnoreCase(statusText)) { statusText = "En attente"; statusClass = "badge-warning"; }
                                                                else if ("cancelled".equalsIgnoreCase(statusText)) { statusText = "Annulé"; statusClass = "badge-danger"; }
                                                                else if ("completed".equalsIgnoreCase(statusText)) { statusText = "Terminé"; statusClass = "badge-primary"; }
                                                                else { statusClass = "badge-gray"; }
                                                                
                                                                String type = "Consultation";
                                                                String notes = appt.getNotes();
                                                                if (notes != null && notes.contains("[")) {
                                                                    int end = notes.indexOf("]");
                                                                    if (end > 1) {
                                                                        type = notes.substring(1, end);
                                                                    }
                                                                }
                                                        %>
                                                        <div style="background: white; border: 1px solid var(--gray-200); border-radius: var(--radius-lg); padding: 1.25rem; display: grid; grid-template-columns: auto 1fr auto; gap: 1.5rem; align-items: center; transition: all 0.2s ease; cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/secretary/viewPatientProfile?patientId=<%= appt.getPatientId() %>'">
                                                            <!-- Date Block -->
                                                            <div style="display: flex; flex-direction: column; align-items: center; min-width: 70px; padding-right: 1.25rem; border-right: 1px solid var(--gray-100);">
                                                                <span style="font-size: 0.75rem; font-weight: 600; text-transform: uppercase; color: var(--gray-500);">
                                                                    <%= new java.text.SimpleDateFormat("MMM").format(appt.getScheduledTime()) %>
                                                                </span>
                                                                <span style="font-size: 1.5rem; font-weight: 700; color: var(--primary); line-height: 1.2;">
                                                                    <%= new java.text.SimpleDateFormat("dd").format(appt.getScheduledTime()) %>
                                                                </span>
                                                                <span style="font-size: 0.875rem; color: var(--gray-600); margin-top: 0.25rem;">
                                                                    <%= new java.text.SimpleDateFormat("HH:mm").format(appt.getScheduledTime()) %>
                                                                </span>
                                                            </div>

                                                            <!-- Info Block -->
                                                            <div>
                                                                <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.25rem;">
                                                                    <h4 style="font-size: 1rem; font-weight: 600; color: var(--gray-900); margin: 0;">
                                                                        <%= appt.getPatientName() != null ? appt.getPatientName() : "Inconnu" %>
                                                                    </h4>
                                                                    <span class="badge badge-gray" style="font-size: 0.75rem; padding: 1px 6px;">
                                                                        <%= type %>
                                                                    </span>
                                                                </div>
                                                                <div style="color: var(--gray-500); font-size: 0.875rem; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden;">
                                                                    <% if (appt.getNotes() != null && !appt.getNotes().isEmpty()) { %>
                                                                        <%= appt.getNotes().replace("["+type+"]", "").trim() %>
                                                                    <% } else { %>
                                                                        <span style="font-style: italic;">Aucune note</span>
                                                                    <% } %>
                                                                </div>
                                                            </div>
                                                            
                                                            <!-- Payment Info -->
                                                            <div style="text-align: right;">
                                                                <% 
                                                                    String payStatus = appt.getPaymentStatus();
                                                                    String payMethod = appt.getPaymentMethod();
                                                                    boolean isPaid = "paid".equalsIgnoreCase(payStatus);
                                                                    String payClass = isPaid ? "text-success" : "text-warning";
                                                                    String payIcon = "online".equals(payMethod) ? "ph-globe" : "ph-buildings";
                                                                %>
                                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 0.25rem;">
                                                                    <span class="badge <%= statusClass %>" style="margin-bottom: 0.25rem;">
                                                                        <%= statusText != null ? statusText.substring(0, 1).toUpperCase() + statusText.substring(1).toLowerCase() : "Inconnu" %>
                                                                    </span>
                                                                    
                                                                    <% if (payStatus != null) { %>
                                                                        <div style="font-size: 0.875rem; display: flex; align-items: center; gap: 0.25rem;">
                                                                            <i class="ph <%= payIcon %>" style="color: var(--gray-500);"></i>
                                                                            <span class="<%= payClass %>" style="font-weight: 500;">
                                                                                <%= isPaid ? "Payé" : "Impayé" %>
                                                                            </span>
                                                                            <% if (isPaid) { %>
                                                                                <a href="${pageContext.request.contextPath}/secretary/invoice?appointmentId=<%= appt.getId() %>" target="_blank" 
                                                                                   class="btn btn-sm btn-outline" style="padding: 0.1rem 0.5rem; font-size: 0.75rem; margin-left: 0.5rem;" title="Imprimer la Facture">
                                                                                    <i class="ph ph-printer"></i>
                                                                                </a>
                                                                            <% } else if ("in_office".equals(payMethod) && !"cancelled".equals(statusText)) { %>
                                                                                <form action="${pageContext.request.contextPath}/secretary/markPaid" method="POST" style="display: inline;">
                                                                                    <input type="hidden" name="appointmentId" value="<%= appt.getId() %>">
                                                                                    <button type="submit" class="btn btn-sm btn-primary" style="padding: 0.1rem 0.5rem; font-size: 0.75rem; margin-left: 0.5rem;">
                                                                                        Payer
                                                                                    </button>
                                                                                </form>
                                                                            <% } %>
                                                                        </div>
                                                                    <% } %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <% } } else { %>
                                                            <div class="empty-state">
                                                                <div class="empty-state-icon"><i class="ph ph-calendar-blank"></i></div>
                                                                <div class="empty-state-title">Aucun Rendez-vous</div>
                                                                <div class="empty-state-text">Commencez par prendre un nouveau rendez-vous.</div>
                                                            </div>
                                                        <% } %>
                                                    </div>
                                                </div>
                            </div>
                        </main>
                    </div>
                </body>

                </html>