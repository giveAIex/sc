package com.sc.servlet;

import com.sc.util.CookieUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        // 1. 销毁Session，清除登录状态
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 2. 只删除自动登录Cookie，保留账号历史记录（记住我）
        CookieUtil.deleteCookie(response, "remember_token");

        // 3. 给前端返回成功结果
        PrintWriter out = response.getWriter();
        out.print("{\"success\":true}");
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 直接访问logout链接，跳转到首页
        response.sendRedirect(request.getContextPath() + "/customer/index.jsp");
    }
}