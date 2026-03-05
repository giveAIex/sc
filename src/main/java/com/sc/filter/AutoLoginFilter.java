package com.sc.filter;

import com.sc.util.CookieUtil;
import com.sc.util.MD5Util;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*") // 拦截所有请求
public class AutoLoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // 1. 如果已经登录，直接放行
        if (session != null && session.getAttribute("userId") != null) {
            chain.doFilter(request, response);
            return;
        }

        // 2. 检查「记住我」Cookie
        String rememberUsername = CookieUtil.getCookie(httpRequest, "remember_username");
        String rememberToken = CookieUtil.getCookie(httpRequest, "remember_token");
        
        if (rememberUsername != null && rememberToken != null) {
            // 验证Token（简单验证：用户名+固定盐值的MD5）
            String expectedToken = MD5Util.encrypt(rememberUsername + "_remember_me_token");
            if (expectedToken.equals(rememberToken)) {
                // Token验证通过，自动登录（这里简化处理，实际项目应该去数据库查用户信息）
                session = httpRequest.getSession(true);
                session.setAttribute("username", rememberUsername);
                session.setAttribute("role", 3); // 默认为客户角色，实际项目应该从数据库查
                session.setMaxInactiveInterval(30 * 60);
            }
        }

        // 3. 放行
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}