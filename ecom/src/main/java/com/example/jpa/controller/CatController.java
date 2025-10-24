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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

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
    public String addCategory(@ModelAttribute("cat") Category cat, 
                             @RequestParam("file") MultipartFile file,
                             ModelMap model) {
        if(file.isEmpty()) {
            model.put("msg", "Please upload a file!");
            return "error";
        }
        try {
            // Ensure Directory is present as in the upload_dr else make one
            File dir = new File(Upload_DIR);
            if(!dir.exists()) {
                dir.mkdirs();
            }
            
            if (cd.existsByCategory(cat.getCategory())) {
                model.put("error", "Category already exists!");
                return "error";
            }
            
            // Saving the file
            String fileName = file.getOriginalFilename();
            if (fileName != null && !fileName.isEmpty()) {
                Path path = Paths.get(Upload_DIR, fileName);
                Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                // Save the name in db
                cat.setImage(fileName);
            } else {
                model.put("error", "Invalid file selected.");
                return "error";
            }
            
            // Save category to db
            cd.save(cat);
            model.put("added", "Category Added!");
            return "redirect:Category";
        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to save file: " + e.getMessage());
            return "error";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Unexpected error occurred: " + e.getMessage());
            return "error";
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
    public String editCategory(@PathVariable("id") int id, HttpServletRequest request) {
        Category category = cd.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid category Id:" + id));
        request.setAttribute("cat", category);
        return "/addCat";
    }
    
    @PostMapping("/updateCategory")
    public String updateCategory(@ModelAttribute("cat") Category cat,
                               @RequestParam("file") MultipartFile file,
                               HttpServletRequest request) {
        try {
            // Fetch the existing category from DB
            Category existing = cd.findById(cat.getId()).orElseThrow();
            String oldName = existing.getCategory();

            // Handle file upload
            if (!file.isEmpty()) {
                String fileName = file.getOriginalFilename();
                Path path = Paths.get(Upload_DIR, fileName);
                Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
                cat.setImage(fileName);
            } else {
                // Keep old image
                cat.setImage(existing.getImage());
            }

            // Save the updated category
            cd.save(cat);

            // Update products that have the old category name
            List<Product> products = pd.findByCategory(oldName);
            for (Product p : products) {
                p.setCategory(cat.getCategory());
            }
            pd.saveAll(products);

            // Success message
            request.setAttribute("success", "Category updated successfully!");
            return "redirect:Category";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating category: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/addForm")
    public String getAllCategoryinProductForm(Model model) {
        List<Category> cat = cd.findAll();
        model.addAttribute("category", cat);
        return "addForm";
    }
}