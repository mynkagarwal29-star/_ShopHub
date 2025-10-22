<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Category" %>
<%@ page import="com.example.jpa.model.Account" %>
<%
    Category cat = (Category) request.getAttribute("cat");  // will be null if adding
    Account currentUser = (Account) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect("/log");
        return;
    }

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title><%= (cat == null) ? "Add Category" : "Edit Category" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
 	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/FORM.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar (same as dashboard) -->
                 <!-- Sidebar (same as dashboard) -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active text-white" href="#">
                                <i class="fas fa-tachometer-alt me-2"></i> Admin Dashboard
                            </a>
                        </li>
        
            <li class="nav-item">
                <a class="nav-link text-white" href="#">
                    <i class="fas fa-home me-2"></i> EDIT MODE
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="#">
                    <i class="fas fa-plus-circle me-2"></i> HERE YOU CAN
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="#">
                    <i class="fas fa-plus-circle me-2"></i> ONLY EDIT/ADD
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="#">
                    <i class="fas fa-users me-2"></i> CATEGORY
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="#">
                    <i class="fas fa-shopping-bag me-2"></i> AND LEAVE
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="#">
                    <i class="fas fa-comments me-2"></i> AFTER
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-white" href="#">
                    <i class="fas fa-sign-out-alt me-2"></i> SAVING IT
                </a>
            </li>
        </ul>
    </div>
</nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <!-- Topbar (same as dashboard) -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
                        <i class="fas fa-bars"></i>
                    </button>
                    <!-- <div class="input-group" style="max-width: 300px;">
                        <input type="text" class="form-control" placeholder="Search products...">
                        <button class="btn btn-outline-secondary" type="button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>  -->
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
                <!-- Add Product Form -->
                <div class="form-container">
                    <h2 class="form-title"><%= (cat == null) ? "Add New Category" : "Edit Category" %></h2>
                    <h4>${added}</h4>
                    <form action="<%= (cat == null) ? "addCategory" : "/updateCategory" %>" method="post" enctype="multipart/form-data">
                    
                    	<% if (cat != null) { %>
				            <input type="hidden" name="id" value="<%= cat.getId() %>">
				        <% } %>
                    	
                        <div class="row form-row">
                           <div class="col-md-6">
							    <label for="productName" class="form-label required">Category Name</label>
							    <input 
							        type="text" 
							        class="form-control" 
							        id="productName" 
							        name="category" 
							        value="<%= (cat != null) ? cat.getCategory() : "" %>" 
							        <%= (cat != null && "RANDOM FINDS".equalsIgnoreCase(cat.getCategory())) ? "readonly" : "required" %>>
							    
							    <% if (cat != null && "RANDOM FINDS".equalsIgnoreCase(cat.getCategory())) { %>
							        <small class="text-muted">This category name cannot be edited.</small>
							    <% } %>
							</div>
                        </div>
                        <div class="form-row">
                            <label for="CategoryImage" class="form-label">Category Image</label>
                            <input type="file" class="form-control" id="productImage" name="file" accept="image/*" >
                             <% if (cat != null && cat.getImage() != null) { %>
					            <p>Current Image:</p>
					            <img src="/uploads/<%= cat.getImage() %>" width="100" height="100">
					            <br><br>
					        <% } else {%>
                            <img id="imagePreview" class="image-preview" alt="Preview">
                            <%} %>
                        </div>
                        <div class="d-flex justify-content-between mt-4">
                            <a href="/Category" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i> Back to Category
                            </a>
                            <button type="submit" class="btn btn-primary btn-submit">
                                <i class="fas fa-save me-2"></i> <%= (cat == null) ? "Add Category" : "Update Category" %>
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Image preview functionality
        document.getElementById('productImage').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    const preview = document.getElementById('imagePreview');
                    preview.src = event.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html>