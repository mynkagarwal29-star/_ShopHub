package com.example.jpa.dao;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.jpa.model.Product;

public interface ProductDao extends JpaRepository<Product, Long> {

    // ✅ Fetch latest 4 products
    List<Product> findTop4ByOrderByIdDesc();

    // ✅ Category-based finders
    List<Product> findByCategory(String category);
    Page<Product> findByCategory(String category, Pageable pageable);

    // ✅ Name search (built-in Spring Data method)
    Page<Product> findByNameContainingIgnoreCase(String name, Pageable pageable);

    // ✅ Custom full-text style search (name + description)
    @Query("""
           SELECT p FROM Product p
           WHERE LOWER(p.name) LIKE CONCAT('%', LOWER(:keyword), '%')
              OR LOWER(p.description) LIKE CONCAT('%', LOWER(:keyword), '%')
           """)
    Page<Product> searchByNameOrDescription(@Param("keyword") String keyword, Pageable pageable);

    // ✅ Non-paginated version (useful for admin or analytics)
    @Query("""
           SELECT p FROM Product p
           WHERE LOWER(p.name) LIKE CONCAT('%', LOWER(:keyword), '%')
              OR LOWER(p.description) LIKE CONCAT('%', LOWER(:keyword), '%')
           """)
    List<Product> searchByNameOrDescriptionRaw(@Param("keyword") String keyword);

    // ✅ Count by category (used for stats)
    int countByCategory(String category);
}
