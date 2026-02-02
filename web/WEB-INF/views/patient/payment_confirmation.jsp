<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.Payment" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Confirmation - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .confirmation-container {
            max-width: 600px;
            margin: 4rem auto;
            text-align: center;
            padding: 2rem;
        }

        .status-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            font-size: 3rem;
        }

        .status-success {
            background: var(--success-50);
            color: var(--success);
        }

        .status-error {
            background: var(--error-50);
            color: var(--error);
        }

        .receipt-card {
            background: white;
            border-radius: var(--radius-xl);
            padding: 2rem;
            box-shadow: var(--shadow-md);
            margin: 2rem 0;
            text-align: left;
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid var(--gray-100);
        }

        .receipt-row:last-child {
            border-bottom: none;
        }

        .receipt-label {
            color: var(--gray-600);
        }

        .receipt-value {
            font-weight: 600;
            color: var(--gray-900);
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <% 
            boolean isSuccess = (Boolean) request.getAttribute("success"); 
            Payment payment = (Payment) request.getAttribute("payment");
        %>

        <% if (isSuccess) { %>
            <div class="status-icon status-success">
                <i class="ph ph-check"></i>
            </div>
            <h1>Payment Successful!</h1>
            <p style="color: var(--gray-600); font-size: 1.125rem;">
                Your appointment request has been submitted successfully to the secretary.
            </p>

            <div class="receipt-card">
                <h3>Transaction Receipt</h3>
                <div class="receipt-row">
                    <span class="receipt-label">Transaction ID</span>
                    <span class="receipt-value"><%= payment.getTransactionRef() %></span>
                </div>
                <div class="receipt-row">
                    <span class="receipt-label">Amount Paid</span>
                    <span class="receipt-value"><%= payment.getAmount() %> DNT</span>
                </div>
                <div class="receipt-row">
                    <span class="receipt-label">Payment Method</span>
                    <span class="receipt-value">Credit Card ending in •••• <%= payment.getCardLastFour() %></span>
                </div>
                <div class="receipt-row">
                    <span class="receipt-label">Status</span>
                    <span class="receipt-value" style="color: var(--success);">Paid</span>
                </div>
                <div class="receipt-row">
                    <span class="receipt-label">Date</span>
                    <span class="receipt-value"><%= payment.getCompletedAt() %></span>
                </div>
            </div>

            <div style="display: flex; gap: 1rem; justify-content: center;">
                <a href="${pageContext.request.contextPath}/patient/appointments" class="btn btn-primary">
                    View My Appointments
                </a>
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-outline">
                    Return to Dashboard
                </a>
            </div>

        <% } else { %>
            <div class="status-icon status-error">
                <i class="ph ph-x"></i>
            </div>
            <h1>Payment Failed</h1>
            <p style="color: var(--gray-600); font-size: 1.125rem;">
                There was an issue processing your payment. Please try again.
            </p>

            <div style="margin-top: 2rem;">
                <a href="javascript:history.back()" class="btn btn-primary">
                    Try Again
                </a>
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-outline" style="margin-left: 1rem;">
                    Return to Dashboard
                </a>
            </div>
        <% } %>
    </div>
</body>
</html>
