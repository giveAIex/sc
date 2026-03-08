<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sc1.entity.User, com.sc1.dao.UserDao, java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null || loginUser.getRole() != 0) { // 校验是否为 0
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head><title>系统后台</title></head>
<body>
    <h2>🛡️ 用户权限管理</h2>
    <table border="1" cellpadding="10" style="border-collapse: collapse; width: 80%;">
        <tr>
            <th>ID</th><th>用户名</th><th>身份</th><th>操作</th>
        </tr>
        <%
            UserDao dao = new UserDao();
            List<User> users = dao.findAllUsers();
            for(User u : users) {
        %>
        <tr>
            <td><%= u.getId() %></td>
            <td><%= u.getUsername() %></td>
            <td><%= u.getRole()==0?"管理员":(u.getRole()==2?"商户":"普通会员") %></td>
            <td>
                <form action="updateUserRole" method="post">
                    <input type="hidden" name="userId" value="<%= u.getId() %>">
                    <select name="newRole" onchange="this.form.submit()">
                        <option value="0" <%= u.getRole()==0?"selected":"" %>>管理员</option>
                        <option value="1" <%= u.getRole()==1?"selected":"" %>>会员</option>
                        <option value="2" <%= u.getRole()==2?"selected":"" %>>商户</option>
                    </select>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>
