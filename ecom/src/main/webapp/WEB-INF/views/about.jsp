<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Me | ShopHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HOME.css">
    <jsp:include page="navbar.jsp" />
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
        
        .hero-section {
            background-color: var(--primary-color);
            color: white;
            padding: 60px 0;
            margin-bottom: 40px;
        }
        
        .about-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
            height: 100%;
            transition: transform 0.3s ease;
        }
        
        .about-card:hover {
            transform: translateY(-5px);
        }
        
        .about-card i {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .team-member {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .team-member img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 4px solid var(--primary-color);
        }
        
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            top: 0;
            left: 8px;
            height: 100%;
            width: 2px;
            background: #e9ecef;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 30px;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -30px;
            top: 5px;
            height: 16px;
            width: 16px;
            border-radius: 50%;
            background: white;
            border: 2px solid var(--primary-color);
        }
        
        .timeline-item h5 {
            color: var(--primary-color);
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
        
        .highlight {
            background-color: rgba(67, 97, 238, 0.1);
            padding: 2px 5px;
            border-radius: 4px;
        }
        
        .feature-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .project-image {
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="display-4 fw-bold mb-4">My Academic Journey</h1>
            <p class="lead">How ShopHub became my learning playground and the lessons I discovered along the way</p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container mb-5">
        <!-- My Story -->
        <div class="row mb-5">
            <div class="col-lg-6 mb-4">
                <h2 class="mb-4">My Learning Journey</h2>
                <p>ShopHub began as an ambitious academic project during my studies in software development. What started as a simple requirement for my course quickly evolved into a passion project that pushed me to explore new technologies and concepts beyond the classroom.</p>
                <p>Throughout this journey, I've encountered numerous challenges - from implementing secure authentication to designing an intuitive user interface. Each obstacle became an opportunity to learn and grow, teaching me valuable lessons about both technical implementation and problem-solving approaches.</p>
                <p>The most rewarding aspect has been seeing how theoretical concepts from my coursework translate into practical solutions. This project has reinforced my belief that hands-on experience is the most effective way to solidify knowledge and develop genuine expertise.</p>
            </div>
            <div class="col-lg-6">
                <img src="https://picsum.photos/seed/coding-project/600/400.jpg" alt="Coding Project" class="img-fluid rounded shadow project-image">
            </div>
        </div>
        
        <!-- Project Goals -->
        <div class="row mb-5">
            <div class="col-lg-4 mb-4">
                <div class="about-card text-center">
                    <i class="bi bi-lightbulb feature-icon"></i>
                    <h3>Learning Goals</h3>
                    <p>Master full-stack development with Spring Boot, understand database design, and implement security best practices.</p>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="about-card text-center">
                    <i class="bi bi-bug feature-icon"></i>
                    <h3>Challenges Faced</h3>
                    <p>Implementing password encryption, managing sessions, and creating a responsive UI that works across devices.</p>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="about-card text-center">
                    <i class="bi bi-trophy feature-icon"></i>
                    <h3>Achievements</h3>
                    <p>Built a complete e-commerce platform with user authentication, product catalog, shopping cart, and order management.</p>
                </div>
            </div>
        </div>
        
        <!-- Development Timeline -->
        <div class="mb-5">
            <h2 class="mb-4 text-center">Project Development Timeline</h2>
            <div class="row">
                <div class="col-lg-6">
                    <div class="timeline">
                        <div class="timeline-item">
                            <h5>Phase 1: Planning</h5>
                            <p>Designed the database schema, mapped out user journeys, and created wireframes for key pages.</p>
                        </div>
                        <div class="timeline-item">
                            <h5>Phase 2: Backend Development</h5>
                            <p>Implemented the Spring Boot backend with JPA repositories and REST controllers for all entities.</p>
                        </div>
                        <div class="timeline-item">
                            <h5>Phase 3: User Authentication</h5>
                            <p>Created user registration and login systems with session management and role-based access control.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="timeline">
                        <div class="timeline-item">
                            <h5>Phase 4: Shopping Features</h5>
                            <p>Developed product catalog, shopping cart functionality, and order processing with payment integration.</p>
                        </div>
                        <div class="timeline-item">
                            <h5>Phase 5: Security Enhancements</h5>
                            <p>Implemented password encryption with BCrypt, security questions for password recovery, and input validation.</p>
                        </div>
                        <div class="timeline-item">
                            <h5>Phase 6: UI/UX Refinement</h5>
                            <p>Enhanced the user interface with responsive design, improved navigation, and added visual feedback.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Key Features -->
        <div class="mb-5">
            <h2 class="mb-4 text-center">Key Features of ShopHub</h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="about-card">
                        <h5><i class="bi bi-person-check me-2"></i>User Authentication</h5>
                        <p>Secure registration and login system with encrypted passwords and role-based access control.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="about-card">
                        <h5><i class="bi bi-cart3 me-2"></i>Shopping Cart</h5>
                        <p>Dynamic cart functionality that persists between sessions and calculates totals in real-time.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="about-card">
                        <h5><i class="bi bi-receipt me-2"></i>Order Management</h5>
                        <p>Complete order processing system with status tracking and order history for users.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="about-card">
                        <h5><i class="bi bi-shield-lock me-2"></i>Password Security</h5>
                        <p>BCrypt password encryption with security questions and OTP-based password recovery.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="about-card">
                        <h5><i class="bi bi-star me-2"></i>Product Reviews</h5>
                        <p>User feedback system with ratings and comments to help customers make informed decisions.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="about-card">
                        <h5><i class="bi bi-phone me-2"></i>Responsive Design</h5>
                        <p>Mobile-friendly interface that adapts to different screen sizes for optimal user experience.</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Personal Reflection -->
        <div class="row mb-5">
            <div class="col-lg-12">
                <div class="about-card">
                    <h2 class="mb-4 text-center">Lessons Learned</h2>
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <h5><i class="bi bi-lightbulb text-primary me-2"></i>Technical Growth</h5>
                            <p>This project significantly expanded my technical skills. I learned to implement <span class="highlight">password encryption</span> using BCrypt, which was initially challenging but crucial for security. I also gained practical experience with <span class="highlight">session management</span>, <span class="highlight">database design</span>, and <span class="highlight">RESTful API development</span>.</p>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5><i class="bi bi-gear text-primary me-2"></i>Problem Solving</h5>
                            <p>When implementing the password reset feature, I encountered several issues with the OTP verification process. Through debugging and research, I learned to systematically identify and resolve problems, a skill that extends beyond coding into all aspects of software development.</p>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5><i class="bi bi-people text-primary me-2"></i>User Experience</h5>
                            <p>Designing an intuitive user interface taught me the importance of putting myself in the users' shoes. I learned to create flows that feel natural and provide clear feedback at each step, especially during critical processes like checkout and password recovery.</p>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5><i class="bi bi-graph-up text-primary me-2"></i>Continuous Learning</h5>
                            <p>Perhaps the most valuable lesson has been embracing the learning process itself. Technology evolves rapidly, and this project taught me to enjoy the journey of discovering new concepts rather than feeling overwhelmed by them.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Call to Action -->
        <div class="text-center py-5">
            <h2 class="mb-3">Explore My Work</h2>
            <p class="lead mb-4">ShopHub represents my dedication to learning and creating meaningful solutions</p>
            <a href="/productlist" class="btn btn-primary btn-lg me-3">Browse Products</a>
            <a href="/contactus" class="btn btn-outline-primary btn-lg">Get In Touch</a>
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