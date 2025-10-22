!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | ShopHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HOME.CSS">
    <jsp:include page="navbar.jsp" />
    <style>
        :root {
            --primary-color: #4361ee;
            --light-color: #f8f9fa;
            --dark-color: #212529;
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
            background-color: #3a56d4;
            border-color: #3a56d4;
        }
        
        .hero-section {
            background-color: var(--primary-color);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        
        .contact-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            height: 100%;
        }
        
        .contact-info {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        
        .contact-info i {
            font-size: 1.5rem;
            color: var(--primary-color);
            margin-right: 15px;
            margin-top: 3px;
        }
        
        .footer {
            background-color: var(--dark-color);
            color: white;
            padding: 30px 0;
            margin-top: 40px;
        }
        
        .footer h5 {
            color: #4cc9f0;
            font-weight: 600;
        }
        
        .footer a {
            color: #adb5bd;
            text-decoration: none;
        }
        
        .footer a:hover {
            color: white;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
        }
        
        .success-message {
            display: none;
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="display-5 fw-bold mb-2">Contact Us</h1>
            <p class="lead">We're here to help and answer any question you might have</p>
            <p class="lead">For now it has been kept static and is a sample view page </p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container mb-5">
        <div class="row">
            <!-- Contact Form -->
            <div class="col-lg-8 mb-4">
                <div class="contact-card">
                    <h3 class="mb-4">Send us a message</h3>
                    <div class="success-message" id="successMessage">
                        <i class="bi bi-check-circle-fill me-2"></i>Your message has been sent successfully!
                    </div>
                    <form id="contactForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label">Your Name</label>
                                <input type="text" class="form-control" id="name" required>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="subject" class="form-label">Subject</label>
                            <input type="text" class="form-control" id="subject" required>
                        </div>
                        <div class="mb-3">
                            <label for="message" class="form-label">Message</label>
                            <textarea class="form-control" id="message" rows="5" required></textarea>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button type="button" class="btn btn-outline-secondary me-2" id="resetBtn">Reset</button>
                            <button type="submit" class="btn btn-primary">Send Message</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Contact Information -->
            <div class="col-lg-4">
                <div class="contact-card">
                    <h3 class="mb-4">Sample Contact Information</h3>
                    <div class="contact-info">
                        <i class="bi bi-geo-alt"></i>
                        <div>
                            <h5>Address</h5>
                            <p>123 Commerce Street<br>Shopville, USA 12345</p>
                        </div>
                    </div>
                    <div class="contact-info">
                        <i class="bi bi-telephone"></i>
                        <div>
                            <h5>Phone</h5>
                            <p>+1 (555) 123-4567</p>
                        </div>
                    </div>
                    <div class="contact-info">
                        <i class="bi bi-envelope"></i>
                        <div>
                            <h5>Email</h5>
                            <p>support@shophub.com</p>
                        </div>
                    </div>
                    <div class="contact-info">
                        <i class="bi bi-clock"></i>
                        <div>
                            <h5>Business Hours</h5>
                            <p>Monday - Friday: 9am - 6pm<br>Saturday: 10am - 4pm<br>Sunday: Closed</p>
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
        document.addEventListener('DOMContentLoaded', function() {
            const contactForm = document.getElementById('contactForm');
            const resetBtn = document.getElementById('resetBtn');
            const successMessage = document.getElementById('successMessage');
            
            // Handle form submission
            contactForm.addEventListener('submit', function(e) {
                e.preventDefault();
                
                // Get form values
                const name = document.getElementById('name').value;
                const email = document.getElementById('email').value;
                const subject = document.getElementById('subject').value;
                const message = document.getElementById('message').value;
                
                // Simple validation
                if (!name || !email || !subject || !message) {
                    alert('Please fill in all fields');
                    return;
                }
                
                // In a real application, you would send this data to a server
                // For demonstration, we'll just show the success message
                successMessage.style.display = 'block';
                
                // Reset form
                contactForm.reset();
                
                // Hide success message after 5 seconds
                setTimeout(() => {
                    successMessage.style.display = 'none';
                }, 5000);
            });
            
            // Handle reset button
            resetBtn.addEventListener('click', function() {
                contactForm.reset();
                successMessage.style.display = 'none';
            });
        });
    </script>
</body>
</html>