package com.example.jpa.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.jpa.dao.AccDao;
import com.example.jpa.dao.CartItemDao;
import com.example.jpa.dao.OrderDao;
import com.example.jpa.dao.ProductDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Cart;
import com.example.jpa.model.CartItem;
import com.example.jpa.model.Order;
import com.example.jpa.model.Product;
import com.example.jpa.service.CartService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartController {

    private final AccDao accountDao;
    private final ProductDao productDao;
    private final CartItemDao cartItemDao;
    private final CartService cartService;
    private final OrderDao orderDao;
    
    public CartController(OrderDao orderDao, CartService cartService, CartItemDao cartItemDao, AccDao accountDao, ProductDao productDao) {
        this.accountDao = accountDao;
        this.orderDao = orderDao;
        this.productDao = productDao;
        this.cartItemDao = cartItemDao;
        this.cartService = cartService;
    }

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        // Updated to use currentUser instead of udata
        Account currentUser = (Account) session.getAttribute("currentUser");
        int cartCount = 0;

        if (currentUser != null) {
            // Load cart items 
            Cart cart = cartService.getCartByAccount(currentUser);
            model.addAttribute("cartItems", cart.getItems());

            // Count total quantities
            cartCount = cart.getItems().stream()
                            .mapToInt(CartItem::getQty)
                            .sum();

            // Check for last order (PENDING_PAYMENT or last placed)
            List<Order> orders = orderDao.findByAccount(currentUser);
            if (!orders.isEmpty()) {
                // Assuming latest order is needed — get most recent by date
                orders.sort((o1, o2) -> o2.getOrderDate().compareTo(o1.getOrderDate()));
                Order latestOrder = orders.get(0);

                model.addAttribute("line1", latestOrder.getLine1());
                model.addAttribute("city", latestOrder.getCity());
                model.addAttribute("postal", latestOrder.getPostal());
                model.addAttribute("country", latestOrder.getCountry());
                model.addAttribute("phoneNumber", latestOrder.getPhoneNumber());
            }

        } else {
            // Guest cart
            Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
            if (guestCart == null) guestCart = new HashMap<>();

            List<CartItem> cartItems = new ArrayList<>();
            for (Map.Entry<Long, Integer> entry : guestCart.entrySet()) {
                Product product = productDao.findById(entry.getKey())
                        .orElseThrow(() -> new RuntimeException("Product not found"));

                CartItem item = new CartItem();
                item.setProduct(product);
                item.setQty(entry.getValue());
                cartItems.add(item);
            }

            model.addAttribute("cartItems", cartItems);

            // Count total quantities
            cartCount = guestCart.values().stream()
                                 .mapToInt(Integer::intValue)
                                 .sum();
        }

        model.addAttribute("cartCount", cartCount);
        return "cart";
    }
    
    @PostMapping("/buy-now")
    public String buyNow(@RequestParam Long productId,
                         @RequestParam int qty,
                         HttpSession session,
                         HttpServletRequest request) {
        // Updated to use currentUser instead of udata
        Account currentUser = (Account) session.getAttribute("currentUser");

        if (currentUser != null) {
            // Logged-in user
            cartService.addToCart(currentUser, productId, qty);
        } else {
            // Guest user
            Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
            if (guestCart == null) guestCart = new HashMap<>();
            guestCart.put(productId, guestCart.getOrDefault(productId, 0) + qty);
            session.setAttribute("guestCart", guestCart);
        }

        // Redirect to cart view page
        return "redirect:/cart";
    }

    @PostMapping("/add")
    public String addToCart(@RequestParam Long productId,
                            @RequestParam int qty,
                            HttpSession session,
                            HttpServletRequest request) {
        // Updated to use currentUser instead of udata
        Account currentUser = (Account) session.getAttribute("currentUser");

        if (currentUser != null) {
            // Logged-in user
            cartService.addToCart(currentUser, productId, qty);
        } else {
            // Guest user
            Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
            if (guestCart == null) guestCart = new HashMap<>();
            guestCart.put(productId, guestCart.getOrDefault(productId, 0) + qty);
            session.setAttribute("guestCart", guestCart);
        }

        // Redirect back to the page where the request came from
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/");
    }

    @PostMapping("/remove")
    public String removeFromCart(@RequestParam(required = false) Long itemId,
                                 @RequestParam(required = false) Long productId,
                                 HttpSession session) {
        // Updated to use currentUser instead of udata
        Account currentUser = (Account) session.getAttribute("currentUser");
        if (currentUser != null) {
            // Logged-in user: remove by CartItem id
            if (itemId != null) {
                cartService.removeFromCart(itemId);
            }
        } else {
            // Guest user: remove by productId
            Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
            if (guestCart != null && productId != null) {
                guestCart.remove(productId);
                session.setAttribute("guestCart", guestCart);
            }
        }
        return "redirect:/cart";
    }

    @PostMapping("/clear")
    public String clearCart(HttpSession session) {
        // Updated to use currentUser instead of udata
        Account currentUser = (Account) session.getAttribute("currentUser");
        if (currentUser != null) {
            Cart cart = cartService.getCartByAccount(currentUser);
            cartService.clearCart(cart);
        } else {
            session.removeAttribute("guestCart");
        }
        return "redirect:/cart";
    }
    
    @PostMapping("/updateQuantity")
    public String updateQuantity(@RequestParam(required = false) Long itemId,
                                 @RequestParam(required = false) Long productId,
                                 @RequestParam int change,
                                 HttpSession session) {
        // Updated to use currentUser instead of udata
        Account currentUser = (Account) session.getAttribute("currentUser");

        if (currentUser != null && itemId != null) {
            try {
                cartService.updateQuantity(itemId, change); // Proper stock handling
            } catch (RuntimeException ex) {
                session.setAttribute("cartError", ex.getMessage());
            }
        } else if (productId != null) {
            // Guest cart: update session only
            Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
            if (guestCart != null) {
                int newQty = guestCart.getOrDefault(productId, 0) + change;
                if (newQty > 0) {
                    guestCart.put(productId, newQty);
                } else {
                    guestCart.remove(productId);
                }
                session.setAttribute("guestCart", guestCart);
            }
        }

        return "redirect:/cart";
    }

    @GetMapping("/rollbacktocart")
    public String backtocart() {
        return "cart";    
    }
}