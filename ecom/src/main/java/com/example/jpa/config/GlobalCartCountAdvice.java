package com.example.jpa.config;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.example.jpa.dao.AccDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Cart;
import com.example.jpa.service.CartService;

import jakarta.servlet.http.HttpSession;
import org.springframework.ui.Model;

@ControllerAdvice
public class GlobalCartCountAdvice {

    @Autowired
    private CartService cartService;

    @Autowired
    private AccDao accountDao;

    @ModelAttribute
    public void addCartCountToModel(HttpSession session, Model model) {
        int cartCount = 0;

        // Get the current user from session (Account object)
        Account currentUser = (Account) session.getAttribute("currentUser");
        if (currentUser != null) {
            // User is logged in
            Cart cart = cartService.getCartByAccount(currentUser);
            if (cart != null && cart.getItems() != null) {
                cartCount = cart.getItems().stream()
                        .mapToInt(item -> item.getQty())
                        .sum();
            }
        } else {
            // User is a guest
            Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
            if (guestCart != null) {
                cartCount = guestCart.values().stream()
                        .mapToInt(Integer::intValue)
                        .sum();
            }
        }

        model.addAttribute("cartCount", cartCount);
    }
}