<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String key = (String) request.getAttribute("key");
    Double amount = (Double) request.getAttribute("amount");
    String custName = (String) request.getAttribute("custName");
    String custEmail = (String) request.getAttribute("custEmail");
    String custContact = (String) request.getAttribute("custContact");
    Long orderId = (Long) request.getAttribute("orderId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing Payment | Secure Checkout</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/a2e0f6d93a.js" crossorigin="anonymous"></script>

    <!-- Lottie Animations -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.10.1/lottie.min.js"></script>

    <!-- Razorpay -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

    <style>
        body {
            background: linear-gradient(135deg, #007bff 0%, #00b4d8 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: "Poppins", sans-serif;
            color: #333;
        }

        .payment-card {
            background-color: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            text-align: center;
            padding: 40px;
            width: 400px;
            position: relative;
            overflow: hidden;
        }

        .loader {
            width: 180px;
            height: 180px;
            margin: 0 auto 20px;
        }

        .status-text {
            font-size: 1.2rem;
            font-weight: 500;
        }

        .btn {
            border-radius: 10px;
        }

        .hidden {
            display: none !important;
        }

        .success, .failure {
            transition: all 0.4s ease;
        }

        .success h3, .failure h3 {
            font-weight: 600;
        }

        .success i {
            color: #28a745;
            font-size: 3rem;
        }

        .failure i {
            color: #dc3545;
            font-size: 3rem;
        }

        @keyframes fadeInUp {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        .fadeInUp {
            animation: fadeInUp 0.8s ease forwards;
        }
    </style>
</head>

<body>
    <div class="payment-card fadeInUp">
        <!-- Processing Section -->
        <div id="processing">
            <div class="loader" id="lottie-container"></div>
            <h4 class="status-text mb-3">Processing your payment...</h4>
            <p class="text-muted">Please do not refresh or close this page.</p>
        </div>

        <!-- Success Message -->
        <div id="success" class="success hidden">
            <i class="fas fa-check-circle mb-3"></i>
            <h3>Payment Successful!</h3>
            <p class="text-muted">Redirecting to your order confirmation...</p>
        </div>

        <!-- Failure Message -->
        <div id="failure" class="failure hidden">
            <i class="fas fa-times-circle mb-3"></i>
            <h3>Payment Failed</h3>
            <p class="text-muted">Something went wrong. Please try again.</p>
            <a href="/cart" class="btn btn-outline-danger mt-3">Back to Cart</a>
        </div>
    </div>

    <script>
        // Lottie animation (loader)
        const loaderAnim = lottie.loadAnimation({
            container: document.getElementById('lottie-container'),
            renderer: 'svg',
            loop: true,
            autoplay: true,
            path: 'https://assets7.lottiefiles.com/packages/lf20_j1adxtyb.json' // nice spinner animation
        });

        // Razorpay Checkout
  const options = {
    "key": "<%= key %>",
    "amount": <%= (int)(amount * 100) %>,
    "currency": "INR",
    "name": "ShopHub",
    "description": "Order Payment",
    "handler": function (response) {
        showSuccess();
        fetch('/api/payment/success', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'orderId=' + <%= orderId %> + '&paymentId=' + response.razorpay_payment_id
        }).then(res => {
            if(res.ok){
                setTimeout(() => {
                    window.location.href = "/order/details?id=" + <%= orderId %>;
                }, 2000);
            } else {
                showFailure();
            }
        }).catch(err => {
            console.error(err);
            showFailure();
        });
    },
    "prefill": {
        "name": "<%= custName %>",
        "email": "<%= custEmail %>",
        "contact": "<%= custContact %>"
    },
    "theme": { "color": "#007bff" },

    // 👇 Handles when user closes or cancels payment
    "modal": {
        "ondismiss": function() {
            console.log("Payment cancelled by user.");
            showFailure();

            // Notify backend to delete the order
            fetch('/api/payment/failure', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'orderId=' + <%= orderId %>
            }).then(res => {
                if (res.ok) {
                    setTimeout(() => {
                        window.location.href = "/cart";
                    }, 2000);
                } else {
                    console.error("Failed to delete order after payment cancel");
                    window.location.href = "/cart";
                }
            }).catch(err => {
                console.error(err);
                window.location.href = "/cart";
            });
        }
    }
};

                
        const rzp1 = new Razorpay(options);
        rzp1.open();

        // UI helper functions
        function showSuccess() {
            document.getElementById('processing').classList.add('hidden');
            document.getElementById('failure').classList.add('hidden');
            document.getElementById('success').classList.remove('hidden');
        }

        function showFailure() {
            document.getElementById('processing').classList.add('hidden');
            document.getElementById('success').classList.add('hidden');
            document.getElementById('failure').classList.remove('hidden');
        }
    </script>
</body>
</html>
