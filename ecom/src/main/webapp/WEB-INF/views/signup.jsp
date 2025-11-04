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

    .section-title i { color: #0d6efd; margin-right: 6px; }
    .error-message { color: red; font-size: 0.85rem; margin-top: 3px; }
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

    <!-- Form Start -->
    <form id="signupForm" action="/createacc" method="post" onsubmit="return handleSignup(event);">

      <!-- Full Name -->
      <div class="mb-3">
        <label class="section-title"><i class="bi bi-person"></i>Full Name</label>
        <input type="text" class="form-control" id="signupName" name="name" required>
        <div id="nameError" class="error-message"></div>
      </div>

      <!-- Email -->
      <div class="mb-3">
        <label class="section-title"><i class="bi bi-envelope"></i>Email Address</label>
        <input type="email" class="form-control" id="signupEmail" name="email" required>
        <div id="emailError" class="error-message"></div>
      </div>

      <!-- Password -->
      <div class="mb-3">
        <label class="section-title"><i class="bi bi-lock"></i>Password</label>
        <input type="password" class="form-control" id="signupPassword" name="password" required>
        <div id="passwordError" class="error-message"></div>
      </div>

      <!-- Confirm Password -->
      <div class="mb-3">
        <label class="section-title"><i class="bi bi-lock-fill"></i>Confirm Password</label>
        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
        <div id="confirmPasswordError" class="error-message"></div>
      </div>

      <!-- Security Question -->
      <div class="mb-3">
        <label class="section-title"><i class="bi bi-shield-lock"></i>Security Question</label>
        <select class="form-select" id="securityQuestion" name="sec_q" required>
          <option value="">-- Select a question --</option>
          <option value="pet">What is your pet's name?</option>
          <option value="birthplace">What is your birthplace's name?</option>
          <option value="school">What was your school's name?</option>
          <option value="friend">What is your best friend's name?</option>
        </select>
        <div id="questionError" class="error-message"></div>
      </div>

      <!-- Security Answer -->
      <div class="mb-3">
        <label class="section-title"><i class="bi bi-key"></i>Your Answer</label>
        <input type="text" class="form-control" id="securityAnswer" name="sec_a" required>
        <div id="answerError" class="error-message"></div>
      </div>

      <input type="hidden" name="role" value="user">

      <div class="form-check mb-4">
        <input type="checkbox" class="form-check-input" id="agreeTerms" required>
        <label class="form-check-label" for="agreeTerms">
          I agree to the <a href="#" class="text-link">terms and conditions</a>
        </label>
        <div id="termsError" class="error-message"></div>
      </div>

      <div class="d-grid">
        <button type="submit" class="btn btn-primary btn-lg">
          <i class="bi bi-person-check me-1"></i> Sign Up
        </button>
      </div>
    </form>

    <div class="divider text-center my-3">Or</div>

    <div class="text-center">
      <a href="/log" class="text-link d-block mb-2">
        <i class="bi bi-box-arrow-in-right"></i> Already have an account? Login Now!
      </a>
      <a href="/" class="text-link d-block">
        <i class="bi bi-house"></i> Go to Home? Continue as a Guest!
      </a>
    </div>
  </div>

  <!-- OTP Verification Modal -->
  <div class="modal fade" id="otpModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content p-3">
        <div class="modal-header">
          <h5 class="modal-title"><i class="bi bi-shield-lock"></i> Verify Your Email</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>We’ve sent a verification code (OTP) to your email. Please enter it below to verify your account.</p>
          <input type="text" id="otpInput" class="form-control mb-2" placeholder="Enter OTP">
          <div id="otpError" class="error-message"></div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-primary" onclick="verifyOtp()">Verify OTP</button>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    const otpModal = new bootstrap.Modal(document.getElementById('otpModal'));

    async function handleSignup(event) {
      event.preventDefault();
      if (!validateForm()) return false;

      const email = document.getElementById('signupEmail').value.trim();
      try {
        const res = await fetch('/sendSignupOtp', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: new URLSearchParams({ email })
        });

        if (res.ok) {
          otpModal.show();
        } else {
          const msg = await res.text();
          alert('Failed to send OTP: ' + msg);
        }
      } catch (e) {
        alert('Error sending OTP. Try again later.');
      }
      return false;
    }

    async function verifyOtp() {
      const email = document.getElementById('signupEmail').value.trim();
      const otp = document.getElementById('otpInput').value.trim();
      document.getElementById('otpError').textContent = '';

      if (otp.length === 0) {
        document.getElementById('otpError').textContent = 'Please enter the OTP.';
        return;
      }

      try {
        const res = await fetch('/verifySignupOtp', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: new URLSearchParams({ email, otp })
        });

        if (res.ok) {
          otpModal.hide();
          // Proceed with actual signup form submission
          document.getElementById('signupForm').submit();
        } else {
          document.getElementById('otpError').textContent = 'Invalid OTP. Please try again.';
        }
      } catch (e) {
        document.getElementById('otpError').textContent = 'Error verifying OTP. Try again.';
      }
    }

    // existing validateForm() function here (keep as is)
    function validateForm() {
      let valid = true;
      document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
      const name = document.getElementById('signupName').value.trim();
      const email = document.getElementById('signupEmail').value.trim();
      const password = document.getElementById('signupPassword').value;
      const confirmPassword = document.getElementById('confirmPassword').value;
      const question = document.getElementById('securityQuestion').value;
      const answer = document.getElementById('securityAnswer').value.trim();
      const terms = document.getElementById('agreeTerms').checked;

      if (name.length < 3 || !/^[A-Za-z\s]+$/.test(name)) {
        document.getElementById('nameError').textContent = 'Full name must be at least 3 letters and contain only alphabets.';
        valid = false;
      }

      const emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,}$/i;
      if (!emailPattern.test(email)) {
        document.getElementById('emailError').textContent = 'Please enter a valid email.';
        valid = false;
      }

      const passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
      if (!passPattern.test(password)) {
        document.getElementById('passwordError').textContent = 'Password must be 8+ chars with upper, lower, number & symbol.';
        valid = false;
      }

      if (confirmPassword !== password) {
        document.getElementById('confirmPasswordError').textContent = 'Passwords do not match.';
        valid = false;
      }

      if (question === '') {
        document.getElementById('questionError').textContent = 'Please select a question.';
        valid = false;
      }

      if (answer.length < 2 || !/^[A-Za-z0-9\s]+$/.test(answer)) {
        document.getElementById('answerError').textContent = 'Provide a valid answer.';
        valid = false;
      }

      if (!terms) {
        document.getElementById('termsError').textContent = 'You must agree to terms.';
        valid = false;
      }
      return valid;
    }
  </script>
</body>
</html>
