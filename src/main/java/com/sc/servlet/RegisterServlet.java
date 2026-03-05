package com.sc.servlet;

import com.sc.service.UserService;
import com.sc.util.MD5Util;
import com.sc.util.ResultUtil;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();

        // 1. 获取参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("rePassword");
        String realName = request.getParameter("realName");
        String phone = request.getParameter("phone");

        // 2. 校验参数
        if (username == null || username.isEmpty()) {
            out.print(gson.toJson(ResultUtil.error("账号不能为空")));
            return;
        }
        if (password == null || password.isEmpty() || rePassword == null || rePassword.isEmpty()) {
            out.print(gson.toJson(ResultUtil.error("密码不能为空")));
            return;
        }
        if (!password.equals(rePassword)) {
            out.print(gson.toJson(ResultUtil.error("两次密码输入不一致")));
            return;
        }

        // 3. 校验账号是否已存在
        if (userService.checkUsernameExist(username)) {
            out.print(gson.toJson(ResultUtil.error("账号已存在，请更换")));
            return;
        }

        // 4. 密码加盐加密
        String salt = MD5Util.generateSalt();
        String encryptPwd = MD5Util.encryptWithSalt(password, salt);

        // 5. 注册用户（默认客户角色）
        int result = userService.registerUser(username, encryptPwd, salt, realName, phone, 0);
        if (result > 0) {
            out.print(gson.toJson(ResultUtil.success("注册成功，请登录", request.getContextPath() + "/login.jsp")));
        } else {
            out.print(gson.toJson(ResultUtil.error("注册失败，请重试")));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
