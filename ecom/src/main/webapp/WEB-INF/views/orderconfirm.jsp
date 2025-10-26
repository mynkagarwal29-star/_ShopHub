<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Order" %>
<%@ page import="com.example.jpa.model.OrderItem" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="java.util.List" %>
<%
    Account currentUser = (Account) session.getAttribute("currentUser");
    Order order = (Order) request.getAttribute("order");
    Boolean feedbackExists = (Boolean) request.getAttribute("feedbackExists");
    Boolean feedbackSuccess = (Boolean) request.getAttribute("feedbackSuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - ShopHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HOME.css">
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
        
        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,.08);
            padding: 15px 0;
        }
        
        .navbar-brand {
            font-weight: 700;
            color: var(--primary) !important;
            font-size: 1.5rem;
        }
        
        .navbar-nav .nav-link {
            color: var(--dark) !important;
            font-weight: 500;
            margin: 0 10px;
            transition: color 0.3s;
        }
        
        .navbar-nav .nav-link:hover {
            color: var(--primary) !important;
        }
        
        .user-dropdown {
            display: flex;
            align-items: center;
        }
        
        .user-dropdown img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .confirmation-container {
            padding: 30px 0;
        }
        
        .confirmation-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .success-icon {
            font-size: 5rem;
            color: var(--success);
            margin-bottom: 20px;
        }
        
        .order-number {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        /* Order Status Styles */
        .order-status-container {
            margin: 25px 0;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            border: 1px solid #e9ecef;
        }
        
        .order-status-title {
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--dark);
            font-size: 1.2rem;
        }
        
        .status-progress {
            display: flex;
            justify-content: space-between;
            position: relative;
            margin-bottom: 15px;
        }
        
        .status-progress::before {
            content: '';
            position: absolute;
            top: 25px;
            left: 0;
            right: 0;
            height: 4px;
            background-color: #e9ecef;
            z-index: 1;
        }
        
        .status-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
            width: 25%;
        }
        
        .status-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            font-size: 1.2rem;
        }
        
        .status-step.completed .status-icon {
            background-color: var(--success);
            color: white;
            box-shadow: 0 0 0 4px rgba(28, 200, 138, 0.2);
        }
        
        .status-step.active .status-icon {
            background-color: var(--primary);
            color: white;
            animation: pulse 1.5s infinite;
            box-shadow: 0 0 0 4px rgba(78, 115, 223, 0.3);
        }
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(78, 115, 223, 0.4);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(78, 115, 223, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(78, 115, 223, 0);
            }
        }
        
        .status-text {
            font-size: 0.9rem;
            text-align: center;
            color: var(--secondary);
            font-weight: 500;
        }
        
        .status-step.active .status-text,
        .status-step.completed .status-text {
            color: var(--dark);
            font-weight: 600;
        }
        
        .current-status {
            margin-top: 15px;
            padding: 10px 20px;
            border-radius: 30px;
            font-weight: 600;
            display: inline-block;
            font-size: 1rem;
        }
        
        .status-confirmed {
            background-color: rgba(78, 115, 223, 0.15);
            color: var(--primary);
            border: 1px solid rgba(78, 115, 223, 0.3);
        }
        
        .status-packed {
            background-color: rgba(246, 194, 62, 0.15);
            color: var(--warning);
            border: 1px solid rgba(246, 194, 62, 0.3);
        }
        
        .status-out-for-delivery {
            background-color: rgba(54, 185, 204, 0.15);
            color: var(--info);
            border: 1px solid rgba(54, 185, 204, 0.3);
        }
        
        .status-completed {
            background-color: rgba(28, 200, 138, 0.15);
            color: var(--success);
            border: 1px solid rgba(28, 200, 138, 0.3);
        }
        
        .order-details-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 15px;
        }
        
        .order-item-details {
            flex: 1;
        }
        
        .order-item-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .order-item-quantity {
            font-size: 0.9rem;
            color: var(--secondary);
        }
        
        .order-item-price {
            font-weight: 600;
            color: var(--primary);
        }
        
        .delivery-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .delivery-info h6 {
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .delivery-info p {
            margin-bottom: 5px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        
        .summary-row.total {
            font-weight: 700;
            font-size: 1.1rem;
            padding-top: 15px;
            margin-top: 15px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn-primary {
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }
        
        .btn-outline-primary {
            color: var(--primary);
            border-color: var(--primary);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .btn-success {
            background-color: var(--success);
            border-color: var(--success);
        }
        
        .btn-success:hover {
            background-color: #13855c;
            border-color: #13855c;
        }
        
        .footer {
            background-color: var(--dark);
            color: white;
            padding: 50px 0 20px;
            margin-top: 50px;
        }
        
        .footer-col h5 {
            font-size: 1.2rem;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .footer-col h5:after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 2px;
            background-color: var(--primary);
        }
        
        .footer-links {
            list-style: none;
            padding: 0;
        }
        
        .footer-links li {
            margin-bottom: 10px;
        }
        
        .footer-links a {
            color: #ddd;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .footer-links a:hover {
            color: var(--primary);
        }
        
        .social-icons a {
            display: inline-block;
            width: 40px;
            height: 40px;
            background-color: rgba(255,255,255,0.1);
            border-radius: 50%;
            text-align: center;
            line-height: 40px;
            margin-right: 10px;
            color: white;
            transition: background-color 0.3s;
        }
        
        .social-icons a:hover {
            background-color: var(--primary);
        }
        
        .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            font-size: 0.9rem;
        }
        
        /* Feedback Modal Styles */
        .feedback-modal .modal-header {
            background-color: var(--primary);
            color: white;
        }
        
        .rating-container {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }
        
        .rating-star {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .rating-star:hover,
        .rating-star.active {
            color: var(--warning);
        }
        
        .feedback-textarea {
            width: 100%;
            min-height: 120px;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            resize: vertical;
        }
        
        .rating-label {
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .rating-error {
            color: var(--danger);
            font-size: 0.85rem;
            margin-top: 5px;
            display: none;
        }
        
        .rating-container.error {
            border: 1px solid var(--danger);
            border-radius: 5px;
            padding: 10px;
        }
        
        /* Thank You Modal Styles */
        .thank-you-modal .modal-header {
            background-color: var(--success);
            color: white;
        }
        
        .thank-you-icon {
            font-size: 4rem;
            color: var(--success);
            margin: 20px 0;
        }
       </style>
</head>
<body>  

    <!-- Order Confirmation Content -->
   <div class="confirmation-container">
    <div class="container">
        <!-- Success Message -->
        <div class="confirmation-card text-center">
            <i class="fas fa-check-circle success-icon"></i>
            <h2>Thank You for Your Order!</h2>
            <p class="text-muted mb-4">Your order has been placed successfully.</p>
            <div class="order-number">Order #<%= order.getId() %></div>
            <%
			    String status = order.getDelivery_status();
			    int statusRank = 0;
			    if ("CONFIRMED".equals(status)) statusRank = 1;
			    else if ("PACKED".equals(status)) statusRank = 2;
			    else if ("OUT_FOR_DELIVERY".equals(status)) statusRank = 3;
			    else if ("COMPLETED".equals(status)) statusRank = 4;
			%>
            
            <!-- Order Status Indicator -->
					<div class="order-status-container" style="font-family: Arial, sans-serif; padding: 20px; background-color: #f9f9f9; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); max-width: 600px; margin: 0 auto;">
    <h5 class="order-status-title" style="font-size: 18px; font-weight: bold; color: #333; margin-bottom: 20px;">Delivery Status</h5>
    <div class="status-progress" style="display: flex; justify-content: space-between; position: relative;">
        
        <!-- Confirmed Step -->
        <div class="status-step <%= statusRank >= 1 ? "completed" : "" %>" style="display: flex; flex-direction: column; align-items: center;">
            <div class="status-icon" style="background-color: <%= statusRank >= 1 ? "#28a745" : "#ccc" %>; color: white; border-radius: 50%; padding: 10px; margin-bottom: 8px;">
                <i class="fas <%= statusRank >= 1 ? "fa-check" : "fa-check" %>"></i>
            </div>
            <div class="status-text" style="font-size: 14px; color: #333;">Confirmed</div>
        </div>

        <!-- Packed Step -->
        <div class="status-step <%= statusRank >= 2 ? "completed" : "" %>" style="display: flex; flex-direction: column; align-items: center;">
            <div class="status-icon" style="background-color: <%= statusRank >= 2 ? "#28a745" : "#ccc" %>; color: white; border-radius: 50%; padding: 10px; margin-bottom: 8px;">
                <i class="fas <%= statusRank >= 2 ? "fa-check" : "fa-box" %>"></i>
            </div>
            <div class="status-text" style="font-size: 14px; color: #333;">Packed</div>
        </div>

        <!-- Out for Delivery Step -->
        <div class="status-step <%= statusRank >= 3 ? "completed" : "" %>" style="display: flex; flex-direction: column; align-items: center;">
            <div class="status-icon" style="background-color: <%= statusRank >= 3 ? "#28a745" : "#ccc" %>; color: white; border-radius: 50%; padding: 10px; margin-bottom: 8px;">
                <i class="fas <%= statusRank >= 3 ? "fa-check" : "fa-truck" %>"></i>
            </div>
            <div class="status-text" style="font-size: 14px; color: #333;">Out for Delivery</div>
        </div>

        <!-- Completed Step -->
        <div class="status-step <%= statusRank == 4 ? "completed" : "" %>" style="display: flex; flex-direction: column; align-items: center;">
            <div class="status-icon" style="background-color: <%= statusRank == 4 ? "#28a745" : "#ccc" %>; color: white; border-radius: 50%; padding: 10px; margin-bottom: 8px;">
                <i class="fas <%= statusRank == 4 ? "fa-check" : "fa-home" %>"></i>
            </div>
            <div class="status-text" style="font-size: 14px; color: #333;">Completed</div>
        </div>
    </div>

    <div class="current-status" style="margin-top: 20px; padding: 10px; border-radius: 4px; background-color: #e9ecef; text-align: center; font-weight: bold; font-size: 16px; color: #333;">
        <%= order.getDelivery_status() %>
    </div>
</div>
	
			<%if(statusRank != 4 ) {%>
                        <p class="mb-4">Estimated delivery: <strong>3-5 business days</strong></p>
                        <%}else{ %><p class="mb-4">Order Delivered:<strong>Thank you for Shopping!</strong></p> <%} %>
            <div class="d-flex justify-content-center gap-3">
                <a href="/profiledetails" class="btn btn-primary">View Orders</a>
                <a href="/productlist" class="btn btn-outline-primary">Continue Shopping</a>
            </div>
        </div>
        
        <div class="row mt-4">
            <!-- Order Details -->
           <div class="col-lg-8">
    <div class="order-details-card">
        <h4 class="section-title">Order Details</h4>

        <!-- Scrollable container -->
                        <div style="max-height:300px; overflow-y:auto; padding-right:5px;">
                        <%
                            List<OrderItem> items = order.getItems();
                            for (OrderItem item : items) {
                        %>
                            <div class="order-item d-flex mb-3">
                                <img src="/uploads/<%= item.getProduct().getImagePath() %>" class="order-item-img me-3" alt="Product">
                                <div class="flex-grow-1">
                                    <div class="order-item-title"><%= item.getProduct().getName() %></div>
                                    <div class="text-muted"><%= item.getProduct().getCategory() %></div>
                                    <div class="d-flex justify-content-between">
                                        <span>₹<%= item.getPrice() %> × <%= item.getQty() %></span>
                                        <span>₹<%= item.getPrice() * item.getQty() %></span>
                                    </div>
                                </div>
                            </div>
                        <%
                            }
                        %>
                    </div>
            
                    <div class="delivery-info mt-3">
                        <h6><i class="fas fa-truck me-2"></i> Delivery Information</h6>
                        <p><strong>Shipping Address:</strong></p>
                        <p><%= order.getLine1() %><br>
                        <%= order.getCity() %>, <%= order.getPostal() %><br>
                        <%= order.getCountry() %></p>
                        <p><strong>Phone:</strong> <%= order.getPhoneNumber() %></p>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-lg-4">
                <div class="order-details-card">
                    <h4 class="section-title">Order Summary</h4>
                    
                    <div class="summary-row d-flex justify-content-between mb-2">
                        <span>Subtotal</span>
                        <span>₹<%= Math.round(order.getSubtotal() * 100.0) / 100.0 %></span>
                    </div>
                    
                    <div class="summary-row d-flex justify-content-between mb-2">
                        <span>Shipping</span>
                        <span>₹<%= Math.round(order.getShipping() * 100.0) / 100.0 %></span>
                    </div>
                    
                    <div class="summary-row d-flex justify-content-between mb-2">
                        <span>Tax</span>
                        <span>₹<%= Math.round(order.getTax() * 100.0) / 100.0 %></span>
                    </div>
                    
                    <hr>
                    <div class="summary-row d-flex justify-content-between total mb-2">
                        <span><strong>Total</strong></span>
                        <span><strong>₹<%= Math.round(order.getTotal() * 100.0) / 100.0 %></strong></span>
                    </div>
                    
                    <div class="mt-4">
                        <h6><i class="fas fa-credit-card me-2"></i> Payment Method</h6>
                        <p><%= order.getStatus().equals("PAID") ? "Paid Online" : "Cash on Delivery / Pending" %></p>
                    </div>
                    
                    <div class="mt-4">
                        <h6><i class="fas fa-file-invoice me-2"></i> Invoice</h6>
                        <button class="btn btn-success w-100">Download Invoice</button>
                    </div>
                     <!-- Place Feedback -->
                            <% if (feedbackExists == null || !feedbackExists) { %>
								    <button type="button" class="btn btn-primary w-100 mb-2" data-bs-toggle="modal" data-bs-target="#feedbackModal">
								        <i class="fas fa-comment-dots me-1"></i> Place Feedback
								    </button>
								<% } else { %>
								    <button class="btn btn-secondary w-100 mb-2" disabled>
								        <i class="fas fa-check-circle me-1"></i> Feedback Already Submitted
								    </button>
								<% } %>

                            
                            <!-- Cancel Order -->
                            <%
                                // Check if order is within 3 days
                                java.time.LocalDate orderDate = order.getOrderDate().toLocalDate();
                                java.time.LocalDate today = java.time.LocalDate.now();
                                boolean canCancel = java.time.temporal.ChronoUnit.DAYS.between(orderDate, today) <= 3;
                            %>
                            <%
                                if (canCancel && !"CANCELLED".equalsIgnoreCase(order.getStatus())) {
                            %>
                                <a href="#" class="btn btn-danger w-100" >
                                    <i class="fas fa-times-circle me-1"></i> Cancel Order
                                </a>
                            <%
                                } else {
                            %>
                                <button class="btn btn-secondary w-100" disabled>
                                    <i class="fas fa-ban me-1"></i> Cancel Unavailable, 3 days grace period exceeded
                                </button>
                            <%
                                }
                            %>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Feedback Modal -->
<div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content rounded-4 shadow">

      <div class="modal-header border-0">
        <h5 class="modal-title fw-bold" id="feedbackModalLabel">Write Feedback</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <form id="feedbackForm" method="post" action="SubmitFeedback">
        <div class="modal-body pt-0">
          
          <!-- Rating Section -->
          <div class="mb-3 text-center">
            <label class="form-label d-block mb-2">Rate your experience</label>
            <div id="ratingStars" class="fs-3">
              <i class="bi bi-star text-warning" data-value="1"></i>
              <i class="bi bi-star text-warning" data-value="2"></i>
              <i class="bi bi-star text-warning" data-value="3"></i>
              <i class="bi bi-star text-warning" data-value="4"></i>
              <i class="bi bi-star text-warning" data-value="5"></i>
            </div>
            <input type="hidden" id="rating" name="rating" value="0">
          </div>

          <!-- Comment Section with Character Counter -->
          <div class="mb-3">
            <label for="comments" class="form-label">Comments (Optional)</label>
            <textarea 
              class="form-control feedback-textarea" 
              id="comments" 
              name="comments" 
              rows="3" 
              maxlength="500" 
              placeholder="Share your experience with this order..."
            ></textarea>
            <small id="charCount" class="text-muted d-block text-end mt-1">
              500 characters remaining
            </small>
          </div>

          <input type="hidden" name="orderId" id="orderId">

        </div>

        <div class="modal-footer border-0">
          <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary rounded-pill px-4">Submit</button>
        </div>
      </form>

    </div>
  </div>
</div>
    <!-- Thank You Modal -->
    <div class="modal fade thank-you-modal" id="thankYouModal" tabindex="-1" aria-labelledby="thankYouModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="thankYouModalLabel">Thank You!</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-check-circle thank-you-icon"></i>
                    <h4>Thank You for Your Feedback!</h4>
                    <p class="mt-3">We appreciate your input and will use it to improve our services.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
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
	/cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Show thank you modal if feedback was successfully submitted
            const feedbackSuccess = <%= (feedbackSuccess != null && feedbackSuccess) ? "true" : "false" %>;
            if (feedbackSuccess) {
                const thankYouModal = new bootstrap.Modal(document.getElementById('thankYouModal'));
                thankYouModal.show();
            }

            // Rating stars functionality
            const stars = document.querySelectorAll('.rating-star');
            const ratingValue = document.getElementById('ratingValue');
            const ratingContainer = document.getElementById('ratingContainer');
            const ratingError = document.querySelector('.rating-error');
            const feedbackForm = document.getElementById('feedbackForm');
            
            
            
            
            
         // Real-time character counter for comments
            const commentBox = document.getElementById('comments');
            const charCount = document.getElementById('charCount');
            const maxLength = parseInt(commentBox.getAttribute('maxlength'), 10);

            commentBox.addEventListener('input', () => {
                const remaining = maxLength - commentBox.value.length;
                charCount.textContent = `${remaining} characters remaining`;

                // Optional: turn red when near the limit
                if (remaining <= 50) {
                    charCount.classList.add('text-danger');
                } else {
                    charCount.classList.remove('text-danger');
                }
            });

            
            
            
            
            
            const submitButton = document.getElementById('submitFeedback');

            // Handle star clicks
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = this.getAttribute('data-rating');
                    ratingValue.value = rating;
                    updateStars(rating);
                    ratingContainer.classList.remove('error');
                    ratingError.style.display = 'none';
                });

                star.addEventListener('mouseover', function() {
                    const rating = this.getAttribute('data-rating');
                    highlightStars(rating);
                });
            });

            // Reset stars on mouse leave
            ratingContainer.addEventListener('mouseleave', function() {
                const currentRating = ratingValue.value;
                updateStars(currentRating);
            });

            function updateStars(rating) {
                stars.forEach((star, index) => {
                    if (index < rating) {
                        star.classList.add('active');
                    } else {
                        star.classList.remove('active');
                    }
                });
            }

            function highlightStars(rating) {
                stars.forEach((star, index) => {
                    if (index < rating) {
                        star.style.color = 'var(--warning)';
                    } else {
                        star.style.color = '#ddd';
                    }
                });
            }

            // Form submission
            submitButton.addEventListener('click', function() {
                const rating = ratingValue.value;
                
                if (rating === '0') {
                    ratingContainer.classList.add('error');
                    ratingError.style.display = 'block';
                    return;
                }
                
                feedbackForm.submit();
            });
        });
    </script>
</body>

</html>
