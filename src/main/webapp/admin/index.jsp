<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.sc.util.XSSUtil" %>
<%
    // 登录用户信息，XSS转义
    User loginUser = (User) session.getAttribute("loginUser");
    String realName = XSSUtil.escape(loginUser.getRealName());
    String username = XSSUtil.escape(loginUser.getUsername());
    pageContext.setAttribute("realName", realName);
    pageContext.setAttribute("username", username);
    String contextPath = request.getContextPath();
    pageContext.setAttribute("contextPath", contextPath);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员后台</title>
    <link rel="stylesheet" href="${contextPath}/static/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/static/css/common.css">
    <script src="${contextPath}/static/js/jquery.min.js"></script>
</head>
<body>
    <div class="admin-container">
        <!-- 顶部导航 -->
        <div class="header">
            <div class="logo">百货商店管理系统</div>
            <div class="header-right">
                <span><i class="fa fa-user-circle"></i> 欢迎您，${realName}（管理员）</span>
                <a href="${contextPath}/logout" class="logout-btn"><i class="fa fa-sign-out-alt"></i> 退出登录</a>
            </div>
        </div>

        <!-- 左侧菜单 -->
        <div class="sidebar">
            <ul class="menu">
                <li class="menu-item active">
                    <a href="${contextPath}/admin/index.jsp"><i class="fa fa-tachometer-alt"></i> 控制台</a>
                </li>
                <li class="menu-item">
                    <a href="${contextPath}/admin/user_manage.jsp"><i class="fa fa-users"></i> 用户管理</a>
                </li>
                <li class="menu-item">
                    <a href="${contextPath}/admin/category_manage.jsp"><i class="fa fa-list"></i> 分类管理</a>
                </li>
                <li class="menu-item">
                    <a href="${contextPath}/admin/goods_manage.jsp"><i class="fa fa-box"></i> 商品管理</a>
                </li>
                <li class="menu-item">
                    <a href="${contextPath}/admin/order_manage.jsp"><i class="fa fa-file-invoice"></i> 订单管理</a>
                </li>
            </ul>
        </div>

        <!-- 主内容区 -->
        <div class="main-content">
            <div class="content-title">控制台</div>
            <div class="data-card-group">
                <div class="data-card">
                    <div class="card-icon blue"><i class="fa fa-users"></i></div>
                    <div class="card-info">
                        <p class="card-num">0</p>
                        <p class="card-name">总用户数</p>
                    </div>
                </div>
                <div class="data-card">
                    <div class="card-icon green"><i class="fa fa-box"></i></div>
                    <div class="card-info">
                        <p class="card-num">0</p>
                        <p class="card-name">总商品数</p>
                    </div>
                </div>
                <div class="data-card">
                    <div class="card-icon orange"><i class="fa fa-file-invoice"></i></div>
                    <div class="card-info">
                        <p class="card-num">0</p>
                        <p class="card-name">总订单数</p>
                    </div>
                </div>
                <div class="data-card">
                    <div class="card-icon red"><i class="fa fa-money-bill-wave"></i></div>
                    <div class="card-info">
                        <p class="card-num">¥0.00</p>
                        <p class="card-name">总销售额</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
