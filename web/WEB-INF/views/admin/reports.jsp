<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nutrit.models.PostReport" %>
<%@ page import="com.nutrit.models.User" %>
<% 
    User currentUser = (User) session.getAttribute("user");
    List<PostReport> reports = (List<PostReport>) request.getAttribute("reports");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer reviewedCount = (Integer) request.getAttribute("reviewedCount");
    Integer dismissedCount = (Integer) request.getAttribute("dismissedCount");
    Integer actionTakenCount = (Integer) request.getAttribute("actionTakenCount");
    String currentFilter = (String) request.getAttribute("currentFilter");
%>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signalements de Posts - Admin - Nutrit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        .reports-page {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-box {
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            padding: 1.5rem;
            text-align: center;
        }
        
        .stat-box-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto 0.75rem;
        }
        
        .stat-box-icon.pending {
            background: var(--warning-light);
            color: var(--warning);
        }
        
        .stat-box-icon.reviewed {
            background: var(--info-light);
            color: var(--info);
        }
        
        .stat-box-icon.dismissed {
            background: var(--gray-100);
            color: var(--gray-500);
        }
        
        .stat-box-icon.action {
            background: var(--success-light);
            color: var(--success);
        }
        
        .stat-box-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        
        .stat-box-label {
            font-size: 0.875rem;
            color: var(--gray-500);
        }
        
        .filter-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            background: var(--card);
            padding: 0.5rem;
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
        }
        
        .filter-tab {
            padding: 0.75rem 1.25rem;
            border: none;
            background: none;
            border-radius: var(--radius-lg);
            font-weight: 500;
            color: var(--gray-500);
            cursor: pointer;
            transition: all var(--transition-fast);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .filter-tab:hover {
            color: var(--gray-700);
        }
        
        .filter-tab.active {
            background: var(--primary);
            color: white;
        }
        
        .filter-tab .badge {
            background: rgba(255,255,255,0.2);
            padding: 0.125rem 0.5rem;
            border-radius: var(--radius-full);
            font-size: 0.75rem;
        }
        
        .filter-tab:not(.active) .badge {
            background: var(--gray-200);
            color: var(--gray-600);
        }
        
        .reports-table {
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            overflow: hidden;
        }
        
        .reports-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .reports-table th,
        .reports-table td {
            padding: 1rem 1.25rem;
            text-align: left;
            border-bottom: 1px solid var(--gray-100);
        }
        
        .reports-table th {
            background: var(--gray-50);
            font-weight: 600;
            color: var(--gray-700);
            font-size: 0.8125rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .reports-table tr:last-child td {
            border-bottom: none;
        }
        
        .reports-table tr:hover td {
            background: var(--gray-50);
        }
        
        .post-preview {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: var(--gray-600);
        }
        
        .reason-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: var(--radius-full);
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .reason-badge.spam {
            background: #fef3c7;
            color: #92400e;
        }
        
        .reason-badge.harassment {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .reason-badge.inappropriate {
            background: #fce7f3;
            color: #9d174d;
        }
        
        .reason-badge.misinformation {
            background: #ede9fe;
            color: #5b21b6;
        }
        
        .reason-badge.other {
            background: var(--gray-100);
            color: var(--gray-600);
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: var(--radius-full);
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .status-badge.pending {
            background: var(--warning-light);
            color: #92400e;
        }
        
        .status-badge.reviewed {
            background: var(--info-light);
            color: #0e7490;
        }
        
        .status-badge.dismissed {
            background: var(--gray-100);
            color: var(--gray-600);
        }
        
        .status-badge.action_taken {
            background: var(--success-light);
            color: #047857;
        }
        
        .action-btns {
            display: flex;
            gap: 0.5rem;
        }
        
        .action-btn {
            padding: 0.375rem 0.75rem;
            border: none;
            border-radius: var(--radius-md);
            font-size: 0.75rem;
            font-weight: 500;
            cursor: pointer;
            transition: all var(--transition-fast);
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }
        
        .action-btn.dismiss {
            background: var(--gray-100);
            color: var(--gray-600);
        }
        
        .action-btn.dismiss:hover {
            background: var(--gray-200);
        }
        
        .action-btn.delete {
            background: var(--error-light);
            color: var(--error);
        }
        
        .action-btn.delete:hover {
            background: #fecaca;
        }
        
        .action-btn.review {
            background: var(--info-light);
            color: var(--info);
        }
        
        .action-btn.review:hover {
            background: #a5f3fc;
        }
        
        .empty-reports {
            padding: 3rem;
            text-align: center;
            color: var(--gray-500);
        }
        
        .empty-reports i {
            font-size: 3rem;
            color: var(--gray-300);
            margin-bottom: 1rem;
        }
        
        .reporter-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .reporter-avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.625rem;
            font-weight: 600;
        }
        
        .time-ago {
            font-size: 0.75rem;
            color: var(--gray-400);
        }
    </style>
</head>

<body>
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />
            <div class="page-content">
                <div class="reports-page">
                    <div class="page-header">
                        <h1><i class="ph ph-flag"></i> Signalements de Posts</h1>
                        <p>Examiner et modérer les signalements de contenu de la communauté</p>
                    </div>
                    
                    <div class="stats-row">
                        <div class="stat-box animate-fade-in">
                            <div class="stat-box-icon pending">
                                <i class="ph ph-clock"></i>
                            </div>
                            <div class="stat-box-value"><%= pendingCount != null ? pendingCount : 0 %></div>
                            <div class="stat-box-label">En attente</div>
                        </div>
                        <div class="stat-box animate-fade-in">
                            <div class="stat-box-icon reviewed">
                                <i class="ph ph-eye"></i>
                            </div>
                            <div class="stat-box-value"><%= reviewedCount != null ? reviewedCount : 0 %></div>
                            <div class="stat-box-label">Révisés</div>
                        </div>
                        <div class="stat-box animate-fade-in">
                            <div class="stat-box-icon dismissed">
                                <i class="ph ph-x-circle"></i>
                            </div>
                            <div class="stat-box-value"><%= dismissedCount != null ? dismissedCount : 0 %></div>
                            <div class="stat-box-label">Rejetés</div>
                        </div>
                        <div class="stat-box animate-fade-in">
                            <div class="stat-box-icon action">
                                <i class="ph ph-check-circle"></i>
                            </div>
                            <div class="stat-box-value"><%= actionTakenCount != null ? actionTakenCount : 0 %></div>
                            <div class="stat-box-label">Actions prises</div>
                        </div>
                    </div>
                    
                    <div class="filter-tabs">
                        <a href="${pageContext.request.contextPath}/admin/reports" 
                           class="filter-tab <%= "all".equals(currentFilter) || currentFilter == null ? "active" : "" %>">
                            Tous les signalements
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/reports?filter=pending" 
                           class="filter-tab <%= "pending".equals(currentFilter) ? "active" : "" %>">
                            En attente
                            <span class="badge"><%= pendingCount != null ? pendingCount : 0 %></span>
                        </a>
                    </div>
                    
                    <div class="reports-table animate-fade-in">
                        <% if (reports != null && !reports.isEmpty()) { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Signalé par</th>
                                    <th>Contenu du Post</th>
                                    <th>Auteur du Post</th>
                                    <th>Raison</th>
                                    <th>Statut</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (PostReport report : reports) {
                                    String reporterName = report.getReporterName() != null ? report.getReporterName() : "Unknown";
                                    String[] names = reporterName.split(" ");
                                    String initials = names[0].substring(0, 1);
                                    if (names.length > 1) initials += names[names.length - 1].substring(0, 1);
                                %>
                                <tr id="report-row-<%= report.getId() %>">
                                    <td>
                                        <div class="reporter-info">
                                            <div class="reporter-avatar"><%= initials.toUpperCase() %></div>
                                            <span><%= reporterName %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="post-preview" title="<%= report.getPostContent() %>">
                                            <%= report.getPostContent() %>
                                        </div>
                                    </td>
                                    <td><%= report.getPostAuthorName() %></td>
                                    <td>
                                        <span class="reason-badge <%= report.getReason() %>">
                                            <%= report.getReasonDisplay() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge <%= report.getStatus() %>" id="status-<%= report.getId() %>">
                                            <%= report.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="time-ago"><%= report.getCreatedAt() %></span>
                                    </td>
                                    <td>
                                        <% if ("pending".equals(report.getStatus())) { %>
                                        <div class="action-btns">
                                            <button class="action-btn dismiss" 
                                                    onclick="reviewReport(<%= report.getId() %>, <%= report.getPostId() %>, 'dismiss')"
                                                    title="Rejeter ce signalement">
                                                <i class="ph ph-x"></i> Ignorer
                                            </button>
                                            <button class="action-btn delete" 
                                                    onclick="reviewReport(<%= report.getId() %>, <%= report.getPostId() %>, 'delete')"
                                                    title="Supprimer le post et prendre des mesures">
                                                <i class="ph ph-trash"></i> Supprimer le Post
                                            </button>
                                        </div>
                                        <% } else { %>
                                        <span style="color: var(--gray-400); font-size: 0.875rem;">Traité</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <% } else { %>
                        <div class="empty-reports">
                            <i class="ph ph-check-circle"></i>
                            <h3>Aucun Signalement</h3>
                            <p>Il n'y a aucun signalement à examiner pour le moment.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        var contextPath = '<%= request.getContextPath() %>';
        
        function reviewReport(reportId, postId, action) {
            var confirmMsg = action === 'delete' 
                ? 'Êtes-vous sûr de vouloir supprimer ce post ? Cette action est irréversible.'
                : 'Êtes-vous sûr de vouloir rejeter ce signalement ?';
            
            if (!confirm(confirmMsg)) return;
            
            fetch(contextPath + '/admin/reports/review', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'reportId=' + reportId + '&postId=' + postId + '&action=' + action
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    // Update the status badge
                    var statusSpan = document.getElementById('status-' + reportId);
                    statusSpan.className = 'status-badge ' + data.status;
                    statusSpan.textContent = data.status;
                    
                    var row = document.getElementById('report-row-' + reportId);
                    var actionsCell = row.querySelector('td:last-child');
                    actionsCell.innerHTML = '<span style="color: var(--gray-400); font-size: 0.875rem;">Traité</span>';
                    
                    // Update counts (refresh page for simplicity)
                    location.reload();
                } else {
                    alert(data.error || 'Échec du traitement du signalement');
                }
            })
            .catch(function(error) {
                alert('Erreur lors du traitement du signalement');
            });
        }
    </script>
</body>

</html>
