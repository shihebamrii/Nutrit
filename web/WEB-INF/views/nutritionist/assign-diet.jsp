<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Attribuer un Plan Alimentaire - Nutrit</title>
                <meta name="description" content="Attribuez un modèle de plan alimentaire à votre patient.">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <script src="https://unpkg.com/@phosphor-icons/web"></script>
                <style>
                    .assign-grid {
                        display: grid;
                        grid-template-columns: 1fr 400px;
                        gap: 2rem;
                        align-items: start;
                    }

                    @media (max-width: 1024px) {
                        .assign-grid {
                            grid-template-columns: 1fr;
                        }
                    }

                    .template-selector {
                        margin-bottom: 1.5rem;
                    }

                    .template-option {
                        padding: 1rem;
                        border: 2px solid var(--gray-200);
                        border-radius: var(--radius-lg);
                        cursor: pointer;
                        transition: all 0.2s ease;
                        margin-bottom: 0.75rem;
                        display: flex;
                        gap: 1rem;
                        align-items: flex-start;
                    }

                    .template-option:hover {
                        border-color: var(--primary-light);
                        background: var(--gray-50);
                    }

                    .template-option.selected {
                        border-color: var(--primary);
                        background: linear-gradient(135deg, rgba(45, 156, 219, 0.05), rgba(45, 156, 219, 0.1));
                    }

                    .template-option input[type="radio"] {
                        margin-top: 0.25rem;
                    }

                    .template-option-content {
                        flex: 1;
                    }

                    .template-option-name {
                        font-weight: 600;
                        color: var(--gray-800);
                        margin-bottom: 0.25rem;
                    }

                    .template-option-meta {
                        font-size: 0.85rem;
                        color: var(--gray-500);
                        display: flex;
                        gap: 1rem;
                        flex-wrap: wrap;
                    }

                    .template-option-meta span {
                        display: flex;
                        align-items: center;
                        gap: 0.25rem;
                    }

                    .preview-card {
                        position: sticky;
                        top: 2rem;
                    }

                    .preview-header {
                        background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                        color: white;
                        padding: 1.5rem;
                        border-radius: var(--radius-xl) var(--radius-xl) 0 0;
                    }

                    .preview-header h3 {
                        margin-bottom: 0.5rem;
                    }

                    .preview-body {
                        padding: 1.5rem;
                        background: white;
                        border: 1px solid var(--gray-200);
                        border-top: none;
                        border-radius: 0 0 var(--radius-xl) var(--radius-xl);
                    }

                    .preview-meal {
                        display: flex;
                        gap: 0.75rem;
                        padding: 0.75rem 0;
                        border-bottom: 1px solid var(--gray-100);
                    }

                    .preview-meal:last-child {
                        border-bottom: none;
                    }

                    .preview-meal-icon {
                        width: 32px;
                        height: 32px;
                        border-radius: var(--radius-md);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex-shrink: 0;
                    }

                    .preview-meal-icon.breakfast {
                        background: #FEF3C7;
                        color: #D97706;
                    }

                    .preview-meal-icon.lunch {
                        background: #D1FAE5;
                        color: #059669;
                    }

                    .preview-meal-icon.dinner {
                        background: #E0E7FF;
                        color: #4F46E5;
                    }

                    .preview-meal-icon.snack {
                        background: #FCE7F3;
                        color: #DB2777;
                    }

                    .preview-meal-text {
                        font-size: 0.85rem;
                        color: var(--gray-600);
                        line-height: 1.5;
                    }

                    .preview-meal-label {
                        font-weight: 600;
                        font-size: 0.75rem;
                        color: var(--gray-700);
                        text-transform: uppercase;
                        margin-bottom: 0.25rem;
                    }

                    .preview-stats {
                        display: flex;
                        justify-content: space-around;
                        background: var(--gray-50);
                        padding: 1rem;
                        border-radius: var(--radius-lg);
                        margin-bottom: 1rem;
                    }

                    .preview-stat {
                        text-align: center;
                    }

                    .preview-stat-value {
                        font-size: 1.25rem;
                        font-weight: 700;
                        color: var(--primary);
                    }

                    .preview-stat-label {
                        font-size: 0.75rem;
                        color: var(--gray-500);
                        text-transform: uppercase;
                    }

                    .empty-preview {
                        text-align: center;
                        padding: 3rem 2rem;
                        color: var(--gray-400);
                    }

                    .empty-preview i {
                        font-size: 3rem;
                        margin-bottom: 1rem;
                    }

                    .form-section {
                        background: var(--gray-50);
                        border-radius: var(--radius-lg);
                        padding: 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    .form-section-title {
                        font-weight: 600;
                        color: var(--gray-700);
                        margin-bottom: 1rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .template-search {
                        position: relative;
                        margin-bottom: 1rem;
                    }

                    .template-search i {
                        position: absolute;
                        left: 1rem;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--gray-400);
                    }

                    .template-search input {
                        padding-left: 2.75rem;
                    }

                    .templates-list {
                        max-height: 400px;
                        overflow-y: auto;
                        border: 1px solid var(--gray-200);
                        border-radius: var(--radius-lg);
                        background: white;
                    }

                    .checkbox-option {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        padding: 0.75rem 1rem;
                        background: var(--gray-50);
                        border-radius: var(--radius-md);
                        cursor: pointer;
                        margin-top: 0.5rem;
                    }

                    .checkbox-option:hover {
                        background: var(--gray-100);
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
                        color: #065F46;
                        border: 1px solid #A7F3D0;
                    }

                    .alert-error {
                        background: #FEE2E2;
                        color: #991B1B;
                        border: 1px solid #FECACA;
                    }

                    .quick-durations {
                        display: flex;
                        gap: 0.5rem;
                        flex-wrap: wrap;
                        margin-top: 0.5rem;
                    }

                    .quick-duration-btn {
                        padding: 0.5rem 1rem;
                        border: 1px solid var(--gray-300);
                        border-radius: var(--radius-md);
                        background: white;
                        font-size: 0.85rem;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .quick-duration-btn:hover {
                        border-color: var(--primary);
                        color: var(--primary);
                    }

                    .quick-duration-btn.active {
                        background: var(--primary);
                        color: white;
                        border-color: var(--primary);
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
                                <h1><i class="ph ph-clipboard-text" style="color: var(--primary);"></i> Attribuer un Plan Alimentaire
                                </h1>
                                <p>Sélectionnez un modèle et attribuez-le à votre patient pour plusieurs jours.</p>
                            </div>

                            <!-- Alerts -->
                            <c:if test="${not empty success}">
                                <div class="alert alert-success animate-fade-in">
                                    <i class="ph ph-check-circle"></i>
                                    ${success}
                                </div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-error animate-fade-in">
                                    <i class="ph ph-warning-circle"></i>
                                    ${error}
                                </div>
                            </c:if>

                            <div class="assign-grid">
                                <!-- Main Form -->
                                <div class="card animate-fade-in">
                                    <form action="${pageContext.request.contextPath}/nutritionist/assignDiet"
                                        method="POST" id="assignForm">

                                        <!-- Patient Selection -->
                                        <div class="form-section">
                                            <div class="form-section-title">
                                                <i class="ph ph-user"></i>
                                                Sélectionner le Patient
                                            </div>
                                            <c:choose>
                                                <c:when test="${not empty patients}">
                                                    <select name="patientId" id="patientId" class="input" required>
                                                        <option value="">Choisir un patient...</option>
                                                        <c:forEach var="patient" items="${patients}">
                                                            <option value="${patient.id}"
                                                                ${selectedPatientId==patient.id.toString() ? 'selected'
                                                                : '' }>
                                                                ${patient.fullName} (${patient.email})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="empty-preview">
                                                        <p>Aucun patient ne vous est encore attribué.</p>
                                                        <a href="${pageContext.request.contextPath}/nutritionist/dashboard"
                                                            class="btn btn-ghost mt-2">
                                                            Voir le Tableau de Bord
                                                        </a>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Template Selection -->
                                        <div class="form-section">
                                            <div class="form-section-title">
                                                <i class="ph ph-book-open"></i>
                                                Sélectionner le Modèle
                                            </div>

                                            <div class="template-search">
                                                <i class="ph ph-magnifying-glass"></i>
                                                <input type="text" id="templateSearch" class="input"
                                                    placeholder="Rechercher des modèles...">
                                            </div>

                                            <div class="templates-list">
                                                <c:forEach var="template" items="${templates}">
                                                    <label class="template-option"
                                                        data-name="${fn:toLowerCase(template.name)}"
                                                        data-category="${fn:toLowerCase(template.category)}"
                                                        data-calories="${template.caloriesPerDay}"
                                                        data-days="${template.durationDays}"
                                                        data-breakfast="${fn:escapeXml(template.breakfast)}"
                                                        data-lunch="${fn:escapeXml(template.lunch)}"
                                                        data-dinner="${fn:escapeXml(template.dinner)}">
                                                        <input type="radio" name="templateId" value="${template.id}"
                                                            ${selectedTemplate !=null &&
                                                            selectedTemplate.id==template.id ? 'checked' : '' }>
                                                        <div class="template-option-content">
                                                            <div class="template-option-name">${template.name}</div>
                                                            <div class="template-option-meta">
                                                                <span><i class="ph ph-tag"></i>
                                                                    ${fn:replace(template.category, '_', ' ')}</span>
                                                                <span><i class="ph ph-fire"></i>
                                                                    ${template.caloriesPerDay} kcal</span>
                                                                <span><i class="ph ph-calendar"></i>
                                                                    ${template.durationDays} jours</span>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <!-- Date and Duration -->
                                        <div class="form-section">
                                            <div class="form-section-title">
                                                <i class="ph ph-calendar"></i>
                                                Planification
                                            </div>

                                            <div class="form-grid">
                                                <div class="form-group">
                                                    <label class="label" for="startDate">Date de Début</label>
                                                    <input type="date" id="startDate" name="startDate" class="input"
                                                        required>
                                                </div>
                                                <div class="form-group">
                                                    <label class="label" for="days">Nombre de Jours</label>
                                                    <input type="number" id="days" name="days" class="input" min="1"
                                                        max="365" value="7" required>
                                                    <div class="quick-durations">
                                                        <button type="button" class="quick-duration-btn"
                                                            onclick="setDays(7)">1 Semaine</button>
                                                        <button type="button" class="quick-duration-btn"
                                                            onclick="setDays(14)">2 Semaines</button>
                                                        <button type="button" class="quick-duration-btn"
                                                            onclick="setDays(30)">1 Mois</button>
                                                        <button type="button" class="quick-duration-btn"
                                                            onclick="setDays(90)">3 Mois</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <label class="checkbox-option">
                                                <input type="checkbox" name="replaceExisting">
                                                <span>Remplacer les plans alimentaires existants dans cette plage de dates</span>
                                            </label>
                                        </div>

                                        <div class="flex justify-end gap-3 mt-6">
                                            <a href="${pageContext.request.contextPath}/nutritionist/dietTemplates"
                                                class="btn btn-ghost">
                                                <i class="ph ph-arrow-left"></i> Retour aux Modèles
                                            </a>
                                            <button type="submit" class="btn btn-primary" ${empty patients ? 'disabled'
                                                : '' }>
                                                <i class="ph ph-check"></i> Attribuer le Plan
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Preview Panel -->
                                <div class="preview-card">
                                    <div class="preview-header">
                                        <h3 id="previewTitle">
                                            <c:choose>
                                                <c:when test="${not empty selectedTemplate}">${selectedTemplate.name}
                                                </c:when>
                                                <c:otherwise>Aperçu du Modèle</c:otherwise>
                                            </c:choose>
                                        </h3>
                                        <div id="previewSubtitle" style="opacity: 0.9; font-size: 0.9rem;">
                                            <c:if test="${not empty selectedTemplate}">
                                                ${fn:replace(selectedTemplate.category, '_', ' ')} -
                                                ${selectedTemplate.caloriesPerDay} kcal/jour
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="preview-body" id="previewBody">
                                        <c:choose>
                                            <c:when test="${not empty selectedTemplate}">
                                                <div class="preview-stats">
                                                    <div class="preview-stat">
                                                        <div class="preview-stat-value">
                                                            ${selectedTemplate.caloriesPerDay}</div>
                                                        <div class="preview-stat-label">Calories</div>
                                                    </div>
                                                    <div class="preview-stat">
                                                        <div class="preview-stat-value">${selectedTemplate.durationDays}
                                                        </div>
                                                        <div class="preview-stat-label">Jours reco.</div>
                                                    </div>
                                                </div>

                                                <div class="preview-meal">
                                                    <div class="preview-meal-icon breakfast"><i
                                                            class="ph ph-sun-horizon"></i></div>
                                                    <div>
                                                        <div class="preview-meal-label">Petit-déjeuner</div>
                                                        <div class="preview-meal-text">${selectedTemplate.breakfast}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="preview-meal">
                                                    <div class="preview-meal-icon lunch"><i class="ph ph-sun"></i></div>
                                                    <div>
                                                        <div class="preview-meal-label">Déjeuner</div>
                                                        <div class="preview-meal-text">${selectedTemplate.lunch}</div>
                                                    </div>
                                                </div>
                                                <div class="preview-meal">
                                                    <div class="preview-meal-icon dinner"><i
                                                            class="ph ph-moon-stars"></i></div>
                                                    <div>
                                                        <div class="preview-meal-label">Dîner</div>
                                                        <div class="preview-meal-text">${selectedTemplate.dinner}</div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-preview" id="emptyPreview">
                                                    <i class="ph ph-clipboard-text"></i>
                                                    <p>Sélectionnez un modèle pour voir l'aperçu</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <script>
                    // Set default start date to today
                    document.getElementById('startDate').valueAsDate = new Date();

                    // Add click handlers to template options
                    document.querySelectorAll('.template-option').forEach(function (option) {
                        var radio = option.querySelector('input[type="radio"]');
                        radio.addEventListener('change', function () {
                            updatePreview(option);
                        });
                    });

                    function updatePreview(option) {
                        var data = option.dataset;
                        var name = option.querySelector('.template-option-name').textContent;
                        var category = data.category.replace('_', ' ');

                        document.getElementById('previewTitle').textContent = name;
                        document.getElementById('previewSubtitle').textContent = category + ' - ' + data.calories + ' kcal/jour';

                        var html = '<div class="preview-stats">' +
                            '<div class="preview-stat">' +
                            '<div class="preview-stat-value">' + data.calories + '</div>' +
                            '<div class="preview-stat-label">Calories</div>' +
                            '</div>' +
                            '<div class="preview-stat">' +
                            '<div class="preview-stat-value">' + data.days + '</div>' +
                            '<div class="preview-stat-label">Jours reco.</div>' +
                            '</div>' +
                            '</div>' +
                            '<div class="preview-meal">' +
                            '<div class="preview-meal-icon breakfast"><i class="ph ph-sun-horizon"></i></div>' +
                            '<div>' +
                            '<div class="preview-meal-label">Petit-déjeuner</div>' +
                            '<div class="preview-meal-text">' + data.breakfast + '</div>' +
                            '</div>' +
                            '</div>' +
                            '<div class="preview-meal">' +
                            '<div class="preview-meal-icon lunch"><i class="ph ph-sun"></i></div>' +
                            '<div>' +
                            '<div class="preview-meal-label">Déjeuner</div>' +
                            '<div class="preview-meal-text">' + data.lunch + '</div>' +
                            '</div>' +
                            '</div>' +
                            '<div class="preview-meal">' +
                            '<div class="preview-meal-icon dinner"><i class="ph ph-moon-stars"></i></div>' +
                            '<div>' +
                            '<div class="preview-meal-label">Dîner</div>' +
                            '<div class="preview-meal-text">' + data.dinner + '</div>' +
                            '</div>' +
                            '</div>';

                        document.getElementById('previewBody').innerHTML = html;

                        // Highlight selected option
                        document.querySelectorAll('.template-option').forEach(function (opt) {
                            opt.classList.remove('selected');
                        });
                        option.classList.add('selected');

                        // Update days field to template's recommended duration
                        document.getElementById('days').value = data.days;
                        updateQuickDurationButtons();
                    }

                    function setDays(days) {
                        document.getElementById('days').value = days;
                        updateQuickDurationButtons();
                    }

                    function updateQuickDurationButtons() {
                        var currentDays = parseInt(document.getElementById('days').value);
                        document.querySelectorAll('.quick-duration-btn').forEach(function (btn) {
                            btn.classList.remove('active');
                        });
                        var mapping = { 7: 0, 14: 1, 30: 2, 90: 3 };
                        if (mapping[currentDays] !== undefined) {
                            document.querySelectorAll('.quick-duration-btn')[mapping[currentDays]].classList.add('active');
                        }
                    }

                    // Template search functionality
                    document.getElementById('templateSearch').addEventListener('input', function (e) {
                        var query = e.target.value.toLowerCase();
                        document.querySelectorAll('.template-option').forEach(function (option) {
                            var name = option.dataset.name;
                            var category = option.dataset.category;
                            if (name.indexOf(query) !== -1 || category.indexOf(query) !== -1) {
                                option.style.display = 'flex';
                            } else {
                                option.style.display = 'none';
                            }
                        });
                    });

                    // Days input change handler
                    document.getElementById('days').addEventListener('input', updateQuickDurationButtons);

                    // Initialize
                    updateQuickDurationButtons();

                    // If a template was pre-selected, highlight it
                    var preSelectedRadio = document.querySelector('input[name="templateId"]:checked');
                    if (preSelectedRadio) {
                        preSelectedRadio.closest('.template-option').classList.add('selected');
                    }
                </script>
            </body>

            </html>