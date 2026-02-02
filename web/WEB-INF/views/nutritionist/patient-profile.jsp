<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.nutrit.models.User" %>
        <%@ page import="com.nutrit.models.PatientProfile" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <% User patient=(User) request.getAttribute("patient"); %>
                    <title>
                        <%= patient !=null ? patient.getFullName() : "Patient" %> - Profil de Santé
                    </title>
                    <meta name="description" content="Voir le profil de santé du patient pour la consultation.">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                    <script src="https://unpkg.com/@phosphor-icons/web"></script>
                    <style>
                        .profile-header {
                            display: flex;
                            align-items: center;
                            gap: 1.5rem;
                            margin-bottom: 2rem;
                        }

                        .patient-avatar {
                            width: 80px;
                            height: 80px;
                            border-radius: var(--radius-full);
                            background: var(--gradient-primary);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-size: 2rem;
                            font-weight: 700;
                        }

                        .info-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                            gap: 1rem;
                        }

                        .info-item {
                            background: var(--gray-50);
                            padding: 1rem;
                            border-radius: var(--radius-lg);
                        }

                        .info-item label {
                            font-size: 0.75rem;
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                            color: var(--gray-500);
                            font-weight: 600;
                            display: block;
                            margin-bottom: 0.25rem;
                        }

                        .info-item span {
                            font-weight: 500;
                            color: var(--gray-800);
                        }

                        .info-item span.empty {
                            color: var(--gray-400);
                            font-style: italic;
                        }

                        .section-card {
                            background: white;
                            border-radius: var(--radius-xl);
                            padding: 1.5rem;
                            margin-bottom: 1.5rem;
                            box-shadow: var(--shadow-sm);
                            border: 1px solid var(--border);
                        }

                        .section-header {
                            display: flex;
                            align-items: center;
                            gap: 0.75rem;
                            margin-bottom: 1.25rem;
                            padding-bottom: 1rem;
                            border-bottom: 1px solid var(--border);
                        }

                        .section-header i {
                            font-size: 1.25rem;
                            color: var(--primary);
                        }

                        .section-header h3 {
                            font-size: 1.125rem;
                            font-weight: 600;
                            margin: 0;
                        }

                        .bmi-badge {
                            display: inline-flex;
                            align-items: center;
                            gap: 0.5rem;
                            padding: 0.5rem 1rem;
                            border-radius: var(--radius-full);
                            font-weight: 600;
                        }

                        .bmi-badge.underweight {
                            background: #FEF3C7;
                            color: #92400E;
                        }

                        .bmi-badge.normal {
                            background: #D1FAE5;
                            color: #065F46;
                        }

                        .bmi-badge.overweight {
                            background: #FEE2E2;
                            color: #991B1B;
                        }

                        .bmi-badge.obese {
                            background: #FEE2E2;
                            color: #7F1D1D;
                        }

                        .text-block {
                            background: var(--gray-50);
                            padding: 1rem;
                            border-radius: var(--radius-lg);
                            line-height: 1.6;
                            color: var(--gray-700);
                        }

                        .text-block.empty {
                            color: var(--gray-400);
                            font-style: italic;
                        }

                        .status-badge {
                            display: inline-flex;
                            align-items: center;
                            gap: 0.5rem;
                            padding: 0.5rem 1rem;
                            border-radius: var(--radius-full);
                            font-size: 0.875rem;
                            font-weight: 500;
                        }

                        .status-badge.complete {
                            background: rgba(16, 185, 129, 0.1);
                            color: var(--success);
                        }

                        .status-badge.incomplete {
                            background: rgba(245, 158, 11, 0.1);
                            color: var(--warning);
                        }
                    </style>
            </head>

            <body>
                <div class="flex">
                    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

                    <main class="main-content">
                        <jsp:include page="/WEB-INF/views/common/header.jsp" />

                        <div class="page-content">
                            <!-- Back Link -->
                            <a href="${pageContext.request.contextPath}/nutritionist/patients" class="link mb-4"
                                style="display: inline-flex; align-items: center; gap: 0.5rem;">
                                <i class="ph ph-arrow-left"></i>
                                Retour aux Patients
                            </a>

                            <% PatientProfile profile=(PatientProfile) request.getAttribute("healthProfile"); Boolean
                                isComplete=(Boolean) request.getAttribute("isComplete"); if (patient !=null) { String[]
                                names=patient.getFullName().split(" ");
                        String initials = names[0].substring(0, 1);
                        if (names.length > 1) initials += names[names.length - 1].substring(0, 1);
                %>
                
                <!-- Patient Header -->
                <div class=" section-card animate-fade-in">
                                <div class="profile-header">
                                    <div class="patient-avatar">
                                        <%= initials.toUpperCase() %>
                                    </div>
                                    <div>
                                        <h1 style="margin: 0;">
                                            <%= patient.getFullName() %>
                                        </h1>
                                        <p style="color: var(--gray-600); margin: 0.25rem 0;">
                                            <%= patient.getEmail() %>
                                        </p>
                                        <div class="status-badge <%= isComplete != null && isComplete ? " complete"
                                            : "incomplete" %>">
                                            <i class="ph-fill <%= isComplete != null && isComplete ? " ph-check-circle"
                                                : "ph-warning-circle" %>"></i>
                                            <%= isComplete !=null && isComplete ? "Profil Complet"
                                                : "Profil Incomplet" %>
                                        </div>
                                    </div>
                                </div>
                        </div>

                        <% if (profile==null) { %>
                            <div class="section-card">
                                <div class="empty-state">
                                    <div class="empty-state-icon">
                                        <i class="ph ph-clipboard-text"></i>
                                    </div>
                                    <div class="empty-state-title">Aucun Profil de Santé</div>
                                    <div class="empty-state-text">Ce patient n'a pas encore rempli son profil de santé.</div>
                                </div>
                            </div>
                            <% } else { %>

                                <!-- Basic Information -->
                                <div class="section-card animate-fade-in" style="animation-delay: 0.1s;">
                                    <div class="section-header">
                                        <i class="ph ph-user-circle"></i>
                                        <h3>Informations de Base</h3>
                                    </div>

                                    <div class="info-grid">
                                        <div class="info-item">
                                            <label>Âge</label>
                                            <span class="<%= profile.getAge() > 0 ? "" : " empty" %>">
                                                <%= profile.getAge()> 0 ? profile.getAge() + " ans" : "Non fourni"
                                                    %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Genre</label>
                                            <span class="<%= profile.getGender() != null ? "" : " empty" %>">
                                                <% String gender = profile.getGender();
                                                   if (gender != null) {
                                                       if ("male".equalsIgnoreCase(gender)) gender = "Homme";
                                                       else if ("female".equalsIgnoreCase(gender)) gender = "Femme";
                                                       else gender = gender.substring(0,1).toUpperCase() + gender.substring(1);
                                                   }
                                                %>
                                                <%= gender != null ? gender : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Taille</label>
                                            <span class="<%= profile.getHeight() != null ? "" : " empty" %>">
                                                <%= profile.getHeight() !=null ? profile.getHeight() + " cm"
                                                    : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Poids Actuel</label>
                                            <span class="<%= profile.getCurrentWeight() != null ? "" : " empty" %>">
                                                <%= profile.getCurrentWeight() !=null ? profile.getCurrentWeight()
                                                    + " kg" : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Poids Cible</label>
                                            <span class="<%= profile.getTargetWeight() != null ? "" : " empty" %>">
                                                <%= profile.getTargetWeight() !=null ? profile.getTargetWeight() + " kg"
                                                    : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Profession</label>
                                            <span class="<%= profile.getOccupation() != null ? "" : " empty" %>">
                                                <%= profile.getOccupation() !=null ? profile.getOccupation()
                                                    : "Non fourni" %>
                                            </span>
                                        </div>
                                    </div>

                                    <% if (profile.getBMI() !=null) { double bmi=profile.getBMI().doubleValue(); String
                                        bmiClass="normal" ; String bmiLabel="Normal" ; if (bmi < 18.5) {
                                        bmiClass="underweight" ; bmiLabel="Insuffisance Pondérale" ; } else if (bmi>= 25 && bmi <
                                            30) { bmiClass="overweight" ; bmiLabel="Surpoids" ; } else if (bmi>= 30) {
                                            bmiClass = "obese"; bmiLabel = "Obésité"; }
                                            %>
                                            <div style="margin-top: 1.5rem;">
                                                <label
                                                    style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600;">IMC</label>
                                                <div class="bmi-badge <%= bmiClass %>" style="margin-top: 0.5rem;">
                                                    <%= profile.getBMI() %> - <%= bmiLabel %>
                                                </div>
                                            </div>
                                            <% } %>
                                </div>

                                <!-- Lifestyle -->
                                <div class="section-card animate-fade-in" style="animation-delay: 0.2s;">
                                    <div class="section-header">
                                        <i class="ph ph-lightning"></i>
                                        <h3>Mode de Vie</h3>
                                    </div>

                                    <div class="info-grid">
                                        <div class="info-item">
                                            <label>Niveau d'Activité</label>
                                            <span class="<%= profile.getActivityLevel() != null ? "" : " empty" %>">
                                                <% String activity = profile.getActivityLevel();
                                                   if (activity != null) {
                                                       activity = activity.replace("_", " ");
                                                       if ("SEDENTARY".equalsIgnoreCase(activity)) activity = "Sédentaire";
                                                       else if ("LIGHTLY ACTIVE".equalsIgnoreCase(activity)) activity = "Légèrement actif";
                                                       else if ("MODERATELY ACTIVE".equalsIgnoreCase(activity)) activity = "Modérément actif";
                                                       else if ("VERY ACTIVE".equalsIgnoreCase(activity)) activity = "Très actif";
                                                       else if ("EXTRA ACTIVE".equalsIgnoreCase(activity)) activity = "Extrêmement actif";
                                                   }
                                                %>
                                                <%= activity != null ? activity : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Heures de Sommeil</label>
                                            <span class="<%= profile.getSleepHours() > 0 ? "" : " empty" %>">
                                                <%= profile.getSleepHours()> 0 ? profile.getSleepHours() + " heures/nuit"
                                                    : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Niveau de Stress</label>
                                            <span class="<%= profile.getStressLevel() != null ? "" : " empty" %>">
                                                <% String stress = profile.getStressLevel();
                                                   if (stress != null) {
                                                       if ("low".equalsIgnoreCase(stress)) stress = "Bas";
                                                       else if ("medium".equalsIgnoreCase(stress)) stress = "Moyen";
                                                       else if ("high".equalsIgnoreCase(stress)) stress = "Élevé";
                                                       else stress = stress.substring(0,1).toUpperCase() + stress.substring(1);
                                                   }
                                                %>
                                                <%= stress != null ? stress : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Statut Tabagique</label>
                                            <span class="<%= profile.getSmokingStatus() != null ? "" : " empty" %>">
                                                <% String smoke = profile.getSmokingStatus();
                                                   if (smoke != null) {
                                                       if ("non-smoker".equalsIgnoreCase(smoke)) smoke = "Non-fumeur";
                                                       else if ("smoker".equalsIgnoreCase(smoke)) smoke = "Fumeur";
                                                       else if ("occasional".equalsIgnoreCase(smoke)) smoke = "Occasionnel";
                                                       else smoke = smoke.substring(0,1).toUpperCase() + smoke.substring(1);
                                                   }
                                                %>
                                                <%= smoke != null ? smoke : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Consommation d'Alcool</label>
                                            <span class="<%= profile.getAlcoholConsumption() != null ? "" : " empty"
                                                %>">
                                                <% String alcohol = profile.getAlcoholConsumption();
                                                   if (alcohol != null) {
                                                       if ("never".equalsIgnoreCase(alcohol)) alcohol = "Jamais";
                                                       else if ("occasional".equalsIgnoreCase(alcohol)) alcohol = "Occasionnel";
                                                       else if ("regular".equalsIgnoreCase(alcohol)) alcohol = "Régulier";
                                                       else alcohol = alcohol.substring(0,1).toUpperCase() + alcohol.substring(1);
                                                   }
                                                %>
                                                <%= alcohol != null ? alcohol : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Fréquence d'Exercice</label>
                                            <span class="<%= profile.getExerciseFrequency() != null ? "" : " empty" %>">
                                                <% String freq = profile.getExerciseFrequency();
                                                   if (freq != null) {
                                                       freq = freq.replace("_", " ");
                                                       if ("NEVER".equalsIgnoreCase(freq)) freq = "Jamais";
                                                       else if ("1-2 TIMES PER WEEK".equalsIgnoreCase(freq)) freq = "1-2 fois par semaine";
                                                       else if ("3-4 TIMES PER WEEK".equalsIgnoreCase(freq)) freq = "3-4 fois par semaine";
                                                       else if ("5+ TIMES PER WEEK".equalsIgnoreCase(freq)) freq = "5+ fois par semaine";
                                                   }
                                                %>
                                                <%= freq != null ? freq : "Non fourni" %>
                                            </span>
                                        </div>
                                    </div>

                                    <% if (profile.getExerciseType() !=null && !profile.getExerciseType().isEmpty()) {
                                        %>
                                        <div style="margin-top: 1rem;">
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Type
                                                d'Exercice</label>
                                            <div class="text-block">
                                                <%= profile.getExerciseType() %>
                                            </div>
                                        </div>
                                        <% } %>
                                </div>

                                <!-- Medical History -->
                                <div class="section-card animate-fade-in" style="animation-delay: 0.3s;">
                                    <div class="section-header">
                                        <i class="ph ph-first-aid-kit"></i>
                                        <h3>Antécédents Médicaux</h3>
                                    </div>

                                    <div style="display: grid; gap: 1rem;">
                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Problèmes
                                                Médicaux</label>
                                            <div class="text-block <%= profile.getMedicalConditions() != null && !profile.getMedicalConditions().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getMedicalConditions() !=null &&
                                                    !profile.getMedicalConditions().isEmpty() ?
                                                    profile.getMedicalConditions() : "Aucun signalé" %>
                                            </div>
                                        </div>

                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Allergies
                                                Alimentaires</label>
                                            <div class="text-block <%= profile.getAllergies() != null && !profile.getAllergies().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getAllergies() !=null && !profile.getAllergies().isEmpty() ?
                                                    profile.getAllergies() : "Aucune signalée" %>
                                            </div>
                                        </div>

                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Médicaments
                                                Actuels</label>
                                            <div class="text-block <%= profile.getCurrentMedications() != null && !profile.getCurrentMedications().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getCurrentMedications() !=null &&
                                                    !profile.getCurrentMedications().isEmpty() ?
                                                    profile.getCurrentMedications() : "Aucun signalé" %>
                                            </div>
                                        </div>

                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Problèmes
                                                Digestifs</label>
                                            <div class="text-block <%= profile.getDigestiveIssues() != null && !profile.getDigestiveIssues().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getDigestiveIssues() !=null &&
                                                    !profile.getDigestiveIssues().isEmpty() ?
                                                    profile.getDigestiveIssues() : "Aucun signalé" %>
                                            </div>
                                        </div>

                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Antécédents
                                                Médicaux Familiaux</label>
                                            <div class="text-block <%= profile.getFamilyMedicalHistory() != null && !profile.getFamilyMedicalHistory().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getFamilyMedicalHistory() !=null &&
                                                    !profile.getFamilyMedicalHistory().isEmpty() ?
                                                    profile.getFamilyMedicalHistory() : "Aucun signalé" %>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Dietary Information -->
                                <div class="section-card animate-fade-in" style="animation-delay: 0.4s;">
                                    <div class="section-header">
                                        <i class="ph ph-bowl-food"></i>
                                        <h3>Informations Diététiques</h3>
                                    </div>

                                    <div class="info-grid" style="margin-bottom: 1rem;">
                                        <div class="info-item">
                                            <label>Consommation d'Eau Quotidienne</label>
                                            <span class="<%= profile.getDailyWaterIntake() > 0 ? "" : " empty" %>">
                                                <%= profile.getDailyWaterIntake()> 0 ? profile.getDailyWaterIntake() +
                                                    " verres" : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Repas par Jour</label>
                                            <span class="<%= profile.getMealsPerDay() > 0 ? "" : " empty" %>">
                                                <%= profile.getMealsPerDay()> 0 ? profile.getMealsPerDay() : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Habitudes de Grignotage</label>
                                            <span class="<%= profile.getSnackingHabits() != null ? "" : " empty" %>">
                                                <% String snack = profile.getSnackingHabits();
                                                   if (snack != null) {
                                                       if ("never".equalsIgnoreCase(snack)) snack = "Jamais";
                                                       else if ("occasional".equalsIgnoreCase(snack)) snack = "Occasionnel";
                                                       else if ("frequent".equalsIgnoreCase(snack)) snack = "Fréquent";
                                                       else snack = snack.substring(0,1).toUpperCase() + snack.substring(1);
                                                   }
                                                %>
                                                <%= snack != null ? snack : "Non fourni" %>
                                            </span>
                                        </div>
                                    </div>

                                    <div style="display: grid; gap: 1rem;">
                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Restrictions
                                                Alimentaires</label>
                                            <div class="text-block <%= profile.getDietaryRestrictions() != null && !profile.getDietaryRestrictions().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getDietaryRestrictions() !=null && !profile.getDietaryRestrictions().isEmpty() ?
                                                    profile.getDietaryRestrictions() : "Aucune" %>
                                            </div>
                                        </div>

                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Préférences
                                                Alimentaires</label>
                                            <div class="text-block <%= profile.getFoodPreferences() != null && !profile.getFoodPreferences().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getFoodPreferences() !=null &&
                                                    !profile.getFoodPreferences().isEmpty() ?
                                                    profile.getFoodPreferences() : "Non fourni" %>
                                            </div>
                                        </div>

                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Aliments
                                                à Éviter</label>
                                            <div class="text-block <%= profile.getFoodsToAvoid() != null && !profile.getFoodsToAvoid().isEmpty() ? "" : "empty" %>">
                                                <%= profile.getFoodsToAvoid() !=null && !profile.getFoodsToAvoid().isEmpty() ? profile.getFoodsToAvoid()
                                                    : "Aucun" %>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Health Goals -->
                                <div class="section-card animate-fade-in" style="animation-delay: 0.5s;">
                                    <div class="section-header">
                                        <i class="ph ph-target"></i>
                                        <h3>Objectifs de Santé</h3>
                                    </div>

                                    <div class="info-grid" style="margin-bottom: 1rem;">
                                        <div class="info-item">
                                            <label>Objectif Principal</label>
                                            <span class="<%= profile.getPrimaryGoal() != null ? "" : " empty" %>"
                                                style="font-weight: 600; color: var(--primary);">
                                                <% String goal = profile.getPrimaryGoal();
                                                   if (goal != null) {
                                                       goal = goal.replace("_", " ");
                                                       if ("WEIGHT LOSS".equalsIgnoreCase(goal)) goal = "Perte de poids";
                                                       else if ("WEIGHT GAIN".equalsIgnoreCase(goal)) goal = "Prise de poids";
                                                       else if ("MUSCLE GAIN".equalsIgnoreCase(goal)) goal = "Prise de muscle";
                                                       else if ("HEALTHY EATING".equalsIgnoreCase(goal)) goal = "Alimentation saine";
                                                       else goal = goal.toUpperCase();
                                                   }
                                                %>
                                                <%= goal != null ? goal : "Non fourni" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <label>Niveau de Motivation</label>
                                            <span class="<%= profile.getMotivationLevel() != null ? "" : " empty" %>">
                                                <% String motivation = profile.getMotivationLevel();
                                                   if (motivation != null) {
                                                       motivation = motivation.replace("_", " ");
                                                       if ("VERY LOW".equalsIgnoreCase(motivation)) motivation = "Très bas";
                                                       else if ("LOW".equalsIgnoreCase(motivation)) motivation = "Bas";
                                                       else if ("MEDIUM".equalsIgnoreCase(motivation)) motivation = "Moyen";
                                                       else if ("HIGH".equalsIgnoreCase(motivation)) motivation = "Élevé";
                                                       else if ("VERY HIGH".equalsIgnoreCase(motivation)) motivation = "Très élevé";
                                                   }
                                                %>
                                                <%= motivation != null ? motivation : "Non fourni" %>
                                            </span>
                                        </div>
                                    </div>

                                    <% if (profile.getSecondaryGoals() !=null && !profile.getSecondaryGoals().isEmpty())
                                        { %>
                                        <div>
                                            <label
                                                style="font-size: 0.75rem; text-transform: uppercase; color: var(--gray-500); font-weight: 600; display: block; margin-bottom: 0.5rem;">Objectifs
                                                Secondaires</label>
                                            <div class="text-block">
                                                <%= profile.getSecondaryGoals() %>
                                            </div>
                                        </div>
                                        <% } %>
                                </div>

                                <!-- Additional Notes -->
                                <% if (profile.getAdditionalNotes() !=null && !profile.getAdditionalNotes().isEmpty()) {
                                    %>
                                    <div class="section-card animate-fade-in" style="animation-delay: 0.6s;">
                                        <div class="section-header">
                                            <i class="ph ph-note-pencil"></i>
                                            <h3>Notes Additionnelles</h3>
                                        </div>
                                        <div class="text-block">
                                            <%= profile.getAdditionalNotes() %>
                                        </div>
                                    </div>
                                    <% } %>

                                        <!-- Diet Compliance Section -->
                                        <%@ page import="com.nutrit.models.MealTracking" %>
                                            <%@ page import="com.nutrit.models.DailyProgress" %>
                                                <%@ page import="java.util.Map" %>
                                                    <%@ page import="java.util.List" %>
                                                        <% Map<String, Object> complianceStats = (Map<String, Object>)
                                                                request.getAttribute("complianceStats");
                                                                List<MealTracking> recentDeviations = (List
                                                                    <MealTracking>)
                                                                        request.getAttribute("recentDeviations");
                                                                        List<DailyProgress> progressHistory = (List
                                                                            <DailyProgress>)
                                                                                request.getAttribute("progressHistory");
                                                                                %>

                                                                                <% if (complianceStats !=null &&
                                                                                    complianceStats.get("totalMeals")
                                                                                    !=null &&
                                                                                    ((Integer)complianceStats.get("totalMeals"))>
                                                                                    0) { %>
                                                                                    <div class="section-card animate-fade-in"
                                                                                        style="animation-delay: 0.65s;">
                                                                                        <div class="section-header">
                                                                                            <i
                                                                                                class="ph ph-chart-pie"></i>
                                                                                            <h3>Observance du Régime</h3>
                                                                                        </div>

                                                                                        <!-- Compliance Stats Card -->
                                                                                        <div
                                                                                            style="background: var(--gradient-primary); color: white; border-radius: var(--radius-xl); padding: 1.5rem; margin-bottom: 1.5rem;">
                                                                                            <div
                                                                                                style="display: flex; justify-content: space-between; align-items: center;">
                                                                                                <div>
                                                                                                    <div
                                                                                                        style="font-size: 0.875rem; opacity: 0.9;">
                                                                                                        Taux d'Observance
                                                                                                        Global
                                                                                                    </div>
                                                                                                    <div
                                                                                                        style="font-size: 2.5rem; font-weight: 700;">
                                                                                                        <%= complianceStats.get("complianceRate")
                                                                                                            %>%
                                                                                                    </div>
                                                                                                </div>
                                                                                                <i class="ph ph-chart-line-up"
                                                                                                    style="font-size: 3rem; opacity: 0.3;"></i>
                                                                                            </div>
                                                                                            <div
                                                                                                style="height: 8px; background: rgba(255,255,255,0.3); border-radius: 4px; margin-top: 1rem; overflow: hidden;">
                                                                                                <div style="height: 100%; background: white; border-radius: 4px; width: <%= complianceStats.get("complianceRate") %>%;"></div>
                                                                                            </div>
                                                                                            <div
                                                                                                style="display: flex; justify-content: space-between; margin-top: 0.75rem; font-size: 0.875rem; opacity: 0.9;">
                                                                                                <span><i
                                                                                                        class="ph ph-check-circle"></i>
                                                                                                    <%= complianceStats.get("completedMeals")
                                                                                                        %> repas
                                                                                                        terminés
                                                                                                </span>
                                                                                                <span><i
                                                                                                        class="ph ph-x-circle"></i>
                                                                                                    <%= complianceStats.get("missedMeals")
                                                                                                        %> repas manqués
                                                                                                </span>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    <% } %>

                                                                                        <!-- Recent Deviations -->
                                                                                        <% if (recentDeviations !=null
                                                                                            &&
                                                                                            !recentDeviations.isEmpty())
                                                                                            { %>
                                                                                            <div class="section-card animate-fade-in"
                                                                                                style="animation-delay: 0.7s;">
                                                                                                <div
                                                                                                    class="section-header">
                                                                                                    <i class="ph ph-warning"
                                                                                                        style="color: var(--warning);"></i>
                                                                                                    <h3>Écarts Alimentaires Récents</h3>
                                                                                                </div>

                                                                                                <p
                                                                                                    style="color: var(--gray-600); font-size: 0.875rem; margin-bottom: 1rem;">
                                                                                                    Moments où le
                                                                                                    patient n'a pas
                                                                                                    suivi le régime
                                                                                                    prévu et ce qu'il a
                                                                                                    mangé à la place :
                                                                                                </p>

                                                                                                <div
                                                                                                    style="display: flex; flex-direction: column; gap: 0.75rem;">
                                                                                                    <% for (MealTracking
                                                                                                        deviation :
                                                                                                        recentDeviations)
                                                                                                        { %>
                                                                                                        <div
                                                                                                            style="background: linear-gradient(135deg, #FEE2E2, #FEF2F2); border-left: 4px solid var(--error); padding: 1rem; border-radius: var(--radius-lg);">
                                                                                                            <div
                                                                                                                style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 0.5rem;">
                                                                                                                <div>
                                                                                                                    <span
                                                                                                                        style="font-weight: 600; color: var(--gray-800); text-transform: capitalize;">
                                                                                                                        <% String mealType = deviation.getMealType();
                                                                                                                            if ("morning".equalsIgnoreCase(mealType)) mealType = "Petit-déjeuner";
                                                                                                                            else if ("noon".equalsIgnoreCase(mealType)) mealType = "Déjeuner";
                                                                                                                            else if ("night".equalsIgnoreCase(mealType)) mealType = "Dîner";
                                                                                                                            else if ("snacks".equalsIgnoreCase(mealType)) mealType = "Collations";
                                                                                                                         %>
                                                                                                                         <%= mealType %>
                                                                                                                    </span>
                                                                                                                    <span
                                                                                                                        style="color: var(--gray-500); font-size: 0.875rem;">
                                                                                                                        -
                                                                                                                        <%= deviation.getTrackingDate()
                                                                                                                            %>
                                                                                                                    </span>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                            <% if
                                                                                                                (deviation.getAlternativeMeal()
                                                                                                                !=null
                                                                                                                &&
                                                                                                                !deviation.getAlternativeMeal().isEmpty())
                                                                                                                { %>
                                                                                                                <div
                                                                                                                    style="margin-top: 0.5rem; padding: 0.75rem; background: white; border-radius: var(--radius-md);">
                                                                                                                    <div
                                                                                                                        style="font-size: 0.75rem; color: var(--error); font-weight: 600; margin-bottom: 0.25rem;">
                                                                                                                        <i
                                                                                                                            class="ph ph-swap"></i>
                                                                                                                        Ce qu'il a
                                                                                                                        mangé à la
                                                                                                                        place :
                                                                                                                    </div>
                                                                                                                    <div
                                                                                                                        style="color: var(--gray-700);">
                                                                                                                        <%= deviation.getAlternativeMeal()
                                                                                                                            %>
                                                                                                                    </div>
                                                                                                                </div>
                                                                                                                <% } %>
                                                                                                                    <% if
                                                                                                                        (deviation.getNotes()
                                                                                                                        !=null
                                                                                                                        &&
                                                                                                                        !deviation.getNotes().isEmpty())
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <div
                                                                                                                            style="margin-top: 0.5rem; font-size: 0.875rem; color: var(--gray-600);">
                                                                                                                            <%= deviation.getNotes()
                                                                                                                                %>
                                                                                                                        </div>
                                                                                                                        <% }
                                                                                                                            %>
                                                                                                        </div>
                                                                                                        <% } %>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } %>

                                                                                                <!-- Weight Progress History -->
                                                                                                <% if (progressHistory
                                                                                                    !=null &&
                                                                                                    !progressHistory.isEmpty())
                                                                                                    { %>
                                                                                                    <div class="section-card animate-fade-in"
                                                                                                        style="animation-delay: 0.75s;">
                                                                                                        <div
                                                                                                            class="section-header">
                                                                                                            <i
                                                                                                                class="ph ph-scales"></i>
                                                                                                            <h3>Historique de l'Évolution de Poids</h3>
                                                                                                        </div>

                                                                                                        <div
                                                                                                            style="overflow-x: auto;">
                                                                                                            <table
                                                                                                                style="width: 100%; border-collapse: collapse;">
                                                                                                                <thead>
                                                                                                                    <tr
                                                                                                                        style="border-bottom: 2px solid var(--border);">
                                                                                                                        <th
                                                                                                                            style="text-align: left; padding: 0.75rem; font-weight: 600; color: var(--gray-600);">
                                                                                                                            Date
                                                                                                                        </th>
                                                                                                                        <th
                                                                                                                            style="text-align: left; padding: 0.75rem; font-weight: 600; color: var(--gray-600);">
                                                                                                                            Poids
                                                                                                                        </th>
                                                                                                                        <th
                                                                                                                            style="text-align: left; padding: 0.75rem; font-weight: 600; color: var(--gray-600);">
                                                                                                                            Consommation
                                                                                                                            d'Eau
                                                                                                                        </th>
                                                                                                                    </tr>
                                                                                                                </thead>
                                                                                                                <tbody>
                                                                                                                    <% double
                                                                                                                        previousWeight=0;
                                                                                                                        boolean
                                                                                                                        isFirst=true;
                                                                                                                        for
                                                                                                                        (DailyProgress
                                                                                                                        p
                                                                                                                        :
                                                                                                                        progressHistory)
                                                                                                                        {
                                                                                                                        double
                                                                                                                        change=isFirst
                                                                                                                        ?
                                                                                                                        0
                                                                                                                        :
                                                                                                                        p.getWeight()
                                                                                                                        -
                                                                                                                        previousWeight;
                                                                                                                        String
                                                                                                                        changeClass=change
                                                                                                                        <
                                                                                                                        0
                                                                                                                        ? "color: var(--success)"
                                                                                                                        :
                                                                                                                        (change>
                                                                                                                        0
                                                                                                                        ?
                                                                                                                        "color:var(--error)"
                                                                                                                        :
                                                                                                                        "");
                                                                                                                        String
                                                                                                                        changeIcon
                                                                                                                        =
                                                                                                                        change
                                                                                                                        < 0 ? "arrow-down"
                                                                                                                            :
                                                                                                                            (change>
                                                                                                                            0
                                                                                                                            ?
                                                                                                                            "arrow-up"
                                                                                                                            :
                                                                                                                            "minus");
                                                                                                                            %>
                                                                                                                            <tr
                                                                                                                                style="border-bottom: 1px solid var(--border);">
                                                                                                                                <td
                                                                                                                                    style="padding: 0.75rem;">
                                                                                                                                    <%= p.getDate()
                                                                                                                                        %>
                                                                                                                                </td>
                                                                                                                                <td
                                                                                                                                    style="padding: 0.75rem;">
                                                                                                                                    <span
                                                                                                                                        style="font-weight: 600;">
                                                                                                                                        <%= p.getWeight()
                                                                                                                                            %>
                                                                                                                                            kg
                                                                                                                                    </span>
                                                                                                                                    <% if
                                                                                                                                        (!isFirst
                                                                                                                                        &&
                                                                                                                                        change
                                                                                                                                        !=0)
                                                                                                                                        {
                                                                                                                                        %>
                                                                                                                                        <span
                                                                                                                                            style="font-size: 0.75rem; margin-left: 0.5rem; <%= changeClass %>">
                                                                                                                                            <i
                                                                                                                                                class="ph ph-<%= changeIcon %>"></i>
                                                                                                                                            <%= String.format("%.1f",
                                                                                                                                                Math.abs(change))
                                                                                                                                                %>
                                                                                                                                                kg
                                                                                                                                        </span>
                                                                                                                                        <% }
                                                                                                                                            %>
                                                                                                                                </td>
                                                                                                                                <td
                                                                                                                                    style="padding: 0.75rem;">
                                                                                                                                    <%= p.getWaterIntake()
                                                                                                                                        %>
                                                                                                                                        verres
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <% previousWeight=p.getWeight();
                                                                                                                                isFirst=false;
                                                                                                                                }
                                                                                                                                %>
                                                                                                                </tbody>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <% } %>

                                                                                                    <!-- Invoices Section -->
                                                                                                    <%@ page import="com.nutrit.models.Invoice" %>
                                                                                                    <% java.util.List<Invoice> invoices = (java.util.List<Invoice>) request.getAttribute("invoices"); %>
                                                                                                    
                                                                                                    <div id="invoices" class="section-card animate-fade-in" style="animation-delay: 0.8s;">
                                                                                                        <div class="section-header">
                                                                                                            <i class="ph ph-receipt"></i>
                                                                                                            <h3>Factures et Facturation</h3>
                                                                                                        </div>
                                                                                                        
                                                                                                        <% if (invoices != null && !invoices.isEmpty()) { %>
                                                                                                        <div class="table-container">
                                                                                                            <table>
                                                                                                                <thead>
                                                                                                                    <tr>
                                                                                                                        <th>Facture #</th>
                                                                                                                        <th>Date</th>
                                                                                                                        <th>Montant</th>
                                                                                                                        <th>Statut</th>
                                                                                                                        <th>Action</th>
                                                                                                                    </tr>
                                                                                                                </thead>
                                                                                                                <tbody>
                                                                                                                    <% java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy", java.util.Locale.FRENCH);
                                                                                                                       for(Invoice inv : invoices) { %>
                                                                                                                    <tr>
                                                                                                                        <td style="font-weight: 500;"><%= inv.getInvoiceNumber() %></td>
                                                                                                                        <td style="color: var(--gray-600);"><%= inv.getCreatedAt() != null ? sdf.format(inv.getCreatedAt()) : "-" %></td>
                                                                                                                        <td style="font-weight: 600;"><%= inv.getAmount() %> DNT</td>
                                                                                                                        <td>
                                                                                                                            <span class="status-badge <%= "paid".equals(inv.getPaymentStatus()) ? "complete" : "incomplete" %>">
                                                                                                                                <%= "paid".equals(inv.getPaymentStatus()) ? "PAYÉ" : "NON PAYÉ" %>
                                                                                                                            </span>
                                                                                                                        </td>
                                                                                                                        <td>
                                                                                                                            <a href="${pageContext.request.contextPath}/secretary/invoice?appointmentId=<%= inv.getAppointmentId() %>" target="_blank" class="btn btn-outline btn-sm">
                                                                                                                                <i class="ph ph-printer"></i>
                                                                                                                            </a>
                                                                                                                        </td>
                                                                                                                    </tr>
                                                                                                                    <% } %>
                                                                                                                </tbody>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <% } else { %>
                                                                                                            <div class="empty-state">
                                                                                                                <div class="empty-state-icon">
                                                                                                                    <i class="ph ph-receipt"></i>
                                                                                                                </div>
                                                                                                                <div class="empty-state-title">Aucune Facture Trouvée</div>
                                                                                                                <div class="empty-state-text">Il n'y a pas encore de factures générées pour ce patient.</div>
                                                                                                            </div>
                                                                                                        <% } %>
                                                                                                    </div>

                                                                                                        <!-- Quick Actions for Nutritionist -->
                                                                                                        <div class="section-card animate-fade-in"
                                                                                                            style="animation-delay: 0.8s;">
                                                                                                            <div
                                                                                                                class="section-header">
                                                                                                                <i
                                                                                                                    class="ph ph-lightning"></i>
                                                                                                                <h3>Actions Rapides</h3>
                                                                                                            </div>

                                                                                                            <div
                                                                                                                style="display: flex; flex-wrap: wrap; gap: 0.75rem;">
                                                                                                                <a href="${pageContext.request.contextPath}/nutritionist/mealPlan/create?patientId=<%= patient.getId() %>"
                                                                                                                    class="btn btn-primary">
                                                                                                                    <i
                                                                                                                        class="ph ph-fork-knife"></i>
                                                                                                                    Plan Alimentaire
                                                                                                                </a>
                                                                                                            </div>
                                                                                                        </div>

                                                                                                        <% } %>

                                                                                                            <% } else {
                                                                                                                %>
                                                                                                                <div
                                                                                                                    class="section-card">
                                                                                                                    <div
                                                                                                                        class="empty-state">
                                                                                                                        <div
                                                                                                                            class="empty-state-icon">
                                                                                                                            <i
                                                                                                                                class="ph ph-user-circle-minus"></i>
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="empty-state-title">
                                                                                                                            Patient Non Trouvé
                                                                                                                        </div>
                                                                                                                        <div
                                                                                                                            class="empty-state-text">
                                                                                                                            Le patient demandé n'a pas pu être trouvé.
                                                                                                                        </div>
                                                                                                                    </div>
                                                                                                                </div>
                                                                                                                <% } %>
                </div>
                </main>
                </div>
            </body>

            </html>