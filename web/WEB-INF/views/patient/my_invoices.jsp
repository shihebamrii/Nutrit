<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nutrit.models.Invoice" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Invoices - Nutrit</title>
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
                <div class="page-header">
                    <div>
                        <h1>Mes factures</h1>
                        <p class="subtitle">Consultez et téléchargez votre historique de paiement.</p>
                    </div>
                </div>

                <% 
                    List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
                    String error = (String) request.getAttribute("error");
                %>

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
                            <div class="empty-state-title">Aucune facture pour le moment</div>
                            <div class="empty-state-text">Vous n'avez pas encore effectué de paiement. Les factures apparaîtront ici une fois que vous aurez effectué un paiement.</div>
                        </div>
                    <% } else { %>
                        <div style="overflow-x: auto;">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>N° Facture</th>
                                        <th>Date</th>
                                        <th>Montant</th>
                                        <th>Moyen de paiement</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy", java.util.Locale.FRENCH);
                                        for(Invoice inv : invoices) { 
                                            String statusClass = "badge-subtle-warning";
                                            String statusText = "En attente";
                                            
                                            // Handle status translation and coloring
                                            if ("completed".equalsIgnoreCase(inv.getPaymentStatus()) || "paid".equalsIgnoreCase(inv.getPaymentStatus()) || "paye".equalsIgnoreCase(inv.getPaymentStatus())) {
                                                statusClass = "badge-subtle-success";
                                                statusText = "Payé";
                                            } else if ("failed".equalsIgnoreCase(inv.getPaymentStatus()) || "echoue".equalsIgnoreCase(inv.getPaymentStatus())) {
                                                statusClass = "badge-subtle-danger";
                                                statusText = "Échoué";
                                            }
                                            
                                            String paymentMethod = inv.getPaymentMethod();
                                            if (paymentMethod != null) {
                                                if (paymentMethod.equals("online") || paymentMethod.equals("en_ligne")) paymentMethod = "En ligne";
                                                else if (paymentMethod.equals("in_office") || paymentMethod.equals("au_cabinet")) paymentMethod = "Sur place";
                                                else paymentMethod = paymentMethod.replace("_", " ");
                                            } else {
                                                paymentMethod = "-";
                                            }
                                            
                                            String invoiceNum = inv.getInvoiceNumber();
                                            if (invoiceNum == null || invoiceNum.isEmpty()) {
                                                invoiceNum = "<em>À venir</em>";
                                            }
                                    %>
                                    <tr>
                                        <td style="font-weight: 500;"><%= invoiceNum %></td>
                                        <td style="color: var(--gray-600);"><%= inv.getCreatedAt() != null ? dateFormat.format(inv.getCreatedAt()) : "-" %></td>
                                        <td style="font-weight: 600;"><%= inv.getAmount() != null ? inv.getAmount() : "0.00" %> DNT</td>
                                        <td style="text-transform: capitalize;"><%= paymentMethod %></td>
                                        <td>
                                            <span class="badge <%= statusClass %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/patient/invoice?appointmentId=<%= inv.getAppointmentId() %>" class="btn-outline btn-sm">
                                                <i class="ph ph-eye"></i> <%= (inv.getInvoiceNumber() != null) ? "Voir" : "Détails" %>
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
