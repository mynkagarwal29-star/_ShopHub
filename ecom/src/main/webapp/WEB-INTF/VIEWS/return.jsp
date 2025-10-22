<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Policy | ShopHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --light-color: #f8f9fa;
            --dark-color: #212529;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--dark-color);
            background-color: #f5f7ff;
        }
        
        .navbar {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color) !important;
            font-size: 1.5rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        .policy-header {
            background-color: var(--primary-color);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .policy-content {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
        }
        
        .policy-content h3 {
            color: var(--primary-color);
            margin-top: 25px;
            margin-bottom: 15px;
        }
        
        .policy-content h3:first-child {
            margin-top: 0;
        }
        
        .policy-content ul {
            padding-left: 20px;
        }
        
        .policy-content li {
            margin-bottom: 8px;
        }
        
        .return-steps {
            counter-reset: step-counter;
        }
        
        .return-step {
            position: relative;
            padding-left: 50px;
            margin-bottom: 25px;
        }
        
        .return-step::before {
            content: counter(step-counter);
            counter-increment: step-counter;
            position: absolute;
            left: 0;
            top: 0;
            width: 36px;
            height: 36px;
            background-color: var(--primary-color);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .footer {
            background-color: var(--dark-color);
            color: white;
            padding: 40px 0;
            margin-top: 50px;
        }
        
        .footer h5 {
            color: var(--success-color);
            font-weight: 600;
        }
        
        .footer a {
            color: #adb5bd;
            text-decoration: none;
        }
        
        .footer a:hover {
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.html">ShopHub</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.html">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="products.html">Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="deals.html">Deals</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about-us.html">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="contact-us.html">Contact</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <div class="input-group me-3">
                        <input type="text" class="form-control" placeholder="Search products...">
                        <button class="btn btn-outline-secondary" type="button">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                    <a href="cart.html" class="btn btn-outline-primary me-2 position-relative">
                        <i class="bi bi-cart3"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            3
                        </span>
                    </a>
                    <div class="dropdown">
                        <button class="btn btn-primary dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-1"></i> Account
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="profile-management.html">My Profile</a></li>
                            <li><a class="dropdown-item" href="order-history.html">Order History</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Policy Header -->
    <div class="policy-header">
        <div class="container">
            <h1 class="display-5 fw-bold">Return Policy</h1>
            <p class="lead">Last updated: October 15, 2023</p>
        </div>
    </div>

    <!-- Policy Content -->
    <div class="container mb-5">
        <div class="policy-content">
            <h2>Return & Refund Policy</h2>
            <p>At ShopHub, we want you to be completely satisfied with your purchase. If for any reason you are not entirely happy with your order, we're here to help.</p>
            
            <h3>Return Eligibility</h3>
            <p>You can return most items within 30 days of delivery. To be eligible for a return, your item must be:</p>
            <ul>
                <li>Unused and in the same condition that you received it</li>
                <li>In the original packaging</li>
                <li>Accompanied by the receipt or proof of purchase</li>
            </ul>
            
            <h3>Non-Returnable Items</h3>
            <p>Several types of goods are exempt from being returned. These include:</p>
            <ul>
                <li>Perishable goods such as food, flowers, or plants</li>
                <li>Custom or personalized products</li>
                <li>Digital downloads or software</li>
                <li>Intimate apparel or sanitary goods</li>
                <li>Hazardous materials or flammable liquids</li>
                <li>Gift cards</li>
            </ul>
            
            <h3>How to Initiate a Return</h3>
            <div class="return-steps">
                <div class="return-step">
                    <h4>Contact Customer Service</h4>
                    <p>Send an email to returns@shophub.com or call us at +1 (555) 123-4567 to initiate a return request. Please include your order number and the reason for the return.</p>
                </div>
                <div class="return-step">
                    <h4>Receive Return Authorization</h4>
                    <p>Our customer service team will review your request and, if approved, will provide you with a Return Merchandise Authorization (RMA) number and return shipping instructions.</p>
                </div>
                <div class="return-step">
                    <h4>Package Your Item</h4>
                    <p>Securely pack the item in its original packaging if possible. Include all accessories, manuals, and documentation that came with the product. Write the RMA number clearly on the outside of the package.</p>
                </div>
                <div class="return-step">
                    <h4>Ship the Item</h4>
                    <p>Send the package using the shipping method provided by our customer service team. For most returns, we will provide a prepaid shipping label. For returns initiated by the customer (not due to our error), you may be responsible for return shipping costs.</p>
                </div>
                <div class="return-step">
                    <h4>Receive Your Refund</h4>
                    <p>Once we receive and inspect your return, we will process your refund within 5-7 business days. Refunds will be issued to your original payment method. Please note that it may take additional time for the refund to appear in your account, depending on your payment provider.</p>
                </div>
            </div>
            
            <h3>Refund Options</h3>
            <p>Depending on the reason for your return and your preference, we offer the following refund options:</p>
            <ul>
                <li><strong>Original Payment Method:</strong> Refund to your credit card, debit card, or PayPal account</li>
                <li><strong>Store Credit:</strong> Receive a ShopHub gift card for the amount of your return, which can be used for future purchases</li>
                <li><strong>Exchange:</strong> Exchange the item for a different size, color, or product of equal or lesser value</li>
            </ul>
            
            <h3>Damaged or Defective Items</h3>
            <p>If you receive a damaged or defective item, please contact us immediately. We will arrange for a replacement or refund at no additional cost to you. In some cases, we may require photographic evidence of the damage or defect.</p>
            
            <h3>Late or Missing Refunds</h3>
            <p>If you haven't received a refund yet, first check your bank account again. Then contact your credit card company, as it may take some time before your refund is officially posted. If you've done all of this and you still have not received your refund, please contact us at returns@shophub.com.</p>
            
            <h3>Exchanges</h3>
            <p>We only replace items if they are defective or damaged. If you need to exchange it for the same item, send us an email at returns@shophub.com or call us at +1 (555) 123-4567.</p>
            
            <h3>Gift Returns</h3>
            <p>If the item was marked as a gift when purchased and shipped directly to you, you'll receive a gift credit for the value of your return. Once the returned item is received, a gift certificate will be emailed to you.</p>
            
            <h3>Return Shipping Costs</h3>
            <p>You will be responsible for paying for your own shipping costs for returning your item unless the return is due to our error (you received an incorrect or defective item). Shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.</p>
            
            <h3>International Returns</h3>
            <p>For international orders, please note that you may be subject to import duties and taxes, which are levied once a shipment reaches your country. We have no control over these charges and cannot predict what they may be. Any additional fees for customs clearance must be borne by you. We do not refund customs fees for returned items.</p>
            
            <h3>Contact Us</h3>
            <p>If you have any questions about our Return Policy, please contact us:</p>
            <ul>
                <li>By email: returns@shophub.com</li>
                <li>By phone: +1 (555) 123-4567</li>
                <li>By mail: 123 Commerce Street, Shopville, USA 12345</li>
            </ul>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5>ShopHub</h5>
                    <p>Your one-stop destination for all your shopping needs. Quality products at unbeatable prices.</p>
                    <div class="social-icons mt-3">
                        <a href="#" class="me-2"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="me-2"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="me-2"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="me-2"><i class="bi bi-youtube"></i></a>
                    </div>
                </div>
                <div class="col-md-2 mb-4">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="index.html">Home</a></li>
                        <li><a href="products.html">Products</a></li>
                        <li><a href="deals.html">Deals</a></li>
                        <li><a href="about-us.html">About Us</a></li>
                        <li><a href="contact-us.html">Contact Us</a></li>
                    </ul>
                </div>
                <div class="col-md-2 mb-4">
                    <h5>Customer Service</h5>
                    <ul class="list-unstyled">
                        <li><a href="faq.html">FAQ</a></li>
                        <li><a href="shipping.html">Shipping Policy</a></li>
                        <li><a href="returns.html">Returns & Refunds</a></li>
                        <li><a href="privacy-policy.html">Privacy Policy</a></li>
                        <li><a href="terms-of-service.html">Terms of Service</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-4">
                    <h5>Contact Us</h5>
                    <p><i class="bi bi-geo-alt me-2"></i> 123 Commerce Street, Shopville, USA</p>
                    <p><i class="bi bi-telephone me-2"></i> +1 (555) 123-4567</p>
                    <p><i class="bi bi-envelope me-2"></i> support@shophub.com</p>
                    <form class="mt-3">
                        <div class="input-group">
                            <input type="email" class="form-control" placeholder="Your email address">
                            <button class="btn btn-primary" type="button">Subscribe</button>
                        </div>
                    </form>
                </div>
            </div>
            <hr class="bg-light">
            <div class="text-center py-3">
                <p class="mb-0">&copy; 2023 ShopHub. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>