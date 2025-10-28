package com.example.jpa.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.jpa.dao.CatDao;
import com.example.jpa.dao.ProductDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Category;
import com.example.jpa.model.Product;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
    @Autowired
    CatDao cd;
    @Autowired
    ProductDao pd;
    
    @GetMapping("/")
    public String home(Model model, HttpSession session) {
        try {
            // Clear any problematic session attributes
            session.removeAttribute("adminloggedin");
            session.removeAttribute("loggedInUser");
            
            // Get current user (if any)
            Account currentUser = (Account) session.getAttribute("currentUser");
            
            // Add categories and products to model
            model.addAttribute("category", cd.findAll());
            model.addAttribute("product", pd.findTop4ByOrderByIdDesc());
            
            // Cart count is now handled by GlobalCartCountAdvice
            
            return "index";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
    
    @GetMapping("/productlist")
    public String allProductsUser(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "8") int size,
            @RequestParam(required = false) String search,
            Model model) {

        Page<Product> productPage;

        if (search != null && !search.trim().isEmpty()) {
            String keyword = search.trim().toLowerCase(); // ✅ lowercase here
            List<Product> results = pd.searchByNameOrDescriptionRaw(keyword);

            int start = page * size;
            int end = Math.min(start + size, results.size());
            List<Product> paged = results.subList(start, end);
            Pageable pageable = PageRequest.of(page, size);
            productPage = new PageImpl<>(paged, pageable, results.size());
        } else {
            Pageable pageable = PageRequest.of(page, size);
            productPage = pd.findAll(pageable);
        }

        model.addAttribute("productPage", productPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", productPage.getTotalPages());
        model.addAttribute("search", search);

        return "productlist";
    }





    @GetMapping("/user_category")
    public String shopbycategory(Model model) {
        List<Category> cat = cd.findAll();
        model.addAttribute("category", cat);
        return "user_cat";
    }
    
    @GetMapping("/productdetail/{id}")
    public String productDetails(@PathVariable Long id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "4") int size,
            Model model) {
        // Fetch main product
        Product prod = pd.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        model.addAttribute("product", prod);

        // Fetch related products (same category) with pagination
        Page<Product> relatedPage = pd.findByCategory(prod.getCategory(), PageRequest.of(page, size));

        // Exclude current product from the list
        List<Product> prod_cat = relatedPage.stream()
                .filter(p -> !p.getId().equals(prod.getId()))
                .toList();

        model.addAttribute("prod_cat", prod_cat);
        model.addAttribute("relatedCurrentPage", page);
        model.addAttribute("relatedTotalPages", relatedPage.getTotalPages());

        return "productdetail";
    }

    @GetMapping("/select_pd/{category}")
    public String getProducts(@PathVariable String category,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "6") int size,
            Model model) {

        List<Category> cat = cd.findAll();

        // Fetch products by category with pagination
        Page<Product> productPage = pd.findByCategory(category, PageRequest.of(page, size));

        model.addAttribute("category", cat);
        model.addAttribute("productPage", productPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", productPage.getTotalPages());
        model.addAttribute("selectedCategory", category);

        return "user_cat";
    }

    @GetMapping("/log")
    public String login_registered_user() {
        return "login";
    }
    @GetMapping("/forgotPassword")
    public String login_pre_registered_user(@RequestParam String email,Model model,HttpSession session) {
    	
  		session.invalidate();
    	model.addAttribute("email",email);
        return "login";
    }
    @GetMapping("/sig")
    public String signup_new_user() {
        return "signup";
    }
    

    
    @GetMapping("/about")
    public String Aboutus() {
        return "about";
    }
    
    @GetMapping("/contactus")
    public String contactus() {
        return "contactus";
    }
}