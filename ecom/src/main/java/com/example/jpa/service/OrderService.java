package com.example.jpa.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.jpa.dao.CartDao;
import com.example.jpa.dao.CartItemDao;
import com.example.jpa.dao.OrderDao;
import com.example.jpa.dao.OrderItemDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Cart;
import com.example.jpa.model.CartItem;
import com.example.jpa.model.Order;
import com.example.jpa.model.OrderItem;

@Service
public class OrderService {

    private final OrderDao orderDao;
    private final OrderItemDao orderItemDao;
    private final CartDao cartDao;
    private final CartItemDao cartItemDao;
    private final CartService cartService;

    public OrderService(OrderDao orderDao,
                        OrderItemDao orderItemDao,
                        CartDao cartDao,
                        CartItemDao cartItemDao,
                        CartService cartService) {
        this.orderDao = orderDao;
        this.orderItemDao = orderItemDao;
        this.cartDao = cartDao;
        this.cartItemDao = cartItemDao;
        this.cartService = cartService;
    }

    /**
     * Places a new order from the given cart items.
     * Cart is NOT cleared here — wait until payment success.
     */
    @Transactional
    public Order placeOrder(Account account,
                            List<CartItem> cartItems,
                            String line1,
                            String city,
                            String postal,
                            String country,
                            String phoneNumber) {

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalArgumentException("Cart is empty");
        }

        // 1. Find existing PENDING_PAYMENT orders by this user
        List<Order> pendingOrders = orderDao.findByAccountAndStatus(account, "PENDING_PAYMENT");

        // 2. Check if any existing order has exactly the same items
        for (Order existingOrder : pendingOrders) {
            if (sameItems(existingOrder.getItems(), cartItems)) {
                if (sameAddress(existingOrder, line1, city, postal, country, phoneNumber)) {
                    // Same items + same address → consider it a duplicate
                    return existingOrder;
                } else {
                    // Same items but different address → allow new order
                    continue;
                }
            }
        }

        // 3. No duplicate found, create new order
        double subtotal = cartItems.stream()
                .mapToDouble(i -> i.getProduct().getPrice() * i.getQty())
                .sum();
        double tax = subtotal * 0.18; // 18% GST
        double shipping = subtotal < 500 ? subtotal * 0.12 : 0;
        double total = subtotal + tax + shipping;

        Order order = new Order();
        order.setAccount(account);
        order.setLine1(line1);
        order.setCity(city);
        order.setPostal(postal);
        order.setCountry(country);
        order.setPhoneNumber(phoneNumber);
        order.setOrderDate(LocalDateTime.now());
        order.setStatus("PENDING_PAYMENT");
        order.setSubtotal(subtotal);
        order.setTax(tax);
        order.setShipping(shipping);
        order.setTotal(total);

        // save order first to generate ID
        orderDao.save(order);

        // Create order items
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cartItems) {
            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            oi.setProduct(cartItem.getProduct());
            oi.setQty(cartItem.getQty());
            oi.setPrice(cartItem.getProduct().getPrice());
            orderItems.add(oi);
        }

        orderItemDao.saveAll(orderItems);
        order.setItems(orderItems);

        return order;
    }

    /**
     * Save or update an order.
     */
    public Order save(Order order) {
        return orderDao.save(order);
    }

    /**
     * Fetch an order by ID
     */
    public Order getOrderById(Long orderId) {
        return orderDao.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }

    public Order findByRazorpayPaymentId(String paymentId) {
        return orderDao.findByRazorpayPaymentId(paymentId).orElse(null);
    }
    
    private boolean sameItems(List<OrderItem> existingItems, List<CartItem> cartItems) {
        if (existingItems.size() != cartItems.size()) return false;

        Map<Long, Integer> existingMap = existingItems.stream()
            .collect(Collectors.toMap(
                item -> item.getProduct().getId(),
                OrderItem::getQty
            ));

        for (CartItem ci : cartItems) {
            Integer qty = existingMap.get(ci.getProduct().getId());
            if (qty == null || qty != ci.getQty()) {
                return false;
            }
        }
        return true;
    }
    
    private String normalize(String s) {
        if (s == null) return "";
        return s.trim().replaceAll("\\s+", " ").toLowerCase();
    }

    @Transactional
    public void rollbackOrderToCart(Long orderId) {
        Order order = orderDao.findById(orderId)
            .orElseThrow(() -> new RuntimeException("Order not found"));

        Account account = order.getAccount();

        // 1. Repopulate the cart
        Cart cart = cartDao.findByAccount(account).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setAccount(account);
            return cartDao.save(newCart);
        });

        // Clear current cart to avoid duplicates
        cartService.clearCart(cart);

        for (OrderItem item : order.getItems()) {
            CartItem cartItem = new CartItem();
            cartItem.setCart(cart);
            cartItem.setProduct(item.getProduct());
            cartItem.setQty(item.getQty());
            cartItemDao.save(cartItem);
            cart.getItems().add(cartItem);
        }

        cartDao.save(cart); // Save updated cart

        // 2. Delete order items (cascades if configured, but ensure)
        orderItemDao.deleteAll(order.getItems());

        // 3. Delete the order itself
        orderDao.delete(order);
    }
    
    private boolean sameAddress(Order existingOrder,
            String line1,
            String city,
            String postal,
            String country,
            String phoneNumber) {
        return normalize(existingOrder.getLine1()).equals(normalize(line1)) &&
               normalize(existingOrder.getCity()).equals(normalize(city)) &&
               normalize(existingOrder.getPostal()).equals(normalize(postal)) &&
               normalize(existingOrder.getCountry()).equals(normalize(country)) &&
               normalize(existingOrder.getPhoneNumber()).equals(normalize(phoneNumber));
    }
    @Transactional
    public void convertOrderToCartWithoutStockAdjustment(Long orderId) {
        Order order = orderDao.findById(orderId)
            .orElseThrow(() -> new RuntimeException("Order not found"));

        Account account = order.getAccount();

        // 1. Repopulate the cart
        Cart cart = cartDao.findByAccount(account).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setAccount(account);
            return cartDao.save(newCart);
        });

        // Clear current cart to avoid duplicates
        cartService.clearCartWithoutRestocking(cart);

        for (OrderItem item : order.getItems()) {
            CartItem cartItem = new CartItem();
            cartItem.setCart(cart);
            cartItem.setProduct(item.getProduct());
            cartItem.setQty(item.getQty());
            cartItemDao.save(cartItem);
            cart.getItems().add(cartItem);
        }

        cartDao.save(cart); // Save updated cart

        // 2. Delete order items (cascades if configured, but ensure)
        orderItemDao.deleteAll(order.getItems());

        // 3. Delete the order itself
        orderDao.delete(order);
    }
}