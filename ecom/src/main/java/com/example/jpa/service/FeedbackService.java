package com.example.jpa.service;

import com.example.jpa.dao.FeedbackDao;
import com.example.jpa.dao.OrderDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Feedback;
import com.example.jpa.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
@Service
public class FeedbackService {

    private final FeedbackDao feedbackDao;
    private final OrderDao orderDao;

    @Autowired
    public FeedbackService(FeedbackDao feedbackDao, OrderDao orderDao) {
        this.feedbackDao = feedbackDao;
        this.orderDao = orderDao;
    }
    @Transactional
    public void saveFeedback(Long orderId, int rating, String comments, Account user) {
        // Validate rating
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        Order order = orderDao.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        // Check if the user is authorized to give feedback for the order
        if (order.getAccount().getId() != (user.getId())) {
            throw new RuntimeException("Unauthorized access to order");
        }
        // Check if feedback already exists for the same order and user (account)
        boolean feedbackExists = feedbackDao.existsByOrderIdAndAccountId(orderId, user.getId());
        if (feedbackExists) {
            throw new RuntimeException("Feedback already exists for this order from the same user");
        }
        // Create new feedback
        Feedback feedback = new Feedback();
        feedback.setOrder(order);
        feedback.setAccount(user);
        feedback.setRating(rating);
        feedback.setComment(comments);
        feedback.setCreatedAt(LocalDateTime.now()); // Set the creation time
        // Save the feedback
        feedbackDao.save(feedback);
    }
    public List<Feedback> getAllFeedbacks() {
        return feedbackDao.findAll();
    }
    public boolean feedbackExistsForOrder(Long orderId, Long userId) {
        return feedbackDao.existsByOrderIdAndAccountId(orderId, userId);
    }
    public List<Feedback> getFeedbacksByUserId(Long userId) {
        return feedbackDao.findByAccountId(userId);
    }
    public void deleteFeedback(Long id) {
        feedbackDao.deleteById(id);
    }
}