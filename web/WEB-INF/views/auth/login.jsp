<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Connexion - Nutrit</title>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/landing.css" />
    
    <style>
        /* Reset & Core Layout */
        body {
            min-height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
            overflow: hidden;
            background: #0f172a; /* Fallback */
        }

        /* --- THEME LAYERS (Background + Overlay linked) --- */
        .theme-layer {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            opacity: 0;
            transition: opacity 1.2s cubic-bezier(0.4, 0, 0.2, 1); /* Cinema-style ease */
            pointer-events: none;
        }

        .theme-layer.active {
            opacity: 1;
        }

        .theme-bg {
            position: absolute;
            top: -5%; left: -5%;
            width: 110%; height: 110%; /* Parallax breathing room */
            background-size: cover;
            background-position: center;
            filter: brightness(0.9);
        }

        .theme-overlay {
            position: absolute;
            inset: 0;
            backdrop-filter: blur(0px); /* Hardware accel */
        }

        /* Theme 1: Professional (Default) */
        #theme-pro .theme-bg {
            background-image: url('https://media.istockphoto.com/id/1160789077/photo/nutritionist-giving-consultation-to-patient-with-healthy-fruit-and-vegetable-right-nutrition.jpg?s=612x612&w=0&k=20&c=t5LNRmwc-BKcV-jmOGiCZXo5DWjBZKMe0OumH4WdW7I=');
        }
        #theme-pro .theme-overlay {
            background: linear-gradient(135deg, rgba(6, 95, 70, 0.85), rgba(16, 185, 129, 0.8)); /* Deep Green */
        }

        /* Theme 2: Patient (Lifestyle) */
        #theme-patient .theme-bg {
            background-image: url('https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=2070&auto=format&fit=crop'); /* Healthy Food/Lifestyle */
        }
        #theme-patient .theme-overlay {
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.6), rgba(56, 189, 248, 0.5)); /* Royal Blue/Slate */
        }

        /* --- AUTH CARD DESIGN --- */
        .auth-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(25px) saturate(180%);
            -webkit-backdrop-filter: blur(25px) saturate(180%);
            padding: 3rem;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.6);
            width: 100%;
            max-width: 440px;
            text-align: center;
            position: relative;
            z-index: 10;
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        /* Patient Mode Card Tweaks */
        .patient-mode .auth-card {
            background: rgba(255, 255, 255, 0.75);
            border-color: rgba(255, 255, 255, 0.8);
            box-shadow: 0 25px 70px rgba(14, 165, 233, 0.2);
        }

        .auth-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .auth-logo {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            text-decoration: none;
            display: inline-block;
            margin-bottom: 1rem;
        }
        
        .auth-logo .dot {
            color: var(--primary-500);
        }

        .auth-title {
            color: #111827;
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .auth-subtitle {
            color: #6b7280;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 0.875rem 1rem;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
            background: white;
        }

        .btn-submit {
            width: 100%;
            background: #10b981; /* Default Green */
            color: white;
            border: none;
            padding: 1rem;
            border-radius: 100px; /* Pill shape */
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.2);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.3);
            background: linear-gradient(135deg, #047857 0%, #059669 100%);
        }
        
        .patient-mode .btn-submit {
            background: linear-gradient(135deg, #0ea5e9, #2563eb);
            box-shadow: 0 10px 30px rgba(14, 165, 233, 0.4);
        }
        
        .patient-mode .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(14, 165, 233, 0.4);
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
            transition: color 0.2s;
        }

        .auth-link:hover {
            color: var(--primary-700);
            text-decoration: underline;
        }

        .error-message {
            background-color: #fef2f2;
            color: #ef4444;
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            border: 1px solid #fee2e2;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .role-selector {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: center;
        }

        .role-card {
            background: rgba(255,255,255,0.8);
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1rem;
            width: 100px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .role-card:hover {
            transform: translateY(-2px);
            border-color: var(--primary-500);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .role-card.active {
            background: #ecfdf5; /* Green tint for default */
            border-color: var(--primary-500);
            color: var(--primary-700);
        }
        
        .patient-mode .role-card.active {
            background: #e0f2fe;
            border-color: #0ea5e9;
            color: #0284c7;
            transform: scale(1.05); /* Slight pop */
            box-shadow: 0 8px 20px rgba(14, 165, 233, 0.15);
        }

        .role-icon {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .role-label {
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .patient-mode .auth-title { 
            color: #0f172a; 
        }

        /* Secretary/Nutri default to Green/Original */

    </style>
</head>
<body>
    <!-- Theme Layers -->
    <div id="theme-pro" class="theme-layer active">
        <div class="theme-bg"></div>
        <div class="theme-overlay"></div>
    </div>
    
    <div id="theme-patient" class="theme-layer">
        <div class="theme-bg"></div>
        <div class="theme-overlay"></div>
    </div>

    <nav class="navbar" style="position: absolute; top: 0; width: 100%; background: transparent; padding: 1.5rem 0; z-index: 20;">
      <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-logo" style="color: white; text-shadow: 0 2px 4px rgba(0,0,0,0.1);">
          Nutrit<span class="dot" style="color: #4ade80;">.</span>
        </a>
        <div class="nav-menu">
             <a href="${pageContext.request.contextPath}/" class="btn-secondary" style="background: rgba(255,255,255,0.2); border-color: rgba(255,255,255,0.4); color: white; backdrop-filter: blur(5px); padding: 0.5rem 1.25rem; font-size: 0.9rem;">
                <i class="fas fa-arrow-left"></i> Retour
             </a>
        </div>
      </div>
    </nav>

    <div class="auth-container" id="authContainer">
        <div class="auth-card">
            <div class="auth-header">
                <h1 class="auth-title" id="authTitle">Bon retour !</h1>
                <p class="auth-subtitle">Connectez-vous pour accéder à votre espace personnel</p>
            </div>

            <!-- Role Selection -->
            <div class="role-selector">
                <div class="role-card" onclick="selectRole('patient')">
                    <i class="fas fa-user-injured role-icon"></i>
                    <span class="role-label">Patient</span>
                </div>
                <div class="role-card active" onclick="selectRole('nutritionist')">
                    <i class="fas fa-user-md role-icon"></i>
                    <span class="role-label">Nutritionniste</span>
                </div>
                <div class="role-card" onclick="selectRole('secretary')">
                    <i class="fas fa-user-edit role-icon"></i>
                    <span class="role-label">Secrétaire</span>
                </div>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="error-message" style="background-color: #f0fdf4; color: #166534; border-color: #dcfce7;">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth/login" method="POST">
                <input type="hidden" name="role" id="selectedRole" value="nutritionist"> <!-- Default -->
                <div class="form-group">
                    <label for="email" class="form-label">Adresse e-mail</label>
                    <div style="position: relative;">
                        <input type="email" id="email" name="email" class="form-input" placeholder="exemple@email.com" required style="padding-left: 2.75rem;">
                        <i class="fas fa-envelope" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                    </div>
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                        <label for="password" class="form-label" style="margin-bottom: 0;">Mot de passe</label>
                        <a href="${pageContext.request.contextPath}/auth/forgot-password" class="auth-link" style="font-size: 0.875rem;">Mot de passe oublié ?</a>
                    </div>
                    <div style="position: relative;">
                        <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required style="padding-left: 2.75rem;">
                        <i class="fas fa-lock" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    Se connecter <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="auth-footer">
                Pas encore de compte ? 
                <a href="${pageContext.request.contextPath}/auth/register" class="auth-link">Créer un compte</a>
            </div>
        </div>
    </div>
    
    <script>
        function selectRole(role) {
            // Update UI cards
            document.querySelectorAll('.role-card').forEach(card => card.classList.remove('active'));
            event.currentTarget.classList.add('active');
            
            const container = document.getElementById('authContainer');
            const title = document.getElementById('authTitle');
            
            // Update Input
            document.getElementById('selectedRole').value = role;
            
            // Themes
            const themePro = document.getElementById('theme-pro');
            const themePatient = document.getElementById('theme-patient');
            
            if (role === 'patient') {
                container.classList.add('patient-mode');
                title.textContent = "Espace Patient";
                
                // Activate Patient Theme
                themePatient.classList.add('active');
                themePro.classList.remove('active');
            } else {
                container.classList.remove('patient-mode');
                
                if (role === 'nutritionist') {
                     title.textContent = "Espace Nutritionniste";
                } else {
                     title.textContent = "Espace Secrétaire";
                }
                
                // Activate Pro Theme
                themePro.classList.add('active');
                themePatient.classList.remove('active');
            }
        }
    </script>

</body>
</html>
