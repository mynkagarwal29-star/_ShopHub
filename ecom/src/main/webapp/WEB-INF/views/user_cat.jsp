 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Category" %>
<%@ page import="com.example.jpa.model.Product" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="java.util.*" %>
<%
    Account currentUser = (Account) session.getAttribute("currentUser");
    Long userId = (currentUser != null) ? currentUser.getId() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopHub - Categories</title>
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HOME.css">
    <jsp:include page="navbar.jsp" />
    <!-- Custom Styles -->
    <style>
    .products-container {
    padding: 30px 0px;
}
        /* General */
        .page-header {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
        }
        .breadcrumb {
            background-color: transparent;
            padding: 0;
            margin: 0;
        }
        .breadcrumb-item + .breadcrumb-item::before {
            content: ">";
            color: var(--secondary);
        }
        /* Category Section - Vertical Sidebar */
        .category-sidebar {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        .category-sidebar h3 {
            font-size: 1.25rem;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .category-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .category-item {
            margin-bottom: 10px;
        }
        .category-link {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
        }
        .category-link:hover {
            background-color: #f8f9fa;
            color: var(--primary);
            transform: translateX(5px);
        }
        .category-link img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 6px;
            margin-right: 12px;
        }
        .category-link h5 {
            margin: 0;
            font-size: 1rem;
            font-weight: 500;
        }
        /* Buttons */
        .btn-gradient-primary {
            background: linear-gradient(to right, #4facfe, #00f2fe);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            font-weight: 500;
            border-radius: 8px;
            transition: 0.3s ease;
        }
        .btn-gradient-primary:hover {
            background: linear-gradient(to right, #00c6fb, #005bea);
            transform: translateY(-1px);
        }
        /* Product Section */
        .product-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            margin-bottom: 30px;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .product-img-container {
            position: relative;
            overflow: hidden;
            height: 200px;
        }
        .product-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }
        .product-card:hover .product-img { transform: scale(1.05); }
        .product-body { padding: 15px; }
        .product-category {
            font-size: 0.8rem;
            color: var(--secondary);
            margin-bottom: 5px;
        }
        .product-title {
            font-weight: 600;
            margin-bottom: 10px;
            height: 40px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .product-price { display: flex; align-items: center; margin-bottom: 15px; }
        .price-current { font-size: 1.2rem; font-weight: 700; color: var(--primary); }
        .product-footer { padding: 0 15px 15px; }
        .add-to-cart-btn {
            width: 100%;
            background-color: var(--primary);
            border: none;
            padding: 8px;
            font-weight: 500;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .add-to-cart-btn:hover { background-color: #2e59d9; }
        /* Helpers */
        .loading-spinner { display: none; text-align: center; padding: 20px; }
        .no-products { text-align: center; padding: 40px; color: #6c757d; }
        .navbar {
                background-color: white;
                box-shadow: 0 2px 4px rgba(0, 0, 0, .08);
                padding: 15px 0;
            }
            .category-list {
                    max-height: 450px; /* Approx height for 7 items (adjust as needed) */
                    overflow-y: auto;
                    padding: 0;
                    margin: 0;
                    list-style: none;
                }
                
                .category-list::-webkit-scrollbar {
                    width: 6px;
                }
                
                .category-list::-webkit-scrollbar-thumb {
                    background-color: #888;
                    border-radius: 4px;
                }
                
                .category-list::-webkit-scrollbar-thumb:hover {
                    background-color: #555;
                }
                
                .category-item {
                    margin-bottom: 10px;
                }
            
    </style>
</head>
<body>
<div class="product-container" style="margin-top : 30px;">
<div class="container">
    <div class="row">
        <!-- Left Sidebar - Categories -->
        <div class="col-md-3">
                        <div class="category-sidebar">
                            <h3>Shop by Category</h3>
                            <ul class="category-list">
                                <% List<Category> categoryList = (List<Category>) request.getAttribute("category"); 
                                if (categoryList != null && !categoryList.isEmpty()) {
                                    for (Category cat : categoryList) { %>
                                        <li class="category-item">
                                            <a href="/select_pd/<%= cat.getCategory() %>" class="category-link">
                                                <img src="/uploads/<%= cat.getImage() %>" alt="<%= cat.getCategory() %>">
                                                <h5><%= cat.getCategory() %></h5>
                                            </a>
                                        </li>
                                <%  } } %>
                            </ul>
                        </div>
                    </div>
        <!-- Main Content - Products -->
        <div class="col-md-9">
            <!-- Page Header -->
            <div class="page-header">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                        <li class="breadcrumb-item"><a href="/productlist">Products</a></li>
                        <li class="breadcrumb-item active">Categories</li>
                    </ol>
                </nav>
                <h1 class="h2 mb-0">Product Categories</h1>
            </div>
            
            <!-- Products Section -->
                   <% 
                        org.springframework.data.domain.Page<Product> productPage = 
                            (org.springframework.data.domain.Page<Product>) request.getAttribute("productPage"); 
                    
                        if (productPage != null && !productPage.isEmpty()) { 
                            List<Product> prodList = productPage.getContent();
                    %>
                    <section class="product-section mb-5">
                    <div class="row">
                        <% for (Product prod : prodList) { %>
                            <div class="col-md-4 col-sm-6 mb-4">
                                <div class="product-card">
                                    <div class="product-img-container">
                                        <a href="/productdetail/<%= prod.getId() %>">
                                            <img src="/uploads/<%= prod.getImagePath() %>" 
                                                 class="product-img img-fluid" alt="<%= prod.getName() %>">
                                        </a>
                                    </div>
                                    <div class="product-body">
                                        <div class="product-category"><%= prod.getCategory() %></div>
                                        <h5 class="product-title"><%= prod.getName() %></h5>
                                        <div class="product-price">
                                            <span class="price-current">₹<%= prod.getPrice() %></span>
                                        </div>
                                    </div>
                                     <div class="product-footer text-center" style="white-space:nowrap;">
<%
    int qty = prod.getQuantity();
    if (qty == 0) {
%>
    <span class="badge bg-danger d-block mb-2">Out of Stock</span>
<% 
    } else if (qty < 6) { 
%>
    <span class="badge bg-danger d-block mb-2">Hurry! Only <%= qty %> left!</span>
<%
    }
%>
    <% if (qty > 0) { %>
        <% if (currentUser != null) { %>
            <!-- Logged-in user -->
            <form action="${pageContext.request.contextPath}/cart/add" method="post" style="display:inline-block; margin-right:8px;">
                <input type="hidden" name="accountId" value="<%= userId %>">
                <input type="hidden" name="productId" value="<%= prod.getId() %>">
                <input type="hidden" name="qty" value="1">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-shopping-cart me-2"></i> Add to Cart
                </button>
            </form>
            <form action="<%= request.getContextPath() %>/cart/buy-now" method="post" style="display:inline-block;">
                <input type="hidden" name="accountId" value="<%= userId %>">
                <input type="hidden" name="productId" value="<%= prod.getId() %>">
                <input type="hidden" name="qty" value="1">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-bolt me-2"></i> Buy Now
                </button>
            </form>
        <% } else { %>
            <!-- Guest user -->
            <form action="${pageContext.request.contextPath}/cart/add" method="post" style="display:inline-block; margin-right:8px;">
                <input type="hidden" name="productId" value="<%= prod.getId() %>">
                <input type="hidden" name="qty" value="1">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-shopping-cart me-2"></i> Add to Cart
                </button>
            </form>
            <form action="${pageContext.request.contextPath}/cart/buy-now" method="post" style="display:inline-block;">
                <input type="hidden" name="productId" value="<%= prod.getId() %>">
                <input type="hidden" name="qty" value="1">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-bolt me-2"></i> Buy Now
                </button>
            </form>
            <small class="text-muted d-block">Use cart but Login to purchase</small>
        <% } %>
    <% } %>
</div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </section>

                <!-- Pagination -->
                <div class="pagination-container text-center">
                    <ul class="pagination justify-content-center">
                        <% 
                            int currentPage = (int) request.getAttribute("currentPage");
                            int totalPages = (int) request.getAttribute("totalPages");
                            String selectedCategory = (String) request.getAttribute("selectedCategory");
                            if (currentPage > 0) {
                            %>
                                <li class="page-item"><a class="page-link" href="/select_pd/<%= selectedCategory %>?page=<%= currentPage -1 %>&size=6">Previous</a></li>
                            <%
                            }
                            for (int i = 0; i < totalPages; i++) {
                        %>
                            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                <a class="page-link" href="/select_pd/<%= selectedCategory %>?page=<%= i %>&size=6">
                                    <%= (i + 1) %>
                                </a>
                            </li>
                        <% } if (currentPage < totalPages - 1) {
                         %>
                                    <li class="page-item"><a class="page-link" href="/select_pd/<%= selectedCategory %>?page=<%= currentPage + 1 %>&size=6">Next</a></li>
                                <%
                                    }%>
                    </ul>
                </div>
                <% }  else { %>
            <!-- No Products Message -->
<section class="product-section mb-5">
    <h2 class="section-title mb-4 text-center" id="categoryTitle">Select a Category</h2>
    <div class="loading-spinner" id="loadingSpinner" style="display: none;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
    <div id="productContainer">
        <div class="no-products text-center">
            <i class="fas fa-hand-pointer fa-3x mb-3 text-muted"></i>
            <h4>Select a category to view products</h4>
            <p>Click on any category in the sidebar to see its products</p>
        </div>
    </div>
</section>

            <% } %>
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
<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>