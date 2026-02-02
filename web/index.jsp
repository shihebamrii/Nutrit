<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.nutrit.dao.UserDAO" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="com.nutrit.models.NutritionistReview" %>
<%@ page import="com.nutrit.dao.NutritionistReviewDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <%
      // Ensure featured nutritionists are available even if accessed directly
      List<User> featured = (List<User>) request.getAttribute("featuredNutritionists");
      if (featured == null) {
          UserDAO userDAO = new UserDAO();
          featured = userDAO.getFeaturedNutritionists(3);
          request.setAttribute("featuredNutritionists", featured);
          featured = userDAO.getFeaturedNutritionists(3);
          request.setAttribute("featuredNutritionists", featured);
      }
      
      // Fetch Reviews
      List<NutritionistReview> recentReviews = (List<NutritionistReview>) request.getAttribute("recentReviews");
      if (recentReviews == null) {
          NutritionistReviewDAO reviewDAO = new NutritionistReviewDAO();
          recentReviews = reviewDAO.getRecentReviews(3);
          request.setAttribute("recentReviews", recentReviews);
      }
    %>
    <meta
      name="description"
      content="Nutrit - Votre partenaire nutrition santé. Consultations personnalisées avec nos nutritionnistes experts."
    />
    <title>Nutrit - Votre Santé, Notre Priorité</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@600;700&display=swap"
      rel="stylesheet"
    />

    <!-- Font Awesome Icons -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
    />

    <!-- Stylesheets -->
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/landing.css?v=<%= System.currentTimeMillis() %>" />
    <link rel="manifest" href="${pageContext.request.contextPath}/manifest.json">
    <meta name="theme-color" content="#4CAF50">
  </head>
  <body>
    <!-- =====================================================
         NAVIGATION
         ===================================================== -->
    <nav class="navbar">
      <div class="nav-container">
        <a href="#" class="nav-logo">
          Nutrit<span class="dot">.</span>
        </a>
        
        <div class="nav-menu">
            <ul class="nav-links">
            <li><a href="#accueil" class="active">Accueil</a></li>
            <li><a href="#video">Découvrir</a></li>
            <li><a href="#resultats">Résultats</a></li>
            <li><a href="#experts">Experts</a></li>
            <li><a href="#solutions">Solutions</a></li>
            <li><a href="#avis">Avis</a></li>
            </ul>
            
            <div class="nav-buttons">
            <button id="installAppBtn" class="btn-primary" style="margin-right: 10px; padding: 0.625rem 1.25rem; font-size: 0.9375rem; display: inline-flex; align-items: center; gap: 8px; border: none; cursor: pointer;">
                <i class="fas fa-download"></i> Installer
            </button>
            <a href="auth/login" class="btn-login">Connexion</a>
            <a href="auth/register" class="btn-register">Inscription</a>
            </div>
        </div>

        <button class="mobile-menu-btn" aria-label="Menu">
          <i class="fas fa-bars"></i>
        </button>
      </div>
    </nav>
    <!-- =====================================================
         HERO SECTION
         ===================================================== -->
    <section class="hero" id="accueil">
      <div class="hero-container">
        <div class="hero-content">
          <div class="hero-badge">
            <span class="hero-badge-dot"></span>
            <span class="hero-badge-text"
              >Plateforme de nutrition #1 en Tunisie</span
            >
          </div>

          <h1 class="hero-title">
            Transformez Votre Vie
            <span>Avec Une Alimentation Saine</span>
          </h1>

          <p class="hero-description">
            Découvrez notre programme de nutrition personnalisé conçu par des
            experts. Atteignez vos objectifs de santé grâce à un accompagnement
            sur mesure et des plans alimentaires adaptés à votre mode de vie.
          </p>

          <div class="hero-buttons">
            <a href="auth/register" class="btn-primary">
              S'inscrire Gratuitement
              <i class="fas fa-arrow-right"></i>
            </a>
            <a href="#video" class="btn-secondary">
              <i class="fas fa-play-circle"></i>
              Voir Comment Ça Marche
            </a>
          </div>

          <div class="hero-stats">
            <div class="stat-item">
              <div class="stat-number">15K+</div>
              <div class="stat-label">Clients Satisfaits</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">98%</div>
              <div class="stat-label">Taux de Réussite</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">50+</div>
              <div class="stat-label">Nutritionnistes Experts</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- =====================================================
         VIDEO SECTION
         ===================================================== -->
    <section class="video-section" id="video">
      <div class="video-container">
        <div class="video-grid">
          <!-- Video Player -->
          <div class="video-player-wrapper" onclick="playVideo(this)">
            <div class="video-thumbnail-container">
              <img
                src="assets/images/video_thumbnail.png"
                alt="Nutritionniste expliquant notre plateforme"
                class="video-thumbnail"
              />
              <div class="play-button">
                <i class="fas fa-play"></i>
              </div>
            </div>
            <video
              class="video-player"
              controls
              poster="assets/images/video_thumbnail.png"
            >
              <source src="assets/nutri.mp4" type="video/mp4" />
              Votre navigateur ne supporte pas la lecture vidéo.
            </video>
          </div>

          <!-- Video Content -->
          <div class="video-content">
            <div class="section-badge">
              <i class="fas fa-video"></i>
              Découvrez Notre Approche
            </div>

            <h2 class="video-title">
              Notre Nutritionniste Vous Explique Notre Plateforme
            </h2>

            <p class="video-description">
              Dans cette vidéo, notre nutritionniste diplômée vous présente en
              détail comment notre plateforme révolutionne votre parcours vers
              une meilleure santé. Découvrez les outils, les méthodes et
              l'accompagnement personnalisé qui font notre différence.
            </p>

            <ul class="video-features">
              <li>
                <i class="fas fa-check-circle"></i>
                Plans alimentaires personnalisés selon vos objectifs
              </li>
              <li>
                <i class="fas fa-check-circle"></i>
                Suivi quotidien de vos progrès et statistiques
              </li>
              <li>
                <i class="fas fa-check-circle"></i>
                Consultations vidéo avec nos experts certifiés
              </li>
              <li>
                <i class="fas fa-check-circle"></i>
                Recettes saines et délicieuses adaptées à vos goûts
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <!-- =====================================================
         TRANSFORMATION SECTION (Before/After)
         ===================================================== -->
    <section class="transformation-section" id="resultats">
      <div class="transformation-container">
        <header class="transformation-header">
          <div class="section-badge">
            <i class="fas fa-medal"></i>
            Résultats Prouvés
          </div>
          <h2 class="transformation-title">
            Vous Pouvez Obtenir Des Résultats Avec Nous
          </h2>
          <p class="transformation-subtitle">
            Découvrez les transformations incroyables de nos clients. Faites
            glisser le curseur pour voir l'avant et l'après de leur parcours
            avec Nutrit.
          </p>
        </header>

        <div class="comparison-grid">
          <!-- Comparison Slider 1 -->
          <div class="comparison-slider" data-comparison>
            <div class="comparison-image-wrapper">
                <img
                  src="https://nutritionist.sites.motocms.com/res/5cebd068a4bffb002318c705/5ced6ad9856fb800236a4dd9_optimized_1920_c1361x924-393x273.webp"
                  alt="Avant transformation"
                  class="comparison-image before"
                />
                <img
                  src="https://nutritionist.sites.motocms.com/res/5cebd068a4bffb002318c705/5ced6af3100ab20023f48fb1_optimized_1395_c1395x931-0x0.webp"
                  alt="Après transformation"
                  class="comparison-image after"
                />
            </div>
            <div class="slider-handle">
              <div class="slider-button">
                <i class="fas fa-arrows-left-right"></i>
              </div>
            </div>
            <input
              type="range"
              min="0"
              max="100"
              value="50"
              class="slider-input"
              aria-label="Comparer avant et après"
            />
            <div class="comparison-labels">
              <span class="label-badge before-label">Avant</span>
              <span class="label-badge after-label">Après</span>
            </div>
          </div>

          <!-- Comparison Slider 2 -->
          <div class="comparison-slider" data-comparison>
            <div class="comparison-image-wrapper">
                <img
                  src="https://nutritionist.sites.motocms.com/res/5cebd068a4bffb002318c705/5cee4a688630270023585376_optimized_1717_c1396x930-288x125.webp"
                  alt="Avant transformation"
                  class="comparison-image before"
                />
                <img
                  src="https://nutritionist.sites.motocms.com/res/5cebd068a4bffb002318c705/5cee4c810b734b002319f69c_optimized_1920_c1222x687-588x392.webp"
                  alt="Après transformation"
                  class="comparison-image after"
                />
            </div>
            <div class="slider-handle">
              <div class="slider-button">
                <i class="fas fa-arrows-left-right"></i>
              </div>
            </div>
            <input
              type="range"
              min="0"
              max="100"
              value="50"
              class="slider-input"
              aria-label="Comparer avant et après"
            />
            <div class="comparison-labels">
              <span class="label-badge before-label">Avant</span>
              <span class="label-badge after-label">Après</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- =====================================================
         NUTRITIONISTS SECTION
         ===================================================== -->
    <section class="nutritionists-section" id="experts">
        <div class="nutritionists-container">
            <header class="section-header">
                <div class="section-badge">
                    <i class="fas fa-user-md"></i>
                    Nos Experts
                </div>
                <h2 class="section-title">
                    Rencontrez Nos Nutritionnistes Certifiés
                </h2>
                <p class="section-subtitle">
                    Notre équipe d'experts qualifiés est là pour vous accompagner vers une vie plus saine.
                </p>
            </header>
            
            <div class="nutritionists-grid">
                <c:forEach var="expert" items="${featuredNutritionists}">
                    <article class="nutritionist-card">
                        <div class="nutritionist-image-wrapper">
                            <img src="${not empty expert.profilePicture ? expert.profilePicture : 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face'}" 
                                 alt="${expert.fullName}" class="nutritionist-image">
                            <div class="nutritionist-status">
                                <span class="status-dot"></span>
                                ${expert.status == 'active' ? 'Disponible' : 'Indisponible'}
                            </div>
                        </div>
                        <div class="nutritionist-info">
                            <h3 class="nutritionist-name">${expert.fullName}</h3>
                            <p class="nutritionist-specialty">${expert.nutritionistProfile.specialization}</p>
                            <div class="nutritionist-meta">
                                <span class="meta-item">
                                    <i class="fas fa-star"></i>
                                    <fmt:formatNumber value="${expert.nutritionistProfile.averageRating}" maxFractionDigits="1" minFractionDigits="1" />
                                </span>
                                <span class="meta-item">
                                    <i class="fas fa-briefcase"></i>
                                    ${expert.nutritionistProfile.yearsExperience} ans
                                </span>
                                <span class="meta-item">
                                    <i class="fas fa-users"></i>
                                    ${expert.nutritionistProfile.reviewCount}+ clients
                                </span>
                            </div>
                            <p class="nutritionist-bio">
                                ${expert.nutritionistProfile.bio}
                            </p>
                            <a href="experts" class="nutritionist-btn">
                                Voir le Profil
                                <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </article>
                </c:forEach>
            </div>
            
            <div class="section-cta">
                <a href="experts" class="btn-experts">
                    <i class="fas fa-users-medical"></i>
                    Plus d'Experts
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- =====================================================
         SOLUTIONS SECTION - Interactive Full-Screen Panels
         ===================================================== -->
    <section class="solutions-section" id="solutions">
        <!-- Background Images Container -->
        <div class="solutions-backgrounds">
            <div class="solutions-bg active" style="background-image: url('https://unlimited-elements.com/wp-content/uploads/2025/01/3887736.jpg')"></div>
            <div class="solutions-bg" style="background-image: url('https://unlimited-elements.com/wp-content/uploads/2025/01/49443.jpg')"></div>
            <div class="solutions-bg" style="background-image: url('https://unlimited-elements.com/wp-content/uploads/2025/01/2458485.jpg')"></div>
            <div class="solutions-bg" style="background-image: url('https://unlimited-elements.com/wp-content/uploads/2025/01/87375.jpg')"></div>
        </div>
        
        <!-- Dark Overlay -->
        <div class="solutions-overlay"></div>
        
        <!-- Header -->
        <header class="solutions-header">
            <div class="section-badge">
                <i class="fas fa-leaf"></i>
                Nos Solutions
            </div>
            <h2 class="solutions-title">Solutions Pour Chaque Mode de Vie</h2>
            <p class="solutions-subtitle">Plans alimentaires complets et conseils d'experts pour un bien-être durable.</p>
        </header>
        
        <!-- Interactive Panels -->
        <div class="solutions-panels">
            <!-- Panel 1 -->
            <div class="solution-panel" data-panel="0">
                <div class="panel-content">
                    <div class="panel-icon">
                        <i class="fas fa-running"></i>
                    </div>
                    <h3 class="panel-title">Nutrition Sportive</h3>
                    <p class="panel-description">
                        Optimisez vos performances avec des plans nutritionnels adaptés à votre activité physique et vos objectifs sportifs.
                    </p>
                    <div class="panel-extended">
                        <ul class="panel-features">
                            <li><i class="fas fa-check"></i> Plans pré et post-entraînement</li>
                            <li><i class="fas fa-check"></i> Calcul précis des macronutriments</li>
                            <li><i class="fas fa-check"></i> Supplémentation adaptée</li>
                            <li><i class="fas fa-check"></i> Récupération optimisée</li>
                        </ul>
                        <a href="experts" class="panel-cta">
                            Commencer maintenant
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <div class="panel-number">01</div>
            </div>
            
            <!-- Panel 2 -->
            <div class="solution-panel" data-panel="1">
                <div class="panel-content">
                    <div class="panel-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <h3 class="panel-title">Plans Personnalisés</h3>
                    <p class="panel-description">
                        Des programmes nutritionnels sur mesure, adaptés à vos goûts, votre mode de vie et vos besoins spécifiques.
                    </p>
                    <div class="panel-extended">
                        <ul class="panel-features">
                            <li><i class="fas fa-check"></i> Analyse complète de vos habitudes</li>
                            <li><i class="fas fa-check"></i> Menus hebdomadaires personnalisés</li>
                            <li><i class="fas fa-check"></i> Liste de courses automatique</li>
                            <li><i class="fas fa-check"></i> Suivi et ajustements réguliers</li>
                        </ul>
                        <a href="experts" class="panel-cta">
                            Commencer maintenant
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <div class="panel-number">02</div>
            </div>
            
            <!-- Panel 3 -->
            <div class="solution-panel" data-panel="2">
                <div class="panel-content">
                    <div class="panel-icon">
                        <i class="fas fa-weight"></i>
                    </div>
                    <h3 class="panel-title">Gestion du Poids</h3>
                    <p class="panel-description">
                        Atteignez et maintenez votre poids idéal grâce à des stratégies durables et un accompagnement personnalisé.
                    </p>
                    <div class="panel-extended">
                        <ul class="panel-features">
                            <li><i class="fas fa-check"></i> Déficit calorique contrôlé</li>
                            <li><i class="fas fa-check"></i> Préservation de la masse musculaire</li>
                            <li><i class="fas fa-check"></i> Gestion des fringales</li>
                            <li><i class="fas fa-check"></i> Maintien à long terme</li>
                        </ul>
                        <a href="experts" class="panel-cta">
                            Commencer maintenant
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <div class="panel-number">03</div>
            </div>
            
            <!-- Panel 4 -->
            <div class="solution-panel" data-panel="3">
                <div class="panel-content">
                    <div class="panel-icon">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <h3 class="panel-title">Santé Digestive</h3>
                    <p class="panel-description">
                        Stratégies alimentaires pour améliorer votre digestion et votre bien-être général au quotidien.
                    </p>
                    <div class="panel-extended">
                        <ul class="panel-features">
                            <li><i class="fas fa-check"></i> Identification des intolérances</li>
                            <li><i class="fas fa-check"></i> Rééquilibrage du microbiome</li>
                            <li><i class="fas fa-check"></i> Réduction des inflammations</li>
                            <li><i class="fas fa-check"></i> Aliments probiotiques adaptés</li>
                        </ul>
                        <a href="experts" class="panel-cta">
                            Commencer maintenant
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <div class="panel-number">04</div>
            </div>
        </div>
    </section>

    <!-- =====================================================
         REVIEWS SECTION
         ===================================================== -->
    <section class="reviews-section" id="avis">
        <div class="reviews-container">
            <header class="section-header">
                <div class="section-badge">
                    <i class="fas fa-quote-left"></i>
                    Témoignages
                </div>
                <h2 class="section-title">
                    Ce Que Disent Nos Clients
                </h2>
                <p class="section-subtitle">
                    Découvrez les expériences de ceux qui ont transformé leur vie avec Nutrit.
                </p>
            </header>
            
            <div class="reviews-carousel">
                <c:choose>
                    <c:when test="${not empty recentReviews}">
                        <c:forEach var="review" items="${recentReviews}" varStatus="status">
                             <!-- Review Card -->
                            <article class="review-card ${status.index == 1 ? 'featured' : ''}">
                                <c:if test="${status.index == 1}">
                                    <div class="featured-badge">
                                        <i class="fas fa-crown"></i>
                                        Top Avis
                                    </div>
                                </c:if>
                                <div class="review-header">
                                    <div class="review-avatar">
                                        <c:choose>
                                            <c:when test="${not empty review.patientProfilePicture}">
                                                <img src="${review.patientProfilePicture}" alt="${review.patientName}" class="avatar-image" />
                                            </c:when>
                                            <c:otherwise>
                                                <div class="avatar-placeholder">
                                                    <c:out value="${review.patientName != null && review.patientName.length() > 0 ? review.patientName.substring(0, 1) : '?'}" />
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="review-author">
                                        <h4 class="author-name">${review.patientName}</h4>
                                        <p class="author-location">Tunisie</p>
                                    </div>
                                    <div class="review-rating">
                                        <c:forEach begin="1" end="${review.rating}">
                                            <i class="fas fa-star"></i>
                                        </c:forEach>
                                        <c:forEach begin="${review.rating + 1}" end="5">
                                            <i class="far fa-star"></i>
                                        </c:forEach>
                                    </div>
                                </div>
                                <blockquote class="review-content">
                                    <p>"${review.comment}"</p>
                                </blockquote>
                                <div class="review-footer">
                                    <span class="review-date"><fmt:formatDate value="${review.createdAt}" pattern="dd MMM yyyy" /></span>
                                    <span class="review-verified">
                                        <i class="fas fa-check-circle"></i>
                                        Vérifié
                                    </span>
                                </div>
                            </article>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="grid-column: 1 / -1; text-align: center; color: #6b7280; padding: 2rem;">
                            <i class="far fa-comment-dots" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                            <p>Aucun avis pour le moment. Soyez le premier à partager votre expérience !</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="reviews-stats">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stat-content">
                        <span class="stat-value">4.9/5</span>
                        <span class="stat-label">Note Moyenne</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <div class="stat-content">
                        <span class="stat-value">2,500+</span>
                        <span class="stat-label">Avis Clients</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="stat-content">
                        <span class="stat-value">98%</span>
                        <span class="stat-label">Recommandent</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- =====================================================
         JAVASCRIPT
         ===================================================== -->
    <!-- =====================================================
         FOOTER
         ===================================================== -->
    <footer class="footer">
      <div class="footer-container">
        <div class="footer-grid">
          <div class="footer-brand">
            <a href="#" class="footer-logo">
              Nutrit<span class="dot">.</span>
            </a>
            <p class="footer-description">
              Votre partenaire santé et nutrition. Des experts dédiés pour vous accompagner vers une vie plus saine et équilibrée.
            </p>
            <div class="social-links">
              <a href="#"><i class="fab fa-facebook-f"></i></a>
              <a href="#"><i class="fab fa-instagram"></i></a>
              <a href="#"><i class="fab fa-twitter"></i></a>
              <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
          </div>

          <div class="footer-links-group">
            <h4>Plateforme</h4>
            <ul>
              <li><a href="#accueil">Accueil</a></li>
              <li><a href="#experts">Nos Nutritionnistes</a></li>
              <li><a href="#solutions">Nos Programmes</a></li>
              <li><a href="#avis">Témoignages</a></li>
            </ul>
          </div>

          <div class="footer-links-group">
            <h4>Entreprise</h4>
            <ul>
              <li><a href="#">À Propos</a></li>
              <li><a href="#">Carrières</a></li>
              <li><a href="#">Blog</a></li>
              <li><a href="#">Presse</a></li>
            </ul>
          </div>

          <div class="footer-links-group">
            <h4>Légal</h4>
            <ul>
              <li><a href="#">Confidentialité</a></li>
              <li><a href="#">CGU</a></li>
              <li><a href="#">Mentions Légales</a></li>
              <li><a href="#">Cookies</a></li>
            </ul>
          </div>
        </div>

        <div class="footer-bottom">
          <p>&copy; 2026 Nutrit. Tous droits réservés.</p>
          <p class="made-with">Fait avec <i class="fas fa-heart"></i> en Tunisie</p>
        </div>
      </div>
    </footer>

    <script>
      // Mobile Menu Toggle
      const mobileBtn = document.querySelector('.mobile-menu-btn');
      const navMenu = document.querySelector('.nav-menu');
      
      if(mobileBtn) {
        mobileBtn.addEventListener('click', () => {
          navMenu.classList.toggle('active');
          const icon = mobileBtn.querySelector('i');
          if(navMenu.classList.contains('active')) {
            icon.classList.remove('fa-bars');
            icon.classList.add('fa-times');
          } else {
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
          }
        });
      }

      // Sticky Navbar Effect
      window.addEventListener('scroll', () => {
        const navbar = document.querySelector('.navbar');
        if(window.scrollY > 50) {
          navbar.classList.add('scrolled');
        } else {
          navbar.classList.remove('scrolled');
        }
      });


      // PWA Install Logic
      let deferredPrompt = null;
      const installBtn = document.getElementById('installAppBtn');

      window.addEventListener('beforeinstallprompt', (e) => {
        // Prevent Chrome 67 and earlier from automatically showing the prompt
        e.preventDefault();
        // Stash the event so it can be triggered later.
        deferredPrompt = e;
      });

      installBtn.addEventListener('click', (e) => {
        if (deferredPrompt) {
          // Show the prompt
          deferredPrompt.prompt();
          // Wait for the user to respond to the prompt
          deferredPrompt.userChoice.then((choiceResult) => {
            if (choiceResult.outcome === 'accepted') {
              console.log('User accepted the A2HS prompt');
            } else {
              console.log('User dismissed the A2HS prompt');
            }
            deferredPrompt = null;
          });
        }
      });

      // Register Service Worker
      if ('serviceWorker' in navigator) {
        const registerSW = async () => {
          try {
            console.log('Attempting to register ServiceWorker...');
            const reg = await navigator.serviceWorker.register('service-worker.js', {
              scope: './'
            });
            console.log('ServiceWorker registered! Scope:', reg.scope);
            
            // Explicitly check for updates
            reg.update();
          } catch (err) {
            console.error('ServiceWorker registration failed:', err);
          }
        };

        if (document.readyState === 'complete') {
          registerSW();
        } else {
          window.addEventListener('load', registerSW);
        }
      } else {
        console.warn('Service workers are not supported in this browser.');
      }
    </script>
    <script>
      // Video Player Function
      function playVideo(wrapper) {
        const thumbnailContainer = wrapper.querySelector(
          ".video-thumbnail-container"
        );
        const video = wrapper.querySelector(".video-player");

        if (thumbnailContainer && video) {
          thumbnailContainer.classList.add("hidden");
          video.classList.add("active");
          video.play();
        }
      }

      // Before/After Comparison Slider
      document.addEventListener("DOMContentLoaded", function () {
        const sliders = document.querySelectorAll("[data-comparison]");

        sliders.forEach((slider) => {
          const input = slider.querySelector(".slider-input");
          const beforeImage = slider.querySelector(".comparison-image.before");
          const handle = slider.querySelector(".slider-handle");

          if (input && beforeImage && handle) {
            // Set initial state
            updateSlider(input.value);

            // Listen for input changes
            input.addEventListener("input", function () {
              updateSlider(this.value);
            });

            function updateSlider(value) {
              const percentage = value + "%";
              beforeImage.style.clipPath = 'inset(0 ' + (100 - value) + '% 0 0)';
              handle.style.left = percentage;
            }
          }
        });

        // Solutions Panel Click Effect
        const panels = document.querySelectorAll('.solution-panel');
        const backgrounds = document.querySelectorAll('.solutions-bg');
        
        panels.forEach((panel) => {
          panel.addEventListener('click', function(e) {
            // Don't toggle if clicking on a link
            if (e.target.tagName === 'A' || e.target.closest('a')) {
              return;
            }
            
            const panelIndex = this.getAttribute('data-panel');
            const isActive = this.classList.contains('expanded');
            
            // Remove expanded class from all panels
            panels.forEach(p => p.classList.remove('expanded'));
            
            // If this panel wasn't active, expand it
            if (!isActive) {
              this.classList.add('expanded');
            }
            
            // Always update background on click
            backgrounds.forEach(bg => bg.classList.remove('active'));
            if (backgrounds[panelIndex]) {
              backgrounds[panelIndex].classList.add('active');
            }
          });
          
          // Also update background on hover (without expanding)
          panel.addEventListener('mouseenter', function() {
            const panelIndex = this.getAttribute('data-panel');
            backgrounds.forEach(bg => bg.classList.remove('active'));
            if (backgrounds[panelIndex]) {
              backgrounds[panelIndex].classList.add('active');
            }
          });
        });
      });
    </script>
  </body>
</html>
