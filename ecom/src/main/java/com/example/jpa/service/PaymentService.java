package com.example.jpa.service;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;

@Service
public class PaymentService {

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

    private RazorpayClient razorpayClient;

    @PostConstruct
    public void init() throws RazorpayException {
        this.razorpayClient = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
    }

    public String getRazorpayKeyId() {
        return razorpayKeyId;
    }

    /**
     * Creates an official Order on Razorpay's server using total amount in paise.
     */
    public String createRazorpayOrder(Long dbOrderId, double totalAmount) throws RazorpayException {
        JSONObject orderRequest = new JSONObject();
        // Convert total amount (INR) to Paise (e.g. 250.50 -> 25050 paise)
        orderRequest.put("amount", Math.round(totalAmount * 100));
        orderRequest.put("currency", "INR");
        orderRequest.put("receipt", "txn_order_" + dbOrderId);

        Order razorpayOrder = razorpayClient.orders.create(orderRequest);
        return razorpayOrder.get("id"); // e.g., "order_Ek39x13k2k"
    }

    /**
     * Verifies the cryptographic HMAC SHA256 signature returned by Razorpay Checkout JS.
     */
    public boolean verifySignature(String razorpayOrderId, String razorpayPaymentId, String razorpaySignature) {
        try {
            JSONObject attributes = new JSONObject();
            attributes.put("razorpay_order_id", razorpayOrderId);
            attributes.put("razorpay_payment_id", razorpayPaymentId);
            attributes.put("razorpay_signature", razorpaySignature);

            return Utils.verifyPaymentSignature(attributes, razorpayKeySecret);
        } catch (RazorpayException e) {
            return false;
        }
    }
}