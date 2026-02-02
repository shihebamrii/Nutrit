<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="com.nutrit.models.NutritionistProfile" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trouver un Nutritionniste - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <!-- Leaflet Map -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        .public-page {
            background-color: var(--gray-50);
            min-height: 100vh;
        }
        
        /* Reusing Navbar styles from landing.jsp or common header */
        .navbar {
            background: #fff;
            padding: 1rem 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--primary-600);
            text-decoration: none;
        }

        .search-section {
            background: #fff;
            padding: 3rem 2rem;
            border-bottom: 1px solid var(--gray-200);
            margin-bottom: 2rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .search-container {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid var(--gray-200);
            border-radius: var(--radius-full);
            font-size: 1rem;
            transition: all 0.2s;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 4px var(--primary-100);
        }

        .search-icon {
            position: absolute;
            left: 1.25rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.25rem;
        }

        .nutritionists-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding-bottom: 4rem;
        }

        .nutri-card {
            background: #fff;
            border-radius: 1rem;
            overflow: hidden;
            border: 1px solid var(--gray-200);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .nutri-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border-color: var(--primary-200);
        }

        .nutri-header {
            padding: 2rem;
            text-align: center;
            background: linear-gradient(135deg, var(--primary-50), var(--white));
            border-bottom: 1px solid var(--gray-100);
        }

        .nutri-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: var(--primary-100);
            color: var(--primary-600);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1rem;
            border: 4px solid #fff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .nutri-name {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.25rem;
        }

        .nutri-specialty {
            color: var(--primary-600);
            font-weight: 600;
            font-size: 0.9rem;
        }

        .nutri-body {
            padding: 1.5rem;
            flex-grow: 1;
        }

        .nutri-info-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
            color: var(--gray-600);
            font-size: 0.9rem;
        }

        .nutri-info-row i {
            color: var(--primary-400);
            font-size: 1.1rem;
        }

        .nutri-footer {
            padding: 1.5rem;
            border-top: 1px solid var(--gray-100);
            text-align: center;
        }

        .btn-view-profile {
            display: block;
            width: 100%;
            padding: 0.75rem;
            background: var(--primary-600);
            color: #fff;
            text-decoration: none;
            border-radius: 0.5rem;
            font-weight: 600;
            transition: background 0.2s;
        }

        .btn-view-profile:hover {
            background: var(--primary-700);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 1rem;
            color: var(--gray-500);
            grid-column: 1 / -1;
        }

        /* Split Layout */
        .main-content-layout {
            display: flex;
            height: calc(100vh - 200px); /* Adjust based on navbar + search height */
            gap: 0;
            overflow: hidden;
            background: #fff;
            border-top: 1px solid var(--gray-200);
        }

        .list-side {
            flex: 1.2;
            overflow-y: auto;
            padding: 2rem;
            background: var(--gray-50);
            border-right: 1px solid var(--gray-200);
        }

        .map-side {
            flex: 1;
            position: sticky;
            top: 0;
            height: 100%;
            z-index: 10;
        }

        #map {
            height: 100%;
            width: 100%;
        }

        .nutritionists-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        @media (max-width: 992px) {
            .main-content-layout {
                flex-direction: column-reverse;
                height: auto;
                overflow: visible;
            }
            .map-side {
                height: 400px;
                position: relative;
            }
            .list-side {
                height: auto;
                overflow: visible;
                padding: 1.5rem;
            }
            .search-section {
                padding: 2rem 1rem;
            }
            .search-section h1 {
                font-size: 1.75rem !important;
            }
        }

        @media (max-width: 768px) {
            .search-container {
                grid-template-columns: 1fr !important;
                gap: 1rem !important;
                padding: 1.5rem !important;
            }
            .navbar {
                padding: 1rem;
            }
            .navbar-brand {
                font-size: 1.25rem;
            }
        }
    </style>
</head>
<body class="public-page">

    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <i class="ph-fill ph-plant"></i>
            Nutrit
        </a>
        <div style="display: flex; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/auth/login" style="color: var(--gray-600); text-decoration: none; font-weight: 500;">Se connecter</a>
            <a href="${pageContext.request.contextPath}/auth/register" style="color: var(--primary-600); text-decoration: none; font-weight: 600;">Nous rejoindre</a>
        </div>
    </nav>

    <div class="search-section">
        <div class="container" style="text-align: center;">
            <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--gray-900); margin-bottom: 1rem;">Trouvez votre Nutritionniste</h1>
            <p style="color: var(--gray-600); margin-bottom: 2rem;">Recherchez par nom, clinique, spécialité ou emplacement dans toute la Tunisie</p>
            
            <form class="search-container" action="${pageContext.request.contextPath}/experts" method="GET" style="max-width: 1000px; display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 1fr auto; gap: 0.5rem; background: #fff; padding: 1rem; border-radius: 1rem; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border: 1px solid var(--gray-200);">
                
                <div style="position: relative;">
                    <i class="ph ph-magnifying-glass search-icon" style="top: 50%; transform: translateY(-50%); left: 1rem;"></i>
                    <input type="text" name="q" class="search-input" placeholder="Rechercher par nom, mot-clé, tag..." value="<%= request.getAttribute("paramQuery") != null ? request.getAttribute("paramQuery") : "" %>" style="border: 1px solid var(--gray-300); border-radius: 0.5rem; padding-left: 2.5rem;">
                </div>

                <select name="gov" class="search-input" style="border: 1px solid var(--gray-300); border-radius: 0.5rem; padding-left: 1rem;">
                    <option value="">Gouvernorat</option>
                    <c:forEach var="g" items="${governorates}">
                        <option value="${g}" ${paramGov eq g ? 'selected' : ''}>${g}</option>
                    </c:forEach>
                    <c:if test="${empty governorates}">
                        <option value="Tunis" ${paramGov eq 'Tunis' ? 'selected' : ''}>Tunis</option>
                        <option value="Sfax" ${paramGov eq 'Sfax' ? 'selected' : ''}>Sfax</option>
                    </c:if>
                </select>

                <select name="spec" class="search-input" style="border: 1px solid var(--gray-300); border-radius: 0.5rem; padding-left: 1rem;">
                    <option value="">Spécialité</option>
                    <c:forEach var="s" items="${specializations}">
                         <option value="${s}" ${paramSpec eq s ? 'selected' : ''}>${s}</option>
                    </c:forEach>
                </select>

                <select name="type" class="search-input" style="border: 1px solid var(--gray-300); border-radius: 0.5rem; padding-left: 1rem;">
                    <option value="">Type</option>
                    <option value="online" <%= "online".equals(request.getAttribute("paramType")) ? "selected" : "" %>>En Ligne</option>
                    <option value="person" <%= "person".equals(request.getAttribute("paramType")) ? "selected" : "" %>>En Personne</option>
                    <option value="both" <%= "both".equals(request.getAttribute("paramType")) ? "selected" : "" %>>Les deux</option>
                </select>

                
                <button type="submit" style="background: var(--primary-600); color: white; border: none; border-radius: 0.5rem; padding: 0 1.5rem; font-weight: 600; cursor: pointer;">Rechercher</button>
            </form>
        </div>
    </div>

    <div class="main-content-layout">
        <!-- Experts List -->
        <div class="list-side">
            <div class="nutritionists-grid">
                <%
                    List<User> nutritionists = (List<User>) request.getAttribute("nutritionists");
                    if (nutritionists != null && !nutritionists.isEmpty()) {
                        for (User n : nutritionists) {
                            NutritionistProfile profile = n.getNutritionistProfile();
                            String specialization = (profile != null && profile.getSpecialization() != null) ? profile.getSpecialization() : "General Nutrition";
                            int yearsExp = (profile != null) ? profile.getYearsExperience() : 0;
                %>
                <div class="nutri-card" id="expert-<%= n.getId() %>">
                    <div class="nutri-header">
                        <div class="nutri-avatar">
                            <% if (n.getProfileImage() != null && !n.getProfileImage().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= n.getProfileImage() %>" alt="<%= n.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                            <% } else { %>
                                <i class="ph ph-user"></i>
                            <% } %>
                        </div>
                        <div class="nutri-name">Dr. <%= n.getFullName() %></div>
                        <div class="nutri-specialty text-truncate"><%= specialization %></div>
                    </div>
                    <div class="nutri-body">
                        <div class="nutri-info-row">
                            <i class="ph ph-briefcase"></i>
                            <span><%= yearsExp %> ans d'expérience</span>
                        </div>
                        <% if (profile != null) { 
                            String loc = "";
                            if (profile.getClinicName() != null) loc += profile.getClinicName();
                            if (profile.getCity() != null) loc += (loc.isEmpty() ? "" : ", ") + profile.getCity();
                            if (loc.isEmpty() && profile.getClinicAddress() != null) loc = profile.getClinicAddress();
                        %>
                        <div class="nutri-info-row">
                            <i class="ph ph-map-pin"></i>
                            <span class="text-truncate"><%= loc %></span>
                        </div>
                        <% if(profile.getConsultationType() != null) { %>
                        <div class="nutri-info-row">
                            <i class="ph ph-video-camera"></i>
                            <span style="text-transform: capitalize;"><%= profile.getConsultationType() %></span>
                        </div>
                        <% } %>
                        <% } %>
                        <div class="nutri-info-row">
                            <i class="ph ph-money"></i>
                            <span><%= (profile != null && profile.getPrice() != null) ? profile.getPrice() : "TBD" %> TND</span>
                        </div>
                    </div>
                    <div class="nutri-footer">
                        <a href="${pageContext.request.contextPath}/profile/<%= n.getId() %>" class="btn-view-profile">Voir Profil</a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="empty-state">
                    <i class="ph ph-user-list" style="font-size: 3rem; color: var(--gray-300); margin-bottom: 1rem;"></i>
                    <h3>Aucun expert trouvé</h3>
                    <p>Réessayez avec d'autres filtres.</p>
                    <a href="${pageContext.request.contextPath}/experts" style="color: var(--primary-600); font-weight: 600; margin-top: 1rem; display: inline-block;">Effacer tout</a>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Interactive Map -->
        <div class="map-side">
            <div id="map"></div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Data from backend
            const mapData = <%= request.getAttribute("mapDataJson") != null ? request.getAttribute("mapDataJson") : "[]" %>;
            console.log("Map Data Loaded:", mapData.length, "experts");

            // Initialize map centered on Tunisia
            const map = L.map('map').setView([34.0, 9.0], 7);

            // Use CartoDB Voyager for a cleaner, more professional look
            L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
                subdomains: 'abcd',
                maxZoom: 19
            }).addTo(map);

            const markers = [];
            
            // Explicit icon definition to avoid default marker issues
            const activeIcon = L.icon({
                iconUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon.png',
                iconRetinaUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon-2x.png',
                shadowUrl: 'https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png',
                iconSize: [25, 41],
                iconAnchor: [12, 41],
                popupAnchor: [1, -34],
                shadowSize: [41, 41]
            });
            
            mapData.forEach(expert => {
                const marker = L.marker([expert.lat, expert.lng], { icon: activeIcon }).addTo(map);
                
                const popupContent = 
                    '<div style="padding: 8px; font-family: \'Inter\', sans-serif; min-width: 150px;">' +
                        '<strong style="display: block; color: var(--primary-700, #059669); font-size: 14px; margin-bottom: 4px;">Dr. ' + expert.name + '</strong>' +
                        '<div style="color: #4B5563; font-size: 12px; margin-bottom: 8px; display: flex; align-items: center; gap: 4px;">' +
                            '<i class="ph-fill ph-check-circle" style="color: #059669;"></i>' +
                            (expert.specialty || expert.clinic) +
                        '</div>' +
                        '<a href="${pageContext.request.contextPath}/profile/' + expert.id + '"' + 
                           ' style="display: block; text-align: center; background: #059669; color: white; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 12px; font-weight: 600; transition: background 0.2s;">' +
                           'Voir Profil' +
                        '</a>' +
                    '</div>';
                
                marker.bindPopup(popupContent);
                markers.push(marker);
                
                // Interaction: center map on card click (optional)
                const card = document.getElementById('expert-' + expert.id);
                if(card) {
                    card.addEventListener('mouseenter', () => {
                         marker.openPopup();
                    });
                     card.addEventListener('click', () => {
                         map.flyTo([expert.lat, expert.lng], 14);
                         marker.openPopup();
                    });
                }
            });

            // Adjust view if markers exist
            if (markers.length > 0) {
                const group = new L.featureGroup(markers);
                map.fitBounds(group.getBounds().pad(0.1));
            }
        });
    </script>

</body>
</html>
