<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="com.sc.util.CookieUtil" %>
<html>
<head>
    <title>百货商店系统-登录</title>
    <!-- 引入Bootstrap 5 -->
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f5f5; min-height: 100vh; display: flex; align-items: center; }
        .login-container { max-width: 900px; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .account-history { margin-top: 20px; }
        .account-card { cursor: pointer; padding: 15px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 10px; transition: all 0.3s; }
        .account-card:hover { border-color: #007bff; background: #f8f9fa; }
        .msg { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="container login-container">
        <div class="row">
            <!-- 左侧：快捷登录账号选择 -->
            <div class="col-md-5">
                <div class="login-box">
                    <h4 class="mb-4">快捷登录</h4>
                    <div class="account-history" id="accountHistory">
                        <%
                            // 读取历史账号Cookie
                            String historyStr = CookieUtil.getCookie(request, "account_history");
                            if (historyStr != null && !historyStr.isEmpty()) {
                                try {
                                    historyStr = URLDecoder.decode(historyStr, StandardCharsets.UTF_8);
                                    String[] accounts = historyStr.split(";");
                                    for (String account : accounts) {
                                        if (account != null && !account.isEmpty()) {
                                            String[] info = account.split("\\|");
                                            if (info.length >= 2) {
                        %>
                                                <div class="account-card" onclick="quickLogin('<%=info[0]%>', '<%=info[1]%>')">
                                                    <div class="fw-bold"><%=info[0]%></div>
                                                    <small class="text-muted">点击快速登录</small>
                                                </div>
                        <%
                                            }
                                        }
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- 右侧：账号密码登录 -->
            <div class="col-md-7">
                <div class="login-box">
                    <h2 class="text-center mb-4">百货商店管理系统</h2>
                    <form action="login" method="post" id="loginForm">
                        <div class="msg">${msg}</div>
                        <div class="mb-3">
                            <label class="form-label">用户名</label>
                            <input type="text" class="form-control" name="username" id="username" placeholder="请输入用户名" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">密码</label>
                            <input type="password" class="form-control" name="password" id="password" placeholder="请输入密码" required>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" name="rememberMe" id="rememberMe">
                            <label class="form-check-label" for="rememberMe">记住我（7天内自动登录）</label>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">登录</button>
                    </form>
                    <div class="mt-4 text-muted small">
                        测试账号：<br>
                        管理员：admin / 123456<br>
                        商家：merchant1 / 123456<br>
                        客户：customer1 / 123456
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        // 快捷登录：点击账号卡片自动填充并提交
        function quickLogin(username, password) {
            document.getElementById('username').value = username;
            document.getElementById('password').value = password;
            document.getElementById('loginForm').submit();
        }
    </script>
</body>
</html>