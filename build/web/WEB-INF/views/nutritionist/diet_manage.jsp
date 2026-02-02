<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gérer les Plans Alimentaires - Nutrit</title>
        <meta name="description" content="Créez et attribuez des plans alimentaires personnalisés pour vos patients.">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="https://unpkg.com/@phosphor-icons/web"></script>
        <style>
            .meal-section {
                background: var(--gray-50);
                border-radius: var(--radius-lg);
                padding: 1.25rem;
                margin-bottom: 1rem;
                border: 1px solid var(--gray-200);
            }

            .meal-section .meal-header {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                margin-bottom: 0.75rem;
            }

            .meal-section .meal-icon {
                width: 36px;
                height: 36px;
                border-radius: var(--radius-md);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.125rem;
            }

            .meal-section .meal-icon.breakfast {
                background: linear-gradient(135deg, #FEF3C7, #FFFBEB);
                color: #D97706;
            }

            .meal-section .meal-icon.lunch {
                background: linear-gradient(135deg, #D1FAE5, #ECFDF5);
                color: #059669;
            }

            .meal-section .meal-icon.dinner {
                background: linear-gradient(135deg, #E0E7FF, #EEF2FF);
                color: #4F46E5;
            }

            .meal-section .meal-icon.snacks {
                background: linear-gradient(135deg, #FCE7F3, #FDF2F8);
                color: #DB2777;
            }

            .meal-section .meal-label {
                font-weight: 600;
                color: var(--gray-700);
            }
        </style>
    </head>

    <body>
        <div class="flex">
            <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

            <main class="main-content">
                <jsp:include page="/WEB-INF/views/common/header.jsp" />

                <div class="page-content" style="max-width: 800px;">
                    <!-- En-tête de la Page -->
                    <div class="page-header">
                        <h1>Créer un Plan Alimentaire</h1>
                        <p>Concevez un plan nutritionnel quotidien personnalisé pour votre patient.</p>
                    </div>

                    <div class="card animate-fade-in">
                        <form action="${pageContext.request.contextPath}/nutritionist/diet" method="POST">
                            <!-- Sélection du Patient et de la Date -->
                            <div class="form-grid mb-6">
                                <div class="form-group">
                                    <label class="label" for="patientId">
                                        <i class="ph ph-user-circle mr-1"></i>
                                        ID du Patient
                                    </label>
                                    <input type="number" id="patientId" name="patientId" class="input" required
                                        placeholder="Saisir l'ID du patient" value="${param.patientId}">
                                </div>
                                <div class="form-group">
                                    <label class="label" for="dayDate">
                                        <i class="ph ph-calendar mr-1"></i>
                                        Date
                                    </label>
                                    <input type="date" id="dayDate" name="dayDate" class="input" required>
                                </div>
                            </div>

                            <!-- Sections des Repas -->
                            <div class="meal-section">
                                <div class="meal-header">
                                    <div class="meal-icon breakfast">
                                        <i class="ph ph-sun-horizon"></i>
                                    </div>
                                    <span class="meal-label">Petit-déjeuner</span>
                                </div>
                                <textarea name="breakfast" class="input" rows="2"
                                    placeholder="ex: Flocons d'avoine aux fruits frais, yaourt grec et thé vert"></textarea>
                            </div>

                            <div class="meal-section">
                                <div class="meal-header">
                                    <div class="meal-icon lunch">
                                        <i class="ph ph-sun"></i>
                                    </div>
                                    <span class="meal-label">Déjeuner</span>
                                </div>
                                <textarea name="lunch" class="input" rows="2"
                                    placeholder="ex: Salade de poulet grillé avec quinoa et légumes"></textarea>
                            </div>

                            <div class="meal-section">
                                <div class="meal-header">
                                    <div class="meal-icon dinner">
                                        <i class="ph ph-moon-stars"></i>
                                    </div>
                                    <span class="meal-label">Dîner</span>
                                </div>
                                <textarea name="dinner" class="input" rows="2"
                                    placeholder="ex: Saumon au four avec légumes rôtis et riz complet"></textarea>
                            </div>

                            <div class="meal-section">
                                <div class="meal-header">
                                    <div class="meal-icon snacks">
                                        <i class="ph ph-apple"></i>
                                    </div>
                                    <span class="meal-label">Collations</span>
                                </div>
                                <textarea name="snacks" class="input" rows="2"
                                    placeholder="ex: Amandes, fruits frais, shake protéiné"></textarea>
                            </div>

                            <div class="flex justify-end mt-6 pt-4" style="border-top: 1.5px solid var(--border);">
                                <button type="submit" class="btn btn-primary">
                                    <i class="ph ph-clipboard-text"></i>
                                    Attribuer le Plan
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>

        <script>
            // Set default date to today
            document.getElementById('dayDate').valueAsDate = new Date();
        </script>
    </body>

    </html>