<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="com.nutrit.models.NutritionistProfile" %>
<%@ page import="com.nutrit.models.AppointmentRequest" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prendre Rendez-vous - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .booking-container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        .nutritionist-info {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, var(--gray-50), var(--gray-100));
            border-radius: var(--radius-xl);
            margin-bottom: 2rem;
        }
        
        .nutritionist-avatar {
            width: 80px;
            height: 80px;
            border-radius: var(--radius-full);
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            flex-shrink: 0;
            overflow: hidden;
        }
        
        .nutritionist-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .nutritionist-details h3 {
            font-size: 1.25rem;
            margin-bottom: 0.25rem;
        }
        
        .nutritionist-details p {
            color: var(--gray-600);
            font-size: 0.875rem;
        }
        
        .next-slot-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: var(--success);
            color: white;
            border-radius: var(--radius-full);
            font-size: 0.875rem;
            font-weight: 500;
            margin-top: 0.75rem;
        }
        
        .date-section {
            margin-bottom: 1.5rem;
        }
        
        .date-header {
            background: var(--gray-100);
            padding: 0.75rem 1rem;
            border-radius: var(--radius-lg);
            font-weight: 600;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .slots-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 0.5rem;
        }
        
        .slot-btn {
            padding: 0.75rem;
            border: 2px solid var(--gray-200);
            border-radius: var(--radius-lg);
            background: white;
            cursor: pointer;
            font-weight: 500;
            transition: all var(--transition-fast);
            text-align: center;
        }
        
        .slot-btn:hover {
            border-color: var(--primary);
            background: var(--primary-50);
        }
        
        .slot-btn.selected {
            border-color: var(--primary);
            background: var(--primary);
            color: white;
        }
        
        .booking-form {
            margin-top: 2rem;
            padding: 1.5rem;
            background: var(--gray-50);
            border-radius: var(--radius-xl);
        }
        
        .selected-slot-display {
            padding: 1rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: var(--radius-lg);
            margin-bottom: 1rem;
            display: none;
        }
        
        .selected-slot-display.show {
            display: block;
        }
        
        .pending-request-card {
            padding: 1.5rem;
            background: linear-gradient(135deg, #FEF3C7, #FFFBEB);
            border-left: 4px solid var(--warning);
            border-radius: var(--radius-lg);
            margin-bottom: 2rem;
        }
        
        .empty-slots {
            text-align: center;
            padding: 3rem;
            color: var(--gray-500);
        }
        
        .empty-slots i {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }
    </style>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="page-content">
                <div class="page-header">
                    <h1><i class="ph ph-calendar-plus" style="color: var(--primary);"></i> Prendre Rendez-vous</h1>
                    <p>Sélectionnez un créneau horaire disponible pour demander un rendez-vous avec votre nutritionniste.</p>
                </div>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success" style="margin-bottom: 1rem;">
                        <i class="ph ph-check-circle"></i> ${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error" style="margin-bottom: 1rem;">
                        <i class="ph ph-x-circle"></i> ${errorMessage}
                    </div>
                </c:if>
                
                <div class="booking-container">
                    <% User nutritionist = (User) request.getAttribute("nutritionist"); %>
                    <% NutritionistProfile profile = (NutritionistProfile) request.getAttribute("nutritionistProfile"); %>
                    <% Timestamp nextSlot = (Timestamp) request.getAttribute("nextAvailableSlot"); %>
                    <% SimpleDateFormat slotFormat = new SimpleDateFormat("EEEE dd MMM 'à' HH:mm", Locale.FRENCH); %>
                    <% SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm"); %>
                    
                    <% if (nutritionist != null) { %>
                    <!-- Nutritionist Info Card -->
                    <div class="nutritionist-info card">
                        <div class="nutritionist-avatar">
                            <% if (nutritionist.getProfilePicture() != null && !nutritionist.getProfilePicture().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= nutritionist.getProfilePicture() %>" alt="Profile">
                            <% } else { %>
                                <i class="ph ph-user"></i>
                            <% } %>
                        </div>
                        <div class="nutritionist-details">
                            <h3>Dr. <%= nutritionist.getFullName() %></h3>
                            <p><%= profile != null && profile.getSpecialization() != null ? profile.getSpecialization() : "Nutritionist" %></p>
                            <% if (nextSlot != null) { %>
                                <div class="next-slot-badge">
                                    <i class="ph ph-clock"></i>
                                    Prochain dispo : <%= slotFormat.format(nextSlot) %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                    
                    <!-- Check for pending request -->
                    <% Boolean hasPending = (Boolean) request.getAttribute("hasPendingRequest"); %>
                    <% AppointmentRequest pendingReq = (AppointmentRequest) request.getAttribute("pendingRequest"); %>
                    <% if (hasPending != null && hasPending && pendingReq != null) { %>
                        <div class="pending-request-card">
                            <h4 style="margin-bottom: 0.5rem;">
                                <i class="ph ph-hourglass" style="color: var(--warning);"></i>
                                Vous avez une demande de rendez-vous en attente
                            </h4>
                            <p style="color: var(--gray-600); margin-bottom: 0.5rem;">
                                Heure demandée : <strong><%= slotFormat.format(pendingReq.getRequestedTime()) %></strong>
                            </p>
                            <p style="color: var(--gray-500); font-size: 0.875rem;">
                                Le secrétaire examinera votre demande bientôt. Vous serez notifié une fois approuvée.
                            </p>
                        </div>
                    <% } else { %>
                    
                    <!-- Available Slots -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="ph ph-calendar-dots mr-2" style="color: var(--primary);"></i> Créneaux Horaires Disponibles</h3>
                        </div>
                        
                        <% Map<String, List<Timestamp>> availableSlots = (Map<String, List<Timestamp>>) request.getAttribute("availableSlots"); %>
                        <% if (availableSlots != null && !availableSlots.isEmpty()) { %>
                            <% for (Map.Entry<String, List<Timestamp>> entry : availableSlots.entrySet()) { %>
                                <div class="date-section">
                                    <div class="date-header">
                                        <i class="ph ph-calendar-blank"></i>
                                        <%= entry.getKey() %>
                                    </div>
                                    <div class="slots-grid">
                                        <% for (Timestamp slot : entry.getValue()) { %>
                                            <button type="button" class="slot-btn" 
                                                    data-slot="<%= slot.toString() %>"
                                                    onclick="selectSlot(this, '<%= slot.toString() %>')">
                                                <%= timeFormat.format(slot) %>
                                            </button>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                            
                            <!-- Booking Form -->
                            <form method="POST" action="${pageContext.request.contextPath}/patient/bookAppointment" class="booking-form">
                                <div class="selected-slot-display" id="selectedSlotDisplay">
                                    <i class="ph ph-check-circle" style="margin-right: 0.5rem;"></i>
                                    Sélectionné : <span id="selectedSlotText"></span>
                                </div>
                                
                                <input type="hidden" name="selectedSlot" id="selectedSlotInput">
                                
                                <div class="form-group">
                                    <label class="label" for="notes">
                                        <i class="ph ph-note mr-1"></i> Motif de la visite (optionnel)
                                    </label>
                                    <textarea name="notes" id="notes" class="input" rows="3" 
                                              placeholder="Décrivez brièvement le motif de votre rendez-vous..."></textarea>
                                </div>
                                
                                <%-- Payment Method Selection --%>
                                <div class="payment-section" style="margin: 1.5rem 0; padding: 1.5rem; background: white; border-radius: var(--radius-lg); border: 1px solid var(--gray-200);">
                                    <h4 style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                                        <i class="ph ph-wallet" style="color: var(--primary);"></i> Méthode de Paiement
                                    </h4>
                                    
                                    <div class="payment-options" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                                        <label class="payment-option" style="cursor: pointer; padding: 1rem; border: 2px solid var(--gray-200); border-radius: var(--radius-lg); display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.5rem; transition: all 0.2s;">
                                            <input type="radio" name="paymentMethod" value="in_office" checked style="display: none;" onchange="updatePaymentSelection(this)">
                                            <i class="ph ph-buildings" style="font-size: 2rem; color: var(--gray-500);"></i>
                                            <span style="font-weight: 600;">Payer au Cabinet</span>
                                            <small style="color: var(--gray-500);">Payez à votre arrivée</small>
                                        </label>
                                        
                                        <label class="payment-option" style="cursor: pointer; padding: 1rem; border: 2px solid var(--gray-200); border-radius: var(--radius-lg); display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.5rem; transition: all 0.2s;">
                                            <input type="radio" name="paymentMethod" value="online" style="display: none;" onchange="updatePaymentSelection(this)">
                                            <i class="ph ph-credit-card" style="font-size: 2rem; color: var(--gray-500);"></i>
                                            <span style="font-weight: 600;">Payer en Ligne Maintenant</span>
                                            <small style="color: var(--gray-500);">Paiement sécurisé</small>
                                        </label>
                                    </div>
                                    
                                    <div class="price-display" style="display: flex; justify-content: space-between; align-items: center; padding-top: 1rem; border-top: 1px solid var(--gray-200);">
                                        <span style="color: var(--gray-600);">Frais de Consultation :</span>
                                        <div style="text-align: right;">
                                            <strong style="font-size: 1.25rem; color: var(--primary);">
                                                <%= profile != null && profile.getPrice() != null ? profile.getPrice() : "50.00" %> DNT
                                            </strong>
                                            <input type="hidden" name="amount" value="<%= profile != null && profile.getPrice() != null ? profile.getPrice() : "50.00" %>">
                                        </div>
                                    </div>
                                </div>
                                
                                <style>
                                    .payment-option:has(input:checked) {
                                        border-color: var(--primary);
                                        background: var(--primary-50);
                                    }
                                    .payment-option:has(input:checked) i {
                                        color: var(--primary) !important;
                                    }
                                </style>
                                
                                <script>
                                    function updatePaymentSelection(radio) {
                                        // Visual update handled by CSS :has selector
                                        const btnText = 'Demander un Rendez-vous';
                                        const btnIcon = radio.value === 'online' ? 'ph-credit-card' : 'ph-paper-plane-right';
                                        
                                        const submitBtn = document.getElementById('submitBtn');
                                        submitBtn.innerHTML = '<i class="ph ' + btnIcon + '"></i> ' + btnText;
                                    }
                                </script>
                                
                                <button type="submit" class="btn btn-primary" id="submitBtn" disabled style="width: 100%; justify-content: center;">
                                    <i class="ph ph-paper-plane-right"></i>
                                    Demander un Rendez-vous
                                </button>
                            </form>
                        <% } else { %>
                            <div class="empty-slots">
                                <i class="ph ph-calendar-x"></i>
                                <h4>Aucun Créneau Disponible</h4>
                                <p>Votre nutritionniste n'a pas encore défini ses disponibilités.</p>
                                <p style="font-size: 0.875rem; margin-top: 0.5rem;">
                                    Veuillez vérifier plus tard ou contacter le secrétaire directement.
                                </p>
                            </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        let selectedSlot = null;
        
        function selectSlot(btn, slotValue) {
            // Remove selection from all buttons
            document.querySelectorAll('.slot-btn').forEach(b => b.classList.remove('selected'));
            
            // Select this button
            btn.classList.add('selected');
            selectedSlot = slotValue;
            
            // Update hidden input
            document.getElementById('selectedSlotInput').value = slotValue;
            
            // Show selected slot display
            const display = document.getElementById('selectedSlotDisplay');
            display.classList.add('show');
            document.getElementById('selectedSlotText').textContent = btn.textContent.trim();
            
            // Enable submit button
            document.getElementById('submitBtn').disabled = false;
        }
    </script>
</body>
</html>
