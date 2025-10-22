<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Product Details - ShopHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    
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
        
        .product-detail-container {
            padding: 30px 0;
        }
        
        .breadcrumb {
            background-color: transparent;
            padding: 0;
            margin-bottom: 20px;
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: ">";
            color: var(--secondary);
        }
        
        .product-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .product-images {
            position: relative;
        }
        
        .main-image {
            width: 100%;
            height: 400px;
            object-fit: contain;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        
        .thumbnail-container {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 10px;
        }
        
        .thumbnail {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: border-color 0.3s;
        }
        
        .thumbnail.active {
            border-color: var(--primary);
        }
        
        .product-badge {
            position: absolute;
            top: 20px;
            right: 20px;
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
        
        .product-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .product-rating {
            color: var(--warning);
            margin-bottom: 15px;
        }
        
        .product-price {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .price-current {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
        }
        
        .price-old {
            font-size: 1.2rem;
            color: var(--secondary);
            text-decoration: line-through;
            margin-left: 15px;
        }
        
        .discount-badge {
            background-color: var(--danger);
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            margin-left: 15px;
        }
        
        .product-description {
            margin-bottom: 25px;
            line-height: 1.6;
        }
        
        .key-features {
            margin-bottom: 25px;
        }
        
        .key-features h6 {
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .key-features ul {
            padding-left: 20px;
        }
        
        .key-features li {
            margin-bottom: 8px;
        }
        
        .quantity-selector {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .quantity-selector label {
            margin-right: 15px;
            font-weight: 500;
        }
        
        .quantity-controls {
            display: flex;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .quantity-btn {
            width: 40px;
            height: 40px;
            border: none;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .quantity-btn:hover {
            background-color: #e9ecef;
        }
        
        .quantity-input {
            width: 60px;
            height: 40px;
            border: none;
            border-left: 1px solid #ddd;
            border-right: 1px solid #ddd;
            text-align: center;
            font-weight: 500;
        }
        
        .product-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .btn-cart {
            flex: 1;
            background-color: var(--primary);
            border: none;
            padding: 12px 20px;
            font-weight: 500;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .btn-cart:hover {
            background-color: #2e59d9;
        }
        
        .btn-buy {
            flex: 1;
            background-color: var(--success);
            border: none;
            padding: 12px 20px;
            font-weight: 500;
            border-radius: 5px;
            color: white;
            transition: background-color 0.3s;
        }
        
        .btn-buy:hover {
            background-color: #13855c;
        }
        
        .btn-wishlist {
            width: 50px;
            height: 50px;
            border-radius: 5px;
            border: 1px solid #ddd;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--danger);
            transition: all 0.3s;
        }
        
        .btn-wishlist:hover {
            background-color: var(--danger);
            color: white;
        }
        
        .product-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            color: var(--secondary);
        }
        
        .meta-item i {
            margin-right: 8px;
            color: var(--primary);
        }
        
        .product-tabs {
            margin-top: 40px;
        }
        
        .nav-tabs {
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 20px;
        }
        
        .nav-tabs .nav-link {
            border: none;
            color: var(--dark);
            font-weight: 500;
            padding: 10px 20px;
            position: relative;
        }
        
        .nav-tabs .nav-link.active {
            color: var(--primary);
        }
        
        .nav-tabs .nav-link.active::after {
            content: "";
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 3px;
            background-color: var(--primary);
        }
        
        .tab-content {
            padding: 20px 0;
        }
        
        .spec-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .spec-table tr {
            border-bottom: 1px solid #e9ecef;
        }
        
        .spec-table td {
            padding: 12px 0;
        }
        
        .spec-table td:first-child {
            font-weight: 500;
            width: 30%;
        }
        
        .review-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .reviewer-info {
            display: flex;
            align-items: center;
        }
        
        .reviewer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .reviewer-name {
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .review-date {
            font-size: 0.85rem;
            color: var(--secondary);
        }
        
        .review-rating {
            color: var(--warning);
        }
        
        .review-text {
            margin-bottom: 15px;
            line-height: 1.6;
        }
        
        .review-actions {
            display: flex;
            gap: 15px;
        }
        
        .review-actions button {
            background: none;
            border: none;
            color: var(--secondary);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
        }
        
        .review-actions button:hover {
            color: var(--primary);
        }
        
        .review-actions i {
            margin-right: 5px;
        }
        
        .related-products {
            margin-top: 50px;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 25px;
            position: relative;
            padding-bottom: 10px;
        }
        
        .section-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background-color: var(--primary);
        }
        
        .related-product-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
        }
        
        .related-product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        .related-product-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        
        .related-product-body {
            padding: 15px;
        }
        
        .related-product-title {
            font-weight: 600;
            margin-bottom: 10px;
            height: 40px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        
        .related-product-price {
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 15px;
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
            .product-actions {
                flex-direction: column;
            }
            
            .btn-cart, .btn-buy {
                width: 100%;
            }
            
            .btn-wishlist {
                width: 100%;
                height: 40px;
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
    /* Products */
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
footer, .footer {
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
    background-color: rgba(255, 255, 255, 0.1);
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
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    font-size: 0.9rem;
}



    </style>
</head>
<body>
    <%Product prod=(Product)request.getAttribute("product"); %>
    <!-- Product Detail Content -->
    <div class="product-detail-container">
        <div class="container">
            <!-- Breadcrumb -->
              <div class="page-header">
                <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/">Home</a></li>
                    <li class="breadcrumb-item"><a href="/productlist">Products</a></li>
                    <li class="breadcrumb-item"><a href="/select_pd/<%= prod.getCategory() %>"><%=prod.getCategory() %></a></li>
                    <li class="breadcrumb-item active"><%=prod.getName() %></li> 
                </ol>
            </nav>
                <h1 class="mb-0">Products Details</h1>
            </div>
            <!-- Product Detail -->
            <div class="product-card">
                    <%
                          if(prod!=null)
                        {
                    %>
                <div class="row">
                    <!-- Product Images -->
                    <div class="col-lg-5 product-images">
                        <img src="/uploads/<%= prod.getImagePath() %>" class="main-image" id="mainProductImage" alt="<%= prod.getName() %>">
                    </div>
                    
                    <!-- Product Info -->
                    <div class="col-lg-7">
                        <h1 class="product-title"><%= prod.getName() %></h1>
                        
                        <div class="product-price">
                            <span class="price-current">₹<%= prod.getPrice() %></span>
                         </div>
                        
                        <div class="product-description">
                            <p><%= prod.getDescription() %></p>
                        </div>
                       
                     <div class="product-actions">
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
    <% if(currentUser != null){ %>
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
                        
                      <!--   <div class="product-meta">
                            <div class="meta-item">
                                <i class="fas fa-truck"></i>
                                <span>Free shipping on orders over $50</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-shield-alt"></i>
                                <span>2-year warranty included</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-undo-alt"></i>
                                <span>30-day return policy</span>
                            </div>
                        </div> -->
                    </div>
                </div>
                        <% 
                        }
                        %>
                        <!-- Related Products -->
                       <div class="related-products">
    <h3 class="section-title">Related Products</h3>
    <% List<Product> prod_cat = (List<Product>) request.getAttribute("prod_cat"); %>
    <div class="row">
        <% if (prod_cat != null) {
               for (Product produ : prod_cat) {
                   if (produ.getId().equals(prod.getId())) continue; // avoid current product
        %>
            <div class="col-lg-3 col-md-4 col-sm-6">
                <div class="card h-100 shadow-sm related-card">
                    <div class="ratio ratio-4x3">
                        <img src="/uploads/<%= produ.getImagePath() %>"
                             class="card-img-top object-fit-cover"
                             alt="<%= produ.getName() %>">
                    </div>
                    <div class="card-body text-center">
                        <h6 class="card-title text-truncate"><%= produ.getName() %></h6>
                        <p class="card-text fw-bold text-primary mb-2">₹<%= produ.getPrice() %></p>
                        <a href="/productdetail/<%= produ.getId() %>"
                           class="btn btn-sm btn-outline-primary w-100">
                            View Details
                        </a>
                    </div>
                </div>
            </div>
        <% }} %>
    </div>

    <!-- Pagination controls -->
    <nav aria-label="Related products pagination">
        <ul class="pagination justify-content-center">
            <%
                int relatedCurrentPage = (int) request.getAttribute("relatedCurrentPage");
                int relatedTotalPages = (int) request.getAttribute("relatedTotalPages");

                if (relatedCurrentPage > 0) {
            %>
                <li class="page-item">
                    <a class="page-link"
                       href="/productdetail/<%= prod.getId() %>?page=<%= relatedCurrentPage - 1 %>&size=4">Previous</a>
                </li>
            <%
                }
                for (int i = 0; i < relatedTotalPages; i++) {
            %>
                <li class="page-item <%= (i == relatedCurrentPage) ? "active" : "" %>">
                    <a class="page-link"
                       href="/productdetail/<%= prod.getId() %>?page=<%= i %>&size=4"><%= i + 1 %></a>
                </li>
            <%
                }
                if (relatedCurrentPage < relatedTotalPages - 1) {
            %>
                <li class="page-item">
                    <a class="page-link"
                       href="/productdetail/<%= prod.getId() %>?page=<%= relatedCurrentPage + 1 %>&size=4">Next</a>
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
    <script>
        // Change main product image when thumbnail is clicked
        function changeImage(img) {
            document.getElementById('mainProductImage').src = img.src;
            
            // Update active thumbnail
            document.querySelectorAll('.thumbnail').forEach(thumb => {
                thumb.classList.remove('active');
            });
            img.classList.add('active');
        }
        
        // Increase quantity
        function increaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            quantityInput.value = currentValue + 1;
        }
        
        // Decrease quantity
        function decreaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            if (currentValue > 1) {
                quantityInput.value = currentValue - 1;
            }
        }
        
        // Toggle wishlist button
        document.querySelector('.btn-wishlist').addEventListener('click', function() {
            const icon = this.querySelector('i');
            if (icon.classList.contains('far')) {
                icon.classList.remove('far');
                icon.classList.add('fas');
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
            }
        });
    </script>
</body>
</html>