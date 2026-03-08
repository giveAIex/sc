<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sc1.entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>SC 百货中心 - 首页</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="logo">SC 百货中心</div>
        <div class="nav-right">
            <%
                // 从 Session 获取用户信息
                User user = (User) session.getAttribute("loginUser");
                if (user == null) {
            %>
                <button class="login-btn" onclick="openLoginModal()">登录 / 注册</button>
            <% } else { %>
                <span>欢迎您，<%= user.getUsername() %></span>
                <% if(user.getRole() == 1) { %>
                    <a href="admin/index.jsp">系统管理</a>
                <% } else if(user.getRole() == 2) { %>
                    <a href="merchant/index.jsp">我的店铺</a>
                <% } %>
                <a href="logoutServlet">退出</a>
            <% } %>
        </div>
    </nav>

    <div class="content">
        <h1>热门商品预览</h1>
        <div class="product-grid">
            <div class="product-card">商品A - ￥99.00</div>
            <div class="product-card">商品B - ￥199.00</div>
            <div class="product-card">商品C - ￥299.00</div>
        </div>
    </div>

    <div id="loginModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeLoginModal()">&times;</span>
            <h2>用户登录</h2>
            <form action="loginServlet" method="post">
                <div class="input-group">
                    <label>用户名</label>
                    <input type="text" name="username" required placeholder="请输入用户名">
                </div>
                <div class="input-group">
                    <label>密码</label>
                    <input type="password" name="password" required placeholder="请输入密码">
                </div>
                <button type="submit" class="submit-btn">立即登录</button>
            </form>
            <p style="color:red; font-size:12px;">
                <%= request.getAttribute("errorMsg") != null ? request.getAttribute("errorMsg") : "" %>
            </p>
        </div>
    </div>

    <script src="js/script.js"></script>
</body>
</html>
