package com.example.jpa.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public class PaymentService {

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    public void createOrder(double amount, String name, String email, String contact, Model model) {
        model.addAttribute("key", razorpayKeyId);
        model.addAttribute("amount", amount);
        model.addAttribute("custName", name);
        model.addAttribute("custEmail", email);
        model.addAttribute("custContact", contact);
    }
}