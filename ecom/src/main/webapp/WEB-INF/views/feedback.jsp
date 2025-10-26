<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.example.jpa.model.Feedback, com.example.jpa.model.Account, java.text.SimpleDateFormat" %>
<%
    String contextPath = request.getContextPath();
    Account currentUser = (Account) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect("/log");
        return;
    }
    List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
    Integer totalReviews = (Integer) request.getAttribute("totalReviews");
    Double avgRating = (Double) request.getAttribute("avgRating");
    Integer fiveStarReviews = (Integer) request.getAttribute("fiveStarReviews");
    Integer unresolvedCount = (Integer) request.getAttribute("unresolvedCount");

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Feedback | ShopHub Admin</title>

    <!-- Bootstrap + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
	
    <style>
        /* GLOBAL THEME COLORS */
        :root {
            --primary: #4e73df;
            --secondary: #858796;
            --success: #1cc88a;
            --warning: #f6c23e;
            --danger: #e74a3b;
            --info: #36b9cc;
            --dark: #343a40;
            --light: #f8f9fc;
        }

        html, body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light);
            color: var(--dark);
            height: 100%;
            overflow-x: hidden;
        }

        /* SIDEBAR */
        .sidebar {
            background: linear-gradient(180deg, var(--primary) 0%, #2e59d9 100%);
            min-height: 100vh;
            position: fixed;
            width: 230px;
            top: 0;
            left: 0;
            z-index: 1030;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.9);
            margin: 6px 10px;
            padding: 10px 15px;
            border-radius: 10px;
            transition: background 0.3s;
        }

        .sidebar .nav-link.active,
        .sidebar .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
        }

        .main-content {
            margin-left: 230px;
            padding: 20px;
            background-color: var(--light);
        }

        /* CARD STYLES */
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s ease-in-out;
        }

        .card:hover {
            transform: translateY(-3px);
        }

        .card-header {
            background-color: white;
            font-weight: 600;
        }

        /* TABLE STYLES */
        .table-container {
            overflow-x: auto;
            border-radius: 10px;
        }

        .table thead {
            background-color: var(--primary);
            color: white;
            text-transform: uppercase;
            font-size: 0.85rem;
        }

        .table tbody tr:hover {
            background-color: rgba(78,115,223,0.05);
        }

        .badge {
            font-size: 0.8rem;
            padding: 6px 10px;
            border-radius: 6px;
        }

        /* BUTTONS */
        .actions .btn {
            border-radius: 6px;
            padding: 5px 10px;
            font-size: 0.9rem;
            margin-right: 5px;
            transition: all 0.2s;
        }

        .edit-btn {
            background: rgba(26, 188, 156, 0.1);
            color: var(--success);
        }

        .edit-btn:hover {
            background: var(--success);
            color: white;
        }

        .delete-btn {
            background: rgba(231, 74, 59, 0.1);
            color: var(--danger);
        }

        .delete-btn:hover {
            background: var(--danger);
            color: white;
        }

        /* RESPONSIVENESS */
        @media (max-width: 991px) {
            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
            }

            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .card .numbers {
                font-size: 1.4rem;
            }

            .table-container {
                font-size: 0.9rem;
            }

            .topbar h4 {
                font-size: 1.2rem;
            }
        }

        /* RATING STARS */
        .rating {
            color: #f6c23e;
        }

        /* FEEDBACK MODAL */
        .modal-content {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- SIDEBAR -->
        <nav class="col-md-3 col-lg-2 sidebar d-md-block collapse" id="sidebarMenu">
            <div class="pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link active" href="#"><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="viewitem"><i class="fas fa-home me-2"></i>Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="addForm"><i class="fas fa-plus-circle me-2"></i>Add Product</a></li>
                    <li class="nav-item"><a class="nav-link" href="Category"><i class="fas fa-list me-2"></i>Category</a></li>
                    <li class="nav-item"><a class="nav-link" href="trainer"><i class="fas fa-users me-2"></i>Users</a></li>
                    <li class="nav-item"><a class="nav-link" href="AdminSideOrder"><i class="fas fa-shopping-bag me-2"></i>Orders</a></li>
                    <li class="nav-item"><a class="nav-link" href="feed"><i class="fas fa-comments me-2"></i>Feedback</a></li>
                    <li class="nav-item"><a class="nav-link" href="logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>
        </nav>

        <!-- MAIN CONTENT -->
        <div class="col main-content">
            <!-- Topbar -->
            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
                <button class="btn btn-outline-primary d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu">
                    <i class="fas fa-bars"></i>
                </button>
                <h4 class="mb-0"><i class="bi bi-chat-left-text me-2"></i>View Feedback</h4>
                   <div class="d-flex align-items-center">
				        <a class="navbar-brand" href="#">
				            <i class="fas fa-shopping-bag me-2"></i>ShopHub
				        </a>
				    </div>
               <div class="d-flex align-items-center">
                <span class="me-3">Logged in as: <strong><%= currentUser.getEmail() %></strong></span>
            </div>
            </div>

            <!-- DASHBOARD CARDS -->
            <div class="row g-3 mb-4">
                <div class="col-md-3 col-6">
                    <div class="card bg-primary text-white text-center p-3">
                        <h5 class="fw-bold"><%= totalReviews != null ? totalReviews : "0" %></h5>
                        <p class="mb-0">Total Reviews</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="card bg-success text-white text-center p-3">
                        <h5 class="fw-bold"><%= avgRating != null ? avgRating : "0.0" %></h5>
                        <p class="mb-0">Avg Rating</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="card bg-warning text-white text-center p-3">
                        <h5 class="fw-bold"><%= fiveStarReviews != null ? fiveStarReviews : "0" %></h5>
                        <p class="mb-0">5-Star Reviews</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="card bg-info text-white text-center p-3">
                        <p class="fw-bold mb-1">Need Help?</p>
                        <p class="small mb-0">Contact Developer</p>
                    </div>
                </div>
            </div>

            <!-- FEEDBACK TABLE -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">All Feedback</h5>
                    <select class="form-select w-auto" id="ratingFilter">
                        <option value="all">All Ratings</option>
                        <option value="5">5 Stars</option>
                        <option value="4">4 Stars</option>
                        <option value="3">3 Stars</option>
                        <option value="2">2 Stars</option>
                        <option value="1">1 Star</option>
                    </select>
                </div>
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
                                String feedbackId = String.format("#FB-%06d", feedback.getId());
                                String dateStr = dateFormat.format(java.sql.Timestamp.valueOf(feedback.getCreatedAt()));
                                String customerName = feedback.getAccount().getName();
                                String orderId = "Order #" + feedback.getOrder().getId();
                                String status = feedback.getOrder().getDelivery_status();
                        %>
                        <tr data-rating="<%= feedback.getRating() %>">
                            <td><%= feedbackId %></td>
                            <td><%= customerName %></td>
                            
                            <td>
							    <a href="AdminSideOrder?userId=<%= feedback.getOrder().getAccount().getId() %>&userName=<%= java.net.URLEncoder.encode(feedback.getOrder().getAccount().getName(), "UTF-8") %>"
							       class="btn btn-outline-primary btn-sm fw-semibold text-decoration-none">
							        <i class="bi bi-box-seam me-1"></i>
							        <%= orderId %>
							    </a>
							</td>

                            <td>
                                <div class="rating">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <i class="bi bi-star<%= i <= feedback.getRating() ? "-fill" : "" %>"></i>
                                    <% } %>
                                </div>
                            </td>
                            <td><span class="text-truncate d-inline-block" style="max-width:200px;"><%= feedback.getComment() %></span></td>
                            <td><%= dateStr %></td>
                            <td><span class="badge bg-success"><%= status %></span></td>
                            <td class="actions">
                                   <button class="btn edit-btn"
						        onclick="viewFeedback(
						            '<%= feedbackId %>',
						            '<%= customerName.replace("'", "\\'").replace("\"", "\\\"") %>',
						            '<%= orderId.replace("'", "\\'").replace("\"", "\\\"") %>',
						           <%= feedback.getRating() %>,
						            '<%= feedback.getComment()
						                .replace("\\", "\\\\")
						                .replace("'", "\\'")
						                .replace("\"", "\\\"")
						                .replace("\n", "\\n")
						                .replace("\r", "") %>',
						            '<%= dateStr.replace("'", "\\'").replace("\"", "\\\"") %>'
						        )">
						        <i class="bi bi-eye"></i>
						    </button>
                                <button class="btn delete-btn" onclick="deleteFeedback(<%= feedback.getId() %>)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="8" class="text-center text-secondary py-4">No feedback available.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL -->
<!-- Feedback Details Modal -->
<div class="modal fade" id="viewFeedbackModal" tabindex="-1" aria-labelledby="viewFeedbackModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content border-0 shadow-lg rounded-4">
      
      <div class="modal-header bg-primary text-white rounded-top-4">
        <h5 class="modal-title d-flex align-items-center">
          <i class="bi bi-chat-dots-fill me-2"></i> Feedback Details
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body p-4">
        <div class="row mb-3">
          <div class="col-4 fw-semibold text-secondary">Feedback ID:</div>
          <div class="col-8" id="modalFeedbackId"></div>
        </div>

        <div class="row mb-3">
          <div class="col-4 fw-semibold text-secondary">Customer:</div>
          <div class="col-8" id="modalCustomer"></div>
        </div>

        <div class="row mb-3">
          <div class="col-4 fw-semibold text-secondary">Order:</div>
          <div class="col-8">
            <button id="modalOrderBtn" class="btn btn-outline-primary btn-sm fw-semibold">
              <i class="bi bi-box-seam me-1"></i>
              <span id="modalOrder"></span>
            </button>
          </div>
        </div>

        <div class="row mb-3 align-items-center">
          <div class="col-4 fw-semibold text-secondary">Rating:</div>
          <div class="col-8" id="modalRating" class="rating text-warning fs-5"></div>
        </div>

        <div class="row mb-3">
          <div class="col-4 fw-semibold text-secondary">Date:</div>
          <div class="col-8" id="modalDate"></div>
        </div>

        <div class="mt-4">
          <div class="fw-semibold text-secondary mb-2">Comment:</div>
          <div id="modalComment" class="p-3 bg-light border rounded-3"></div>
        </div>
      </div>

    </div>
  </div>
</div>


<!-- SCRIPTS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function deleteFeedback(id) {
        if (confirm('Are you sure you want to delete this feedback?')) {
            window.location.href = '/feedback/delete/' + id;
        }
    }

    function viewFeedback(feedbackId, customer, order, rating, comment, date) {
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
        new bootstrap.Modal(document.getElementById('viewFeedbackModal')).show();
    }


    document.getElementById('ratingFilter').addEventListener('change', function() {
        const value = this.value;
        document.querySelectorAll('#feedbackTable tbody tr').forEach(tr => {
            const rating = tr.getAttribute('data-rating');
            tr.style.display = (value === 'all' || rating === value) ? '' : 'none';
        });
    });
</script>
</body>
</html>
