<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" session="true" %>
<%
    // 登录校验：未登录跳转到首页
    Object loginUser = session.getAttribute("username");
    Object userRole = session.getAttribute("role");
    if (loginUser == null || loginUser.toString().trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/customer/index.jsp");
        return;
    }
    // 仅普通用户可访问
    int role = userRole != null ? Integer.parseInt(userRole.toString()) : 0;
    if (role != 0) {
        response.sendRedirect(request.getContextPath() + "/customer/index.jsp");
        return;
    }
    String username = loginUser.toString();
    String contextPath = request.getContextPath();
%>
<html>
<head>
    <title>个人中心 - 百货商店</title>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<%=contextPath%>/customer/css/login.css" rel="stylesheet">
</head>
<body>
    <!-- 顶部导航 -->
    <div class="header">
        <div class="logo">
            <a href="<%=contextPath%>/customer/index.jsp" style="text-decoration: none; color: #993300;">百货商店</a>
        </div>
        <div class="user-wrap">
            <button class="user-btn" id="userBtn">
                <i class="fas fa-user-circle user-avatar"></i>
                <span class="username"><%=username%></span>
                <i class="fas fa-chevron-down arrow-icon"></i>
            </button>
            <div class="user-dropdown" id="userDropdown">
                <div class="user-dropdown-item" onclick="window.location.href='index.jsp'">
                    <i class="fas fa-home"></i>
                    <span>返回首页</span>
                </div>
                <div class="dropdown-divider"></div>
                <div class="user-dropdown-item" onclick="logout()">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>退出登录</span>
                </div>
            </div>
        </div>
    </div>

    <!-- 个人中心主体 -->
    <div class="center-container">
        <!-- 侧边栏菜单 -->
        <div class="center-sidebar">
            <div class="sidebar-title">个人中心</div>
            <div class="sidebar-menu">
                <div class="menu-item active" data-target="info">
                    <i class="fas fa-user"></i>
                    <span>个人信息</span>
                </div>
                <div class="menu-item" data-target="order">
                    <i class="fas fa-shopping-bag"></i>
                    <span>我的订单</span>
                </div>
                <div class="menu-item" data-target="collect">
                    <i class="fas fa-heart"></i>
                    <span>我的收藏</span>
                </div>
                <div class="menu-item" data-target="address">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>收货地址</span>
                </div>
                <div class="menu-item" data-target="security">
                    <i class="fas fa-shield-alt"></i>
                    <span>账户安全</span>
                </div>
            </div>
        </div>

        <!-- 右侧内容区 -->
        <div class="center-content">
            <!-- 个人信息面板 -->
            <div class="content-panel active" id="info">
                <div class="panel-header">
                    <h4>个人信息</h4>
                </div>
                <div class="panel-body">
                    <div class="info-form">
                        <div class="form-row">
                            <label>用户名</label>
                            <input type="text" value="<%=username%>" readonly>
                        </div>
                        <div class="form-row">
                            <label>昵称</label>
                            <input type="text" placeholder="请设置您的昵称">
                        </div>
                        <div class="form-row">
                            <label>手机号</label>
                            <input type="tel" placeholder="请绑定您的手机号">
                        </div>
                        <div class="form-row">
                            <label>邮箱</label>
                            <input type="email" placeholder="请绑定您的邮箱">
                        </div>
                        <div class="form-row">
                            <label>头像</label>
                            <div class="avatar-upload">
                                <i class="fas fa-user-circle" style="font-size: 60px; color: #999;"></i>
                                <button class="btn btn-sm btn-outline-secondary">上传头像</button>
                            </div>
                        </div>
                        <div class="form-row">
                            <button class="save-btn">保存修改</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 我的订单面板 -->
            <div class="content-panel" id="order">
                <div class="panel-header">
                    <h4>我的订单</h4>
                    <div class="order-tabs">
                        <span class="order-tab active">全部</span>
                        <span class="order-tab">待付款</span>
                        <span class="order-tab">待发货</span>
                        <span class="order-tab">待收货</span>
                        <span class="order-tab">待评价</span>
                    </div>
                </div>
                <div class="panel-body">
                    <div class="empty-tip">
                        <i class="fas fa-box-open"></i>
                        <p>暂无订单记录</p>
                    </div>
                </div>
            </div>

            <!-- 我的收藏面板 -->
            <div class="content-panel" id="collect">
                <div class="panel-header">
                    <h4>我的收藏</h4>
                </div>
                <div class="panel-body">
                    <div class="goods-grid">
                        <div class="empty-tip">
                            <i class="fas fa-heart"></i>
                            <p>暂无收藏商品</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 收货地址面板 -->
            <div class="content-panel" id="address">
                <div class="panel-header">
                    <h4>收货地址</h4>
                    <button class="add-btn">+ 新增地址</button>
                </div>
                <div class="panel-body">
                    <div class="empty-tip">
                        <i class="fas fa-map-marker-alt"></i>
                        <p>暂无收货地址</p>
                    </div>
                </div>
            </div>

            <!-- 账户安全面板 -->
            <div class="content-panel" id="security">
                <div class="panel-header">
                    <h4>账户安全</h4>
                </div>
                <div class="panel-body">
                    <div class="security-list">
                        <div class="security-item">
                            <div class="security-info">
                                <i class="fas fa-key"></i>
                                <div>
                                    <h5>登录密码</h5>
                                    <p>定期修改密码可提升账户安全性</p>
                                </div>
                            </div>
                            <button class="btn btn-sm btn-outline-warning">修改密码</button>
                        </div>
                        <div class="security-item">
                            <div class="security-info">
                                <i class="fas fa-mobile-alt"></i>
                                <div>
                                    <h5>绑定手机号</h5>
                                    <p>用于登录、找回密码、接收订单通知</p>
                                </div>
                            </div>
                            <button class="btn btn-sm btn-outline-primary">去绑定</button>
                        </div>
                        <div class="security-item">
                            <div class="security-info">
                                <i class="fas fa-envelope"></i>
                                <div>
                                    <h5>绑定邮箱</h5>
                                    <p>用于找回密码、接收系统通知</p>
                                </div>
                            </div>
                            <button class="btn btn-sm btn-outline-primary">去绑定</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JS资源 -->
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        const contextPath = "<%=contextPath%>";
    </script>
    <script>
        // 侧边栏菜单切换
        document.querySelectorAll('.menu-item').forEach(item => {
            item.addEventListener('click', function() {
                // 重置所有菜单和面板
                document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));
                document.querySelectorAll('.content-panel').forEach(p => p.classList.remove('active'));
                
                // 激活当前菜单和面板
                this.classList.add('active');
                const target = this.getAttribute('data-target');
                document.getElementById(target).classList.add('active');
            });
        });

        // 订单标签切换
        document.querySelectorAll('.order-tab').forEach(tab => {
            tab.addEventListener('click', function() {
                document.querySelectorAll('.order-tab').forEach(t => t.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // 用户下拉菜单
        const userBtn = document.getElementById('userBtn');
        const userDropdown = document.getElementById('userDropdown');
        const arrowIcon = userBtn.querySelector('.arrow-icon');
        
        userBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            const isShow = userDropdown.style.display === 'block';
            if (isShow) {
                userDropdown.style.display = 'none';
                arrowIcon.classList.remove('rotate');
            } else {
                userDropdown.style.display = 'block';
                arrowIcon.classList.add('rotate');
            }
        });

        document.addEventListener('click', function(e) {
            if (!userBtn.contains(e.target) && !userDropdown.contains(e.target)) {
                userDropdown.style.display = 'none';
                arrowIcon.classList.remove('rotate');
            }
        });

        // 退出登录
        function logout() {
            fetch(contextPath + '/logout', { method: 'POST' })
            .then(() => {
                window.location.href = contextPath + '/customer/index.jsp';
            })
            .catch(err => {
                window.location.href = contextPath + '/customer/index.jsp';
            });
        }
    </script>
</body>
</html>