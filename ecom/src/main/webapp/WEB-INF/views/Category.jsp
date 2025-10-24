<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Category" %>
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
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/ADMIN.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
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
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Topbar -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
                        <i class="fas fa-bars"></i>
                    </button>
                   <!-- <div class="input-group" style="max-width: 300px;">
                        <input type="text" class="form-control" placeholder="Search category...">
                        <button class="btn btn-outline-secondary" type="button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    -->                     
                    
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
                
                <!-- Dashboard Cards -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card text-white bg-primary mb-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <h4 class="card-title">Segment with Most Products! </h4>
                                    <p>Category with most products: <strong>${catnm}</strong> (${catct} products)</p>
								</div>
                                <div class="fs-1">
                                    <i class="fas fa-users"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card text-white bg-success mb-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <h4 class="card-title"><strong>${totalcat}</strong> Active Segments on the site!</h4>
                                    <p class="card-text">Total Categories for the Cutomer to Shop!</p>
                                </div>
                                <div class="fs-1">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Product Table -->
 <div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">Category Details</h5>
        <a href="/addCat" class="btn btn-primary btn-sm">Add New</a>
    </div>
    <div class="card-body">
        <div class="row">
            <%
                List<Category> categoryList = (List<Category>) request.getAttribute("category");
                if (categoryList != null && !categoryList.isEmpty()) {
                    for (Category cat : categoryList) {
            %>
            <div class="col-md-3 mb-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body d-flex flex-column align-items-center text-center">
                        <a href="/viewitem?category=<%= java.net.URLEncoder.encode(cat.getCategory(), "UTF-8") %>">
                            <img src="/uploads/<%= cat.getImage() %>" 
                                 class="img-fluid mb-3 rounded" 
                                 alt="Category Image" 
                                 style="width: 100px; height: 100px; object-fit: cover;">
                        </a>
                        <h6 class="text-uppercase fw-bold mb-1"><%= cat.getCategory() %></h6>
                        <p class="text-muted mb-2">ID: <%= cat.getId() %></p>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/editCategory/<%= cat.getId() %>" class="btn btn-warning btn-sm">Edit</a>

                            <% if (!"RANDOM FINDS".equalsIgnoreCase(cat.getCategory())) { %>
                                <a href="/deletecat/<%= cat.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure? **Product under this category will be moved to miscellaneous section**');">
                                   Delete
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="col-12">
                <p class="text-danger">No categories found.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>
            
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>