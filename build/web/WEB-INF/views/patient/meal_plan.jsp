<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.nutrit.models.PatientMealPlan" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Meal Plan - Nutrit</title>
    <meta name="description" content="View your personalized meal plan">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .meal-plan-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 2rem;
            border-radius: var(--radius-xl);
            margin-bottom: 2rem;
        }
        
        .meal-plan-header h1 {
            margin: 0 0 0.5rem 0;
            font-size: 1.75rem;
        }
        
        .meal-plan-header p {
            margin: 0;
            opacity: 0.9;
        }
        
        .meal-plan-meta {
            color: var(--gray-800);
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid rgba(255,255,255,0.2);
        }
        
        .meal-plan-meta .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }
        
        .meal-times-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        
        .meal-card {
            background: var(--white);
            border-radius: var(--radius-xl);
            border: 1px solid var(--gray-200);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .meal-card:hover {
            box-shadow: var(--shadow-lg);
        }
        
        .meal-card-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .meal-icon {
            width: 40px;
            height: 40px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }
        
        .meal-icon.morning { background: #FEF3C7; color: #D97706; }
        .meal-icon.noon { background: #D1FAE5; color: #059669; }
        .meal-icon.night { background: #E0E7FF; color: #4F46E5; }
        .meal-icon.snacks { background: #FCE7F3; color: #DB2777; }
        
        .meal-card-header h3 {
            margin: 0;
            font-size: 1.125rem;
            color: var(--gray-800);
        }
        
        .meal-card-body {
            padding: 1.25rem;
        }
        
        .food-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .food-list li {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem;
            background: var(--gray-50);
            border-radius: var(--radius-md);
            margin-bottom: 0.5rem;
            gap: 0.75rem;
        }
        
        .food-list li:last-child {
            margin-bottom: 0;
        }
        
        .food-image {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-md);
            object-fit: cover;
            flex-shrink: 0;
            border: 1px solid var(--gray-200);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .food-image:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .food-info {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-width: 0;
        }
        
        .food-name {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            color: var(--gray-800);
        }
        
        .food-name i {
            color: var(--primary);
        }
        
        .food-portion {
            font-size: 0.875rem;
            color: var(--gray-600);
            background: var(--white);
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            border: 1px solid var(--gray-200);
        }
        
        .food-calories {
            font-size: 0.75rem;
            color: var(--gray-500);
            margin-top: 0.25rem;
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
        
        .nutritionist-note {
            background: var(--primary-light);
            border: 1px solid var(--primary);
            border-radius: var(--radius-lg);
            padding: 1rem 1.25rem;
            margin-top: 1.5rem;
        }
        
        .nutritionist-note h4 {
            margin: 0 0 0.5rem 0;
            color: var(--primary-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .nutritionist-note p {
            margin: 0;
            color: var(--gray-700);
        }

        /* Tracking UI Styles */
        .meal-tracking {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-100);
            display: flex;
            gap: 0.5rem;
        }

        .tracking-btn {
            padding: 0.5rem 1rem;
            border-radius: var(--radius-md);
            border: 2px solid transparent; 
            cursor: pointer;
            font-size: 0.75rem;
            font-weight: 600;
            transition: all var(--transition-fast);
            display: flex;
            align-items: center;
            gap: 0.25rem;
            background: var(--gray-100);
            color: var(--gray-600);
            flex: 1;
            justify-content: center;
        }

        .tracking-btn:hover {
            background: var(--gray-200);
        }

        .tracking-btn.done.active {
            background: var(--success);
            color: white;
            border-color: var(--success);
        }
        .tracking-btn.done:not(.active):hover {
            color: var(--success);
            background: #ecfdf5; 
            border-color: var(--success);
        }

        .tracking-btn.missed.active {
            background: var(--error);
            color: white;
            border-color: var(--error);
        }
        .tracking-btn.missed:not(.active):hover {
            color: var(--error);
            background: #fef2f2; 
            border-color: var(--error);
        }
        
        .tracking-btn i {
             font-size: 1.1em;
        }

        .alternative-input {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            margin-top: 0.5rem;
            font-size: 0.875rem;
            display: none; 
        }

        .alternative-input.show {
            display: block;
        }

        .alternative-display {
            margin-top: 0.5rem;
            background: #fff5f5;
            color: #c53030;
            padding: 0.5rem;
            border-radius: var(--radius-md);
            font-size: 0.875rem;
        }

        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-badge.done {
            background: #d1fae5;
            color: #065f46;
        }

        .status-badge.missed {
            background: #fee2e2;
            color: #991b1b;
        }
        
        /* Image Lightbox Modal */
        .image-lightbox {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.9);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.2s ease;
        }
        
        .image-lightbox.active {
            display: flex;
        }
        
        .lightbox-content {
            position: relative;
            max-width: 90%;
            max-height: 90%;
            animation: zoomIn 0.3s ease;
        }
        
        .lightbox-image {
            max-width: 100%;
            max-height: 90vh;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }
        
        .lightbox-close {
            position: absolute;
            top: -40px;
            right: 0;
            background: white;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--gray-800);
            transition: all 0.2s ease;
        }
        
        .lightbox-close:hover {
            background: var(--error);
            color: white;
            transform: rotate(90deg);
        }
        
        .lightbox-caption {
            position: absolute;
            bottom: -50px;
            left: 0;
            right: 0;
            text-align: center;
            color: white;
            font-size: 1rem;
            font-weight: 500;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes zoomIn {
            from { 
                transform: scale(0.8);
                opacity: 0;
            }
            to { 
                transform: scale(1);
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
        
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp"/>
            
            <div class="page-content">
                <c:choose>
                    <c:when test="${mealPlan != null}">
                        <!-- Meal Plan Header -->
                        <div class="meal-plan-header">
                            <h1><i class="ph ph-bowl-food"></i> Your Meal Plan</h1>
                            <p>Personalized nutrition assigned by your nutritionist</p>
                            
                            <div class="meal-plan-meta">
                                <div class="meta-item">
                                    <i class="ph ph-user-circle"></i>
                                    By: ${mealPlan.nutritionistName}
                                </div>
                                <div class="meta-item">
                                    <i class="ph ph-calendar"></i>
                                    Created: <fmt:formatDate value="${mealPlan.createdAt}" pattern="MMM dd, yyyy"/>
                                </div>
                                <c:if test="${mealPlan.startDate != null}">
                                    <div class="meta-item">
                                        <i class="ph ph-clock"></i>
                                        Valid: <fmt:formatDate value="${mealPlan.startDate}" pattern="MMM dd"/> 
                                        <c:if test="${mealPlan.endDate != null}">
                                            - <fmt:formatDate value="${mealPlan.endDate}" pattern="MMM dd, yyyy"/>
                                        </c:if>
                                    </div>
                                </c:if>
                                <c:if test="${mealPlan.targetWeight > 0}">
                                    <div class="meta-item" style="background: rgba(46, 204, 113, 0.2); border: 1px solid rgba(46, 204, 113, 0.4); padding: 0.5rem 1rem; border-radius: var(--radius-md);">
                                        <i class="ph ph-scales" style="font-size: 1.25rem; color: #2ecc71;"></i>
                                        <strong>Poids Cible:</strong> 
                                        <fmt:formatNumber value="${mealPlan.targetWeight}" maxFractionDigits="1"/> kg
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Meal Cards -->
                        <div class="meal-times-grid">
                            <c:forEach var="mealTime" items="${mealTimes}">
                                <c:if test="${mealPlan.mealTimeEnabled[mealTime]}">
                                    <div class="meal-card animate-fade-in">
                                        <div class="meal-card-header">
                                            <div class="meal-icon ${mealTime}">
                                                <c:choose>
                                                    <c:when test="${mealTime == 'morning'}"><i class="ph ph-sun-horizon"></i></c:when>
                                                    <c:when test="${mealTime == 'noon'}"><i class="ph ph-sun"></i></c:when>
                                                    <c:when test="${mealTime == 'night'}"><i class="ph ph-moon-stars"></i></c:when>
                                                    <c:when test="${mealTime == 'snacks'}"><i class="ph ph-cookie"></i></c:when>
                                                </c:choose>
                                            </div>
                                            <h3>
                                                <c:choose>
                                                    <c:when test="${mealTime == 'morning'}">Morning (Breakfast)</c:when>
                                                    <c:when test="${mealTime == 'noon'}">Noon (Lunch)</c:when>
                                                    <c:when test="${mealTime == 'night'}">Night (Dinner)</c:when>
                                                    <c:when test="${mealTime == 'snacks'}">Snacks</c:when>
                                                </c:choose>
                                            </h3>
                                            
                                            <!-- Meal Calorie Target with Scale Icon -->
                                            <div class="meal-target-calories" style="margin-left: auto; font-size: 0.85rem; color: var(--text-muted); display: flex; align-items: center; gap: 0.4rem; background: rgba(0,0,0,0.05); padding: 2px 8px; border-radius: 10px;">
                                                <i class="ph ph-scales" style="color: var(--primary); font-size: 1rem;"></i>
                                                <span style="font-weight: 600;">Cible: 
                                                    <c:choose>
                                                        <c:when test="${mealTime == 'morning'}">${mealPlan.caloriesMatin}</c:when>
                                                        <c:when test="${mealTime == 'noon'}">${mealPlan.caloriesMidi}</c:when>
                                                        <c:when test="${mealTime == 'night'}">${mealPlan.caloriesSoir}</c:when>
                                                        <c:when test="${mealTime == 'snacks'}">${mealPlan.caloriesCollation}</c:when>
                                                    </c:choose>
                                                    kcal
                                                </span>
                                            </div>
                                        </div>
                                        <div class="meal-card-body">
                                            <ul class="food-list">
                                                <c:forEach var="item" items="${mealPlan.mealItems[mealTime]}">
                                                    <c:if test="${item.foodItem1 != null}">
                                                        <li>
                                                            <c:if test="${not empty item.foodItem1.imagePath}">
                                                                <img src="${pageContext.request.contextPath}/${item.foodItem1.imagePath}" 
                                                                     alt="${item.foodItem1.name}" 
                                                                     class="food-image"
                                                                     onclick="openLightbox('${pageContext.request.contextPath}/${item.foodItem1.imagePath}', '${item.foodItem1.name}')"
                                                                     onerror="this.style.display='none'">
                                                            </c:if>
                                                            <div class="food-info">
                                                                <div class="food-name">
                                                                    <i class="ph ph-check-circle"></i>
                                                                    ${item.foodItem1.name}
                                                                </div>
                                                                <div class="food-calories">
                                                                    ${item.foodItem1.caloriesPer100g} cal/100g
                                                                </div>
                                                            </div>
                                                            <span class="food-portion">
                                                                <i class="ph ph-scales" style="font-size: 0.8rem; opacity: 0.8; margin-right: 4px; color: var(--primary);"></i>
                                                                <fmt:formatNumber value="${item.quantity1}" maxFractionDigits="0"/> g
                                                            </span>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${item.foodItem2 != null}">
                                                        <li>
                                                            <c:if test="${not empty item.foodItem2.imagePath}">
                                                                <img src="${pageContext.request.contextPath}/${item.foodItem2.imagePath}" 
                                                                     alt="${item.foodItem2.name}" 
                                                                     class="food-image"
                                                                     onclick="openLightbox('${pageContext.request.contextPath}/${item.foodItem2.imagePath}', '${item.foodItem2.name}')"
                                                                     onerror="this.style.display='none'">
                                                            </c:if>
                                                            <div class="food-info">
                                                                <div class="food-name">
                                                                    <i class="ph ph-arrows-left-right"></i>
                                                                    <span class="text-muted">ou</span> ${item.foodItem2.name}
                                                                </div>
                                                                <div class="food-calories">
                                                                    ${item.foodItem2.caloriesPer100g} cal/100g
                                                                </div>
                                                            </div>
                                                            <span class="food-portion">
                                                                <i class="ph ph-scales" style="font-size: 0.8rem; opacity: 0.8; margin-right: 4px; color: var(--primary);"></i>
                                                                <fmt:formatNumber value="${item.quantity2}" maxFractionDigits="0"/> g
                                                            </span>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${item.foodItem3 != null}">
                                                        <li>
                                                            <c:if test="${not empty item.foodItem3.imagePath}">
                                                                <img src="${pageContext.request.contextPath}/${item.foodItem3.imagePath}" 
                                                                     alt="${item.foodItem3.name}" 
                                                                     class="food-image"
                                                                     onclick="openLightbox('${pageContext.request.contextPath}/${item.foodItem3.imagePath}', '${item.foodItem3.name}')"
                                                                     onerror="this.style.display='none'">
                                                            </c:if>
                                                            <div class="food-info">
                                                                <div class="food-name">
                                                                    <i class="ph ph-arrows-left-right"></i>
                                                                    <span class="text-muted">ou</span> ${item.foodItem3.name}
                                                                </div>
                                                                <div class="food-calories">
                                                                    ${item.foodItem3.caloriesPer100g} cal/100g
                                                                </div>
                                                            </div>
                                                            <span class="food-portion">
                                                                <i class="ph ph-scales" style="font-size: 0.8rem; opacity: 0.8; margin-right: 4px; color: var(--primary);"></i>
                                                                <fmt:formatNumber value="${item.quantity3}" maxFractionDigits="0"/> g
                                                            </span>
                                                        </li>
                                                    </c:if>
                                                </c:forEach>
                                            </ul>

                                            
                                            <!-- Tracking UI -->
                                            <c:if test="${mealPlan != null}">
                                                <c:set var="trackingType" value="" />
                                                <c:choose>
                                                    <c:when test="${mealTime == 'morning'}"><c:set var="trackingType" value="morning"/></c:when>
                                                    <c:when test="${mealTime == 'noon'}"><c:set var="trackingType" value="noon"/></c:when>
                                                    <c:when test="${mealTime == 'night'}"><c:set var="trackingType" value="night"/></c:when>
                                                    <c:when test="${mealTime == 'snacks'}"><c:set var="trackingType" value="snacks"/></c:when>
                                                </c:choose>
                                                
                                                <c:if test="${not empty trackingType}">
                                                    <c:set var="tracking" value="${mealTracking[trackingType]}" />
                                                    <c:set var="isCompleted" value="${tracking != null and tracking.completed}" />
                                                    <c:set var="isTracked" value="${tracking != null}" />
                                                    
                                                    <div class="meal-tracking">
                                                        <button class="tracking-btn done ${isTracked && isCompleted ? 'active' : ''}" 
                                                            onclick="trackMeal(${mealPlan.id}, '${trackingType}', true)"
                                                            ${isTracked ? 'disabled' : ''}>
                                                            <i class="ph ph-check"></i> Done
                                                        </button>
                                                        <button class="tracking-btn missed ${isTracked && !isCompleted ? 'active' : ''}" 
                                                            onclick="showAlternativeInput('${trackingType}', ${mealPlan.id})"
                                                            ${isTracked ? 'disabled' : ''}>
                                                            <i class="ph ph-x"></i> Didn't eat
                                                        </button>
                                                    </div>
                                                    
                                                    <c:if test="${tracking != null and !isCompleted and tracking.alternativeMeal != null}">
                                                        <div class="alternative-display">
                                                            <strong>What I ate instead:</strong>
                                                            ${tracking.alternativeMeal}
                                                        </div>
                                                    </c:if>
                                                    
                                                    <input type="text"
                                                        class="alternative-input"
                                                        id="alt-${trackingType}"
                                                        placeholder="What did you eat instead? (Press Enter to save)"
                                                        onkeypress="if(event.key==='Enter') submitAlternative('${trackingType}', ${mealPlan.id})">
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                        
                        <!-- Nutritionist Notes -->
                        <c:if test="${not empty mealPlan.notes}">
                            <div class="nutritionist-note">
                                <h4><i class="ph ph-note"></i> Notes from your Nutritionist</h4>
                                <p>${mealPlan.notes}</p>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <!-- No Plan -->
                        <div class="empty-state">
                            <i class="ph ph-bowl-food"></i>
                            <h3>No Meal Plan Yet</h3>
                            <p>Your nutritionist hasn't assigned a meal plan to you yet.</p>
                            <p>Please contact your nutritionist or wait for them to create one for you.</p>
                            <a href="${pageContext.request.contextPath}/chat" class="btn btn-primary mt-4">
                                <i class="ph ph-chat-circle"></i> Message Your Nutritionist
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
    
    <!-- Image Lightbox Modal -->
    <div id="imageLightbox" class="image-lightbox" onclick="closeLightbox()">
        <div class="lightbox-content" onclick="event.stopPropagation()">
            <button class="lightbox-close" onclick="closeLightbox()">
                <i class="ph ph-x"></i>
            </button>
            <img id="lightboxImage" class="lightbox-image" src="" alt="">
            <div id="lightboxCaption" class="lightbox-caption"></div>
        </div>
    </div>
</body>

    <script>
        // Image Lightbox Functions
        function openLightbox(imageSrc, imageAlt) {
            const lightbox = document.getElementById('imageLightbox');
            const lightboxImage = document.getElementById('lightboxImage');
            const lightboxCaption = document.getElementById('lightboxCaption');
            
            lightboxImage.src = imageSrc;
            lightboxImage.alt = imageAlt;
            lightboxCaption.textContent = imageAlt;
            
            lightbox.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
        
        function closeLightbox() {
            const lightbox = document.getElementById('imageLightbox');
            lightbox.classList.remove('active');
            document.body.style.overflow = 'auto';
        }
        
        // Close lightbox with Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeLightbox();
            }
        });
        
        function trackMeal(mealPlanId, mealType, completed) {
            const alternativeMeal = completed ? null : document.getElementById('alt-' + mealType).value;
            
            // Visual feedback immediately
            const btns = document.querySelectorAll('.tracking-btn');
            // Optimistic update could happen here, but we will reload for now as per simple logic
            
            fetch('${pageContext.request.contextPath}/patient/saveMealTracking', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'mealPlanId=' + mealPlanId +  
                      '&mealType=' + mealType + 
                      '&completed=' + completed + 
                      (alternativeMeal ? '&alternativeMeal=' + encodeURIComponent(alternativeMeal) : '')
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload(); 
                } else {
                    alert('Error tracking meal: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while tracking meal');
            });
        }

        function showAlternativeInput(mealType, mealPlanId) {
            const input = document.getElementById('alt-' + mealType);
            if (input) {
                // Toggle display
                if (input.style.display !== 'block') {
                   input.style.display = 'block'; 
                   input.classList.add('show');
                   input.focus();
                   
                   // Ensure the missed button looks active/pending if not already
                   // We don't save yet, we wait for input
                } else {
                   // If already shown, maybe hide it? Or focus it?
                   input.focus();
                }
            }
        }

        function submitAlternative(mealType, mealPlanId) {
            const input = document.getElementById('alt-' + mealType);
            if (input && input.value.trim() !== '') {
                trackMeal(mealPlanId, mealType, false);
            } else {
                 // If empty, allow saving as just "Missed" without specific alternative?
                 // Let's assume yes, if they press enter on empty, it just marks as missed.
                 trackMeal(mealPlanId, mealType, false);
            }
        }
    </script>
</html>
