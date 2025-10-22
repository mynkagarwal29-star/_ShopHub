<%@ page import="com.example.jpa.model.Order" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.OrderItem" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="com.example.jpa.service.PaymentService" %>
<%@ page import="java.util.List" %>
<% 
    Account currentUser = (Account) session.getAttribute("currentUser");
    Order order = (Order) request.getAttribute("order"); 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details | ShopHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${ pageContext.request.contextPath}/css/HOME.CSS">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--dark-color);
            background-color: #f5f7ff;
        }
        
        .navbar {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color) !important;
            font-size: 1.5rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        .account-sidebar {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .account-sidebar .nav-link {
            color: var(--dark-color);
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 5px;
        }
        
        .account-sidebar .nav-link:hover {
            background-color: var(--light-color);
        }
        
        .account-sidebar .nav-link.active {
            background-color: var(--primary-color);
            color: white;
        }
        
        .order-details-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            margin-bottom: 20px;
        }

        .order-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .status-delivered {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-processing {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            top: 0;
            left: 8px;
            height: 100%;
            width: 2px;
            background: #e9ecef;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -30px;
            top: 5px;
            height: 16px;
            width: 16px;
            border-radius: 50%;
            background: white;
            border: 2px solid var(--primary-color);
        }
        
        .timeline-item.completed::before {
            background: var(--primary-color);
        }
        
        .timeline-item:last-child::before {
            background: #e9ecef;
            border-color: #e9ecef;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
            margin-right: 15px;
        }

       .scrollable-items {
    max-height: 400px;
    overflow-y: auto;
    position: relative;
}

.scrollable-items h4 {
    position: sticky;
    top: 0;
    background-color: white; /* same as container bg */
    padding: 15px 0;
    z-index: 10;
    border-bottom: 1px solid #eee;
}


        .footer {
            background-color: var(--dark-color);
            color: white;
            padding: 40px 0;
            margin-top: 50px;
        }
        
        .footer h5 {
            color: var(--success-color);
            font-weight: 600;
        }
        
        .footer a {
            color: #adb5bd;
            text-decoration: none;
        }
        
        .footer a:hover {
            color: white;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="fas fa-shopping-bag me-2"></i>ShopHub
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
    <li class="nav-item"><a class="nav-link" href="#" data-target="/">Home</a></li>
    <li class="nav-item"><a class="nav-link" href="#" data-target="/productlist">Products</a></li>
    <li class="nav-item"><a class="nav-link" href="#" data-target="/user_category">Categories</a></li>
    <li class="nav-item"><a class="nav-link" href="#" data-target="/about">About</a></li>
    <li class="nav-item"><a class="nav-link" href="#" data-target="/contactus">Contact</a></li>
</ul>


            <div class="d-flex align-items-center gap-2 ms-3">
                <!-- Show cart button -->
                <a href="/orders/edit?orderId=<%= order.getId() %>"
                   class="btn btn-gradient-primary d-flex align-items-center gap-2 position-relative">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Cart</span>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        ${cartCount != null ? cartCount : 0}
                    </span>
                </a>
                       <a href="#" data-target="/profiledetails" class="btn btn-gradient-primary d-flex align-items-center gap-2">
                        Welcome: <%= currentUser != null ? currentUser.getName() : "" %>
                    </a>
                  
            </div>
        </div>
    </div>
</nav>

    <!-- Main Content -->
<!-- Main Content -->
<div class="container my-5">
    <div class="row">
        <!-- Order Details and Items -->
        <div class="col-md-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Order Details</h2>
            </div>

            <!-- Payment and Cart Buttons or Cancel Button -->
            <div class="d-flex justify-content-between align-items-center mt-4">
               
                    <form action="/api/payment/createRazorpayorder" method="post">
                        <input type="hidden" name="orderId" value="<%= order.getId() %>">
                        <input type="hidden" name="amount" value="<%= Math.round(order.getTotal() * 100.0f) / 100.0f %>">
                        <input type="hidden" name="name" value="<%= order.getAccount().getName() %>">
                        <input type="hidden" name="email" value="<%= order.getAccount().getEmail() %>">
                        <input type="hidden" name="contact" value="<%= order.getPhoneNumber() %>">
                        <button type="submit" class="btn btn-primary">All set! Proceed to Payment</button>
                    </form>
                    <a href="/orders/edit?orderId=<%= order.getId() %>" class="btn btn-outline-primary">Want to edit? Go back to Cart</a>
            </div>

            <div class="row mt-4">
                <!-- Order Summary -->
                <div class="col-md-6">
                    <div class="order-details-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h4 class="mb-1">Order #<%= order.getId() %></h4>
                                <p class="text-muted mb-0">Placed on <%= order.getOrderDate() %></p>
                            </div>
                            <span class="order-status"><%= order.getStatus() %></span>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-12">
                                <h5 class="mb-3">Shipping Address</h5>
                                <p class="mb-1"><%= order.getLine1() %></p>
                                <p class="mb-1"><%= order.getCity() %>, <%= order.getPostal() %></p>
                                <p class="mb-1"><%= order.getCountry() %></p>
                                <p class="mb-1">Phone: <%= order.getPhoneNumber() %></p>
                            </div>
                        </div>

                        <h5 class="mb-3">Order Summary</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal</span>
                            <span>₹<%= Math.round(order.getSubtotal() * 100.0f) / 100.0f %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping</span>
                            <span>₹<%= Math.round(order.getShipping() * 100.0f) / 100.0f %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Tax</span>
                            <span>₹<%= Math.round(order.getTax() * 100.0f) / 100.0f %></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span><strong>Total</strong></span>
                            <span><strong>₹<%= Math.round(order.getTotal() * 100.0f) / 100.0f %></strong></span>
                        </div>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="col-md-6">
                  <h4 class="mb-4">Order Items</h4>
                    <div class="order-details-card scrollable-items">
                        <%
                            List<OrderItem> items = order.getItems();
                            for (OrderItem item : items) {
                        %>
                            <div class="order-item d-flex mb-3">
                                <img src="/uploads/<%= item.getProduct().getImagePath() %>" alt="Product" style="width: 80px; height: auto; margin-right: 15px;">
                                <div class="flex-grow-1">
                                    <h5 class="mb-1"><%= item.getProduct().getName() %></h5>
                                    <p class="text-muted mb-1"><%= item.getProduct().getCategory() %></p>
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
                </div>
            </div>

        </div>
    </div>
</div>


    <!-- Footer -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <form id="editOrderForm" action="/orders/edit" method="get" style="display:none;">
    <input type="hidden" name="orderId" value="<%= order.getId() %>">
</form>
    <script>
document.addEventListener('DOMContentLoaded', () => {
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
    const form = document.getElementById('editOrderForm');

    navLinks.forEach(link => {
        link.addEventListener('click', event => {
            event.preventDefault();
            const targetUrl = link.getAttribute('data-target');

            // Modify form action to include redirect parameter
            const actionWithRedirect = form.action + "?orderId=" + form.orderId.value + "&redirectTo=" + encodeURIComponent(targetUrl);
            
            // Submit via JS (can be improved via AJAX if needed)
            window.location.href = actionWithRedirect;
        });
    });
});
</script>
    
</body>
</html>