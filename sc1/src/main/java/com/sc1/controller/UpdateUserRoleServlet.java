package com.sc1.controller;

import com.sc1.dao.UserDao;
import com.sc1.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/updateUserRole")
public class UpdateUserRoleServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 安全检查：只有管理员Session能操作
        User loginUser = (User) request.getSession().getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权操作");
            return;
        }

        // 2. 获取参数
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int newRole = Integer.parseInt(request.getParameter("newRole"));

            // 3. 调用DAO执行更新
            boolean success = userDao.updateRole(userId, newRole);

            // 4. 重定向回列表页，带上提示参数
            if (success) {
                response.sendRedirect("index.jsp?msg=update_success");
            } else {
                response.sendRedirect("index.jsp?msg=update_fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?msg=error");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
    }
}
