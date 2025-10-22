<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Product" %>
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="com.example.jpa.model.Category" %>
<%@ page import="java.util.*" %>
<%
    Account currentUser = (Account) session.getAttribute("currentUser");
    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
        response.sendRedirect("/log");
        return;
    }

    String selectedCategory = request.getParameter("category");
    String stockSort = request.getParameter("stockSort");
    String search = request.getParameter("search");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ADMIN.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<%
    String adminMessage = (String) session.getAttribute("adminloggedin");
    Account adminAccount = (Account) session.getAttribute("currentUser"); // assuming you store the admin account object in session
    if (adminMessage != null) {
        session.removeAttribute("adminloggedin");
        String alertClass = "alert-success"; // Example: change class based on the message type
        String alertText = adminMessage;
%>

<!-- Floating Alert Box for greeting -->
<div id="floatingAlert" class="alert <%= alertClass %> shadow-lg rounded-3 p-3 position-fixed top-0 start-50 translate-middle-x" 
     style="z-index: 1050; width: 350px; text-align:center; opacity: 0;">
    <%= alertText %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const alertBox = document.getElementById("floatingAlert");
        if (alertBox) {
            alertBox.style.transition = "opacity 0.5s ease, transform 0.5s ease";
            alertBox.style.opacity = 1;
            alertBox.style.transform = "translate(-50%, 20px)";

            setTimeout(() => {
                alertBox.style.opacity = 0;
                alertBox.style.transform = "translate(-50%, -20px)";
            }, 3000);

            setTimeout(() => {
                alertBox.remove();
            }, 3500);
        }

        <% if(adminAccount != null && "admin@gmail.com".equals(adminAccount.getEmail())) { %>
        // Extra alert for changing email/password
        const alertBox2 = document.createElement("div");
        alertBox2.className = "alert alert-warning shadow-lg rounded-3 p-3 position-fixed top-0 start-50 translate-middle-x";
        alertBox2.style.zIndex = 1050;
        alertBox2.style.width = "350px";
        alertBox2.style.textAlign = "center";
        alertBox2.style.opacity = 0;
        alertBox2.innerHTML = "You are using the base email and password. Please change your email and password immediately!";
        document.body.appendChild(alertBox2);

        setTimeout(() => {
            alertBox2.style.transition = "opacity 0.5s ease, transform 0.5s ease";
            alertBox2.style.opacity = 1;
            alertBox2.style.transform = "translate(-50%, 70px)"; // slightly below the first alert
        }, 500);

        setTimeout(() => {
            alertBox2.style.opacity = 0;
            alertBox2.style.transform = "translate(-50%, 20px)";
        }, 4000);

        setTimeout(() => {
            alertBox2.remove();
        }, 4500);
        <% } %>
    });
</script>

<% } %>


<body>

<div class="container-fluid">
    <div class="row">
<!-- Sidebar -->
<nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
  <div class="position-sticky pt-3 d-flex flex-column h-100">
    <!-- Navigation -->
    <ul class="nav flex-column mb-auto">
      <li class="nav-item">
        <a class="nav-link active text-white" href="#">
          <i class="fas fa-tachometer-alt me-2"></i> Admin Dashboard
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="viewitem">
          <i class="fas fa-home me-2"></i> Home
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="addForm">
          <i class="fas fa-plus-circle me-2"></i> Add Product
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="Category">
          <i class="fas fa-tags me-2"></i> Category
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="trainer">
          <i class="fas fa-users me-2"></i> View Users
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="AdminSideOrder">
          <i class="fas fa-shopping-bag me-2"></i> View Orders
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="feed">
          <i class="fas fa-comments me-2"></i> View Feedback
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="logout">
          <i class="fas fa-sign-out-alt me-2"></i> Logout
        </a>
      </li>
    </ul>

    <!-- Settings buttons -->
    <div class="mt-auto pb-3 px-3">
      <button class="btn btn-warning w-100 mb-2 rounded-pill shadow-sm d-flex align-items-center justify-content-center"
              data-bs-toggle="modal" data-bs-target="#editEmailModal">
        <i class="fas fa-envelope-open me-2"></i>Edit Email
      </button>
      <button class="btn btn-warning w-100 rounded-pill shadow-sm d-flex align-items-center justify-content-center"
              data-bs-toggle="modal" data-bs-target="#resetModal">
        <i class="fas fa-key me-2"></i>Edit Password
      </button>
    </div>
    
  </div>
</nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
            <!-- Topbar with Search Bar -->
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <button class="btn btn-link d-md-none" type="button" data-bs-toggle="collapse" data-bs-target=".sidebar">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Search Bar with Clear -->
    <div class="input-group" style="max-width: 400px;">
        <form method="get" action="/viewitem" class="input-group">
            <input type="text" name="search" class="form-control" placeholder="Search products..."
                   value="<%= (search != null) ? search : "" %>">

            <!-- Preserve filters -->
            <input type="hidden" name="category" value="<%= (selectedCategory != null) ? selectedCategory : "" %>">
            <input type="hidden" name="stockSort" value="<%= (stockSort != null) ? stockSort : "" %>">

            <button class="btn btn-outline-secondary" type="submit">
                <i class="fas fa-search"></i>
            </button>

            <!-- Clear Search Button -->
            <%
                StringBuilder clearUrl = new StringBuilder("viewitem?");
                if (selectedCategory != null && !selectedCategory.isEmpty()) {
                    clearUrl.append("category=").append(selectedCategory).append("&");
                }
                if (stockSort != null && !stockSort.isEmpty()) {
                    clearUrl.append("stockSort=").append(stockSort).append("&");
                }
            %>
            <a href="<%= clearUrl.toString() %>" class="btn btn-outline-danger">
                <i class="fas fa-times"></i>
            </a>
        </form>
    </div>

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


            <!-- Dashboard Cards -->
            <div class="row mb-4">
    <div class="col-md-6">
        <a href="trainer" class="text-decoration-none">
            <div class="card text-white bg-primary mb-3">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="card-title">${activeUsers} Customers so far!</h4>
                        <p class="card-text text-white">Active Users (Go to Users section)</p>
                    </div>
                    <div class="fs-1">
                        <i class="fas fa-users" aria-label="Go to trainer page"></i>
                    </div>
                </div>
            </div>
        </a>
    </div>

    <div class="col-md-6">
        <a href="AdminSideOrder" class="text-decoration-none">
            <div class="card text-white bg-success mb-3">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="card-title">${totalSales} items have been sold!</h4>
                        <p class="card-text text-white">Total Sales (Go to Orders section)</p>
                    </div>
                    <div class="fs-1">
                        <i class="fas fa-shopping-cart" aria-label="Go to orders page"></i>
                    </div>
                </div>
            </div>
        </a>
    </div>
</div>

            <!-- Product Table -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <h5 class="mb-0">Product Details</h5>

                    <!-- Filters: Category + Stock Sort -->
                    <form action="viewitem" method="get" class="d-flex align-items-center flex-wrap" style="gap: 10px;">
                        <!-- Category Dropdown -->
                        <select name="category" class="form-select form-select-sm">
                            <option value="">-- Filter by Category --</option>
                            <%
                                List<Category> categories = (List<Category>) request.getAttribute("category");
                                if (categories != null) {
                                    for (Category cat : categories) {
                                        if ("MISCELLANEOUS".equals(cat.getCategory())) continue;
                            %>
                            <option value="<%= cat.getCategory() %>"
                                    <%= cat.getCategory().equals(selectedCategory) ? "selected" : "" %>>
                                <%= cat.getCategory() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>

                        <!-- Stock Sort Dropdown -->
                        <select name="stockSort" class="form-select form-select-sm">
                            <option value="">-- Sort by Stock --</option>
                            <option value="lowToHigh" <%= "lowToHigh".equals(stockSort) ? "selected" : "" %>>Low to High</option>
                            <option value="highToLow" <%= "highToLow".equals(stockSort) ? "selected" : "" %>>High to Low</option>
                        </select>

                        <!-- Filter Buttons -->
                        <button type="submit" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-filter me-1"></i> Apply Filter
                        </button>
                        <a href="viewitem" class="btn btn-outline-secondary btn-sm">Clear</a>
                    </form>

                    <!-- Add Product Button -->
                    <a href="addForm" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus"></i> Add New
                    </a>
                </div>

                <!-- Filter Message -->
                <%
                    if ((selectedCategory != null && !selectedCategory.isEmpty()) || 
                        (stockSort != null && !stockSort.isEmpty())) {
                %>
                <div class="alert alert-info m-3 mb-0" role="alert">
                    <strong>Filters Applied:</strong>
                    <%
                        if (selectedCategory != null && !selectedCategory.isEmpty()) {
                    %> 
                        Category: <strong><%= selectedCategory %></strong>
                    <%
                        }
                        if (stockSort != null && !stockSort.isEmpty()) {
                    %>
                        &nbsp;|&nbsp; Stock:
                        <strong>
                            <%= "lowToHigh".equals(stockSort) ? "Low to High" : "High to Low" %>
                        </strong>
                    <%
                        }
                    %>
                </div>
                <%
                    }
                %>

                <!-- Table -->
                <div class="card-body p-0">
                    <div class="table-container">
                        <table class="table table-striped table-hover mb-0" style="border-collapse: separate; table-layout: fixed; width: 100%;">
                            <thead class="table-light" style="position: sticky; top: 0; z-index: 1;">
                            <tr>
                                <th>ID</th>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                            </thead>
                        </table>

                        <div style="max-height: 350px; overflow-y: auto; border-top: none;">
                            <table class="table table-striped table-hover mb-0" style="table-layout: fixed; width: 100%;">
                                <tbody>
                                <%
                                    List<Product> prodList = (List<Product>) request.getAttribute("data");
                                    if (prodList != null && !prodList.isEmpty()) {
                                        for (Product prod : prodList) {
                                %>
                                <tr style="border-bottom: 1px solid #eee;">
                                    <td style="padding: 10px; color: #555;"><%= prod.getId() %></td>
                                    <td style="padding: 10px; color: #555;"><%= prod.getName() %></td>
                                    <td style="padding: 10px; color: #555;"><%= prod.getCategory() %></td>
                                    <td style="padding: 10px; color: #555;"><%= prod.getQuantity() %></td>
                                    <td style="padding: 10px; color: #555;">₹<%= prod.getPrice() %></td>
                                    <td style="padding: 10px;"><a href="/viewrecord/<%= prod.getId() %>" class="btn btn-warning btn-sm">EDIT</a></td>
                                    <td style="padding: 10px;"><a href="/deletepd/<%= prod.getId() %>" onclick="return confirm('Are you sure?')" class="btn btn-danger btn-sm">DELETE</a></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="padding: 15px;"><h4>No records found!</h4></td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<!-- Edit Email Modal -->
<div class="modal fade" id="editEmailModal" tabindex="-1" aria-labelledby="editEmailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form action="/updateEmail" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="editEmailModalLabel">Edit Email</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="newEmail" class="form-label">New Email Address</label>
            <input type="email" class="form-control" id="newEmail" name="newEmail" required>
          </div>
          <div class="mb-3">
            <label for="currentPasswordEmail" class="form-label">Current Password</label>
            <input type="password" class="form-control" id="currentPasswordEmail" name="currentPassword" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Update Email</button>
        </div>
      </form>
    </div>
  </div>
</div>
<div class="modal fade" id="resetModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content p-3">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-shield-lock me-2"></i>Reset Password</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <!-- Step 1: Enter Email -->
        <div id="stepEmail">
            <label>Email</label>
            <input type="email" id="resetEmail" class="form-control" placeholder="Enter your registered email" required>
            <button class="btn btn-primary mt-3 w-100 icon-btn" id="sendOtpBtn">
                <i class="bi bi-envelope-paper"></i> Send OTP
            </button>
            <div id="resetSpinner" class="text-center mt-3" style="display:none;">
			    <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
			    <span id="resetStatusText" class="ms-2">Processing...</span>
			</div>
        </div>

        <!-- Step 2: Enter OTP -->
        <div id="stepOtp" style="display:none;">
            <label>Enter OTP</label>
            <input type="text" id="otpInput" class="form-control" placeholder="6-digit code" required>
            <button class="btn btn-primary mt-3 w-100 icon-btn" id="verifyOtpBtn">
                <i class="bi bi-check2-circle"></i> Verify OTP
            </button>
        </div>

        <!-- Step 3: Enter New Password -->
        <div id="stepNewPassword" style="display:none;">
            <label>New Password</label>
            <input type="password" id="newPassword" class="form-control" placeholder="Enter new password" required>
            <label class="mt-2">Confirm Password</label>
            <input type="password" id="confirmPassword" class="form-control" placeholder="Re-enter password" required>
            <button class="btn btn-success mt-3 w-100 icon-btn" id="updatePasswordBtn">
                <i class="bi bi-unlock-fill"></i> Update Password
            </button>
        </div>

        <!-- Message -->
        <div id="resetMsg" class="mt-3 text-center fw-semibold"></div>
      </div>
    </div>
  </div>
</div>

<div id="resetSpinner" class="text-center mt-3" style="display:none;">
    <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
    <span id="resetStatusText" class="ms-2">Processing...</span>
</div>
<%
    // Check for message in request scope (flash attributes) first
    String msg = (String) request.getAttribute("msg");
    
    // If not found, check session scope
    if (msg == null) {
        msg = (String) session.getAttribute("msg");
        // Remove from session to prevent showing again
        if (msg != null) {
            session.removeAttribute("msg");
        }
    }
    
    String alertClass = "";
    String alertText = "";

    if (msg != null) {
        switch (msg) {
            case "ok":
                alertClass = "alert-success";
                alertText = "✅ Your email has been updated successfully!";
                break;
            case "pwd":
                alertClass = "alert-danger";
                alertText = "❌ Incorrect password. Please try again.";
                break;
            case "e":
                alertClass = "alert-warning";
                alertText = "⚠️ This email is already in use.";
                break;
            case "login":
                alertClass = "alert-warning";
                alertText = "⚠️ Please log in to update your email.";
                break;
            case "wrongCredentials":
                alertClass = "alert-danger";
                alertText = "❌ Wrong credentials. Please try again.";
                break;
            case "userNotFound":
                alertClass = "alert-danger";
                alertText = "❌ User not found.";
                break;
            case "securityAnswer":
                alertClass = "alert-danger";
                alertText = "❌ Security answer was incorrect.";
                break;
            case "passwordMismatch":
                alertClass = "alert-danger";
                alertText = "❌ Passwords do not match.";
                break;
            case "passwordUpdateSuccess":
                alertClass = "alert-success";
                alertText = "✅ Password updated successfully. Please login again.";
                break;
            default:
                alertClass = "alert-info";
                alertText = msg;
        }
%>
<div id="floatingAlert" class="alert <%= alertClass %> shadow-lg rounded-3 p-3 position-fixed top-0 start-50 translate-middle-x" 
     style="z-index:1050; width: 350px; text-align:center; opacity:0;">
    <%= alertText %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const alertBox = document.getElementById("floatingAlert");
        if (alertBox) {
            alertBox.style.transition = "opacity 0.5s ease, transform 0.5s ease";
            alertBox.style.opacity = 1;
            alertBox.style.transform = "translate(-50%, 20px)";

            setTimeout(() => {
                alertBox.style.opacity = 0;
                alertBox.style.transform = "translate(-50%, -20px)";
            }, 3000);

            setTimeout(() => {
                alertBox.remove();
            }, 3500);
        }
    });
</script>
<% } %>
<script>
 $(document).ready(function(){
    let emailGlobal = '';

    function showSpinner(msg){
        $('#resetSpinner').show();
        $('#resetStatusText').text(msg);
    }
    function hideSpinner(){
        $('#resetSpinner').hide();
    }

    // Open modal
    $('button[data-bs-target="#resetModal"]').click(function(){
        $('#resetModal').modal('show');
        $('#stepEmail').show(); 
        $('#stepOtp').hide(); 
        $('#stepNewPassword').hide(); 
        $('#resetMsg').text('');
        hideSpinner();
    });

    // Step 1: Send OTP
    $('#sendOtpBtn').click(function(){
        let email = $('#resetEmail').val().trim();
        if(!email){ $('#resetMsg').text('Please enter email').addClass('text-danger').removeClass('text-success'); return; }
        emailGlobal = email;

        $(this).prop('disabled', true);
        showSpinner('Sending OTP...');

        $.post('/sendResetOtp', {email: email})
        .done(function(){
            hideSpinner();
            $('#resetMsg').text('OTP sent to your email').removeClass('text-danger').addClass('text-success');
            $('#stepEmail').hide(); 
            $('#stepOtp').show();
        })
        .fail(function(err){
            hideSpinner();
            $('#resetMsg').text(err.responseText || 'Error sending OTP').removeClass('text-success').addClass('text-danger');
        })
        .always(function(){ $('#sendOtpBtn').prop('disabled', false); });
    });

    // Step 2: Verify OTP
    $('#verifyOtpBtn').click(function(){
        let otp = $('#otpInput').val().trim();
        if(!otp){ $('#resetMsg').text('Enter OTP').removeClass('text-success').addClass('text-danger'); return; }

        $(this).prop('disabled', true);
        showSpinner('Verifying OTP...');

        $.post('/verifyResetOtp', {email: emailGlobal, otp: otp})
        .done(function(){
            hideSpinner();
            $('#resetMsg').text('OTP Verified!').removeClass('text-danger').addClass('text-success');
            $('#stepOtp').hide(); 
            $('#stepNewPassword').show();
        })
        .fail(function(){
            hideSpinner();
            $('#resetMsg').text('Invalid OTP, please try again').removeClass('text-success').addClass('text-danger');
        })
        .always(function(){ $('#verifyOtpBtn').prop('disabled', false); });
    });

    // Step 3: Update Password
    $('#updatePasswordBtn').click(function(){
        let pwd = $('#newPassword').val().trim();
        let confirmPwd = $('#confirmPassword').val().trim();
        if(!pwd || !confirmPwd){ $('#resetMsg').text('Enter all fields').addClass('text-danger').removeClass('text-success'); return; }
        if(pwd !== confirmPwd){ $('#resetMsg').text('Passwords do not match').addClass('text-danger').removeClass('text-success'); return; }

        $(this).prop('disabled', true);
        showSpinner('Updating password...');

        $.post('/updatePassword', {email: emailGlobal, newPassword: pwd})
        .done(function(){
            hideSpinner();
            $('#resetMsg').text('Password updated successfully!').removeClass('text-danger').addClass('text-success');
            setTimeout(()=> { $('#resetModal').modal('hide'); }, 1500);
        })
        .fail(function(){
            hideSpinner();
            $('#resetMsg').text('Error updating password').removeClass('text-success').addClass('text-danger');
        })
        .always(function(){ $('#updatePasswordBtn').prop('disabled', false); });
    });
});
</script> 
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> 

</body>

</html>
