package com.example.jpa.service;

import com.example.jpa.dao.AccDao;
import com.example.jpa.dao.CartDao;
import com.example.jpa.dao.CartItemDao;
import com.example.jpa.dao.ProductDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Cart;
import com.example.jpa.model.CartItem;
import com.example.jpa.model.Product;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CartService {

    private final CartDao cartDao;
    private final CartItemDao cartItemDao;
    private final ProductDao productDao;
    private final AccDao accountDao;

    public CartService(CartDao cartDao,
                       CartItemDao cartItemDao,
                       ProductDao productDao,
                       AccDao accountDao) {
        this.cartDao = cartDao;
        this.cartItemDao = cartItemDao;
        this.productDao = productDao;
        this.accountDao = accountDao;
    }

    // ✅ Fetch cart by account; create if not exists
    public Cart getCartByAccount(Account account) {
        return cartDao.findByAccount(account).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setAccount(account);
            return cartDao.save(newCart);
        });
    }

    // ✅ Get all items in a user's cart
    public List<CartItem> getCartItemsByUser(Account account) {
        Cart cart = getCartByAccount(account);
        return cart.getItems();
    }

    // ✅ Add product to cart
    public CartItem addToCart(Account account, Long productId, int qty) {
        Cart cart = getCartByAccount(account);
        Product product = productDao.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        if (product.getQuantity() < qty) {
            throw new RuntimeException("Not enough stock available");
        }

        Optional<CartItem> existingItemOpt = cart.getItems().stream()
                .filter(ci -> ci.getProduct().getId().equals(productId))
                .findFirst();

        if (existingItemOpt.isPresent()) {
            CartItem existingItem = existingItemOpt.get();
            existingItem.setQty(existingItem.getQty() + qty);
            product.setQuantity(product.getQuantity() - qty); // Reduce stock
            productDao.save(product);
            return cartItemDao.save(existingItem);
        }

        CartItem item = new CartItem();
        item.setCart(cart);
        item.setProduct(product);
        item.setQty(qty);
        cart.getItems().add(item);

        product.setQuantity(product.getQuantity() - qty); // Reduce stock
        productDao.save(product);
        return cartItemDao.save(item);
    }

    // ✅ Update quantity (+/- buttons)
    public CartItem updateQuantity(Long cartItemId, int change) {
        CartItem item = cartItemDao.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("CartItem not found"));

        Product product = item.getProduct();
        int newQty = item.getQty() + change;

        if (change > 0 && product.getQuantity() < change) {
            throw new RuntimeException("Not enough stock available");
        }

        if (newQty <= 0) {
            // Restore full qty to product stock
            product.setQuantity(product.getQuantity() + item.getQty());
            productDao.save(product);
            removeFromCart(cartItemId);
            return null;
        }

        // Adjust stock
        product.setQuantity(product.getQuantity() - change);
        item.setQty(newQty);

        productDao.save(product);
        return cartItemDao.save(item);
    }

    // ✅ Remove an item by cartItemId
    public void removeFromCart(Long cartItemId) {
        CartItem item = cartItemDao.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("CartItem not found"));

        Product product = item.getProduct();
        product.setQuantity(product.getQuantity() + item.getQty()); // Restore stock
        productDao.save(product);

        Cart cart = item.getCart();
        cart.getItems().remove(item); // maintain consistency
        cartItemDao.delete(item);
    }

    // ✅ Clear cart fully
    public void clearCart(Account account) {
        Cart cart = getCartByAccount(account);
        for (CartItem item : cart.getItems()) {
            cartItemDao.delete(item);
        }
        cart.getItems().clear();
        cartDao.save(cart);
    }
    
    public void clearCart(Cart cart) {
        if (cart == null) {
            throw new IllegalArgumentException("Cart cannot be null");
        }

        for (CartItem item : cart.getItems()) {
            Product product = item.getProduct();
            product.setQuantity(product.getQuantity() + item.getQty()); // Restore stock
            productDao.save(product);

            cartItemDao.delete(item);
        }

        cart.getItems().clear();
        cartDao.save(cart);
    }

    // ✅ Calculate total value of cart
    public double getCartTotal(Account account) {
        return getCartItemsByUser(account).stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQty())
                .sum();
    }

 // Clear cart without restoring product quantities
    public void clearCartWithoutRestocking(Cart cart) {
        if (cart == null) {
            throw new IllegalArgumentException("Cart cannot be null");
        }

        for (CartItem item : cart.getItems()) {
            // Don't restore stock - just delete the cart item
            cartItemDao.delete(item);
        }

        cart.getItems().clear();
        cartDao.save(cart);
    }
}