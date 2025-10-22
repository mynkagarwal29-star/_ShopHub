package com.example.jpa.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.jpa.dao.AccDao;
import com.example.jpa.model.Account;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OtpService {

    @Autowired
    private EmailService emailService;
    @Autowired
    AccDao ac, accDao;
    // Stores OTP and expiry for each email
    private final Map<String, OtpData> otpStorage = new ConcurrentHashMap<>();

    private static final int OTP_LENGTH = 6;
    private static final int EXPIRY_MINUTES = 5; // OTP valid for 5 minutes

    public void generateAndSendOtp(String email) {
        // Check if the email exists in the database
        Optional<Account> optionalUser = accDao.findByEmail(email);
        if (optionalUser.isEmpty()) {
            throw new IllegalArgumentException("Email not registered.");
        }

        // Generate a 6-digit random OTP
        String otp = String.valueOf(new Random().nextInt(900000) + 100000);

        // Store with expiry time
        otpStorage.put(email, new OtpData(otp, LocalDateTime.now().plusMinutes(EXPIRY_MINUTES)));

        // Send OTP via EmailService
        String subject = "Your ShopHub Password Reset OTP";
        String message = "Dear user,\n\nYour OTP for password reset is: " + otp +
                "\n\nThis OTP will expire in " + EXPIRY_MINUTES + " minutes.\n\nRegards,\nShopHub Support";

        emailService.sendSimpleMail(email, subject, message);
    }


    public boolean verifyOtp(String email, String otp) {
        if (!otpStorage.containsKey(email)) {
            return false;
        }

        OtpData otpData = otpStorage.get(email);

        // Check expiry
        if (LocalDateTime.now().isAfter(otpData.getExpiryTime())) {
            otpStorage.remove(email);
            return false;
        }

        // Check match
        boolean isValid = otpData.getOtp().equals(otp);

        // If valid, remove it (one-time use)
        if (isValid) {
            otpStorage.remove(email);
        }

        return isValid;
    }

    // Inner class to store OTP + expiry
    private static class OtpData {
        private final String otp;
        private final LocalDateTime expiryTime;

        public OtpData(String otp, LocalDateTime expiryTime) {
            this.otp = otp;
            this.expiryTime = expiryTime;
        }

        public String getOtp() {
            return otp;
        }

        public LocalDateTime getExpiryTime() {
            return expiryTime;
        }
    }

    public void clearOtp(String email) {
        otpStorage.remove(email); // remove the OTP after successful password reset
    }
}
