<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.User" %>
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
    <title>Prendre un RDV - Secrétairiat</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .booking-container { max-width: 900px; margin: 0 auto; }
        .date-section { margin-bottom: 1.5rem; }
        .date-header { background: var(--gray-100); padding: 0.75rem 1rem; border-radius: var(--radius-lg); font-weight: 600; margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.5rem; }
        .slots-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 0.5rem; }
        .slot-btn { padding: 0.75rem; border: 2px solid var(--gray-200); border-radius: var(--radius-lg); background: white; cursor: pointer; font-weight: 500; transition: all var(--transition-fast); text-align: center; }
        .slot-btn:hover { border-color: var(--primary); background: var(--primary-50); }
        .slot-btn.selected { border-color: var(--primary); background: var(--primary); color: white; }
        .booking-form { margin-top: 2rem; padding: 1.5rem; background: var(--gray-50); border-radius: var(--radius-xl); }
        .selected-slot-display { padding: 1rem; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; border-radius: var(--radius-lg); margin-bottom: 1rem; display: none; }
        .selected-slot-display.show { display: block; }
    </style>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="page-content">
                <div class="page-header">
                    <h1><i class="ph ph-calendar-plus" style="color: var(--primary);"></i> Prendre un Rendez-vous</h1>
                    <p>Sélectionnez un patient et un créneau horaire pour créer un rendez-vous directement.</p>
                </div>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success" style="margin-bottom: 1rem;"><i class="ph ph-check-circle"></i> ${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error" style="margin-bottom: 1rem;"><i class="ph ph-x-circle"></i> ${error}</div>
                </c:if>
                
                <div class="booking-container">
                    <form method="POST" action="${pageContext.request.contextPath}/secretary/bookDirect">
                        <div class="card" style="margin-bottom: 1.5rem;">
                            <div class="card-header"><h3><i class="ph ph-user mr-2" style="color: var(--primary);"></i> Sélectionner un Patient</h3></div>
                            <div style="padding: 1rem;">
                                <select name="patientId" id="patientId" class="input" required>
                                    <option value="">-- Choisir un patient --</option>
                                    <% List<User> patients = (List<User>) request.getAttribute("patients");
                                       Integer selectedPatientId = (Integer) request.getAttribute("selectedPatientId");
                                       if (patients != null) {
                                           for (User p : patients) { %>
                                        <option value="<%= p.getId() %>" <%= (selectedPatientId != null && selectedPatientId == p.getId()) ? "selected" : "" %>><%= p.getFullName() %></option>
                                    <% } } %>
                                </select>
                            </div>
                        </div>
                        
                        <div class="card">
                            <div class="card-header"><h3><i class="ph ph-calendar-dots mr-2" style="color: var(--primary);"></i> Créneaux Horaires Disponibles</h3></div>
                            <% Map<String, List<Timestamp>> availableSlots = (Map<String, List<Timestamp>>) request.getAttribute("availableSlots");
                               SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                               if (availableSlots != null && !availableSlots.isEmpty()) { %>
                                <% for (Map.Entry<String, List<Timestamp>> entry : availableSlots.entrySet()) { %>
                                <div class="date-section">
                                    <div class="date-header"><i class="ph ph-calendar-blank"></i> <%= entry.getKey() %></div>
                                    <div class="slots-grid">
                                        <% for (Timestamp slot : entry.getValue()) { %>
                                        <button type="button" class="slot-btn" data-slot="<%= slot.toString() %>" onclick="selectSlot(this, '<%= slot.toString() %>')"><%= timeFormat.format(slot) %></button>
                                        <% } %>
                                    </div>
                                </div>
                                <% } %>
                                
                                <div class="booking-form">
                                    <div class="selected-slot-display" id="selectedSlotDisplay">
                                        <i class="ph ph-check-circle" style="margin-right: 0.5rem;"></i> Sélectionné : <span id="selectedSlotText"></span>
                                    </div>
                                    <input type="hidden" name="selectedSlot" id="selectedSlotInput">
                                    <div class="form-group">
                                        <label class="label" for="notes"><i class="ph ph-note mr-1"></i> Notes (optionnel)</label>
                                        <textarea name="notes" id="notes" class="input" rows="3" placeholder="Notes sur le rendez-vous..."></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary" id="submitBtn" disabled><i class="ph ph-calendar-check"></i> Créer le Rendez-vous</button>
                                </div>
                            <% } else { %>
                                <div style="text-align: center; padding: 3rem; color: var(--gray-500);">
                                    <i class="ph ph-calendar-x" style="font-size: 3rem;"></i>
                                    <h4>Aucun créneau disponible</h4>
                                    <p>Le nutritionniste n'a pas encore configuré sa disponibilité.</p>
                                </div>
                            <% } %>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
    <script>
        function selectSlot(btn, slotValue) {
            document.querySelectorAll('.slot-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            document.getElementById('selectedSlotInput').value = slotValue;
            document.getElementById('selectedSlotDisplay').classList.add('show');
            document.getElementById('selectedSlotText').textContent = btn.textContent.trim();
            document.getElementById('submitBtn').disabled = false;
        }
    </script>
</body>
</html>
