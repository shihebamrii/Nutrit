<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="com.nutrit.models.NutritionistProfile" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paramètres - Nutrit</title>
    <meta name="description" content="Gérez les paramètres de votre compte, vos informations personnelles et vos préférences de sécurité.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* Centering and layout optimization */
        .settings-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .page-header.centered {
            text-align: center;
            margin-bottom: 2rem;
        }

        .profile-avatar-large {
            width: 80px; 
            height: 80px; 
            border-radius: 50%; 
            background: var(--gradient-primary); 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            color: #fff; 
            font-weight: 700; 
            font-size: 1.75rem; 
            box-shadow: var(--shadow-md); 
            overflow: hidden;
            flex-shrink: 0;
        }
    </style>
</head>

<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />

            <div class="page-content">
                <div class="settings-container">
                    
                    <div class="page-header centered">
                        <h1>Paramètres du Compte</h1>
                        <p>Gérez vos informations personnelles et paramètres de sécurité.</p>
                    </div>

                    <% if (request.getAttribute("successMessage") !=null) { %>
                        <div class="alert alert-success animate-fade-in mb-4">
                            <i class="ph ph-check-circle" style="font-size: 1.25rem; flex-shrink: 0;"></i>
                            <span><%= request.getAttribute("successMessage") %></span>
                        </div>
                    <% } %>

                    <% if (request.getAttribute("errorMessage") !=null) { %>
                        <div class="alert alert-error animate-fade-in mb-4">
                            <i class="ph ph-warning-circle" style="font-size: 1.25rem; flex-shrink: 0;"></i>
                            <span><%= request.getAttribute("errorMessage") %></span>
                        </div>
                    <% } %>

                    <% 
                        User u = (User) request.getAttribute("user"); 
                        if (u == null) u = (User) session.getAttribute("user"); 
                        
                        String initials = "U";
                        if (u.getFullName() != null && !u.getFullName().isEmpty()) {
                            String[] names = u.getFullName().split(" ");
                            initials = names[0].substring(0, 1);
                            if (names.length > 1) initials += names[names.length - 1].substring(0, 1);
                        }
                    %>

                    <div class="card mb-6 animate-fade-in">
                        <div class="flex items-center gap-5">
                            <div class="profile-avatar-large">
                                <% if (u.getProfilePicture() != null && !u.getProfilePicture().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/<%= u.getProfilePicture() %>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <%= initials.toUpperCase() %>
                                <% } %>
                            </div>
                            <div>
                                <h2 style="font-size: 1.5rem; margin-bottom: 0.25rem;"><%= u.getFullName() %></h2>
                                <div class="flex items-center gap-3">
                                    <span class="badge badge-primary"><%= u.getRole() %></span>
                                    <span class="text-sm text-gray"><%= u.getEmail() %></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card form-section animate-fade-in mb-6" style="animation-delay: 0.1s;">
                        <div class="card-header">
                            <h3>
                                <i class="ph ph-user-circle mr-2" style="color: var(--primary);"></i>
                                Informations Personnelles
                            </h3>
                        </div>

                        <form action="${pageContext.request.contextPath}/profile" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="updateBasic">
                            <div class="form-grid">
                                <div class="form-group full-width">
                                    <label class="label" for="profilePicture">Photo de Profil</label>
                                    <input type="file" id="profilePicture" name="profilePicture" class="input" accept="image/*">
                                    <small class="text-xs text-gray-500">Recommandé : Image carrée, max 2Mo</small>
                                </div>
                                <div class="form-group full-width">
                                    <label class="label" for="fullName">Nom Complet</label>
                                    <input type="text" id="fullName" name="fullName" class="input" value="<%= u.getFullName() %>" required>
                                </div>
                                <div class="form-group">
                                    <label class="label" for="email">Email (Lecture seule)</label>
                                    <input type="email" id="email" class="input" value="<%= u.getEmail() %>" disabled style="background-color: var(--gray-100); cursor: not-allowed;">
                                </div>
                                <div class="form-group">
                                    <label class="label" for="phone">Téléphone</label>
                                    <input type="tel" id="phone" name="phone" class="input" value="<%= u.getPhone() != null ? u.getPhone() : "" %>" placeholder="Entrez votre numéro de téléphone">
                                </div>
                                <div class="form-group full-width">
                                    <label class="label" for="address">Adresse</label>
                                    <input type="text" id="address" name="address" class="input" value="<%= u.getAddress() != null ? u.getAddress() : "" %>" placeholder="Entrez votre adresse">
                                </div>
                                <div class="form-group full-width">
                                    <label class="label" for="communityBio">Bio Communautaire</label>
                                    <textarea id="communityBio" name="communityBio" class="input" rows="3" placeholder="Présentez-vous à la communauté..."><%= u.getBio() != null ? u.getBio() : "" %></textarea>
                                </div>
                            </div>
                            <div class="flex justify-end mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="ph ph-floppy-disk"></i> Enregistrer
                                </button>
                            </div>
                        </form>
                    </div>

                    <% if ("nutritionist".equals(u.getRole())) { 
                        NutritionistProfile np = (NutritionistProfile) request.getAttribute("nutritionistProfile"); 
                        if (np != null) { %>
                        <div class="card form-section animate-fade-in mb-6" style="animation-delay: 0.2s;">
                            <div class="card-header">
                                <h3>
                                    <i class="ph ph-certificate mr-2" style="color: var(--success);"></i>
                                    Profil Professionnel
                                </h3>
                            </div>
                            <form action="${pageContext.request.contextPath}/profile" method="POST">
                                <input type="hidden" name="action" value="updateNutritionist">
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label class="label" for="specialization">Spécialisation</label>
                                        <input type="text" id="specialization" name="specialization" class="input" value="<%= np.getSpecialization() %>" placeholder="ex: Nutrition Sportive">
                                    </div>
                                    <div class="form-group">
                                        <label class="label" for="yearsExperience">Expérience (Années)</label>
                                        <input type="number" id="yearsExperience" name="yearsExperience" class="input" value="<%= np.getYearsExperience() %>" min="0">
                                    </div>
                                    <div class="form-group">
                                        <label class="label" for="licenseNumber">Numéro de Licence</label>
                                        <input type="text" id="licenseNumber" name="licenseNumber" class="input" value="<%= np.getLicenseNumber() %>">
                                    </div>
                                    <div class="form-group">
                                        <label class="label" for="price">Prix Consultation (TND)</label>
                                        <input type="number" step="0.01" id="price" name="price" class="input" value="<%= np.getPrice() %>" min="0">
                                    </div>
                                    <div class="form-group full-width">
                                        <label class="label" for="clinicAddress">Adresse Cabinet</label>
                                        <input type="text" id="clinicAddress" name="clinicAddress" class="input" value="<%= np.getClinicAddress() %>">
                                    </div>
                                    <div class="form-group full-width">
                                        <label class="label" for="workingHours">Horaires de Travail</label>
                                        <input type="text" id="workingHours" name="workingHours" class="input" placeholder="ex: Lun-Ven 9h-17h" value="<%= np.getWorkingHours() %>">
                                    </div>
                                    <div class="form-group full-width">
                                        <label class="label" for="bio">Bio Professionnelle</label>
                                        <textarea id="bio" name="bio" class="input" rows="4" placeholder="Votre approche..."><%= np.getBio() != null ? np.getBio() : "" %></textarea>
                                    </div>
                                </div>
                                <div class="flex justify-end mt-4">
                                    <button type="submit" class="btn btn-success">
                                        <i class="ph ph-floppy-disk"></i> Mettre à jour
                                    </button>
                                </div>
                            </form>
                        </div>
                    <% } } %>

                    <div class="card animate-fade-in mb-6" style="animation-delay: 0.3s;">
                        <div class="card-header">
                            <h3>
                                <i class="ph ph-shield-check mr-2" style="color: var(--warning);"></i>
                                Sécurité
                            </h3>
                        </div>
                        <form action="${pageContext.request.contextPath}/profile" method="POST">
                            <input type="hidden" name="action" value="updatePassword">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="label" for="newPassword">Nouveau Mot de Passe</label>
                                    <input type="password" id="newPassword" name="newPassword" class="input" required placeholder="Nouveau mot de passe">
                                </div>
                                <div class="form-group">
                                    <label class="label" for="confirmPassword">Confirmer</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="input" required placeholder="Confirmez">
                                </div>
                            </div>
                            <div class="flex justify-end mt-4">
                                <button type="submit" class="btn btn-outline">
                                    <i class="ph ph-key"></i> Changer le Mot de Passe
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="text-center text-sm text-gray mt-6 pb-10">
                        <i class="ph ph-clock mr-1"></i>
                        Membre depuis <%= u.getCreatedAt() %>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>

</html>