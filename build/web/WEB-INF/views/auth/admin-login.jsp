<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration - Nutrit</title>
    <meta name="description" content="Portail d'administration Nutrit - Accès réservé aux administrateurs.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .admin-auth-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
            position: relative;
            overflow: hidden;
        }

        .admin-auth-page::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 30% 30%, rgba(5, 150, 105, 0.08) 0%, transparent 50%),
                        radial-gradient(circle at 70% 70%, rgba(13, 148, 136, 0.06) 0%, transparent 50%);
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(2%, 2%) rotate(2deg); }
        }

        .admin-auth-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 420px;
            padding: 2rem;
        }

        .admin-auth-card {
            background: rgba(30, 41, 59, 0.8);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: var(--radius-2xl);
            padding: 2.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        .admin-logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .admin-logo .shield-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #059669 0%, #0d9488 100%);
            border-radius: var(--radius-xl);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 32px rgba(5, 150, 105, 0.3);
        }

        .admin-logo .shield-icon i {
            font-size: 2rem;
            color: white;
        }

        .admin-logo h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #f1f5f9;
            margin-bottom: 0.5rem;
        }

        .admin-logo .subtitle {
            font-size: 0.875rem;
            color: #94a3b8;
        }

        .admin-form .form-group {
            margin-bottom: 1.25rem;
        }

        .admin-form .label {
            display: flex;
            align-items: center;
            font-size: 0.875rem;
            font-weight: 500;
            color: #cbd5e1;
            margin-bottom: 0.5rem;
        }

        .admin-form .label i {
            margin-right: 0.5rem;
            color: #64748b;
        }

        .admin-form .input {
            width: 100%;
            padding: 0.875rem 1rem;
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: var(--radius-lg);
            color: #f1f5f9;
            font-size: 0.9375rem;
            transition: all var(--transition-normal);
        }

        .admin-form .input::placeholder {
            color: #64748b;
        }

        .admin-form .input:focus {
            outline: none;
            border-color: #059669;
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.2);
        }

        .admin-form .btn-admin {
            width: 100%;
            padding: 0.875rem 1.5rem;
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: white;
            font-weight: 600;
            font-size: 0.9375rem;
            border: none;
            border-radius: var(--radius-lg);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all var(--transition-normal);
            margin-top: 1.5rem;
        }

        .admin-form .btn-admin:hover {
            background: linear-gradient(135deg, #047857 0%, #065f46 100%);
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(5, 150, 105, 0.3);
        }

        .admin-form .btn-admin:active {
            transform: translateY(0);
        }

        .admin-alert {
            padding: 0.875rem 1rem;
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            font-size: 0.875rem;
        }

        .admin-alert.error {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5;
        }

        .admin-alert.success {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #6ee7b7;
        }

        .admin-alert i {
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .admin-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .admin-footer a {
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.875rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: color var(--transition-normal);
        }

        .admin-footer a:hover {
            color: #059669;
        }

        /* Subtle grid pattern overlay */
        .grid-pattern {
            position: absolute;
            inset: 0;
            background-image: 
                linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
            background-size: 50px 50px;
            pointer-events: none;
        }
    </style>
</head>

<body class="admin-auth-page">
    <div class="grid-pattern"></div>
    
    <div class="admin-auth-container animate-fade-in">
        <div class="admin-auth-card">
            <div class="admin-logo">
                <div class="shield-icon">
                    <i class="ph-fill ph-shield-check"></i>
                </div>
                <h1>Administration</h1>
                <p class="subtitle">Portail sécurisé - Accès réservé</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="admin-alert error">
                    <i class="ph ph-warning-circle"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="admin-alert success">
                    <i class="ph ph-check-circle"></i>
                    <span><%= request.getAttribute("success") %></span>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth/admin/login" method="POST" class="admin-form">
                <div class="form-group">
                    <label class="label" for="email">
                        <i class="ph ph-envelope"></i>
                        Adresse e-mail
                    </label>
                    <input type="email" id="email" name="email" class="input" required
                        placeholder="admin@nutrit.com" autocomplete="email">
                </div>

                <div class="form-group">
                    <label class="label" for="password">
                        <i class="ph ph-lock"></i>
                        Mot de passe
                    </label>
                    <input type="password" id="password" name="password" class="input" required
                        placeholder="Entrez votre mot de passe" autocomplete="current-password">
                </div>

                <button type="submit" class="btn-admin">
                    <i class="ph ph-sign-in"></i>
                    Connexion sécurisée
                </button>
            </form>

            <div class="admin-footer">
                <a href="${pageContext.request.contextPath}/auth/login">
                    <i class="ph ph-arrow-left"></i>
                    Retour au portail utilisateur
                </a>
            </div>
        </div>
    </div>
</body>

</html>
