<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Modèles de Plans Alimentaires - Nutrit</title>
                <meta name="description" content="Parcourez plus de 50 modèles de plans alimentaires pré-établis pour divers objectifs de santé.">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <script src="https://unpkg.com/@phosphor-icons/web"></script>
                <style>
                    .templates-header {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 1rem;
                        align-items: center;
                        justify-content: space-between;
                        margin-bottom: 1.5rem;
                    }

                    .search-filter-bar {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 1rem;
                        flex: 1;
                    }

                    .search-box {
                        position: relative;
                        flex: 1;
                        min-width: 250px;
                    }

                    .search-box i {
                        position: absolute;
                        left: 1rem;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--gray-400);
                    }

                    .search-box input {
                        padding-left: 2.75rem;
                    }

                    .category-filter {
                        min-width: 200px;
                    }

                    .templates-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                        gap: 1.5rem;
                    }

                    .template-card {
                        background: var(--white);
                        border-radius: var(--radius-xl);
                        border: 1px solid var(--gray-200);
                        overflow: hidden;
                        transition: all 0.3s ease;
                    }

                    .template-card:hover {
                        transform: translateY(-4px);
                        box-shadow: var(--shadow-lg);
                        border-color: var(--primary);
                    }

                    .template-header {
                        padding: 1.25rem;
                        background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                        color: white;
                    }

                    .template-category {
                        display: inline-block;
                        font-size: 0.7rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        padding: 0.25rem 0.75rem;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 50px;
                        margin-bottom: 0.5rem;
                    }

                    .template-name {
                        font-size: 1.125rem;
                        font-weight: 700;
                        margin-bottom: 0.25rem;
                    }

                    .template-goal {
                        font-size: 0.85rem;
                        opacity: 0.9;
                        line-height: 1.4;
                    }

                    .template-body {
                        padding: 1.25rem;
                    }

                    .template-stats {
                        display: flex;
                        gap: 1rem;
                        margin-bottom: 1rem;
                    }

                    .stat-item {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        font-size: 0.85rem;
                        color: var(--gray-600);
                    }

                    .stat-item i {
                        color: var(--primary);
                    }

                    .meals-preview {
                        background: var(--gray-50);
                        border-radius: var(--radius-lg);
                        padding: 1rem;
                        margin-bottom: 1rem;
                    }

                    .meal-preview-item {
                        display: flex;
                        align-items: flex-start;
                        gap: 0.75rem;
                        padding: 0.5rem 0;
                        border-bottom: 1px solid var(--gray-200);
                    }

                    .meal-preview-item:last-child {
                        border-bottom: none;
                    }

                    .meal-preview-icon {
                        width: 28px;
                        height: 28px;
                        border-radius: var(--radius-md);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex-shrink: 0;
                        font-size: 0.875rem;
                    }

                    .meal-preview-icon.breakfast {
                        background: linear-gradient(135deg, #FEF3C7, #FFFBEB);
                        color: #D97706;
                    }

                    .meal-preview-icon.lunch {
                        background: linear-gradient(135deg, #D1FAE5, #ECFDF5);
                        color: #059669;
                    }

                    .meal-preview-icon.dinner {
                        background: linear-gradient(135deg, #E0E7FF, #EEF2FF);
                        color: #4F46E5;
                    }

                    .meal-preview-text {
                        font-size: 0.8rem;
                        color: var(--gray-600);
                        line-height: 1.4;
                        display: -webkit-box;
                        -webkit-line-clamp: 2;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                    }

                    .template-footer {
                        display: flex;
                        gap: 0.75rem;
                        padding-top: 0.5rem;
                    }

                    .template-footer .btn {
                        flex: 1;
                    }

                    .restrictions-tags {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 0.5rem;
                        margin-bottom: 1rem;
                    }

                    .restriction-tag {
                        font-size: 0.7rem;
                        padding: 0.25rem 0.5rem;
                        background: var(--gray-100);
                        color: var(--gray-600);
                        border-radius: 50px;
                        display: flex;
                        align-items: center;
                        gap: 0.25rem;
                    }

                    .restriction-tag.vegan {
                        background: #D1FAE5;
                        color: #059669;
                    }

                    .restriction-tag.vegetarian {
                        background: #FEF3C7;
                        color: #D97706;
                    }

                    .restriction-tag.gluten_free {
                        background: #DBEAFE;
                        color: #2563EB;
                    }

                    .restriction-tag.halal {
                        background: #E0E7FF;
                        color: #4F46E5;
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
                    }

                    .results-count {
                        color: var(--gray-500);
                        font-size: 0.9rem;
                    }

                    /* Category colors */
                    .category-weight_loss {
                        background: linear-gradient(135deg, #EF4444, #DC2626);
                    }

                    .category-weight_gain {
                        background: linear-gradient(135deg, #10B981, #059669);
                    }

                    .category-muscle_building {
                        background: linear-gradient(135deg, #6366F1, #4F46E5);
                    }

                    .category-diabetes {
                        background: linear-gradient(135deg, #F59E0B, #D97706);
                    }

                    .category-heart_health {
                        background: linear-gradient(135deg, #EC4899, #DB2777);
                    }

                    .category-keto {
                        background: linear-gradient(135deg, #8B5CF6, #7C3AED);
                    }

                    .category-vegan {
                        background: linear-gradient(135deg, #22C55E, #16A34A);
                    }

                    .category-vegetarian {
                        background: linear-gradient(135deg, #84CC16, #65A30D);
                    }

                    .category-general_health {
                        background: linear-gradient(135deg, #06B6D4, #0891B2);
                    }

                    .category-detox {
                        background: linear-gradient(135deg, #14B8A6, #0D9488);
                    }

                    .category-athletic {
                        background: linear-gradient(135deg, #F97316, #EA580C);
                    }

                    .category-pregnancy {
                        background: linear-gradient(135deg, #F472B6, #EC4899);
                    }

                    .category-paleo {
                        background: linear-gradient(135deg, #A3E635, #84CC16);
                    }

                    .category-gluten_free {
                        background: linear-gradient(135deg, #38BDF8, #0EA5E9);
                    }

                    .category-lactose_free {
                        background: linear-gradient(135deg, #60A5FA, #3B82F6);
                    }

                    .category-halal {
                        background: linear-gradient(135deg, #818CF8, #6366F1);
                    }

                    /* Modal for template details */
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
                        padding: 1rem;
                    }

                    .modal-overlay.active {
                        display: flex;
                    }

                    .modal-content {
                        background: white;
                        border-radius: var(--radius-xl);
                        max-width: 700px;
                        width: 100%;
                        max-height: 90vh;
                        overflow-y: auto;
                    }

                    .modal-header {
                        padding: 1.5rem;
                        border-bottom: 1px solid var(--gray-200);
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-start;
                    }

                    .modal-body {
                        padding: 1.5rem;
                    }

                    .modal-close {
                        background: none;
                        border: none;
                        font-size: 1.5rem;
                        cursor: pointer;
                        color: var(--gray-400);
                    }

                    .modal-close:hover {
                        color: var(--gray-600);
                    }

                    .detail-section {
                        margin-bottom: 1.5rem;
                    }

                    .detail-section h4 {
                        font-size: 0.85rem;
                        text-transform: uppercase;
                        color: var(--gray-500);
                        margin-bottom: 0.75rem;
                        letter-spacing: 0.05em;
                    }

                    .meal-detail {
                        background: var(--gray-50);
                        padding: 1rem;
                        border-radius: var(--radius-lg);
                        margin-bottom: 0.75rem;
                    }

                    .meal-detail-header {
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                        font-weight: 600;
                        color: var(--gray-700);
                        margin-bottom: 0.5rem;
                    }

                    .meal-detail-content {
                        color: var(--gray-600);
                        font-size: 0.9rem;
                        line-height: 1.6;
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
                                <h1><i class="ph ph-book-open" style="color: var(--primary);"></i> Modèles de Plans Alimentaires
                                </h1>
                                <p>Choisissez parmi plus de 50 plans nutritionnels conçus par des professionnels pour vos patients.</p>
                            </div>

                            <!-- Search and Filter -->
                            <div class="templates-header">
                                <div class="search-filter-bar">
                                    <form action="${pageContext.request.contextPath}/nutritionist/dietTemplates"
                                        method="GET" class="search-box">
                                        <i class="ph ph-magnifying-glass"></i>
                                        <input type="text" name="search" class="input" placeholder="Rechercher des modèles..."
                                            value="${searchQuery}">
                                    </form>
                                    <select class="input category-filter" onchange="filterByCategory(this.value)">
                                        <option value="">Toutes les Catégories</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat}" ${selectedCategory==cat ? 'selected' : '' }>
                                                ${fn:replace(cat, '_', ' ')}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <a href="${pageContext.request.contextPath}/nutritionist/assignDiet"
                                    class="btn btn-primary">
                                    <i class="ph ph-plus"></i> Attribuer à un Patient
                                </a>
                            </div>

                            <p class="results-count mb-4">
                                <c:choose>
                                    <c:when test="${not empty templates}">
                                        Affichage de ${fn:length(templates)} modèle(s)
                                        <c:if test="${not empty selectedCategory}"> dans la catégorie
                                            "${fn:replace(selectedCategory, '_', ' ')}"</c:if>
                                        <c:if test="${not empty searchQuery}"> correspondant à "${searchQuery}"</c:if>
                                    </c:when>
                                    <c:otherwise>
                                        Aucun modèle trouvé
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <!-- Templates Grid -->
                            <c:choose>
                                <c:when test="${not empty templates}">
                                    <div class="templates-grid">
                                        <c:forEach var="template" items="${templates}">
                                            <div class="template-card animate-fade-in" data-id="${template.id}"
                                                data-name="${fn:escapeXml(template.name)}"
                                                data-category="${fn:replace(template.category, '_', ' ')}"
                                                data-goal="${fn:escapeXml(template.targetGoal)}"
                                                data-calories="${template.caloriesPerDay}"
                                                data-days="${template.durationDays}"
                                                data-breakfast="${fn:escapeXml(template.breakfast)}"
                                                data-lunch="${fn:escapeXml(template.lunch)}"
                                                data-dinner="${fn:escapeXml(template.dinner)}"
                                                data-morning-snack="${fn:escapeXml(template.morningSnack)}"
                                                data-afternoon-snack="${fn:escapeXml(template.afternoonSnack)}"
                                                data-evening-snack="${fn:escapeXml(template.eveningSnack)}"
                                                data-suitable="${fn:escapeXml(template.suitableFor)}"
                                                data-nutrition="${fn:escapeXml(template.nutritionInfo)}"
                                                data-notes="${fn:escapeXml(template.notes)}">
                                                <div class="template-header category-${template.category}">
                                                    <span class="template-category">${fn:replace(template.category, '_',
                                                        ' ')}</span>
                                                    <div class="template-name">${template.name}</div>
                                                    <div class="template-goal">${template.targetGoal}</div>
                                                </div>
                                                <div class="template-body">
                                                    <div class="template-stats">
                                                        <div class="stat-item">
                                                            <i class="ph ph-fire"></i>
                                                            ${template.caloriesPerDay} kcal/jour
                                                        </div>
                                                        <div class="stat-item">
                                                            <i class="ph ph-calendar"></i>
                                                            ${template.durationDays} jours
                                                        </div>
                                                    </div>

                                                    <c:if
                                                        test="${not empty template.restrictions && template.restrictions != 'none'}">
                                                        <div class="restrictions-tags">
                                                            <c:forTokens var="restriction"
                                                                items="${template.restrictions}" delims=",">
                                                                <span
                                                                    class="restriction-tag ${fn:toLowerCase(fn:replace(fn:trim(restriction), '-', '_'))}">
                                                                    <i class="ph ph-check-circle"></i>
                                                                    ${fn:trim(restriction)}
                                                                </span>
                                                            </c:forTokens>
                                                        </div>
                                                    </c:if>

                                                    <div class="meals-preview">
                                                        <div class="meal-preview-item">
                                                            <div class="meal-preview-icon breakfast">
                                                                <i class="ph ph-sun-horizon"></i>
                                                            </div>
                                                            <div class="meal-preview-text">${template.breakfast}</div>
                                                        </div>
                                                        <div class="meal-preview-item">
                                                            <div class="meal-preview-icon lunch">
                                                                <i class="ph ph-sun"></i>
                                                            </div>
                                                            <div class="meal-preview-text">${template.lunch}</div>
                                                        </div>
                                                        <div class="meal-preview-item">
                                                            <div class="meal-preview-icon dinner">
                                                                <i class="ph ph-moon-stars"></i>
                                                            </div>
                                                            <div class="meal-preview-text">${template.dinner}</div>
                                                        </div>
                                                    </div>

                                                    <div class="template-footer">
                                                        <button type="button" class="btn btn-ghost"
                                                            onclick="showDetails(this.closest('.template-card'))">
                                                            <i class="ph ph-eye"></i> Voir Détails
                                                        </button>
                                                        <a href="${pageContext.request.contextPath}/nutritionist/assignDiet?templateId=${template.id}"
                                                            class="btn btn-primary">
                                                            <i class="ph ph-user-plus"></i> Utiliser Modèle
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <i class="ph ph-magnifying-glass"></i>
                                        <h3>Aucun Modèle Trouvé</h3>
                                        <p>Essayez d'ajuster votre recherche ou vos critères de filtrage.</p>
                                        <a href="${pageContext.request.contextPath}/nutritionist/dietTemplates"
                                            class="btn btn-primary mt-4">
                                            Voir tous les Modèles
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </main>
                </div>

                <!-- Template Details Modal -->
                <div class="modal-overlay" id="detailsModal">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div>
                                <h2 id="modalTitle">Nom du Modèle</h2>
                                <p id="modalCategory" style="color: var(--gray-500);"></p>
                            </div>
                            <button class="modal-close" onclick="closeModal()">
                                <i class="ph ph-x"></i>
                            </button>
                        </div>
                        <div class="modal-body" id="modalBody">
                            <!-- Filled by JavaScript -->
                        </div>
                    </div>
                </div>

                <script>
                    function filterByCategory(category) {
                        var url = new URL(window.location.href);
                        if (category) {
                            url.searchParams.set('category', category);
                        } else {
                            url.searchParams.delete('category');
                        }
                        url.searchParams.delete('search');
                        window.location.href = url.toString();
                    }

                    function showDetails(card) {
                        var data = card.dataset;
                        var templateId = data.id;

                        document.getElementById('modalTitle').textContent = data.name;
                        document.getElementById('modalCategory').textContent = data.category;

                        var html = '<div class="detail-section">' +
                            '<h4>Aperçu</h4>' +
                            '<p style="color: var(--gray-600); margin-bottom: 1rem;">' + data.goal + '</p>' +
                            '<div class="template-stats" style="display: flex; gap: 2rem; flex-wrap: wrap;">' +
                            '<div class="stat-item"><i class="ph ph-fire"></i> ' + data.calories + ' kcal/jour</div>' +
                            '<div class="stat-item"><i class="ph ph-calendar"></i> ' + data.days + ' jours recommandés</div>' +
                            '<div class="stat-item"><i class="ph ph-chart-pie-slice"></i> ' + data.nutrition + '</div>' +
                            '</div>' +
                            '</div>';

                        html += '<div class="detail-section">' +
                            '<h4>Plan de Repas Quotidien</h4>' +
                            '<div class="meal-detail">' +
                            '<div class="meal-detail-header">' +
                            '<div class="meal-preview-icon breakfast"><i class="ph ph-sun-horizon"></i></div>' +
                            'Petit-déjeuner' +
                            '</div>' +
                            '<div class="meal-detail-content">' + data.breakfast + '</div>' +
                            '</div>';

                        if (data.morningSnack) {
                            html += '<div class="meal-detail">' +
                                '<div class="meal-detail-header">' +
                                '<div class="meal-preview-icon" style="background: #FEF3C7; color: #D97706;"><i class="ph ph-cookie"></i></div>' +
                                'Collation du Matin' +
                                '</div>' +
                                '<div class="meal-detail-content">' + data.morningSnack + '</div>' +
                                '</div>';
                        }

                        html += '<div class="meal-detail">' +
                            '<div class="meal-detail-header">' +
                            '<div class="meal-preview-icon lunch"><i class="ph ph-sun"></i></div>' +
                            'Déjeuner' +
                            '</div>' +
                            '<div class="meal-detail-content">' + data.lunch + '</div>' +
                            '</div>';

                        if (data.afternoonSnack) {
                            html += '<div class="meal-detail">' +
                                '<div class="meal-detail-header">' +
                                '<div class="meal-preview-icon" style="background: #D1FAE5; color: #059669;"><i class="ph ph-coffee"></i></div>' +
                                'Collation de l\'Après-midi' +
                                '</div>' +
                                '<div class="meal-detail-content">' + data.afternoonSnack + '</div>' +
                                '</div>';
                        }

                        html += '<div class="meal-detail">' +
                            '<div class="meal-detail-header">' +
                            '<div class="meal-preview-icon dinner"><i class="ph ph-moon-stars"></i></div>' +
                            'Dîner' +
                            '</div>' +
                            '<div class="meal-detail-content">' + data.dinner + '</div>' +
                            '</div>';

                        if (data.eveningSnack) {
                            html += '<div class="meal-detail">' +
                                '<div class="meal-detail-header">' +
                                '<div class="meal-preview-icon" style="background: #E0E7FF; color: #4F46E5;"><i class="ph ph-moon"></i></div>' +
                                'Collation du Soir' +
                                '</div>' +
                                '<div class="meal-detail-content">' + data.eveningSnack + '</div>' +
                                '</div>';
                        }

                        html += '</div>';

                        html += '<div class="detail-section">' +
                            '<h4>Convient Pour</h4>' +
                            '<p style="color: var(--gray-600);">' + data.suitable + '</p>' +
                            '</div>';

                        if (data.notes) {
                            html += '<div class="detail-section">' +
                                '<h4>Notes & Recommandations</h4>' +
                                '<p style="color: var(--gray-600);">' + data.notes + '</p>' +
                                '</div>';
                        }

                        html += '<div style="padding-top: 1rem; border-top: 1px solid var(--gray-200);">' +
                            '<a href="${pageContext.request.contextPath}/nutritionist/assignDiet?templateId=' + templateId + '" class="btn btn-primary" style="width: 100%;">' +
                            '<i class="ph ph-user-plus"></i> Attribuer ce Modèle à un Patient' +
                            '</a>' +
                            '</div>';

                        document.getElementById('modalBody').innerHTML = html;
                        document.getElementById('detailsModal').classList.add('active');
                    }

                    function closeModal() {
                        document.getElementById('detailsModal').classList.remove('active');
                    }

                    // Close modal when clicking outside
                    document.getElementById('detailsModal').addEventListener('click', function (e) {
                        if (e.target === this) {
                            closeModal();
                        }
                    });

                    // Close modal with Escape key
                    document.addEventListener('keydown', function (e) {
                        if (e.key === 'Escape') {
                            closeModal();
                        }
                    });
                </script>
            </body>

            </html>