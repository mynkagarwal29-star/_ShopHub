<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.jpa.model.Account" %>
<%
    try {
        Account currentUser = (Account) session.getAttribute("currentUser");
        String name = (currentUser != null) ? currentUser.getName() : null;
%>

<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="fas fa-shopping-bag me-2"></i>ShopHub
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link active" href="/">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="/productlist">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="/user_category">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="/about">About</a></li>
                <li class="nav-item"><a class="nav-link" href="/contactus">Contact</a></li>
            </ul>

            <div class="d-flex align-items-center gap-2 ms-3">
                <!-- Show cart button -->
                <a href="${pageContext.request.contextPath}/cart"
                   class="btn btn-gradient-primary d-flex align-items-center gap-2 position-relative">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Cart</span>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        ${cartCount != null ? cartCount : 0}
                    </span>
                </a>

                <% if (currentUser == null) { %>
                    <!-- Not logged in -->
                    <a href="/log" class="btn btn-gradient-primary d-flex align-items-center gap-2">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </a>
                    <a href="/sig" class="btn btn-gradient-primary d-flex align-items-center gap-2">
                        <i class="fas fa-user-plus"></i> Sign Up
                    </a>
                <% } else { %>
                    <!-- Logged in -->
                    <a href="/profiledetails" class="btn btn-gradient-primary d-flex align-items-center gap-2">
                        Welcome: <%= name != null ? name : "" %>
                    </a>
                    <a href="/logout" class="btn btn-gradient-primary d-flex align-items-center gap-2">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<%
    } catch (Exception e) {
        // Handle any exceptions gracefully
        System.out.println("Error in navbar: " + e.getMessage());
    }
%>