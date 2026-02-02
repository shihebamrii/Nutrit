package com.nutrit.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.util.Properties;

public class EmailService {

    private static final Properties props = new Properties();

    static {
        try (InputStream input = EmailService.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (input == null) {
                System.err.println("CRITICAL ERROR: Unable to find mail.properties in classpath");
            } else {
                props.load(input);
                System.out.println("SUCCESS: Loaded mail.properties from classpath");
            }
        } catch (Exception ex) {
            System.err.println("ERROR loading mail.properties:");
            ex.printStackTrace();
        }
    }

    public static boolean sendPasswordResetEmail(String toEmail, String resetLink) {
        String username = props.getProperty("mail.username");
        String password = props.getProperty("mail.password");
        
        if (username == null || password == null) {
            System.err.println("ERROR: mail.username or mail.password is missing in mail.properties");
            return false;
        }

        Properties mailProps = new Properties();
        putIfNotNull(mailProps, "mail.smtp.auth", props.getProperty("mail.smtp.auth", "true"));
        putIfNotNull(mailProps, "mail.smtp.starttls.enable", props.getProperty("mail.smtp.starttls.enable", "true"));
        putIfNotNull(mailProps, "mail.smtp.host", props.getProperty("mail.smtp.host", "smtp-relay.brevo.com"));
        putIfNotNull(mailProps, "mail.smtp.port", props.getProperty("mail.smtp.port", "587"));
        mailProps.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(mailProps, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(props.getProperty("mail.from", "noreply@nutrit.tn")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Réinitialisation de votre mot de passe - Nutrit");

            String htmlContent = "<div style=\"font-family: 'Plus Jakarta Sans', Arial, sans-serif; background-color: #f9f9f9; padding: 40px 0; color: #333; line-height: 1.6;\">"
                    + "<div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);\">"
                    + "<!-- Header Color/Image placeholder -->"
                    + "<div style=\"width: 100%; height: 200px; background-color: #059669; background-image: url('https://images.unsplash.com/photo-1546549032-9571cd6b27df?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'); background-size: cover; background-position: center;\"></div>"
                    + "<div style=\"padding: 40px;\">"
                    + "<div style=\"color: #059669; font-weight: 700; font-size: 24px; margin-bottom: 20px;\">Nutrit</div>"
                    + "<h1 style=\"font-size: 22px; font-weight: 800; color: #111; margin-bottom: 16px;\">Réinitialisation de votre mot de passe</h1>"
                    + "<p style=\"margin-bottom: 24px;\">Bonjour,</p>"
                    + "<p style=\"margin-bottom: 24px;\">Vous avez demandé la réinitialisation de votre mot de passe pour votre compte Nutrit. Cliquez sur le bouton ci-dessous pour sécuriser votre accès :</p>"
                    + "<a href=\"" + resetLink + "\" style=\"display: inline-block; padding: 14px 28px; background-color: #059669; color: #ffffff; text-decoration: none; border-radius: 30px; font-weight: 700; font-size: 16px; box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);\">Réinitialiser mon mot de passe</a>"
                    + "<p style=\"margin-top: 32px; font-size: 14px; color: #666;\">Si vous n'êtes pas à l'origine de cette demande, vous pouvez ignorer cet e-mail en toute sécurité.</p>"
                    + "<p style=\"font-size: 14px; color: #666;\">Ce lien expirera dans 24 heures.</p>"
                    + "<hr style=\"border: 0; border-top: 1px solid #eee; margin: 32px 0;\">"
                    + "<p style=\"font-size: 12px; color: #999; text-align: center;\">&copy; 2025 Nutrit. Tous droits réservés.<br>Votre partenaire santé au quotidien.</p>"
                    + "</div></div></div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("DEBUG: Password reset email sent to " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("ERROR: Failed to send email to " + toEmail);
            e.printStackTrace();
            return false;
        }
    }
    private static void putIfNotNull(Properties props, String key, String value) {
        if (value != null) {
            props.put(key, value);
        } else {
            System.err.println("WARNING: Attempted to put null value for property: " + key);
        }
    }
}
