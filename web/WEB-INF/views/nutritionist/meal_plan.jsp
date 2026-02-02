<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Plans Alimentaires - Nutrit</title>
    <meta name="description" content="Gérez les plans alimentaires de vos patients.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .plans-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .patient-select-form {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .patient-select-form select {
            min-width: 250px;
        }
        
        .plans-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }
        
        .plan-card {
            background: var(--white);
            border-radius: var(--radius-xl);
            border: 1px solid var(--gray-200);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .plan-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }
        
        .plan-header {
            padding: 1.25rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }
        
        .plan-patient-name {
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            color: black;
        }
        
        .plan-date {
            font-size: 0.85rem;
            opacity: 0.9;
            color: black;
        }
        
        .plan-body {
            padding: 1.25rem;
        }
        
        .meal-times-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .meal-pill {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .meal-pill.morning { background: #FEF3C7; color: #D97706; }
        .meal-pill.noon { background: #D1FAE5; color: #059669; }
        .meal-pill.night { background: #E0E7FF; color: #4F46E5; }
        .meal-pill.snacks { background: #FCE7F3; color: #DB2777; }
        
        .plan-status {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .plan-status.active {
            background: #D1FAE5;
            color: #059669;
        }
        
        .plan-status.inactive {
            background: var(--gray-100);
            color: var(--gray-500);
        }
        
        .plan-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
        }
        
        .plan-actions .btn {
            flex: 1;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--gray-50);
            border-radius: var(--radius-xl);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--gray-300);
            margin-bottom: 1rem;
        }
        
        .empty-state h3 {
            color: var(--gray-700);
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            color: var(--gray-500);
            margin-bottom: 1.5rem;
        }
        
        .alert {
            padding: 1rem 1.25rem;
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-success {
            background: #D1FAE5;
            color: #059669;
            border: 1px solid #A7F3D0;
        }
        
        .alert-error {
            background: #FEE2E2;
            color: #DC2626;
            border: 1px solid #FECACA;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }
        
        .modal.show {
            display: flex;
        }
        
        .modal-content {
            background-color: white;
            border-radius: var(--radius-xl);
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: var(--shadow-2xl);
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h3 {
            margin: 0;
            font-size: 1.25rem;
        }
        
        .close-modal {
            font-size: 1.5rem;
            color: var(--gray-500);
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .close-modal:hover {
            color: var(--danger);
        }
        
        .modal-body {
            padding: 1.5rem;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        
        .table th, .table td {
            text-align: left;
            padding: 0.75rem;
            border-bottom: 1px solid var(--gray-100);
        }
        
        .table th {
            font-weight: 600;
            color: var(--gray-600);
            background: var(--gray-50);
        }

        /* Custom Tooltip */
        .tooltip-container {
            position: relative;
            display: inline-block;
        }

        .tooltip-content {
            visibility: hidden;
            width: 200px;
            background-color: #1f2937;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 8px;
            position: absolute;
            z-index: 1050;
            bottom: 125%; /* Position above */
            left: 50%;
            margin-left: -100px;
            opacity: 0;
            transition: opacity 0.3s;
            font-size: 0.75rem;
            font-weight: normal;
            box-shadow: var(--shadow-lg);
            pointer-events: none;
        }

        .tooltip-content::after {
            content: "";
            position: absolute;
            top: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: #1f2937 transparent transparent transparent;
        }

        .tooltip-container:hover .tooltip-content {
            visibility: visible;
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
        
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp"/>
            
            <div class="page-content">
                <!-- Page Header -->
                <div class="page-header">
                    <h1><i class="ph ph-bowl-food" style="color: var(--primary);"></i> Plans Alimentaires</h1>
                    <p>Créez et gérez des plans alimentaires personnalisés pour vos patients.</p>
                </div>
                
                <!-- Alerts -->
                <c:if test="${param.success == 'created'}">
                    <div class="alert alert-success">
                        <i class="ph ph-check-circle"></i>
                        Plan alimentaire créé avec succès !
                    </div>
                </c:if>
                <c:if test="${param.success == 'deleted'}">
                    <div class="alert alert-success">
                        <i class="ph ph-check-circle"></i>
                        Plan alimentaire supprimé avec succès !
                    </div>
                </c:if>
                <c:if test="${param.error == 'noPatient'}">
                    <div class="alert alert-error">
                        <i class="ph ph-warning"></i>
                        Veuillez d'abord sélectionner un patient.
                    </div>
                </c:if>
                
                <!-- Header with Patient Select -->
                <div class="plans-header">
                    <form class="patient-select-form" action="${pageContext.request.contextPath}/nutritionist/mealPlan/create" method="GET">
                        <label for="patientSelect"><strong>Sélectionner un Patient :</strong></label>
                        <select name="patientId" id="patientSelect" class="input" required>
                            <option value="">-- Choisir un patient --</option>
                            <c:forEach var="patient" items="${patients}">
                                <option value="${patient.id}">${patient.fullName}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="ph ph-plus"></i> Créer un Plan Alimentaire
                        </button>
                    </form>
                </div>
                
                <!-- Meal Plans Grid -->
                <c:choose>
                    <c:when test="${not empty mealPlans}">
                        <h3 class="mb-4">Vos Plans Alimentaires (${mealPlans.size()})</h3>
                        <div class="plans-grid">
                            <c:forEach var="plan" items="${mealPlans}">
                                <div class="plan-card animate-fade-in">
                                    <div class="plan-header">
                                        <div class="plan-patient-name">${plan.patientName}</div>
                                        <div class="plan-date">
                                            Créé le : <fmt:formatDate value="${plan.createdAt}" pattern="dd MMM yyyy"/>
                                        </div>
                                    </div>
                                    <div class="plan-body">
                                        <div class="meal-times-pills">
                                            <c:if test="${plan.mealTimeEnabled['morning']}">
                                                <span class="meal-pill morning">
                                                    <i class="ph ph-sun-horizon"></i> Matin
                                                </span>
                                            </c:if>
                                            <c:if test="${plan.mealTimeEnabled['noon']}">
                                                <span class="meal-pill noon">
                                                    <i class="ph ph-sun"></i> Midi
                                                </span>
                                            </c:if>
                                            <c:if test="${plan.mealTimeEnabled['night']}">
                                                <span class="meal-pill night">
                                                    <i class="ph ph-moon-stars"></i> Soir
                                                </span>
                                            </c:if>
                                            <c:if test="${plan.mealTimeEnabled['snacks']}">
                                                <span class="meal-pill snacks">
                                                    <i class="ph ph-cookie"></i> Collations
                                                </span>
                                            </c:if>
                                        </div>
                                        
                                        <span class="plan-status ${plan.active ? 'active' : 'inactive'}">
                                            <i class="ph ${plan.active ? 'ph-check-circle' : 'ph-x-circle'}"></i>
                                            ${plan.active ? 'Actif' : 'Inactif'}
                                        </span>
                                        
                                        <c:if test="${not empty plan.notes}">
                                            <p class="mt-3" style="color: var(--gray-600); font-size: 0.875rem;">
                                                ${plan.notes}
                                            </p>
                                        </c:if>
                                        
                                        <div class="plan-actions">
                                            <button type="button" class="btn btn-ghost" onclick="showProgress(${plan.patientId}, '${plan.patientName}')" title="Voir les progrès">
                                                <i class="ph ph-chart-line-up" style="color: var(--primary);"></i> Suivi
                                            </button>
                                            <a href="${pageContext.request.contextPath}/nutritionist/mealPlan/create?patientId=${plan.patientId}" 
                                               class="btn btn-ghost">
                                                <i class="ph ph-pencil"></i> Modifier
                                            </a>
                                            <form action="${pageContext.request.contextPath}/nutritionist/mealPlan/delete" method="POST" 
                                                  style="flex: 1;" onsubmit="return confirm('Supprimer ce plan alimentaire ?');">
                                                <input type="hidden" name="planId" value="${plan.id}">
                                                <button type="submit" class="btn btn-ghost" style="width: 100%; color: var(--danger);">
                                                    <i class="ph ph-trash"></i> Supprimer
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="ph ph-bowl-food"></i>
                            <h3>Aucun Plan Alimentaire pour le moment</h3>
                            <p>Sélectionnez un patient ci-dessus pour créer votre premier plan alimentaire personnalisé.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <!-- Progress Modal -->
    <div id="progressModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalPatientName">Suivi du Patient</h3>
                <span class="close-modal" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div id="progressLoading" style="text-align: center; padding: 2rem;">
                    <i class="ph ph-spinner ph-spin" style="font-size: 2rem; color: var(--primary);"></i>
                    <p>Chargement du suivi...</p>
                </div>
                <div id="progressData" style="display:none;">
                    <div style="overflow-x: auto;">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 15%">Date</th>
                                    <th style="width: 10%">Poids</th>
                                    <th style="width: 10%">Eau</th>
                                    <th class="text-center" style="width: 15%">Matin</th>
                                    <th class="text-center" style="width: 15%">Midi</th>
                                    <th class="text-center" style="width: 15%">Soir</th>
                                    <th class="text-center" style="width: 15%">Collation</th>
                                </tr>
                            </thead>
                            <tbody id="progressTableBody">
                                <!-- Data populated by JS -->
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="noDataMessage" class="empty-state" style="display:none; padding: 2rem;">
                     <i class="ph ph-chart-bar" style="font-size: 3rem; color: var(--gray-300);"></i>
                     <p>Aucune donnée de suivi disponible pour les 30 derniers jours.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showProgress(patientId, patientName) {
            const modal = document.getElementById('progressModal');
            document.getElementById('modalPatientName').innerText = 'Suivi : ' + patientName;
            
            modal.classList.add('show');
            
            const loading = document.getElementById('progressLoading');
            const dataDiv = document.getElementById('progressData');
            const noData = document.getElementById('noDataMessage');
            const tbody = document.getElementById('progressTableBody');
            
            loading.style.display = 'block';
            dataDiv.style.display = 'none';
            noData.style.display = 'none';
            tbody.innerHTML = '';
            
            fetch('${pageContext.request.contextPath}/api/patient/progress?patientId=' + patientId)
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
                .then(data => {
                    loading.style.display = 'none';
                    if (data && data.length > 0) {
                        dataDiv.style.display = 'block';
                        
                        let rowsHtml = '';
                        for (let i = 0; i < data.length; i++) {
                            const item = data[i];
                            let dateStr = item.date || '-';
                            
                            const weight = item.weight ? item.weight + '<small>kg</small>' : '-';
                            const water = item.waterIntake ? item.waterIntake + ' <i class="ph ph-drop" style="color:#0EA5E9"></i>' : '-';
                            
                            // Group meals by type
                            const meals = {
                                morning: [],
                                noon: [],
                                night: [],
                                snacks: []
                            };
                            
                            if (item.mealTrackings) {
                                for(let j=0; j<item.mealTrackings.length; j++) {
                                    let m = item.mealTrackings[j];
                                    let type = m.mealType ? m.mealType.toLowerCase() : 'snacks';
                                    if(type === 'breakfast') type = 'morning';
                                    if(type === 'lunch') type = 'noon';
                                    if(type === 'dinner') type = 'night';
                                    if(type === 'collation') type = 'snacks';
                                    
                                    if(meals[type]) meals[type].push(m);
                                }
                            }
                            
                            // Helper to render cell
                            function renderCell(mealList) {
                                if (!mealList || mealList.length === 0) {
                                    return '<span style="color:var(--gray-300)">-</span>';
                                }
                                
                                // Analyze status
                                let allCompleted = true;
                                let anyLog = false;
                                let notes = [];
                                
                                for(let k=0; k<mealList.length; k++) {
                                    anyLog = true;
                                    let isDone = (mealList[k].completed === true || mealList[k].completed === "true");
                                    if (!isDone) allCompleted = false;
                                    
                                    // Build note content
                                    let notePart = "";
                                    if (mealList[k].alternativeMeal) notePart += "Alt: " + mealList[k].alternativeMeal;
                                    if (mealList[k].notes) {
                                        if (notePart) notePart += " | ";
                                        notePart += mealList[k].notes;
                                    }
                                    if (notePart) notes.push(notePart);
                                }
                                
                                let icon = allCompleted 
                                    ? '<i class="ph ph-check-circle" style="color:#059669; font-size:1.25rem;"></i>' 
                                    : '<i class="ph ph-x-circle" style="color:#DC2626; font-size:1.25rem;"></i>';
                                    
                                if (notes.length > 0) {
                                    return '<div class="tooltip-container">' + 
                                                icon + 
                                                '<span class="tooltip-content">' + notes.join('<br>') + '</span>' +
                                           '</div>';
                                } else {
                                    return icon;
                                }
                            }

                            rowsHtml += '<tr>' +
                                    '<td style="white-space:nowrap; font-weight:500;">' + dateStr + '</td>' +
                                    '<td>' + weight + '</td>' +
                                    '<td>' + water + '</td>' +
                                    '<td class="text-center">' + renderCell(meals.morning) + '</td>' +
                                    '<td class="text-center">' + renderCell(meals.noon) + '</td>' +
                                    '<td class="text-center">' + renderCell(meals.night) + '</td>' +
                                    '<td class="text-center">' + renderCell(meals.snacks) + '</td>' +
                                '</tr>';
                        }
                        tbody.innerHTML = rowsHtml;
                    } else {
                        noData.style.display = 'block';
                    }
                })
                .catch(error => {
                    console.error('Error fetching progress:', error);
                    loading.style.display = 'none';
                    noData.innerHTML = '<p style="color:var(--danger)">Erreur de chargement.<br><small>' + error.message + '</small></p>';
                    noData.style.display = 'block';
                });
        }
        
        function closeModal() {
            document.getElementById('progressModal').classList.remove('show');
        }
        
        // Close on outside click
        window.onclick = function(event) {
            const modal = document.getElementById('progressModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
