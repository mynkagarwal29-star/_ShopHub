package com.example.jpa.dao;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.jpa.model.Account;
import com.example.jpa.model.Feedback;
import com.example.jpa.model.Order;

public interface FeedbackDao extends JpaRepository<Feedback, Long> {
	  List<Feedback> findAll();
	Optional<Feedback> findByOrder(Order order);
    Optional<Feedback> findByAccount(Account account);
    boolean existsByOrderIdAndAccountId(Long orderId, Long accountId);
    @Query("SELECT f FROM Feedback f WHERE f.account.id = :userId ORDER BY f.createdAt DESC")
    List<Feedback> findByAccountId(@Param("userId") Long userId);
}
