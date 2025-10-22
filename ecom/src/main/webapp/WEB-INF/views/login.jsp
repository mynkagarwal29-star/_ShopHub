<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.jpa.model.Account" %>
<%
    Account currentUser = (Account) session.getAttribute("currentUser");
    if (currentUser != null) {
        response.sendRedirect("/");
        return;
    }
    String msg = (String) request.getAttribute("msg");
    String sms = (String) request.getAttribute("sms");
    String email = (String) request.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login - ShopHub</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<style>
body { 
    background: linear-gradient(120deg, #e3f2fd, #ffffff);
    font-family:'Segoe UI',sans-serif; 
    min-height:100vh;
}
.container { 
    max-width: 480px; 
    margin-top:70px; 
    padding:40px; 
    background:#fff; 
    border-radius:16px; 
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
}
h2 { 
    font-weight:700; 
    color:#0d6efd; 
}
.btn-primary { 
    background-color:#0d6efd; 
    border:none; 
    font-weight:600;
}
.btn-primary:hover { background-color:#0b5ed7; }
a.text-link { 
    color:#0d6efd; 
    text-decoration:none; 
    font-weight:500; 
    transition:color 0.3s ease;
}
a.text-link:hover { color:#0a58ca; text-decoration:underline; }
.divider {
    display: flex;
    align-items: center;
    text-align: center;
    color: #6c757d;
    margin: 1.5rem 0;
}
.divider::before, .divider::after {
    content: '';
    flex: 1;
    border-bottom: 1px solid #dee2e6;
}
.divider:not(:empty)::before {
    margin-right: .75em;
}
.divider:not(:empty)::after {
    margin-left: .75em;
}
.icon-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
}
.modal-content {
    border-radius: 12px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.15);
}
        /* Flashing animation for attention */
        .beep-animation {
            animation: flashColor 1s infinite;
        }

        @keyframes flashColor {
            0% { color: red; }
            50% { color: black; }
            100% { color: red; }
        }
        .glow {
    color: #0dcaf0;
    text-shadow: 0 0 5px #0dcaf0, 0 0 10px #0dcaf0, 0 0 20px #0dcaf0;
    transition: all 0.4s ease-in-out;
  }
</style>
</head>
<body>

<div class="container">
    <h2 class="text-center mb-4"><i class="bi bi-shop"></i> Login to ShopHub</h2>

    <% if(msg != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
	<% if(sms != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i><%= sms %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>

    <form action="/loginprocess" method="post">
        <div class="mb-3">
            <label class="fw-semibold">Email address</label>
            <input type="email" class="form-control" name="email" placeholder="Enter your email" value="<%= (email != null) ? email : "" %>" required>
  		</div>
        <div class="mb-3">
            <label class="fw-semibold">Password</label>
            <input type="password" class="form-control" name="password" placeholder="Enter your password" required>
        </div>
        <div class="d-grid">
            <button type="submit" class="btn btn-primary btn-lg">
                <i class="bi bi-box-arrow-in-right me-1"></i> Login
            </button>
        </div>
    </form>

    <div class="text-center mt-4">
       <a href="#" id="forgotPasswordLink"
   class="text-link me-3 <% if(email != null){ %>glow<% } %>">
   <i class="bi bi-key"></i> Forgot Password?
</a>

        <br>
        <a href="/sig" class="text-link">
            <i class="bi bi-person-plus"></i> Don't have an account? Sign Up Now!
        </a>
    </div>

    <div class="divider">Or</div>

    <div class="text-center">
        <a href="/" class="btn btn-outline-primary icon-btn">
            <i class="bi bi-person-walking"></i> Continue as Guest
        </a>
    </div>
</div>

<!-- Reset Password Modal -->
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
    $('#forgotPasswordLink').click(function(){
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

</body>
</html>
