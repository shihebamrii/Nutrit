<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un Plan Alimentaire - Nutrit</title>
    <meta name="description" content="Créez un plan alimentaire personnalisé pour votre patient">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .patient-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: linear-gradient(135deg, var(--primary-light), var(--white));
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
            border: 1px solid var(--primary);
        }
        
        .patient-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            font-weight: 600;
        }
        
        .patient-details h3 {
            margin: 0;
            color: var(--gray-800);
        }
        
        .patient-details p {
            margin: 0;
            color: var(--gray-600);
            font-size: 0.875rem;
        }
        
        .meal-times-selector {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            padding: 1.25rem;
            background: var(--gray-50);
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
        }
        
        .meal-time-checkbox {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.25rem;
            background: var(--white);
            border: 2px solid var(--gray-200);
            border-radius: var(--radius-lg);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .meal-time-checkbox:hover {
            border-color: var(--primary);
        }
        
        .meal-time-checkbox.checked {
            border-color: var(--primary);
            background: var(--primary-light);
        }
        
        .meal-time-checkbox input {
            display: none;
        }
        
        .meal-time-checkbox .icon {
            width: 32px;
            height: 32px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
        }
        
        .meal-time-checkbox .icon.morning { background: #FEF3C7; color: #D97706; }
        .meal-time-checkbox .icon.noon { background: #D1FAE5; color: #059669; }
        .meal-time-checkbox .icon.night { background: #E0E7FF; color: #4F46E5; }
        .meal-time-checkbox .icon.snacks { background: #FCE7F3; color: #DB2777; }
        
        .meal-section {
            background: var(--white);
            border-radius: var(--radius-xl);
            border: 1px solid var(--gray-200);
            margin-bottom: 1.5rem;
            overflow: hidden;
            display: none;
        }
        
        .meal-section.active {
            display: block;
        }
        
        .meal-section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.25rem;
            background: var(--gray-50);
            border-bottom: 1px solid var(--gray-200);
        }
        
        .meal-section-header .icon {
            width: 36px;
            height: 36px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.125rem;
        }
        
        .meal-section-header h4 {
            margin: 0;
            color: var(--gray-800);
        }
        
        .meal-section-body {
            padding: 1.25rem;
        }
        
        .food-items-container {
            min-height: 100px;
        }
        
        .food-item-row {
            display: grid;
            grid-template-columns: 1fr 100px 150px 40px;
            gap: 0.75rem;
            align-items: center;
            padding: 0.75rem;
            background: var(--gray-50);
            border-radius: var(--radius-lg);
            margin-bottom: 0.5rem;
        }
        
        .food-item-row select, 
        .food-item-row input {
            padding: 0.5rem 0.75rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: 0.875rem;
        }
        
        .remove-item-btn {
            width: 32px;
            height: 32px;
            border: none;
            background: red;
            color: white;
            border-radius: var(--radius-md);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .add-food-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            width: 100%;
            padding: 0.75rem;
            border: 2px dashed var(--gray-300);
            background: transparent;
            border-radius: var(--radius-lg);
            color: var(--gray-600);
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 0.5rem;
        }
        
        .add-food-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-light);
        }
        
        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gray-200);
            margin-top: 1.5rem;
        }
        
        .existing-plan-warning {
            background: #FEF3C7;
            border: 1px solid #F59E0B;
            color: #92400E;
            padding: 1rem 1.25rem;
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
    </style>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
        
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp"/>
            
            <div class="page-content" style="max-width: 1200px; margin: 0 auto;">
                <!-- Page Header -->
                <div class="page-header">
                    <h1><i class="ph ph-plus-circle" style="color: var(--primary);"></i> Créer un Plan Alimentaire</h1>
                    <p>Concevez un horaire de repas personnalisé pour votre patient.</p>
                </div>
                
                <!-- Patient Info -->
                <div class="patient-info">
                    <div class="patient-avatar">
                        ${patient.fullName.substring(0, 1).toUpperCase()}
                    </div>
                    <div class="patient-details">
                        <h3>${patient.fullName}</h3>
                        <p>${patient.email}</p>
                    </div>
                </div>
                
                <!-- Existing Plan Warning -->
                <c:if test="${existingPlan != null}">
                    <div class="existing-plan-warning">
                        <i class="ph ph-warning" style="font-size: 1.25rem;"></i>
                        <div>
                            <strong>Ce patient possède déjà un plan alimentaire actif.</strong>
                            La création d'un nouveau plan désactivera le plan existant.
                        </div>
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/nutritionist/mealPlan/create" method="POST" id="mealPlanForm">
                    <input type="hidden" name="patientId" value="${patient.id}">
                    
                    <!-- Step 1: Plan Duration -->
                    <div class="card mb-4">
                        <h3 class="mb-3"><i class="ph ph-calendar"></i> Étape 1 : Calendrier du Plan</h3>
                        <p class="text-muted mb-4">Choisissez la durée pendant laquelle le patient doit suivre ce plan :</p>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                            <div>
                                <label class="label">Date de Début</label>
                                <input type="date" name="startDate" class="input" required id="startDate">
                            </div>
                            <div>
                                <label class="label">Date de Fin</label>
                                <input type="date" name="endDate" class="input" required id="endDate">
                            </div>
                        </div>
                    </div>

                    <!-- Step 2: Select Meal Times -->
                    <div class="card mb-4">
                        <h3 class="mb-3"><i class="ph ph-clock"></i> Étape 2 : Sélectionner les Moments des Repas</h3>
                        <p class="text-muted mb-4">Choisissez les moments des repas que le patient doit suivre :</p>
                        
                        <div class="meal-times-selector">
                            <label class="meal-time-checkbox" onclick="toggleMealTime('morning')">
                                <input type="checkbox" name="mealTimes" value="morning" id="check_morning">
                                <div class="icon morning"><i class="ph ph-sun-horizon"></i></div>
                                <span>Matin (Petit-déjeuner)</span>
                            </label>
                            
                            <label class="meal-time-checkbox" onclick="toggleMealTime('noon')">
                                <input type="checkbox" name="mealTimes" value="noon" id="check_noon">
                                <div class="icon noon"><i class="ph ph-sun"></i></div>
                                <span>Midi (Déjeuner)</span>
                            </label>
                            
                            <label class="meal-time-checkbox" onclick="toggleMealTime('night')">
                                <input type="checkbox" name="mealTimes" value="night" id="check_night">
                                <div class="icon night"><i class="ph ph-moon-stars"></i></div>
                                <span>Soir (Dîner)</span>
                            </label>
                            
                            <label class="meal-time-checkbox" onclick="toggleMealTime('snacks')">
                                <input type="checkbox" name="mealTimes" value="snacks" id="check_snacks">
                                <div class="icon snacks"><i class="ph ph-cookie"></i></div>
                                <span>Collations</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Step 2: Add Foods to Each Meal Time -->
                    <div class="card mb-4">
                        <h3 class="mb-3"><i class="ph ph-fork-knife"></i> Étape 3 : Ajouter des Aliments</h3>
                        <p class="text-muted mb-4">Sélectionnez des aliments et spécifiez les portions pour chaque repas :</p>
                        
                        <!-- Morning Section -->
                        <div class="meal-section" id="section_morning">
                            <div class="meal-section-header">
                                <div class="icon" style="background: #FEF3C7; color: #D97706;">
                                    <i class="ph ph-sun-horizon"></i>
                                </div>
                                <h4>Matin (Petit-déjeuner)</h4>
                            </div>
                            <div class="meal-section-body">
                                <div class="food-items-container" id="foods_morning"></div>
                                <button type="button" class="add-food-btn" onclick="addFoodItem('morning')">
                                    <i class="ph ph-plus"></i> Ajouter un Aliment
                                </button>
                            </div>
                        </div>
                        
                        <!-- Noon Section -->
                        <div class="meal-section" id="section_noon">
                            <div class="meal-section-header">
                                <div class="icon" style="background: #D1FAE5; color: #059669;">
                                    <i class="ph ph-sun"></i>
                                </div>
                                <h4>Midi (Déjeuner)</h4>
                            </div>
                            <div class="meal-section-body">
                                <div class="food-items-container" id="foods_noon"></div>
                                <button type="button" class="add-food-btn" onclick="addFoodItem('noon')">
                                    <i class="ph ph-plus"></i> Ajouter un Aliment
                                </button>
                            </div>
                        </div>
                        
                        <!-- Night Section -->
                        <div class="meal-section" id="section_night">
                            <div class="meal-section-header">
                                <div class="icon" style="background: #E0E7FF; color: #4F46E5;">
                                    <i class="ph ph-moon-stars"></i>
                                </div>
                                <h4>Soir (Dîner)</h4>
                            </div>
                            <div class="meal-section-body">
                                <div class="food-items-container" id="foods_night"></div>
                                <button type="button" class="add-food-btn" onclick="addFoodItem('night')">
                                    <i class="ph ph-plus"></i> Ajouter un Aliment
                                </button>
                            </div>
                        </div>
                        
                        <!-- Snacks Section -->
                        <div class="meal-section" id="section_snacks">
                            <div class="meal-section-header">
                                <div class="icon" style="background: #FCE7F3; color: #DB2777;">
                                    <i class="ph ph-cookie"></i>
                                </div>
                                <h4>Collations</h4>
                            </div>
                            <div class="meal-section-body">
                                <div class="food-items-container" id="foods_snacks"></div>
                                <button type="button" class="add-food-btn" onclick="addFoodItem('snacks')">
                                    <i class="ph ph-plus"></i> Ajouter un Aliment
                                </button>
                            </div>
                        </div>
                    </div>
                    

                    
                    <!-- Step 4: Notes -->
                    <div class="card mb-4">
                        <h3 class="mb-3"><i class="ph ph-note"></i> Étape 4 : Notes Additionnelles</h3>
                        <textarea name="notes" class="input" rows="3" 
                                  placeholder="Ajoutez toute instruction spéciale ou note pour le patient..."></textarea>
                    </div>
                    
                    <!-- Form Footer -->
                    <div class="form-footer">
                        <a href="${pageContext.request.contextPath}/nutritionist/mealPlan" class="btn btn-ghost">
                            <i class="ph ph-arrow-left"></i> Annuler
                        </a>
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="ph ph-check-circle"></i> Créer le Plan Alimentaire
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <!-- Store food items and portion units as JSON for JavaScript -->
    <script>
        // Food items from database
        const foodItems = [
            <c:forEach var="food" items="${foodItems}" varStatus="status">
                {
                    id: ${food.id},
                    name: "${food.name}",
                    nameAr: "${food.nameAr != null ? food.nameAr : ''}",
                    category: "${food.category}",
                    calories: ${food.caloriesPer100g},
                    idealMoment: "${food.idealMoment != null ? food.idealMoment : ''}",
                    portionUnit: "${food.portionUnit}",
                    defaultPortion: ${food.defaultPortion},
                    imagePath: "${food.imagePath != null ? food.imagePath : ''}"
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Portion units from database
        const portionUnits = [
            <c:forEach var="unit" items="${portionUnits}" varStatus="status">
                {
                    id: ${unit.id},
                    name: "${unit.name}",
                    abbr: "${unit.abbreviation}"
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        // Generate food select options HTML
        function getFoodOptionsHtml(mealTime) {
            if (!foodItems || foodItems.length === 0) {
                console.error('No food items available!');
                return '<option value="">-- Aucun Aliment Disponible --</option>';
            }
            
            // Convert English meal time to French for filtering
            const mealTimeMap = {
                'morning': 'matin',
                'noon': 'midi',
                'night': 'soir',
                'snacks': 'collation'
            };
            const frenchMealTime = mealTimeMap[mealTime] || mealTime;
            
            // Filter foods appropriate for this meal time
            let filteredFoods = foodItems;
            if (frenchMealTime && frenchMealTime !== '') {
                filteredFoods = foodItems.filter(f => {
                    if (!f.idealMoment || f.idealMoment === '') return true; // Include if no restriction
                    return f.idealMoment.includes(frenchMealTime);
                });
            }
            
            if (filteredFoods.length === 0) {
                console.warn('No foods found for meal time:', mealTime, '(' + frenchMealTime + ')');
                return '<option value="">-- Aucun Aliment pour ce Repas --</option>';
            }
            
            let html = '<option value="">-- Sélectionner un Aliment --</option>';
            
            // Group by category
            const categories = [...new Set(filteredFoods.map(f => f.category))].filter(c => c); // Remove empty categories
            
            if (categories.length === 0) {
                console.error('No categories found!');
                return html;
            }
            
            categories.forEach(cat => {
                const categoryFoods = filteredFoods.filter(f => f.category === cat);
                if (categoryFoods.length > 0) {
                    // Capitalize category name
                    const catLabel = cat.charAt(0).toUpperCase() + cat.slice(1);
                    html += '<optgroup label="' + catLabel + '">';
                    categoryFoods.forEach(food => {
                        // Show French name, Arabic name (if available), and calories
                        let displayText = food.name;
                        if (food.nameAr && food.nameAr !== '') {
                            displayText += ' - ' + food.nameAr;
                        }
                        displayText += ' (' + food.calories + ' cal)';
                        html += '<option value="' + food.id + '">' + displayText + '</option>';
                    });
                    html += '</optgroup>';
                }
            });
            
            console.log('Generated', filteredFoods.length, 'food options for', mealTime, 'with', categories.length, 'categories');
            return html;
        }
        
        // Generate portion units select options HTML
        function getUnitOptionsHtml() {
            let html = '';
            portionUnits.forEach(unit => {
                // Default to grams
                const selected = unit.abbr === 'g' ? 'selected' : '';
                html += '<option value="' + unit.id + '" ' + selected + '>' + unit.abbr + '</option>';
            });
            return html;
        }
        
        // Toggle meal time section visibility
        function toggleMealTime(mealTime) {
            const checkbox = document.getElementById('check_' + mealTime);
            const section = document.getElementById('section_' + mealTime);
            const label = checkbox.closest('.meal-time-checkbox');
            
            // Toggle checkbox manually since we're handling the click
            checkbox.checked = !checkbox.checked;
            
            if (checkbox.checked) {
                section.classList.add('active');
                label.classList.add('checked');
                // Add first food item if empty
                const container = document.getElementById('foods_' + mealTime);
                if (container.children.length === 0) {
                    addFoodItem(mealTime);
                }
            } else {
                section.classList.remove('active');
                label.classList.remove('checked');
            }
        }
        
        // Add a new food item row with 2 alternatives (Main + 1 Alternative)
        function addFoodItem(mealTime) {
            const container = document.getElementById('foods_' + mealTime);
            const row = document.createElement('div');
            row.className = 'food-item-row';
            row.style.display = 'block'; // Block display for better structure
            row.style.padding = '1rem';
            
            // Generate food options HTML filtered by meal time
            const foodOptions = getFoodOptionsHtml(mealTime);
            
            // Build HTML string with proper variable concatenation (2 options only)
            let html = '<div style="display: flex; gap: 0.5rem; justify-content: flex-end; margin-bottom: 0.5rem;">' +
                    '<button type="button" class="remove-item-btn" onclick="removeItem(this)" title="Supprimer la ligne">' +
                        '<i class="ph ph-x"></i>' +
                    '</button>' +
                '</div>' +
                
                '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">' +
                    '<!-- Option 1 (Principal) -->' +
                    '<div style="background: white; padding: 0.5rem; border-radius: 8px; border: 1px solid #e5e7eb;">' +
                        '<label class="label" style="font-size: 0.75rem; color: var(--primary);">Option 1 (Principal)</label>' +
                        '<select name="food_' + mealTime + '_1" class="input" style="margin-bottom: 0.5rem;" required onchange="updateCalorieDisplay(this)">' +
                            foodOptions +
                        '</select>' +
                        '<div style="display: flex; align-items: center; gap: 0.5rem;">' +
                            '<input type="number" name="qty_' + mealTime + '_1" value="100" min="1" class="input" required style="flex: 1;">' +
                            '<span class="unit-display" style="min-width: 40px; font-size: 0.85rem; color: #6b7280;">g</span>' +
                        '</div>' +
                        '<div class="text-xs text-muted mt-1 cal-display">0 cal</div>' +
                    '</div>' +
                    
                    '<!-- Option 2 (Alternative) -->' +
                    '<div style="background: white; padding: 0.5rem; border-radius: 8px; border: 1px solid #e5e7eb;">' +
                        '<label class="label" style="font-size: 0.75rem; color: #6b7280;">Option 2 (Ou)</label>' +
                        '<select name="food_' + mealTime + '_2" class="input" style="margin-bottom: 0.5rem;" onchange="updateCalorieDisplay(this)">' +
                            foodOptions +
                        '</select>' +
                        '<div style="display: flex; align-items: center; gap: 0.5rem;">' +
                            '<input type="number" name="qty_' + mealTime + '_2" value="100" min="1" class="input" style="flex: 1;">' +
                            '<span class="unit-display" style="min-width: 40px; font-size: 0.85rem; color: #6b7280;">g</span>' +
                        '</div>' +
                        '<div class="text-xs text-muted mt-1 cal-display">0 cal</div>' +
                    '</div>' +

                    '<!-- Option 3 (Alternative) -->' +
                    '<div style="background: white; padding: 0.5rem; border-radius: 8px; border: 1px solid #e5e7eb;">' +
                        '<label class="label" style="font-size: 0.75rem; color: #6b7280;">Option 3 (Ou)</label>' +
                        '<select name="food_' + mealTime + '_3" class="input" style="margin-bottom: 0.5rem;" onchange="updateCalorieDisplay(this)">' +
                            foodOptions +
                        '</select>' +
                        '<div style="display: flex; align-items: center; gap: 0.5rem;">' +
                            '<input type="number" name="qty_' + mealTime + '_3" value="100" min="1" class="input" style="flex: 1;">' +
                            '<span class="unit-display" style="min-width: 40px; font-size: 0.85rem; color: #6b7280;">g</span>' +
                        '</div>' +
                        '<div class="text-xs text-muted mt-1 cal-display">0 cal</div>' +
                    '</div>' +

                    '<!-- Option 4 (Alternative) -->' +
                    '<div style="background: white; padding: 0.5rem; border-radius: 8px; border: 1px solid #e5e7eb;">' +
                        '<label class="label" style="font-size: 0.75rem; color: #6b7280;">Option 4 (Ou)</label>' +
                        '<select name="food_' + mealTime + '_4" class="input" style="margin-bottom: 0.5rem;" onchange="updateCalorieDisplay(this)">' +
                            foodOptions +
                        '</select>' +
                        '<div style="display: flex; align-items: center; gap: 0.5rem;">' +
                            '<input type="number" name="qty_' + mealTime + '_4" value="100" min="1" class="input" style="flex: 1;">' +
                            '<span class="unit-display" style="min-width: 40px; font-size: 0.85rem; color: #6b7280;">g</span>' +
                        '</div>' +
                        '<div class="text-xs text-muted mt-1 cal-display">0 cal</div>' +
                    '</div>' +
                '</div>';
            
            row.innerHTML = html;
            container.appendChild(row);
            
            console.log('Added food item row for', mealTime, 'with 2 alternatives');
        }
        
        // Remove a food item row
        function removeItem(btn) {
            btn.closest('.food-item-row').remove();
        }

        // Auto-suggest meals based on target calories
        function autoSuggestMeal(mealTime) {
            // Get target calories from input
            const calInput = document.getElementById('cal_' + mealTime);
            if (!calInput) {
                alert('Veuillez d\'abord définir les calories cibles');
                return;
            }
            const targetCalories = parseInt(calInput.value) || 400;
            
            // Convert English meal time to French for filtering
            const mealTimeMap = {
                'morning': 'matin',
                'noon': 'midi',
                'night': 'soir',
                'snacks': 'collation'
            };
            const frenchMealTime = mealTimeMap[mealTime] || mealTime;
            
            // Filter foods for this meal time
            const mealFoods = foodItems.filter(f => {
                if (!f.idealMoment || f.idealMoment === '') return true;
                return f.idealMoment.includes(frenchMealTime);
            });
            
            if (mealFoods.length === 0) {
                alert('Aucun aliment disponible pour ce moment de repas');
                return;
            }
            
            // Define category priorities for each meal type
            const categoryPriority = {
                'morning': ['glucides', 'proteines', 'fruits', 'laitier'],
                'noon': ['proteines', 'glucides', 'legumes', 'lipides'],
                'night': ['proteines', 'legumes', 'glucides'],
                'snacks': ['fruits', 'laitier', 'lipides', 'collation']
            };
            
            const categories = categoryPriority[mealTime] || ['proteines', 'glucides', 'legumes'];
            
            // Build a balanced meal (2-3 items)
            function buildMeal(calorieTarget) {
                let meal = [];
                let remainingCal = calorieTarget;
                let usedIds = [];
                
                // Try to get one food from each priority category
                for (let cat of categories) {
                    if (remainingCal <= 50) break;
                    
                    // Find foods in this category that haven't been used
                    const catFoods = mealFoods.filter(f => 
                        f.category === cat && 
                        !usedIds.includes(f.id) &&
                        f.calories > 0
                    );
                    
                    if (catFoods.length > 0) {
                        // Pick a random food from this category
                        const food = catFoods[Math.floor(Math.random() * catFoods.length)];
                        
                        // Calculate portion based on calories
                        // Aim for roughly equal distribution, but at least 50g
                        const calPerItem = remainingCal / (categories.length - meal.length);
                        let portion = Math.round((calPerItem * 100) / food.calories);
                        
                        // Clamp portion between 30g and 300g
                        portion = Math.max(30, Math.min(300, portion));
                        
                        // Adjust remaining calories
                        const actualCal = (portion * food.calories) / 100;
                        remainingCal -= actualCal;
                        
                        meal.push({ food: food, portion: portion });
                        usedIds.push(food.id);
                    }
                }
                
                // If we have remaining calories and less than 3 items, add more
                if (remainingCal > 50 && meal.length < 3) {
                    const extraFoods = mealFoods.filter(f => 
                        !usedIds.includes(f.id) && f.calories > 0
                    );
                    
                    if (extraFoods.length > 0) {
                        const food = extraFoods[Math.floor(Math.random() * extraFoods.length)];
                        let portion = Math.round((remainingCal * 100) / food.calories);
                        portion = Math.max(30, Math.min(300, portion));
                        meal.push({ food: food, portion: portion });
                    }
                }
                
                return meal;
            }
            
            // Build four different meal options
            const meal1 = buildMeal(targetCalories);
            const meal2 = buildMeal(targetCalories);
            const meal3 = buildMeal(targetCalories);
            const meal4 = buildMeal(targetCalories);
            
            // Clear existing food items
            const container = document.getElementById('foods_' + mealTime);
            container.innerHTML = '';
            
            // Add suggested food rows
            if (meal1.length > 0 || meal2.length > 0 || meal3.length > 0 || meal4.length > 0) {
                // Determine max items to show
                const maxItems = Math.max(meal1.length, meal2.length, meal3.length, meal4.length);
                
                for (let i = 0; i < maxItems; i++) {
                    // Add a food row
                    addFoodItem(mealTime);
                    
                    // Get the last added row
                    const rows = container.querySelectorAll('.food-item-row');
                    const lastRow = rows[rows.length - 1];
                    
                    if (lastRow) {
                        // Fill Option 1 (Main) from meal1
                        const select1 = lastRow.querySelector('select[name^="food_' + mealTime + '_1"]');
                        const qty1 = lastRow.querySelector('input[name^="qty_' + mealTime + '_1"]');
                        
                        if (meal1[i] && select1 && qty1) {
                            select1.value = meal1[i].food.id;
                            qty1.value = meal1[i].portion;
                            updateCalorieDisplay(select1);
                        }
                        
                        // Fill Option 2 (Alternative) from meal2
                        const select2 = lastRow.querySelector('select[name^="food_' + mealTime + '_2"]');
                        const qty2 = lastRow.querySelector('input[name^="qty_' + mealTime + '_2"]');
                        
                        if (meal2[i] && select2 && qty2) {
                            select2.value = meal2[i].food.id;
                            qty2.value = meal2[i].portion;
                            updateCalorieDisplay(select2);
                        }

                        // Fill Option 3 (Alternative) from meal3
                        const select3 = lastRow.querySelector('select[name^="food_' + mealTime + '_3"]');
                        const qty3 = lastRow.querySelector('input[name^="qty_' + mealTime + '_3"]');
                        
                        if (meal3[i] && select3 && qty3) {
                            select3.value = meal3[i].food.id;
                            qty3.value = meal3[i].portion;
                            updateCalorieDisplay(select3);
                        }

                        // Fill Option 4 (Alternative) from meal4
                        const select4 = lastRow.querySelector('select[name^="food_' + mealTime + '_4"]');
                        const qty4 = lastRow.querySelector('input[name^="qty_' + mealTime + '_4"]');
                        
                        if (meal4[i] && select4 && qty4) {
                            select4.value = meal4[i].food.id;
                            qty4.value = meal4[i].portion;
                            updateCalorieDisplay(select4);
                        }
                    }
                }
                
                // Calculate and show total calories
                let total1 = meal1.reduce((sum, m) => sum + (m.portion * m.food.calories / 100), 0);
                let total2 = meal2.reduce((sum, m) => sum + (m.portion * m.food.calories / 100), 0);
                let total3 = meal3.reduce((sum, m) => sum + (m.portion * m.food.calories / 100), 0);
                let total4 = meal4.reduce((sum, m) => sum + (m.portion * m.food.calories / 100), 0);
                
                console.log('Auto-suggested for', mealTime + ':', 
                    'Option 1 =', Math.round(total1), 'cal,',
                    'Option 2 =', Math.round(total2), 'cal,',
                    'Option 3 =', Math.round(total3), 'cal,',
                    'Option 4 =', Math.round(total4), 'cal',
                    '(Target:', targetCalories, 'cal)');
            }
        }

        // Add Calorie Inputs and Auto-Suggest buttons to headers
        document.addEventListener('DOMContentLoaded', function() {
            const targets = {
                'morning': 400,
                'noon': 600,
                'night': 500,
                'snacks': 200
            };
            
            for (const [meal, defCal] of Object.entries(targets)) {
                const header = document.querySelector('#section_' + meal + ' h4');
                if (header) {
                    const container = document.createElement('div');
                    container.style.marginLeft = 'auto';
                    container.style.display = 'flex';
                    container.style.alignItems = 'center';
                    container.style.gap = '0.5rem';
                    container.innerHTML = 
                        '<label style="font-size: 0.8rem; margin-right: 0.5rem;">Calories Cibles :</label>' +
                        '<input type="number" id="cal_' + meal + '" name="calories' + meal.charAt(0).toUpperCase() + meal.slice(1) + '" ' +
                               'value="' + defCal + '" style="width: 80px; padding: 4px; border-radius: 4px; border: 1px solid #ccc;">' +
                        '<button type="button" onclick="autoSuggestMeal(\'' + meal + '\')" ' +
                                'style="background: linear-gradient(135deg, #8B5CF6, #6366F1); color: white; border: none; ' +
                                'padding: 6px 12px; border-radius: 6px; cursor: pointer; font-size: 0.75rem; ' +
                                'display: flex; align-items: center; gap: 4px;">' +
                            '<i class="ph ph-magic-wand"></i> Suggestion Auto' +
                        '</button>';
                    header.parentNode.appendChild(container);
                }
            }
        });

        // Update calorie display and unit when food is selected
        function updateCalorieDisplay(select) {
            const foodId = select.value;
            const container = select.parentElement;
            const display = container.querySelector('.cal-display');
            const unitDisplay = container.querySelector('.unit-display');
            const qtyInput = container.querySelector('input[type="number"]');
            
            if (foodId) {
                const food = foodItems.find(f => f.id == foodId);
                if (food) {
                    // Update calorie display with proper unit
                    const unit = food.portionUnit || 'g';
                    display.innerText = food.calories + ' cal / 100' + unit;
                    
                    // Update unit display next to quantity
                    if (unitDisplay) {
                        unitDisplay.innerText = unit;
                    }
                    
                    // Set default portion if available
                    if (qtyInput && food.defaultPortion) {
                        qtyInput.value = food.defaultPortion;
                    }
                }
            } else {
                display.innerText = '0 cal';
                if (unitDisplay) unitDisplay.innerText = 'g';
                if (qtyInput) qtyInput.value = 100;
            }
        }
        
        // Form validation
        document.getElementById('mealPlanForm').addEventListener('submit', function(e) {
            const checkedTimes = document.querySelectorAll('input[name="mealTimes"]:checked');
            if (checkedTimes.length === 0) {
                e.preventDefault();
                alert('Please select at least one meal time.');
                return false;
            }
            
            // Check each enabled time has at least one food
            let hasFood = false;
            checkedTimes.forEach(cb => {
                const mealTime = cb.value;
                // Check if any main food option is selected for this meal time
                const foods = document.querySelectorAll('select[name^="food_' + mealTime + '_1"]');
                foods.forEach(f => {
                    if (f.value) hasFood = true;
                });
            });
            
            if (!hasFood) {
                e.preventDefault();
                alert('Please add at least one food item for the selected meal times.');
                return false;
            }
        });
        
        // Debug: Log if script loaded
        console.log('Meal plan script loaded. Food items:', foodItems.length, 'Portion units:', portionUnits.length);
        // Initialize details
        document.addEventListener('DOMContentLoaded', function() {
            // Set default dates
            const today = new Date();
            const nextWeek = new Date();
            nextWeek.setDate(today.getDate() + 7);
            
            document.getElementById('startDate').valueAsDate = today;
            document.getElementById('endDate').valueAsDate = nextWeek;
            
            // Validate dates on change
            document.getElementById('startDate').addEventListener('change', validateDates);
            document.getElementById('endDate').addEventListener('change', validateDates);
        });
        
        function validateDates() {
            const start = document.getElementById('startDate').value;
            const end = document.getElementById('endDate').value;
            
            if (start && end && start > end) {
                alert('End date cannot be before start date');
                document.getElementById('endDate').value = '';
            }
        }

    </script>
</body>
</html>
