<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.User" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Patients - Secrétariat Nutrit</title>
                <meta name="description" content="Consultez et gérez les patients du nutritionniste, prenez des rendez-vous.">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <script src="https://unpkg.com/@phosphor-icons/web"></script>
                <style>
                    .modal-overlay {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.5);
                        backdrop-filter: blur(4px);
                        z-index: 1000;
                        justify-content: center;
                        align-items: center;
                        animation: fadeIn 0.2s ease;
                    }

                    .modal-content {
                        background: var(--card);
                        border-radius: var(--radius-xl);
                        width: 100%;
                        max-width: 480px;
                        max-height: 90vh;
                        overflow-y: auto;
                        box-shadow: var(--shadow-xl);
                        animation: slideUp 0.3s ease;
                    }

                    .modal-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 1.5rem 1.5rem 0 1.5rem;
                    }

                    .modal-header h3 {
                        font-size: 1.25rem;
                        margin: 0;
                    }

                    .modal-close {
                        background: var(--gray-100);
                        border: none;
                        width: 36px;
                        height: 36px;
                        border-radius: 50%;
                        font-size: 1.25rem;
                        cursor: pointer;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--gray-500);
                        transition: all var(--transition-fast);
                    }

                    .modal-close:hover {
                        background: var(--gray-200);
                        color: var(--gray-700);
                    }

                    .modal-body {
                        padding: 1.5rem;
                    }

                    .patient-banner {
                        background: linear-gradient(135deg, var(--primary-50), var(--primary-100));
                        border: 1px solid var(--primary-200);
                        border-radius: var(--radius-lg);
                        padding: 1rem 1.25rem;
                        margin-bottom: 1.5rem;
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                    }

                    .patient-banner i {
                        color: var(--primary-600);
                        font-size: 1.5rem;
                    }

                    .patient-banner span {
                        color: var(--primary-700);
                        font-weight: 600;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                        }

                        to {
                            opacity: 1;
                        }
                    }

                    @keyframes slideUp {
                        from {
                            transform: translateY(20px);
                            opacity: 0;
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="flex">
                    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

                    <main class="main-content">
                        <jsp:include page="/WEB-INF/views/common/header.jsp" />

                        <div class="page-content">
                            <!-- Page Header -->
                            <div class="page-header flex items-center justify-between">
                                <div>
                                    <h1>Patients du Nutritionniste</h1>
                                    <p>Consultez la liste des patients et prenez des rendez-vous.</p>
                                </div>
                                <div class="badge badge-primary" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                    <i class="ph ph-users mr-2"></i>
                                    <%= (request.getAttribute("patients") !=null) ?
                                        ((List)request.getAttribute("patients")).size() : 0 %> Patients
                                </div>
                            </div>

                            <!-- Patients Table Card -->
                            <div class="card animate-fade-in">
                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Patient</th>
                                                <th>Contact</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% List<User> patients = (List<User>) request.getAttribute("patients");
                                                    if (patients != null && !patients.isEmpty()) {
                                                    for(User p : patients) {
                                                    String[] names = p.getFullName().split(" ");
                                                    String initials = names[0].substring(0, 1);
                                                    if (names.length > 1) initials += names[names.length -
                                                    1].substring(0, 1);
                                                    %>
                                                    <tr>
                                                        <td>
                                                            <div class="flex items-center gap-3">
                                                                <div
                                                                    style="width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, #FEE2E2, #FEF2F2); display: flex; align-items: center; justify-content: center; color: #DC2626; font-weight: 600; font-size: 0.875rem; flex-shrink: 0;">
                                                                    <%= initials.toUpperCase() %>
                                                                </div>
                                                                <div>
                                                                    <div style="font-weight: 600;">
                                                                        <%= p.getFullName() %>
                                                                    </div>
                                                                    <div class="text-sm text-gray">
                                                                        <i class="ph ph-calendar mr-1"></i>
                                                                        Depuis le <%= p.getCreatedAt() %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="flex flex-col gap-1">
                                                                <div class="flex items-center gap-2">
                                                                    <i class="ph ph-envelope text-gray"></i>
                                                                    <span>
                                                                        <%= p.getEmail() %>
                                                                    </span>
                                                                </div>
                                                                <% if (p.getPhone() !=null && !p.getPhone().isEmpty()) {
                                                                    %>
                                                                    <div class="flex items-center gap-2">
                                                                        <i class="ph ph-phone text-gray"></i>
                                                                        <span class="text-sm text-gray">
                                                                            <%= p.getPhone() %>
                                                                        </span>
                                                                    </div>
                                                                    <% } %>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <button
                                                                onclick="openBookingModal('<%= p.getId() %>', '<%= p.getFullName() %>')"
                                                                class="btn btn-primary btn-sm">
                                                                <i class="ph ph-calendar-plus"></i>
                                                                Prendre RDV
                                                            </button>
                                                            <a href="${pageContext.request.contextPath}/secretary/patientInvoices?patientId=<%= p.getId() %>" 
                                                               class="btn btn-outline btn-sm" title="Voir les factures">
                                                                <i class="ph ph-receipt"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                    <% } } else { %>
                                                        <tr>
                                                            <td colspan="3">
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <i class="ph ph-user-circle-minus"></i>
                                                                    </div>
                                                                    <div class="empty-state-title">Aucun Patient Trouvé
                                                                    </div>
                                                                    <div class="empty-state-text">Il n'y a pas encore de patients actifs pour ce nutritionniste.</div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <!-- Booking Modal -->
                <div id="bookingModal" class="modal-overlay">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3>
                                <i class="ph ph-calendar-plus mr-2" style="color: var(--primary);"></i>
                                Prendre un Rendez-vous
                            </h3>
                            <button onclick="closeBookingModal()" class="modal-close">
                                <i class="ph ph-x"></i>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="patient-banner">
                                <i class="ph ph-user-circle"></i>
                                <span id="patientNameDisplay">Patient</span>
                            </div>

                            <form action="${pageContext.request.contextPath}/secretary/bookAppointment" method="POST">
                                <input type="hidden" name="source" value="patients">
                                <input type="hidden" name="patientId" id="modalPatientId">

                                <div class="form-grid">
                                    <div class="form-group">
                                        <label class="label">
                                            <i class="ph ph-calendar mr-1"></i>
                                            Date
                                        </label>
                                        <input type="date" name="date" class="input" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="label">
                                            <i class="ph ph-clock mr-1"></i>
                                            Heure
                                        </label>
                                        <input type="time" name="time" class="input" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="label">
                                        <i class="ph ph-note-pencil mr-1"></i>
                                        Raison / Notes
                                    </label>
                                    <textarea name="reason" class="input" rows="3"
                                        placeholder="Optionnel : Ajouter une raison de visite..."></textarea>
                                </div>

                                <div class="flex justify-end gap-3 mt-4">
                                    <button type="button" onclick="closeBookingModal()" class="btn btn-secondary">
                                        Annuler
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="ph ph-check-circle"></i>
                                        Confirmer le RDV
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    function openBookingModal(id, name) {
                        document.getElementById('modalPatientId').value = id;
                        document.getElementById('patientNameDisplay').textContent = name;
                        document.getElementById('bookingModal').style.display = "flex";
                    }

                    function closeBookingModal() {
                        document.getElementById('bookingModal').style.display = "none";
                    }

                    // Close on outside click
                    window.onclick = function (event) {
                        var modal = document.getElementById('bookingModal');
                        if (event.target == modal) {
                            closeBookingModal();
                        }
                    }

                    // Close on escape key
                    document.addEventListener('keydown', function (event) {
                        if (event.key === 'Escape') {
                            closeBookingModal();
                        }
                    });
                </script>
            </body>

            </html>