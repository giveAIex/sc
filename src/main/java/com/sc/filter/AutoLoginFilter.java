package com.sc.filter;

import com.sc.entity.User;
import com.sc.service.UserService;

import jakarta.servlet.*;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AutoLoginFilter implements Filter {

    private UserService userService = new UserService();
    // 白名单：无需自动登录校验的路径
    private static final String[] WHITE_LIST = {
            "/login.jsp", "/register.jsp", "/static/",
            "/login", "/register", "/logout"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String contextPath = req.getContextPath();
        String requestURI = req.getRequestURI();

        // 1. 白名单请求直接放行
        for (String path : WHITE_LIST) {
            if (requestURI.contains(path)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // 2. 已登录用户直接放行
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser != null) {
            chain.doFilter(request, response);
            return;
        }

        // 3. 未登录，检查Cookie中的自动登录凭证
        String username = null;
        String encryptPwd = null;
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("autoLoginUsername".equals(cookie.getName())) {
                    username = cookie.getValue();
                }
                if ("autoLoginToken".equals(cookie.getName())) {
                    encryptPwd = cookie.getValue();
                }
            }
        }

        // 4. 凭证有效，执行自动登录
        if (username != null && !username.isEmpty() && encryptPwd != null && !encryptPwd.isEmpty()) {
            User user = userService.getUserByUsername(username);
            // 校验用户状态、密码匹配
            if (user != null && user.getStatus() == 1 && encryptPwd.equals(user.getPassword())) {
                session.setAttribute("loginUser", user);
                session.setMaxInactiveInterval(3600);
                chain.doFilter(request, response);
                return;
            }
        }

        // 5. 无有效凭证，放行交给权限过滤器处理
        chain.doFilter(request, response);
    }
}
