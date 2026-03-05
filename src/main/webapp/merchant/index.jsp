<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    // 权限校验：没登录或者不是商家，跳回登录页
    Integer role = (Integer) session.getAttribute("role");
    if (role == null || role != 2) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<html>
<head><!-- Bootstrap 5 CSS -->
<link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap 5 JS -->
<script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <title>商家管理后台</title>
    <style>
        .header { padding: 20px; background: #28a745; color: white; font-size: 20px; }
        .nav { margin: 20px; }
        .nav a { margin-right: 20px; font-size: 16px; text-decoration: none; color: #28a745; }
        .content { margin: 20px; font-size: 18px; }
    </style>
</head>
<body>
    <div class="header">百货商店系统-商家管理后台</div>
    <div class="nav">
        <a href="#">商品管理</a>
        <a href="#">订单管理</a>
        <a href="#">店铺信息</a>
        <a href="../login.jsp">退出登录</a>
    </div>
    <div class="content">
        <h3>欢迎您，商家：${username}</h3>
        <p>您可以管理自己的商品、处理订单、查看销售数据</p>
    </div>
</body>
</html>