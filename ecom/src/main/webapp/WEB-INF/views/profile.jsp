 <%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="com.example.jpa.model.Order" %>
<%@ page import="com.example.jpa.model.OrderItem" %>
<%@ page import="com.example.jpa.model.Feedback" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Account currentUser = (Account) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("/log");
        return;
    }
    Account account = (Account) request.getAttribute("account");
    List<Order> recentOrders = (List<Order>) request.getAttribute("recentOrders");
    List<Feedback> userFeedbacks = (List<Feedback>) request.getAttribute("userFeedbacks");

    // Fix for ClassCastException - handle both Integer and Long
    Object orderCountObj = request.getAttribute("orderCount");
    long orderCount = 0;
    if (orderCountObj instanceof Integer) {
        orderCount = ((Integer) orderCountObj).longValue();
    } else if (orderCountObj instanceof Long) {
        orderCount = (Long) orderCountObj;
    }
	String error= (String) request.getAttribute("error");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - ShopHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HOME.CSS">
    <jsp:include page="navbar.jsp" />
    <style>
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

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--dark);
            background-color: #f5f5f5;
        }

        .dashboard-container {
            padding: 30px 0;
        }

        .welcome-card {
            background: linear-gradient(to right, var(--primary), #2e59d9);
            color: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .dashboard-card, .feedback-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
            height: 100%;
        }

        .feedback-item {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .feedback-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .feedback-order-id {
            font-weight: 600;
            color: var(--primary);
        }

        .feedback-rating {
            color: var(--warning);
        }

        .feedback-scroll-container {
            max-height: 350px;
            overflow-y: auto;
            padding-right: 10px;
        }

        .feedback-scroll-container::-webkit-scrollbar {
            width: 6px;
        }

        .feedback-scroll-container::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 10px;
        }

        .feedback-scroll-container::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }

        .no-feedback {
            text-align: center;
            color: var(--secondary);
            padding: 20px;
        }

        /* Modal styles */
        .modal-content {
            border-radius: 10px;
        }
        .dashboard-card h5 i,
.feedback-card h5 i {
    vertical-align: middle;
}

.btn {
    transition: all 0.2s ease;
}

.btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.feedback-card,
.dashboard-card {
    height: 100%;
    display: flex;
    flex-direction: column;
}

.feedback-scroll-container {
    flex-grow: 1;
}

.feedback-item {
    background-color: #f9fafc;
    border: 1px solid #e6e8ef;
    border-radius: 8px;
    padding: 12px 15px;
    margin-bottom: 10px;
    transition: all 0.3s ease;
    cursor: pointer;
}
.feedback-item:hover {
    background-color: #f1f3f9;
    transform: scale(1.02);
}

.order-item {
    transition: all 0.2s ease;
}
.order-item:hover {
    background-color: #f8f9ff;
    transform: translateY(-2px);
}
        
    </style>
</head>
<body>

			<!-- Alert Message Section -->
        <%
    String msg = (String) request.getAttribute("msg");
    String alertClass = "";
    String alertText = "";

    if (msg != null) {
        switch (msg) {
            case "ok":
                alertClass = "alert-success";
                alertText = "✅ Your email has been updated successfully!";
                break;
            case "pwd":
                alertClass = "alert-danger";
                alertText = "❌ Incorrect password. Please try again.";
                break;
            case "e":
                alertClass = "alert-warning";
                alertText = "⚠️ This email is already in use.";
                break;
            case "login":
                alertClass = "alert-warning";
                alertText = "⚠️ Please log in to update your email.";
                break;
            case "deleted":
                alertClass = "alert-success";
                alertText = "✅ Your account and all associated data have been deleted successfully!";
                break;
        }
%>


<div id="floatingAlert" class="alert <%= alertClass %> shadow-lg rounded-3 p-3 position-fixed top-0 start-50 translate-middle-x" 
     style="z-index:1050; width: 350px; text-align:center; opacity:0;">
    <%= alertText %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const alertBox = document.getElementById("floatingAlert");
        if (alertBox) {
            // Show alert
            alertBox.style.transition = "opacity 0.5s ease, transform 0.5s ease";
            alertBox.style.opacity = 1;
            alertBox.style.transform = "translate(-50%, 20px)";

            // Fade out after 3 seconds
            setTimeout(() => {
                alertBox.style.opacity = 0;
                alertBox.style.transform = "translate(-50%, -20px)";
            }, 3000);

            // Remove from DOM after fade-out
            setTimeout(() => {
                alertBox.remove();
            }, 3500);
        }
    });
</script>

<%
    }
%>



    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome -->
            <div class="welcome-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1>Welcome, <%= account != null ? account.getName() : (currentUser != null ? currentUser.getName() : "User") %>!</h1>
                        <p class="mb-0">Here's what's happening with your account today.</p>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="d-flex justify-content-end">
                            <div class="text-center me-4">
                                <h3><%= orderCount %></h3>
                                <p class="mb-0">Orders</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
<div class="row g-4 align-items-stretch">
    <!-- Recent Orders -->
    <div class="col-lg-4 col-md-6">
        <div class="dashboard-card h-100">
            <h5 class="mb-3"><i class="fas fa-box me-2 text-primary"></i>Recent Orders</h5>
            <div style="max-height: 400px; overflow-y: auto;">
            <% if (recentOrders != null && !recentOrders.isEmpty()) {
                for (Order o : recentOrders) {
                    List<OrderItem> items = o.getItems();
                    String firstImage = (items != null && !items.isEmpty())
                            ? items.get(0).getProduct().getImagePath()
                            : "/images/placeholder.png";
            %>
                <div class="order-item mb-3 p-3 border rounded shadow-sm bg-light">
                    <div class="d-flex align-items-center">
                        <img src="/uploads/<%= firstImage %>" alt="Product" class="me-3"
                             style="width:60px; height:60px; object-fit:cover; border-radius:8px;">
                        <div class="order-details flex-grow-1">
                            <div><strong>Order ID:</strong> #<%= o.getId() %></div>
                            <div><strong>Transaction:</strong> <%= o.getRazorpayPaymentId() != null ? o.getRazorpayPaymentId() : "N/A" %></div>
                            <div><strong>Date:</strong> <%= o.getOrderDate() %></div>
                            <div><strong>Status:</strong> <span class="badge bg-info text-dark">
                                <%= o.getDelivery_status() != null ? o.getDelivery_status() : "Pending" %>
                            </span></div>
                        </div>
                        <a href="/order/details?id=<%= o.getId() %>" class="btn btn-sm btn-outline-primary">View</a>
                    </div>
                </div>
            <% } } else { %>
                <p class="text-muted text-center py-4">No recent orders found.</p>
            <% } %>
            </div>
        </div>
    </div>

    <!-- Account Information -->
    <div class="col-lg-4 col-md-6">
        <div class="dashboard-card h-100">
            <h5 class="mb-3"><i class="fas fa-user-circle me-2 text-primary"></i>Account Information</h5>
            
            <div class="account-info mb-3">
                <i class="fas fa-user me-2 text-secondary"></i>
                <%= account != null ? account.getName() : (currentUser != null ? currentUser.getName() : "N/A") %>
            </div>
            <div class="account-info mb-3">
                <i class="fas fa-envelope me-2 text-secondary"></i>
                <%= account != null ? account.getEmail() : (currentUser != null ? currentUser.getEmail() : "N/A") %>
            </div>
            <% if (recentOrders != null && !recentOrders.isEmpty()) {
                Order latestOrder = recentOrders.get(0); %>
                <div class="account-info mb-3">
                    <i class="fas fa-map-marker-alt me-2 text-secondary"></i>
                    <%= latestOrder.getLine1() != null ? latestOrder.getLine1() + ", " : "" %>
                    <%= latestOrder.getCity() != null ? latestOrder.getCity() + ", " : "" %>
                    <%= latestOrder.getPostal() != null ? latestOrder.getPostal() + ", " : "" %>
                    <%= latestOrder.getCountry() != null ? latestOrder.getCountry() : "" %>
                </div>
            <% } else { %>
                <div class="account-info mb-3">
                    <i class="fas fa-map-marker-alt me-2 text-secondary"></i> Address not available <small>*Make a purchase!*</small>
                </div>
            <% } %>

            <!-- Edit Buttons -->
          	 <div class="mt-4 text-center">
			    <button class="btn btn-primary px-4 py-2 me-2 rounded-pill shadow-sm"
			            data-bs-toggle="modal" data-bs-target="#editEmailModal">
			        <i class="fas fa-envelope-open me-2"></i>Edit Email
			    </button>
			    <button class="btn btn-warning px-4 py-2 me-2 rounded-pill shadow-sm"
			            data-bs-toggle="modal" data-bs-target="#editPasswordModal">
			        <i class="fas fa-key me-2"></i>Edit Password
			    </button>
			
			    <!-- Add margin-top to separate from the "Edit" buttons -->
			    <button class="btn btn-danger px-4 py-2 mt-3 rounded-pill shadow-sm text-white d-block mx-auto"
			            data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
			        <i class="fas fa-trash-alt me-2"></i>Delete Account!
			    </button>
			    <% if(error != null) { %>
			     <div class="alert alert-danger alert-dismissible fade show" role="alert">
			      <i class="bi bi-exclamation-triangle-fill me-2"> </i><%= error %>
			       <button type="button" class="btn-close" data-bs-dismiss="alert">
			       </button> 
			     </div> <% } %>
			</div>
        </div>
    </div>

    <!-- Feedback Section -->
    <div class="col-lg-4 col-md-12">
        <div class="feedback-card h-100">
            <h5 class="mb-3"><i class="fas fa-comments me-2 text-primary"></i>Your Feedbacks</h5>
            <div class="feedback-scroll-container">
                <% if (userFeedbacks != null && !userFeedbacks.isEmpty()) {
                    int index = 0;
                    for (Feedback feedback : userFeedbacks) { %>
                        <div class="feedback-item"
                             data-bs-toggle="modal"
                             data-bs-target="#feedbackModal<%= index %>">
                            <div class="feedback-header">
                                <div class="feedback-order-id">Order #<%= feedback.getOrder().getId() %></div>
                                <div class="feedback-rating">
                                    <% for (int i = 1; i <= 5; i++) {
                                       String starClass = (i <= feedback.getRating()) ? "" : "text-muted"; %>
                                       <i class="fas fa-star <%= starClass %>"></i>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <!-- Feedback Modal -->
                        <div class="modal fade" id="feedbackModal<%= index %>" tabindex="-1" aria-labelledby="feedbackModalLabel<%= index %>" aria-hidden="true">
                          <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="feedbackModalLabel<%= index %>">
                                    Feedback for Order #<%= feedback.getOrder().getId() %>
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                              </div>
                              <div class="modal-body">
                                <p><strong>Rating:</strong>
                                 <% for (int i = 1; i <= 5; i++) { 
                                        String starClass = (i <= feedback.getRating()) ? "text-warning" : "text-muted"; %>
                                        <i class="fas fa-star <%= starClass %>"></i>
                                 <% } %>
                                </p>
                                <p><strong>Comment:</strong></p>
                                <p><%= feedback.getComment() %></p>
                              </div>
                              <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                              </div>
                            </div>
                          </div>
                        </div>
                <% index++; }
                } else { %>
                    <div class="no-feedback">
                        <i class="fas fa-comment-slash fa-3x mb-3 text-muted"></i>
                        <p>No feedbacks submitted yet.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

                    </div>
                </div>
              
<!-- Edit Email Modal -->
<div class="modal fade" id="editEmailModal" tabindex="-1" aria-labelledby="editEmailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form action="/updateEmail" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="editEmailModalLabel">Edit Email</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="newEmail" class="form-label">New Email Address</label>
            <input type="email" class="form-control" id="newEmail" name="newEmail" required>
          </div>
          <div class="mb-3">
            <label for="currentPasswordEmail" class="form-label">Current Password</label>
            <input type="password" class="form-control" id="currentPasswordEmail" name="currentPassword" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Update Email</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Password Modal -->
<div class="modal fade" id="editPasswordModal" tabindex="-1" aria-labelledby="editPasswordModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form action="/updatePasswordFull" method="post">
      <input type="hidden" class="form-control" id="email" name="email" value="<%= account.getEmail() %>" >
        <div class="modal-header">
          <h5 class="modal-title" id="editPasswordModalLabel">Edit Password</h5>
          
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
        	<small class="text-danger">NOTE: You have to login again after this action!</small>
          <div class="mb-3">
            <label for="securityQuestion" class="form-label">Security Question</label>
            <input type="text" class="form-control" id="securityQuestion" name="securityQuestion" value="What is your <%= account.getSec_q() %>'s name?" disabled>
          </div>
          <div class="mb-3">
            <label for="securityAnswer" class="form-label">Security Answer</label>
            <input type="text" class="form-control" id="securityAnswer" name="answer" required>
          </div>
          <div class="mb-3">
            <label for="newPassword" class="form-label">New Password</label>
            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
          </div>
          <div class="mb-3">
            <label for="confirmPassword" class="form-label">Confirm New Password</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
          </div>
        </div>
        <div class="modal-footer">
		 <button type="button" id="forgotPasswordLink"
        class="btn btn-link text-decoration-none text-link me-3"
        data-bs-toggle="modal" data-bs-target="#mockingModal">
    <i class="bi bi-key"></i> 😲 Forgot Answer?
</button>

          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          
          <button type="submit" class="btn btn-warning">Update Password</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- Mocking Modal -->
<div class="modal fade" id="mockingModal" tabindex="-1" aria-labelledby="mockingModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content text-center">
      <div class="modal-header border-0">
        <h5 class="modal-title w-100" id="mockingModalLabel">😂 Ha ha ha!</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p style="font-size: 1.2rem;">
          You forgot this little thing? 😆<br>
          Don't worry, we got you covered.<br>
          It is unbeliveable you did'nt care about your <%=account.getSec_q()%>!
        </p>
         <p class="text-muted mb-4">Not letting you go away like that,</p>
        <p class="text-muted mb-4">You can still reset your password below.</p>
       <a href="<%= request.getContextPath() %>/forgotPassword?email=<%= account.getEmail() %>" class="btn btn-primary">
		    <i class="bi bi-arrow-repeat me-1"></i> Forgot Password
		</a>

      </div>
      <div class="modal-footer border-0"></div>
    </div>
  </div>
</div>
<!-- Delete Account Modal -->
<div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteAccountModalLabel">Confirm Account Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="text-danger">Warning: All your data will be erased and cannot be retrieved again. Are you sure you want to delete your account?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
              <form action="/deleteAccount" method="post">
    <!-- Hidden field for user ID (optional if you use session in controller) -->
    <input type="hidden" name="userId" value="<%= currentUser.getId() %>">

    <!-- Ask user to confirm their password before deletion -->
    <div class="mb-3">
        <label for="password" class="form-label">Enter your password to confirm:</label>
        <input type="password" class="form-control" id="password" name="password" required>
    </div>

    <button type="submit" class="btn btn-danger">Delete Account</button>
</form>

              </div>
        </div>
    </div>
</div>

    <!-- Footer -->
        <footer>
        <div class="container">
            <div class="row">
                <div class="col-md-4 footer-col">
                    <h5>ShopHub</h5>
                    <p>Your one-stop destination for all your shopping needs. We offer a wide range of products at competitive prices with fast delivery.</p>
                    <div class="social-icons">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="col-md-2 footer-col">
                    <h5>Quick Links</h5>
                    <ul class="footer-links">
                        <li><a href="/">Home</a></li>
                        <li><a href="/productlist">Products</a></li>
                        <li><a href="/user_category">Categories</a></li>
                        <li><a href="/about">About Us</a></li>
                        <li><a href="/contactus">Contact Us</a></li>
                    </ul>
                </div>
                <div class="col-md-3 footer-col">
                    <h5>Customer Service</h5>
                    <ul class="footer-links">
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Shipping Policy</a></li>
                        <li><a href="#">Returns & Refunds</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms & Conditions</a></li>
                    </ul>
                </div>
                <div class="col-md-3 footer-col">
                    <h5>Contact Us</h5>
                    <ul class="footer-links">
                        <li><i class="fas fa-map-marker-alt me-2"></i>123 Shopping St, Retail City</li>
                        <li><i class="fas fa-phone me-2"></i>+91 9999999999</li>
                        <li><i class="fas fa-envelope me-2"></i>contact@shophub.com</li>
                    </ul>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; 2025 ShopHub. All Rights Reserved.</p>
            </div>
        </div>
    </footer>   

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
