<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Payment - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .payment-container {
            max-width: 500px;
            margin: 2rem auto;
            background: white;
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
        }

        .payment-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            color: white;
            text-align: center;
        }

        .payment-body {
            padding: 2rem;
        }

        .card-preview {
            background: linear-gradient(135deg, #1e293b, #0f172a);
            border-radius: 12px;
            padding: 1.5rem;
            color: white;
            margin-bottom: 2rem;
            position: relative;
            box-shadow: var(--shadow-md);
        }

        .card-chip {
            width: 40px;
            height: 30px;
            background: linear-gradient(135deg, #fbbf24, #d97706);
            border-radius: 4px;
            margin-bottom: 1rem;
        }

        .card-number-display {
            font-family: 'Courier New', monospace;
            font-size: 1.25rem;
            letter-spacing: 2px;
            margin-bottom: 1rem;
        }

        .card-details-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.875rem;
            opacity: 0.8;
        }

        .expiry-display {
            text-align: center;
        }

        .order-summary {
            background: var(--gray-50);
            padding: 1rem;
            border-radius: var(--radius-lg);
            margin-bottom: 1.5rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            margin-top: 1rem;
            padding-top: 0.5rem;
            border-top: 1px solid var(--gray-200);
            font-weight: 700;
            font-size: 1.125rem;
            color: var(--gray-900);
        }

        .cc-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .processing-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            display: none;
        }

        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid var(--gray-200);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 1rem;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body style="background-color: var(--gray-50);">

    <div class="processing-overlay" id="processingOverlay">
        <div class="spinner"></div>
        <h3>Processing Payment...</h3>
        <p style="color: var(--gray-600);">Please do not refresh the page.</p>
    </div>

    <div class="payment-container">
        <div class="payment-header">
            <i class="ph ph-lock-key" style="font-size: 2rem; margin-bottom: 0.5rem;"></i>
            <h2>Secure Checkout</h2>
            <p style="opacity: 0.9;">Nutrit Secure Payment Gateway</p>
        </div>

        <div class="payment-body">
            <% 
                String amount = (String) request.getAttribute("amount");
                String slot = (String) request.getAttribute("slot");
                String notes = (String) request.getAttribute("notes");
                // Convert timestamp string to readable format
                SimpleDateFormat inFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                SimpleDateFormat outFormat = new SimpleDateFormat("EEEE, MMM dd, yyyy 'at' HH:mm");
                String formattedDate = slot;
                try {
                    formattedDate = outFormat.format(inFormat.parse(slot));
                } catch(Exception e) {}
            %>

            <div class="order-summary">
                <div class="summary-row">
                    <span>Service</span>
                    <span>Nutrition Consultation</span>
                </div>
                <div class="summary-row">
                    <span>Date & Time</span>
                    <span><%= formattedDate %></span>
                </div>
                <div class="summary-total">
                    <span>Total Amount</span>
                    <span><%= amount %> DNT</span>
                </div>
            </div>

            <div class="card-preview">
                <div class="card-chip"></div>
                <div class="card-number-display" id="displayCard">•••• •••• •••• ••••</div>
                <div class="card-details-row">
                    <span id="displayName">CARD HOLDER</span>
                    <span class="expiry-display" id="displayExpiry">MM/YY</span>
                </div>
                <i class="ph ph-visa-logo" style="position: absolute; bottom: 1.5rem; right: 1.5rem; font-size: 2rem;"></i>
            </div>

            <form action="${pageContext.request.contextPath}/patient/processPayment" method="POST" id="paymentForm" onsubmit="return processPayment(event)">
                <input type="hidden" name="amount" value="<%= amount %>">
                <input type="hidden" name="slot" value="<%= slot %>">
                <input type="hidden" name="notes" value="<%= notes %>">
                <input type="hidden" name="cardLastFour" id="cardLastFour">
                <input type="hidden" name="transactionRef" id="transactionRef">

                <div class="form-group">
                    <label class="label">Card Number</label>
                    <div class="input-group">
                        <span class="input-icon"><i class="ph ph-credit-card"></i></span>
                        <input type="text" class="input" id="cardNumber" placeholder="0000 0000 0000 0000" maxlength="19" required oninput="formatCardNumber(this)">
                    </div>
                </div>

                <div class="cc-grid">
                    <div class="form-group">
                        <label class="label">Expiry Date</label>
                        <input type="text" class="input" id="expiry" placeholder="MM/YY" maxlength="5" required oninput="formatExpiry(this)">
                    </div>
                    <div class="form-group">
                        <label class="label">CVV</label>
                        <div class="input-group">
                            <span class="input-icon"><i class="ph ph-lock"></i></span>
                            <input type="text" class="input" placeholder="123" maxlength="3" required pattern="\d{3}">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="label">Cardholder Name</label>
                    <input type="text" class="input" id="cardName" placeholder="John Doe" required oninput="updateName(this)">
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="width: 100%; margin-top: 1rem;">
                    Pay <%= amount %> DNT
                </button>
                
                <div style="text-align: center; margin-top: 1rem;">
                    <button type="button" onclick="history.back()" style="background: none; border: none; color: var(--gray-500); cursor: pointer; text-decoration: underline;">
                        Cancel Payment
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function formatCardNumber(input) {
            let value = input.value.replace(/\D/g, '');
            let formatted = '';
            for (let i = 0; i < value.length; i++) {
                if (i > 0 && i % 4 === 0) formatted += ' ';
                formatted += value[i];
            }
            input.value = formatted;
            document.getElementById('displayCard').textContent = formatted || '•••• •••• •••• ••••';
        }

        function formatExpiry(input) {
            let value = input.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.slice(0, 2) + '/' + value.slice(2, 4);
            }
            input.value = value;
            document.getElementById('displayExpiry').textContent = value || 'MM/YY';
        }

        function updateName(input) {
            document.getElementById('displayName').textContent = input.value.toUpperCase() || 'CARD HOLDER';
        }

        function processPayment(e) {
            e.preventDefault();
            
            // Basic validation simulated
            const cardNum = document.getElementById('cardNumber').value.replace(/\s/g, '');
            if (cardNum.length < 16) {
                alert('Invalid card number');
                return false;
            }

            // Set hidden fields
            document.getElementById('cardLastFour').value = cardNum.slice(-4);
            document.getElementById('transactionRef').value = 'TXN-' + Date.now() + '-' + Math.floor(Math.random() * 1000);

            // Show processing
            document.getElementById('processingOverlay').style.display = 'flex';

            // Simulate network delay
            setTimeout(() => {
                document.getElementById('paymentForm').submit();
            }, 2000);
            
            return false;
        }
    </script>
</body>
</html>
