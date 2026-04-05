package com.example.jpa.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    // dynamically picks from application.properties / env
    @Value("${spring.mail.username}")
    private String fromEmail;

    // SAME method signature
    public void sendSimpleMail(String to, String subject, String text) {

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail); // no hardcoding now ✅
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);

            mailSender.send(message);

            System.out.println("Email sent successfully via SMTP");

        } catch (Exception ex) {
            throw new RuntimeException("Error sending email via SMTP", ex);
        }
    }
}