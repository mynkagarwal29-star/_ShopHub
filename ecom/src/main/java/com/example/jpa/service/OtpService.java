package com.example.jpa.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.jpa.dao.AccDao;
import com.example.jpa.model.Account;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OtpService {

    @Autowired
    private EmailService emailService;

    @Autowired
    private AccDao accDao; // Fixed single reference autowiring

    private final Map<String, OtpData> otpStorage = new ConcurrentHashMap<>();
    private final SecureRandom secureRandom = new SecureRandom();

    private static final int EXPIRY_MINUTES = 5; // OTP valid for 5 minutes

    public void generateAndSendOtp(String email) {
        // Check if the email exists in the database
        Optional<Account> optionalUser = accDao.findByEmail(email);
        if (optionalUser.isEmpty()) {
            throw new IllegalArgumentException("Email not registered.");
        }

        // Cryptographically secure 6-digit OTP
        String otp = String.format("%06d", secureRandom.nextInt(1_000_000));

        // Store with expiry time
        otpStorage.put(email, new OtpData(otp, LocalDateTime.now().plusMinutes(EXPIRY_MINUTES)));

        // Send OTP via EmailService
        String subject = "Your ShopHub Password Reset OTP";
        String message = "Dear user,\n\nYour OTP for password reset is: " + otp +
                "\n\nThis OTP will expire in " + EXPIRY_MINUTES + " minutes.\n\nRegards,\nShopHub Support";

        emailService.sendSimpleMail(email, subject, message);
    }

    public void generateAndSendSignupOtp(String email) {
        // Cryptographically secure 6-digit OTP
        String otp = String.format("%06d", secureRandom.nextInt(1_000_000));

        otpStorage.put(email, new OtpData(otp, LocalDateTime.now().plusMinutes(EXPIRY_MINUTES)));

        String subject = "Your ShopHub Signup Verification OTP";
        String message = "Dear user,\n\nYour OTP for signup verification is: " + otp +
                "\n\nThis OTP will expire in " + EXPIRY_MINUTES + " minutes.\n\nWelcome to ShopHub!";

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

    public void clearOtp(String email) {
        otpStorage.remove(email);
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
}