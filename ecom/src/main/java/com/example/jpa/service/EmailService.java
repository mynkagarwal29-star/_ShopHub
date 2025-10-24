package com.example.jpa.service;

import java.io.IOException;

import org.springframework.stereotype.Service;

import com.sendgrid.Method;
import com.sendgrid.Request;
import com.sendgrid.Response;
import com.sendgrid.SendGrid;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;

@Service
public class EmailService {

    // Keep method signature same
    public void sendSimpleMail(String to, String subject, String text) {
        Email from = new Email("your_verified_sender@example.com"); // must match your SendGrid verified sender
        Email toEmail = new Email(to);
        Content content = new Content("text/plain", text);
        Mail mail = new Mail(from, subject, toEmail, content);

        SendGrid sg = new SendGrid(System.getenv("SENDGRID_API_KEY"));
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);

            System.out.println("SendGrid Response Code: " + response.getStatusCode());
        } catch (IOException ex) {
            // Optional: log or rethrow
            throw new RuntimeException("Error sending email via SendGrid", ex);
        }
    }
}
