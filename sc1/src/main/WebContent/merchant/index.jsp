<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sc1.entity.User, com.sc1.entity.Product, com.sc1.dao.ProductDao, java.util.List" %>
<%
    // 安全校验：如果不是商户，踢回登录页
    User user = (User) session.getAttribute("loginUser");
    if (user == null || user.getRole() != 2) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>商户管理后台</title>
    <style>
        table { width: 90%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f4f4f4; }
        .action-btn { color: #1890ff; cursor: pointer; text-decoration: none; margin-right: 10px; }
        .add-btn { display: block; width: 120px; margin: 20px auto; padding: 10px; 
                  background: #28a745; color: white; text-align: center; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>
    <h2 style="text-align: center;">欢迎回来，<%= user.getUsername() %> 店长！</h2>
    
    <a href="addProduct.jsp" class="add-btn">+ 发布新商品</a>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>商品名称</th>
                <th>价格</th>
                <th>库存</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <%
                ProductDao dao = new ProductDao();
                // 只查当前登录商户的商品
                List<Product> myProducts = dao.findByMerchantId(user.getId());
                for(Product p : myProducts) {
            %>
            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getName() %></td>
                <td>￥<%= p.getPrice() %></td>
                <td><%= p.getStock() %></td>
                <td>
                    <a href="editProduct.jsp?id=<%= p.getId() %>" class="action-btn">修改</a>
                    <a href="deleteProduct?id=<%= p.getId() %>" class="action-btn" 
                       style="color:red;" onclick="return confirm('确定要下架这件商品吗？')">下架</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    
    <p style="text-align: center;"><a href="../index.jsp">返回商城首页</a></p>
</body>
</html>
