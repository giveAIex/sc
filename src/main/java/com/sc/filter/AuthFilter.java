package com.sc.filter;

import com.sc.entity.User;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AuthFilter implements Filter {

    // 白名单：无需登录即可访问的路径
    private static final String[] WHITE_LIST = {
            "/login.jsp", "/register.jsp", "/static/",
            "/login", "/register", "/logout", "/index"
    };

    // 角色权限路径映射
    private static final String ADMIN_PATH = "/admin/";
    private static final String MERCHANT_PATH = "/merchant/";
    private static final String CUSTOMER_PATH = "/customer/";

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

        // 2. 校验是否登录
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            // 未登录，跳转到登录页
            resp.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // 3. 角色权限校验
        Integer role = loginUser.getRole();
        if (requestURI.contains(ADMIN_PATH) && role != 1) {
            // 非管理员访问管理员后台
            resp.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        if (requestURI.contains(MERCHANT_PATH) && role != 2) {
            // 非商家访问商家后台
            resp.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        if (requestURI.contains(CUSTOMER_PATH) && role != 0) {
            // 非客户访问客户页面
            resp.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // 4. 权限校验通过，放行
        chain.doFilter(request, response);
    }
}
