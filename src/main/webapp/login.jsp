<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 强制获取项目上下文路径，解决路径错乱问题
    String contextPath = request.getContextPath();
    pageContext.setAttribute("contextPath", contextPath);
    // 获取记住的账号
    String rememberUsername = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("rememberUsername".equals(cookie.getName())) {
                rememberUsername = cookie.getValue();
                break;
            }
        }
    }
    pageContext.setAttribute("rememberUsername", rememberUsername);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统登录</title>
    <!-- 静态资源绝对路径，100%加载成功，适配sc项目 -->
    <link rel="stylesheet" href="${contextPath}/static/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/static/css/login.css">
    <!-- 先加载jQuery，必须放在最前面，解决$ is not defined问题 -->
    <script src="${contextPath}/static/js/jquery.min.js"></script>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-title">
                <h2><i class="fa fa-store"></i> 百货商店管理系统</h2>
                <p>请输入账号密码登录</p>
            </div>
            <form id="loginForm" onsubmit="return false;"> <!-- 阻止表单默认提交，避免页面刷新 -->
                <div class="form-item">
                    <label><i class="fa fa-user"></i> 账号</label>
                    <input type="text" name="username" id="username" placeholder="请输入账号" value="${rememberUsername}" required>
                </div>
                <div class="form-item">
                    <label><i class="fa fa-lock"></i> 密码</label>
                    <input type="password" name="password" id="password" placeholder="请输入密码" required>
                </div>
                <div class="form-item remember">
                    <label><input type="checkbox" name="remember" value="1" ${rememberUsername != null && rememberUsername != '' ? 'checked' : ''}> 记住账号</label>
                </div>
                <div class="form-item">
                    <button type="button" id="loginBtn" class="login-btn">登 录</button>
                </div>
                <div class="form-item register-link">
                    还没有账号？<a href="${contextPath}/register.jsp">立即注册</a>
                </div>
            </form>
            <div class="msg-tip" id="msgTip" style="display: none; margin-top: 15px; padding: 10px; border-radius: 4px;"></div>
        </div>
    </div>

    <script>
        // 页面加载完成后再绑定事件，确保元素已加载
        $(document).ready(function() {
            console.log("页面加载完成，jQuery初始化成功"); // 控制台可看到，确认JS正常执行

            // 登录按钮点击事件
            $('#loginBtn').click(function() {
                console.log("登录按钮被点击"); // 控制台可看到，确认点击事件触发
                let username = $('#username').val().trim();
                let password = $('#password').val().trim();
                let remember = $('input[name="remember"]:checked').val() || '0';

                // 前端参数校验
                if (!username) {
                    showMsg('请输入账号', 'error');
                    return;
                }
                if (!password) {
                    showMsg('请输入密码', 'error');
                    return;
                }

                // 提交登录请求，绝对路径适配sc项目
                $.ajax({
                    url: '${contextPath}/login', // 100%正确的请求路径
                    type: 'POST', // 和后端Servlet的doPost对应
                    data: {
                        username: username,
                        password: password,
                        remember: remember
                    },
                    dataType: 'json', // 后端返回JSON格式
                    success: function(res) {
                        console.log("请求成功，后端返回：", res); // 控制台看后端返回结果
                        if (res.code == 200) {
                            showMsg(res.msg, 'success');
                            setTimeout(function() {
                                window.location.href = res.data; // 登录成功跳转
                            }, 1000);
                        } else {
                            showMsg(res.msg, 'error');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("请求失败：", xhr, status, error); // 控制台看报错详情
                        showMsg('网络错误/请求失败，请检查后端服务', 'error');
                    }
                });
            });

            // 回车登录
            $(document).keydown(function(e) {
                if (e.keyCode == 13) {
                    $('#loginBtn').click();
                }
            });

            // 提示信息方法
            function showMsg(msg, type) {
                let tip = $('#msgTip');
                tip.text(msg).show();
                if (type == 'success') {
                    tip.css('background', '#f0f9ff').css('color', '#007dff');
                } else {
                    tip.css('background', '#fff2f0').css('color', '#ff4d4f');
                }
                setTimeout(function() {
                    tip.hide();
                }, 3000);
            }
        });
    </script>
</body>
</html>
