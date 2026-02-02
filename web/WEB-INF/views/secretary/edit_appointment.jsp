<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.Appointment" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le RDV - Secrétariat</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .edit-container { max-width: 900px; margin: 0 auto; }
        .current-info { padding: 1.5rem; background: linear-gradient(135deg, var(--gray-50), var(--gray-100)); border-radius: var(--radius-xl); margin-bottom: 1.5rem; }
        .current-info h4 { margin-bottom: 0.5rem; }
        .date-section { margin-bottom: 1.5rem; }
        .date-header { background: var(--gray-100); padding: 0.75rem 1rem; border-radius: var(--radius-lg); font-weight: 600; margin-bottom: 0.75rem; }
        .slots-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 0.5rem; }
        .slot-btn { padding: 0.75rem; border: 2px solid var(--gray-200); border-radius: var(--radius-lg); background: white; cursor: pointer; font-weight: 500; transition: all var(--transition-fast); }
        .slot-btn:hover { border-color: var(--primary); background: var(--primary-50); }
        .slot-btn.selected { border-color: var(--primary); background: var(--primary); color: white; }
        .slot-btn.current { border-color: var(--success); background: #D1FAE5; }
        .cancel-warning { padding: 1rem; background: #FEF3C7; border-radius: var(--radius-lg); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem; }
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
                        <h1><i class="ph ph-pencil-simple" style="color: var(--primary);"></i> Modifier le Rendez-vous</h1>
                        <p>Reprogrammez ou mettez à jour les détails du rendez-vous.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/secretary/appointments" class="btn btn-ghost"><i class="ph ph-arrow-left"></i> Retour</a>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error" style="margin-bottom: 1rem;"><i class="ph ph-x-circle"></i> ${error}</div>
                </c:if>
                
                <% Appointment appt = (Appointment) request.getAttribute("appointment");
                   Boolean canCancel = (Boolean) request.getAttribute("canCancel");
                   SimpleDateFormat fullFormat = new SimpleDateFormat("EEEE d MMM 'à' HH:mm", java.util.Locale.FRENCH);
                   SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                   if (appt != null) { %>
                
                <div class="edit-container">
                    <div class="current-info">
                        <h4><i class="ph ph-user mr-1"></i> <%= appt.getPatientName() %></h4>
                        <p><i class="ph ph-calendar mr-1"></i> Actuel : <strong><%= fullFormat.format(appt.getScheduledTime()) %></strong></p>
                        <p style="margin-top: 0.5rem; color: var(--gray-600);"><i class="ph ph-note mr-1"></i> <%= appt.getNotes() != null ? appt.getNotes() : "Aucune note" %></p>
                    </div>
                    
                    <% if (canCancel == null || !canCancel) { %>
                    <div class="cancel-warning">
                        <i class="ph ph-warning" style="color: var(--warning);"></i>
                        <span>Ce rendez-vous est dans moins de 2 heures et ne peut plus être annulé.</span>
                    </div>
                    <% } %>
                    
                    <form method="POST" action="${pageContext.request.contextPath}/secretary/editAppointment">
                        <input type="hidden" name="appointmentId" value="<%= appt.getId() %>">
                        
                        <div class="card" style="margin-bottom: 1.5rem;">
                            <div class="card-header"><h3><i class="ph ph-clock mr-2" style="color: var(--primary);"></i> Reprogrammer pour le</h3></div>
                            <% Map<String, List<Timestamp>> availableSlots = (Map<String, List<Timestamp>>) request.getAttribute("availableSlots");
                               if (availableSlots != null && !availableSlots.isEmpty()) { %>
                                <% for (Map.Entry<String, List<Timestamp>> entry : availableSlots.entrySet()) { %>
                                <div class="date-section">
                                    <div class="date-header"><i class="ph ph-calendar-blank mr-1"></i> <%= entry.getKey() %></div>
                                    <div class="slots-grid">
                                        <% for (Timestamp slot : entry.getValue()) { 
                                               boolean isCurrent = slot.equals(appt.getScheduledTime()); %>
                                        <button type="button" class="slot-btn <%= isCurrent ? "current selected" : "" %>" 
                                                data-slot="<%= slot.toString() %>" onclick="selectSlot(this, '<%= slot.toString() %>')">
                                            <%= timeFormat.format(slot) %><%= isCurrent ? " ✓" : "" %>
                                        </button>
                                        <% } %>
                                    </div>
                                </div>
                                <% } %>
                            <% } %>
                        </div>
                        
                        <input type="hidden" name="newTime" id="newTimeInput" value="<%= appt.getScheduledTime().toString() %>">
                        
                        <div class="form-group">
                            <label class="label" for="notes">Notes</label>
                            <textarea name="notes" id="notes" class="input" rows="3"><%= appt.getNotes() != null ? appt.getNotes() : "" %></textarea>
                        </div>
                        
                        <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                            <button type="submit" class="btn btn-primary"><i class="ph ph-floppy-disk"></i> Enregistrer les modifications</button>
                            <% if (canCancel != null && canCancel) { %>
                            <button type="button" class="btn" style="background: var(--error); color: white;" onclick="confirmCancel(<%= appt.getId() %>)">
                                <i class="ph ph-x"></i> Annuler le Rendez-vous
                            </button>
                            <% } %>
                        </div>
                    </form>
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <script>
        function selectSlot(btn, slotValue) {
            document.querySelectorAll('.slot-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            document.getElementById('newTimeInput').value = slotValue;
        }
        
        function confirmCancel(id) {
            if (confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous ?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/secretary/cancelAppointment';
                form.innerHTML = '<input type="hidden" name="appointmentId" value="' + id + '">';
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
