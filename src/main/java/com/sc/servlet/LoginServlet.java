package com.sc.servlet;

import com.sc.entity.User;
import com.sc.service.UserService;
import com.sc.util.MD5Util;
import com.sc.util.ResultUtil;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

// 必须和前端请求的路径一致：/login
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson(); // 必须确保WEB-INF/lib里有gson的jar包

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 强制设置响应编码，避免中文乱码
        response.setContentType("application/json;charset=utf-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String contextPath = request.getContextPath();

        // 控制台打印日志，确认后端收到请求
        System.out.println("=== 收到登录请求 ===");

        // 1. 获取前端参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        System.out.println("请求参数：username=" + username + ", remember=" + remember);

        // 2. 校验参数
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            out.print(gson.toJson(ResultUtil.error("账号密码不能为空")));
            System.out.println("登录失败：账号密码为空");
            return;
        }

        // 3. 查询用户
        User user = userService.getUserByUsername(username);
        if (user == null) {
            out.print(gson.toJson(ResultUtil.error("账号不存在")));
            System.out.println("登录失败：账号不存在");
            return;
        }

        // 4. 校验密码（加盐加密对比）
        String encryptPwd = MD5Util.encryptWithSalt(password, user.getSalt());
        if (!encryptPwd.equals(user.getPassword())) {
            out.print(gson.toJson(ResultUtil.error("密码错误")));
            System.out.println("登录失败：密码错误");
            return;
        }

        // 5. 校验账号状态
        if (user.getStatus() != 1) {
            out.print(gson.toJson(ResultUtil.error("账号已被禁用，请联系管理员")));
            System.out.println("登录失败：账号被禁用");
            return;
        }

        // 6. 登录成功，存入Session
        HttpSession session = request.getSession();
        session.setAttribute("loginUser", user);
        session.setMaxInactiveInterval(3600); // Session有效期1小时
        System.out.println("登录成功：username=" + username + ", role=" + user.getRole());

        // 7. 记住账号（只存用户名，不存密码）
        if ("1".equals(remember)) {
            Cookie cookie = new Cookie("rememberUsername", username);
            cookie.setMaxAge(7 * 24 * 3600);
            cookie.setPath(contextPath);
            response.addCookie(cookie);
        } else {
            Cookie cookie = new Cookie("rememberUsername", "");
            cookie.setMaxAge(0);
            cookie.setPath(contextPath);
            response.addCookie(cookie);
        }

        // 8. 按角色返回跳转地址
        String redirectUrl;
        if (user.getRole() == 1) {
            redirectUrl = contextPath + "/admin/index.jsp";
        } else if (user.getRole() == 2) {
            redirectUrl = contextPath + "/merchant/index.jsp";
        } else {
            redirectUrl = contextPath + "/customer/index.jsp";
        }
        out.print(gson.toJson(ResultUtil.success("登录成功", redirectUrl)));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
