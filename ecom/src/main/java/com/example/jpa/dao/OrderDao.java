package com.example.jpa.dao;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.jpa.model.Account;
import com.example.jpa.model.Order;

public interface OrderDao extends JpaRepository<Order, Long> {

	List<Order> findByAccountId(long id);
	List<Order> findByAccountAndStatus(Account account, String status);
	
	Optional<Order> findByRazorpayPaymentId(String razorpayPaymentId);
	List<Order> findByAccount(Account account);
	int countByAccount_Id(long id);
	int countByStatus(String string);
	
}
