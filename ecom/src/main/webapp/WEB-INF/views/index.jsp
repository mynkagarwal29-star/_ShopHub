<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Category" %>
<%@ page import="com.example.jpa.model.Product" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="java.util.*" %>
<%
    // Check if user is logged in
    Account currentUser = (Account) session.getAttribute("currentUser");
    
    // If user is logged in and is an admin, redirect to admin dashboard
    if (currentUser != null && "admin".equals(currentUser.getRole())) {
        response.sendRedirect("/viewitem");
        return;
    }
    
    // Get user ID if logged in (will be null for guests)
    Long userId = (currentUser != null) ? currentUser.getId() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopHub - Your Online Shopping Destination</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HOME.css">
    
    <!-- Add cache control headers -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <jsp:include page="navbar.jsp" />
</head>
<body>
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <h1>Welcome to ShopHub</h1>
            <p>Your one-stop destination for all your shopping needs. Discover amazing products at unbeatable prices.</p>
            <a href="/productlist" class="btn btn-light btn-hero">Shop Now</a>
        </div>
    </section>

    <!-- Categories Section -->
    <%
        List<Category> categoryList = (List<Category>) request.getAttribute("category");
        Category randomFindsCat = null;
    %>

    <section class="category-section">
        <div class="container">
            <h2 class="section-title text-center mb-4">Shop by Category</h2>

            <div class="category-scroll-container">
                <div class="d-flex flex-nowrap overflow-auto px-4" id="categoryRow">
                    <%
                        if (categoryList != null && !categoryList.isEmpty()) {
                            for (Category cat : categoryList) {
                                if ("RANDOM FINDS".equalsIgnoreCase(cat.getCategory())) {
                                    randomFindsCat = cat; // store it for later
                                    continue;
                                }
                    %>
                        <!-- Display all other categories -->
                        <div class="category-item me-3">
                            <div class="card category-card text-center">
                                <a href="/select_pd/<%= cat.getCategory() %>">
                                    <img src="/uploads/<%= cat.getImage() %>" width="100" height="100" class="mx-auto mt-3">
                                </a>
                                <div class="card-body category-card-body">
                                    <h5 class="category-card-title"><%= cat.getCategory() %></h5>
                                </div>
                            </div>
                        </div>
                    <%
                            }

                            // Now display RANDOM FINDS at the end
                            if (randomFindsCat != null) {
                    %>
                        <div class="category-item me-3">
                            <div class="card category-card text-center">
                                <a href="/select_pd/<%= randomFindsCat.getCategory() %>">
                                    <img src="/uploads/<%= randomFindsCat.getImage() %>" width="100" height="100" class="mx-auto mt-3">
                                </a>
                                <div class="card-body category-card-body">
                                    <h5 class="category-card-title"><%= randomFindsCat.getCategory() %></h5>
                                </div>
                            </div>
                        </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Products Section -->
    <section class="product-section">
        <div class="container">
            <h2 class="section-title">Recently Featured Products! </h2>
            <div class="row">
                <%
                    List<Product> prodList = (List<Product>) request.getAttribute("product");
                    if (prodList != null && !prodList.isEmpty()) {
                        for (Product prod : prodList) {
                %>
                <div class="col-md-3 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-img-container">
                            <a href="/productdetail/<%= prod.getId() %>">
                                <img src="/uploads/<%= prod.getImagePath() %>" class="product-img" alt="<%= prod.getName() %>">
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
                <%
                        }
                    } else {
                %>
                <p>No featured products available.</p>
                <%
                    }
                %>
            </div>
            <h2>
                <a href="/productlist" class="section-title" style="display:block; text-align:center;">
                    Get Them All!
                </a>
            </h2>
        </div>
    </section>

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
</body>
</html>