package com.example.jpa.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.jpa.model.CartItem;
import com.example.jpa.model.Product;

@Repository
public interface CartItemDao extends JpaRepository<CartItem, Long> {

	long countByProduct(Product product);
	
}
