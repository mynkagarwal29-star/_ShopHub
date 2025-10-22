<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.jpa.model.CartItem" %>
<%@ page import="com.example.jpa.model.Account" %>
<%
    Account currentUser = (Account) session.getAttribute("currentUser");
String error = (String) request.getAttribute("error");
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - ShopHub</title>
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
        
        .cart-container {
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
        .cart-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .cart-item {
            display: flex;
            align-items: center;
            padding: 20px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .cart-item-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 20px;
        }
        
        .cart-item-details {
            flex: 1;
        }
        
        .cart-item-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .cart-item-category {
            font-size: 0.85rem;
            color: var(--secondary);
            margin-bottom: 10px;
        }
        
        .cart-item-price {
            font-weight: 600;
            color: var(--primary);
        }
        
        .quantity-controls {
            display: flex;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow: hidden;
            width: fit-content;
        }
        
        .quantity-btn {
            width: 36px;
            height: 36px;
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
            width: 50px;
            height: 36px;
            border: none;
            border-left: 1px solid #ddd;
            border-right: 1px solid #ddd;
            text-align: center;
            font-weight: 500;
        }
        
        .cart-item-actions {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .remove-btn {
            background: none;
            border: none;
            color: var(--danger);
            cursor: pointer;
            font-size: 1.2rem;
            transition: color 0.3s;
        }
        
        .remove-btn:hover {
            color: #c0392b;
        }
        
        .summary-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 30px;
            position: sticky;
            top: 20px;
        }
        
        .summary-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        
        .summary-row.total {
            font-weight: 700;
            font-size: 1.1rem;
            padding-top: 15px;
            margin-top: 15px;
            border-top: 1px solid #e9ecef;
        }
        
        .promo-code {
            margin-bottom: 20px;
        }
        
        .promo-code .input-group {
            margin-bottom: 10px;
        }
        
        .empty-cart {
            text-align: center;
            padding: 50px 0;
        }
        
        .empty-cart i {
            font-size: 5rem;
            color: var(--secondary);
            margin-bottom: 20px;
        }
        
        .empty-cart h3 {
            margin-bottom: 15px;
        }
        
        .btn-primary {
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }
        
        .btn-outline-primary {
            color: var(--primary);
            border-color: var(--primary);
        }
        
        .btn-outline-primary:hover {
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
            .cart-item {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .cart-item-img {
                margin-right: 0;
                margin-bottom: 15px;
            }
            
            .cart-item-actions {
                flex-direction: row;
                margin-top: 15px;
                width: 100%;
                justify-content: space-between;
            }
        }
    </style>
</head>
<body>
   
	  <% if(error != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <!-- Cart Content -->
    <div class="cart-container">
        <div class="container">
        
            <!-- Page Header -->
            <div class="page-header">
              <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                      <li class="breadcrumb-item"><a href="/">Home</a></li>
                      <li class="breadcrumb-item"><a href="/productlist">Products</a></li>
                      <li class="breadcrumb-item"><a href="/user_category">Category</a></li>
                      <li class="breadcrumb-item active" aria-current="page">Cart</li>
                    </ol>

                </nav>
                <h1 class="mb-0">Shopping Cart</h1>
            </div>
            
           <div class="container mt-4">
    <div class="row">
        <!-- Cart Items: Left Column -->
        <div class="col-lg-8">
            <div class="cart-card" style="max-height:900px; overflow-y:auto; padding:15px; border:1px solid #ddd; border-radius:8px;">
                <%
                    if (cartItems != null && !cartItems.isEmpty()) {
                        for (CartItem item : cartItems) {
                %>
                    <div class="cart-item d-flex align-items-center justify-content-between mb-3 p-2" style="border-bottom:1px solid #eee;">
                        <img src="/uploads/<%= item.getProduct().getImagePath() %>" class="cart-item-img me-3" style="width:80px; height:80px; object-fit:cover;">
                        <div class="cart-item-details flex-grow-1">
                            <h5 class="cart-item-title mb-1"><%= item.getProduct().getName() %></h5>
                            <div class="cart-item-category mb-1 text-muted"><%= item.getProduct().getCategory() %></div>
                            <div class="cart-item-price mb-1">₹<%= item.getProduct().getPrice() %></div>
                        </div>
                        <div class="quantity-controls me-3 d-flex align-items-center">
                            <% if (currentUser != null) { %>
                                <!-- Logged in: update by itemId -->
                                <form action="${pageContext.request.contextPath}/cart/updateQuantity" method="post" style="display:inline;">
                                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                    <input type="hidden" name="change" value="-1">
                                    <button type="submit">-</button>
                                </form>
                                <%= item.getQty() %>
                                <form action="${pageContext.request.contextPath}/cart/updateQuantity" method="post" style="display:inline;">
                                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                    <input type="hidden" name="change" value="1">
                                    <button type="submit">+</button>
                                </form>
                            <% } else { %>
                                <!-- Guest: update by productId -->
                                <form action="${pageContext.request.contextPath}/cart/updateQuantity" method="post" style="display:inline;">
                                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                    <input type="hidden" name="change" value="-1">
                                    <button type="submit">-</button>
                                </form>
                                <%= item.getQty() %>
                                <form action="${pageContext.request.contextPath}/cart/updateQuantity" method="post" style="display:inline;">
                                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                    <input type="hidden" name="change" value="1">
                                    <button type="submit">+</button>
                                </form>
                            <% } %>

                        </div>
                        <div class="cart-item-actions text-end">
                            <div class="fw-bold mb-1">₹<%= item.getProduct().getPrice() * item.getQty() %></div>
                            <% if (currentUser != null) { %>
                                <!-- Logged in user: remove by itemId -->
                                <form action="${pageContext.request.contextPath}/cart/remove" method="post" style="display:inline;">
                                    <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger">Remove</button>
                                </form>
                            <% } else { %>
                                <!-- Guest user: remove by productId -->
                                <form action="${pageContext.request.contextPath}/cart/remove" method="post" style="display:inline;">
                                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger">Remove</button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                     <div class="empty-cart">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Your cart is empty</h3>
                        <p class="text-muted">Add some items to your cart to continue shopping</p>
                        <a href="${pageContext.request.contextPath}/productlist" class="btn btn-primary">Start Shopping</a>
                    </div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Order Summary: Right Column -->
<div class="col-lg-4">
    <div class="summary-card p-3 mb-3" style="border:1px solid #ddd; border-radius:8px;">
        <h4 class="summary-title mb-3">Order Summary</h4>

        <div class="summary-row d-flex justify-content-between mb-2">
            <span>Subtotal</span>
            <span>₹<%= cartItems != null ? cartItems.stream().mapToDouble(i -> i.getProduct().getPrice() * i.getQty()).sum() : 0 %></span>
        </div>

        <%
            double subtotal = cartItems != null ? cartItems.stream().mapToDouble(i -> i.getProduct().getPrice() * i.getQty()).sum() : 0;
            double tax = subtotal * 0.18;  // 18% GST
            double shipping = subtotal < 500 ? subtotal * 0.12 : 0;  // 12% shipping fee if total < 500
            double total = subtotal + tax + shipping;
        %>

        <div class="summary-row d-flex justify-content-between mb-2">
            <span>Shipping</span>
            <span>₹<%= Math.round(shipping * 100.0f) / 100.0f  %></span>
        </div>

        <div class="summary-row d-flex justify-content-between mb-2">
            <span>Tax (18% GST)</span>
            <span>₹<%= Math.round(tax * 100.0f) / 100.0f  %></span>
        </div>

        <div class="summary-row d-flex justify-content-between fw-bold mb-3">
            <span>Total</span>
            <span>₹<%= Math.round(total * 100.0f) / 100.0f %></span>
        </div>

        <% if (currentUser != null) { %>
            <!-- Logged-in user: checkout form -->
            <form action="/orders/place" method="post" class="mt-3">
            <%
    String line1 = (String) request.getAttribute("line1");
    String city = (String) request.getAttribute("city");
    String postal = (String) request.getAttribute("postal");
    String country = (String) request.getAttribute("country");
    String phoneNumber = (String) request.getAttribute("phoneNumber");

                if (line1 != null && !line1.isEmpty()) {
            %>
                <div class="mb-2">
                    <label class="form-label">Address Line</label>
                    <input type="text" name="line1" class="form-control" value="<%= line1 %>" />
                </div>
            
                <div class="mb-2">
                    <label class="form-label">City</label>
                    <input type="text" name="city" class="form-control" value="<%= city %>" />
                </div>
            
                <div class="mb-2">
                    <label class="form-label">Postal Code</label>
                    <input type="text" name="postal" class="form-control" value="<%= postal %>" />
                </div>
            
                <div class="mb-2">
                    <label class="form-label">Country</label>
                    <input type="text" name="country" class="form-control" value="<%= country %>" />
                </div>
            
                <div class="mb-2">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phoneNumber" class="form-control" value="<%= phoneNumber %>" />
                </div>
            <%
                }else{
            %>
            
                <div class="mb-2">
    <label class="form-label">Address Line</label>
    <input type="text" name="line1" class="form-control" value="${line1}" required>
</div>
<div class="mb-2">
    <label class="form-label">City</label>
    <input type="text" name="city" class="form-control" value="${city}" required>
</div>
<div class="mb-2">
    <label class="form-label">Postal Code</label>
    <input type="text" name="postal" class="form-control" value="${postal}" required>
</div> 
<div class="mb-2">
    <label class="form-label">Country</label>
    <input type="text" name="country" class="form-control" value="${country}" required>
</div>
<div class="mb-3">
    <label class="form-label">Phone Number</label>
    <input type="text" name="phoneNumber" class="form-control" value="${phoneNumber}" required>
</div>

<%} %>
                <!-- Hidden totals -->
                <input type="hidden" name="subtotal" value="<%= subtotal %>">
                <input type="hidden" name="tax" value="<%= tax %>">
                <input type="hidden" name="shipping" value="<%= shipping %>">
                <input type="hidden" name="total" value="<%= total %>">

                <button type="submit" class="btn btn-primary w-100">Place Order</button>
                <small class="text-muted d-block text-center">Always Check your cart before placing the order!</small>
        
            </form>
        <% } else { %>
            <!-- Guest user: redirect to login first -->
            <a href="${pageContext.request.contextPath}/log" class="btn btn-primary w-100 mb-2">
                Login to Checkout
            </a>
        <% } %>

        <form action="${pageContext.request.contextPath}/cart/clear" method="post" class="mt-2">
            <button type="submit" class="btn btn-outline-danger w-100">Clear Cart</button>
        </form>
    </div>
</div>


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
        // Update quantity
        function updateQuantity(button, change) {
            const input = button.parentNode.querySelector('.quantity-input');
            const currentValue = parseInt(input.value);
            const newValue = currentValue + change;
            
            if (newValue >= 1) {
                input.value = newValue;
                // In a real application, you would update the cart total here
                updateCartTotal();
            }
        }
        
        // Remove item from cart
        document.querySelectorAll('.remove-btn').forEach(button => {
            button.addEventListener('click', function() {
                if (confirm('Are you sure you want to remove this item from your cart?')) {
                    // In a real application, you would remove the item from the cart here
                    this.closest('.cart-item').remove();
                    updateCartTotal();
                    updateCartCount();
                }
            });
        });
        
        // Clear cart
        document.querySelector('.btn-outline-danger').addEventListener('click', function() {
            if (confirm('Are you sure you want to clear your entire cart?')) {
                // In a real application, you would clear the cart here
                document.querySelectorAll('.cart-item').forEach(item => {
                    item.remove();
                });
                updateCartTotal();
                updateCartCount();
                
                // Show empty cart message
                const cartItems = document.querySelector('.cart-card');
                cartItems.innerHTML = `
                    <div class="empty-cart">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Your cart is empty</h3>
                        <p class="text-muted">Add some items to your cart to continue shopping</p>
                        <a href="${pageContext.request.contextPath}/productlist" class="btn btn-primary">Start Shopping</a>
                    </div>
                `;
            }
        });
        
        // Update cart total (simplified for demo)
        function updateCartTotal() {
            // In a real application, you would recalculate the total based on the items in the cart
            // For demo purposes, we'll just keep the existing total
        }
        
        // Update cart count (simplified for demo)
        function updateCartCount() {
            // In a real application, you would update the cart count in the navbar
            // For demo purposes, we'll just keep the existing count
        }
        
        // Apply promo code
        document.querySelector('.promo-code .btn-outline-secondary').addEventListener('click', function() {
            const promoInput = document.querySelector('.promo-code input');
            const promoCode = promoInput.value.trim();
            
            if (promoCode) {
                // In a real application, you would validate the promo code and apply the discount
                alert(`Promo code "${promoCode}" applied successfully!`);
                promoInput.value = '';
            } else {
                alert('Please enter a promo code');
            }
        });
    </script>
</body>
</html>