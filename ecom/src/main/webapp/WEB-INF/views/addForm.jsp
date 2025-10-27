<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Category" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="java.util.*" %>

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
    <style>
        .char-counter {
            font-size: 0.85rem;
            text-align: right;
            margin-top: 4px;
        }
        .char-counter.warning {
            color: #dc3545;
            font-weight: 600;
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
                    <li class="nav-item"><a class="nav-link active text-white"><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="viewitem"><i class="fas fa-home me-2"></i>Home</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="addForm"><i class="fas fa-plus-circle me-2"></i>Add Product</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="Category"><i class="fas fa-tags me-2"></i>Category</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="trainer"><i class="fas fa-users me-2"></i>View Users</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="AdminSideOrder"><i class="fas fa-shopping-bag me-2"></i>Orders</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="feed"><i class="fas fa-comments me-2"></i>Feedback</a></li>
                    <li class="nav-item"><a class="nav-link text-white" href="logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <div><a class="navbar-brand" href="#"><i class="fas fa-shopping-bag me-2"></i>ShopHub</a></div>
                <small class="text-danger">Search looks through both product names and descriptions — try specific keywords for better accuracy.</small>
                <div class="d-flex align-items-center">
                    <%
                        String userEmail = currentUser.getEmail();
                        if (userEmail != null) {
                    %>
                    <span class="me-3">Logged in as: <strong><%= userEmail %></strong></span>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Add Product Form -->
            <div class="form-container">
                <h2 class="form-title">Add New Product</h2>
                <form action="/addProduct" method="post" enctype="multipart/form-data">
                    <div class="row form-row">
                        <div class="col-md-6">
                            <label for="productName" class="form-label required">Product Name</label>
                            <input type="text" class="form-control" id="productName" name="name"
                                   maxlength="250" required>
                            <div id="nameCounter" class="char-counter">0 / 250</div>
                        </div>

                        <div class="col-md-6">
                            <label for="category" class="form-label required">Category</label>
                            <select class="form-select" id="category" name="category" required
                                    style="overflow-y: auto;"
                                    onfocus="this.size=5;" onblur="this.size=1;"
                                    onchange="this.size=1; this.blur();">
                                <option value="">Select Category</option>
                                <%
                                    List<Category> categories = (List<Category>) request.getAttribute("category");
                                    if (categories != null) {
                                        for (Category cat : categories) {
                                            if (cat.getCategory().equals("MISCELLANEOUS")) continue;
                                %>
                                <option value="<%= cat.getCategory() %>"><%= cat.getCategory() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="row form-row">
                        <div class="col-md-6">
                            <label for="quantity" class="form-label required">Quantity</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" min="1" required>
                        </div>
                        <div class="col-md-6">
                            <label for="price" class="form-label required">Price ($)</label>
                            <input type="number" class="form-control" id="price" name="price" step="0.01" min="0.01" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description"
                                  rows="4" maxlength="10000" required></textarea>
                        <div id="descCounter" class="char-counter">0 / 10000</div>
                    </div>

                    <div class="form-row">
                        <label for="productImage" class="form-label required">Product Image</label>
                        <input type="file" class="form-control" id="productImage" name="file" accept="image/*" required>
                        <img id="imagePreview" class="image-preview" alt="Preview">
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="viewitem" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i> Back to Products
                        </a>
                        <button type="submit" class="btn btn-primary btn-submit">
                            <i class="fas fa-save me-2"></i> Add Product
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const nameInput = document.getElementById('productName');
    const descInput = document.getElementById('description');
    const nameCounter = document.getElementById('nameCounter');
    const descCounter = document.getElementById('descCounter');

    const updateCounter = (input, counter, max) => {
        const length = input.value.length;
        counter.textContent = `${length} / ${max}`;
        counter.classList.toggle('warning', length > max * 0.9);
    };

    nameInput.addEventListener('input', () => updateCounter(nameInput, nameCounter, 250));
    descInput.addEventListener('input', () => updateCounter(descInput, descCounter, 10000));

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
