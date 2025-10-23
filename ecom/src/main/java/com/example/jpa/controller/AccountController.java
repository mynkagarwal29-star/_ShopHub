package com.example.jpa.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.jpa.dao.AccDao;
import com.example.jpa.dao.CartDao;
import com.example.jpa.dao.FeedbackDao;
import com.example.jpa.dao.OrderDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Cart;
import com.example.jpa.model.Feedback;
import com.example.jpa.model.Order;
import com.example.jpa.service.CartService;
import com.example.jpa.service.FeedbackService;
import com.example.jpa.service.OtpService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Controller
public class AccountController {
    @Autowired
    AccDao ac, accDao;

    @Autowired
    CartService cartService;
    @Autowired
    CartDao cartDao;
    @Autowired
    OtpService otpservice;
    @Autowired
    OrderDao orderDao;
    @Autowired
    FeedbackDao feedbackDao;
    @Autowired
    FeedbackService feedbackService;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder; // Added password encoder
    
    @GetMapping("/profiledetails")
    public String profileDetails(HttpSession session, Model model) {
        Account currentUser = (Account) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/log";
        }

        Account account = accDao.findById(currentUser.getId())
                .orElse(currentUser);

        List<Order> orders = orderDao.findOrdersWithItems(account);

        List<Order> recentOrders = orders.stream()
                .sorted((o1, o2) -> o2.getOrderDate().compareTo(o1.getOrderDate()))
                .toList();

        List<Feedback> userFeedbacks = feedbackService.getFeedbacksByUserId(currentUser.getId());

        model.addAttribute("account", account);
        model.addAttribute("orderCount", orders.size());
        model.addAttribute("recentOrders", recentOrders);
        model.addAttribute("userFeedbacks", userFeedbacks);

        return "profile";
    }
    
    @PostMapping("/createacc")
    public String signup(@RequestParam("confirmPassword") String cp,
            @ModelAttribute Account user, RedirectAttributes model, 
            HttpServletRequest request) {
        System.out.println("Signup triggered");
        
        // Check if passwords match
        if (!user.getPassword().equals(cp)) {
            model.addFlashAttribute("msg", "Passwords do not match");
            return "redirect:" + getReferer(request);
        }
        
        // Check for duplicate email
        Optional<Account> existingUser = accDao.findByEmail(user.getEmail());
        if (existingUser.isPresent()) {
            model.addFlashAttribute("msg", "Email already exists");
            return "redirect:" + getReferer(request);
        }
        
        // Encrypt password before saving
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        ac.save(user);
        model.addFlashAttribute("sms", "Account created successfully! You may login now.");
        return "redirect:/log";
    }
    
    @PostMapping("/loginprocess")
    public String login(@RequestParam("email") String email,
            @RequestParam("password") String pwd,
            ModelMap model, HttpSession session) {

        // Find user by email only
        Account user = ac.findByEmail(email).orElse(null);
        if (user != null && passwordEncoder.matches(pwd, user.getPassword())) {
            // Clear old attributes
            session.removeAttribute("udata");
            session.removeAttribute("accdata");
            session.removeAttribute("AccHolder");
            session.removeAttribute("adminloggedin");
            session.removeAttribute("loggedInUser");

            // Set the current user in session
            session.setAttribute("currentUser", user);

            if (user.getRole().equals("user")) {
                // Merge guest cart if exists
                Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
                boolean hasItemsInCart = false;

                if (guestCart != null && !guestCart.isEmpty()) {
                    Cart cart = cartService.getCartByAccount(user);
                    for (Map.Entry<Long, Integer> entry : guestCart.entrySet()) {
                        cartService.addToCart(user, entry.getKey(), entry.getValue());
                    }
                    session.removeAttribute("guestCart");
                    hasItemsInCart = true;
                }

                return hasItemsInCart ? "redirect:/cart" : "redirect:/profiledetails";
            } else if (user.getRole().equals("admin")) {
                session.setAttribute("adminloggedin", "Welcome Admin!");
                session.setAttribute("loggedInUser", "Admin");
                return "redirect:/viewitem";
            }
        }
        model.put("msg", "Wrong credentials !");
        return "login";
    }
    
    @GetMapping("logout")
    public String logout(HttpServletRequest req, HttpServletResponse response) {
        // Invalidate session
        req.getSession().invalidate();
        
        // Clear any cookies if needed
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                cookie.setValue("");
                cookie.setPath("/");
                cookie.setMaxAge(0);
                response.addCookie(cookie);
            }
        }
        
        // Redirect to home page
        return "redirect:/log";
    }
    
    
    @PostMapping("/sendResetOtp")
    public ResponseEntity<String> sendOtp(@RequestParam String email, HttpSession session) {
        // Get the logged-in user from session
        Account currentUser = (Account) session.getAttribute("currentUser");
        if(currentUser != null)
        // Check if the email belongs to the logged-in user
        if (!currentUser.getEmail().equalsIgnoreCase(email)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You can only request OTP for your own email.");
        }
        
        try {
            // Send OTP (no need to check DB since we already verified ownership)
            otpservice.generateAndSendOtp(email);
            return ResponseEntity.ok("OTP sent successfully to " + email);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Failed to send OTP. Please try again later.");
        }
    }


    @PostMapping("/verifyResetOtp")
    public ResponseEntity<Void> verifyOtp(@RequestParam String email, @RequestParam String otp) {
        boolean valid = otpservice.verifyOtp(email, otp);
        return valid ? ResponseEntity.ok().build() : ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
    
    
    @PostMapping("/updatePassword")
    public ResponseEntity<String> updatePassword(
            @RequestParam String email,
            @RequestParam String newPassword
            ) {
        // Find the account by email
        Optional<Account> optionalUser = ac.findByEmail(email);
        if (optionalUser.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                 .body("User not found");
        }

        Account user = optionalUser.get();
        // Update password with encryption
        user.setPassword(passwordEncoder.encode(newPassword));
        ac.save(user);

        // Clear any stored OTP if using session/cache
        otpservice.clearOtp(email);  
        
        return ResponseEntity.ok("Password updated successfully");
    }
    
    @PostMapping("/updatePasswordFull")
    public String updatePasswordFull(
            @RequestParam String email,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            @RequestParam String answer,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        Optional<Account> optionalUser = ac.findByEmail(email);
        if (optionalUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "User not found");
            return "redirect:/log";
        }

        Account user = optionalUser.get();

        if (!user.getSec_a().equalsIgnoreCase(answer.trim())) {
            redirectAttributes.addFlashAttribute("error", "Security answer was incorrect");
            return "redirect:/profiledetails";
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match");
            return "redirect:/profiledetails";
        }

        // Update password with encryption
        user.setPassword(passwordEncoder.encode(newPassword));
        ac.save(user);
        otpservice.clearOtp(email);

        // Invalidate current session (log out user)
        session.invalidate();

        redirectAttributes.addFlashAttribute("sms", "Password updated successfully. Please login again.");
        return "redirect:/log";
    }


    @PostMapping("/updateEmail")
    public String updateEmail(
            @RequestParam("newEmail") String newEmail,
            @RequestParam("currentPassword") String currentPassword,
            HttpSession session,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        Account currentUser = (Account) session.getAttribute("currentUser");

        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("msg", "login");
            return "redirect:/log";
        }

        // Check current password using password encoder
        if (!passwordEncoder.matches(currentPassword, currentUser.getPassword())) {
            redirectAttributes.addFlashAttribute("msg", "pwd");
            return "redirect:" + getReferer(request);
        }

        // Check if new email already exists
        Optional<Account> existing = accDao.findByEmail(newEmail);
        if (existing.isPresent()) {
            redirectAttributes.addFlashAttribute("msg", "e");
            return "redirect:" + getReferer(request);
        }

        // Update email
        currentUser.setEmail(newEmail);
        accDao.save(currentUser);
        session.setAttribute("currentUser", currentUser);

        redirectAttributes.addFlashAttribute("msg", "ok");
        return "redirect:" + getReferer(request);
    }

    // Utility method to safely get the referring page
    private String getReferer(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        return (referer != null && !referer.isEmpty()) ? referer : "/";
    }
    
    @PostMapping("/deleteAccount")
    @Transactional
    public String deleteAccount(HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            Account sessionAccount = (Account) session.getAttribute("currentUser");
            if (sessionAccount == null) {
                redirectAttributes.addFlashAttribute("msg", "login");
                return "redirect:/log";
            }

            Account user = accDao.findById(sessionAccount.getId())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            // Find and delete cart using the correct method
            cartDao.findByAccount(user).ifPresent(cart -> {
                // Cart items will be deleted automatically due to CascadeType.ALL and orphanRemoval
                cartDao.delete(cart);
            });

            // Delete account (will cascade to orders and feedbacks if properly configured)
            accDao.delete(user);
            session.invalidate();

            redirectAttributes.addFlashAttribute("msg", "deleted");
            return "redirect:/";
        } catch (DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("error", "Cannot delete account due to existing references");
            return "redirect:/account";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting account: " + e.getMessage());
            return "redirect:/account";
        }
    }
}