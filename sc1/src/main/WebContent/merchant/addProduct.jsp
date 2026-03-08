<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>商户后台 - 发布商品</title>
    <style>
        .form-container { width: 400px; margin: 50px auto; border: 1px solid #ddd; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; }
        .form-group input, textarea { width: 100%; padding: 8px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>发布新商品</h2>
        <form action="addProduct" method="post">
            <div class="form-group">
                <label>商品名称</label>
                <input type="text" name="pname" required>
            </div>
            <div class="form-group">
                <label>价格 (元)</label>
                <input type="number" step="0.01" name="price" required>
            </div>
            <div class="form-group">
                <label>库存</label>
                <input type="number" name="stock" required>
            </div>
            <div class="form-group">
                <label>商品描述</label>
                <textarea name="description" rows="4"></textarea>
            </div>
            <button type="submit" style="width:100%; padding:10px; background:#28a745; color:#fff; border:none;">确认发布</button>
        </form>
    </div>
</body>
</html>
