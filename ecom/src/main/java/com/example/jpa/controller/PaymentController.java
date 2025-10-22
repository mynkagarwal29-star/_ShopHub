package com.example.jpa.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.jpa.dao.OrderDao;
import com.example.jpa.model.Order;
import com.example.jpa.service.EmailService;
import com.example.jpa.service.OrderService;
import com.example.jpa.service.PaymentService;

@Controller
@RequestMapping("/api/payment")
public class PaymentController {

    @Autowired
    private PaymentService razorpayService;

    @Autowired
    private OrderService orderService;
    
    @Autowired
    private OrderDao orderDao;
    
    @Autowired
    private EmailService emailService;

    @PostMapping("/createRazorpayorder")
    public String createOrder(
            @RequestParam Long orderId,  // Add this param
            @RequestParam double amount,
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String contact,
            Model model) {

        model.addAttribute("orderId", orderId);
        razorpayService.createOrder(amount, name, email, contact, model);
        return "checkout";
    }
    
    @GetMapping("/checkout")
    public String checkout() {
        return "checkout";
    }
    
    // Since we cannot verify, we just update the order status to PAID when the frontend says payment is done.
    @PostMapping("/success")
    public ResponseEntity<String> paymentSuccess(
            @RequestParam Long orderId,
            @RequestParam String paymentId) {

        Order order = orderService.getOrderById(orderId);
        order.setStatus("PAID");
        order.setDelivery_status("CONFIRMED");
        order.setRazorpayPaymentId(paymentId); // Save payment id
        orderService.save(order);
     
        // after payment is successful
        emailService.sendSimpleMail(
            order.getAccount().getEmail(),
            "Order Confirmation - Order #" + order.getId(),
            "Thank you for your order! Your order #" + order.getId() + " has been successfully placed.\n"
            + "Payment ID: " + paymentId + "\n\n"
            + "Estimated Delivery: 3-5 business days."
        );

        return ResponseEntity.ok("Payment recorded successfully");
    }
    @PostMapping("/failure")
    public ResponseEntity<String> paymentFailure(@RequestParam Long orderId) {
        try {
            orderDao.findById(orderId).ifPresent(orderDao::delete);
            return ResponseEntity.ok("Order deleted due to payment failure");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Failed to handle payment failure");
        }
    }

}