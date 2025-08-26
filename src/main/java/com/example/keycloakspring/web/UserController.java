package com.example.keycloakspring.web;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @GetMapping
    public ResponseEntity<?> me(Authentication authentication) {
        String name = authentication != null ? authentication.getName() : "unknown";
        return ResponseEntity.ok(Map.of("message", "User endpoint: Hello " + name));
    }
}
