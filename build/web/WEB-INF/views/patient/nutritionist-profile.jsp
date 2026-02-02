<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.User" %>
            <%@ page import="com.nutrit.models.NutritionistProfile" %>
                <%@ page import="com.nutrit.models.NutritionistReview" %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <% User nutritionist=(User) request.getAttribute("nutritionist"); %>
                            <title>
                                <%= nutritionist !=null ? "Dr. " + nutritionist.getFullName() : "Nutritionist Profile"
                                    %> - Nutrit
                            </title>
                            <meta name="description" content="View nutritionist profile and reviews.">
                            <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                rel="stylesheet">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                            <script src="https://unpkg.com/@phosphor-icons/web"></script>
                            <style>
                                .profile-header {
                                    display: flex;
                                    gap: 2rem;
                                    align-items: flex-start;
                                    margin-bottom: 2rem;
                                }

                                @media (max-width: 768px) {
                                    .profile-header {
                                        flex-direction: column;
                                        align-items: center;
                                        text-align: center;
                                    }
                                }

                                .profile-avatar {
                                    width: 120px;
                                    height: 120px;
                                    border-radius: var(--radius-full);
                                    background: var(--gradient-primary);
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    color: white;
                                    font-size: 3rem;
                                    font-weight: 700;
                                    flex-shrink: 0;
                                }

                                .profile-info h1 {
                                    font-size: 2rem;
                                    margin-bottom: 0.5rem;
                                }

                                .profile-meta {
                                    display: flex;
                                    flex-wrap: wrap;
                                    gap: 1rem;
                                    margin-top: 1rem;
                                }

                                .meta-item {
                                    display: flex;
                                    align-items: center;
                                    gap: 0.5rem;
                                    font-size: 0.875rem;
                                    color: var(--gray-600);
                                }

                                .meta-item i {
                                    color: var(--primary);
                                }

                                .rating-large {
                                    display: flex;
                                    align-items: center;
                                    gap: 0.5rem;
                                    margin-top: 0.75rem;
                                }

                                .rating-large .stars {
                                    display: flex;
                                    gap: 0.25rem;
                                }

                                .rating-large .star {
                                    color: #FCD34D;
                                    font-size: 1.25rem;
                                }

                                .rating-large .star.empty {
                                    color: var(--gray-300);
                                }

                                .profile-grid {
                                    display: grid;
                                    grid-template-columns: 2fr 1fr;
                                    gap: 1.5rem;
                                }

                                @media (max-width: 1024px) {
                                    .profile-grid {
                                        grid-template-columns: 1fr;
                                    }
                                }

                                .info-grid {
                                    display: grid;
                                    grid-template-columns: repeat(2, 1fr);
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

                                .bio-section {
                                    margin-top: 1.5rem;
                                }

                                .bio-section h3 {
                                    margin-bottom: 0.75rem;
                                }

                                .review-card {
                                    background: var(--gray-50);
                                    border-radius: var(--radius-lg);
                                    padding: 1rem;
                                    margin-bottom: 1rem;
                                }

                                .review-header {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    margin-bottom: 0.5rem;
                                }

                                .reviewer-name {
                                    font-weight: 600;
                                    color: var(--gray-800);
                                }

                                .review-date {
                                    font-size: 0.75rem;
                                    color: var(--gray-500);
                                }

                                .review-stars {
                                    display: flex;
                                    gap: 0.125rem;
                                    margin-bottom: 0.5rem;
                                }

                                .review-stars .star {
                                    font-size: 0.875rem;
                                    color: #FCD34D;
                                }

                                .review-stars .star.empty {
                                    color: var(--gray-300);
                                }

                                .review-comment {
                                    color: var(--gray-700);
                                    font-size: 0.9rem;
                                    line-height: 1.5;
                                }

                                .review-form {
                                    margin-top: 1.5rem;
                                    padding-top: 1.5rem;
                                    border-top: 1px solid var(--border);
                                }

                                .star-rating {
                                    display: flex;
                                    flex-direction: row-reverse;
                                    justify-content: flex-end;
                                    gap: 0.25rem;
                                }

                                .star-rating input {
                                    display: none;
                                }

                                .star-rating label {
                                    cursor: pointer;
                                    font-size: 1.75rem;
                                    color: var(--gray-300);
                                    transition: color 0.2s;
                                }

                                .star-rating label:hover,
                                .star-rating label:hover~label,
                                .star-rating input:checked~label {
                                    color: #FCD34D;
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
                                    <!-- Back Link -->
                                    <a href="${pageContext.request.contextPath}/patient/nutritionists" class="link mb-4"
                                        style="display: inline-flex; align-items: center; gap: 0.5rem;">
                                        <i class="ph ph-arrow-left"></i>
                                        Back to Nutritionists
                                    </a>

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

                                                    <% NutritionistProfile profile=(NutritionistProfile)
                                                        request.getAttribute("profile"); List<NutritionistReview>
                                                        reviews = (List<NutritionistReview>)
                                                            request.getAttribute("reviews");
                                                            Double avgRating = (Double)
                                                            request.getAttribute("avgRating");
                                                            Integer reviewCount = (Integer)
                                                            request.getAttribute("reviewCount");
                                                            Boolean hasReviewed = (Boolean)
                                                            request.getAttribute("hasReviewed");

                                                            if (nutritionist != null) {
                                                            String[] names = nutritionist.getFullName().split(" ");
                                                            String initials = names[0].substring(0, 1);
                                                            if (names.length > 1) initials += names[names.length -
                                                            1].substring(0, 1);
                                                            int fullStars = avgRating != null ? (int)
                                                            Math.round(avgRating) : 0;
                                                            %>

                                                            <!-- Profile Header -->
                                                            <div class="card animate-fade-in">
                                                                <div class="profile-header">
                                                                    <div class="profile-avatar" style="overflow: hidden;">
                                                                        <% if (nutritionist.getProfilePicture() != null && !nutritionist.getProfilePicture().isEmpty()) { %>
                                                                            <img src="${pageContext.request.contextPath}/<%= nutritionist.getProfilePicture() %>" alt="<%= nutritionist.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                                                        <% } else { %>
                                                                            <%= initials.toUpperCase() %>
                                                                        <% } %>
                                                                    </div>
                                                                    <div class="profile-info">
                                                                        <h1>Dr. <%= nutritionist.getFullName() %>
                                                                        </h1>
                                                                        <p style="color: var(--gray-600);">
                                                                            <%= profile !=null &&
                                                                                profile.getSpecialization() !=null ?
                                                                                profile.getSpecialization()
                                                                                : "Certified Nutritionist" %>
                                                                        </p>

                                                                        <div class="rating-large">
                                                                            <div class="stars">
                                                                                <% for (int i=1; i <=5; i++) { %>
                                                                                    <i class="ph-fill ph-star star <%= i <= fullStars ? "" : "empty" %>"></i>
                                                                                    <% } %>
                                                                            </div>
                                                                            <span style="color: var(--gray-600);">
                                                                                <%= avgRating !=null ?
                                                                                    String.format("%.1f", avgRating)
                                                                                    : "0.0" %>
                                                                                    (<%= reviewCount !=null ?
                                                                                        reviewCount : 0 %> reviews)
                                                                            </span>
                                                                        </div>

                                                                        <div class="profile-meta">
                                                                            <% if (profile !=null &&
                                                                                profile.getYearsExperience()> 0) { %>
                                                                                <div class="meta-item">
                                                                                    <i class="ph ph-briefcase"></i>
                                                                                    <span>
                                                                                        <%= profile.getYearsExperience()
                                                                                            %> years experience
                                                                                    </span>
                                                                                </div>
                                                                                <% } %>
                                                                                    <% if (profile !=null &&
                                                                                        profile.getClinicAddress()
                                                                                        !=null) { %>
                                                                                        <div class="meta-item">
                                                                                            <i
                                                                                                class="ph ph-map-pin"></i>
                                                                                            <span>
                                                                                                <%= profile.getClinicAddress()
                                                                                                    %>
                                                                                            </span>
                                                                                        </div>
                                                                                        <% } %>
                                                                                            <% if (profile !=null &&
                                                                                                profile.getWorkingHours()
                                                                                                !=null) { %>
                                                                                                <div class="meta-item">
                                                                                                    <i
                                                                                                        class="ph ph-clock"></i>
                                                                                                    <span>
                                                                                                        <%= profile.getWorkingHours()
                                                                                                            %>
                                                                                                    </span>
                                                                                                </div>
                                                                                                <% } %>
                                                                        </div>

                                                                        <div style="margin-top: 1.5rem;">
                                                                            <a href="javascript:void(0)" onclick="confirmRequest(<%= nutritionist.getId() %>)"
                                                                                class="btn btn-primary">
                                                                                <i class="ph ph-paper-plane-tilt"></i>
                                                                                Request This Nutritionist
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="profile-grid" style="margin-top: 1.5rem;">
                                                                <!-- About Section -->
                                                                <div class="card animate-fade-in"
                                                                    style="animation-delay: 0.1s;">
                                                                    <div class="card-header">
                                                                        <h3><i class="ph ph-user mr-2"
                                                                                style="color: var(--primary);"></i>About
                                                                        </h3>
                                                                    </div>

                                                                    <div class="info-grid">
                                                                        <% if (profile !=null &&
                                                                            profile.getSpecialization() !=null) { %>
                                                                            <div class="info-item">
                                                                                <label>Specialization</label>
                                                                                <span>
                                                                                    <%= profile.getSpecialization() %>
                                                                                </span>
                                                                            </div>
                                                                            <% } %>
                                                                                <% if (profile !=null &&
                                                                                    profile.getLicenseNumber() !=null) {
                                                                                    %>
                                                                                    <div class="info-item">
                                                                                        <label>License Number</label>
                                                                                        <span>
                                                                                            <%= profile.getLicenseNumber()
                                                                                                %>
                                                                                        </span>
                                                                                    </div>
                                                                                    <% } %>
                                                                                        <% if (profile !=null &&
                                                                                            profile.getPrice() !=null) {
                                                                                            %>
                                                                                            <div class="info-item">
                                                                                                <label>Consultation
                                                                                                    Fee</label>
                                                                                                <span>$<%=
                                                                                                        profile.getPrice()
                                                                                                        %></span>
                                                                                            </div>
                                                                                            <% } %>
                                                                                                <div class="info-item">
                                                                                                    <label>Email</label>
                                                                                                    <span>
                                                                                                        <%= nutritionist.getEmail()
                                                                                                            %>
                                                                                                    </span>
                                                                                                </div>
                                                                    </div>

                                                                    <% if (profile !=null && profile.getBio() !=null &&
                                                                        !profile.getBio().isEmpty()) { %>
                                                                        <div class="bio-section">
                                                                            <h3>Biography</h3>
                                                                            <p
                                                                                style="color: var(--gray-700); line-height: 1.6;">
                                                                                <%= profile.getBio() %>
                                                                            </p>
                                                                        </div>
                                                                        <% } %>
                                                                </div>

                                                                <!-- Reviews Section -->
                                                                <div class="card animate-fade-in"
                                                                    style="animation-delay: 0.2s;">
                                                                    <div class="card-header">
                                                                        <h3><i class="ph ph-star mr-2"
                                                                                style="color: var(--primary);"></i>Reviews
                                                                        </h3>
                                                                    </div>

                                                                    <% if (reviews !=null && !reviews.isEmpty()) { for
                                                                        (NutritionistReview review : reviews) { int
                                                                        reviewStars=review.getRating(); %>
                                                                        <div class="review-card">
                                                                            <div class="review-header">
                                                                                <span class="reviewer-name">
                                                                                    <%= review.getPatientName() %>
                                                                                </span>
                                                                                <span class="review-date">
                                                                                    <%= new
                                                                                        java.text.SimpleDateFormat("MMM,dd,yyyy").format(review.getCreatedAt())
                                                                                        %>
                                                                                </span>
                                                                            </div>
                                                                            <div class="review-stars">
                                                                                <% for (int i=1; i <=5; i++) { %>
                                                                                    <i class="ph-fill ph-star star <%= i <= reviewStars ? "" : "empty" %>"></i>
                                                                                    <% } %>
                                                                            </div>
                                                                            <% if (review.getComment() !=null &&
                                                                                !review.getComment().isEmpty()) { %>
                                                                                <p class="review-comment">
                                                                                    <%= review.getComment() %>
                                                                                </p>
                                                                                <% } %>
                                                                        </div>
                                                                        <% } } else { %>
                                                                            <div class="empty-state">
                                                                                <div class="empty-state-icon">
                                                                                    <i
                                                                                        class="ph ph-chat-circle-text"></i>
                                                                                </div>
                                                                                <div class="empty-state-title">No
                                                                                    Reviews Yet</div>
                                                                                <div class="empty-state-text">Be the
                                                                                    first to leave a review!</div>
                                                                            </div>
                                                                            <% } %>

                                                                                <!-- Review Form -->
                                                                                <% if (hasReviewed==null ||
                                                                                    !hasReviewed) { %>
                                                                                    <div class="review-form">
                                                                                        <h4
                                                                                            style="margin-bottom: 1rem;">
                                                                                            Leave a Review</h4>
                                                                                        <form
                                                                                            action="${pageContext.request.contextPath}/patient/addReview"
                                                                                            method="POST">
                                                                                            <input type="hidden"
                                                                                                name="nutritionistId"
                                                                                                value="<%= nutritionist.getId() %>">

                                                                                            <div class="form-group">
                                                                                                <label
                                                                                                    class="label">Your
                                                                                                    Rating</label>
                                                                                                <div
                                                                                                    class="star-rating">
                                                                                                    <input type="radio"
                                                                                                        name="rating"
                                                                                                        value="5"
                                                                                                        id="star5"
                                                                                                        required>
                                                                                                    <label
                                                                                                        for="star5"><i
                                                                                                            class="ph-fill ph-star"></i></label>
                                                                                                    <input type="radio"
                                                                                                        name="rating"
                                                                                                        value="4"
                                                                                                        id="star4">
                                                                                                    <label
                                                                                                        for="star4"><i
                                                                                                            class="ph-fill ph-star"></i></label>
                                                                                                    <input type="radio"
                                                                                                        name="rating"
                                                                                                        value="3"
                                                                                                        id="star3">
                                                                                                    <label
                                                                                                        for="star3"><i
                                                                                                            class="ph-fill ph-star"></i></label>
                                                                                                    <input type="radio"
                                                                                                        name="rating"
                                                                                                        value="2"
                                                                                                        id="star2">
                                                                                                    <label
                                                                                                        for="star2"><i
                                                                                                            class="ph-fill ph-star"></i></label>
                                                                                                    <input type="radio"
                                                                                                        name="rating"
                                                                                                        value="1"
                                                                                                        id="star1">
                                                                                                    <label
                                                                                                        for="star1"><i
                                                                                                            class="ph-fill ph-star"></i></label>
                                                                                                </div>
                                                                                            </div>

                                                                                            <div class="form-group">
                                                                                                <label
                                                                                                    class="label">Your
                                                                                                    Comment
                                                                                                    (Optional)</label>
                                                                                                <textarea name="comment"
                                                                                                    class="input"
                                                                                                    rows="3"
                                                                                                    placeholder="Share your experience..."></textarea>
                                                                                            </div>

                                                                                            <button type="submit"
                                                                                                class="btn btn-primary w-full">
                                                                                                <i
                                                                                                    class="ph ph-paper-plane-tilt"></i>
                                                                                                Submit Review
                                                                                            </button>
                                                                                        </form>
                                                                                    </div>
                                                                                    <% } else { %>
                                                                                        <div
                                                                                            style="margin-top: 1.5rem; padding: 1rem; background: var(--gray-50); border-radius: var(--radius-lg); text-align: center;">
                                                                                            <i class="ph ph-check-circle"
                                                                                                style="color: var(--success); font-size: 1.5rem;"></i>
                                                                                            <p
                                                                                                style="color: var(--gray-600); margin-top: 0.5rem;">
                                                                                                You have already
                                                                                                reviewed this
                                                                                                nutritionist.</p>
                                                                                        </div>
                                                                                        <% } %>
                                                                </div>
                                                            </div>

                                                            <% } else { %>
                                                                <div class="card">
                                                                    <div class="empty-state">
                                                                        <div class="empty-state-icon">
                                                                            <i class="ph ph-user-circle-minus"></i>
                                                                        </div>
                                                                        <div class="empty-state-title">Nutritionist Not
                                                                            Found</div>
                                                                        <div class="empty-state-text">The requested
                                                                            nutritionist profile could not be found.
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <% } %>
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
                window.location.href = "${pageContext.request.contextPath}/patient/requestNutritionist?nutritionistId=" + nutritionistId + "&fromProfile=true";
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
                window.location.href = "${pageContext.request.contextPath}/patient/requestNutritionist?nutritionistId=" + targetNutritionistId + "&fromProfile=true";
            }
        });

        // Close modal when clicking outside
        document.getElementById('confirmModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
    </script>
                    </body>

                    </html>