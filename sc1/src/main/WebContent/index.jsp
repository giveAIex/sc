<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sc1.entity.User" %>
<%
    // 给静态资源生成一个随机版本号，解决浏览器不更新 CSS/JS 的问题
    String version = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SC1 综合商城</title>
    <link rel="stylesheet" href="css/style.css?v=<%=version%>">
    <style>
        body { margin: 0; font-family: "Segoe UI", Tahoma, sans-serif; background: #f0f2f5; }
        .navbar { 
            display: flex; justify-content: space-between; align-items: center; 
            background: #001529; color: white; padding: 0 40px; height: 64px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .logo { font-size: 20px; font-weight: bold; color: #1890ff; }

        /* 用户折叠菜单容器 */
        .user-nav { position: relative; }
        .user-trigger { 
            cursor: pointer; padding: 4px 12px; border-radius: 4px;
            transition: all 0.3s; display: flex; align-items: center;
        }
        .user-trigger:hover { background: rgba(255,255,255,0.1); }

        /* 下拉菜单样式 */
        .user-dropdown {
            display: none; position: absolute; right: 0; top: 55px; 
            background: white; min-width: 160px; border-radius: 4px;
            box-shadow: 0 3px 6px -4px rgba(0,0,0,0.12), 0 6px 16px 0 rgba(0,0,0,0.08);
            z-index: 1000; overflow: hidden;
        }
        .user-dropdown a {
            display: block; color: rgba(0,0,0,0.85); padding: 12px 16px; 
            text-decoration: none; font-size: 14px; transition: 0.3s;
        }
        .user-dropdown a:hover { background: #e6f7ff; }
        .user-dropdown.show { display: block; animation: fadeIn 0.2s; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

        /* 登录按钮 */
        .btn-login { background: #1890ff; color: white; border: none; padding: 6px 20px; border-radius: 4px; cursor: pointer; }

        /* 弹窗 */
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.45); z-index: 2000; }
        .modal-body { background: white; width: 360px; margin: 100px auto; padding: 32px; border-radius: 8px; position: relative; }
        .modal-close { position: absolute; right: 20px; top: 15px; cursor: pointer; font-size: 22px; color: #999; }
        input { width: 100%; padding: 10px; margin: 12px 0; border: 1px solid #d9d9d9; border-radius: 2px; box-sizing: border-box; }
        .btn-submit { width: 100%; background: #1890ff; color: white; border: none; padding: 10px; cursor: pointer; margin-top: 10px; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo">SC1 PLATFORM</div>
    <div class="nav-right">
        <%
            User user = (User) session.getAttribute("loginUser");
            if (user == null) {
        %>
            <button class="btn-login" onclick="openLogin()">登录</button>
        <% } else { %>
            <div class="user-nav">
                <div class="user-trigger" onclick="toggleMenu(event)">
                    <span>欢迎, <%= user.getUsername() %></span>
                    <span style="margin-left:8px; font-size:10px;">▼</span>
                </div>
                <div id="userDropdown" class="user-dropdown">
                    <% if(user.getRole() == 1) { %>
                        <a href="admin/index.jsp">⚙️ 系统管理</a>
                    <% } else if(user.getRole() == 2) { %>
                        <a href="merchant/index.jsp">🏪 店铺后台</a>
                    <% } %>
                    <a href="logout">🚪 退出登录</a>
                </div>
            </div>
        <% } %>
    </div>
</nav>

<div id="loginModal" class="modal">
    <div class="modal-body">
        <span class="modal-close" onclick="closeLogin()">&times;</span>
        <h2 style="margin-bottom: 24px;">用户登录</h2>
        <form id="loginForm">
            <input type="text" name="username" placeholder="用户名" required autocomplete="off">
            <input type="password" name="password" placeholder="密码" required>
            <div id="msg" style="color: #ff4d4f; font-size: 14px; min-height: 20px;"></div>
            <button type="submit" class="btn-submit">立即进入</button>
        </form>
    </div>
</div>



<script>
    // 1. 弹窗逻辑
    function openLogin() { document.getElementById('loginModal').style.display = 'block'; }
    function closeLogin() { document.getElementById('loginModal').style.display = 'none'; }

    // 2. 折叠菜单逻辑
    function toggleMenu(e) {
        e.stopPropagation();
        document.getElementById('userDropdown').classList.toggle('show');
    }

    // 点击页面任何地方关闭折叠菜单
    document.addEventListener('click', function() {
        const menu = document.getElementById('userDropdown');
        if(menu) menu.classList.remove('show');
    });

    // 3. 核心：带“防缓存”标识的 AJAX 登录
    document.getElementById('loginForm').onsubmit = function(e) {
        e.preventDefault();
        const msgDiv = document.getElementById('msg');
        msgDiv.innerText = "正在验证...";

        const formData = new URLSearchParams(new FormData(this));
        
        // 增加时间戳参数 _t，确保请求永远不被浏览器拦截缓存
        fetch('loginServlet?_t=' + Date.now(), {
            method: 'POST',
            body: formData
        })
        .then(res => res.text())
        .then(data => {
            // 使用 includes 排除任何隐藏字符干扰
            if (data.includes("success")) {
                location.reload(true); // 传入 true 强制从服务器加载
            } else {
                msgDiv.innerText = "❌ 账号或密码不匹配";
            }
        })
        .catch(err => {
            msgDiv.innerText = "⚠️ 服务器连接失败";
        });
    };
</script>

</body>
</html>
