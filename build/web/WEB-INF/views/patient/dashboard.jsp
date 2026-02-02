<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.nutrit.models.Appointment" %>
        <%@ page import="com.nutrit.models.PatientMealPlan" %>
            <%@ page import="com.nutrit.models.DailyProgress" %>
                <%@ page import="com.nutrit.models.PatientProfile" %>
                    <%@ page import="com.nutrit.models.MealTracking" %>
                        <%@ page import="java.util.Map" %>
                            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                                <!DOCTYPE html>
                                <html lang="fr">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Tableau de Bord Patient - Nutrit</title>
                                    <meta name="description"
                                        content="Suivez votre parcours nutritionnel, consultez votre plan alimentaire et gérez vos rendez-vous avec votre nutritionniste.">
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                        rel="stylesheet">
                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/assets/css/style.css">
                                    <script src="https://unpkg.com/@phosphor-icons/web"></script>
                                    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
                                    <style>
                                        .diet-item {
                                            display: flex;
                                            align-items: flex-start;
                                            justify-content: space-between;
                                            padding: 1rem;
                                            border-radius: var(--radius-lg);
                                            background: var(--gray-50);
                                            margin-bottom: 0.75rem;
                                            transition: all var(--transition-fast);
                                            flex-wrap: wrap;
                                            gap: 0.75rem;
                                        }

                                        .diet-item:hover {
                                            background: var(--gray-100);
                                        }

                                        .diet-item:last-child {
                                            margin-bottom: 0;
                                        }

                                        .diet-item.completed {
                                            background: linear-gradient(135deg, #D1FAE5, #ECFDF5);
                                            border-left: 4px solid var(--success);
                                        }

                                        .diet-item.not-completed {
                                            background: linear-gradient(135deg, #FEE2E2, #FEF2F2);
                                            border-left: 4px solid var(--error);
                                        }

                                        .diet-meal {
                                            display: flex;
                                            align-items: center;
                                            gap: 1rem;
                                            flex: 1;
                                            min-width: 200px;
                                        }

                                        .meal-icon {
                                            width: 44px;
                                            height: 44px;
                                            border-radius: var(--radius-lg);
                                            display: flex;
                                            align-items: center;
                                            justify-content: center;
                                            font-size: 1.25rem;
                                            flex-shrink: 0;
                                        }

                                        .meal-icon.breakfast {
                                            background: linear-gradient(135deg, #FEF3C7, #FFFBEB);
                                            color: #D97706;
                                        }

                                        .meal-icon.lunch {
                                            background: linear-gradient(135deg, #D1FAE5, #ECFDF5);
                                            color: #059669;
                                        }

                                        .meal-icon.dinner {
                                            background: linear-gradient(135deg, #E0E7FF, #EEF2FF);
                                            color: #4F46E5;
                                        }

                                        .meal-icon.snacks {
                                            background: linear-gradient(135deg, #FCE7F3, #FDF2F8);
                                            color: #DB2777;
                                        }

                                        .meal-label {
                                            font-size: 0.75rem;
                                            text-transform: uppercase;
                                            letter-spacing: 0.05em;
                                            color: var(--gray-500);
                                            font-weight: 600;
                                        }

                                        .meal-name {
                                            font-weight: 500;
                                            color: var(--gray-800);
                                        }

                                        .meal-tracking {
                                            display: flex;
                                            align-items: center;
                                            gap: 0.5rem;
                                            flex-shrink: 0;
                                        }

                                        .tracking-btn {
                                            padding: 0.5rem 1rem;
                                            border-radius: var(--radius-md);
                                            border: 2px solid transparent; /* Prepare for border */
                                            cursor: pointer;
                                            font-size: 0.75rem;
                                            font-weight: 600;
                                            transition: all var(--transition-fast);
                                            display: flex;
                                            align-items: center;
                                            gap: 0.25rem;
                                            background: var(--gray-100);
                                            color: var(--gray-600);
                                        }

                                        .tracking-btn:hover {
                                            background: var(--gray-200);
                                        }

                                        /* Done Button State */
                                        .tracking-btn.done.active {
                                            background: var(--success);
                                            color: white;
                                            border-color: var(--success);
                                        }
                                        .tracking-btn.done:not(.active):hover {
                                            color: var(--success);
                                            background: #ecfdf5; /* primary-50 */
                                            border-color: var(--success);
                                        }

                                        /* Missed Button State */
                                        .tracking-btn.missed.active {
                                            background: var(--error);
                                            color: white;
                                            border-color: var(--error);
                                        }
                                        .tracking-btn.missed:not(.active):hover {
                                            color: var(--error);
                                            background: #fef2f2; /* error-light */
                                            border-color: var(--error);
                                        }

                                        .alternative-input {
                                            width: 100%;
                                            margin-top: 0.5rem;
                                            padding: 0.75rem;
                                            border: 1px solid var(--gray-300);
                                            border-radius: var(--radius-md);
                                            font-size: 0.875rem;
                                            display: none;
                                        }

                                        .alternative-input.show {
                                            display: block;
                                        }

                                        .alternative-display {
                                            width: 100%;
                                            margin-top: 0.5rem;
                                            padding: 0.75rem;
                                            background: rgba(239, 68, 68, 0.1);
                                            border-radius: var(--radius-md);
                                            font-size: 0.875rem;
                                            color: var(--error);
                                        }

                                        .alternative-display strong {
                                            color: var(--gray-700);
                                        }

                                        .status-badge {
                                            font-size: 0.7rem;
                                            padding: 0.25rem 0.5rem;
                                            border-radius: var(--radius-full);
                                            font-weight: 600;
                                        }

                                        .status-badge.done {
                                            background: var(--success);
                                            color: white;
                                        }

                                        .status-badge.missed {
                                            background: var(--error);
                                            color: white;
                                        }

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
                                            max-width: 500px;
                                            width: 90%;
                                            max-height: 90vh;
                                            overflow-y: auto;
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

.form-row {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1.25rem;
    margin-bottom: 1.5rem;
    align-items: start;
}

/* Optional: make inputs look better inside the row */
.form-row .form-group {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
}

.form-group input{
        padding: 0.6rem 0.75rem;
    border-radius: 8px;
    border: 1px solid #d1d5db;
    font-size: 0.9rem;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.form-row label {
    font-size: 0.85rem;
    font-weight: 500;
    color: #374151; /* soft dark gray */
}

.form-row input,
.form-row select,
.form-row textarea {
    padding: 0.6rem 0.75rem;
    border-radius: 8px;
    border: 1px solid #d1d5db;
    font-size: 0.9rem;
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.form-row input:focus,
.form-row select:focus,
.form-row textarea:focus {
    outline: none;
    border-color: #22c55e; /* Nutrit green */
    box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.15);
}

/* Responsive: stack on small screens */
@media (max-width: 640px) {
    .form-row {
        grid-template-columns: 1fr;
    }
}


                                        .compliance-card {
                                            background: linear-gradient(135deg, var(--primary), var(--secondary));
                                            color: white;
                                            border-radius: var(--radius-xl);
                                            padding: 1.5rem;
                                            margin-bottom: 1.5rem;
                                        }

                                        .compliance-rate {
                                            font-size: 2.5rem;
                                            font-weight: 700;
                                        }

                                        .compliance-bar {
                                            height: 8px;
                                            background: rgba(255, 255, 255, 0.3);
                                            border-radius: 4px;
                                            overflow: hidden;
                                            margin-top: 1rem;
                                        }

                                        .compliance-fill {
                                            height: 100%;
                                            background: white;
                                            border-radius: 4px;
                                            transition: width 0.5s ease;
                                        }

                                        .health-stats-grid {
                                            display: grid;
                                            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
                                            gap: 1rem;
                                            margin-top: 1rem;
                                        }

                                        .health-stat {
                                            background: var(--gray-50);
                                            padding: 1rem;
                                            border-radius: var(--radius-lg);
                                            text-align: center;
                                        }

                                        .health-stat-value {
                                            font-size: 1.5rem;
                                            font-weight: 700;
                                            color: var(--primary);
                                        }

                                        .health-stat-label {
                                            font-size: 0.75rem;
                                            color: var(--gray-500);
                                            margin-top: 0.25rem;
                                        }

                                        @media (max-width: 768px) {
                                            .form-row {
                                                grid-template-columns: 1fr;
                                            }
                                            .compliance-rate {
                                                font-size: 1.75rem;
                                            }
                                            .page-header h1 {
                                                font-size: 1.5rem;
                                            }
                                            .health-stats-grid {
                                                grid-template-columns: 1fr 1fr;
                                            }
                                        }
                                        @media (max-width: 480px) {
                                            .health-stats-grid {
                                                grid-template-columns: 1fr;
                                            }
                                            .modal-content {
                                                padding: 1.25rem;
                                            }
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
                                                    <h1>Mon Tableau de Bord Santé</h1>
                                                    <p>Suivez vos progrès et restez concentré sur vos objectifs nutritionnels.</p>
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

                                                <!-- Stats Grid -->
                                                <div class="stats-grid">
                                                    <% Appointment nextAppt=(Appointment)
                                                        request.getAttribute("nextAppointment"); %>
                                                        <div class="card stat-card animate-fade-in">
                                                            <div class="stat-icon"><i class="ph ph-calendar"></i></div>
                                                            <% if (nextAppt !=null) { %>
                                                                <div class="stat-value" style="font-size: 1.25rem;">
                                                                    <%= new
                                                                        java.text.SimpleDateFormat("MMM,dd,yyyy").format(nextAppt.getScheduledTime())
                                                                        %>
                                                                        <div
                                                                            style="font-size: 0.875rem; color: var(--primary); font-weight: 500;">
                                                                            at <%= new
                                                                                java.text.SimpleDateFormat("HH:mm").format(nextAppt.getScheduledTime())
                                                                                %>
                                                                        </div>
                                                                </div>
                                                                <div class="stat-label">Prochain Rendez-vous</div>
                                                                <div class="stat-change positive" style="display: flex; align-items: center; gap: 0.5rem;">
                                                                    <% if (nextAppt.getNutritionistProfilePicture() != null && !nextAppt.getNutritionistProfilePicture().isEmpty()) { %>
                                                                        <img src="${pageContext.request.contextPath}/<%= nextAppt.getNutritionistProfilePicture() %>" 
                                                                             style="width: 20px; height: 20px; border-radius: 50%; object-fit: cover;">
                                                                    <% } else { %>
                                                                        <i class="ph ph-user"></i>
                                                                    <% } %>
                                                                    avec Dr. <%= nextAppt.getNutritionistName() !=null ? nextAppt.getNutritionistName() : "Inconnu" %>
                                                                </div>
                                                                <% if (nextAppt.getNotes() != null && !nextAppt.getNotes().isEmpty()) { %>
                                                                    <div style="font-size: 0.75rem; color: var(--gray-500); margin-top: 0.5rem; padding-top: 0.5rem; border-top: 1px solid var(--gray-100);">
                                                                        <i class="ph ph-note-pencil mr-1"></i> <%= nextAppt.getNotes() %>
                                                                    </div>
                                                                <% } %>
                                                                <% } else { %>
                                                                    <div class="stat-value">Aucun prévu</div>
                                                                    <div class="stat-label">Prochain Rendez-vous</div>
                                                                    <a href="${pageContext.request.contextPath}/patient/bookAppointment" 
                                                                       style="display: inline-flex; align-items: center; gap: 0.25rem; margin-top: 0.5rem; padding: 0.4rem 0.75rem; background: var(--primary); color: white; border-radius: var(--radius-md); font-size: 0.75rem; font-weight: 500; text-decoration: none;">
                                                                        <i class="ph ph-calendar-plus"></i> Prendre RDV
                                                                    </a>
                                                                    <% } %>
                                                        </div>

                                                        <% DailyProgress progress=(DailyProgress)
                                                            request.getAttribute("latestProgress"); %>
                                                            <% PatientProfile healthProfile=(PatientProfile)
                                                                request.getAttribute("healthProfile"); %>
                                                                <div class="card stat-card animate-fade-in"
                                                                    style="animation-delay: 0.1s;">
                                                                    <div class="stat-icon"
                                                                        style="background: linear-gradient(135deg, #D1FAE5, #ECFDF5); color: #059669;">
                                                                        <i class="ph ph-scales"></i>
                                                                    </div>
                                                                    <% if (progress !=null && progress.getWeight()> 0) {
                                                                        %>
                                                                        <div class="stat-value">
                                                                            <%= progress.getWeight() %> <span
                                                                                    style="font-size: 1rem; font-weight: 500;">kg</span>
                                                                        </div>
                                                                        <div class="stat-label">Poids Actuel</div>
                                                                        <div class="stat-change positive"><i
                                                                                class="ph ph-calendar-check"></i>
                                                                            Enregistré le <%= progress.getDate() %>
                                                                        </div>
                                                                        <% } else if (healthProfile !=null &&
                                                                            healthProfile.getCurrentWeight() !=null) {
                                                                            %>
                                                                            <div class="stat-value">
                                                                                <%= healthProfile.getCurrentWeight() %>
                                                                                    <span
                                                                                        style="font-size: 1rem; font-weight: 500;">kg</span>
                                                                            </div>
                                                                            <div class="stat-label">Poids Actuel</div>
                                                                            <div class="stat-change"
                                                                                style="color: var(--info);"><i
                                                                                    class="ph ph-info"></i> Depuis votre profil</div>
                                                                            <% } else { %>
                                                                                <div class="stat-value">-- <span
                                                                                        style="font-size: 1rem; font-weight: 500;">kg</span>
                                                                                </div>
                                                                                <div class="stat-label">Poids Actuel
                                                                                </div>
                                                                                <div class="stat-change"
                                                                                    style="color: var(--warning);"><i
                                                                                        class="ph ph-pencil-simple"></i>
                                                                                    Aucune donnée</div>
                                                                                <% } %>
                                                                </div>

                                                                <div class="card stat-card animate-fade-in"
                                                                    style="animation-delay: 0.15s;">
                                                                    <div class="stat-icon"
                                                                        style="background: linear-gradient(135deg, #DBEAFE, #EFF6FF); color: #3B82F6;">
                                                                        <i class="ph ph-target"></i>
                                                                    </div>
                                                                    <% if (healthProfile !=null &&
                                                                        healthProfile.getTargetWeight() !=null) { %>
                                                                        <div class="stat-value">
                                                                            <%= healthProfile.getTargetWeight() %> <span
                                                                                    style="font-size: 1rem; font-weight: 500;">kg</span>
                                                                        </div>
                                                                        <div class="stat-label">Poids Cible</div>
                                                                        <% double currentWt=0; if (progress !=null &&
                                                                            progress.getWeight()> 0) currentWt =
                                                                            progress.getWeight();
                                                                            else if (healthProfile.getCurrentWeight() !=
                                                                            null) currentWt =
                                                                            healthProfile.getCurrentWeight().doubleValue();
                                                                            double targetWt =
                                                                            healthProfile.getTargetWeight().doubleValue();
                                                                            double diff = Math.abs(currentWt -
                                                                            targetWt);
                                                                            %>
                                                                            <div class="stat-change <%= currentWt <= targetWt ? "positive" : "" %>">
                                                                                <i class="ph ph-arrow-<%= currentWt > targetWt ? "down" : "up" %>"></i>
                                                                                <%= String.format("%.1f", diff) %> kg restants
                                                                            </div>
                                                                            <% } else { %>
                                                                                <div class="stat-value">-- <span
                                                                                        style="font-size: 1rem; font-weight: 500;">kg</span>
                                                                                </div>
                                                                                <div class="stat-label">Poids Cible
                                                                                </div>
                                                                                <div class="stat-change"
                                                                                    style="color: var(--warning);"><i
                                                                                        class="ph ph-pencil-simple"></i>
                                                                                    Définir l'objectif</div>
                                                                                <% } %>
                                                                </div>

                                                                <div class="card stat-card animate-fade-in"
                                                                    style="animation-delay: 0.2s;">
                                                                    <div class="stat-icon"
                                                                        style="background: linear-gradient(135deg, #CFFAFE, #ECFEFF); color: #0891B2;">
                                                                        <i class="ph ph-drop"></i>
                                                                    </div>
                                                                    <% if (progress !=null && progress.getWaterIntake()>
                                                                        0) { %>
                                                                        <div class="stat-value">
                                                                            <%= progress.getWaterIntake() %> <span
                                                                                    style="font-size: 1rem; font-weight: 500;">verres</span>
                                                                        </div>
                                                                        <div class="stat-label">Eau Aujourd'hui</div>
                                                                    <div class="stat-change positive"><i
                                                                            class="ph ph-check-circle"></i> Continuez
                                                                        ainsi !</div>
                                                                    <% } else { %>
                                                                        <div class="stat-value">0 <span
                                                                                style="font-size: 1rem; font-weight: 500;">verres</span>
                                                                        </div>
                                                                        <div class="stat-label">Eau Aujourd'hui</div>
                                                                        <div class="stat-change"
                                                                            style="color: var(--warning);"><i
                                                                                class="ph ph-warning"></i> Enregistrez
                                                                            votre consommation</div>
                                                                        <% } %>
                                                                </div>
                                                </div>

                                                <!-- Content Grid -->
                                                <div class="content-grid">

                                                    <!-- Progress Charts Section -->
                                                    <div class="card animate-fade-in"
                                                        style="margin-bottom: 2rem; animation-delay: 0.2s; grid-column: 1 / -1;">
                                                        <div class="card-header"
                                                            style="display: flex; justify-content: space-between; align-items: center;">
                                                            <h3><i class="ph ph-chart-line-up mr-2"
                                                                    style="color: var(--primary);"></i> Vos Progrès
                                                            </h3>
                                                        </div>
                                                        <div
                                                            style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem;">
                                                            <div style="min-height: 350px; background: white; padding: 1rem; border-radius: var(--radius-lg); border: 1px solid var(--gray-100);">
                                                                <div id="weightChart"></div>
                                                            </div>
                                                            <div style="min-height: 350px; background: white; padding: 1rem; border-radius: var(--radius-lg); border: 1px solid var(--gray-100);">
                                                                <div id="waterChart"></div>
                                                            </div>
                                                             <div style="min-height: 350px; background: white; padding: 1rem; border-radius: var(--radius-lg); border: 1px solid var(--gray-100);">
                                                                <div id="caloriesChart"></div>
                                                            </div>
                                                        </div>

                                                        <!-- Table of recent records -->
                                                        <div style="margin-top: 2rem;">
                                                            <h4
                                                                style="margin-bottom: 1rem; font-size: 1rem; font-weight: 600;">
                                                                Historique Récent</h4>
                                                            <div style="overflow-x: auto;">
                                                                <table
                                                                    style="width: 100%; border-collapse: collapse; font-size: 0.875rem;">
                                                                    <thead>
                                                                        <tr
                                                                            style="border-bottom: 2px solid var(--gray-100);">
                                                                            <th
                                                                                style="text-align: left; padding: 0.75rem;">
                                                                                Date</th>
                                                                            <th
                                                                                style="text-align: left; padding: 0.75rem;">
                                                                                Poids (kg)</th>
                                                                            <th
                                                                                style="text-align: left; padding: 0.75rem;">
                                                                                Eau (verres)</th>
                                                                            <th
                                                                                style="text-align: left; padding: 0.75rem;">
                                                                                Calories</th>
                                                                            <th
                                                                                style="text-align: left; padding: 0.75rem;">
                                                                                Notes</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:forEach var="record"
                                                                            items="${progressHistory}" end="9">
                                                                            <tr
                                                                                style="border-bottom: 1px solid var(--gray-100);">
                                                                                <td style="padding: 0.75rem;">
                                                                                    ${record.date}</td>
                                                                                <td style="padding: 0.75rem;">
                                                                                    ${record.weight > 0 ? record.weight
                                                                                    : '-'}</td>
                                                                                <td style="padding: 0.75rem;">
                                                                                    ${record.waterIntake}</td>
                                                                                <td style="padding: 0.75rem;">
                                                                                    ${record.caloriesConsumed > 0 ?
                                                                                    record.caloriesConsumed : '-'}</td>
                                                                                <td
                                                                                    style="padding: 0.75rem; color: var(--text-light);">
                                                                                    ${record.notes != null ?
                                                                                    record.notes : ''}</td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                        <c:if test="${empty progressHistory}">
                                                                            <tr>
                                                                                <td colspan="5"
                                                                                    style="padding: 1rem; text-align: center; color: var(--text-light);">
                                                                                    Aucun enregistrement trouvé.</td>
                                                                            </tr>
                                                                        </c:if>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <%-- DietPlan diet=(DietPlan) request.getAttribute("todayDiet"); --%>
                                                        <% Map<String, MealTracking> mealTracking = (Map<String,
                                                                MealTracking>) request.getAttribute("mealTracking"); %>
                                                                <div class="card animate-fade-in"
                                                                    style="animation-delay: 0.25s;">
                                                                    <div
                                                                        class="card-header flex items-center justify-between">
                                                                        <h3><i class="ph ph-fork-knife mr-2"
                                                                                style="color: var(--primary);"></i>
                                                                            Plan Alimentaire du Jour</h3>
                                                                        <span class="text-sm text-muted">
                                                                            <%= new java.text.SimpleDateFormat("EEEE d MMMM", java.util.Locale.FRENCH).format(new java.util.Date()) %>
                                                                        </span>
                                                                    </div>

                                                                    <% PatientMealPlan mealPlan = (PatientMealPlan) request.getAttribute("mealPlan"); %>
                                                                    <% if (mealPlan !=null) { %>
                                                                    <c:if test="${not empty mealPlan.mealItems['morning']}">
                                                                        <!-- Breakfast -->
                                                                        <% MealTracking breakfastTracking=mealTracking
                                                                            !=null ? mealTracking.get("morning") :
                                                                            null; boolean
                                                                            breakfastCompleted=breakfastTracking !=null
                                                                            && breakfastTracking.isCompleted(); boolean
                                                                            breakfastTracked=breakfastTracking !=null;
                                                                            %>
                                                                        <div class="diet-item <%= breakfastTracked ? (breakfastCompleted ? "    completed" : "not-completed" ) : "" %>"
                                                                            id="meal-breakfast">
                                                                            <div class="diet-meal">
                                                                                <div class="meal-icon breakfast"><i
                                                                                        class="ph ph-sun-horizon"></i>
                                                                                </div>
                                                                                <div>
                                                                                    <div class="meal-label">
                                                                                        Petit Déjeuner</div>
                                                                                    <div class="meal-name">
                                                                                        <c:forEach var="item" items="${mealPlan.mealItems['morning']}">
                                                                                            <div style="margin-bottom: 4px;">
                                                                                                <span>${item.quantity1}g ${item.foodItem1.name}</span>
                                                                                                <c:if test="${not empty item.foodItem2}">
                                                                                                    <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                        ou ${item.quantity2}g ${item.foodItem2.name}
                                                                                                    </div>
                                                                                                </c:if>
                                                                                                <c:if test="${not empty item.foodItem3}">
                                                                                                    <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                        ou ${item.quantity3}g ${item.foodItem3.name}
                                                                                                    </div>
                                                                                                </c:if>
                                                                                            </div>
                                                                                        </c:forEach>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="meal-tracking">
                                                                                <button class="tracking-btn done <%= breakfastTracked && breakfastCompleted ? "active" : "" %>" 
                                                                                    onclick="trackMeal(<%= mealPlan.getId() %>, 'breakfast', true)"
                                                                                    <%= breakfastTracked ? "disabled" : "" %>>
                                                                                    <i class="ph ph-check"></i> Fait
                                                                                </button>
                                                                                <button class="tracking-btn missed <%= breakfastTracked && !breakfastCompleted ? "active" : "" %>" 
                                                                                    onclick="showAlternativeInput('breakfast', <%= mealPlan.getId() %>)"
                                                                                    <%= breakfastTracked ? "disabled" : "" %>>
                                                                                    <i class="ph ph-x"></i> Pas mangé
                                                                                </button>
                                                                            </div>
                                                                            <% if (breakfastTracking !=null &&
                                                                                !breakfastCompleted &&
                                                                                breakfastTracking.getAlternativeMeal()
                                                                                !=null) { %>
                                                                                <div class="alternative-display">
                                                                                    <strong>Ce que j'ai mangé
                                                                                        à la place :</strong>
                                                                                    <%= breakfastTracking.getAlternativeMeal()
                                                                                        %>
                                                                                </div>
                                                                                <% } %>
                                                                                    <input type="text"
                                                                                        class="alternative-input"
                                                                                        id="alt-breakfast"
                                                                                        placeholder="Qu'avez-vous mangé à la place ?"
                                                                                        onkeypress="if(event.key==='Enter') submitAlternative('breakfast', <%= mealPlan.getId() %>)">
                                                                        </div>
                                                                    </c:if>

                                                                    <c:if test="${not empty mealPlan.mealItems['noon']}">
                                                                        <!-- Lunch -->
                                                                        <% MealTracking lunchTracking=mealTracking
                                                                            !=null ? mealTracking.get("noon") :
                                                                            null; boolean
                                                                            lunchCompleted=lunchTracking !=null &&
                                                                            lunchTracking.isCompleted(); boolean
                                                                            lunchTracked=lunchTracking !=null; %>
                                                                        <div class="diet-item <%= lunchTracked ? (lunchCompleted ? "completed" : "not-completed" ) : ""
                                                                            %>" id="meal-lunch">
                                                                            <div class="diet-meal">
                                                                                <div class="meal-icon lunch"><i
                                                                                        class="ph ph-sun"></i>
                                                                                </div>
                                                                                <div>
                                                                                    <div class="meal-label">
                                                                                        Déjeuner</div>
                                                                                    <div class="meal-name">
                                                                                        <c:forEach var="item" items="${mealPlan.mealItems['noon']}">
                                                                                            <div style="margin-bottom: 4px;">
                                                                                                <span>${item.quantity1}g ${item.foodItem1.name}</span>
                                                                                                <c:if test="${not empty item.foodItem2}">
                                                                                                    <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                        ou ${item.quantity2}g ${item.foodItem2.name}
                                                                                                    </div>
                                                                                                </c:if>
                                                                                                <c:if test="${not empty item.foodItem3}">
                                                                                                    <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                        ou ${item.quantity3}g ${item.foodItem3.name}
                                                                                                    </div>
                                                                                                </c:if>
                                                                                            </div>
                                                                                        </c:forEach>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="meal-tracking">
                                                                                <button class="tracking-btn done <%= lunchTracked && lunchCompleted ? "active" : "" %>" 
                                                                                    onclick="trackMeal(<%= mealPlan.getId() %>, 'lunch', true)"
                                                                                    <%= lunchTracked ? "disabled" : "" %>>
                                                                                    <i class="ph ph-check"></i> Fait
                                                                                </button>
                                                                                <button class="tracking-btn missed <%= lunchTracked && !lunchCompleted ? "active" : "" %>" 
                                                                                    onclick="showAlternativeInput('lunch', <%= mealPlan.getId() %>)"
                                                                                    <%= lunchTracked ? "disabled" : "" %>>
                                                                                    <i class="ph ph-x"></i> Pas mangé
                                                                                </button>
                                                                            </div>
                                                                            <% if (lunchTracking !=null &&
                                                                                !lunchCompleted &&
                                                                                lunchTracking.getAlternativeMeal()
                                                                                !=null) { %>
                                                                                <div
                                                                                    class="alternative-display">
                                                                                    <strong>Ce que j'ai mangé
                                                                                        à la place :</strong>
                                                                                    <%= lunchTracking.getAlternativeMeal()
                                                                                        %>
                                                                                </div>
                                                                                <% } %>
                                                                                    <input type="text"
                                                                                        class="alternative-input"
                                                                                        id="alt-lunch"
                                                                                        placeholder="Qu'avez-vous mangé à la place ?"
                                                                                        onkeypress="if(event.key==='Enter') submitAlternative('lunch', <%= mealPlan.getId() %>)">
                                                                        </div>
                                                                    </c:if>

                                                                    <c:if test="${not empty mealPlan.mealItems['night']}">
                                                                        <!-- Dinner -->
                                                                        <% MealTracking
                                                                            dinnerTracking=mealTracking !=null ?
                                                                            mealTracking.get("night") : null;
                                                                            boolean
                                                                            dinnerCompleted=dinnerTracking
                                                                            !=null &&
                                                                            dinnerTracking.isCompleted();
                                                                            boolean dinnerTracked=dinnerTracking
                                                                            !=null; %>
                                                                        <div class="diet-item <%= dinnerTracked ? (dinnerCompleted ? "completed" : "not-completed" )
                                                                            : "" %>" id="meal-dinner">
                                                                            <div class="diet-meal">
                                                                                <div
                                                                                    class="meal-icon dinner">
                                                                                    <i
                                                                                        class="ph ph-moon-stars"></i>
                                                                                </div>
                                                                                <div>
                                                                                    <div class="meal-label">
                                                                                        Dîner</div>
                                                                                    <div class="meal-name">
                                                                                        <c:forEach var="item" items="${mealPlan.mealItems['night']}">
                                                                                            <div style="margin-bottom: 4px;">
                                                                                                <span>${item.quantity1}g ${item.foodItem1.name}</span>
                                                                                                <c:if test="${not empty item.foodItem2}">
                                                                                                    <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                        ou ${item.quantity2}g ${item.foodItem2.name}
                                                                                                    </div>
                                                                                                </c:if>
                                                                                                <c:if test="${not empty item.foodItem3}">
                                                                                                    <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                        ou ${item.quantity3}g ${item.foodItem3.name}
                                                                                                    </div>
                                                                                                </c:if>
                                                                                            </div>
                                                                                        </c:forEach>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="meal-tracking">
                                                                                <button class="tracking-btn done <%= dinnerTracked && dinnerCompleted ? "active" : "" %>" 
                                                                                    onclick="trackMeal(<%= mealPlan.getId() %>, 'dinner', true)"
                                                                                    <%= dinnerTracked ? "disabled" : "" %>>
                                                                                    <i class="ph ph-check"></i> Fait
                                                                                </button>
                                                                                <button class="tracking-btn missed <%= dinnerTracked && !dinnerCompleted ? "active" : "" %>" 
                                                                                    onclick="showAlternativeInput('dinner', <%= mealPlan.getId() %>)"
                                                                                    <%= dinnerTracked ? "disabled" : "" %>>
                                                                                    <i class="ph ph-x"></i> Pas mangé
                                                                                </button>
                                                                            </div>
                                                                            <% if (dinnerTracking !=null &&
                                                                                !dinnerCompleted &&
                                                                                dinnerTracking.getAlternativeMeal()
                                                                                !=null) { %>
                                                                                <div
                                                                                    class="alternative-display">
                                                                                    <strong>Ce que j'ai mangé
                                                                                        à la place :</strong>
                                                                                    <%= dinnerTracking.getAlternativeMeal()
                                                                                        %>
                                                                                </div>
                                                                                <% } %>
                                                                                    <input type="text"
                                                                                        class="alternative-input"
                                                                                        id="alt-dinner"
                                                                                        placeholder="Qu'avez-vous mangé à la place ?"
                                                                                        onkeypress="if(event.key==='Enter') submitAlternative('dinner', <%= mealPlan.getId() %>)">
                                                                        </div>
                                                                    </c:if>

                                                                                    <!-- Snacks -->
                                                                                    <% if (mealPlan.getMealItems().get("snacks") != null && !mealPlan.getMealItems().get("snacks").isEmpty()) { %>
                                                                                        <% MealTracking
                                                                                            snacksTracking=mealTracking
                                                                                            !=null ?
                                                                                            mealTracking.get("snacks") :
                                                                                            null; boolean
                                                                                            snacksCompleted=snacksTracking
                                                                                            !=null &&
                                                                                            snacksTracking.isCompleted();
                                                                                            boolean
                                                                                            snacksTracked=snacksTracking
                                                                                            !=null; %>
                                                                                            <div class="diet-item <%= snacksTracked ? (snacksCompleted ? "completed"
                                                                                                : "not-completed" ) : ""
                                                                                                %>" id="meal-snacks">
                                                                                                <div class="diet-meal">
                                                                                                    <div
                                                                                                        class="meal-icon snacks">
                                                                                                        <i
                                                                                                            class="ph ph-cookie"></i>
                                                                                                    </div>
                                                                                                    <div>
                                                                                                        <div
                                                                                                            class="meal-label">
                                                                                                            Collations</div>
                                                                                                        <div
                                                                                                            class="meal-name">
                                                                                                            <c:forEach var="item" items="${mealPlan.mealItems['snacks']}">
                                                                                                                <div style="margin-bottom: 4px;">
                                                                                                                    <span>${item.quantity1}g ${item.foodItem1.name}</span>
                                                                                                                    <c:if test="${not empty item.foodItem2}">
                                                                                                                        <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                                            ou ${item.quantity2}g ${item.foodItem2.name}
                                                                                                                        </div>
                                                                                                                    </c:if>
                                                                                                                    <c:if test="${not empty item.foodItem3}">
                                                                                                                        <div style="font-size: 0.85em; color: #6b7280; margin-left: 0.5rem;">
                                                                                                                            ou ${item.quantity3}g ${item.foodItem3.name}
                                                                                                                        </div>
                                                                                                                    </c:if>
                                                                                                                </div>
                                                                                                            </c:forEach>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                                    <div class="meal-tracking">
                                                                                                        <button class="tracking-btn done <%= snacksTracked && snacksCompleted ? "active" : "" %>" 
                                                                                                            onclick="trackMeal(<%= mealPlan.getId() %>, 'snacks', true)"
                                                                                                            <%= snacksTracked ? "disabled" : "" %>>
                                                                                                            <i class="ph ph-check"></i> Fait
                                                                                                        </button>
                                                                                                        <button class="tracking-btn missed <%= snacksTracked && !snacksCompleted ? "active" : "" %>" 
                                                                                                            onclick="showAlternativeInput('snacks', <%= mealPlan.getId() %>)"
                                                                                                            <%= snacksTracked ? "disabled" : "" %>>
                                                                                                            <i class="ph ph-x"></i> Sauté
                                                                                                        </button>
                                                                                                    </div>
                                                                                                <% if (snacksTracking
                                                                                                    !=null &&
                                                                                                    !snacksCompleted &&
                                                                                                    snacksTracking.getAlternativeMeal()
                                                                                                    !=null) { %>
                                                                                                    <div
                                                                                                        class="alternative-display">
                                                                                                        <strong>Ce que j'ai
                                                                                                            mangé
                                                                                                            à la place :</strong>
                                                                                                        <%= snacksTracking.getAlternativeMeal()
                                                                                                            %>
                                                                                                    </div>
                                                                                                    <% } %>
                                                                                                        <input
                                                                                                            type="text"
                                                                                                            class="alternative-input"
                                                                                                            id="alt-snacks"
                                                                                                            placeholder="Qu'avez-vous mangé à la place ?"
                                                                                                            onkeypress="if(event.key==='Enter') submitAlternative('snacks', <%= mealPlan.getId() %>)">
                                                                                            </div>
                                                                                            <% } %>

                                                                                                <% if (mealPlan.getNotes()
                                                                                                    !=null &&
                                                                                                    !mealPlan.getNotes().isEmpty())
                                                                                                    { %>
                                                                                                    <div
                                                                                                        style="margin-top: 1rem; padding: 1rem; background: var(--gray-50); border-radius: var(--radius-lg);">
                                                                                                        <div
                                                                                                            style="font-size: 0.75rem; color: var(--gray-500); font-weight: 600; margin-bottom: 0.25rem;">
                                                                                                            <i
                                                                                                                class="ph ph-note"></i>
                                                                                                            Notes de
                                                                                                            votre
                                                                                                            nutritionniste
                                                                                                        </div>
                                                                                                        <div
                                                                                                            style="font-size: 0.875rem; color: var(--gray-700);">
                                                                                                            <%= mealPlan.getNotes()
                                                                                                                %>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <% } %>

                                                                                                        <% } else { %>
                                                                                                            <div
                                                                                                                class="empty-state">
                                                                                                                <div
                                                                                                                    class="empty-state-icon">
                                                                                                                    <i
                                                                                                                        class="ph ph-bowl-food"></i>
                                                                                                                </div>
                                                                                                                <div
                                                                                                                    class="empty-state-title">
                                                                                                                    Aucun
                                                                                                                    Plan
                                                                                                                    Alimentaire
                                                                                                                </div>
                                                                                                                <div
                                                                                                                    class="empty-state-text">
                                                                                                                    Votre
                                                                                                                    nutritionniste
                                                                                                                    n'a
                                                                                                                    pas
                                                                                                                    encore
                                                                                                                    assigné
                                                                                                                    de
                                                                                                                    plan
                                                                                                                    pour
                                                                                                                    aujourd'hui.
                                                                                                                </div>
                                                                                                                <a href="${pageContext.request.contextPath}/patient/nutritionists"
                                                                                                                    class="btn btn-primary"
                                                                                                                    style="margin-top: 1rem;">
                                                                                                                    <i
                                                                                                                        class="ph ph-stethoscope"></i>
                                                                                                                    Trouver
                                                                                                                    un
                                                                                                                    Nutritionniste
                                                                                                                </a>
                                                                                                            </div>
                                                                                                            <% } %>
                                                                </div>

                                                                <!-- Quick Actions & Health Summary -->
                                                                <div
                                                                    style="display: flex; flex-direction: column; gap: 1.5rem;">
                                                                    <% Map<String, Object> complianceStats = (Map
                                                                        <String, Object>)
                                                                            request.getAttribute("complianceStats"); %>
                                                                            <% if (complianceStats !=null &&
                                                                                complianceStats.get("totalMeals") !=null
                                                                                &&
                                                                                ((Integer)complianceStats.get("totalMeals"))>
                                                                                0) { %>
                                                                                <div class="compliance-card animate-fade-in"
                                                                                    style="animation-delay: 0.3s;color: black;">
                                                                                    <div
                                                                                        style="display: flex; justify-content: space-between; align-items: center;">
                                                                                        <span
                                                                                            style="font-size: 1rem; font-weight: 600; opacity: 0.9;">Respect du
                                                                                            Régime</span>
                                                                                        <i class="ph ph-chart-line"
                                                                                            style="font-size: 1.5rem;"></i>
                                                                                    </div>
                                                                                    <div class="compliance-rate">
                                                                                        <%= complianceStats.get("complianceRate")
                                                                                            %>%
                                                                                    </div>
                                                                                    <div class="compliance-bar">
                                                                                        <div class="compliance-fill"
                                                                                            style="width: <%= complianceStats.get("complianceRate") %>%;">
                                                                                        </div>
                                                                                    </div>
                                                                                    <div
                                                                                        style="display: flex; justify-content: space-between; margin-top: 0.75rem; font-size: 0.875rem; opacity: 0.9;">
                                                                                        <span><i
                                                                                                class="ph ph-check-circle"></i>
                                                                                            <%= complianceStats.get("completedMeals")
                                                                                                %> terminé
                                                                                        </span>
                                                                                        <span><i
                                                                                                class="ph ph-x-circle"></i>
                                                                                            <%= complianceStats.get("missedMeals")
                                                                                                %> manqué
                                                                                        </span>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>

                                                                                    <div class="card animate-fade-in"
                                                                                        style="animation-delay: 0.35s;">
                                                                                        <div class="card-header">
                                                                                            <h3><i class="ph ph-lightning mr-2"
                                                                                                    style="color: var(--primary);"></i>
                                                                                                Actions Rapides</h3>
                                                                                        </div>
                                                                                        <div
                                                                                            style="display: flex; flex-direction: column; gap: 0.75rem;">
                                                                                            <button
                                                                                                class="btn btn-primary w-full"
                                                                                                onclick="openProgressModal()">
                                                                                                <i
                                                                                                    class="ph ph-plus-circle"></i>
                                                                                                Enregistrer le Progrès Journalier
                                                                                            </button>
                                                                                            <a href="${pageContext.request.contextPath}/patient/nutritionists"
                                                                                                class="btn btn-outline w-full">
                                                                                                <i
                                                                                                    class="ph ph-stethoscope"></i>
                                                                                                Trouver des Nutritionnistes
                                                                                            </a>
                                                                                            <a href="${pageContext.request.contextPath}/patient/health-profile"
                                                                                                class="btn btn-outline w-full">
                                                                                                <i
                                                                                                    class="ph ph-user-circle"></i>
                                                                                                Profil Santé
                                                                                            </a>
                                                                                        </div>
                                                                                    </div>

                                                                                    <% if (healthProfile !=null) { %>
                                                                                        <div class="card animate-fade-in"
                                                                                            style="animation-delay: 0.4s;">
                                                                                            <div class="card-header">
                                                                                                <h3><i class="ph ph-heart mr-2"
                                                                                                        style="color: var(--error);"></i>
                                                                                                    Résumé Santé</h3>
                                                                                            </div>
                                                                                            <div
                                                                                                class="health-stats-grid">
                                                                                                <% if
                                                                                                    (healthProfile.getHeight()
                                                                                                    !=null) { %>
                                                                                                    <div
                                                                                                        class="health-stat">
                                                                                                        <div
                                                                                                            class="health-stat-value">
                                                                                                            <%= healthProfile.getHeight()
                                                                                                                %>
                                                                                                        </div>
                                                                                                        <div
                                                                                                            class="health-stat-label">
                                                                                                            Taille (cm)
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <% } %>
                                                                                                        <% if
                                                                                                            (healthProfile.getActivityLevel()
                                                                                                            !=null) { %>
                                                                                                            <div
                                                                                                                class="health-stat">
                                                                                                                <div class="health-stat-value"
                                                                                                                    style="font-size: 1rem;">
                                                                                                                    <%= healthProfile.getActivityLevel().replace("_", " "
                                                                                                                        )
                                                                                                                        %>
                                                                                                                </div>
                                                                                                                <div
                                                                                                                    class="health-stat-label">
                                                                                                                    Niveau
                                                                                                                    d'Activité
                                                                                                                </div>
                                                                                                            </div>
                                                                                                            <% } %>
                                                                                                                <% if
                                                                                                                    (healthProfile.getSleepHours()>
                                                                                                                    0) {
                                                                                                                    %>
                                                                                                                    <div
                                                                                                                        class="health-stat">
                                                                                                                        <div
                                                                                                                            class="health-stat-value">
                                                                                                                            <%= healthProfile.getSleepHours()
                                                                                                                                %>
                                                                                                                                h
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="health-stat-label">
                                                                                                                            Sommeil/Nuit
                                                                                                                        </div>
                                                                                                                    </div>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                                                        <% if
                                                                                                                            (healthProfile.getDailyWaterIntake()>
                                                                                                                            0)
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <div
                                                                                                                                class="health-stat">
                                                                                                                                <div
                                                                                                                                    class="health-stat-value">
                                                                                                                                    <%= healthProfile.getDailyWaterIntake()
                                                                                                                                        %>
                                                                                                                                </div>
                                                                                                                                <div
                                                                                                                                    class="health-stat-label">
                                                                                                                                    Objectif
                                                                                                                                    Eau
                                                                                                                                </div>
                                                                                                                            </div>
                                                                                                                            <% }
                                                                                                                                %>
                                                                                            </div>
                                                                                        </div>
                                                                                        <% } %>
                                                                </div>
                                                </div>
                                            </div>
                                        </main>
                                    </div>

                                    <!-- Progress Modal -->
                                    <div class="modal-overlay" id="progressModal">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h3><i class="ph ph-chart-line-up"></i> Enregistrer le Progrès</h3>
                                                <button class="modal-close"
                                                    onclick="closeProgressModal()">&times;</button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/patient/logProgress"
                                                method="POST">
                                                <div class="form-row">
                                                    <div class="form-group">
                                                        <label for="weight">Poids (kg)</label>
                                                        <input type="number" step="0.1" id="weight" name="weight"
                                                            class="form-control" placeholder="e.g., 70.5">
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="waterIntake">Consommation d'Eau (verres)</label>
                                                        <input type="number" id="waterIntake" name="waterIntake"
                                                            class="form-control" placeholder="e.g., 8">
                                                    </div>
                                                </div>
                                                <div class="form-row    ">
                                                    <label for="calories">Calories Estimées</label>
                                                    <input type="number" id="calories" name="calories"
                                                        class="form-control" placeholder="e.g., 1800">
                                                </div>
                                                <div class="form-group">
                                                    <label for="notes">Notes</label>
                                                    <textarea id="notes" name="notes" class="form-control" rows="3"
                                                        placeholder="Comment vous sentez-vous aujourd'hui ?"></textarea>
                                                </div>
                                                <button type="submit" class="btn btn-primary w-full"><i
                                                        class="ph ph-check"></i> Enregistrer</button>
                                            </form>
                                        </div>
                                    </div>

                                    <script>
                                        const contextPath = '${pageContext.request.contextPath}';

                                        function trackMeal(mealPlanId, mealType, completed) {
                                            const mealTypeMap = {
                                                'breakfast': 'morning',
                                                'lunch': 'noon',
                                                'dinner': 'night',
                                                'snacks': 'snacks'
                                            };
                                            const dbMealType = mealTypeMap[mealType] || mealType;
                                            
                                            const params = new URLSearchParams();
                                            params.append('mealPlanId', mealPlanId);
                                            params.append('mealType', dbMealType);
                                            params.append('completed', completed);
                                            params.append('alternativeMeal', ''); // Ensure alternativeMeal is sent, even if empty
                                            params.append('notes', 'Enregistré depuis le tableau de bord'); // Add notes parameter

                                            fetch(contextPath + '/patient/saveMealTracking', {
                                                method: 'POST',
                                                headers: {
                                                    'Content-Type': 'application/x-www-form-urlencoded'
                                                },
                                                body: params
                                            })
                                                .then(response => response.json())
                                                .then(data => {
                                                    if (data.success) location.reload();
                                                    else alert('Échec de l\'enregistrement : ' + data.message);
                                                })
                                                .catch(error => { console.error('Error:', error); alert('Une erreur est survenue. Veuillez réessayer.'); });
                                        }

                                        function showAlternativeInput(mealType, mealPlanId) {
                                            const input = document.getElementById('alt-' + mealType);
                                            input.classList.add('show');
                                            input.focus();
                                            input.dataset.mealPlanId = mealPlanId;
                                        }

                                        function submitAlternative(mealType, mealPlanId) {
                                            const input = document.getElementById('alt-' + mealType);
                                            const alternativeMeal = input.value.trim();
                                            if (!alternativeMeal) { alert('Veuillez entrer ce que vous avez mangé à la place.'); return; }

                                            const mealTypeMap = {
                                                'breakfast': 'morning',
                                                'lunch': 'noon',
                                                'dinner': 'night',
                                                'snacks': 'snacks'
                                            };
                                            const dbMealType = mealTypeMap[mealType] || mealType;

                                            const params = new URLSearchParams();
                                            params.append('mealPlanId', mealPlanId);
                                            params.append('mealType', dbMealType);
                                            params.append('completed', 'false');
                                            params.append('alternativeMeal', alternativeMeal);
                                            params.append('notes', 'Enregistré depuis le tableau de bord');

                                            fetch(contextPath + '/patient/saveMealTracking', {
                                                method: 'POST',
                                                headers: {
                                                    'Content-Type': 'application/x-www-form-urlencoded'
                                                },
                                                body: params
                                            })
                                                .then(response => response.json())
                                                .then(data => {
                                                    if (data.success) location.reload();
                                                    else alert('Échec de l\'enregistrement : ' + data.message);
                                                })
                                                .catch(error => { console.error('Error:', error); alert('Une erreur est survenue. Veuillez réessayer.'); });
                                        }

                                        function openProgressModal() { document.getElementById('progressModal').classList.add('show'); }
                                        function closeProgressModal() { document.getElementById('progressModal').classList.remove('show'); }

                                        document.getElementById('progressModal').addEventListener('click', function (e) {
                                            if (e.target === this) closeProgressModal();
                                        });

                                        // ApexCharts Initialization
                                        document.addEventListener('DOMContentLoaded', function () {
                                            const dates = [];
                                            const weights = [];
                                            const waterIntake = [];
                                            const calories = [];

                                            <c:forEach var="p" items="${chartHistory}">
                                                dates.push('${p.date}');
                                                weights.push(${p.weight > 0 ? p.weight : 'null'});
                                                waterIntake.push(${p.waterIntake});
                                                calories.push(${p.caloriesConsumed > 0 ? p.caloriesConsumed : '0'});
                                            </c:forEach>

                                            const commonOptions = {
                                                chart: {
                                                    fontFamily: 'Inter, sans-serif',
                                                    toolbar: { show: false },
                                                    animations: { enabled: true, easing: 'easeinout', speed: 800 }
                                                },
                                                dataLabels: { enabled: false },
                                                stroke: { curve: 'smooth', width: 3 },
                                                xaxis: {
                                                    categories: dates,
                                                    axisBorder: { show: false },
                                                    axisTicks: { show: false },
                                                    labels: { style: { colors: '#64748b', fontSize: '12px' } }
                                                },
                                                yaxis: {
                                                    labels: { style: { colors: '#64748b', fontSize: '12px' } }
                                                },
                                                grid: { borderColor: '#f1f5f9', strokeDashArray: 4 },
                                                tooltip: { theme: 'light' }
                                            };

                                            // Weight Chart
                                            if (document.getElementById('weightChart')) {
                                                const weightOptions = {
                                                    ...commonOptions,
                                                    series: [{ name: 'Poids', data: weights }],
                                                    chart: { type: 'area', height: 320, parentHeightOffset: 0 },
                                                    colors: ['#059669'],
                                                    fill: {
                                                        type: 'gradient',
                                                        gradient: { shadeIntensity: 1, opacityFrom: 0.7, opacityTo: 0.3, stops: [0, 90, 100] }
                                                    },
                                                    title: { text: 'Historique de Poids (kg)', align: 'left', style: { fontSize: '16px', fontWeight: 600, color: '#1e293b' } }
                                                };
                                                new ApexCharts(document.querySelector("#weightChart"), weightOptions).render();
                                            }

                                            // Water Chart
                                            if (document.getElementById('waterChart')) {
                                                const waterOptions = {
                                                    ...commonOptions,
                                                    series: [{ name: 'Eau', data: waterIntake }],
                                                    chart: { type: 'bar', height: 320, parentHeightOffset: 0 },
                                                    colors: ['#0891B2'],
                                                    plotOptions: {
                                                        bar: { borderRadius: 6, columnWidth: '40%', dataLabels: { position: 'top' } }
                                                    },
                                                     title: { text: 'Consommation d\'Eau (Verres)', align: 'left', style: { fontSize: '16px', fontWeight: 600, color: '#1e293b' } }
                                                };
                                                new ApexCharts(document.querySelector("#waterChart"), waterOptions).render();
                                            }

                                             // Calories Chart
                                            if (document.getElementById('caloriesChart')) {
                                                const caloriesOptions = {
                                                    ...commonOptions,
                                                    series: [{ name: 'Calories', data: calories }],
                                                    chart: { type: 'area', height: 320, parentHeightOffset: 0 },
                                                    colors: ['#F59E0B'], // Amber/Orange for calories
                                                     fill: {
                                                        type: 'gradient',
                                                        gradient: { shadeIntensity: 1, opacityFrom: 0.7, opacityTo: 0.3, stops: [0, 90, 100] }
                                                    },
                                                    title: { text: 'Calories Consommées', align: 'left', style: { fontSize: '16px', fontWeight: 600, color: '#1e293b' } }
                                                };
                                                new ApexCharts(document.querySelector("#caloriesChart"), caloriesOptions).render();
                                            }
                                        });
                                    </script>
                                </body>

                                </html>