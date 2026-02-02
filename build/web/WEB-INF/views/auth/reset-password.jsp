<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réinitialiser le mot de passe - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        html, body {
            height: 100%;
            overflow: hidden;
            background: var(--gray-50);
        }

        .auth-form-panel {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
        }

        .auth-form-container {
            width: 100%;
            max-width: 450px;
        }

        .auth-card-glass {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: var(--radius-2xl);
            padding: 2.5rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-header .logo-icon {
            width: 60px;
            height: 60px;
            background: var(--gradient-primary);
            border-radius: var(--radius-xl);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 1.75rem;
        }

        .form-header h2 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: var(--gray-500);
            font-size: 0.9375rem;
        }

        .auth-form .form-group {
            margin-bottom: 1.25rem;
        }

        .auth-form .label {
            display: flex;
            align-items: center;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
        }

        .auth-form .label i {
            margin-right: 0.5rem;
            color: var(--gray-400);
        }

        .auth-form .input {
            width: 100%;
            padding: 0.875rem 1rem;
            background: white;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-lg);
            font-size: 0.9375rem;
            transition: all var(--transition-normal);
        }

        .auth-form .input:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
        }

        .auth-form .btn-submit {
            width: 100%;
            padding: 0.875rem 1.5rem;
            background: var(--gradient-primary);
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

        .auth-form .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(5, 150, 105, 0.3);
        }

        .auth-alert {
            padding: 0.875rem 1rem;
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            font-size: 0.875rem;
        }

        .auth-alert.error {
            background: var(--error-light);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #b91c1c;
        }

        .auth-alert.success {
            background: var(--success-light);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: #047857;
        }
    </style>
</head>

<body>
    <div class="auth-form-panel">
        <div class="auth-form-container">
            <div class="auth-card-glass">
                <div class="form-header">
                    <div class="logo-icon">
                        <i class="ph-fill ph-check-shield"></i>
                    </div>
                    <h2>Nouveau mot de passe</h2>
                    <p>Définissez un mot de passe sécurisé pour votre compte.</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="auth-alert error">
                        <i class="ph ph-warning-circle"></i>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth/reset-password" method="POST" class="auth-form">
                    <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
                    
                    <div class="form-group">
                        <label class="label" for="password">
                            <i class="ph ph-lock"></i>
                            Nouveau mot de passe
                        </label>
                        <input type="password" id="password" name="password" class="input" required
                            placeholder="Au moins 8 caractères" minlength="8">
                    </div>

                    <div class="form-group">
                        <label class="label" for="confirm_password">
                            <i class="ph ph-lock-key"></i>
                            Confirmer le mot de passe
                        </label>
                        <input type="password" id="confirm_password" name="confirm_password" class="input" required
                            placeholder="Répétez le mot de passe">
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="ph ph-shield-check"></i>
                        Réinitialiser le mot de passe
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const form = document.querySelector('form');
        const password = document.getElementById('password');
        const confirm = document.getElementById('confirm_password');

        form.onsubmit = (e) => {
            if (password.value !== confirm.value) {
                alert("Les mots de passe ne correspondent pas.");
                e.preventDefault();
            }
        };
    </script>
</body>

</html>
