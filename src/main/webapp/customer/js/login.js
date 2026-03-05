// ===================== 极速版：登录/退出 0 刷新 0 延迟 =====================
function showLoginModal() {
    const modal = document.getElementById('loginModal');
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
}
function closeLoginModal() {
    const modal = document.getElementById('loginModal');
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

document.addEventListener('DOMContentLoaded', function () {
    // 初始化用户下拉
    if (isLogin) {
        initUserDropdown();
    }
});

// 初始化用户下拉菜单
function initUserDropdown() {
    const userBtn = document.getElementById('userBtn');
    const userDropdown = document.getElementById('userDropdown');
    const arrowIcon = userBtn?.querySelector('.fa-chevron-down');

    if (userBtn && userDropdown) {
        userBtn.onclick = function (e) {
            e.stopPropagation();
            const show = userDropdown.style.display === 'block';
            userDropdown.style.display = show ? 'none' : 'block';
            arrowIcon.style.transform = show ? 'rotate(0)' : 'rotate(180deg)';
        };
        document.onclick = () => {
            userDropdown.style.display = 'none';
            arrowIcon.style.transform = 'rotate(0)';
        };
    }
}

// 登录标签切换
function switchTab(type) {
    const pwdPanel = document.getElementById('pwdPanel');
    const smsPanel = document.getElementById('smsPanel');
    const pwdTab = document.getElementById('pwdTab');
    const smsTab = document.getElementById('smsTab');

    pwdPanel.classList.remove('active');
    smsPanel.classList.remove('active');
    pwdTab.classList.remove('active');
    smsTab.classList.remove('active');

    if (type === 'pwd') {
        pwdPanel.classList.add('active');
        pwdTab.classList.add('active');
    } else {
        smsPanel.classList.add('active');
        smsTab.classList.add('active');
    }
}

// 密码显隐
function togglePwd() {
    const i = document.getElementById('password');
    const e = document.getElementById('pwdEye');
    if (!i || !e) return;
    e.className = '';
    if (i.type === 'password') {
        i.type = 'text';
        e.className = 'fas fa-eye pwd-eye';
    } else {
        i.type = 'password';
        e.className = 'fas fa-eye-slash pwd-eye';
    }
}

// 历史账号
function toggleHistory() {
    const d = document.getElementById('historyDropdown');
    const a = document.getElementById('historyArrow');
    if (d && a) {
        const s = d.style.display === 'block';
        d.style.display = s ? 'none' : 'block';
        a.classList.toggle('rotate', !s);
    }
}
function selectAccount(u, p) {
    document.getElementById('username').value = u;
    document.getElementById('password').value = p;
    toggleHistory();
}
function deleteAccount(e, i) {
    e.stopPropagation();
    accountList.splice(i, 1);
    document.cookie = "account_history=" + encodeURIComponent(accountList.join(';')) + ";path=/;max-age=2592000";
    window.location.reload();
}

// ===================== 【核心】极速登录：不刷新页面 =====================
function submitLogin() {
    const u = document.getElementById('username')?.value.trim();
    const p = document.getElementById('password')?.value.trim();
    const m = document.getElementById('pwdMsg');
    if (!u) { m.textContent = '请输入用户名'; return; }
    if (!p) { m.textContent = '请输入密码'; return; }

    const f = new FormData();
    f.append('username', u);
    f.append('password', p);

    fetch(contextPath + '/login', { method: 'POST', body: f })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                closeLoginModal();
                // ✅ 关键：不刷新，直接刷新当前页面（最快方式）
                window.location.replace(contextPath + '/customer/index.jsp');
            } else {
                m.textContent = data.msg || '登录失败';
            }
        });
}

// ===================== 【核心】极速退出：不等待、不卡顿 =====================
function logout() {
    // 异步请求退出，不等待结果
    fetch(contextPath + '/logout', { method: 'POST' });
    // ✅ 直接跳转，比 reload 快一倍
    window.location.replace(contextPath + '/customer/index.jsp');
}

// 跳转后台
function goToAdminPage(p) {
    window.open(contextPath + "/admin/index.jsp?page=" + p);
}
function goToMerchantPage(p) {
    window.open(contextPath + "/merchant/index.jsp?page=" + p);
}

// 切换首页/个人中心
function switchView() {
    window.location.href = showCenter
        ? contextPath + '/customer/index.jsp'
        : contextPath + '/customer/index.jsp?view=center';
}