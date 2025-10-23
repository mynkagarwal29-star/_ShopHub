package com.example.jpa.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.jpa.dao.OrderDao;
import com.example.jpa.dao.OrderItemDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.CartItem;
import com.example.jpa.model.Order;
import com.example.jpa.service.CartService;
import com.example.jpa.service.FeedbackService;
import com.example.jpa.service.OrderService;
import com.example.jpa.service.PaymentService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
public class OrderController {

    private final OrderService orderService;
    private final CartService cartService;
    private final PaymentService paymentService;
    private final OrderDao orderDao;
    private final OrderItemDao orderItemDao;
    private final FeedbackService feedbackService;
    
    @Value("${razorpay.key.id:rzp_test_dummykey}")
    private String razorpayKeyId;

    public OrderController(FeedbackService feedbackService,OrderItemDao orderItemDao, OrderDao orderDao, OrderService orderService, CartService cartService, PaymentService paymentService) {
        this.orderService = orderService;
        this.cartService = cartService;
        this.paymentService = paymentService;
        this.orderDao = orderDao;
        this.orderItemDao = orderItemDao;
		this.feedbackService = feedbackService;
    }

    @PostMapping("/orders/place")
    public String placeOrder(
            @RequestParam String line1,
            @RequestParam String city,
            @RequestParam String postal,
            @RequestParam String country,
            @RequestParam String phoneNumber,
            HttpSession session,
            Model model) {

        Account user = (Account) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/log";
        }

        List<CartItem> cartItems = cartService.getCartItemsByUser(user);
        if (cartItems == null || cartItems.isEmpty()) {
            model.addAttribute("error", "Cart is empty.");
            return "redirect:/cart";
        }

        Order order = orderService.placeOrder(user, cartItems, line1, city, postal, country, phoneNumber);

        // Round total amount to 2 decimal places
        double totalAmount = order.getTotal();
        totalAmount = Math.round(totalAmount * 100.0) / 100.0;  // ensures 2 decimal digits

        // Convert to paise for Razorpay (integer)
        long amountInPaise = Math.round(totalAmount * 100);

        // Dummy Razorpay order ID for now
        String razorpayOrderId = "order_dummy_" + System.currentTimeMillis();

        model.addAttribute("order", order);
        model.addAttribute("razorpayOrderId", razorpayOrderId);
        model.addAttribute("razorpayKeyId", razorpayKeyId);
        model.addAttribute("amount", amountInPaise);
        model.addAttribute("currency", "INR");

        return "orderdetail"; // your JSP or Thymeleaf page to show order details
    }

    
    @GetMapping("/order/orderconfirm")
    public String confirmationPage(@RequestParam Long orderId, Model model) {
        Order order = orderService.getOrderById(orderId);
        model.addAttribute("order", order);
        cartService.clearCart(order.getAccount());
        
        boolean feedbackExists = feedbackService.feedbackExistsForOrder(orderId, order.getAccount().getId());
        model.addAttribute("feedbackExists", feedbackExists);
        
        return "orderconfirm";  // the JSP name for your confirmation page
    }
    
    @GetMapping("/orders/edit")
    public String editOrder(
        @RequestParam(required = false) Long orderId,
        @RequestParam(required = false) String redirectTo,
        Model model,
        HttpSession session
    ) {
        Account user = (Account) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/log";
        }
        
        Order order = orderService.getOrderById(orderId);

        model.addAttribute("line1", order.getLine1());
        model.addAttribute("city", order.getCity());
        model.addAttribute("postal", order.getPostal());
        model.addAttribute("country", order.getCountry());
        model.addAttribute("phoneNumber", order.getPhoneNumber());
        
        // Convert order back to cart without adjusting product quantities
        orderService.convertOrderToCartWithoutStockAdjustment(orderId);

        // Redirect to desired page if provided, otherwise go to cart
        if (redirectTo != null && !redirectTo.isEmpty()) {
            return "redirect:" + redirectTo;
        } else {
            return "forward:/cart";
        }
    }

    @GetMapping("/order/details")
    public String orderDetails(@RequestParam("id") Long orderId, Model model, HttpSession session) {
        // Updated to use currentUser instead of accdata
        Account user = (Account) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/log"; // Redirect if not logged in
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null || order.getAccount().getId() != user.getId()) {
            // Order not found or does not belong to logged-in user
            return "redirect:/"; // or an error page
        }
        boolean feedbackExists = feedbackService.feedbackExistsForOrder(orderId, order.getAccount().getId());
        model.addAttribute("feedbackExists", feedbackExists);
        
        model.addAttribute("order", order);
        
        return "orderconfirm"; // your JSP page name
    }
    
    @Transactional
    @GetMapping("AdminSideOrder")
    public String orders_recieved(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) String status,
            Model model, HttpSession session) {

        Account user = (Account) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/log";
        }

        // Fetch with items eagerly
        List<Order> orders = orderDao.findAllWithItems();

        // Apply filters in memory
        if (userId != null) {
            orders = orders.stream()
                    .filter(order -> order.getAccount().getId() == userId)
                    .collect(Collectors.toList());
        }

        if (userName != null && !userName.isEmpty()) {
            orders = orders.stream()
                    .filter(order -> order.getAccount().getName() != null &&
                                     order.getAccount().getName().toLowerCase().contains(userName.toLowerCase()))
                    .collect(Collectors.toList());
        }

        if (status != null && !status.isEmpty()) {
            orders = orders.stream()
                    .filter(order -> status.equalsIgnoreCase(order.getDelivery_status()))
                    .collect(Collectors.toList());
        }

        model.addAttribute("data", orders);

        long totalOrders = orders.size();
        long confirmedOrders = orders.stream()
                .filter(o -> "CONFIRMED".equalsIgnoreCase(o.getDelivery_status()))
                .count();
        long packedOrders = orders.stream()
                .filter(o -> "PACKED".equalsIgnoreCase(o.getDelivery_status()))
                .count();
        long shippedOrders = orders.stream()
                .filter(o -> "OUT_FOR_DELIVERY".equalsIgnoreCase(o.getDelivery_status()))
                .count();
        long completedOrders = orders.stream()
                .filter(o -> "COMPLETED".equalsIgnoreCase(o.getDelivery_status()))
                .count();
        long cancelledOrders = orders.stream()
                .filter(o -> "CANCELLED".equalsIgnoreCase(o.getDelivery_status()) ||
                             "FAILED".equalsIgnoreCase(o.getDelivery_status()))
                .count();

        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("confirmedOrders", confirmedOrders);
        model.addAttribute("packedOrders", packedOrders);
        model.addAttribute("shippedOrders", shippedOrders);
        model.addAttribute("completedOrders", completedOrders);
        model.addAttribute("cancelledOrders", cancelledOrders);

        return "admin_order";
    }


    
    @PostMapping("/updateDeliveryStatus")
    public String updateDeliveryStatus(
            @RequestParam Long orderId,
            @RequestParam String deliveryStatus,
            @RequestParam(required = false) String userId,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) String status,
            RedirectAttributes redirectAttributes,HttpSession session) {

    	 Account user = (Account) session.getAttribute("currentUser");
         if (user == null) {
             return "redirect:/log";
         }
        // Find and update the order
        Order order = orderDao.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        
        order.setDelivery_status(deliveryStatus);
        orderDao.save(order);

        // Preserve filters on redirect
        if (userId != null && !userId.isEmpty()) {
            redirectAttributes.addAttribute("userId", userId);
        }
        if (userName != null && !userName.isEmpty()) {
            redirectAttributes.addAttribute("userName", userName);
        }
        if (status != null && !status.isEmpty()) {
            redirectAttributes.addAttribute("status", status);
        }

        // Redirect back with preserved filters
        return "redirect:/AdminSideOrder";
    }
    @GetMapping("/deleteOrder/{orderId}")
    public String deleteOrder(
            @PathVariable("orderId") Long orderId,
            HttpServletRequest request,
            HttpSession session) {

        Account user = (Account) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/log";
        }

        // Check if the order exists
        orderDao.findById(orderId).ifPresent(order -> {
            // Optional: ensure user owns the order or is admin
            if (order.getAccount().getId() == user.getId() || "ADMIN".equalsIgnoreCase(user.getRole())) {
                orderDao.delete(order);
            }
        });

        // Redirect back to the referring page
        String referer = request.getHeader("Referer");
        return (referer != null) ? "redirect:" + referer : "redirect:/";
    }

}