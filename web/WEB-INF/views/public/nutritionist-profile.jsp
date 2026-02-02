<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="com.nutrit.models.NutritionistProfile" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        User n = (User) request.getAttribute("nutritionist");
        NutritionistProfile p = (NutritionistProfile) request.getAttribute("profile");
        String fullName = (n != null) ? n.getFullName() : "Nutritionist";
    %>
    <title>Dr. <%= fullName %> - Profil Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .public-profile {
            background-color: var(--gray-50);
            min-height: 100vh;
            padding-bottom: 4rem;
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary-600), var(--primary-800));
            padding: 2rem 0 6rem;
            color: #fff;
        }
        
        /* Reusing Navbar styles */
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

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .profile-card {
            background: #fff;
            border-radius: 1.5rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            margin-top: -4rem;
            overflow: hidden;
            display: grid;
            grid-template-columns: 300px 1fr;
        }

        .profile-sidebar {
            background: var(--gray-50);
            padding: 2rem;
            text-align: center;
            border-right: 1px solid var(--gray-200);
        }

        .profile-main {
            padding: 3rem;
        }

        .large-avatar {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            background: var(--primary-100);
            color: var(--primary-600);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 5rem;
            margin: 0 auto 1.5rem;
            border: 6px solid #fff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            object-fit: cover;
        }

        .expert-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: var(--primary-100);
            color: var(--primary-700);
            border-radius: 2rem;
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }

        .consultation-price {
            margin: 2rem 0;
            padding: 1.5rem;
            background: #fff;
            border-radius: 1rem;
            border: 1px solid var(--gray-200);
        }

        .price-label {
            font-size: 0.875rem;
            color: var(--gray-500);
            margin-bottom: 0.5rem;
        }

        .price-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--gray-900);
        }

        .btn-book {
            display: block;
            width: 100%;
            padding: 1rem;
            background: var(--primary-600);
            color: #fff;
            text-decoration: none;
            border-radius: 0.75rem;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.2s;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.3);
        }

        .btn-book:hover {
            background: var(--primary-700);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(5, 150, 105, 0.4);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .section-title i {
            color: var(--primary-600);
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .info-item h4 {
            color: var(--gray-500);
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }

        .info-item p {
            color: var(--gray-900);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .bio-text {
            color: var(--gray-600);
            line-height: 1.7;
            margin-bottom: 2rem;
        }

        .clinic-info {
            background: var(--gray-50);
            padding: 2rem;
            border-radius: 1rem;
            border: 1px solid var(--gray-200);
        }

        @media (max-width: 900px) {
            .profile-card {
                grid-template-columns: 1fr;
            }
            .profile-sidebar {
                border-right: none;
                border-bottom: 1px solid var(--gray-200);
                padding: 1.5rem;
            }
            .profile-main {
                padding: 1.5rem;
            }
            .large-avatar {
                width: 140px;
                height: 140px;
                font-size: 4rem;
            }
            .profile-main h1 {
                font-size: 1.75rem !important;
            }
            .info-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
        }

        @media (max-width: 600px) {
            .navbar {
                padding: 1rem;
            }
            .navbar-brand {
                font-size: 1.25rem;
            }
            .profile-header {
                padding: 1rem 0 4rem;
            }
            .profile-card {
                border-radius: 0;
            }
        }
        
        
        /* Booking Styles */
        .date-section { margin-bottom: 1.5rem; }
        .date-header {
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            display: flex; align-items: center; gap: 0.5rem;
            font-size: 0.9rem;
        }
        .slots-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.5rem;
        }
        .slot-btn {
            padding: 0.5rem;
            border: 1px solid var(--gray-300);
            border-radius: 0.5rem;
            background: #fff;
            cursor: pointer;
            font-size: 0.9rem;
            color: var(--gray-700);
            transition: all 0.2s;
            text-align: center;
        }
        .slot-btn:hover {
            border-color: var(--primary-500);
            color: var(--primary-600);
            background: var(--primary-50);
        }
        .slot-btn.selected {
            background: var(--primary-600);
            color: #fff;
            border-color: var(--primary-600);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .modal.active { display: flex; }
        .modal-content {
            background: #fff;
            padding: 2rem;
            border-radius: 1rem;
            width: 90%;
            max-width: 400px;
            text-align: center;
        }
        .modal-title { font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem; }
        .modal-options { display: grid; gap: 1rem; margin-bottom: 1.5rem; }
        .modal-option {
            padding: 1rem;
            border: 2px solid var(--gray-200);
            border-radius: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
            display: flex; flex-direction: column; align-items: center; gap: 0.5rem;
        }
        .modal-option:hover, .modal-option.selected {
            border-color: var(--primary-600);
            background: var(--primary-50);
        }
        .modal-option i { font-size: 1.5rem; color: var(--primary-600); }
        .btn-confirm {
            width: 100%;
            padding: 0.75rem;
            background: var(--primary-600);
            color: #fff;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-confirm:disabled { background: var(--gray-400); cursor: not-allowed; }
    </style>
</head>
<body class="public-profile">

    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <i class="ph-fill ph-plant"></i>
            Nutrit
        </a>
        <div style="display: flex; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/experts" style="color: var(--gray-600); text-decoration: none; display: flex; align-items: center; gap: 0.5rem;">
                <i class="ph ph-arrow-left"></i> Retour à la liste
            </a>
        </div>
    </nav>

    <% if (n != null) { 
        String bio = (p != null && p.getBio() != null) ? p.getBio() : "Aucune biographie disponible.";
        String specialization = (p != null && p.getSpecialization() != null) ? p.getSpecialization() : "Nutrition Générale";
        String clinic = (p != null && p.getClinicAddress() != null) ? p.getClinicAddress() : "Consultation en ligne";
        String hours = (p != null && p.getWorkingHours() != null) ? p.getWorkingHours() : "Sur rendez-vous";
        String license = (p != null && p.getLicenseNumber() != null) ? p.getLicenseNumber() : "Vérifié";
        java.math.BigDecimal price = (p != null && p.getPrice() != null) ? p.getPrice() : java.math.BigDecimal.ZERO;
        int yearsExp = (p != null) ? p.getYearsExperience() : 0;
    %>

    <div class="profile-header">
        <div class="container">
            <!-- Header content overlap handled by card margin -->
        </div>
    </div>

    <div class="container">
        <div class="profile-card">
            <div class="profile-sidebar">
                <% if (n.getProfileImage() != null && !n.getProfileImage().isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= n.getProfileImage() %>" class="large-avatar" alt="<%= n.getFullName() %>">
                <% } else { %>
                    <div class="large-avatar">
                        <i class="ph ph-user"></i>
                    </div>
                <% } %>
                
                <div class="expert-badge">
                    <i class="ph ph-seal-check"></i>
                    Expert Vérifié
                </div>

                <div class="consultation-price">
                    <div class="price-label">Frais de Consultation</div>
                    <div class="price-value"><%= price %> TND</div>
                </div>

                <div style="text-align: left; margin-bottom: 1rem;">
                    <h4 style="font-size: 1rem; color: var(--gray-700); margin-bottom: 0.5rem;">Prendre un Rendez-vous</h4>
                    
                    <% 
                    Map<String, List<Timestamp>> availableSlots = (Map<String, List<Timestamp>>) request.getAttribute("availableSlots");
                    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                    SimpleDateFormat sideDateFormat = new SimpleDateFormat("EEE d MMM", java.util.Locale.FRENCH);
                    if (availableSlots != null && !availableSlots.isEmpty()) {
                        int dayCount = 0;
                        for (Map.Entry<String, List<Timestamp>> entry : availableSlots.entrySet()) {
                            if (dayCount >= 1) break; // Limit to 1 day for sidebar compactness
                            dayCount++;
                    %>
                        <div class="date-section">
                            <div class="date-header">
                                <i class="ph ph-calendar-blank"></i> <%= entry.getKey() %>
                            </div>
                            <div class="slots-grid">
                                <% for (Timestamp slot : entry.getValue()) { %>
                                    <div class="slot-btn" onclick="openBookingModal('<%= slot.toString() %>', '<%= timeFormat.format(slot) %>', '<%= entry.getKey() %>')">
                                        <%= timeFormat.format(slot) %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% 
                        }
                    } else { 
                    %>
                        <div style="text-align: center; color: var(--gray-500); padding: 1rem;">
                            <i class="ph ph-calendar-x" style="font-size: 2rem;"></i>
                            <p>Aucun créneau disponible</p>
                        </div>
                    <% } %>
                    
                    <button id="showMoreBtn" style="width: 100%; margin-top: 1rem; padding: 0.5rem; border: 1px dashed var(--gray-300); background: transparent; color: var(--gray-500); cursor: pointer; border-radius: 0.5rem;" onclick="location.href='${pageContext.request.contextPath}/patient/appointment?nutritionistId=<%= n.getId() %>'">
                        Voir toutes les disponibilités
                    </button>
                </div>
            </div>

            <div class="profile-main">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem;">
                    <div>
                        <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--gray-900); margin-bottom: 0.5rem;">Dr. <%= n.getFullName() %></h1>
                        <p style="color: var(--primary-600); font-size: 1.25rem; font-weight: 600; margin-bottom: 0.5rem;"><%= specialization %></p>
                        <% if (p != null && p.getClinicName() != null) { %>
                            <p style="color: var(--gray-500); font-size: 1.1rem; display: flex; align-items: center; gap: 0.5rem;">
                                <i class="ph ph-hospital"></i> <%= p.getClinicName() %>
                            </p>
                        <% } %>
                    </div>
                </div>

                <!-- Tags Section -->
                <div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 2rem;">
                    <% if (p != null && p.getConsultationType() != null) { 
                        String cType = p.getConsultationType();
                        String icon = "globe";
                        String label = "En Ligne";
                        if (cType.contains("presentiel")) { icon = "buildings"; label = "En Personne"; }
                        else if (cType.contains("hybride")) { icon = "arrows-left-right"; label = "Hybride (Ligne & Cabinet)"; }
                    %>
                        <span style="background: var(--primary-50); color: var(--primary-700); padding: 0.5rem 1rem; border-radius: 2rem; font-size: 0.9rem; font-weight: 600; display: inline-flex; align-items: center; gap: 0.5rem;">
                            <i class="ph ph-<%= icon %>"></i> <%= label %>
                        </span>
                    <% } %>
                    
                    <% if (p != null && p.getLanguages() != null && !p.getLanguages().isEmpty()) { 
                        String[] langs = p.getLanguages().split(",");
                        for(String lang : langs) {
                    %>
                        <span style="background: var(--gray-100); color: var(--gray-700); padding: 0.5rem 1rem; border-radius: 2rem; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 0.5rem;">
                            <i class="ph ph-translate"></i> <%= lang.trim() %>
                        </span>
                    <%  } 
                       } %>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <h4>Expérience</h4>
                        <p><%= yearsExp %> Ans</p>
                    </div>
                    <div class="info-item">
                        <h4>Numéro de Licence</h4>
                        <p><%= license %></p>
                    </div>
                    <% if (p != null && p.getCity() != null) { %>
                    <div class="info-item">
                        <h4>Emplacement</h4>
                        <p><%= p.getCity() %><%= (p.getGovernorate() != null) ? ", " + p.getGovernorate() : "" %></p>
                    </div>
                    <% } %>
                </div>

                <h3 class="section-title"><i class="ph ph-article"></i> À propos</h3>
                <p class="bio-text">
                    <%= bio %>
                </p>

                <% if (p != null && (p.getMultipleSpecialties() != null || p.getKeywords() != null)) { %>
                    <h3 class="section-title" style="margin-top: 2rem;"><i class="ph ph-stethoscope"></i> Spécialités</h3>
                    <div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 2rem;">
                        <% 
                        if (p.getMultipleSpecialties() != null) {
                            for (String s : p.getMultipleSpecialties().split(",")) {
                        %>
                            <span style="border: 1px solid var(--primary-200); color: var(--primary-700); padding: 0.4rem 0.8rem; border-radius: 0.5rem; font-size: 0.9rem;"><%= s.trim() %></span>
                        <% 
                            }
                        }
                        if (p.getKeywords() != null) {
                            for (String k : p.getKeywords().split(",")) {
                        %>
                            <span style="background: var(--gray-50); color: var(--gray-600); padding: 0.4rem 0.8rem; border-radius: 0.5rem; font-size: 0.9rem;"><%= k.trim() %></span>
                        <% 
                            }
                        }
                        %>
                    </div>
                <% } %>

                <% if (p != null && p.getDiplomas() != null && !p.getDiplomas().isEmpty()) { %>
                    <h3 class="section-title"><i class="ph ph-graduation-cap"></i> Éducation & Diplômes</h3>
                    <div style="background: var(--gray-50); padding: 1.5rem; border-radius: 1rem; border-left: 4px solid var(--primary-500); margin-bottom: 2rem;">
                         <p style="color: var(--gray-800); font-weight: 500;"><%= p.getDiplomas().replace(",", "<br>") %></p>
                    </div>
                <% } %>

                <div class="clinic-info">
                    <h3 class="section-title" style="font-size: 1.25rem; margin-bottom: 1rem;"><i class="ph ph-map-pin"></i> Détails du Cabinet</h3>
                    <div class="info-grid" style="margin-bottom: 1rem;">
                        <div class="info-item">
                            <h4>Adresse</h4>
                            <p><%= clinic %></p>
                            <% if (p.getCity() != null) { %>
                                <p style="font-size: 0.9rem; color: var(--gray-500); font-weight: 400;"><%= p.getCity() %>, <%= p.getGovernorate() %></p>
                            <% } %>
                        </div>
                        <div class="info-item">
                            <h4>Heures de Travail</h4>
                            <p><%= hours %></p>
                        </div>
                    </div>
                    
                    <% 
                    List<User> secretaries = (List<User>) request.getAttribute("secretaries");
                    if (secretaries != null && !secretaries.isEmpty()) {
                        User sec = secretaries.get(0); // Display the first secretary's info
                    %>
                        <div style="margin-bottom: 1rem; padding-top: 1rem; border-top: 1px solid var(--gray-200);">
                            <h4 style="font-size: 0.875rem; color: var(--gray-500); margin-bottom: 0.5rem;">Contact Secrétariat</h4>
                            <p style="font-size: 1.1rem; font-weight: 600; color: var(--gray-900); display: flex; align-items: center; gap: 0.5rem;">
                                <i class="ph ph-phone-call"></i> <a href="tel:<%= sec.getPhone() %>" style="text-decoration: none; color: inherit;"><%= sec.getPhone() %></a>
                            </p>
                            <p style="font-size: 0.9rem; color: var(--gray-500);"><%= sec.getFullName() %></p>
                        </div>
                    <% } %>
                    
                    <% if (p != null && p.getLatitude() != null && p.getLongitude() != null) { %>
                        <div id="map" style="height: 250px; border-radius: 0.5rem; margin-top: 1rem;"></div>
                        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>
                        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
                        <script>
                            document.addEventListener('DOMContentLoaded', function() {
                                var map = L.map('map').setView([<%= p.getLatitude() %>, <%= p.getLongitude() %>], 13);
                
                                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                                }).addTo(map);
                
                                L.marker([<%= p.getLatitude() %>, <%= p.getLongitude() %>]).addTo(map)
                                    .bindPopup('<b style="color: var(--primary-700);"><%= p.getClinicName() != null ? p.getClinicName().replace("'", "\\'") : "Clinic" %></b><br><%= clinic.replace("'", "\\'") %>')
                                    .openPopup();
                            });
                        </script>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <!-- Booking Modal -->
    <div id="bookingModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title">Confirmer le Rendez-vous</h3>
            <p style="color: var(--gray-600); margin-bottom: 1.5rem;">
                Rendez-vous avec Dr. <%= n.getFullName() %><br>
                <span id="modalDate" style="font-weight: 600; color: var(--gray-900);"></span> à <span id="modalTime" style="font-weight: 600; color: var(--gray-900);"></span>
            </p>
            
            <div class="modal-options">
                <div class="modal-option" onclick="selectType(this, 'in_office')">
                    <i class="ph ph-buildings"></i>
                    <span style="font-weight: 600;">Au Cabinet</span>
                    <span style="font-size: 0.8rem; color: var(--gray-500);">Payer <%= price %> TND au cabinet</span>
                </div>
                <div class="modal-option" onclick="selectType(this, 'online')">
                    <i class="ph ph-video-camera"></i>
                    <span style="font-weight: 600;">En Ligne</span>
                    <span style="font-size: 0.8rem; color: var(--gray-500);">Payer <%= price %> TND en ligne</span>
                </div>
            </div>

            <div style="display: flex; gap: 1rem;">
                <button onclick="closeModal()" style="flex: 1; padding: 0.75rem; background: transparent; border: 1px solid var(--gray-300); border-radius: 0.5rem; cursor: pointer;">Annuler</button>
                <button id="confirmBtn" onclick="confirmBooking()" class="btn-confirm" disabled>Confirmer & Réserver</button>
            </div>
        </div>
    </div>

    <script>
        let selectedSlotTs = null;
        let selectedType = null;
        const isLoggedIn = <%= session.getAttribute("user") != null %>;
        const nutritionistId = <%= n.getId() %>;

        function openBookingModal(ts, time, date) {
            selectedSlotTs = ts;
            document.getElementById('modalDate').innerText = date;
            document.getElementById('modalTime').innerText = time;
            
            // Reset selection
            document.querySelectorAll('.modal-option').forEach(el => el.classList.remove('selected'));
            selectedType = null;
            document.getElementById('confirmBtn').disabled = true;
            
            document.getElementById('bookingModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('bookingModal').classList.remove('active');
        }

        function selectType(el, type) {
            document.querySelectorAll('.modal-option').forEach(e => e.classList.remove('selected'));
            el.classList.add('selected');
            selectedType = type;
            document.getElementById('confirmBtn').disabled = false;
        }

        function confirmBooking() {
            if (!selectedSlotTs || !selectedType) return;

            if (!isLoggedIn) {
                // Not logged in -> Redirect to Register with params
                // Encoding components to ensure URL safety
                const params = new URLSearchParams({
                    nutritionistId: nutritionistId,
                    slot: selectedSlotTs,
                    type: selectedType,
                    redirect: 'booking' // Special flag for registration handling
                });
                window.location.href = '${pageContext.request.contextPath}/auth/register?' + params.toString();
            } else {
                // Logged in -> Post to existing logic
                // We'll create a hidden form and submit it
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/patient/bookAppointment'; // Reusing this endpoint

                const inputSlot = document.createElement('input');
                inputSlot.type = 'hidden';
                inputSlot.name = 'selectedSlot';
                inputSlot.value = selectedSlotTs;
                
                const inputPayment = document.createElement('input');
                inputPayment.type = 'hidden';
                inputPayment.name = 'paymentMethod';
                inputPayment.value = selectedType; // 'online' or 'in_office' matches what book_appointment.jsp expects

                // Some defaults
                const inputAmount = document.createElement('input');
                inputAmount.type = 'hidden';
                inputAmount.name = 'amount';
                inputAmount.value = '<%= price %>';

                form.appendChild(inputSlot);
                form.appendChild(inputPayment);
                form.appendChild(inputAmount);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Close modal on outside click
        window.onclick = function(event) {
            const modal = document.getElementById('bookingModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
    <% } %>
</body>
</html>
