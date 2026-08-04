package com.example.jpa.controller;

import com.example.jpa.model.Account;
import com.example.jpa.model.Order;
import com.example.jpa.service.EmailService;
import com.example.jpa.service.OrderService;
import com.example.jpa.service.PaymentService;
import com.razorpay.RazorpayException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequestMapping("/api/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private EmailService emailService;

    @GetMapping("/createRazorpayorder")
    public String createOrder(@RequestParam(required = false) Long orderId, Model model) {
        if (orderId == null) {
            model.addAttribute("error", "Order ID is missing. Please place the order again.");
            return "error";
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            model.addAttribute("error", "Order #" + orderId + " not found.");
            return "error";
        }

        try {
            String razorpayOrderId = paymentService.createRazorpayOrder(order.getId(), order.getTotal());
            order.setRazorpayOrderId(razorpayOrderId);
            orderService.save(order);

            Account account = order.getAccount();
            long amountInPaise = Math.round(order.getTotal() * 100);

            // Synchronized key names with checkout.jsp
            model.addAttribute("key", paymentService.getRazorpayKeyId());
            model.addAttribute("amount", amountInPaise);
            model.addAttribute("razorpayOrderId", razorpayOrderId);
            model.addAttribute("orderId", order.getId()); // Matches request.getAttribute("orderId")
            model.addAttribute("custName", account != null ? account.getName() : "");
            model.addAttribute("custEmail", account != null ? account.getEmail() : "");
            model.addAttribute("custContact", order.getPhoneNumber() != null ? order.getPhoneNumber() : "");

            return "checkout";
        } catch (RazorpayException e) {
            e.printStackTrace();
            model.addAttribute("error", "Razorpay Error: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping("/verify")
    @ResponseBody
    public ResponseEntity<String> verifyPayment(@RequestBody Map<String, String> payload) {
        String razorpayOrderId = payload.get("razorpay_order_id");
        String razorpayPaymentId = payload.get("razorpay_payment_id");
        String razorpaySignature = payload.get("razorpay_signature");
        
        if (payload.get("dbOrderId") == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Missing dbOrderId");
        }
        
        Long dbOrderId = Long.parseLong(payload.get("dbOrderId"));

        // Cryptographic HMAC SHA256 Signature Verification
        boolean isValid = paymentService.verifySignature(razorpayOrderId, razorpayPaymentId, razorpaySignature);
        if (!isValid) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Fraudulent payment signature detected");
        }

        Order order = orderService.getOrderById(dbOrderId);
        if (order == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Order not found");
        }

        // Idempotency check
        if ("PAID".equalsIgnoreCase(order.getStatus())) {
            return ResponseEntity.ok("Payment already processed");
        }

        // Update database status
        order.setStatus("PAID");
        order.setDelivery_status("CONFIRMED");
        order.setRazorpayPaymentId(razorpayPaymentId);
        orderService.save(order);

        // Send Email Notification
        if (order.getAccount() != null && order.getAccount().getEmail() != null) {
            emailService.sendSimpleMail(
                order.getAccount().getEmail(),
                "Order Confirmation - Order #" + order.getId(),
                "Thank you for your order! Order #" + order.getId() + " has been successfully placed.\nPayment ID: " + razorpayPaymentId
            );
        }

        return ResponseEntity.ok("Payment verified successfully");
    }

    @PostMapping("/failure")
    @ResponseBody
    public ResponseEntity<String> paymentFailure(@RequestParam Long orderId) {
        Order order = orderService.getOrderById(orderId);
        if (order != null && !"PAID".equalsIgnoreCase(order.getStatus())) {
            order.setStatus("CANCELLED");
            orderService.save(order);
        }
        return ResponseEntity.ok("Order cancelled");
    }
}