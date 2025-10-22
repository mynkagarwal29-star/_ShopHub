 
<%@ page import="com.example.jpa.model.Account" %>
<%@ page import="java.util.*" %>
<% Account currentUser = (Account) session.getAttribute("currentUser");
if (currentUser == null || !"admin".equals(currentUser.getRole())) {
    response.sendRedirect("/log");
    return;
} %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Users | Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ADMIN.css">
    <style>
        .table-container {
            position: relative;
        }
        
        .table-scrollable {
            max-height: 350px;
            overflow-y: auto;
            display: block;
        }
        
        .table-scrollable thead, .table-scrollable tbody {
            display: table;
            width: 100%;
            table-layout: fixed;
        }
        
        .action-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
            margin: 0 0.25rem;
        }
        
        .filter-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .filter-section {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .sort-options {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 12px;
            background-color: #e9ecef;
            border-radius: 6px;
        }
        
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        
        .badge-order-count {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
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
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">
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
                                <i class="fas fa-plus-circle me-2"></i> Category
                            </a>
                        </li>
                       <li class="nav-item">
                            <a class="nav-link active text-white" href="trainer">
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
                            <a class="nav-link text-white" href="/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            
            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
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
                
                <!-- Dashboard Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary dashboard-card mb-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <h4 class="card-title">${activeUsers}</h4>
                                    <p class="card-text">Active Users (Carts)</p>
                                </div>
                                <div class="fs-1">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card text-white bg-success dashboard-card mb-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <h4 class="card-title">${totalUsers}</h4>
                                    <p class="card-text">Total Users</p>
                                </div>
                                <div class="fs-1">
                                    <i class="fas fa-users"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card text-white bg-warning dashboard-card mb-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <h4 class="card-title">${usersWithoutOrders}</h4>
                                    <p class="card-text">Users Without Orders</p>
                                </div>
                                <div class="fs-1">
                                    <i class="fas fa-user-slash"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="card text-white bg-info dashboard-card mb-3">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <h4 class="card-title">${usersWithOrders}</h4>
                                    <p class="card-text">Users With Orders</p>
                                </div>
                                <div class="fs-1">
                                    <i class="fas fa-users"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
     <!-- Users Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">User Details</h5> 
                                            <!-- Filter Section -->
						<form method="get" action="trainer" id="filterForm">
						    <div class="filter-section">
						        <!-- Checkbox -->
						        <div class="form-check form-switch">
						            <input class="form-check-input" type="checkbox" name="withOrdersOnly" id="withOrdersOnly"
						                   value="true" <%= Boolean.TRUE.equals(request.getAttribute("withOrdersOnly")) ? "checked" : "" %>>
						            <label class="form-check-label fw-bold" for="withOrdersOnly">
						                Show Users With Orders Only
						            </label>
						        </div>
						
						        <!-- Sort Options -->
						        <div class="sort-options" id="sortSection"
						             style="<%= Boolean.TRUE.equals(request.getAttribute("withOrdersOnly")) ? "display:flex;" : "display:none;" %>">
						            <span class="fw-bold">Sort By Order Count:</span>
						            <div class="form-check form-check-inline">
						                <input class="form-check-input" type="radio" name="sortOrder" id="lowToHigh" value="asc"
						                       <%= "asc".equals(request.getAttribute("sortOrder")) ? "checked" : "" %>>
						                <label class="form-check-label" for="lowToHigh">Low to High</label>
						            </div>
						            <div class="form-check form-check-inline">
						                <input class="form-check-input" type="radio" name="sortOrder" id="highToLow" value="desc"
						                       <%= "desc".equals(request.getAttribute("sortOrder")) ? "checked" : "" %>>
						                <label class="form-check-label" for="highToLow">High to Low</label>
						            </div>
						        </div>
						
						        <div class="ms-auto">
						            <button type="submit" class="btn btn-sm btn-primary">
						                <i class="fas fa-filter me-1"></i> Apply Filter
						            </button>
						            <a href="trainer" class="btn btn-sm btn-outline-secondary">
						                <i class="fas fa-redo me-1"></i> Reset
						            </a>
						        </div>
						    </div>
						</form>
                    </div>
                    
                    <div class="card-body p-0">
                        <div class="table-container">
                            <!-- Updated Header Table -->
                            <table class="table table-striped table-hover mb-0" style="border-collapse: separate; table-layout: fixed; width: 100%;">
                                <thead class="table-light" style="position: sticky; top: 0; z-index: 1;">
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Orders</th>
                                        <th colspan="2">Actions</th>
                                    </tr>
                                </thead>
                            </table>
                            
                            <div class="table-scrollable">
                                <table class="table table-striped table-hover mb-0" style="table-layout: fixed; width: 100%;">
                                    <tbody>
                                        <%
                                            List<Account> userList = (List<Account>) request.getAttribute("data");
                                            Map<Long, Integer> orderCountMap = (Map<Long, Integer>) request.getAttribute("orderCountMap");
                                            
                                            if (userList != null && !userList.isEmpty()) {
                                                for (Account user : userList) {
                                                    if ("admin".equalsIgnoreCase(user.getRole())) {
                                                        continue; // skip admin account
                                                    }
                                                    
                                                    Integer orderCount = orderCountMap.get(user.getId());
                                                    if (orderCount == null) {
                                                        orderCount = 0;
                                                    }
                                        %>
                                        <tr style="border-bottom: 1px solid #eee;">
                                            <td style="padding: 10px; color: #555;"><%= user.getId() %></td>
                                            <td style="padding: 10px; color: #555;">
                                                <%= (user.getName() != null && !user.getName().isEmpty()) ? user.getName() : "N/A" %>
                                            </td>
                                            <td style="padding: 10px; color: #555;"><%= user.getEmail() %></td>
                                            <td style="padding: 10px; color: #555;">
                                                <span class="badge badge-order-count bg-primary"><%= orderCount %></span>
                                            </td>
                                            <td style="padding: 10px;">
                                                <a href="AdminSideOrder?userId=<%= user.getId() %>&userName=<%= java.net.URLEncoder.encode(user.getName(), "UTF-8") %>"
												    class="btn btn-sm btn-primary action-btn">
												    <i class="fas fa-shopping-bag me-1"></i> Orders
												</a>
                                            </td>
                                            <td style="padding: 10px;">
                                                <a href="#" class="btn btn-sm btn-danger action-btn" 
                                                   onclick="return confirm('THIS FEATURE IS UNDER DEVELOPMENT');">
                                                    <i class="fas fa-trash-alt me-1"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="6" style="padding: 15px; text-align: center;">
                                                <h4>No records found!</h4>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
   <script>
document.addEventListener('DOMContentLoaded', function() {
    const withOrdersOnly = document.getElementById('withOrdersOnly');
    const sortSection = document.getElementById('sortSection');

    sortSection.style.display = withOrdersOnly.checked ? 'flex' : 'none';

    withOrdersOnly.addEventListener('change', function() {
        sortSection.style.display = this.checked ? 'flex' : 'none';
        if (this.checked && !document.querySelector('input[name="sortOrder"]:checked')) {
            document.getElementById('highToLow').checked = true;
        }
    });
});
</script>
   
</body>

</html>
