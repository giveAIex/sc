package com.sc.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtil {
    // 添加Cookie
    public static void addCookie(HttpServletResponse response, String name, String value, int maxAge) {
        if (response == null) return; // 空值判断
        Cookie cookie = new Cookie(name, value);
        cookie.setPath("/");
        cookie.setMaxAge(maxAge);
        response.addCookie(cookie);
    }

    // 获取Cookie
    public static String getCookie(HttpServletRequest request, String name) {
        if (request == null) return null; // 关键：添加空值判断
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(name)) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    // 删除Cookie
    public static void deleteCookie(HttpServletResponse response, String name) {
        addCookie(response, name, "", 0);
    }
}