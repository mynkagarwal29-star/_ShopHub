package com.example.jpa.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.example.jpa.model.Account;
import com.example.jpa.model.Feedback;
import com.example.jpa.service.FeedbackService;
import com.example.jpa.service.OrderService;
import jakarta.servlet.http.HttpSession;
@Controller
@RequestMapping("/feedback")
public class FeedbackController {

    private final FeedbackService feedbackService;
    private final OrderService orderService;

    public FeedbackController(FeedbackService feedbackService, OrderService orderService) {
        this.feedbackService = feedbackService;
        this.orderService = orderService;
    }

    // Record feedback from user
    @PostMapping("/record")
    public String recordFeedback(@RequestParam Long orderId,
                                 @RequestParam int rating,
                                 @RequestParam(required = false) String comments,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {

        Account user = (Account) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/log";
        }

        // Sanitize and normalize comments
        if (comments != null) {
            comments = comments.trim(); // remove leading/trailing spaces
            comments = comments.replaceAll("\\s+", " "); // replace multiple spaces with a single space
            comments = comments.replaceAll("[\\u0000-\\u001F\\u007F]", ""); // remove control characters
            if (comments.length() > 1000) { // optional: limit to 1000 chars
                comments = comments.substring(0, 1000);
            }
        }

        try {
            feedbackService.saveFeedback(orderId, rating, comments, user);
            redirectAttributes.addFlashAttribute("feedbackSuccess", true);
        } catch (RuntimeException e) {
            if (e.getMessage().contains("Feedback already exists")) {
                redirectAttributes.addFlashAttribute("feedbackExists", true);
            } else {
                redirectAttributes.addFlashAttribute("feedbackError", e.getMessage());
            }
        }

        return "redirect:/order/orderconfirm?orderId=" + orderId;
    }

    /* Admin feedback page
    @GetMapping("/feed")
    public String feedbackPage(Model model, HttpSession session) {
        Account user = (Account) session.getAttribute("currentUser");
        if (user == null || !user.getRole().equalsIgnoreCase("ADMIN")) {
            return "redirect:/log";
        }

        List<Feedback> feedbackList = feedbackService.getAllFeedbacks();

        // Convert createdAt to java.util.Date for JSP compatibility
        List<Map<String, Object>> feedbackViewList = feedbackList.stream().map(f -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", f.getId());
            map.put("comment", f.getComment());
            map.put("rating", f.getRating());
            map.put("accountName", f.getAccount().getName());
            map.put("orderId", f.getOrder().getId());
            map.put("createdAt", java.sql.Timestamp.valueOf(f.getCreatedAt())); // ✅ converted here
            return map;
        }).toList();

        int totalReviews = feedbackList.size();
        double avgRating = 0;
        int fiveStarReviews = 0;

        if (totalReviews > 0) {
            double sum = feedbackList.stream().mapToInt(Feedback::getRating).sum();
            avgRating = sum / totalReviews;
            fiveStarReviews = (int) feedbackList.stream().filter(f -> f.getRating() == 5).count();
        }

        avgRating = Math.round(avgRating * 10) / 10.0;

        model.addAttribute("feedbackList", feedbackViewList);
        model.addAttribute("totalReviews", totalReviews);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("fiveStarReviews", fiveStarReviews);
        model.addAttribute("unresolvedCount", 0);

        return "feedback";
    }*/

    
    // Delete feedback
    @GetMapping("/delete/{id}")
    public String deleteFeedback(@PathVariable Long id, HttpSession session) {
        Account user = (Account) session.getAttribute("currentUser");
        if (user == null || !user.getRole().equalsIgnoreCase("ADMIN")) {
            return "redirect:/log";
        }

        feedbackService.deleteFeedback(id);
        return "redirect:/feed";
    }
}