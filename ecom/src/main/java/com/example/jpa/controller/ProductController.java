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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
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

    // ✅ External uploads directory (outside of JAR)
    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @PostMapping("/addProduct")
    public String addProduct(@ModelAttribute("product") Product product,
                             @RequestParam("file") MultipartFile file,
                             RedirectAttributes model) {
        if (file.isEmpty()) {
            model.addFlashAttribute("msg", "Please upload a file!");
            return "redirect:/viewitem";
        }

        try {
            // Ensure upload directory exists
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Save file
            String fileName = file.getOriginalFilename();
            if (fileName != null && !fileName.isEmpty()) {
                Path destination = uploadPath.resolve(fileName);
                Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);
                product.setImagePath(fileName);
            }

            pd.save(product);
            model.addFlashAttribute("msg", "Product added successfully!");
            return "redirect:/viewitem";

        } catch (IOException e) {
            e.printStackTrace();
            model.addFlashAttribute("error", "File save failed: " + e.getMessage());
            return "redirect:/viewitem";
        }
    }

    @GetMapping("/viewrecord/{id}")
    public String editproduct(@PathVariable Long id, Model model) {
        Product prod = pd.findById(id).orElse(null);
        List<Category> cat = cd.findAll();
        model.addAttribute("product", prod);
        model.addAttribute("category", cat);
        return "updateForm";
    }

    @PostMapping("/updateProduct")
    public String edited(@ModelAttribute("product") Product product,
                         @RequestParam("file") MultipartFile file,
                         RedirectAttributes model) throws IOException {

        Product existing = pd.findById(product.getId())
                .orElseThrow(() -> new IllegalArgumentException("Invalid product ID:" + product.getId()));

        // ✅ Make sure directory exists
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        if (!file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            Path destination = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);
            product.setImagePath(fileName);
        } else {
            product.setImagePath(existing.getImagePath());
        }

        // Keep category rules
        if ("MISCELLANEOUS".equals(existing.getCategory()) || "RANDOM FINDS".equals(existing.getCategory())) {
            List<Category> categories = cd.findAll();
            boolean categoryExists = categories.stream()
                    .anyMatch(cat -> cat.getCategory().equals(product.getCategory())
                            && !"MISCELLANEOUS".equals(cat.getCategory()));

            if (!categoryExists) {
                model.addFlashAttribute("error", "Invalid category selected!");
                return "redirect:/viewrecord/" + product.getId();
            }
        } else {
            product.setCategory(existing.getCategory());
        }

        pd.save(product);
        model.addFlashAttribute("msg", "Product updated successfully!");
        return "redirect:/viewitem";
    }

    @GetMapping("/viewitem")
    public String getAllData(@RequestParam(value = "category", required = false) String category,
                             @RequestParam(value = "stockSort", required = false) String stockSort,
                             @RequestParam(value = "search", required = false) String search,
                             Model model, HttpSession session) {

        Account currentUser = (Account) session.getAttribute("currentUser");
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            return "redirect:/log";
        }

        int totalAccounts = ad.findAll().size();
        int activeUsers = totalAccounts > 0 ? totalAccounts - 1 : 0;
        model.addAttribute("activeUsers", activeUsers);
        int totalSales = oid.findAll().size();
        model.addAttribute("totalSales", totalSales);

        List<Product> products = pd.findAll();

        if (category != null && !category.isEmpty()) {
            products = products.stream()
                    .filter(p -> p.getCategory() != null && p.getCategory().equalsIgnoreCase(category))
                    .collect(Collectors.toList());
        }

        if (search != null && !search.trim().isEmpty()) {
            String lowerSearch = search.toLowerCase();
            products = products.stream()
                    .filter(p -> p.getName().toLowerCase().contains(lowerSearch)
                            || p.getDescription().toLowerCase().contains(lowerSearch))
                    .collect(Collectors.toList());
        }

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
            long cartCount = cartItemDao.countByProduct(product);
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

            pd.deleteById(id);
            model.addFlashAttribute("msg", "Product was deleted successfully!");
        } else {
            model.addFlashAttribute("msg", "Product not found.");
        }

        return "redirect:/viewitem";
    }
}
