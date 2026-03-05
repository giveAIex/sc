<%
    // 强制页面不缓存，静态资源走CDN缓存
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="com.sc.util.CookieUtil" %>
<%
    String contextPath = request.getContextPath();
    Object loginUser = session.getAttribute("username");
    Object userRole = session.getAttribute("role");
    boolean isLogin = loginUser != null && !loginUser.toString().trim().isEmpty();
    String username = isLogin ? loginUser.toString() : "";
    int role = isLogin && userRole != null ? Integer.parseInt(userRole.toString()) : 0;
    boolean isAdmin = role == 1;
    boolean isMerchant = role == 2;
    boolean isCustomer = role == 0;
    String view = request.getParameter("view");
    boolean showCenter = isLogin && isCustomer && "center".equals(view);
    
    // 固定版本号（改代码时手动改数字，如2026030404）
    long version = 2026030404;
%>
<html>
<head>
    <title><%=showCenter ? "个人中心 - 百货商店" : "百货商店首页"%></title>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <!-- 预连接CDN，加快加载（图标正常+速度快） -->
    <link rel="preconnect" href="https://cdn.bootcdn.net">
    <link rel="dns-prefetch" href="https://cdn.bootcdn.net">
    
    <!-- 恢复CDN，图标立刻正常 -->
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="<%=contextPath%>/customer/css/login.css?v=<%=version%>" rel="stylesheet">
</head>
<body>
    <!-- 顶部导航 -->
    <div class="header">
        <div class="logo">
            <a href="<%=contextPath%>/customer/index.jsp">百货商店</a>
        </div>
        
        <% if (isLogin) { %>
            <div class="user-wrap">
                <button class="user-btn" id="userBtn">
                    <i class="fas fa-user-circle"></i>
                    <span><%=username%></span>
                    <i class="fas fa-chevron-down"></i>
                </button>
                <!-- 用户下拉菜单（分角色补全） -->
                <div class="user-dropdown" id="userDropdown">
                    <% if (isAdmin) { %>
                        <div class="user-dropdown-item" onclick="goToAdminPage('index')">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>管理后台首页</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToAdminPage('user')">
                            <i class="fas fa-users"></i>
                            <span>用户管理</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToAdminPage('goods')">
                            <i class="fas fa-boxes"></i>
                            <span>商品审核</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToAdminPage('order')">
                            <i class="fas fa-clipboard-list"></i>
                            <span>订单监控</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToAdminPage('system')">
                            <i class="fas fa-cog"></i>
                            <span>系统设置</span>
                        </div>
                        <div class="dropdown-divider"></div>
                    <% } %>
                    
                    <% if (isMerchant) { %>
                        <div class="user-dropdown-item" onclick="goToMerchantPage('index')">
                            <i class="fas fa-store"></i>
                            <span>商家工作台</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToMerchantPage('goods')">
                            <i class="fas fa-plus-square"></i>
                            <span>商品管理</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToMerchantPage('order')">
                            <i class="fas fa-shipping-fast"></i>
                            <span>订单处理</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToMerchantPage('stats')">
                            <i class="fas fa-chart-line"></i>
                            <span>数据统计</span>
                        </div>
                        <div class="user-dropdown-item" onclick="goToMerchantPage('setting')">
                            <i class="fas fa-store-alt"></i>
                            <span>店铺设置</span>
                        </div>
                        <div class="dropdown-divider"></div>
                    <% } %>
                    
                    <% if (isCustomer) { %>
                        <div class="user-dropdown-item" onclick="switchView('center')">
                            <i class="fas fa-user-edit"></i>
                            <span><%=showCenter ? "返回首页" : "个人中心"%></span>
                        </div>
                        <div class="user-dropdown-item" onclick="alert('购物车功能开发中')">
                            <i class="fas fa-shopping-cart"></i>
                            <span>我的购物车</span>
                        </div>
                        <div class="user-dropdown-item" onclick="alert('消息功能开发中')">
                            <i class="fas fa-bell"></i>
                            <span>我的消息</span>
                        </div>
                        <div class="user-dropdown-item" onclick="alert('帮助中心开发中')">
                            <i class="fas fa-question-circle"></i>
                            <span>帮助中心</span>
                        </div>
                        <div class="dropdown-divider"></div>
                    <% } %>
                    
                    <!-- 所有用户通用：退出登录 -->
                    <div class="user-dropdown-item" onclick="logout()">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>退出登录</span>
                    </div>
                </div>
            </div>
        <% } else { %>
            <!-- 0延迟登录按钮 -->
            <button class="login-btn-header" onclick="showLoginModal()">请登录</button>
        <% } %>
    </div>

    <!-- 视图切换 -->
    <% if (showCenter) { %>
        <div class="center-container">
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
            <div class="center-content">
                <div class="content-panel active" id="info">
                    <div class="panel-header"><h4>个人信息</h4></div>
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
                <div class="content-panel" id="collect">
                    <div class="panel-header"><h4>我的收藏</h4></div>
                    <div class="panel-body">
                        <div class="goods-grid">
                            <div class="empty-tip">
                                <i class="fas fa-heart"></i>
                                <p>暂无收藏商品</p>
                            </div>
                        </div>
                    </div>
                </div>
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
                <div class="content-panel" id="security">
                    <div class="panel-header"><h4>账户安全</h4></div>
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
    <% } else { %>
        <div class="content">
            <h3>热门商品</h3>
            <div class="goods-list">
                <div class="goods-item">商品1</div>
                <div class="goods-item">商品2</div>
                <div class="goods-item">商品3</div>
                <div class="goods-item">商品4</div>
            </div>
        </div>
    <% } %>

    <!-- 原生登录弹窗（0延迟） -->
    <div class="login-modal" id="loginModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
        <div style="background: #fff; border-radius: 12px; width: 420px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); overflow: hidden; position: relative;">
            <div style="padding: 25px 30px 10px; text-align: center;">
                <h5 style="margin: 0; font-size: 24px; font-weight: 500; color: #333;">账号登录</h5>
            </div>
            <div style="padding: 10px 30px 30px;">
                <div class="tab-slider">
                    <div class="tab-item active" id="pwdTab" onclick="switchTab('pwd')">账号密码</div>
                    <div class="tab-item" id="smsTab" onclick="switchTab('sms')">短信登录</div>
                </div>
                <div class="login-panels">
                    <!-- 账号密码面板 -->
                    <div id="pwdPanel" class="login-panel active">
                        <div class="input-wrap">
                            <input type="text" id="username" placeholder="请输入用户名/手机号">
                            <i class="fas fa-chevron-down input-arrow" id="historyArrow" onclick="toggleHistory()"></i>
                            <div class="history-dropdown" id="historyDropdown">
                                <%
                                    String historyStr = CookieUtil.getCookie(request, "account_history");
                                    String[][] accountList = new String[0][2];
                                    if (historyStr != null && !historyStr.isEmpty()) {
                                        try {
                                            historyStr = URLDecoder.decode(historyStr, StandardCharsets.UTF_8);
                                            String[] accounts = historyStr.split(";");
                                            accountList = new String[accounts.length][2];
                                            for (int i = 0; i < accounts.length; i++) {
                                                String account = accounts[i];
                                                if (account != null && !account.isEmpty()) {
                                                    String[] info = account.split("\\|");
                                                    if (info.length >= 2) {
                                                        accountList[i][0] = info[0];
                                                        accountList[i][1] = info[1];
                                                    }
                                                }
                                            }
                                        } catch (Exception e) { e.printStackTrace(); }
                                    }
                                    if (accountList.length > 0 && accountList[0][0] != null) {
                                        for (int i = 0; i < accountList.length; i++) {
                                            if (accountList[i][0] == null) continue;
                                %>
                                            <div class="history-item" onclick="selectAccount('<%=accountList[i][0]%>', '<%=accountList[i][1]%>')">
                                                <i class="fas fa-user history-item-icon"></i>
                                                <div class="history-item-account"><%=accountList[i][0]%></div>
                                                <i class="fas fa-times history-item-delete" onclick="deleteAccount(event, <%=i%>)"></i>
                                            </div>
                                <%
                                        }
                                    } else {
                                %>
                                            <div class="history-item text-muted text-center" style="padding: 15px;">暂无历史账号</div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                        <div class="input-wrap">
                            <input type="password" id="password" placeholder="请输入密码">
                            <i class="fas fa-eye-slash pwd-eye" id="pwdEye" onclick="togglePwd()"></i>
                        </div>
                        <div class="error-msg" id="pwdMsg"></div>
                        <div class="remember-me">
                            <input type="checkbox" id="rememberMe" checked>
                            <label for="rememberMe">记住我（7天自动登录）</label>
                        </div>
                        <button class="login-btn" onclick="submitLogin()">登 录</button>
                        <div class="link-group">
                            <a href="javascript:void(0)">免费注册</a>
                            <span class="link-divider">|</span>
                            <a href="javascript:void(0)">忘记密码</a>
                        </div>
                    </div>
                    <!-- 短信登录面板 -->
                    <div id="smsPanel" class="login-panel">
                        <div class="input-wrap">
                            <input type="tel" placeholder="请输入手机号">
                        </div>
                        <div class="input-wrap">
                            <input type="text" placeholder="请输入验证码">
                            <button class="btn btn-sm btn-outline-secondary code-btn" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%);">获取验证码</button>
                        </div>
                        <button class="login-btn" style="margin-top: 10px;">登 录</button>
                    </div>
                </div>
            </div>
            <!-- 关闭按钮 -->
            <button onclick="closeLoginModal()" style="position: absolute; top: 10px; right: 10px; background: transparent; border: none; font-size: 20px; color: #999; cursor: pointer; z-index: 10;">×</button>
        </div>
    </div>

    <!-- JS放底部，加快首屏加载 -->
    <script src="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        const contextPath = "<%=contextPath%>";
        const isLogin = <%=isLogin%>;
        const isAdmin = <%=isAdmin%>;
        const isMerchant = <%=isMerchant%>;
        const isCustomer = <%=isCustomer%>;
        const showCenter = <%=showCenter%>;
        let accountList = [
            <%
                for (int i = 0; i < accountList.length; i++) {
                    if (accountList[i][0] != null) {
                        out.print("['" + accountList[i][0] + "','" + accountList[i][1] + "'],");
                    }
                }
            %>
        ];
    </script>
    <script src="<%=contextPath%>/customer/js/login.js?v=<%=version%>"></script>
</body>
</html>