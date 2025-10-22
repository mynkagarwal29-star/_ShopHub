<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Order" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="java.util.*" %>
<% Account currentUser = (Account) session.getAttribute("currentUser");
if (currentUser == null || !"admin".equals(currentUser.getRole())) {
    response.sendRedirect("/log");
    return;
} %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Orders | Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ADMIN.css">
    <style>
        .table-container {
            position: relative;
        }
        
        .table-scrollable {
            max-height: 350px;
            overflow-y: auto;
            display: block;
        }
        
        .table-scrollable thead, .table-scrollable tbody {
            display: table;
            width: 100%;
            table-layout: fixed;
        }
        
        .action-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
            margin: 0 0.25rem;
        }
        
        .status-badge {
            font-size: 0.75rem;
            padding: 0.35em 0.65em;
        }
        
        .delivery-status-form {
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">
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
                            <a class="nav-link active text-white" href="AdminSideOrder">
                                <i class="fas fa-shopping-bag me-2"></i> View Orders
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="feed">
                                <i class="fas fa-comments me-2"></i> View Feedback
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Topbar -->
               <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
    <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
        <i class="fas fa-bars"></i>
    </button>

    <div class="d-flex align-items-center">
        <a class="navbar-brand" href="#">
            <i class="fas fa-shopping-bag me-2"></i>ShopHub
        </a>
    </div>

    <form action="instantdetail" method="post" target="blank" class="d-flex align-items-center">
        <div class="form-group mb-0 me-2">
         <!-- Preserve filter parameters -->
		<input type="hidden" name="userId" value="<%= request.getParameter("userId") != null ? request.getParameter("userId") : "" %>">
		<input type="hidden" name="userName" value="<%= request.getParameter("userName") != null ? request.getParameter("userName") : "" %>">
		<input type="hidden" name="status" value="<%= request.getParameter("status") != null ? request.getParameter("status") : "" %>">
												       
            <label for="orderId" class="visually-hidden">Enter Order ID:</label>
            <input type="text" class="form-control" name="orderId" id="orderId" placeholder="Enter Order ID" value="${not empty param.orderId ? param.orderId : ''}">
        </div>
        <button type="submit" class="btn btn-primary">Get Details</button>
    </form>
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

                
               <!-- Dashboard Cards -->
<div class="row mb-4 g-3">
    <div class="col-md-2 col-sm-6">
        <div class="card text-white bg-primary dashboard-card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="card-title mb-0">${totalOrders}</h4>
                    <p class="card-text mb-0">Total Orders Placed</p>
                </div>
                <i class="fas fa-shopping-bag fs-1"></i>
            </div>
        </div>
    </div>

    <div class="col-md-2 col-sm-6">
        <div class="card text-white bg-info dashboard-card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="card-title mb-0">${confirmedOrders}</h4>
                    <p class="card-text mb-0">Orders Confirmed</p>
                </div>
                <i class="fas fa-clipboard-check fs-1"></i>
            </div>
        </div>
    </div>

    <div class="col-md-2 col-sm-6">
        <div class="card text-white bg-warning dashboard-card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="card-title mb-0">${packedOrders}</h4>
                    <p class="card-text mb-0">Orders Packed</p>
                </div>
                <i class="fas fa-box-open fs-1"></i>
            </div>
        </div>
    </div>

    <div class="col-md-2 col-sm-6">
        <div class="card text-white bg-secondary dashboard-card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="card-title mb-0">${shippedOrders}</h4>
                    <p class="card-text mb-0">Out for Delivery</p>
                </div>
                <i class="fas fa-truck fs-1"></i>
            </div>
        </div>
    </div>

    <div class="col-md-2 col-sm-6">
        <div class="card text-white bg-success dashboard-card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="card-title mb-0">${completedOrders}</h4>
                    <p class="card-text mb-0">Completed Orders</p>
                </div>
                <i class="fas fa-check-circle fs-1"></i>
            </div>
        </div>
    </div>

    <div class="col-md-2 col-sm-6">
        <div class="card text-white bg-danger dashboard-card">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="card-title mb-0">${cancelledOrders}</h4>
                    <p class="card-text mb-0">Cancelled by Customer</p>
                </div>
                <i class="fas fa-times-circle fs-1"></i>
            </div>
        </div>
    </div>
</div>
                <!-- Orders Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Order Details</h5> 
                         <!-- Filter Section -->
                
                        <form action="AdminSideOrder" method="get" class="row g-3">
                            <div class="col-md-4">
                                <label for="userId" class="form-label">User ID</label>
                                <input type="text" class="form-control" id="userId" name="userId" 
                                       placeholder="Enter User ID" value="${not empty param.userId ? param.userId : ''}">
                            </div>
                            <div class="col-md-4">
                                <label for="userName" class="form-label">User Name</label>
                                <input type="text" class="form-control" id="userName" name="userName" 
                                       placeholder="Enter User Name" value="${not empty param.userName ? param.userName : ''}">
                            </div>
                            <div class="col-md-4">
                                <label for="status" class="form-label">Delivery Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="" ${empty param.status ? 'selected' : ''}>All Status</option>
                                    <option value="CONFIRMED" ${param.status eq 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                    <option value="PACKED" ${param.status eq 'PACKED' ? 'selected' : ''}>Packed</option>
                                    <option value="OUT_FOR_DELIVERY" ${param.status eq 'OUT_FOR_DELIVERY' ? 'selected' : ''}>Out for Delivery</option>
                                    <option value="COMPLETED" ${param.status eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-filter me-1"></i> Apply Filters
                                </button>
                                <a href="AdminSideOrder" class="btn btn-secondary">
                                    <i class="fas fa-redo me-1"></i> Reset
                                </a>
                                <a href="trainer" class="btn btn-primary btn-sm">
                                View Users
                            	</a>
                            </div>
                        </form>

                    <!--     <h6 style="
                            background-color: #d4edda;
                            color: #155724;
                            border: 1px solid #c3e6cb;
                            padding: 10px 20px;
                            border-radius: 12px;
                            margin-bottom: 15px;
                            font-weight: 500;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                            display: inline-block;
                            font-family: 'Segoe UI', sans-serif;">${msg}</h6> -->
                    </div>
                   
                    <div class="card-body p-0">
                        <div class="table-container">
                            <table class="table table-striped table-hover mb-0" style="border-collapse: separate; table-layout: fixed; width: 100%;">
                                <thead class="table-light" style="position: sticky; top: 0; z-index: 1;">
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Total</th>
                                        <th>Payment</th>
                                        <th>Item Count</th>
                                        <th>Delivery Status</th>
                                        <th colspan="2">Actions</th>
                                    </tr>
                                </thead>
                            </table>
                            <div style="max-height: 350px; overflow-y: auto; border-top: none;">
                                <table class="table table-striped table-hover mb-0" style="table-layout: fixed; width: 100%;">
                                    <tbody>
                                        <%
                                            List<Order> orderList = (List<Order>) request.getAttribute("data");
                                            if (orderList != null && !orderList.isEmpty()) {
                                                for (Order order : orderList) {
                                        %>                        
                                        <tr style="border-bottom: 1px solid #eee;">
                                            <td style="padding: 10px; color: #555;"><%= order.getId() %></td>
                                            <td style="padding: 10px; color: #555;"><%= order.getAccount().getName() %></td>
                                            <td style="padding: 10px; color: #555;"><%= order.getOrderDate() %></td>
                                            <td style="padding: 10px; color: #555;">₹<%= order.getTotal() %></td>
                                            <td style="padding: 10px; color: #555;"><%= order.getRazorpayPaymentId() %></td>
                                           <td style="padding: 10px; color: #555;">
											    <span class="badge bg-success status-badge">
											        <%= order.getItems().size() %>
											    </span>                                 
											</td>
                                            <td style="padding: 10px; color: #555;">
                                                <form method="post" action="updateDeliveryStatus" class="delivery-status-form">
                                                 <!-- Preserve filter parameters -->
												    <input type="hidden" name="userId" value="<%= request.getParameter("userId") != null ? request.getParameter("userId") : "" %>">
												    <input type="hidden" name="userName" value="<%= request.getParameter("userName") != null ? request.getParameter("userName") : "" %>">
												    <input type="hidden" name="status" value="<%= request.getParameter("status") != null ? request.getParameter("status") : "" %>">
												                                                
                                                    <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                                    <select name="deliveryStatus" class="form-select form-select-sm" onchange="this.form.submit()">
                                                        <option value="CONFIRMED" <%= "CONFIRMED".equals(order.getDelivery_status()) ? "selected" : "" %>>Confirmed</option>
                                                        <option value="PACKED" <%= "PACKED".equals(order.getDelivery_status()) ? "selected" : "" %>>Packed</option>
                                                        <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equals(order.getDelivery_status()) ? "selected" : "" %>>Out for Delivery</option>
                                                        <option value="COMPLETED" <%= "COMPLETED".equals(order.getDelivery_status()) ? "selected" : "" %>>Completed</option>
                                                    </select>
                                                </form>
                                            </td>
                                            <td style="padding: 10px;">
                                                <a href="/viewOrder/<%= order.getId() %>" target="blank" class="btn btn-sm btn-primary action-btn">
                                                    <i class="fas fa-eye me-1"></i> View
                                                </a>
                                            </td>
                                            <td style="padding: 10px;">
                                                <a href="/deleteOrder/<%= order.getId() %>" class="btn btn-sm btn-danger action-btn" onclick="return confirm('Are you sure you want to delete this order? It is recommended to keep them for statistics');">
                                                    <i class="fas fa-trash-alt me-1"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="9" style="padding: 15px; text-align: center;"><h4>No records found!</h4></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>