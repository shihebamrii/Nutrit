<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.nutrit.models.PatientProfile" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Profil Santé - Nutrit</title>
            <meta name="description"
                content="Complétez votre profil santé pour aider les nutritionnistes à vous fournir une meilleure consultation.">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            <script src="https://unpkg.com/@phosphor-icons/web"></script>
            <style>
                .profile-form {
                    max-width: 900px;
                }

                .form-section {
                    background: white;
                    border-radius: var(--radius-xl);
                    padding: 2rem;
                    margin-bottom: 1.5rem;
                    box-shadow: var(--shadow-sm);
                    border: 1px solid var(--border);
                }

                .form-section-header {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    margin-bottom: 1.5rem;
                    padding-bottom: 1rem;
                    border-bottom: 1px solid var(--border);
                }

                .form-section-header i {
                    font-size: 1.5rem;
                    color: var(--primary);
                }

                .form-section-header h2 {
                    font-size: 1.25rem;
                    font-weight: 600;
                    margin: 0;
                }

                .form-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1.25rem;
                }

                .form-grid-3 {
                    grid-template-columns: repeat(3, 1fr);
                }

                @media (max-width: 768px) {
                    .form-grid-3 {
                        grid-template-columns: 1fr;
                    }
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                }

                .form-group.full-width {
                    grid-column: 1 / -1;
                }

                .form-group label {
                    font-size: 0.875rem;
                    font-weight: 500;
                    color: var(--gray-700);
                    margin-bottom: 0.5rem;
                }

                .form-group label .required {
                    color: var(--danger);
                }

                .form-group .hint {
                    font-size: 0.75rem;
                    color: var(--gray-500);
                    margin-top: 0.25rem;
                }

                .progress-indicator {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    padding: 1rem 1.5rem;
                    background: var(--gray-50);
                    border-radius: var(--radius-lg);
                    margin-bottom: 1.5rem;
                }

                .progress-indicator.complete {
                    background: rgba(16, 185, 129, 0.1);
                }

                .progress-indicator i {
                    font-size: 2rem;
                }

                .progress-indicator.complete i {
                    color: var(--success);
                }

                .progress-indicator.incomplete i {
                    color: var(--warning);
                }

                .bmi-display {
                    background: var(--gradient-primary);
                    color: white;
                    padding: 1rem 1.5rem;
                    border-radius: var(--radius-lg);
                    text-align: center;
                }

                .bmi-display .label {
                    font-size: 0.875rem;
                    opacity: 0.9;
                }

                .bmi-display .value {
                    font-size: 2rem;
                    font-weight: 700;
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
                            <h1>Profil Santé</h1>
                            <p>Complétez vos informations de santé pour aider les nutritionnistes à fournir des consultations personnalisées.</p>
                        </div>

                        <% if (request.getAttribute("successMessage") !=null) { %>
                            <div class="alert alert-success animate-fade-in mb-4">
                                <i class="ph ph-check-circle"></i>
                                <span>
                                    <%= request.getAttribute("successMessage") %>
                                </span>
                            </div>
                            <% } %>

                                <% if (request.getAttribute("errorMessage") !=null) { %>
                                    <div class="alert alert-error animate-fade-in mb-4">
                                        <i class="ph ph-warning-circle"></i>
                                        <span>
                                            <%= request.getAttribute("errorMessage") %>
                                        </span>
                                    </div>
                                    <% } %>

                                        <% PatientProfile profile=(PatientProfile)
                                            request.getAttribute("healthProfile"); Boolean isComplete=(Boolean)
                                            request.getAttribute("isComplete"); %>

                                            <!-- Progress Indicator -->
                                            <div class="progress-indicator <%= isComplete != null && isComplete ? "complete" : "incomplete" %>">
                                                <i class="ph-fill <%= isComplete != null && isComplete ? "ph-check-circle" : "ph-warning-circle" %>"></i>
                                                <div>
                                                    <% if (isComplete !=null && isComplete) { %>
                                                        <strong style="color: var(--success);">Profil Complet</strong>
                                                        <p
                                                            style="margin: 0; font-size: 0.875rem; color: var(--gray-600);">
                                                            Votre profil santé est complet. Les nutritionnistes peuvent maintenant vous fournir des recommandations personnalisées.</p>
                                                        <% } else { %>
                                                            <strong style="color: var(--warning);">Profil
                                                                Incomplet</strong>
                                                            <p
                                                                style="margin: 0; font-size: 0.875rem; color: var(--gray-600);">
                                                                Veuillez remplir au moins les informations de base (marquées d'un *) pour aider les nutritionnistes à mieux vous aider.</p>
                                                            <% } %>
                                                </div>
                                            </div>

                                            <form action="${pageContext.request.contextPath}/patient/saveHealthProfile"
                                                method="POST" class="profile-form">

                                                <!-- Section 1: Basic Information -->
                                                <div class="form-section animate-fade-in">
                                                    <div class="form-section-header">
                                                        <i class="ph ph-user-circle"></i>
                                                        <h2>Informations de Base</h2>
                                                    </div>

                                                    <div class="form-grid">
                                                        <div class="form-group">
                                                            <label>Date de Naissance <span class="required">*</span></label>
                                                            <input type="date" name="dateOfBirth" class="input" required
                                                                value="<%= profile != null && profile.getDateOfBirth() != null ? profile.getDateOfBirth() : "" %>">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Genre <span class="required">*</span></label>
                                                            <select name="gender" class="input" required>
                                                                <option value="">Sélectionner...</option>
                                                                <option value="homme" <%=profile !=null && "homme"
                                                                    .equals(profile.getGender()) ? "selected" : "" %>
                                                                    >Homme</option>
                                                                <option value="femme" <%=profile !=null && "femme"
                                                                    .equals(profile.getGender()) ? "selected" : "" %>
                                                                    >Femme</option>
                                                                <option value="autre" <%=profile !=null && "autre"
                                                                    .equals(profile.getGender()) ? "selected" : "" %>
                                                                    >Autre</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Taille (cm) <span class="required">*</span></label>
                                                            <input type="number" name="height" class="input" step="0.1"
                                                                min="50" max="250" required
                                                                value="<%= profile != null && profile.getHeight() != null ? profile.getHeight() : "" %>"
                                                                placeholder="e.g., 175">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Poids Actuel (kg) <span
                                                                    class="required">*</span></label>
                                                            <input type="number" name="currentWeight" class="input"
                                                                step="0.1" min="20" max="300" required
                                                                value="<%= profile != null && profile.getCurrentWeight() != null ? profile.getCurrentWeight() : "" %>"
                                                                placeholder="e.g., 70">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Poids Cible (kg)</label>
                                                            <input type="number" name="targetWeight" class="input"
                                                                step="0.1" min="20" max="300"
                                                                value="<%= profile != null && profile.getTargetWeight() != null ? profile.getTargetWeight() : "" %>"
                                                                placeholder="e.g., 65">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Profession</label>
                                                            <input type="text" name="occupation" class="input"
                                                                value="<%= profile != null && profile.getOccupation() != null ? profile.getOccupation() : "" %>"
                                                                placeholder="ex: Employé de bureau">
                                                        </div>
                                                    </div>

                                                    <% if (profile !=null && profile.getBMI() !=null) { %>
                                                        <div style="margin-top: 1.5rem;">
                                                            <div class="bmi-display" style="display: inline-block;">
                                                                <div class="label">Votre IMC</div>
                                                                <div class="value">
                                                                    <%= profile.getBMI() %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <% } %>
                                                </div>

                                                <!-- Section 2: Lifestyle -->
                                                <div class="form-section animate-fade-in"
                                                    style="animation-delay: 0.1s;">
                                                    <div class="form-section-header">
                                                        <i class="ph ph-lightning"></i>
                                                        <h2>Mode de Vie</h2>
                                                    </div>

                                                    <div class="form-grid">
                                                        <div class="form-group">
                                                            <label>Niveau d'Activité</label>
                                                            <select name="activityLevel" class="input">
                                                                <option value="">Sélectionner...</option>
                                                                <option value="sedentaire" <%=profile !=null
                                                                    && "sedentaire" .equals(profile.getActivityLevel())
                                                                    ? "selected" : "" %>>Sédentaire (peu/pas d'exercice)
                                                                </option>
                                                                <option value="leger" <%=profile !=null && "leger"
                                                                    .equals(profile.getActivityLevel()) ? "selected"
                                                                    : "" %>>Léger (1-2 jours/semaine)</option>
                                                                <option value="modere" <%=profile !=null && "modere"
                                                                    .equals(profile.getActivityLevel()) ? "selected"
                                                                    : "" %>>Modéré (3-5 jours/semaine)</option>
                                                                <option value="actif" <%=profile !=null && "actif"
                                                                    .equals(profile.getActivityLevel()) ? "selected"
                                                                    : "" %>>Actif (6-7 jours/semaine)</option>
                                                                <option value="tres_actif" <%=profile !=null
                                                                    && "tres_actif" .equals(profile.getActivityLevel())
                                                                    ? "selected" : "" %>>Très Actif (athlète)</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Heures de Sommeil (par nuit)</label>
                                                            <input type="number" name="sleepHours" class="input" min="1"
                                                                max="24"
                                                                value="<%= profile != null && profile.getSleepHours() > 0 ? profile.getSleepHours() : "" %>"
                                                                placeholder="e.g., 7">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Niveau de Stress</label>
                                                            <select name="stressLevel" class="input">
                                                                <option value="">Sélectionner...</option>
                                                                <option value="low" <%=profile !=null && "low"
                                                                    .equals(profile.getStressLevel()) ? "selected" : ""
                                                                    %>>Faible</option>
                                                                <option value="moderate" <%=profile !=null && "moderate"
                                                                    .equals(profile.getStressLevel()) ? "selected" : ""
                                                                    %>>Modéré</option>
                                                                <option value="high" <%=profile !=null && "high"
                                                                    .equals(profile.getStressLevel()) ? "selected" : ""
                                                                    %>>Élevé</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Tabagisme</label>
                                                            <select name="smokingStatus" class="input">
                                                                <option value="">Sélectionner...</option>
                                                                <option value="never" <%=profile !=null && "never"
                                                                    .equals(profile.getSmokingStatus()) ? "selected"
                                                                    : "" %>>Jamais Fumé</option>
                                                                <option value="former" <%=profile !=null && "former"
                                                                    .equals(profile.getSmokingStatus()) ? "selected"
                                                                    : "" %>>Ancien Fumeur</option>
                                                                <option value="current" <%=profile !=null && "current"
                                                                    .equals(profile.getSmokingStatus()) ? "selected"
                                                                    : "" %>>Fumeur Actuel</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Consommation d'Alcool</label>
                                                            <select name="alcoholConsumption" class="input">
                                                                <option value="">Sélectionner...</option>
                                                                <option value="none" <%=profile !=null && "none"
                                                                    .equals(profile.getAlcoholConsumption())
                                                                    ? "selected" : "" %>>Aucune</option>
                                                                <option value="occasional" <%=profile !=null
                                                                    && "occasional"
                                                                    .equals(profile.getAlcoholConsumption())
                                                                    ? "selected" : "" %>>Occasionnelle</option>
                                                                <option value="moderate" <%=profile !=null && "moderate"
                                                                    .equals(profile.getAlcoholConsumption())
                                                                    ? "selected" : "" %>>Modérée</option>
                                                                <option value="frequent" <%=profile !=null && "frequent"
                                                                    .equals(profile.getAlcoholConsumption())
                                                                    ? "selected" : "" %>>Fréquente</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Fréquence d'Exercice</label>
                                                            <select name="exerciseFrequency" class="input">
                                                                <option value="">Sélectionner...</option>
                                                                <option value="none" <%=profile !=null && "none"
                                                                    .equals(profile.getExerciseFrequency()) ? "selected"
                                                                    : "" %>>Aucune</option>
                                                                <option value="1-2_weekly" <%=profile !=null
                                                                    && "1-2_weekly"
                                                                    .equals(profile.getExerciseFrequency()) ? "selected"
                                                                    : "" %>>1-2 fois/semaine</option>
                                                                <option value="3-4_weekly" <%=profile !=null
                                                                    && "3-4_weekly"
                                                                    .equals(profile.getExerciseFrequency()) ? "selected"
                                                                    : "" %>>3-4 fois/semaine</option>
                                                                <option value="5+_weekly" <%=profile !=null
                                                                    && "5+_weekly"
                                                                    .equals(profile.getExerciseFrequency()) ? "selected"
                                                                    : "" %>>5+ fois/semaine</option>
                                                                <option value="daily" <%=profile !=null && "daily"
                                                                    .equals(profile.getExerciseFrequency()) ? "selected"
                                                                    : "" %>>Quotidien</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Type d'Exercice</label>
                                                            <input type="text" name="exerciseType" class="input"
                                                                value="<%= profile != null && profile.getExerciseType() != null ? profile.getExerciseType() : "" %>"
                                                                placeholder="ex: Course, Musculation, Yoga, Natation">
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Section 3: Medical History -->
                                                <div class="form-section animate-fade-in"
                                                    style="animation-delay: 0.2s;">
                                                    <div class="form-section-header">
                                                        <i class="ph ph-first-aid-kit"></i>
                                                        <h2>Antécédents Médicaux</h2>
                                                    </div>

                                                    <div class="form-grid">
                                                        <div class="form-group full-width">
                                                            <label>Conditions Médicales</label>
                                                            <textarea name="medicalConditions" class="input" rows="3"
                                                                placeholder="ex: Diabète, Hypertension, Maladie cardiaque, Thyroïde, SOPK, Maladie rénale..."><%= profile != null && profile.getMedicalConditions() != null ? profile.getMedicalConditions() : "" %></textarea>
                                                            <span class="hint">Listez les maladies chroniques ou problèmes de santé</span>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Allergies Alimentaires</label>
                                                            <textarea name="allergies" class="input" rows="2"
                                                                placeholder="ex: Arachides, Fruits de mer, Produits laitiers, Œufs, Gluten..."><%= profile != null && profile.getAllergies() != null ? profile.getAllergies() : "" %></textarea>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Médicaments Actuels</label>
                                                            <textarea name="currentMedications" class="input" rows="2"
                                                                placeholder="Listez les médicaments que vous prenez actuellement..."><%= profile != null && profile.getCurrentMedications() != null ? profile.getCurrentMedications() : "" %></textarea>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Chirurgies Précédentes</label>
                                                            <textarea name="previousSurgeries" class="input" rows="2"
                                                                placeholder="ex: Appendicectomie (2015), Bypass gastrique..."><%= profile != null && profile.getPreviousSurgeries() != null ? profile.getPreviousSurgeries() : "" %></textarea>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Antécédents Médicaux Familiaux</label>
                                                            <textarea name="familyMedicalHistory" class="input" rows="2"
                                                                placeholder="ex: Père : Maladie cardiaque, Mère : Diabète..."><%= profile != null && profile.getFamilyMedicalHistory() != null ? profile.getFamilyMedicalHistory() : "" %></textarea>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Problèmes Digestifs</label>
                                                            <textarea name="digestiveIssues" class="input" rows="2"
                                                                placeholder="ex: Ballonnements, Constipation, Reflux acide, Intolérances..."><%= profile != null && profile.getDigestiveIssues() != null ? profile.getDigestiveIssues() : "" %></textarea>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Section 4: Dietary Information -->
                                                <div class="form-section animate-fade-in"
                                                    style="animation-delay: 0.3s;">
                                                    <div class="form-section-header">
                                                        <i class="ph ph-bowl-food"></i>
                                                        <h2>Informations Alimentaires</h2>
                                                    </div>

                                                    <div class="form-grid">
                                                        <div class="form-group full-width">
                                                            <label>Restrictions Alimentaires</label>
                                                            <textarea name="dietaryRestrictions" class="input" rows="2"
                                                                placeholder="ex: Végétarien, Végétalien, Halal, Casher, Sans Gluten, Sans Lactose..."><%= profile != null && profile.getDietaryRestrictions() != null ? profile.getDietaryRestrictions() : "" %></textarea>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Préférences Alimentaires</label>
                                                            <textarea name="foodPreferences" class="input" rows="2"
                                                                placeholder="Aliments que vous appréciez et souhaitez inclure dans votre plan..."><%= profile != null && profile.getFoodPreferences() != null ? profile.getFoodPreferences() : "" %></textarea>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Aliments à Éviter / Aversions</label>
                                                            <textarea name="foodsToAvoid" class="input" rows="2"
                                                                placeholder="Aliments que vous n'aimez pas ou voulez éviter..."><%= profile != null && profile.getFoodsToAvoid() != null ? profile.getFoodsToAvoid() : "" %></textarea>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Consommation d'Eau Quotidienne (verres)</label>
                                                            <input type="number" name="dailyWaterIntake" class="input"
                                                                min="0" max="30"
                                                                value="<%= profile != null && profile.getDailyWaterIntake() > 0 ? profile.getDailyWaterIntake() : "" %>"
                                                                placeholder="e.g., 8">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Repas par Jour</label>
                                                            <input type="number" name="mealsPerDay" class="input"
                                                                min="1" max="10"
                                                                value="<%= profile != null && profile.getMealsPerDay() > 0 ? profile.getMealsPerDay() : "" %>"
                                                                placeholder="e.g., 3">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Habitudes de Grignotage</label>
                                                            <select name="snackingHabits" class="input">
                                                                <option value="">Sélectionner...</option>
                                                                <option value="never" <%=profile !=null && "never"
                                                                    .equals(profile.getSnackingHabits()) ? "selected"
                                                                    : "" %>>Jamais</option>
                                                                <option value="rarely" <%=profile !=null && "rarely"
                                                                    .equals(profile.getSnackingHabits()) ? "selected"
                                                                    : "" %>>Rarement</option>
                                                                <option value="sometimes" <%=profile !=null
                                                                    && "sometimes" .equals(profile.getSnackingHabits())
                                                                    ? "selected" : "" %>>Parfois</option>
                                                                <option value="often" <%=profile !=null && "often"
                                                                    .equals(profile.getSnackingHabits()) ? "selected"
                                                                    : "" %>>Souvent</option>
                                                                <option value="always" <%=profile !=null && "always"
                                                                    .equals(profile.getSnackingHabits()) ? "selected"
                                                                    : "" %>>Toujours</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Historique des Régimes</label>
                                                            <textarea name="previousDietHistory" class="input" rows="2"
                                                                placeholder="Avez-vous essayé des régimes auparavant ? (ex: Keto, Jeûne intermittent, Méditerranéen...)"><%= profile != null && profile.getPreviousDietHistory() != null ? profile.getPreviousDietHistory() : "" %></textarea>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Section 5: Health Goals -->
                                                <div class="form-section animate-fade-in"
                                                    style="animation-delay: 0.4s;">
                                                    <div class="form-section-header">
                                                        <i class="ph ph-target"></i>
                                                        <h2>Objectifs de Santé</h2>
                                                    </div>

                                                    <div class="form-grid">
                                                        <div class="form-group">
                                                            <label>Objectif Principal <span class="required">*</span></label>
                                                            <select name="primaryGoal" class="input" required>
                                                                <option value="">Sélectionner...</option>
                                                                <option value="weight_loss" <%=profile !=null
                                                                    && "weight_loss" .equals(profile.getPrimaryGoal())
                                                                    ? "selected" : "" %>>Perte de Poids</option>
                                                                <option value="weight_gain" <%=profile !=null
                                                                    && "weight_gain" .equals(profile.getPrimaryGoal())
                                                                    ? "selected" : "" %>>Prise de Poids</option>
                                                                <option value="muscle_building" <%=profile !=null
                                                                    && "muscle_building"
                                                                    .equals(profile.getPrimaryGoal()) ? "selected" : ""
                                                                    %>>Prise de Masse</option>
                                                                <option value="health_improvement" <%=profile !=null
                                                                    && "health_improvement"
                                                                    .equals(profile.getPrimaryGoal()) ? "selected" : ""
                                                                    %>>Amélioration Santé Générale</option>
                                                                <option value="disease_management" <%=profile !=null
                                                                    && "disease_management"
                                                                    .equals(profile.getPrimaryGoal()) ? "selected" : ""
                                                                    %>>Gestion de Maladie</option>
                                                                <option value="maintenance" <%=profile !=null
                                                                    && "maintenance" .equals(profile.getPrimaryGoal())
                                                                    ? "selected" : "" %>>Maintien du Poids</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Niveau de Motivation</label>
                                                            <select name="motivationLevel" class="input">
                                                                <option value="">Sélectionner...</option>
                                                                <option value="low" <%=profile !=null && "low"
                                                                    .equals(profile.getMotivationLevel()) ? "selected"
                                                                    : "" %>>Faible</option>
                                                                <option value="moderate" <%=profile !=null && "moderate"
                                                                    .equals(profile.getMotivationLevel()) ? "selected"
                                                                    : "" %>>Modéré</option>
                                                                <option value="high" <%=profile !=null && "high"
                                                                    .equals(profile.getMotivationLevel()) ? "selected"
                                                                    : "" %>>Élevé</option>
                                                                <option value="very_high" <%=profile !=null
                                                                    && "very_high" .equals(profile.getMotivationLevel())
                                                                    ? "selected" : "" %>>Très Élevé</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group full-width">
                                                            <label>Objectifs Secondaires</label>
                                                            <textarea name="secondaryGoals" class="input" rows="2"
                                                                placeholder="D'autres objectifs ? (ex: Plus d'énergie, Meilleur sommeil, Moins de cholestérol...)"><%= profile != null && profile.getSecondaryGoals() != null ? profile.getSecondaryGoals() : "" %></textarea>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Section 6: Additional Notes -->
                                                <div class="form-section animate-fade-in"
                                                    style="animation-delay: 0.5s;">
                                                    <div class="form-section-header">
                                                        <i class="ph ph-note-pencil"></i>
                                                        <h2>Notes Supplémentaires</h2>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Autre chose à signaler au nutritionniste ?</label>
                                                        <textarea name="additionalNotes" class="input" rows="4"
                                                            placeholder="Partagez toute autre information pertinente sur votre santé, mode de vie ou préférences..."><%= profile != null && profile.getAdditionalNotes() != null ? profile.getAdditionalNotes() : "" %></textarea>
                                                    </div>
                                                </div>

                                                <!-- Submit Button -->
                                                <div class="form-section"
                                                    style="background: transparent; box-shadow: none; border: none; padding: 0;">
                                                    <button type="submit" class="btn btn-primary btn-lg w-full">
                                                        <i class="ph ph-check-circle"></i>
                                                        Enregistrer le Profil Santé
                                                    </button>
                                                </div>
                                            </form>
                    </div>
                </main>
            </div>
        </body>

        </html>