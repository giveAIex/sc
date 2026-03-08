package com.sc1.controller;

import com.sc1.dao.UserDao;
import com.sc1.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 彻底禁用缓存
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String u = request.getParameter("username");
        String p = request.getParameter("password");
        User user = userDao.login(u, p);

        if (user != null) {
            request.getSession().setAttribute("loginUser", user);
            out.print("success"); // 严禁使用 println
        } else {
            out.print("fail");
        }
        out.flush();
        out.close();
    }
}
