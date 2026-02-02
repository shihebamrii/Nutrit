<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>
            <%@ page import="com.nutrit.models.User" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Trouver un Nutritionniste - Nutrit</title>
                    <meta name="description" content="Parcourez et connectez-vous avec des nutritionnistes certifiés.">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                    <script src="https://unpkg.com/@phosphor-icons/web"></script>
                    <style>
                        .nutritionists-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                            gap: 1.5rem;
                        }

                        .nutritionist-card {
                            background: white;
                            border-radius: var(--radius-xl);
                            padding: 1.5rem;
                            box-shadow: var(--shadow-md);
                            transition: all var(--transition-normal);
                            border: 1px solid var(--border);
                        }

                        .nutritionist-card:hover {
                            transform: translateY(-4px);
                            box-shadow: var(--shadow-lg);
                        }

                        .nutritionist-header {
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                            margin-bottom: 1rem;
                        }

                        .nutritionist-avatar {
                            width: 64px;
                            height: 64px;
                            border-radius: var(--radius-full);
                            background: var(--gradient-primary);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-size: 1.5rem;
                            font-weight: 700;
                        }

                        .nutritionist-name {
                            font-size: 1.25rem;
                            font-weight: 600;
                            color: var(--gray-900);
                        }

                        .nutritionist-title {
                            font-size: 0.875rem;
                            color: var(--gray-500);
                        }

                        .rating-display {
                            display: flex;
                            align-items: center;
                            gap: 0.5rem;
                            margin-bottom: 1rem;
                        }

                        .stars {
                            display: flex;
                            gap: 0.125rem;
                        }

                        .star {
                            color: #FCD34D;
                            font-size: 1rem;
                        }

                        .star.empty {
                            color: var(--gray-300);
                        }

                        .rating-text {
                            font-size: 0.875rem;
                            color: var(--gray-600);
                        }

                        .card-actions {
                            display: flex;
                            gap: 0.75rem;
                            margin-top: 1rem;
                        }

                        .search-section {
                            margin-bottom: 2rem;
                        }

                        .search-box {
                            display: flex;
                            gap: 1rem;
                            max-width: 500px;
                        }

                        .search-box .input {
            flex: 1;
        }

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .modal-card {
            background: white;
            border-radius: var(--radius-xl);
            padding: 2rem;
            width: 100%;
            max-width: 400px;
            box-shadow: var(--shadow-xl);
            transform: translateY(20px);
            transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            text-align: center;
        }

        .modal-overlay.active .modal-card {
            transform: translateY(0);
        }

        .modal-icon {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: #FEF2F2;
            color: #DC2626;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 1.5rem;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
        }

        .modal-text {
            color: var(--gray-600);
            margin-bottom: 2rem;
            line-height: 1.5;
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
        }

        .btn-cancel {
            background: white;
            border: 1px solid var(--gray-200);
            color: var(--gray-700);
        }

        .btn-cancel:hover {
            background: var(--gray-50);
            border-color: var(--gray-300);
        }

        .btn-confirm {
            background: #DC2626;
            color: white;
            border: none;
        }

        .btn-confirm:hover {
            background: #B91C1C;
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
                                    <h1>Trouver un Nutritionniste</h1>
                                    <p>Parcourez les nutritionnistes certifiés et demandez à vous connecter avec eux.</p>
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

                                                <!-- Search Section -->
                                                <div class="search-section">
                                                    <div class="search-box">
                                                        <input type="text" id="searchInput" class="input"
                                                            placeholder="Rechercher des nutritionnistes..."
                                                            onkeyup="filterNutritionists()">
                                                    </div>
                                                </div>

                                                <!-- Nutritionists Grid -->
                                                <div class="nutritionists-grid" id="nutritionistsGrid">
                                                    <% List<User> nutritionists = (List<User>)
                                                            request.getAttribute("nutritionists");
                                                            Map<Integer, Double> ratings = (Map<Integer, Double>)
                                                                    request.getAttribute("ratings");
                                                                    Map<Integer, Integer> reviewCounts = (Map<Integer,
                                                                            Integer>)
                                                                            request.getAttribute("reviewCounts");

                                                                            if (nutritionists != null &&
                                                                            !nutritionists.isEmpty()) {
                                                                            for (User n : nutritionists) {
                                                                            String[] names = n.getFullName().split(" ");
                                                                            String initials = names[0].substring(0, 1);
                                                                            if (names.length > 1) initials +=
                                                                            names[names.length - 1].substring(0, 1);

                                                                            double rating = ratings != null &&
                                                                            ratings.get(n.getId()) != null ?
                                                                            ratings.get(n.getId()) : 0.0;
                                                                            int count = reviewCounts != null &&
                                                                            reviewCounts.get(n.getId()) != null ?
                                                                            reviewCounts.get(n.getId()) : 0;
                                                                            int fullStars = (int) Math.round(rating);
                                                                            %>
                                                                            <div class="nutritionist-card animate-fade-in"
                                                                                data-name="<%= n.getFullName().toLowerCase() %>">
                                                                                <div class="nutritionist-header">
                                                                                    <div class="nutritionist-avatar" style="overflow: hidden;">
                                                                                        <% if (n.getProfilePicture() != null && !n.getProfilePicture().isEmpty()) { %>
                                                                                            <img src="${pageContext.request.contextPath}/<%= n.getProfilePicture() %>" alt="<%= n.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                                                                        <% } else { %>
                                                                                            <%= initials.toUpperCase() %>
                                                                                        <% } %>
                                                                                    </div>
                                                                                    <div>
                                                                                        <div class="nutritionist-name">
                                                                                            Dr. <%= n.getFullName() %>
                                                                                        </div>
                                                                                        <div class="nutritionist-title">
                                                                                            Nutritionniste Certifié</div>
                                                                                    </div>
                                                                                </div>

                                                                                <div class="rating-display">
                                                                                    <div class="stars">
                                                                                        <% for (int i=1; i <=5; i++) {
                                                                                            %>
                                                                                            <i class="ph-fill ph-star star <%= i <= fullStars ? "" : "empty" %>"></i>
                                                                                            <% } %>
                                                                                    </div>
                                                                                    <span class="rating-text">
                                                                                        <%= String.format("%.1f",
                                                                                            rating) %> (<%= count %>
                                                                                                avis)
                                                                                    </span>
                                                                                </div>

                                                                                <div class="card-actions">
                                                                                    <a href="${pageContext.request.contextPath}/patient/nutritionist-profile?nutritionistId=<%= n.getId() %>"
                                                                                        class="btn btn-outline flex-1">
                                                                                        <i class="ph ph-user"></i>
                                                                                        Voir le Profil
                                                                                    </a>
                                                                                    <a href="javascript:void(0)" onclick="confirmRequest(<%= n.getId() %>)"
                                                                                        class="btn btn-primary flex-1">
                                                                                        <i
                                                                                            class="ph ph-paper-plane-tilt"></i>
                                                                                        Demander
                                                                                    </a>
                                                                                </div>
                                                                            </div>
                                                                            <% } } else { %>
                                                                                <div class="card"
                                                                                    style="grid-column: 1 / -1;">
                                                                                    <div class="empty-state">
                                                                                        <div class="empty-state-icon">
                                                                                            <i
                                                                                                class="ph ph-user-circle-minus"></i>
                                                                                        </div>
                                                                                        <div class="empty-state-title">
                                                                                            Aucun nutritionniste disponible
                                                                                        </div>
                                                                                        <div class="empty-state-text">
                                                                                            Veuillez vérifier plus tard pour
                                                                                            des nutritionnistes disponibles.
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                                </div>
                            </div>
                        </main>
                    </div>

    <!-- Confirmation Modal -->
    <div class="modal-overlay" id="confirmModal">
        <div class="modal-card">
            <div class="modal-icon">
                <i class="ph ph-warning"></i>
            </div>
            <h3 class="modal-title">Changer de Nutritionniste ?</h3>
            <p class="modal-text">
                En envoyant cette nouvelle demande, vous serez automatiquement retiré de la liste de votre nutritionniste actuel.
            </p>
            <div class="modal-actions">
                <button class="btn btn-cancel flex-1" onclick="closeModal()">Annuler</button>
                <button class="btn btn-confirm flex-1" id="confirmBtn">Continuer</button>
            </div>
        </div>
    </div>

                    <script>
        let targetNutritionistId = null;

        function confirmRequest(nutritionistId) {
            const currentId = <%= request.getAttribute("currentNutritionistId") != null ? request.getAttribute("currentNutritionistId") : -1 %>;
            
            if (currentId !== -1 && currentId !== nutritionistId) {
                targetNutritionistId = nutritionistId;
                const modal = document.getElementById('confirmModal');
                modal.classList.add('active');
            } else {
                window.location.href = "${pageContext.request.contextPath}/patient/requestNutritionist?nutritionistId=" + nutritionistId;
            }
        }

        function closeModal() {
            const modal = document.getElementById('confirmModal');
            modal.classList.remove('active');
            targetNutritionistId = null;
        }

        // Handle confirm button click
        document.getElementById('confirmBtn').addEventListener('click', function() {
            if (targetNutritionistId) {
                window.location.href = "${pageContext.request.contextPath}/patient/requestNutritionist?nutritionistId=" + targetNutritionistId;
            }
        });

        // Close modal when clicking outside
        document.getElementById('confirmModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        function filterNutritionists() {
                            const search = document.getElementById('searchInput').value.toLowerCase();
                            const cards = document.querySelectorAll('.nutritionist-card');

                            cards.forEach(card => {
                                const name = card.getAttribute('data-name');
                                if (name.includes(search)) {
                                    card.style.display = '';
                                } else {
                                    card.style.display = 'none';
                                }
                            });
                        }
                    </script>
                </body>

                </html>