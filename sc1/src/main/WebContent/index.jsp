<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sc1.entity.User" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html>
<head>
    <title>SC1 综合商城</title>
    <link rel="stylesheet" href="css/style.css?v=<%=v%>">
    <style>
        .navbar { display: flex; justify-content: space-between; align-items: center; background: #222; color: #fff; padding: 10px 40px; }
        .user-nav { position: relative; cursor: pointer; }
        .dropdown { display: none; position: absolute; right: 0; top: 100%; background: #fff; color: #333; min-width: 150px; box-shadow: 0 2px 10px rgba(0,0,0,0.2); border-radius: 4px; z-index: 1000; }
        .dropdown a { display: block; padding: 10px 15px; text-decoration: none; color: #333; border-bottom: 1px solid #eee; }
        .dropdown a:hover { background: #f5f5f5; }
        .show { display: block; }
        /* 弹窗样式 */
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); }
        .modal-content { background: #fff; width: 300px; margin: 100px auto; padding: 25px; border-radius: 8px; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo">SC1 SHOP</div>
    <div class="nav-right">
        <%
            User user = (User) session.getAttribute("loginUser");
            if (user == null) {
        %>
            <button onclick="document.getElementById('loginModal').style.display='block'">登录</button>
        <% } else { %>
            <div class="user-nav" onclick="toggleMenu(event)">
                👤 <%= user.getUsername() %> <small>▼</small>
                <div id="drop" class="dropdown">
                    <% if(user.getRole() == 0) { %>
                        <a href="admin/index.jsp">⚙️ 系统管理</a>
                    <% } else if(user.getRole() == 2) { %>
                        <a href="merchant/index.jsp">🏪 店铺管理</a>
                    <% } %>
                    <a href="logout">🚪 退出登录</a>
                </div>
            </div>
        <% } %>
    </div>
</nav>

<div id="loginModal" class="modal">
    <div class="modal-content">
        <h3>用户登录</h3>
        <form id="loginForm">
            <input type="text" name="username" placeholder="账号" required><br>
            <input type="password" name="password" placeholder="密码" required><br>
            <p id="msg" style="color:red; font-size:12px;"></p>
            <button type="submit">登录</button>
            <button type="button" onclick="document.getElementById('loginModal').style.display='none'">取消</button>
        </form>
    </div>
</div>

<script>
    function toggleMenu(e) {
        e.stopPropagation();
        document.getElementById('drop').classList.toggle('show');
    }
    window.onclick = function() {
        var d = document.getElementById('drop');
        if(d) d.classList.remove('show');
    }

    document.getElementById('loginForm').onsubmit = function(e) {
        e.preventDefault();
        fetch('loginServlet?t=' + Date.now(), {
            method: 'POST',
            body: new URLSearchParams(new FormData(this))
        })
        .then(res => res.text())
        .then(data => {
            if (data.includes("success")) {
                location.reload(true);
            } else {
                document.getElementById('msg').innerText = "账号或密码错误";
            }
        });
    }
</script>
</body>
</html>
