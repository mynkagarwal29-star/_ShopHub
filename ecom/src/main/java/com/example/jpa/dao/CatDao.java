package com.example.jpa.dao;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.jpa.model.Category;

public interface CatDao extends JpaRepository<Category, Long> {
	 

	 boolean existsByCategory(String category);

	 Optional<Category> findById(int id);

	 Category findByCategory(String string);
	 
}
