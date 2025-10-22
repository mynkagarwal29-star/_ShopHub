 <%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@page import="java.util.*" %>
<%@page import="com.example.jpa.model.Product" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@page import="com.example.jpa.model.Category" %>
<%
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
    <title>Add Product - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FORM.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
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
                            <a class="nav-link text-white" href="/viewitem">
                                <i class="fas fa-home me-2"></i> EDIT MODE
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="/addForm">
                                <i class="fas fa-plus-circle me-2"></i> HERE YOU CAN
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="/Category">
                                <i class="fas fa-plus-circle me-2"></i> ONLY EDIT
                            </a>
                        </li>
                      <li class="nav-item">
                            <a class="nav-link text-white" href="trainer">
                                <i class="fas fa-users me-2"></i> PRODUCT
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="AdminSideOrder">
                                <i class="fas fa-shopping-bag me-2"></i> AND LEAVE
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="feed">
                                <i class="fas fa-comments me-2"></i> AFTER 
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="./Login.jsp">
                                <i class="fas fa-sign-out-alt me-2"></i> SAVING IT
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <!-- Topbar (same as dashboard) -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
                        <i class="fas fa-bars"></i>
                    </button>
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

                <!-- Update Product Form -->
                  <%
                        Product product=(Product)request.getAttribute("product");
                        if(product!=null)
                        {
                    %>
                <div class="form-container">
                    <h2 class="form-title">Update Product</h2>
                    
                    <form action="/updateProduct" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="id" value="<%= product.getId() %>" />
                        <div class="row form-row">
                            <div class="col-md-6">
                                <label for="productName" class="form-label required">Product Name</label>
                                <input type="text" class="form-control" id="productName" name="name"  value="<%=product.getName() %>">
                            </div>
                            <div class="col-md-6">
                                <label for="category" class="form-label readonly">Category</label>
                                <%if(!(product.getCategory().equals("MISCELLANEOUS") || product.getCategory().equals("RANDOM FINDS"))){ %>
                                 <input type="text" id="category" name="category"  value="<%=product.getCategory() %>" readonly />
                                 <%} else {%>
                                             <select     class="form-select"
                                            id="category"
                                            name="category"
                                            required
                                            style="overflow-y: auto;"
                                            onfocus="this.size=5;"
                                            onblur="this.size=1;"
                                            onchange="this.size=1; this.blur();">
                                        <option value="">Select Category</option>
                                        <%
                                            List<Category> categories = (List<Category>) request.getAttribute("category");
                                            if (categories != null) {
                                                for (Category cat : categories) {
                                                	if(cat.getCategory().equals("MISCELLANEOUS")) continue;
                                                	// Set selected if current category matches
                                                	String selected = cat.getCategory().equals(product.getCategory()) ? "selected" : "";
                                        %>
                                            <option value="<%= cat.getCategory() %>" <%= selected %>><%= cat.getCategory() %></option>
                                        <%
                                                }
                                            }
                                        %>
                                </select>
                                 <%} %>
                             </div>
                        </div>
                        <div class="row form-row">
                            <div class="col-md-6">
                                <label for="quantity" class="form-label required">Quantity</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" min="1" value="<%=product.getQuantity() %>">
                            </div>
                            <div class="col-md-6">
                                <label for="price" class="form-label required">Price ($)</label>
                                <input type="number" class="form-control" id="price" name="price" step="0.01" min="0.01" value="<%=product.getPrice() %>">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4"> <%=product.getDescription() %> </textarea>
                        </div>
                        
                        <div class="form-row">
                            <label for="productImage" class="form-label">Current Image:</label>
                                    <br/>
                                     <img src="/uploads/<%= product.getImagePath() %>" width="100" height="100">
                                    <br/>
                            <label for="productImage" class="form-label">Product Image</label>
                            <input type="file" class="form-control" id="productImage" name="file" accept="image/*">
                            <img id="imagePreview" class="image-preview" alt="Preview">
                        </div>
                        
                        <div class="d-flex justify-content-between mt-4">
                            <a href="/viewitem" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i> Back to Products
                            </a>
                            <button type="submit" class="btn btn-primary btn-submit">
                                <i class="fas fa-save me-2"></i> Save Product
                            </button>
                        </div>
                        <% 
                        }
                        %>
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