 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Sign Up - ShopHub</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    body {
      background: linear-gradient(120deg, #e3f2fd, #ffffff);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .signup-card {
      background: #fff;
      border-radius: 14px;
      box-shadow: 0 6px 20px rgba(0,0,0,0.07);
      padding: 40px 35px;
      max-width: 520px;
      width: 100%;
    }

    h2 {
      color: #0d6efd;
      font-weight: 700;
      text-align: center;
      margin-bottom: 1.2rem;
    }

    .section-title {
      display: flex;
      align-items: center;
      font-weight: 600;
      margin-bottom: 8px;
      color: #212529;
    }

    .section-title i {
      color: #0d6efd;
      margin-right: 6px;
      font-size: 1.1rem;
    }

    .form-control, .form-select {
      border-radius: 8px;
      padding: 10px;
      border: 1px solid #ced4da;
      transition: all 0.2s ease-in-out;
    }

    .form-control:focus, .form-select:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 0 0.15rem rgba(13, 110, 253, 0.25);
    }

    .btn-primary {
      background-color: #0d6efd;
      border: none;
      font-weight: 600;
      padding: 12px;
      border-radius: 10px;
      transition: background-color 0.3s ease, transform 0.15s ease;
    }

    .btn-primary:hover {
      background-color: #0b5ed7;
      transform: translateY(-1px);
    }

    .text-link {
      color: #0d6efd;
      text-decoration: none;
      font-weight: 500;
      transition: color 0.3s ease;
    }

    .text-link:hover {
      color: #0a58ca;
      text-decoration: underline;
    }

    .divider {
      display: flex;
      align-items: center;
      text-align: center;
      margin: 1.5rem 0;
      color: #6c757d;
      font-size: 0.9rem;
    }
    .divider::before, .divider::after {
      content: "";
      flex: 1;
      border-bottom: 1px solid #dee2e6;
    }
    .divider:not(:empty)::before { margin-right: .75em; }
    .divider:not(:empty)::after { margin-left: .75em; }
  </style>
</head>

<body>
  <div class="signup-card">
  <% String msg = (String) request.getAttribute("msg"); %>
    <h2><i class="bi bi-person-plus-fill me-1"></i> Create Account</h2>
<% if(msg != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <form action="/createacc" method="post">
      <div class="mb-3">
        <label for="signupName" class="section-title"><i class="bi bi-person"></i>Full Name</label>
        <input type="text" class="form-control" id="signupName" name="name" required>
      </div>

      <div class="mb-3">
        <label for="signupEmail" class="section-title"><i class="bi bi-envelope"></i>Email Address</label>
        <input type="email" class="form-control" id="signupEmail" name="email" required>
      </div>

      <div class="mb-3">
        <label for="signupPassword" class="section-title"><i class="bi bi-lock"></i>Password</label>
        <input type="password" class="form-control" id="signupPassword" name="password" required>
      </div>

      <div class="mb-3">
        <label for="confirmPassword" class="section-title"><i class="bi bi-lock-fill"></i>Confirm Password</label>
        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
      </div>

      <div class="mb-3">
        <label for="securityQuestion" class="section-title"><i class="bi bi-shield-lock"></i>Security Question</label>
        <select class="form-select" id="securityQuestion" name="sec_q" required>
          <option value="">-- Select a question --</option>
          <option value="pet">What is your pet's name?</option>
          <option value="birthplace">What is your birthplace's name?</option>
          <option value="school">What was the name of your school's  name?</option>
          <option value="friend">What is your best friend's name?</option>
        </select>
      </div>

      <div class="mb-3">
        <label for="securityAnswer" class="section-title"><i class="bi bi-key"></i>Your Answer</label>
        <input type="text" class="form-control" id="securityAnswer" name="sec_a" required>
      </div>

      <input type="hidden" name="role" value="user">

      <div class="form-check mb-4">
        <input type="checkbox" class="form-check-input" id="agreeTerms" required>
        <label class="form-check-label" for="agreeTerms">
          I agree to the <a href="#" class="text-link">terms and conditions</a>
        </label>
      </div>

      <div class="d-grid">
        <button type="submit" class="btn btn-primary btn-lg">
          <i class="bi bi-person-check me-1"></i> Sign Up
        </button>
      </div>
    </form>

    <div class="divider">Or</div>

    <div class="text-center">
      <a href="/log" class="text-link d-block mb-2">
        <i class="bi bi-box-arrow-in-right"></i> Already have an account? Login Now!
      </a>
      <a href="/" class="text-link d-block">
        <i class="bi bi-house"></i> Go to Home? Continue as a Guest!
      </a>
    </div>
  </div>
	
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
