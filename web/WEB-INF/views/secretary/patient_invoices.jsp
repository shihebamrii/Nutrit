<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nutrit.models.Invoice" %>
<%@ page import="com.nutrit.models.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Factures Patient - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
</head>
<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />

            <div class="page-content">
                
                <% 
                    User patient = (User) request.getAttribute("patient");
                    List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
                    String error = (String) request.getAttribute("error");
                %>

                <div class="page-header">
                    <div>
                        <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 0.5rem;">
                            <a href="${pageContext.request.contextPath}/secretary/patients" class="btn-icon" style="background: white; border: 1px solid var(--border);">
                                <i class="ph ph-arrow-left"></i>
                            </a>
                            <h1>Factures : <%= patient != null ? patient.getFullName() : "Patient Inconnu" %></h1>
                        </div>
                        <p class="subtitle">Historique des paiements et factures pour ce patient.</p>
                    </div>
                </div>

                <% if(error != null) { %>
                    <div class="alert alert-error animate-fade-in">
                        <i class="ph ph-warning-circle"></i>
                        <%= error %>
                    </div>
                <% } %>

                <div class="card animate-fade-in" style="animation-delay: 0.1s;">
                    <% if(invoices == null || invoices.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="ph ph-receipt"></i>
                            </div>
                            <div class="empty-state-title">Aucune facture trouvée</div>
                            <div class="empty-state-text">Il n'y a pas encore de factures générées pour ce patient.</div>
                        </div>
                    <% } else { %>
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>N° Facture</th>
                                        <th>Date</th>
                                        <th>Montant</th>
                                        <th>Méthode de Paiement</th>
                                        <th>Statut</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        SimpleDateFormat dateFormat = new SimpleDateFormat("d MMM yyyy", java.util.Locale.FRENCH);
                                        for(Invoice inv : invoices) { 
                                    %>
                                    <tr>
                                        <td style="font-weight: 500;"><%= inv.getInvoiceNumber() %></td>
                                        <td style="color: var(--gray-600);"><%= inv.getCreatedAt() != null ? dateFormat.format(inv.getCreatedAt()) : "-" %></td>
                                        <td style="font-weight: 600;"><%= inv.getAmount() %> TND</td>
                                        <td style="text-transform: capitalize;"><%= inv.getPaymentMethod() != null ? ("online".equals(inv.getPaymentMethod()) ? "En ligne" : "Au cabinet") : "N/A" %></td>
                                        <td>
                                            <span class="status-badge <%= "paid".equals(inv.getPaymentStatus()) ? "complete" : "incomplete" %>">
                                                <%= "paid".equals(inv.getPaymentStatus()) ? "PAYÉ" : "NON PAYÉ" %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/secretary/invoice?appointmentId=<%= inv.getAppointmentId() %>" target="_blank" class="btn-outline btn-sm">
                                                <i class="ph ph-printer"></i> Imprimer
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
