package com.sc1.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

// 访问路径为 http://localhost:8080/sc/productList
@WebServlet("/productList")
public class ProductListServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置响应编码，防止中文乱码
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        // 这里后续可以调用 Service 和 DAO 从数据库查数据
        // 现在先模拟输出一下
        out.println("<h1>百货商店商品列表加载成功！</h1>");
        out.println("<p>正在连接数据库...</p>");
    }
}
