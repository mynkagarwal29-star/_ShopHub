package com.example.jpa.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.jpa.model.OrderItem;

public interface OrderItemDao extends JpaRepository<OrderItem, Long> {

}
