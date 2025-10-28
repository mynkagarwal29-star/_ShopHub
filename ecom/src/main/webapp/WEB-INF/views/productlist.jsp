 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Product" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="org.springframework.data.domain.Page" %>
<%@ page import="java.util.*" %>
<%
    Account currentUser = (Account) session.getAttribute("currentUser");
    Long userId = (currentUser != null) ? currentUser.getId() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="${ pageContext.request.contextPath}/css/HOME.CSS">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - ShopHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ pageContext.request.contextPath}/css/HOME.css">
    <jsp:include page="navbar.jsp" />
    <style>
        :root {
            --primary: #4e73df;
            --secondary: #858796;
            --success: #1cc88a;
            --info: #36b9cc;
            --warning: #f6c23e;
            --danger: #e74a3b;
            --light: #f8f9fc;
            --dark: #5a5c69;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--dark);
            background-color: #f5f5f5;
        }
        
        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,.08);
            padding: 15px 0;
        }
        
        .navbar-brand {
            font-weight: 700;
            color: var(--primary) !important;
            font-size: 1.5rem;
        }
        
        .navbar-nav .nav-link {
            color: var(--dark) !important;
            font-weight: 500;
            margin: 0 10px;
            transition: color 0.3s;
        }
        
        .navbar-nav .nav-link:hover {
            color: var(--primary) !important;
        }
        
        .user-dropdown {
            display: flex;
            align-items: center;
        }
        
        .user-dropdown img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .products-container {
            padding: 30px 0;
        }
        
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
        
        .products-header {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .view-toggle {
            display: flex;
            background-color: white;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .view-toggle button {
            border: none;
            background-color: white;
            padding: 8px 12px;
            color: var(--secondary);
            transition: all 0.3s;
        }
        
        .view-toggle button.active {
            background-color: var(--primary);
            color: white;
        }
        
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
        
        .product-card:hover .product-img {
            transform: scale(1.05);
        }
        
        .product-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .badge-sale {
            background-color: var(--danger);
            color: white;
        }
        
        .badge-new {
            background-color: var(--success);
            color: white;
        }
        
        .product-actions {
            position: absolute;
            bottom: 10px;
            left: 0;
            right: 0;
            display: flex;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;
        }
        
        .product-card:hover .product-actions {
            opacity: 1;
        }
        
        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: white;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            transition: all 0.3s;
        }
        
        .action-btn:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .wishlist-btn:hover {
            background-color: var(--danger);
        }
        
        .product-body {
            padding: 15px;
        }
        
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
        
        .product-rating {
            color: var(--warning);
            margin-bottom: 10px;
        }
        
        .product-price {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .price-current {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary);
        }
        
        .price-old {
            font-size: 0.9rem;
            color: var(--secondary);
            text-decoration: line-through;
            margin-left: 10px;
        }
        
        .product-footer {
            padding: 0 15px 15px;
        }
        
        .add-to-cart-btn {
            width: 100%;
            background-color: var(--primary);
            border: none;
            padding: 8px;
            font-weight: 500;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .add-to-cart-btn:hover {
            background-color: #2e59d9;
        }
        
        .list-view .product-card {
            display: flex;
            flex-direction: row;
            height: auto;
        }
        
        .list-view .product-img-container {
            width: 200px;
            height: 200px;
            flex-shrink: 0;
        }
        
        .list-view .product-body {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .list-view .product-title {
            height: auto;
            margin-bottom: 5px;
        }
        
        .list-view .product-footer {
            width: 200px;
            flex-shrink: 0;
            padding: 15px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .pagination {
            margin-top: 30px;
        }
        
        .page-link {
            color: var(--primary);
        }
        
        .page-item.active .page-link {
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .footer {
            background-color: var(--dark);
            color: white;
            padding: 50px 0 20px;
            margin-top: 50px;
        }
        
        .footer-col h5 {
            font-size: 1.2rem;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .footer-col h5:after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 2px;
            background-color: var(--primary);
        }
        
        .footer-links {
            list-style: none;
            padding: 0;
        }
        
        .footer-links li {
            margin-bottom: 10px;
        }
        
        .footer-links a {
            color: #ddd;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .footer-links a:hover {
            color: var(--primary);
        }
        
        .social-icons a {
            display: inline-block;
            width: 40px;
            height: 40px;
            background-color: rgba(255,255,255,0.1);
            border-radius: 50%;
            text-align: center;
            line-height: 40px;
            margin-right: 10px;
            color: white;
            transition: background-color 0.3s;
        }
        
        .social-icons a:hover {
            background-color: var(--primary);
        }
        
        .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid rgba(255,255,255,0.1);
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .products-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .view-toggle {
                margin-top: 10px;
            }
            
            .list-view .product-card {
                flex-direction: column;
            }
            
            .list-view .product-img-container {
                width: 100%;
            }
            
            .list-view .product-footer {
                width: 100%;
            }
        }
        .category-item {
    flex: 0 0 220px;
}
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
    .category-scroll-container {
        overflow-x: auto;
        overflow-y: hidden;
        white-space: nowrap;
        padding-bottom: 10px;
        scroll-behavior: smooth;
        scrollbar-width:none
    }
    .category-item {
        display: inline-block;
        white-space: normal; /* Keep text wrap inside cards */
    }
    /* Optional: Hide scrollbar (cross-browser) */
    .category-scroll-container::-webkit-scrollbar {
        display: none;
    }
    .category-scroll-container {
        -ms-overflow-style: none;  /* IE/Edge */
        scrollbar-width: none;     /* Firefox */
    }
    </style>
</head>
<body>    
    <!-- Products Content -->
    <div class="products-container">
        <div class="container">
            <!-- Page Header -->
<div class="page-header">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/">Home</a></li>
            <li class="breadcrumb-item active">Products</li>
        </ol>
    </nav>

    <h1 class="mb-3">All Products</h1>

    <!-- Search form and Back button -->
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <form class="input-group mb-3" method="get" action="/productlist">
                <input type="text" name="search" class="form-control" placeholder="Search product..." value="${search != null ? search : ''}">
                <button class="btn btn-primary" type="submit">Search</button>
                <a href="/productlist" class="btn btn-secondary">Back</a>
            </form>
        </div>
    </div>
</div>


            
            <div class="row">
                <!-- Products Grid -->
                <div class="col-12" >  
                        
                    <div class="row" id="productsContainer">
                        <!-- Product comes here in a loop-->
                            <%
                                            Page<Product> productPage = (Page<Product>) request.getAttribute("productPage");
                                            List<Product> prodList = (productPage != null) ? productPage.getContent() : null;
                                            int currentPage = (Integer) request.getAttribute("currentPage");
                                            int totalPages = (Integer) request.getAttribute("totalPages");
                            %> 
                          <%
                                if (prodList != null && !prodList.isEmpty()) {
                                    for (Product prod : prodList) {
                            %>
                                        <div class="col-lg-3 col-md-4 col-sm-6 product-item" style="margin:20px 0;">
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
                    
                   <!-- Pagination controls -->
                       <nav aria-label="Page navigation example">
    <ul class="pagination justify-content-center">
        <%
            if (currentPage > 0) {
        %>
            <li class="page-item">
                <a class="page-link" href="/productlist?page=<%= currentPage - 1 %>&size=8&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">Previous</a>
            </li>
        <%
            }
            for (int i = 0; i < totalPages; i++) {
        %>
            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                <a class="page-link" href="/productlist?page=<%= i %>&size=8&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"><%= i + 1 %></a>
            </li>
        <%
            }
            if (currentPage < totalPages - 1) {
        %>
            <li class="page-item">
                <a class="page-link" href="/productlist?page=<%= currentPage + 1 %>&size=8&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">Next</a>
            </li>
        <%
            }
        %>
    </ul>
</nav>

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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>