<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.nutrit.models.ChatMessage" %>
            <%@ page import="com.nutrit.models.User" %>
                <!DOCTYPE html>
                <html lang="fr">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Messages - Nutrit</title>
                    <meta name="description"
                        content="Discutez avec votre nutritionniste ou vos patients en toute sécurité sur la plateforme Nutrit.">
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                    <script src="https://unpkg.com/@phosphor-icons/web"></script>
                </head>

                <body>
    <style>
        .chat-layout {
            display: flex;
            height: calc(100vh - 140px);
            min-height: 500px;
            background: var(--card);
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            overflow: hidden;
            margin: 1rem;
        }

        .chat-sidebar {
            width: 300px;
            border-right: 1px solid var(--gray-100);
            display: flex;
            flex-direction: column;
            background: #fff;
        }

        .chat-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #fff;
        }

        .contacts-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-100);
        }

        .contacts-list {
            flex: 1;
            overflow-y: auto;
            padding: 1rem 0;
        }

        .contacts-category {
            padding: 0.5rem 1.5rem;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--gray-500);
            text-transform: uppercase;
            margin-top: 0.5rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1.5rem;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
        }

        .contact-item:hover {
            background: var(--gray-50);
        }

        .contact-item.active {
            background: var(--primary-50);
            border-right: 3px solid var(--primary);
        }

        .contact-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 600;
            font-size: 0.875rem;
            flex-shrink: 0;
            overflow: hidden;
        }

        .contact-info {
            flex: 1;
            min-width: 0;
        }

        .contact-name {
            font-weight: 500;
            color: var(--gray-900);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .contact-role {
            font-size: 0.75rem;
            color: var(--gray-500);
        }

        /* Existing chat styles overrides */
        .messages-area {
            flex: 1;
            padding: 1.5rem;
            overflow-y: auto;
            background: var(--gray-50);
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .chat-header {
            padding: 1rem 1.5rem; 
            border-bottom: 1px solid var(--gray-100);
            display: flex;
            align-items: center;
            gap: 1rem;
            background: #fff;
        }
        
        .chat-input-area {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--gray-100);
            background: #fff;
            display: flex;
            gap: 0.75rem;
        }
        
        @media (max-width: 768px) {
            .chat-sidebar {
                width: 80px; 
            }
            .contact-info, .contacts-category, .contacts-header h2 {
                display: none;
            }
            .contacts-header { padding: 1rem; text-align: center; }
            .contact-item { padding: 0.75rem; justify-content: center; }
            .contacts-category { margin-top: 0; }
        }
    </style>
    
    <div class="flex">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="/WEB-INF/views/common/header.jsp" />

            <% 
                User otherUser = (User) request.getAttribute("otherUser");
                User currentUser = (User) session.getAttribute("user");
                User nutritionist = (User) request.getAttribute("nutritionist");
                List<User> patients = (List<User>) request.getAttribute("patients");
                List<User> friends = (List<User>) request.getAttribute("friends");
                List<ChatMessage> history = (List<ChatMessage>) request.getAttribute("chatHistory");
                
                int activeId = otherUser != null ? otherUser.getId() : -1;
            %>

            <div class="chat-layout animate-fade-in">
                <!-- Sidebar -->
                <div class="chat-sidebar">
                    <div class="contacts-header">
                        <h2 style="font-size: 1.25rem; font-weight: 700;">Messages</h2>
                    </div>
                    
                    <div class="contacts-list">
                        <% if (nutritionist != null) { %>
                            <div class="contacts-category">PRO</div>
                            <a href="${pageContext.request.contextPath}/chat?userId=<%= nutritionist.getId() %>" 
                               class="contact-item <%= activeId == nutritionist.getId() ? "active" : "" %>">
                                <div class="contact-avatar">
                                    <% if (nutritionist.getProfilePicture() != null && !nutritionist.getProfilePicture().isEmpty()) { %>
                                        <img src="${pageContext.request.contextPath}/<%= nutritionist.getProfilePicture() %>" alt="Doc" style="width: 100%; height: 100%; object-fit: cover;">
                                    <% } else { %>
                                        DR
                                    <% } %>
                                </div>
                                <div class="contact-info">
                                    <div class="contact-name"><%= nutritionist.getFullName() %></div>
                                    <div class="contact-role">Nutritionist</div>
                                </div>
                            </a>
                        <% } %>
                        
                        <% if (patients != null && !patients.isEmpty()) { %>
                            <div class="contacts-category">PATIENTS</div>
                            <% for (User patient : patients) { 
                                String pInitials = patient.getFullName() != null && !patient.getFullName().isEmpty() ? patient.getFullName().substring(0, 1) : "P";
                            %>
                            <a href="${pageContext.request.contextPath}/chat?userId=<%= patient.getId() %>" 
                               class="contact-item <%= activeId == patient.getId() ? "active" : "" %>">
                                <div class="contact-avatar">
                                    <% if (patient.getProfilePicture() != null && !patient.getProfilePicture().isEmpty()) { %>
                                        <img src="${pageContext.request.contextPath}/<%= patient.getProfilePicture() %>" alt="<%= patient.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                    <% } else { %>
                                        <%= pInitials.toUpperCase() %>
                                    <% } %>
                                </div>
                                <div class="contact-info">
                                    <div class="contact-name"><%= patient.getFullName() %></div>
                                    <div class="contact-role">Patient</div>
                                </div>
                            </a>
                            <% } %>
                        <% } %>
                        
                        <% if (friends != null && !friends.isEmpty()) { %>
                            <div class="contacts-category">Friends</div>
                            <% for (User friend : friends) { 
                                String fInitials = friend.getFullName().substring(0, 1);
                            %>
                            <a href="${pageContext.request.contextPath}/chat?userId=<%= friend.getId() %>" 
                               class="contact-item <%= activeId == friend.getId() ? "active" : "" %>">
                                <div class="contact-avatar">
                                    <% if (friend.getProfilePicture() != null && !friend.getProfilePicture().isEmpty()) { %>
                                        <img src="${pageContext.request.contextPath}/<%= friend.getProfilePicture() %>" alt="<%= friend.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                    <% } else { %>
                                        <%= fInitials.toUpperCase() %>
                                    <% } %>
                                </div>
                                <div class="contact-info">
                                    <div class="contact-name"><%= friend.getFullName() %></div>
                                    <div class="contact-role">Friend</div>
                                </div>
                            </a>
                            <% } %>
                        <% } else if (nutritionist == null && (patients == null || patients.isEmpty())) { %>
                            <div style="padding: 2rem; text-align: center; color: var(--gray-500); font-size: 0.875rem;">
                                <i class="ph ph-users" style="font-size: 1.5rem; margin-bottom: 0.5rem; display: block;"></i>
                                No contacts found
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Main Chat Area -->
                <div class="chat-main">
                    <!-- Chat Header -->
                    <div class="chat-header">
                        <% if (otherUser != null) { 
                            String oInitials = otherUser.getFullName().substring(0, 1);
                        %>
                            <div class="contact-avatar">
                                <% if (otherUser.getProfilePicture() != null && !otherUser.getProfilePicture().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/<%= otherUser.getProfilePicture() %>" alt="User" style="width: 100%; height: 100%; object-fit: cover;">
                                <% } else { %>
                                    <%= oInitials.toUpperCase() %>
                                <% } %>
                            </div>
                            <div>
                                <div style="font-weight: 600; font-size: 1.1rem;"><%= otherUser.getFullName() %></div>
                                <div style="font-size: 0.8rem; color: var(--success); display: flex; align-items: center; gap: 0.25rem;">
                                    <span style="width: 8px; height: 8px; background: var(--success); border-radius: 50%;"></span>
                                    Online
                                </div>
                            </div>
                        <% } else { %>
                            <span style="color: var(--gray-500);">Select a conversation</span>
                        <% } %>
                    </div>

                    <!-- Messages -->
                    <div class="messages-area" id="messagesArea">
                        <% if (history != null && !history.isEmpty()) {
                            for(ChatMessage msg : history) {
                                boolean isSent = msg.getSenderId() == currentUser.getId();
                        %>
                        <div class="message-bubble <%= isSent ? "message-sent" : "message-received" %> animate-fade-in">
                            <div><%= msg.getMessage() %></div>
                            <div class="message-time"><%= msg.getCreatedAt() %></div>
                        </div>
                        <% } } else if (otherUser != null) { %>
                            <div class="empty-state">
                                <i class="ph ph-hand-waving" style="font-size: 3rem; color: var(--primary-200); margin-bottom: 1rem;"></i>
                                <div class="empty-state-title">Say Hello!</div>
                                <div class="empty-state-text">Start your conversation with <%= otherUser.getFullName() %></div>
                            </div>
                        <% } else { %>
                            <div class="empty-state">
                                <i class="ph ph-chats-circle" style="font-size: 3rem; color: var(--gray-300); margin-bottom: 1rem;"></i>
                                <div class="empty-state-title">Your Messages</div>
                                <div class="empty-state-text">Select a contact from the sidebar to start chatting.</div>
                            </div>
                        <% } %>
                    </div>

                    <!-- Input -->
                    <% if (otherUser != null) { %>
                    <div class="chat-input-area">
                        <input type="text" id="messageInput" class="input" placeholder="Type your message..." style="margin-bottom: 0; border-radius: 2rem;">
                        <input type="hidden" id="receiverId" value="<%= otherUser.getId() %>">
                        <button class="btn btn-primary" onclick="sendMessage()" style="border-radius: 50%; width: 44px; height: 44px; padding: 0; display: flex; align-items: center; justify-content: center;">
                            <i class="ph ph-paper-plane-right" style="font-size: 1.25rem;"></i>
                        </button>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

                    <script>
                        const messagesArea = document.getElementById('messagesArea');
                        if (messagesArea) messagesArea.scrollTop = messagesArea.scrollHeight;

                        function sendMessage() {
                            const input = document.getElementById('messageInput');
                            const receiverId = document.getElementById('receiverId').value;
                            const text = input.value;

                            if (!text.trim()) return;

                            fetch('${pageContext.request.contextPath}/chat/send', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'receiverId=' + receiverId + '&message=' + encodeURIComponent(text)
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        input.value = '';
                                        pollMessages();
                                    }
                                });
                        }

        <% if (otherUser != null) { %>
                            setInterval(pollMessages, 3000);

                            function pollMessages() {
                                const userId = <%= otherUser.getId() %>;
                                const currentUserId = <%= currentUser.getId() %>;

                                fetch('${pageContext.request.contextPath}/chat/poll?userId=' + userId)
                                    .then(response => response.json())
                                    .then(messages => {
                                        const area = document.getElementById('messagesArea');
                                        area.innerHTML = '';
                                        messages.forEach(msg => {
                                            const isSent = msg.senderId === currentUserId;
                                            const div = document.createElement('div');
                                            div.className = 'message-bubble ' + (isSent ? 'message-sent' : 'message-received');
                                            div.innerHTML = '<div>' + msg.message + '</div>' +
                                                '<div class="message-time">' + (msg.createdAt || '') + '</div>';
                                            area.appendChild(div);
                                        });
                                        area.scrollTop = area.scrollHeight;
                                    });
                            }
        <% } %>

                            // Allow Enter key to send
                            document.getElementById('messageInput')?.addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    sendMessage();
                                }
                            });
                    </script>
                </body>

                </html>