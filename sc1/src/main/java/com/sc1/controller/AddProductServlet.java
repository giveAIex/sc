package com.sc1.controller;

import com.sc1.dao.ProductDao;
import com.sc1.entity.Product;
import com.sc1.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/merchant/addProduct")
public class AddProductServlet extends HttpServlet {
    
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. 安全检查：确保只有登录的商户能发商品
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null || loginUser.getRole() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2. 接收表单参数
        String name = request.getParameter("pname");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String desc = request.getParameter("description");

        // 3. 封装对象
        Product p = new Product();
        p.setName(name);
        p.setPrice(new BigDecimal(priceStr));
        p.setStock(Integer.parseInt(stockStr));
        p.setDescription(desc);
        p.setMerchantId(loginUser.getId()); // 【关键】绑定当前商户ID

        // 4. 调用DAO保存
        // 确保前面的变量名 productDao 没写错，且方法名首字母小写
        boolean success = productDao.addProduct(p); 


        if (success) {
            // 保存成功，跳转回列表页或提示
            response.sendRedirect("index.jsp?msg=success");
        } else {
            request.setAttribute("error", "商品发布失败，请重试");
            request.getRequestDispatcher("addProduct.jsp").forward(request, response);
        }
    }
}
