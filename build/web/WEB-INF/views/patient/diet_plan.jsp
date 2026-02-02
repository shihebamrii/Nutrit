<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.DietPlan" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>My Diet Plan - Nutrit</title>
                    <meta name="description"
                        content="View your personalized daily nutrition plans created by your nutritionist.">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                    <script src="https://unpkg.com/@phosphor-icons/web"></script>
                    <style>
                        .diet-card {
                            background: var(--card);
                            border-radius: var(--radius-xl);
                            border: 1px solid var(--border);
                            overflow: hidden;
                            margin-bottom: 1.5rem;
                        }

                        .diet-card-header {
                            background: var(--gradient-primary);
                            color: white;
                            padding: 1rem 1.5rem;
                            display: flex;
                            align-items: center;
                            gap: 0.75rem;
                        }

                        .diet-card-body {
                            padding: 1.5rem;
                        }

                        .meal-row {
                            display: flex;
                            align-items: flex-start;
                            gap: 1rem;
                            padding: 1rem 0;
                            border-bottom: 1px solid var(--gray-100);
                        }

                        .meal-row:last-child {
                            border-bottom: none;
                            padding-bottom: 0;
                        }

                        .meal-row:first-child {
                            padding-top: 0;
                        }

                        .meal-icon-wrapper {
                            width: 44px;
                            height: 44px;
                            border-radius: var(--radius-lg);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 1.25rem;
                            flex-shrink: 0;
                        }

                        .meal-icon-wrapper.breakfast {
                            background: linear-gradient(135deg, #FEF3C7, #FFFBEB);
                            color: #D97706;
                        }

                        .meal-icon-wrapper.lunch {
                            background: linear-gradient(135deg, #D1FAE5, #ECFDF5);
                            color: #059669;
                        }

                        .meal-icon-wrapper.dinner {
                            background: linear-gradient(135deg, #E0E7FF, #EEF2FF);
                            color: #4F46E5;
                        }

                        .meal-icon-wrapper.snacks {
                            background: linear-gradient(135deg, #FCE7F3, #FDF2F8);
                            color: #DB2777;
                        }

                        .meal-details .meal-type {
                            font-size: 0.75rem;
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                            color: var(--gray-500);
                            font-weight: 600;
                            margin-bottom: 0.25rem;
                        }

                        .meal-details .meal-content {
                            font-weight: 500;
                            color: var(--gray-800);
                        }
                    </style>
                </head>

                <body>
                    <div class="flex">
                        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

                        <main class="main-content">
                            <jsp:include page="/WEB-INF/views/common/header.jsp" />

                            <div class="page-content" style="max-width: 900px;">
                                <!-- Page Header -->
                                <div class="page-header">
                                    <h1>My Diet Plan</h1>
                                    <p>Your personalized nutrition plans created by your nutritionist.</p>
                                </div>

                                <% List<DietPlan> plans = (List<DietPlan>) request.getAttribute("dietPlans");
                                        if (plans != null && !plans.isEmpty()) {
                                        for(DietPlan plan : plans) { %>
                                        <div class="diet-card animate-fade-in">
                                            <div class="diet-card-header">
                                                <i class="ph ph-calendar-check" style="font-size: 1.5rem;"></i>
                                                <div>
                                                    <div style="font-weight: 600; font-size: 1.125rem;">
                                                        <%= plan.getDayDate() %>
                                                    </div>
                                                    <div style="font-size: 0.875rem; opacity: 0.9;">Daily Nutrition Plan
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="diet-card-body">
                                                <div class="meal-row">
                                                    <div class="meal-icon-wrapper breakfast">
                                                        <i class="ph ph-sun-horizon"></i>
                                                    </div>
                                                    <div class="meal-details">
                                                        <div class="meal-type">Breakfast</div>
                                                        <div class="meal-content">
                                                            <%= plan.getBreakfast() %>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="meal-row">
                                                    <div class="meal-icon-wrapper lunch">
                                                        <i class="ph ph-sun"></i>
                                                    </div>
                                                    <div class="meal-details">
                                                        <div class="meal-type">Lunch</div>
                                                        <div class="meal-content">
                                                            <%= plan.getLunch() %>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="meal-row">
                                                    <div class="meal-icon-wrapper dinner">
                                                        <i class="ph ph-moon-stars"></i>
                                                    </div>
                                                    <div class="meal-details">
                                                        <div class="meal-type">Dinner</div>
                                                        <div class="meal-content">
                                                            <%= plan.getDinner() %>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% if (plan.getSnacks() !=null && !plan.getSnacks().isEmpty()) { %>
                                                    <div class="meal-row">
                                                        <div class="meal-icon-wrapper snacks">
                                                            <i class="ph ph-apple"></i>
                                                        </div>
                                                        <div class="meal-details">
                                                            <div class="meal-type">Snacks</div>
                                                            <div class="meal-content">
                                                                <%= plan.getSnacks() %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                            </div>
                                        </div>
                                        <% } } else { %>
                                            <div class="card animate-fade-in">
                                                <div class="empty-state">
                                                    <div class="empty-state-icon">
                                                        <i class="ph ph-fork-knife"></i>
                                                    </div>
                                                    <div class="empty-state-title">No Diet Plans Yet</div>
                                                    <div class="empty-state-text">Your nutritionist will create a
                                                        personalized diet plan for you soon. Check back later!</div>
                                                </div>
                                            </div>
                                            <% } %>
                            </div>
                        </main>
                    </div>
                </body>

                </html>