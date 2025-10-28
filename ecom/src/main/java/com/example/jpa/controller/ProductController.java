package com.example.jpa.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.jpa.dao.AccDao;
import com.example.jpa.dao.CartItemDao;
import com.example.jpa.dao.CatDao;
import com.example.jpa.dao.OrderItemDao;
import com.example.jpa.dao.ProductDao;
import com.example.jpa.model.Account;
import com.example.jpa.model.Category;
import com.example.jpa.model.Product;

import jakarta.servlet.http.HttpSession;

@Controller
public class ProductController {
    @Autowired
    ProductDao pd;
    @Autowired
    CatDao cd;
    @Autowired
    CartItemDao cartItemDao;
    @Autowired
    AccDao ad;
    @Autowired
    OrderItemDao oid;
    public static final String Upload_DIR="uploads/";
    
    @PostMapping("/addProduct")
    public String addProduct(@ModelAttribute("product") Product product, @RequestParam("file") MultipartFile file, RedirectAttributes model) {
        if(file.isEmpty()) {
            model.addAttribute("msg", "Please upload a file!");
            return "error";
        }
        try {
            //Ensure Directory is present as in the upload_dr else make one
            File dir=new File(Upload_DIR);
            if(!dir.exists()) {
                dir.mkdirs();
            }
            
            //saving the file
            String fileName=file.getOriginalFilename();
            if (fileName != null && !fileName.isEmpty()) {
                Path path = Paths.get(Upload_DIR, fileName);
                Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                //save the name in db
                product.setImagePath(fileName);
            } else {
                model.addAttribute("error", "Invalid file selected.");
                return "error"; // error.jsp
            }
            //save category to db
            pd.save(product);
            model.addFlashAttribute("msg", "Product was Added Successfully!");
            return "redirect:/viewitem";
        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to save file: " + e.getMessage());
            return "error"; // Redirect to error.jsp or display error page
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Unexpected error occurred: " + e.getMessage());
            return "error";
        }
    }
    
    @GetMapping("/viewrecord/{id}")//GETTING PRODUCT DETAILS FROM DASHBOARD SELECTION
    public String editproduct(@PathVariable Long id, Model model) {
        Product prod=pd.findById(id).get();
        
        List<Category> cat=cd.findAll();
        model.addAttribute("product", prod);
        model.addAttribute("category", cat);
        return "updateForm";
    }
    
    @PostMapping("/updateProduct")
    public String edited(@ModelAttribute("product") Product product, 
                         @RequestParam("file") MultipartFile file, 
                         RedirectAttributes model) throws IOException {
        
        // Get existing product details
        Product existing = pd.findById(product.getId())
                             .orElseThrow(() -> new IllegalArgumentException("Invalid product ID:" + product.getId()));
        
        // Handle image upload
        if (!file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            Path path = Paths.get("uploads/", fileName);
            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
            product.setImagePath(fileName);
        } else {
            // Keep existing image if no new file uploaded
            product.setImagePath(existing.getImagePath());
        }
        
        // Special handling for category updates
        if ("MISCELLANEOUS".equals(existing.getCategory()) || "RANDOM FINDS".equals(existing.getCategory())) {
            // Validate that the new category exists in the database
            List<Category> categories = cd.findAll();
            boolean categoryExists = categories.stream()
                .anyMatch(cat -> cat.getCategory().equals(product.getCategory()) && 
                                 !"MISCELLANEOUS".equals(cat.getCategory()));
            
            if (!categoryExists) {
                model.addFlashAttribute("error", "Invalid category selected!");
                return "redirect:/editForm?id=" + product.getId();
            }
        } else {
            // For non-miscellaneous/random finds products, keep original category
            product.setCategory(existing.getCategory());
        }
        
        // Save updated product
        pd.save(product);
        model.addFlashAttribute("msg", "Product was Updated Successfully!");
        return "redirect:/viewitem";
    }    
    @GetMapping("/viewitem")
    public String getAllData(@RequestParam(value = "category", required = false) String category,
                             @RequestParam(value = "stockSort", required = false) String stockSort,
                             @RequestParam(value = "search", required = false) String search,
                             Model model, HttpSession session) {

        Account currentUser = (Account) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            return "redirect:/log"; // Or "/log"
        }

     // 🔹 Active Users = Total accounts - 1 (assuming only one admin)
        int totalAccounts = ad.findAll().size(); // Or use ad.count()
        int activeUsers = totalAccounts > 0 ? totalAccounts - 1 : 0;
        model.addAttribute("activeUsers", activeUsers);

        // 🔹 Total Sales = Number of OrderItems
        int totalSales = oid.findAll().size(); // Or use oid.count()
        model.addAttribute("totalSales", totalSales);
        
        List<Product> products = pd.findAll();

        // Filter by category
        if (category != null && !category.isEmpty()) {
            products = products.stream()
                .filter(p -> p.getCategory() != null && p.getCategory().equalsIgnoreCase(category))
                .collect(Collectors.toList());
        }

        // Filter by search (name or description)
        if (search != null && !search.trim().isEmpty()) {
            String lowerSearch = search.toLowerCase();
            products = products.stream()
                .filter(p -> p.getName().toLowerCase().contains(lowerSearch) ||
                             p.getDescription().toLowerCase().contains(lowerSearch))
                .collect(Collectors.toList());
        }

        // Sort by stock
        if (stockSort != null) {
            if (stockSort.equals("lowToHigh")) {
                products.sort(Comparator.comparingInt(Product::getQuantity));
            } else if (stockSort.equals("highToLow")) {
                products.sort((a, b) -> Integer.compare(b.getQuantity(), a.getQuantity()));
            }
        }

        model.addAttribute("data", products);
        model.addAttribute("category", cd.findAll());
        model.addAttribute("selectedCategory", category);
        model.addAttribute("stockSort", stockSort);
        model.addAttribute("search", search);

        return "dashboard";
    }


    @GetMapping("/deletepd/{id}")
    public String deleteProduct(@PathVariable Long id, RedirectAttributes model) {
        Product product = pd.findById(id).orElse(null);

        if (product != null) {
            // Check if product is in any customer's cart
            long cartCount = cartItemDao.countByProduct(product);

            // Check if product is in any active (not yet delivered) orders
            long activeOrderCount = oid.countActiveOrdersByProduct(product);

            if (cartCount > 0) {
                model.addFlashAttribute("msg", 
                    "Cannot delete product: it is present in one or more customers' carts.");
                return "redirect:/viewitem";
            }

            if (activeOrderCount > 0) {
                model.addFlashAttribute("msg", 
                    "Cannot delete product: it is part of an active order (not yet delivered or completed).");
                return "redirect:/viewitem";
            }

            // ✅ If product is only in delivered/completed orders, it's safe to delete
            pd.deleteById(id);
            model.addFlashAttribute("msg", "Product was deleted successfully!");
        } else {
            model.addFlashAttribute("msg", "Product not found.");
        }

        return "redirect:/viewitem";
    }

}