<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.NutritionistAvailability" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paramètres de Disponibilité - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .availability-form {
            max-width: 800px;
            margin: 0 auto; /* CENTERED HERE */
        }
        
        .day-row {
            display: grid;
            grid-template-columns: 140px 60px 1fr 1fr 100px;
            gap: 1rem;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid var(--gray-100);
            transition: background var(--transition-fast);
        }
        
        .day-row:last-child {
            border-bottom: none;
        }
        
        .day-row:hover {
            background: var(--gray-50);
        }
        
        .day-row.disabled {
            opacity: 0.5;
        }
        
        .day-name {
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .day-icon {
            width: 32px;
            height: 32px;
            border-radius: var(--radius-md);
            background: var(--gradient-primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
        }
        
        .day-row.disabled .day-icon {
            background: var(--gray-300);
        }
        
        .toggle-switch {
            position: relative;
            width: 44px;
            height: 24px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: var(--gray-300);
            border-radius: 24px;
            transition: 0.3s;
        }
        
        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            border-radius: 50%;
            transition: 0.3s;
        }
        
        input:checked + .toggle-slider {
            background-color: var(--primary);
        }
        
        input:checked + .toggle-slider:before {
            transform: translateX(20px);
        }
        
        .time-input {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .time-input label {
            font-size: 0.75rem;
            color: var(--gray-500);
            text-transform: uppercase;
        }
        
        .time-input input {
            width: 110px;
        }
        
        .duration-select select {
            width: 100%;
        }
        
        .header-row {
            display: grid;
            grid-template-columns: 140px 60px 1fr 1fr 100px;
            gap: 1rem;
            padding: 0.75rem 1rem;
            background: var(--gray-50);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            color: var(--gray-500);
            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
        }
        
        .info-box {
            padding: 1rem;
            background: linear-gradient(135deg, #DBEAFE, #EFF6FF);
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
        }
        
        .info-box i {
            color: var(--info);
            font-size: 1.25rem;
            flex-shrink: 0;
        }
        
        .info-box p {
            color: var(--gray-700);
            font-size: 0.875rem;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="page-content">
                <div class="page-header" style="text-align: center;"> <h1><i class="ph ph-calendar-check" style="color: var(--primary);"></i> Paramètres de Disponibilité</h1>
                    <p>Définissez votre disponibilité hebdomadaire afin que les patients puissent prendre rendez-vous avec vous.</p>
                </div>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success" style="margin-bottom: 1rem; max-width: 800px; margin-left: auto; margin-right: auto;">
                        <i class="ph ph-check-circle"></i> ${success}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error" style="margin-bottom: 1rem; max-width: 800px; margin-left: auto; margin-right: auto;">
                        <i class="ph ph-x-circle"></i> ${error}
                    </div>
                </c:if>
                
                <div class="availability-form">
                    <div class="info-box">
                        <i class="ph ph-info"></i>
                        <div>
                            <p><strong>Comment ça marche :</strong> Activez les jours où vous êtes disponible, définissez vos heures de travail et choisissez la durée des rendez-vous. Les patients verront les créneaux horaires disponibles en fonction de ces paramètres.</p>
                        </div>
                    </div>
                    
                    <form method="POST" action="${pageContext.request.contextPath}/nutritionist/availability">
                        <div class="card">
                            <div class="header-row">
                                <span>Jour</span>
                                <span>Actif</span>
                                <span>Début</span>
                                <span>Fin</span>
                                <span>Créneau</span>
                            </div>
                            
                            <% 
                                Map<String, NutritionistAvailability> availByDay = (Map<String, NutritionistAvailability>) request.getAttribute("availByDay");
                                if (availByDay == null) availByDay = new java.util.HashMap<>();
                                
                                String[] days = {"monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"};
                                String[] dayLabels = {"Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"};
                                String[] dayShort = {"Lu", "Ma", "Me", "Je", "Ve", "Sa", "Di"};
                                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                                
                                for (int i = 0; i < days.length; i++) {
                                    String day = days[i];
                                    NutritionistAvailability avail = availByDay.get(day);
                                    boolean isEnabled = avail != null && avail.isActive();
                                    String startTime = avail != null ? timeFormat.format(avail.getStartTime()) : "09:00";
                                    String endTime = avail != null ? timeFormat.format(avail.getEndTime()) : "17:00";
                                    int duration = avail != null ? avail.getSlotDurationMinutes() : 30;
                            %>
                            <div class="day-row <%= !isEnabled ? "disabled" : "" %>" id="row_<%= day %>">
                                <div class="day-name">
                                    <div class="day-icon"><%= dayShort[i] %></div>
                                    <%= dayLabels[i] %>
                                </div>
                                
                                <label class="toggle-switch">
                                    <input type="checkbox" name="<%= day %>_enabled" 
                                           <%= isEnabled ? "checked" : "" %>
                                           onchange="toggleDay('<%= day %>')">
                                    <span class="toggle-slider"></span>
                                </label>
                                
                                <div class="time-input">
                                    <label>De</label>
                                    <input type="time" name="<%= day %>_start" 
                                           value="<%= startTime %>" 
                                           class="input" 
                                           id="<%= day %>_start"
                                           <%= !isEnabled ? "disabled" : "" %>>
                                </div>
                                
                                <div class="time-input">
                                    <label>À</label>
                                    <input type="time" name="<%= day %>_end" 
                                           value="<%= endTime %>" 
                                           class="input"
                                           id="<%= day %>_end"
                                           <%= !isEnabled ? "disabled" : "" %>>
                                </div>
                                
                                <div class="duration-select">
                                    <select name="<%= day %>_duration" class="input" id="<%= day %>_duration" <%= !isEnabled ? "disabled" : "" %>>
                                        <option value="15" <%= duration == 15 ? "selected" : "" %>>15 min</option>
                                        <option value="30" <%= duration == 30 ? "selected" : "" %>>30 min</option>
                                        <option value="45" <%= duration == 45 ? "selected" : "" %>>45 min</option>
                                        <option value="60" <%= duration == 60 ? "selected" : "" %>>60 min</option>
                                    </select>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        
                        <div style="margin-top: 1.5rem; display: flex; gap: 1rem; justify-content: center;"> <button type="submit" class="btn btn-primary">
                                <i class="ph ph-floppy-disk"></i> Enregistrer
                            </button>
                            <button type="button" class="btn btn-ghost" onclick="setDefaultHours()">
                                <i class="ph ph-clock"></i> Par défaut (Lun-Ven 9-17)
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        function toggleDay(day) {
            const row = document.getElementById('row_' + day);
            const checkbox = document.querySelector('input[name="' + day + '_enabled"]');
            const startInput = document.getElementById(day + '_start');
            const endInput = document.getElementById(day + '_end');
            const durationSelect = document.getElementById(day + '_duration');
            
            if (checkbox.checked) {
                row.classList.remove('disabled');
                startInput.disabled = false;
                endInput.disabled = false;
                durationSelect.disabled = false;
            } else {
                row.classList.add('disabled');
                startInput.disabled = true;
                endInput.disabled = true;
                durationSelect.disabled = true;
            }
        }
        
        function setDefaultHours() {
            const weekdays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];
            const weekend = ['saturday', 'sunday'];
            
            weekdays.forEach(day => {
                const checkbox = document.querySelector('input[name="' + day + '_enabled"]');
                checkbox.checked = true;
                toggleDay(day);
                document.getElementById(day + '_start').value = '09:00';
                document.getElementById(day + '_end').value = '17:00';
                document.getElementById(day + '_duration').value = '30';
            });
            
            weekend.forEach(day => {
                const checkbox = document.querySelector('input[name="' + day + '_enabled"]');
                checkbox.checked = false;
                toggleDay(day);
            });
        }
    </script>
</body>
</html>