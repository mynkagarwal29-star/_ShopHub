package com.example.jpa.dao;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.jpa.model.Account;
import com.example.jpa.model.Cart;

public interface CartDao extends JpaRepository<Cart, Long> {

    // Correct method to find cart by account
    Optional<Cart> findByAccount(Account account);
    long count();
	Optional<Account> findByAccountId(long id);

}
