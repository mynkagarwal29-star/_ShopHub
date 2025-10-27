<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Category" %>
<%@ page import="com.example.jpa.model.Account" %>

<%
    Category cat = (Category) request.getAttribute("cat");  // null if adding new
    Account currentUser = (Account) session.getAttribute("currentUser");

    // ✅ Ensure only admins can access
    if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("/log");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (cat == null) ? "Add Category" : "Edit Category" %> | Admin Panel</title>

    <!-- Bootstrap & Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FORM.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">

            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column text-white">
                        <li class="nav-item"><a class="nav-link active text-white" href="#"><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-edit me-2"></i>Edit Mode</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-plus-circle me-2"></i>You Can Add/Edit</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-tags me-2"></i>Categories</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="#"><i class="fas fa-save me-2"></i>Save & Exit</a></li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <!-- Sidebar toggle button -->
                    <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
                        <i class="fas fa-bars"></i>
                    </button>

                    <!-- Branding -->
                    <div class="fw-bold fs-4">
                        <i class="fas fa-store me-2 text-primary"></i>ShopHub Admin
                    </div>

                    <!-- User Info -->
                    <div class="text-muted small">
                        Logged in as: <strong><%= currentUser.getEmail() %></strong>
                    </div>
                </div>

                <!-- Form Container -->
                <div class="form-container">
                    <h2 class="form-title mb-4">
                        <%= (cat == null) ? "Add New Category" : "Edit Category" %>
                    </h2>

                    <form action="${pageContext.request.contextPath}/<%= (cat == null) ? "addCategory" : "updateCategory" %>"
                          method="post"
                          enctype="multipart/form-data"
                          class="needs-validation" novalidate>

                        <% if (cat != null) { %>
                            <input type="hidden" name="id" value="<%= cat.getId() %>">
                        <% } %>

                        <!-- Category Name -->
                        <div class="mb-3 col-md-6">
                            <label for="productName" class="form-label required">Category Name</label>
                            <input
                                type="text"
                                class="form-control"
                                id="productName"
                                name="category"
                                maxlength="250"
                                value="<%= (cat != null) ? cat.getCategory() : "" %>"
                                <%= (cat != null && "RANDOM FINDS".equalsIgnoreCase(cat.getCategory())) ? "readonly" : "required" %>>
                            
                            <div class="d-flex justify-content-between">
                                <small id="charCount" class="text-muted">0 / 250</small>
                                <% if (cat != null && "RANDOM FINDS".equalsIgnoreCase(cat.getCategory())) { %>
                                    <small class="text-warning">This category cannot be edited.</small>
                                <% } %>
                            </div>
                        </div>

                        <!-- Category Image -->
                        <div class="mb-3">
                            <label for="productImage" class="form-label">Category Image</label>
                            <input type="file" class="form-control" id="productImage" name="file" accept="image/*">

                            <% if (cat != null && cat.getImage() != null) { %>
                                <div class="mt-2">
                                    <p>Current Image:</p>
                                    <img src="/uploads/<%= cat.getImage() %>" width="100" height="100" class="rounded border">
                                </div>
                            <% } else { %>
                                <img id="imagePreview" class="image-preview mt-2 rounded border" alt="Preview" style="display:none;" width="100" height="100">
                            <% } %>
                        </div>

                        <!-- Buttons -->
                        <div class="d-flex justify-content-between mt-4">
                            <a href="/Category" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Back to Category
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i><%= (cat == null) ? "Add Category" : "Update Category" %>
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Image preview & Character counter -->
    <script>
        // Live image preview
        const productImage = document.getElementById('productImage');
        const preview = document.getElementById('imagePreview');

        if (productImage) {
            productImage.addEventListener('change', e => {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = event => {
                        preview.src = event.target.result;
                        preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                }
            });
        }

        // Live character counter
        const input = document.getElementById("productName");
        const counter = document.getElementById("charCount");

        function updateCount() {
            counter.textContent = `${input.value.length} / 250`;
            if (input.value.length >= 250) {
                counter.classList.add("text-danger");
            } else {
                counter.classList.remove("text-danger");
            }
        }

        input.addEventListener("input", updateCount);
        document.addEventListener("DOMContentLoaded", updateCount);
    </script>
</body>
</html>
