<!DOCTYPE html>
<html lang="en">
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%@ page import="com.example.jpa.model.Feedback" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
        String contextPath = request.getContextPath();
        Account currentUser = (Account) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect("/log");
            return;
        }
    List<Feedback> feedbackList = (List <Feedback>) request.getAttribute("feedbackList");
    Integer totalReviews = (Integer) request.getAttribute("totalReviews");
    Double avgRating = (Double) request.getAttribute("avgRating");
    Integer fiveStarReviews = (Integer) request.getAttribute("fiveStarReviews");
    Integer unresolvedCount = (Integer) request.getAttribute("unresolvedCount");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Feedback | ShopHub Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Using a more reliable CDN for Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Also adding Font Awesome as fallback for icons used in sidebar -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ADMIN.css">
    <style>
        /* Existing styles remain the same */
        :root {
            --primary: #4e73df;
            --secondary: #858796;
            --success: #1cc88a;
            --info: #36b9cc;
            --warning: #f6c23e;
            --danger: #e74a3b;
            --light: #f8f9fc;
            --dark: #5a5c69;
        }
        html, body {
            height: 100%;
            overflow-x: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--dark);
            background-color: #f5f5f5;
        }
        .container-fluid {
            min-height: 100vh;
        }
        .sidebar {
            min-height: 100vh;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
            background: linear-gradient(180deg, var(--primary) 10%, #2e59d9 100%) !important;
            z-index: 100;
            box-shadow: 0 2px 4px rgba(0,0,0,.08);
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8) !important;
            font-weight: 500;
            margin: 5px 15px;
            padding: 10px 15px !important;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
        }

        .table-container {
            max-height: 500px;
            overflow-y: auto;
            position: relative;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        .table-container thead {
            position: sticky;
            top: 0;
            background: #f8f9fa;
            z-index: 10;
            border-bottom: 2px solid var(--primary);
        }
        .table-container thead th {
            font-weight: 600;
            color: var(--primary);
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
            padding: 15px;
        }
        .table-container tbody tr {
            border-bottom: 1px solid #e3e6f0;
            transition: background-color 0.2s;
        }
        .table-container tbody tr:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }
        .table-container tbody td {
            padding: 15px;
            vertical-align: middle;
        }
        .table-container::-webkit-scrollbar {
            width: 8px;
        }
        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        .table-container::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 4px;
        }
        .table-container::-webkit-scrollbar-thumb:hover {
            background: #2e59d9;
        }
        .main-content {
            min-height: 100vh;
            padding-bottom: 30px;
            background-color: #f5f5f5;
        }
        /* Card Styles */
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            margin-bottom: 25px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 2rem 0 rgba(58, 59, 69, 0.2);
        }
        .card-header {
            background-color: white;
            border-bottom: 1px solid #e3e6f0;
            padding: 15px 20px;
            font-weight: 600;
            color: var(--dark);
        }
        /* Button Styles */
        .btn-primary {
            background-color: var(--primary);
            border-color: var(--primary);
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
            transform: translateY(-2px);
        }
        .btn-outline-secondary {
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-outline-secondary:hover {
            transform: translateY(-2px);
        }
        /* Form Styles */
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #d1d3e2;
            padding: 10px 15px;
            transition: all 0.2s ease-in-out;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }
        /* Topbar Styles */
        .topbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,.08);
            padding: 15px 0;
            margin-bottom: 25px;
        }
        .topbar .input-group {
            max-width: 300px;
        }
        .topbar .form-control {
            border-radius: 50px 0 0 50px;
            border-right: none;
        }
        .topbar .btn {
            border-radius: 0 50px 50px 0;
            background-color: var(--primary);
            border-color: var(--primary);
        }
        /* Dashboard Cards */
        .cardbox .card {
            border-left: 4px solid var(--primary);
        }
        .cardbox .card .numbers {
            font-size: 1.75rem;
            font-weight: bold;
            color: #fff;
            margin-bottom: 5px;
        }
        .cardbox .card .cardName {
            font-size: 0.9rem;
            color: var(--secondary);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .cardbox .card .iconbox {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(78, 115, 223, 0.1);
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--primary);
            font-size: 1.5rem;
        }
        /* Action Buttons */
        .actions .edit-btn, .actions .delete-btn {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.85rem;
            margin-right: 5px;
            transition: all 0.2s;
        }
        .actions .edit-btn {
            background: rgba(26, 188, 156, 0.1);
            color: var(--success);
        }
        .actions .edit-btn:hover {
            background: var(--success);
            color: white;
        }
        .actions .delete-btn {
            background: rgba(231, 74, 59, 0.1);
            color: var(--danger);
        }
        .actions .delete-btn:hover {
            background: var(--danger);
            color: white;
        }
        /* Star Rating */
        .rating {
            color: #f6c23e;
        }
        /* Feedback Message */
        .feedback-message {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .form-container {
                margin: 20px 15px;
                padding: 20px;
            }
            
            .form-title {
                font-size: 1.5rem;
            }
            
            .btn-submit, .btn-outline-secondary {
                width: 100%;
                margin-bottom: 10px;
            }
        }
        
        .cardbox .card.bg-success {
            border-left: 4px solid #1cc88a;
        }
        .cardbox .card.bg-warning {
            border-left: 4px solid #f6c23e;
        }
        .cardbox .card.bg-danger {
            border-left: 4px solid #e74a3b;
        }

        /* Modal styles */
        .modal-content {
            border-radius: 10px;
            border: none;
            box-shadow: 0 0.5rem 2rem rgba(0, 0, 0, 0.15);
        }
        .modal-header {
            border-bottom: 1px solid #e3e6f0;
            padding: 1.5rem;
        }
        .modal-body {
            padding: 1.5rem;
        }
        .modal-footer {
            border-top: 1px solid #e3e6f0;
            padding: 1rem 1.5rem;
        }
        .feedback-detail-label {
            font-weight: 600;
            color: var(--dark);
        }
        .feedback-detail-value {
            margin-bottom: 1rem;
        }
        .feedback-detail-comment {
            background-color: #f8f9fc;
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid var(--primary);
        }
        
        /* Debug styles to ensure table is visible */
        .table-container {
            min-height: 200px;
        }
        .no-data-message {
            text-align: center;
            padding: 20px;
            color: var(--secondary);
        }
    </style>
</head>
<body>
     <div class="container-fluid">
        <div class="row">
              <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" id="sidebar">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active text-white" href="#">
                            <i class="fas fa-tachometer-alt me-2"></i> Admin Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="viewitem">
                            <i class="fas fa-home me-2"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="addForm">
                            <i class="fas fa-plus-circle me-2"></i> Add Product
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="Category">
                            <i class="fas fa-plus-circle me-2"></i> Category
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="trainer">
                            <i class="fas fa-users me-2"></i> View Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="AdminSideOrder">
                            <i class="fas fa-shopping-bag me-2"></i> View Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="feed">
                            <i class="fas fa-comments me-2"></i> View Feedback
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <!-- Topbar -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebar">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div>
                        <a class="navbar-brand" href="#">
                            <i class="fas fa-shopping-bag me-2"></i>ShopHub
                        </a>
                    </div>
                    <!-- User Info Section (Logged In As) -->
                    <div class="d-flex align-items-center">
                        <span class="me-3">Logged in as: <strong><%= currentUser.getEmail() %></strong></span>
                    </div>
                </div>
                <div class="topbar d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <h4 class="mb-0">View Feedback</h4>
                    </div>
                </div>
                 
                <!-- Stats Cards with colors -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card cardbox bg-primary">
                            <div class="card-body d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="numbers"><%= totalReviews != null ? totalReviews : "0" %></div>
                                    <div class="cardName">Total Reviews</div>
                                </div>
                                <div class="iconbox">
                                    <i class="bi bi-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card cardbox <%= (avgRating != null && avgRating > 4) ? "bg-success" : (avgRating != null && avgRating > 3) ? "bg-warning" : "bg-danger" %>">
                            <div class="card-body d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="numbers"><%= avgRating != null ? avgRating : "0.0" %></div>
                                    <div class="cardName">Avg Rating</div>
                                </div>
                                <div class="iconbox">
                                    <i class="bi bi-star-half"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card cardbox bg-warning">
                            <div class="card-body d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="numbers"><%= fiveStarReviews != null ? fiveStarReviews : "0" %></div>
                                    <div class="cardName">5-Star Reviews</div>
                                </div>
                                <div class="iconbox">
                                    <i class="bi bi-star-fill"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- New Card for Developer Contact -->
                    <div class="col-md-3 col-sm-6 mb-3">
                        <div class="card cardbox bg-info text-white">
                            <div class="card-body d-flex align-items-center">
                                <div class="flex-grow-1">
                                    <div class="numbers">Always Here for New Features!</div>
                                    <div class="cardName">Contact Developer</div>
                                </div>
                                <div class="iconbox">
                                    <i class="bi bi-person-check"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Feedback Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">All Feedback</h5>
                        <div class="d-flex">
                            <!-- Feedback Rating Filter -->
                        <select class="form-select me-2" style="width: auto;" id="ratingFilter">
                            <option value="all">Filter</option>
                            <option value="5">5 Stars</option>
                            <option value="4">4 Stars</option>
                            <option value="3">3 Stars</option>
                            <option value="2">2 Stars</option>
                            <option value="1">1 Star</option>
                        </select>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-container">
                            <table class="table table-hover mb-0" id="feedbackTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Customer</th>
                                        <th>Order</th>
                                        <th>Rating</th>
                                        <th>Feedback</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (feedbackList != null && !feedbackList.isEmpty()) {
                                        for (Feedback feedback : feedbackList) {
                                            // Format the feedback ID
                                            String feedbackId = String.format("#FB-%06d", feedback.getId());
                                            
                                            // Format the date
                                            String dateStr = dateFormat.format(java.sql.Timestamp.valueOf(feedback.getCreatedAt()));
                                            
                                            // Customer name
                                            String customerName = feedback.getAccount().getName();
                                            
                                            // Order ID
                                            String orderId = "Order #" + feedback.getOrder().getId();                                           
                                    %>
                                        <tr data-rating="<%= feedback.getRating() %>">
                                            <td><%= feedbackId %></td>
                                            <td><%= customerName %></td>
                                            <td><% if (feedback.getOrder() != null) { %>
                                                    <a href="AdminSideOrder?userId=<%= feedback.getOrder().getAccount().getId() %>&userName=<%= java.net.URLEncoder.encode(feedback.getOrder().getAccount().getName(), "UTF-8") %>" 
                                                       style="color: #007bff; text-decoration: none; font-weight: bold; padding: 5px 10px; border: 1px solid #007bff; border-radius: 4px; display: inline-block;">
                                                        <%= orderId %>
                                                    </a>
                                                <% } else { %>
                                                    <%= orderId %>
                                                <% } %></td>
                                            <td>
                                                <div class="rating">
                                                    <% for (int i = 1; i <= 5; i++) { %>
                                                        <i class="bi bi-star<%= i <= feedback.getRating() ? "-fill" : "" %>"></i>
                                                    <% } %>
                                                </div>
                                            </td>
                                            <td class="feedback-message"><%= feedback.getComment() %></td>
                                            <td><%= dateStr %></td>
                                           <td>
											    <% 
											        String status = "Unknown";
											        if (feedback.getOrder() != null && feedback.getOrder().getDelivery_status() != null) {
											            status = feedback.getOrder().getDelivery_status();
											        }
											    %>
											    <span class="badge bg-success"><%= status %></span>
											</td>
                                            <td class="actions">
                                               <button class="btn edit-btn" onclick="viewFeedback(
												    '<%= feedbackId %>',
												    '<%= StringEscapeUtils.escapeEcmaScript(customerName) %>',
												    '<%= StringEscapeUtils.escapeEcmaScript(orderId) %>',
												    <%= feedback.getRating() %>,
												    '<%= StringEscapeUtils.escapeEcmaScript(feedback.getComment()) %>',
												    '<%= dateStr %>'
												)">
												    <i class="bi bi-eye"></i>
												</button>
                                                <button class="btn delete-btn" onclick="deleteFeedback(<%= feedback.getId() %>)">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    <% 
                                        }
                                    } else { %>
                                        <tr>
                                            <td colspan="8" class="no-data-message">
                                                <i class="bi bi-info-circle me-2"></i>
                                                No feedback data available at the moment.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Single Modal for all Feedback -->
    <div class="modal fade" id="viewFeedbackModal" tabindex="-1" aria-labelledby="viewFeedbackModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewFeedbackModalLabel">Feedback Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <span class="feedback-detail-label">Feedback ID:</span>
                        </div>
                        <div class="col-md-8">
                            <span id="modalFeedbackId" class="feedback-detail-value"></span>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <span class="feedback-detail-label">Customer:</span>
                        </div>
                        <div class="col-md-8">
                            <span id="modalCustomer" class="feedback-detail-value"></span>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <span class="feedback-detail-label">Order:</span>
                        </div>
                        <div class="col-md-8">
                            <span id="modalOrder" class="feedback-detail-value"></span>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <span class="feedback-detail-label">Rating:</span>
                        </div>
                        <div class="col-md-8">
                            <div id="modalRating" class="rating"></div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <span class="feedback-detail-label">Date:</span>
                        </div>
                        <div class="col-md-8">
                            <span id="modalDate" class="feedback-detail-value"></span>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-12">
                            <span class="feedback-detail-label">Comment:</span>
                            <div id="modalComment" class="feedback-detail-comment mt-2"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Debug: Check if the page loaded correctly
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Page loaded successfully');
            console.log('Feedback table element:', document.getElementById('feedbackTable'));
            console.log('Feedback list size:', <%= feedbackList != null ? feedbackList.size() : 0 %>);
        });
        
        function deleteFeedback(id) {
            if (confirm('Are you sure you want to delete this feedback?')) {
                window.location.href = '/feedback/delete/' + id;
            }
        }
        
        // Function to view feedback details in modal
        function viewFeedback(feedbackId, customer, order, rating, comment, date) {
            // Set modal content
            document.getElementById('modalFeedbackId').textContent = feedbackId;
            document.getElementById('modalCustomer').textContent = customer;
            document.getElementById('modalOrder').textContent = order;
            document.getElementById('modalDate').textContent = date;
            document.getElementById('modalComment').textContent = comment;
            
            // Generate star rating HTML
            let ratingHtml = '';
            for (let i = 1; i <= 5; i++) {
                if (i <= rating) {
                    ratingHtml += '<i class="bi bi-star-fill"></i>';
                } else {
                    ratingHtml += '<i class="bi bi-star"></i>';
                }
            }
            document.getElementById('modalRating').innerHTML = ratingHtml;
            
            // Show the modal
            const modal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
            modal.show();
        }
        
        // Rating Filter
        document.getElementById('ratingFilter').addEventListener('change', function() {
            const filterValue = this.value;
            const rows = document.querySelectorAll('#feedbackTable tbody tr');
            rows.forEach(row => {
                const rating = row.getAttribute('data-rating');
                if (filterValue === 'all' || rating === filterValue) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>