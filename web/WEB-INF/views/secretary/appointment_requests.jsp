<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.AppointmentRequest" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demandes de Rendez-vous - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .request-card {
            background: white;
            border-radius: var(--radius-xl);
            padding: 1.5rem;
            margin-bottom: 1rem;
            border: 1px solid var(--gray-200);
            transition: all var(--transition-fast);
        }
        
        .request-card:hover {
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }
        
        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }
        
        .patient-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .patient-avatar {
            width: 50px;
            height: 50px;
            border-radius: var(--radius-full);
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            flex-shrink: 0;
            overflow: hidden;
        }
        
        .patient-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .patient-details h4 {
            margin-bottom: 0.25rem;
        }
        
        .patient-details p {
            color: var(--gray-500);
            font-size: 0.875rem;
        }
        
        .request-time {
            text-align: right;
        }
        
        .request-time .date {
            font-weight: 600;
            color: var(--primary);
            font-size: 1.1rem;
        }
        
        .request-time .time {
            color: var(--gray-600);
            font-size: 0.875rem;
        }
        
        .request-notes {
            padding: 1rem;
            background: var(--gray-50);
            border-radius: var(--radius-lg);
            margin-bottom: 1rem;
            font-size: 0.875rem;
            color: var(--gray-700);
        }
        
        .request-notes label {
            font-weight: 600;
            color: var(--gray-500);
            font-size: 0.75rem;
            text-transform: uppercase;
            display: block;
            margin-bottom: 0.5rem;
        }
        
        .request-actions {
            display: flex;
            gap: 0.75rem;
            justify-content: flex-end;
        }
        
        .request-meta {
            font-size: 0.75rem;
            color: var(--gray-400);
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-100);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--gray-500);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--gray-300);
            margin-bottom: 1rem;
        }
        
        /* Modal styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .modal-overlay.show {
            display: flex;
        }
        
        .modal-content {
            background: white;
            border-radius: var(--radius-xl);
            padding: 2rem;
            max-width: 450px;
            width: 90%;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .modal-header h3 {
            margin: 0;
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--gray-500);
        }
    </style>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="page-content">
                <div class="page-header flex items-center justify-between">
                    <div>
                        <h1><i class="ph ph-clock-countdown" style="color: var(--primary);"></i> Demandes de Rendez-vous</h1>
                        <p>Examinez et gérez les demandes de rendez-vous des patients.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/secretary/appointments" class="btn btn-ghost">
                        <i class="ph ph-calendar"></i> Voir tous les RDV
                    </a>
                </div>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success" style="margin-bottom: 1rem;">
                        <i class="ph ph-check-circle"></i> ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error" style="margin-bottom: 1rem;">
                        <i class="ph ph-x-circle"></i> ${error}
                    </div>
                </c:if>
                
                <% 
                    List<AppointmentRequest> requests = (List<AppointmentRequest>) request.getAttribute("appointmentRequests");
                    SimpleDateFormat dateFormat = new SimpleDateFormat("EEE d MMM", java.util.Locale.FRENCH);
                    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                    SimpleDateFormat createdFormat = new SimpleDateFormat("d MMM yyyy 'à' HH:mm", java.util.Locale.FRENCH);
                %>
                
                <% if (requests != null && !requests.isEmpty()) { %>
                    <div class="card">
                        <div class="card-header flex items-center justify-between">
                            <h3>
                                <i class="ph ph-users mr-2" style="color: var(--primary);"></i>
                                Demandes en Attente (<%= requests.size() %>)
                            </h3>
                        </div>
                        
                        <% for (AppointmentRequest req : requests) { 
                            String initials = "";
                            if (req.getPatientName() != null) {
                                String[] names = req.getPatientName().split(" ");
                                initials = names[0].substring(0, 1);
                                if (names.length > 1) initials += names[names.length - 1].substring(0, 1);
                            }
                        %>
                        <div class="request-card">
                            <div class="request-header">
                                <div class="patient-info">
                                    <div class="patient-avatar">
                                        <% if (req.getPatientProfilePicture() != null && !req.getPatientProfilePicture().isEmpty()) { %>
                                            <img src="${pageContext.request.contextPath}/<%= req.getPatientProfilePicture() %>" alt="Profile">
                                        <% } else { %>
                                            <%= initials.toUpperCase() %>
                                        <% } %>
                                    </div>
                                    <div class="patient-details">
                                        <h4><%= req.getPatientName() != null ? req.getPatientName() : "Patient Inconnu" %></h4>
                                        <p><%= req.getPatientEmail() != null ? req.getPatientEmail() : "" %></p>
                                    </div>
                                </div>
                                <div class="request-time">
                                    <div class="date"><%= dateFormat.format(req.getRequestedTime()) %></div>
                                    <div class="time"><i class="ph ph-clock"></i> <%= timeFormat.format(req.getRequestedTime()) %></div>
                                </div>
                            </div>
                            
                            <% if (req.getPatientNotes() != null && !req.getPatientNotes().isEmpty()) { %>
                            <div class="request-notes">
                                <label><i class="ph ph-note"></i> Message du Patient</label>
                                <%= req.getPatientNotes() %>
                            </div>
                            <% } %>
                            
                            <!-- Payment Info -->
                            <div class="request-notes" style="background: var(--primary-50); border: 1px solid var(--primary-200);">
                                <label style="color: var(--primary-700);"><i class="ph ph-wallet"></i> Détails du Paiement</label>
                                <div style="display: flex; gap: 2rem; margin-top: 0.5rem;">
                                    <div>
                                        <span style="color: var(--gray-600); font-size: 0.8rem;">Méthode :</span>
                                        <span style="font-weight: 600; color: var(--gray-900);">
                                            <% if ("online".equals(req.getPaymentMethod())) { %>
                                                <i class="ph ph-globe"></i> Paiement en ligne
                                            <% } else { %>
                                                <i class="ph ph-buildings"></i> Payer au cabinet
                                            <% } %>
                                        </span>
                                    </div>
                                    <div>
                                        <span style="color: var(--gray-600); font-size: 0.8rem;">Statut :</span>
                                        <span class="badge <%= "paid".equals(req.getPaymentStatus()) ? "badge-success" : "badge-warning" %>">
                                            <%= "paid".equals(req.getPaymentStatus()) ? "PAYÉ" : "EN ATTENTE" %>
                                        </span>
                                    </div>
                                    <% if (req.getPaymentAmount() != null) { %>
                                    <div>
                                        <span style="color: var(--gray-600); font-size: 0.8rem;">Montant :</span>
                                        <span style="font-weight: 600; color: var(--gray-900); text-transform: uppercase;"><%= req.getPaymentAmount() %> TND</span>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            
                            <div class="request-actions">
                                <button class="btn btn-ghost" style="color: var(--error);" 
                                        onclick="showRejectModal(<%= req.getId() %>, '<%= req.getPatientName() != null ? req.getPatientName().replace("'", "\\'") : "Patient" %>')">
                                    <i class="ph ph-x"></i> Rejeter
                                </button>
                                <form method="POST" action="${pageContext.request.contextPath}/secretary/approveAppointmentRequest" style="display: inline;">
                                    <input type="hidden" name="requestId" value="<%= req.getId() %>">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="ph ph-check"></i> Approuver
                                    </button>
                                </form>
                            </div>
                            
                            <div class="request-meta">
                                <i class="ph ph-calendar-blank"></i> Demandé le <%= createdFormat.format(req.getCreatedAt()) %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="card">
                        <div class="empty-state">
                            <i class="ph ph-checks"></i>
                            <h3>Tout est à jour !</h3>
                            <p>Il n'y a aucune demande de rendez-vous en attente pour le moment.</p>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <!-- Reject Modal -->
    <div class="modal-overlay" id="rejectModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="ph ph-x-circle" style="color: var(--error);"></i> Rejeter la demande</h3>
                <button class="modal-close" onclick="closeRejectModal()">&times;</button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/secretary/rejectAppointmentRequest">
                <input type="hidden" name="requestId" id="rejectRequestId">
                <p style="margin-bottom: 1rem; color: var(--gray-600);">
                    Veuillez fournir une raison pour le rejet de la demande de <strong id="rejectPatientName"></strong>.
                </p>
                <div class="form-group">
                    <label class="label" for="reason">Raison du rejet</label>
                    <textarea name="reason" id="reason" class="input" rows="3" required
                              placeholder="ex : Le créneau horaire demandé n'est pas disponible..."></textarea>
                </div>
                <div style="display: flex; gap: 0.75rem; justify-content: flex-end;">
                    <button type="button" class="btn btn-ghost" onclick="closeRejectModal()">Annuler</button>
                    <button type="submit" class="btn" style="background: var(--error); color: white;">
                        <i class="ph ph-x"></i> Rejeter la demande
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function showRejectModal(requestId, patientName) {
            document.getElementById('rejectRequestId').value = requestId;
            document.getElementById('rejectPatientName').textContent = patientName;
            document.getElementById('rejectModal').classList.add('show');
        }
        
        function closeRejectModal() {
            document.getElementById('rejectModal').classList.remove('show');
        }
        
        // Close modal on outside click
        document.getElementById('rejectModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeRejectModal();
            }
        });
    </script>
</body>
</html>
