package com.example.jpa.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

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

import com.example.jpa.dao.CatDao;
import com.example.jpa.dao.ProductDao;
import com.example.jpa.model.Category;
import com.example.jpa.model.Product;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CatController {
    @Autowired
    CatDao cd;
    @Autowired
    ProductDao pd;

    private static final String Upload_DIR="uploads/";
    
    @PostMapping("/addCategory")
    public String addCategory(
            @ModelAttribute("cat") Category cat,
            @RequestParam("file") MultipartFile file,
            RedirectAttributes redirectAttrs) {

        try {
            // Ensure upload directory exists
            File dir = new File(Upload_DIR);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // Validate category name
            if (cd.existsByCategory(cat.getCategory())) {
                redirectAttrs.addFlashAttribute("error", "Category already exists!");
                return "redirect:/Category";
            }

            // Handle file upload
            if (file.isEmpty()) {
                redirectAttrs.addFlashAttribute("error", "Please upload an image!");
                return "redirect:/Category";
            }

            String fileName = file.getOriginalFilename();
            if (fileName == null || fileName.isEmpty()) {
                redirectAttrs.addFlashAttribute("error", "Invalid file name.");
                return "redirect:/Category";
            }

            Path path = Paths.get(Upload_DIR, fileName);
            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
            cat.setImage(fileName);

            // Save category
            cd.save(cat);

            redirectAttrs.addFlashAttribute("success", "Category added successfully!");
            return "redirect:/Category";

        } catch (IOException e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("error", "File upload failed: " + e.getMessage());
            return "redirect:/Category";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("error", "Unexpected error: " + e.getMessage());
            return "redirect:/Category";
        }
    }
    
    @GetMapping("/Category")
    public String viewCategory(Model model) {
        List<Category> cat = cd.findAll();

        // Find category with max number of products
        String catWithMaxProducts = "";
        int maxCount = 0;

        for (Category c : cat) {
            int productCount = pd.countByCategory(c.getCategory());

            if (productCount > maxCount) {
                maxCount = productCount;
                catWithMaxProducts = c.getCategory();
            }
        }

        model.addAttribute("category", cat);
        model.addAttribute("totalcat", cat.size());
        model.addAttribute("catnm", catWithMaxProducts);
        model.addAttribute("catct", maxCount);

        return "Category";
    }


    
    @GetMapping("/deletecat/{id}")
    public String Delete(@PathVariable Long id, Model model) {
        Category categoryToDelete = cd.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid Category ID"));
        
        Category miscCategory = cd.findByCategory("RANDOM FINDS");
        if (miscCategory == null) {
            throw new IllegalStateException("MISCELLANEOUS category not found!");
        }
        
        List<Product> products = pd.findByCategory(categoryToDelete.getCategory());
        for (Product p : products) {
            p.setCategory(miscCategory.getCategory());
            pd.save(p);
        }
        
        cd.deleteById(id);
        return "redirect:/Category";
    }
     
    
    @GetMapping("/editCategory/{id}")
    public String editCategory(@PathVariable("id") long id, HttpServletRequest request) {
        Category category = cd.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid category Id:" + id));
        request.setAttribute("cat", category);
        return "addCat";
    }
    
    @PostMapping("/updateCategory")
    public String updateCategory(
            @ModelAttribute("cat") Category cat,
            @RequestParam("file") MultipartFile file,
            RedirectAttributes redirectAttrs) {

        try {
            // Fetch the existing category from DB
            Category existing = cd.findById(cat.getId())
                    .orElseThrow(() -> new IllegalArgumentException("Category not found for ID: " + cat.getId()));

            String oldName = existing.getCategory();

            // Handle file upload
            if (!file.isEmpty()) {
                String fileName = file.getOriginalFilename();
                if (fileName != null && !fileName.isEmpty()) {
                    Path path = Paths.get(Upload_DIR, fileName);
                    Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                    cat.setImage(fileName);
                }
            } else {
                // Keep old image if no new one is uploaded
                cat.setImage(existing.getImage());
            }

            // Save updated category
            cd.save(cat);

            // Update products using the old category name
            List<Product> products = pd.findByCategory(oldName);
            for (Product p : products) {
                p.setCategory(cat.getCategory());
            }
            pd.saveAll(products);

            redirectAttrs.addFlashAttribute("success", "Category updated successfully!");
            return "redirect:/Category";

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("error", "Error updating category: " + e.getMessage());
            return "redirect:/Category";
        }
    }

    @GetMapping("/addForm")
    public String getAllCategoryinProductForm(Model model) {
        List<Category> cat = cd.findAll();
        model.addAttribute("category", cat);
        return "addForm";
    }
}