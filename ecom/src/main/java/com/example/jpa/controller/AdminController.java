package com.example.jpa.controller;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.jpa.dao.AccDao;
import com.example.jpa.dao.CartDao;
import com.example.jpa.dao.OrderDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Feedback;
import com.example.jpa.model.Order;
import com.example.jpa.model.OrderItem;
import com.example.jpa.service.FeedbackService;
import com.example.jpa.service.OrderService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {

    @Autowired
    AccDao acc;
    @Autowired
    OrderDao orderDao;
 
    @Autowired
    CartDao cartDao;
    
    private final FeedbackService feedbackService ;
    private final OrderService orderService ;

    public AdminController(FeedbackService feedbackService, OrderService orderService) {
        this.feedbackService = feedbackService;
        this.orderService = orderService;
    }
    
    @GetMapping("/addCat")
    public String addCategory() {
        return "addCat";
    }
    
    @GetMapping("/trainer")
    public String viewUsers(
            @RequestParam(value = "withOrdersOnly", required = false, defaultValue = "false") boolean withOrdersOnly,
            @RequestParam(value = "sortOrder", required = false) String sortOrder,
            Model model) {

        // Get all non-admin users
        List<Account> allUsers = acc.findAllUsers().stream()
                .filter(u -> !"admin".equalsIgnoreCase(u.getRole()))
                .collect(Collectors.toList());

        // Count active users (carts)
        long activeUsersCount = cartDao.count();
        model.addAttribute("activeUsers", activeUsersCount -1);

        // Build order count map
        Map<Long, Integer> orderCountMap = new HashMap<>();
        int usersWithoutOrders = 0;
        int usersWithOrders = 0;

        for (Account user : allUsers) {
            int orderCount = orderDao.countByAccount_Id(user.getId());
            orderCountMap.put(user.getId(), orderCount);
            if (orderCount > 0) usersWithOrders++;
            else usersWithoutOrders++;
        }

        // Filter
        List<Account> filteredUsers = allUsers;
        if (withOrdersOnly) {
            filteredUsers = filteredUsers.stream()
                    .filter(u -> orderCountMap.getOrDefault(u.getId(), 0) > 0)
                    .collect(Collectors.toList());

            // Sort
            if ("asc".equalsIgnoreCase(sortOrder)) {
                filteredUsers.sort(Comparator.comparingInt(u -> orderCountMap.getOrDefault(u.getId(), 0)));
            } else { // default to desc
                filteredUsers.sort((u1, u2) -> Integer.compare(
                        orderCountMap.getOrDefault(u2.getId(), 0),
                        orderCountMap.getOrDefault(u1.getId(), 0)
                ));
            }
        }

        // Add attributes
        model.addAttribute("data", filteredUsers);
        model.addAttribute("totalUsers", allUsers.size());
        model.addAttribute("usersWithoutOrders", usersWithoutOrders);
        model.addAttribute("usersWithOrders", usersWithOrders);
        model.addAttribute("orderCountMap", orderCountMap);

        // Preserve filter state
        model.addAttribute("withOrdersOnly", withOrdersOnly);
        model.addAttribute("sortOrder", sortOrder != null ? sortOrder : "desc");

        return "user"; // or whatever your JSP is named
    }

/*
    @GetMapping("AdminSideOrder")
    public String orders_recieved(Model model) {
    	 List<Order> order = orderDao.findAll();
         model.addAttribute("data", order);
        return "admin_order";
    }
  */  
    // Admin-only: list all feedback
    @GetMapping("/feed")
    public String listAllFeedback(Model model, HttpSession session) {
        Account user = (Account) session.getAttribute("currentUser");
        if (user == null || !user.getRole().equalsIgnoreCase("ADMIN")) {
            return "redirect:/log";
        }

        List<Feedback> feedbackList = feedbackService.getAllFeedbacks();
        model.addAttribute("feedbackList", feedbackList);

        
        int totalReviews = feedbackList.size();
        double avgRating = 0;
        int fiveStarReviews = 0;

        if (totalReviews > 0) {
            double sum = feedbackList.stream().mapToInt(Feedback::getRating).sum();
            avgRating = sum / totalReviews;
            fiveStarReviews = (int) feedbackList.stream().filter(f -> f.getRating() == 5).count();
        }

        avgRating = Math.round(avgRating * 10) / 10.0;

        model.addAttribute("totalReviews", totalReviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("fiveStarReviews", fiveStarReviews);
        
        return "feedback";
    }

    @GetMapping("/viewOrder/{id}")
    public String viewOrder(
            @PathVariable Long id,
            Model model,
            @RequestParam(required = false) String userId,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) String status,
            RedirectAttributes redirectAttributes) {

        Order order = orderService.getOrderWithItems(id); // <-- FIXED

        if (order == null) {
            redirectAttributes.addFlashAttribute("error", "Order not found.");
            return "redirect:/admin/orders";
        }

        // Preserve filters
        if (userId != null && !userId.isEmpty()) redirectAttributes.addAttribute("userId", userId);
        if (userName != null && !userName.isEmpty()) redirectAttributes.addAttribute("userName", userName);
        if (status != null && !status.isEmpty()) redirectAttributes.addAttribute("status", status);

        model.addAttribute("order", order);
        model.addAttribute("orderItems", order.getItems());
        model.addAttribute("orderSize", order.getItems().size());

        return "admin_order_detail";
    }

    @PostMapping("/instantdetail")
    public String instantDetail(@RequestParam Long orderId, Model model) {
        Order order = orderService.getOrderWithItems(orderId); // <-- FIXED

        if (order == null) {
            model.addAttribute("error", "Order not found");
            return "admin_order_detail";
        }

        model.addAttribute("order", order);
        model.addAttribute("orderItems", order.getItems());
        model.addAttribute("orderSize", order.getItems().size());

        return "admin_order_detail";
    }

}
    