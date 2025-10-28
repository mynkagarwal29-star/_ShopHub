package com.example.jpa.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.jpa.model.OrderItem;
import com.example.jpa.model.Product;

public interface OrderItemDao extends JpaRepository<OrderItem, Long> {
	
	@Query("SELECT COUNT(oi) FROM OrderItem oi WHERE oi.product = :product AND " +
		       "LOWER(oi.order.delivery_status) NOT IN ('OUT_FOR_DELIVERY', 'COMPLETED')")
		long countActiveOrdersByProduct(@Param("product") Product product);


}
