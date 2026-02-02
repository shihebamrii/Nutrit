<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nutrit.models.Invoice" %>
<%@ page import="com.nutrit.models.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Facture - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5;
            --gray-900: #111827;
            --gray-600: #4B5563;
            --gray-200: #E5E7EB;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            color: var(--gray-900);
            line-height: 1.5;
            margin: 0;
            padding: 0;
            background: #fff;
        }

        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 3rem;
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 3rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--gray-200);
        }

        .brand-logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .invoice-title {
            text-align: right;
        }
        
        .invoice-title h1 {
            margin: 0;
            font-size: 2rem;
            color: var(--gray-900);
        }
        
        .invoice-details {
            display: flex;
            justify-content: space-between;
            margin-bottom: 3rem;
        }
        
        .bill-to h3, .bill-from h3 {
            font-size: 0.875rem;
            text-transform: uppercase;
            color: var(--gray-600);
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }
        
        .table th {
            text-align: left;
            padding: 0.75rem 1rem;
            background: var(--gray-200);
            font-weight: 600;
        }
        
        .table td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .total-section {
            display: flex;
            justify-content: flex-end;
        }
        
        .total-box {
            width: 300px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            font-weight: 500;
        }
        
        .total-grand {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary);
            border-top: 2px solid var(--gray-900);
            margin-top: 0.5rem;
            padding-top: 0.5rem;
        }

        .actions {
            margin-top: 4rem;
            text-align: center;
        }

        .btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 6px;
            font-family: inherit;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        @media print {
            .actions {
                display: none;
            }
            body {
                print-color-adjust: exact;
                -webkit-print-color-adjust: exact;
            }
            .invoice-container {
                padding: 0;
            }
        }
    </style>
</head>
<body>
    <% 
        Invoice invoice = (Invoice) request.getAttribute("invoice");
        Appointment appt = (Appointment) request.getAttribute("appointment");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy", java.util.Locale.FRENCH);
        java.util.Date invoiceDate = (invoice != null && invoice.getCreatedAt() != null) ? invoice.getCreatedAt() : new java.util.Date();
    %>

    <div class="invoice-container">
        <div class="invoice-header">
            <div class="brand">
                <div class="brand-logo">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12,2A10,10 0 1,0 22,12A10,10 0 0,0 12,2M12,20A8,8 0 1,1 20,12A8,8 0 0,1 12,20M12,4A8,8 0 0,1 20,12C20,14.54 18.81,17.43 14,19.92C9.19,17.43 8,14.54 8,12A4,4 0 0,1 12,8V4Z" />
                    </svg>
                    NUTRIT
                </div>
                <p style="color: var(--gray-600); margin: 0.5rem 0 0 0;">
                    123 Avenue de la Santé<br>
                    Tunis, Tunisie 1000
                </p>
            </div>
            <div class="invoice-title">
                <h1>FACTURE</h1>
                <p style="color: var(--gray-600); margin: 0.5rem 0 0 0;">
                    N° : <%= (invoice != null && invoice.getInvoiceNumber() != null) ? invoice.getInvoiceNumber() : "À VENIR" %><br>
                    Date : <%= dateFormat.format(invoiceDate) %>
                </p>
            </div>
        </div>

        <div class="invoice-details">
            <div class="bill-to">
                <h3>Facturé à :</h3>
                <p style="margin: 0; font-weight: 500;">
                    <%= appt.getPatientName() != null ? appt.getPatientName() : "Patient" %>
                </p>
            </div>
            <div class="bill-from">
                <h3>Fournisseur :</h3>
                <p style="margin: 0; font-weight: 500;">
                    <%= appt.getNutritionistName() != null ? appt.getNutritionistName() : "Dr. Nutritionniste" %>
                </p>
                <p style="margin: 0; color: var(--gray-600);">Nutritionniste Certifié</p>
            </div>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th style="width: 100px; text-align: center;">Durée</th>
                    <th style="width: 150px; text-align: right;">Montant</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <strong>Consultation Nutritionnelle</strong><br>
                        <span style="color: var(--gray-600); font-size: 0.875rem;">
                            Date : <%= dateFormat.format(appt.getScheduledTime()) %>
                        </span>
                    </td>
                    <td style="text-align: center;">0.5 h</td>
                    <td style="text-align: right;">
                        <%= invoice != null ? invoice.getAmount() : (appt.getPaymentAmount() != null ? appt.getPaymentAmount() : "50.00") %> DNT
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="total-section">
            <div class="total-box">
                <div class="total-row">
                    <span>Sous-total :</span>
                    <span><%= invoice != null ? invoice.getAmount() : (appt.getPaymentAmount() != null ? appt.getPaymentAmount() : "50.00") %> DNT</span>
                </div>
                <div class="total-row">
                    <span>TVA (0%) :</span>
                    <span>0.00 DNT</span>
                </div>
                <div class="total-row total-grand">
                    <span>Total :</span>
                    <span><%= invoice != null ? invoice.getAmount() : (appt.getPaymentAmount() != null ? appt.getPaymentAmount() : "50.00") %> DNT</span>
                </div>
            </div>
        </div>
        
        <div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid var(--gray-200);">
            <p style="color: var(--gray-600); font-size: 0.875rem;">
                <strong>Conditions de paiement :</strong> Paiement effectué par <%= invoice != null && "online".equals(invoice.getPaymentMethod()) ? "Paiement en ligne" : "Paiement sur place" %>.
                <br>Merci d'avoir choisi Nutrit pour votre parcours de santé.
            </p>
        </div>

        <div class="actions">
            <button class="btn" onclick="window.print()">Imprimer la facture</button>
            <button class="btn" style="background: transparent; color: var(--gray-600); border: 1px solid var(--gray-200); margin-left: 1rem;" 
                    onclick="window.history.back()">Retour</button>
        </div>
    </div>
</body>
</html>
