package com.example.jpa;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class CartCountFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);

        int cartCount = 0;
        if (session != null) {
            // Check for logged-in user cart
            Object currentUser = session.getAttribute("currentUser");
            if (currentUser != null) {
                // Cart count will be handled by GlobalCartCountAdvice
                cartCount = 0; // Placeholder
            } else {
                // Check for guest cart
                Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
                if (guestCart != null) {
                    cartCount = guestCart.values().stream().mapToInt(Integer::intValue).sum();
                }
            }
        }

        // Make cartCount available for all JSPs in this request
        request.setAttribute("cartCount", cartCount);

        // Continue with next filter or target resource (servlet, JSP, etc.)
        chain.doFilter(request, response);
    }
}