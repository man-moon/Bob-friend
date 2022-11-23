package org.bobfriend.bobfriend.controller;

import lombok.RequiredArgsConstructor;
import org.bobfriend.bobfriend.service.EmailService;
import org.bobfriend.bobfriend.dto.EmailVerifyRequestDto;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.mail.MessagingException;
import java.io.UnsupportedEncodingException;

@RestController
@RequiredArgsConstructor
public class EmailController {

    private final EmailService emailService;

    @PostMapping("signup/verifyEmail")
    public String verifyEmail(@RequestBody EmailVerifyRequestDto emailDto) throws MessagingException, UnsupportedEncodingException {

        String authCode = emailService.sendEmail(emailDto.getEmail());
        return authCode;
    }
}
