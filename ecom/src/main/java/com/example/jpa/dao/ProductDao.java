package com.example.jpa.dao;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.jpa.model.Product;

public interface ProductDao extends JpaRepository<Product, Long> {
    
    List<Product> findTop4ByOrderByIdDesc();
    List<Product> findByCategory(String category);
    Page<Product> findByCategory(String category, PageRequest of);
    Page<Product> findByNameContainingIgnoreCase(String trim, PageRequest of);

    // For user pagination (e.g., /productlist)
    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<Product> searchByNameOrDescription(@Param("keyword") String keyword, PageRequest pageRequest);

    // For admin search (non-paginated)
    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Product> searchByNameOrDescriptionRaw(@Param("keyword") String keyword);
	int countByCategory(String category);
}
