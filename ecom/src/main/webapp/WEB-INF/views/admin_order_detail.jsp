<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Order" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="com.example.jpa.model.OrderItem" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details | Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ADMIN.css">
    <style>
        .order-items-table-container {
            max-height: 480px; /* approx 6 rows */
            overflow-y: auto;
        }
    </style>
</head>
<body>
<%
	Account currentUser = (Account) session.getAttribute("currentUser");
    Order order = (Order) request.getAttribute("order");
	int count = (int) request.getAttribute("orderSize");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
%>
<div class="container-fluid">
    <div class="row">
       <!-- Sidebar -->
<nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-tachometer-alt me-2"></i> Admin Dashboard</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-home me-2"></i> THIS IS</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-plus-circle me-2"></i> ORDER DETAIL</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-plus-circle me-2"></i> PAGE</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-users me-2"></i> SET TO </a></li>
            <li class="nav-item"><a class="nav-link active text-white" href="#"><i class="fas fa-shopping-bag me-2"></i> READ ONLY MODE</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-comments me-2"></i> CLOSE THE TAB</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-sign-out-alt me-2"></i>TO GO BACK</a></li>
        </ul>
    </div>
</nav>


        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
            <!-- Topbar -->
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
                    <i class="fas fa-bars"></i>
                </button>
                <div class="d-flex align-items-center">
                    <h4 class="mb-0 me-3">Order Details</h4>
                    <button class="btn btn-secondary" onclick="confirmClose()">Close Tab</button>
                    <script>
							function confirmClose() {
							    if (confirm("Are you sure? You will go back to Order page!")) {
							        window.open('', '_self'); // Some browsers require this line
							        window.close();
							    }
							}
					</script>
                </div>
                <div>
                     <a class="navbar-brand" href="#">
                        <i class="fas fa-shopping-bag me-2"></i>ShopHub
                    </a>
                </div>
                <!-- User Info Section (Logged In As) -->
    <div class="d-flex align-items-center">
        <%
            String userEmail = currentUser.getEmail();
            if (userEmail != null) {
        %>
            <!-- Show logged-in email -->
            <div class="d-flex align-items-center">
                <span class="me-3">Logged in as: <strong><%= userEmail %></strong></span>
            </div>
        <%
            }
        %>
    </div>
            </div>

            <div class="row">
                <!-- Left Column: Order Info + Summary -->
                <div class="col-md-5">
                    <!-- Order Information -->
                    <div class="card mb-4">
                        <div class="card-header"><h5 class="mb-0">Order Information</h5></div>
                        <div class="card-body">
                            <div class="mb-3"><strong>Order ID:</strong> #<%= order.getId()%> WITH <strong><%= count %> items</strong></div>
                            <div class="mb-3"><strong>Order Date:</strong> <%= order.getOrderDate() %></div>
                            <div class="mb-3">
                                <strong>Status:</strong>
                                <span class="badge 
                                    <%= "COMPLETED".equals(order.getDelivery_status()) ? "bg-success" : 
                                        "OUT_FOR_DELIVERY".equals(order.getDelivery_status()) ? "bg-warning" : 
                                        "PACKED".equals(order.getDelivery_status()) ? "bg-info" : "bg-danger" %>">
                                    <%= order.getDelivery_status() %>
                                </span>
                            </div>
                            <div class="mb-3"><strong>Payment Method:</strong> ONLINE</div>
                            <div class="mb-3"><strong>Customer:</strong> <%= order.getAccount().getName() %></div>
                            <div class="mb-3"><strong>Shipping Address:</strong>
                                <p class="mb-1"><%= order.getLine1() %></p>
                                <p class="mb-1"><%= order.getCity() %>, <%= order.getPostal() %></p>
                                <p class="mb-1"><%= order.getCountry() %></p>
                                <p class="mb-1">Phone: <%= order.getPhoneNumber() %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Order Summary -->
                    <div class="card mb-4">
                        <div class="card-header"><h5 class="mb-0">Order Summary</h5></div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2"><span>Subtotal:</span><span>₹<%= order.getSubtotal() %></span></div>
                            <div class="d-flex justify-content-between mb-2"><span>Shipping:</span><span>₹<%= order.getShipping() %></span></div>
                            <div class="d-flex justify-content-between mb-2"><span>Tax:</span><span>₹<%= order.getTax() %></span></div>
                            <hr>
                            <div class="d-flex justify-content-between"><strong>Total:</strong><strong>₹<%= order.getTotal() %></strong></div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Order Items Table -->
                <div class="col-md-7">
                    <div class="card mb-4">
                        <div class="card-header"><h5 class="mb-0">Order Items</h5></div>
                        <div class="card-body p-0 order-items-table-container">
                            <table class="table table-striped table-hover mb-0" style="border-collapse: separate; table-layout: fixed; width: 100%;">
                                <thead class="table-light" style="position: sticky; top: 0; z-index: 1;">
                                    <tr>
                                        <th>Product</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    if (orderItems != null && !orderItems.isEmpty()) {
                                        for (OrderItem item : orderItems) {
                                %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="/uploads/<%= item.getProduct().getImagePath() %>" 
                                                     alt="<%= item.getProduct().getName() %>" 
                                                     class="img-thumbnail me-2" 
                                                     style="width: 50px; height: 50px; object-fit: cover;">
                                                <div><%= item.getProduct().getName() %></div>
                                            </div>
                                        </td>
                                        <td><%= item.getProduct().getCategory() %></td>
                                        <td>₹<%= item.getPrice() %></td>
                                        <td><%= item.getQty() %></td>
                                        <td>₹<%= item.getPrice() * item.getQty() %></td>
                                    </tr>
                                <%
                                        }
                                    } else {
                                %>
                                    <tr>
                                        <td colspan="5" class="text-center"><h5>No items found!</h5></td>
                                    </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-between mt-4">
                <button class="btn btn-primary"><i class="fas fa-file-pdf me-1"></i> Download Invoice</button>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
