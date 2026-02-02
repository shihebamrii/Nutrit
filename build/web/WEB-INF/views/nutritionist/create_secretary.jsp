<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer un Secrétaire - Nutrit</title>
    <meta name="description" content="Créez un nouveau compte de secrétaire pour vous aider à gérer votre cabinet.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* New styles for centering */
        .secretary-container {
            max-width: 640px;
            margin: 0 auto; /* This centers the container horizontally */
        }
        
        .page-header.centered {
            text-align: center;
        }
    </style>
</head>

<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />

            <div class="page-content">
                
                <div class="secretary-container">
                    
                    <div class="page-header centered">
                        <h1>Créer un Compte Secrétaire</h1>
                        <p>Ajoutez un nouveau secrétaire pour vous aider à gérer vos rendez-vous et vos patients.</p>
                    </div>

                    <div class="card animate-fade-in">
                        <div class="card-header">
                            <h3>
                                <i class="ph <%= request.getAttribute("secretary") != null ? "ph-pencil-simple" : "ph-user-plus" %> mr-2" style="color: var(--primary);"></i>
                                <%= request.getAttribute("secretary") != null ? "Modifier le Secrétaire" : "Détails du Secrétaire" %>
                            </h3>
                        </div>

                        <% if (request.getAttribute("success") !=null) { %>
                            <div class="alert alert-success mb-4">
                                <i class="ph ph-check-circle" style="font-size: 1.25rem; flex-shrink: 0;"></i>
                                <span>
                                    <%= request.getAttribute("success") %>
                                </span>
                            </div>
                        <% } %>

                        <% if (request.getAttribute("error") !=null) { %>
                            <div class="alert alert-error mb-4">
                                <i class="ph ph-warning-circle" style="font-size: 1.25rem; flex-shrink: 0;"></i>
                                <span>
                                    <%= request.getAttribute("error") %>
                                </span>
                            </div>
                        <% } %>

                        <% 
                            com.nutrit.models.User secretary = (com.nutrit.models.User) request.getAttribute("secretary");
                            boolean isEdit = (secretary != null);
                            String formAction = isEdit ? "/nutritionist/editSecretary" : "/nutritionist/createSecretary";
                        %>

                        <form action="${pageContext.request.contextPath}<%= formAction %>" method="POST">
                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= secretary.getId() %>">
                            <% } %>
                            
                            <div class="form-grid">
                                <div class="form-group full-width">
                                    <label class="label" for="full_name">
                                        <i class="ph ph-user mr-1"></i>
                                        Nom Complet
                                    </label>
                                    <input type="text" id="full_name" name="full_name" class="input"
                                        required placeholder="Entrez le nom complet" value="<%= isEdit ? secretary.getFullName() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label class="label" for="email">
                                        <i class="ph ph-envelope mr-1"></i>
                                        Adresse Email
                                    </label>
                                    <input type="email" id="email" name="email" class="input" required
                                        placeholder="secretaire@exemple.com" value="<%= isEdit ? secretary.getEmail() : "" %>">
                                </div>

                                <div class="form-group">
                                    <label class="label" for="phone">
                                        <i class="ph ph-phone mr-1"></i>
                                        Numéro de Téléphone
                                    </label>
                                    <input type="tel" id="phone" name="phone" class="input" required
                                        placeholder="Entrez le numéro de téléphone" value="<%= isEdit ? secretary.getPhone() : "" %>">
                                </div>

                                <div class="form-group full-width">
                                    <label class="label" for="password">
                                        <i class="ph ph-lock mr-1"></i>
                                        Mot de Passe <%= isEdit ? "(Laisser vide pour ne pas changer)" : "Initial" %>
                                    </label>
                                    <input type="password" id="password" name="password" class="input"
                                        <%= isEdit ? "" : "required" %> placeholder="<%= isEdit ? "Nouveau mot de passe (optionnel)" : "Créez un mot de passe sécurisé" %>">
                                </div>
                            </div>

                            <div class="flex justify-between items-center mt-6 pt-4"
                                style="border-top: 1px solid var(--border);">
                                <a href="${pageContext.request.contextPath}/nutritionist/secretaries"
                                    class="btn btn-secondary">
                                    <i class="ph ph-arrow-left"></i>
                                    Annuler
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="ph <%= isEdit ? "ph-check" : "ph-user-plus" %>"></i>
                                    <%= isEdit ? "Mettre à jour" : "Créer le Compte" %>
                                </button>
                            </div>
                        </form>
                    </div>
                </div> </div>
        </main>
    </div>
</body>

</html>