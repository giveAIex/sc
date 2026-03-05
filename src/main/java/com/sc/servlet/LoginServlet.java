package com.sc.servlet;

import com.sc.util.DBUtil;
import com.sc.util.CookieUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder; // 关键：补全import
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/login")
@MultipartConfig
public class LoginServlet extends HttpServlet {
    private static final int REMEMBER_ME_EXPIRE = 7 * 24 * 60 * 60;
    private static final int ACCOUNT_HISTORY_EXPIRE = 30 * 24 * 60 * 60;
    private static final int MAX_HISTORY_COUNT = 3; // 最多保存3个历史账号

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        System.out.println("=== 登录调试 ===");
        System.out.println("前端输入的用户名：[" + username + "]");
        System.out.println("前端输入的密码：[" + password + "]");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"msg\":\"用户名和密码不能为空\"}");
            out.flush();
            return;
        }

        Connection conn = DBUtil.getConnection();
        String sql = "SELECT id, role, password FROM user WHERE username=?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username.trim());
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                System.out.println("数据库里的密码：[" + dbPassword + "]");
                System.out.println("密码是否匹配：" + dbPassword.equals(password.trim()));

                if (dbPassword.equals(password.trim())) {
                    System.out.println("=== 登录成功 ===");
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("username", username.trim());
                    session.setAttribute("role", rs.getInt("role"));
                    session.setMaxInactiveInterval(30 * 60);

                    if ("on".equals(rememberMe)) {
                        CookieUtil.addCookie(response, "remember_username", username.trim(), REMEMBER_ME_EXPIRE);
                    } else {
                        CookieUtil.deleteCookie(response, "remember_username");
                    }

                    // 兼容Java 17的历史账号存储
                    saveAccountHistory(request, response, username.trim(), password.trim());

                    PrintWriter out = response.getWriter();
                    out.print("{\"success\":true,\"role\":" + rs.getInt("role") + "}");
                    out.flush();
                } else {
                    PrintWriter out = response.getWriter();
                    out.print("{\"success\":false,\"msg\":\"用户名或密码错误\"}");
                    out.flush();
                }
            } else {
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false,\"msg\":\"用户名不存在\"}");
                out.flush();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"msg\":\"系统错误，请查看控制台\"}");
            out.flush();
        } finally {
            DBUtil.close(conn);
        }
    }

    // 兼容Java 17的历史账号存储逻辑
    private void saveAccountHistory(HttpServletRequest request, HttpServletResponse response, String username, String password) {
        try {
            String historyStr = CookieUtil.getCookie(request, "account_history");
            List<String> accountList = new ArrayList<>();

            if (historyStr != null && !historyStr.isEmpty()) {
                historyStr = URLDecoder.decode(historyStr, StandardCharsets.UTF_8);
                String[] accounts = historyStr.split(";");
                for (String account : accounts) {
                    if (account != null && !account.isEmpty() && !account.startsWith(username + "|")) {
                        if (!accountList.contains(account)) { // 手动去重
                            accountList.add(account);
                        }
                    }
                }
            }

            // 新账号置顶
            accountList.add(0, username + "|" + password);

            // 只保留最多3个账号
            if (accountList.size() > MAX_HISTORY_COUNT) {
                accountList = accountList.subList(0, MAX_HISTORY_COUNT);
            }

            // 重新拼接并保存到Cookie
            String newHistory = String.join(";", accountList);
            CookieUtil.addCookie(response, "account_history",
                URLEncoder.encode(newHistory, StandardCharsets.UTF_8), ACCOUNT_HISTORY_EXPIRE);

            System.out.println("保存的历史账号：" + newHistory); // 调试用
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}