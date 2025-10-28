package com.example.jpa.dao;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.jpa.model.Product;

public interface ProductDao extends JpaRepository<Product, Long> {

    // Get latest 4 products
    List<Product> findTop4ByOrderByIdDesc();

    // Find products by category
    List<Product> findByCategory(String category);
    Page<Product> findByCategory(String category, Pageable pageable);

    // Search products by name (case-insensitive) with pagination
    Page<Product> findByNameContainingIgnoreCase(String name, Pageable pageable);

    // Search products by name or description (case-insensitive) with pagination
    @Query("""
    	    SELECT p FROM Product p 
    	    WHERE lower(p.name) LIKE %:keyword%
    	       OR lower(p.description) LIKE %:keyword%
    	""")
    	List<Product> searchByNameOrDescription(@Param("keyword") String keyword);

    // Raw search without pagination (case-insensitive)
    @Query("SELECT p FROM Product p WHERE " +
           "LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(p.description) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Product> searchByNameOrDescriptionRaw(@Param("keyword") String keyword);

    // Count products by category
    int countByCategory(String category);
}
