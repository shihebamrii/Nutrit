<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Inscription - Nutrit</title>

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

    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" crossorigin=""/>
    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" crossorigin=""></script>

    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/landing.css" />
    
    <style>
        body {
            /* Background Image with Overlay */
            background: url('https://media.istockphoto.com/id/1160789077/photo/nutritionist-giving-consultation-to-patient-with-healthy-fruit-and-vegetable-right-nutrition.jpg?s=612x612&w=0&k=20&c=t5LNRmwc-BKcV-jmOGiCZXo5DWjBZKMe0OumH4WdW7I=') center center / cover no-repeat fixed;
            min-height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
            position: relative;
        }

        /* Dark/Green Gradient Overlay */
        body::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(6, 78, 59, 0.85), rgba(6, 95, 70, 0.75));
            z-index: 1;
            backdrop-filter: blur(4px);
        }

        .auth-container {
            width: 100%;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            position: relative;
            z-index: 10;
            box-sizing: border-box;
        }

        .auth-card {
            /* Glassmorphism Effect */
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 24px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
            padding: 2.5rem;
            width: 100%;
            max-width: 800px; /* Wider for better map layout */
            animation: fadeInUp 0.5s ease;
            position: relative;
            max-height: 90vh; /* Prevent overflowing viewport */
            overflow-y: auto; /* Allow scrolling inside card */
        }
        
        /* Custom Scrollbar for the card */
        .auth-card::-webkit-scrollbar {
            width: 8px;
        }
        .auth-card::-webkit-scrollbar-track {
            background: rgba(0,0,0,0.05);
            border-radius: 4px;
        }
        .auth-card::-webkit-scrollbar-thumb {
            background: rgba(16, 185, 129, 0.3);
            border-radius: 4px;
        }
        .auth-card::-webkit-scrollbar-thumb:hover {
            background: rgba(16, 185, 129, 0.5);
        }

        .auth-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .auth-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: #064e3b;
            margin-bottom: 0.5rem;
        }

        .auth-subtitle {
            color: #6b7280;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
        }

        .form-group {
            margin-bottom: 0; /* Let grid gap handle spacing */
        }
        
        .form-group.full-width {
            grid-column: span 2;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .form-input, .form-select, textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #f9fafb;
            box-sizing: border-box; /* Fix padding calculation */
        }

        .form-input:focus, .form-select:focus, textarea:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
            background: white;
        }
        
        #map-container {
            height: 300px;
            width: 100%;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            margin-top: 0.5rem;
            z-index: 1; /* Ensure it stays below navbar if fixed */
        }

        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: white;
            border: none;
            padding: 1rem;
            border-radius: 100px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.2);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.3);
            background: linear-gradient(135deg, #047857 0%, #059669 100%);
        }

        .auth-footer {
            margin-top: 2rem;
            text-align: center;
            font-size: 0.9375rem;
            color: #6b7280;
        }

        .auth-link {
            color: var(--primary-600);
            font-weight: 600;
            text-decoration: none;
        }

        .auth-link:hover {
            text-decoration: underline;
        }
        
        .nutritionist-fields {
            display: none;
            background: #f0fdf4;
            padding: 1.5rem;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            border: 1px solid #dcfce7;
            margin-top: 1.5rem;
        }
        
        .section-separator {
            margin: 0 0 1.5rem;
            font-weight: 700;
            color: #064e3b;
            font-size: 1.1rem;
            border-bottom: 2px solid #dcfce7;
            padding-bottom: 0.75rem;
        }

        @media (max-width: 640px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .form-group.full-width {
                grid-column: span 1;
            }
            .auth-card {
                padding: 2rem 1.5rem;
            }
            .auth-title {
                font-size: 1.75rem;
            }
            .navbar {
                padding: 1rem 0;
            }
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="auth-container">
        
        <!-- Navbar inside container for z-index management or kept separate? Keeping fixed navbar requires z-index adjustment -->
        <nav class="navbar" style="position: fixed; top: 0; left: 0; width: 100%; background: transparent; padding: 1.5rem 0; z-index: 50; pointer-events: none;">
          <div class="nav-container" style="pointer-events: auto;">
            <a href="${pageContext.request.contextPath}/" class="nav-logo" style="color: white; text-shadow: 0 2px 4px rgba(0,0,0,0.2);">
              Nutrit<span class="dot" style="color: #4ade80;">.</span>
            </a>
            <div class="nav-menu">
                 <a href="${pageContext.request.contextPath}/" class="btn-secondary" style="background: rgba(255,255,255,0.2); border-color: rgba(255,255,255,0.4); color: white; backdrop-filter: blur(5px); padding: 0.5rem 1.25rem; font-size: 0.9rem;">
                    <i class="fas fa-arrow-left"></i> Retour
                 </a>
            </div>
          </div>
        </nav>

        <div class="auth-card">
            <div class="auth-header">
                <h1 class="auth-title">Créer un compte</h1>
                <p class="auth-subtitle">Rejoignez la communauté Nutrit dès aujourd'hui</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message" style="background-color: #fef2f2; color: #ef4444; padding: 1rem; border-radius: 12px; margin-bottom: 1.5rem; border: 1px solid #fee2e2; display: flex; align-items: center; gap: 0.75rem;">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth/register" method="POST">
                
                <!-- Main Info Section -->
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label class="form-label">Je suis...</label>
                        <select name="role" id="roleSelect" class="form-select" onchange="toggleNutritionistFields()">
                            <option value="patient">Un Patient (Je veux améliorer ma santé)</option>
                            <option value="nutritionist">Un Nutritionniste (Je veux proposer mes services)</option>
                        </select>
                    </div>
                
                    <div class="form-group full-width">
                        <label for="full_name" class="form-label">Nom complet</label>
                        <input type="text" id="full_name" name="full_name" class="form-input" placeholder="Jean Dupont" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="email" class="form-label">Adresse e-mail</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="exemple@email.com" required>
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label">Mot de passe</label>
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone" class="form-label">Téléphone</label>
                        <input type="tel" id="phone" name="phone" class="form-input" placeholder="06 12 34 56 78">
                    </div>
                    
                    <div class="form-group full-width">
                        <label for="address" class="form-label">Adresse Personnelle</label>
                        <input type="text" id="address" name="address" class="form-input" placeholder="Votre adresse complète">
                    </div>
                </div>

                <!-- Nutritionist Specific Fields -->
                <div id="nutritionistFields" class="nutritionist-fields">
                    <h3 class="section-separator">Informations Professionnelles</h3>
                    
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label for="specialization" class="form-label">Spécialisation Principale</label>
                            <input type="text" id="specialization" name="specialization" class="form-input" placeholder="Ex: Nutrition Sportive, Perte de Poids">
                        </div>
                        
                        <div class="form-group">
                            <label for="years_experience" class="form-label">Années d'expérience</label>
                            <input type="number" id="years_experience" name="years_experience" class="form-input" min="0">
                        </div>
                        
                        <div class="form-group">
                            <label for="license_number" class="form-label">Numéro de Licence/Adeli</label>
                            <input type="text" id="license_number" name="license_number" class="form-input">
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="clinic_name" class="form-label">Nom du Cabinet (Optionnel)</label>
                            <input type="text" id="clinic_name" name="clinic_name" class="form-input">
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="clinic_address" class="form-label">Adresse du Cabinet</label>
                            <input type="text" id="clinic_address" name="clinic_address" class="form-input" onchange="geocodeAddress()">
                        </div>
                        
                        <div class="form-group">
                            <label for="city" class="form-label">Ville</label>
                            <input type="text" id="city" name="city" class="form-input">
                        </div>
                        
                        <div class="form-group">
                            <label for="governorate" class="form-label">Gouvernorat</label>
                            <input type="text" id="governorate" name="governorate" class="form-input">
                        </div>
                        
                        <!-- Map Section -->
                        <div class="form-group full-width">
                            <label class="form-label">Localisation du Cabinet (Cliquer sur la carte)</label>
                            <div id="map-container"></div>
                            <input type="hidden" id="latitude" name="latitude">
                            <input type="hidden" id="longitude" name="longitude">
                            <p style="font-size: 0.8rem; color: #6b7280; margin-top: 0.5rem;">
                                <i class="fas fa-info-circle"></i> Vous pouvez cliquer sur la carte pour ajuster la position exacte.
                            </p>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="consultation_type" class="form-label">Type de Consultation</label>
                            <select id="consultation_type" name="consultation_type" class="form-select">
                                <option value="en_ligne">En ligne (Vidéo)</option>
                                <option value="presentiel">En cabinet</option>
                                <option value="hybride">Hybride (En ligne & Cabinet)</option>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label for="working_hours" class="form-label">Horaires de Travail</label>
                            <input type="text" id="working_hours" name="working_hours" class="form-input" placeholder="Ex: Lun-Ven 09:00-18:00">
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label">Autres Spécialités</label>
                            <div class="specialties-grid">
                                <label class="specialty-chip">
                                    <input type="checkbox" name="specialties_multi" value="perte_poids">
                                    <span><i class="fas fa-weight-scale"></i> Perte de poids</span>
                                </label>
                                <label class="specialty-chip">
                                    <input type="checkbox" name="specialties_multi" value="nutrition_sportive">
                                    <span><i class="fas fa-running"></i> Nutrition sportive</span>
                                </label>
                                <label class="specialty-chip">
                                    <input type="checkbox" name="specialties_multi" value="diabete">
                                    <span><i class="fas fa-notes-medical"></i> Diabète</span>
                                </label>
                                <label class="specialty-chip">
                                    <input type="checkbox" name="specialties_multi" value="digestif">
                                    <span><i class="fas fa-stomach"></i> Troubles digestifs</span>
                                </label>
                                <label class="specialty-chip">
                                    <input type="checkbox" name="specialties_multi" value="pediatrie">
                                    <span><i class="fas fa-baby"></i> Pédiatrie</span>
                                </label>
                                <label class="specialty-chip">
                                    <input type="checkbox" name="specialties_multi" value="grossesse">
                                    <span><i class="fas fa-person-pregnant"></i> Grossesse</span>
                                </label>
                                <label class="specialty-chip">
                                    <input type="checkbox" name="specialties_multi" value="vegetarien">
                                    <span><i class="fas fa-carrot"></i> Végétarisme</span>
                                </label>
                            </div>
                            <style>
                                .specialties-grid {
                                    display: flex;
                                    flex-wrap: wrap;
                                    gap: 0.75rem;
                                }
                                .specialty-chip {
                                    cursor: pointer;
                                    user-select: none;
                                }
                                .specialty-chip input {
                                    position: absolute;
                                    opacity: 0;
                                    cursor: pointer;
                                    height: 0;
                                    width: 0;
                                }
                                .specialty-chip span {
                                    display: flex;
                                    align-items: center;
                                    gap: 0.5rem;
                                    padding: 0.6rem 1rem;
                                    border: 1px solid #d1d5db;
                                    border-radius: 100px;
                                    background: white;
                                    color: #4b5563;
                                    font-size: 0.9rem;
                                    font-weight: 500;
                                    transition: all 0.2s ease;
                                    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
                                }
                                .specialty-chip span:hover {
                                    background: #f9fafb;
                                    border-color: #9ca3af;
                                }
                                .specialty-chip input:checked + span {
                                    background: #ecfdf5;
                                    border-color: #10b981;
                                    color: #047857;
                                    box-shadow: 0 2px 4px rgba(16, 185, 129, 0.15);
                                }
                            </style>
                        </div>
                        
                        <div class="form-group full-width">
                            <label for="languages" class="form-label">Langues Parlées</label>
                            <div style="display: flex; gap: 1rem; flex-wrap: wrap; margin-top: 0.5rem;">
                                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                    <input type="checkbox" name="languages" value="francais" checked> Français
                                </label>
                                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                    <input type="checkbox" name="languages" value="arabe"> Arabe
                                </label>
                                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                    <input type="checkbox" name="languages" value="anglais"> Anglais
                                </label>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label for="diplomas" class="form-label">Diplômes & Certifications</label>
                            <textarea id="diplomas" name="diplomas" class="form-input" rows="3" placeholder="Listez vos diplômes..."></textarea>
                        </div>

                        <div class="form-group full-width">
                            <label for="keywords" class="form-label">Mots-clés (pour la recherche)</label>
                            <input type="text" id="keywords" name="keywords" class="form-input" placeholder="Ex: sommeil, stress, énergie, bio">
                        </div>
                        
                        <div class="form-group">
                            <label for="price" class="form-label">Tarif Consultation</label>
                            <input type="number" id="price" name="price" class="form-input" min="0" step="0.01">
                        </div>
                    </div>
                </div>

                <div class="form-group full-width" style="margin-top: 2rem;">
                    <label style="display: flex; align-items: start; gap: 0.5rem; font-size: 0.875rem; color: #6b7280;">
                        <input type="checkbox" required style="margin-top: 0.25rem;">
                        <span>J'accepte les <a href="#" class="auth-link">Conditions Générales d'Utilisation</a> et la <a href="#" class="auth-link">Politique de Confidentialité</a>.</span>
                    </label>
                </div>

                <button type="submit" class="btn-submit">
                    Créer mon compte <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="auth-footer">
                Déjà un compte ? 
                <a href="${pageContext.request.contextPath}/auth/login" class="auth-link">Se connecter</a>
            </div>
        </div>
    </div>

    <script>
        let map, marker;

        function initMap() {
            // Tunisia coordinates default
            map = L.map('map-container').setView([36.8065, 10.1815], 13);
            
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap contributors'
            }).addTo(map);
            
            map.on('click', function(e) {
                setMarker(e.latlng.lat, e.latlng.lng);
            });
            
            // Fix map size on container visibility change/resize
            setTimeout(() => { map.invalidateSize(); }, 500);
        }

        function setMarker(lat, lng) {
            if (marker) {
                marker.setLatLng([lat, lng]);
            } else {
                marker = L.marker([lat, lng]).addTo(map);
            }
            document.getElementById('latitude').value = lat;
            document.getElementById('longitude').value = lng;
        }

        function toggleNutritionistFields() {
            const roleSelect = document.getElementById('roleSelect');
            const nutritionistFields = document.getElementById('nutritionistFields');
            
            if (roleSelect.value === 'nutritionist') {
                nutritionistFields.style.display = 'block';
                // Animation for smooth appearing
                nutritionistFields.style.opacity = '0';
                setTimeout(() => {
                    nutritionistFields.style.transition = 'opacity 0.3s ease';
                    nutritionistFields.style.opacity = '1';
                }, 10);
                
                // Init map if it hasn't been initialized (visible now)
                if(!map) {
                    setTimeout(initMap, 100);
                } else {
                    setTimeout(() => { map.invalidateSize(); }, 100);
                }
                
            } else {
                nutritionistFields.style.display = 'none';
            }
        }
        
        // Geocoding stub (optional enhancement)
        function geocodeAddress() {
            // In a real app, call Nominatim API or Google Maps API here to auto-center map
            // based on the address entered
        }
    </script>
</body>
</html>
