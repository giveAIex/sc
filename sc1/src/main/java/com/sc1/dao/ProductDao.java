package com.sc1.dao;

import com.sc1.entity.Product;
import com.sc1.utils.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {

    // 1. 发布商品的方法 (给 AddProductServlet 用的)
    public boolean addProduct(Product p) {
        String sql = "INSERT INTO products (name, price, stock, description, merchant_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, p.getName());
            pstmt.setBigDecimal(2, p.getPrice());
            pstmt.setInt(3, p.getStock());
            pstmt.setString(4, p.getDescription());
            pstmt.setInt(5, p.getMerchantId());

            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. 查询所有商品的方法 (给 index.jsp 用的)
    // 之前你可能不小心把下面这段删掉了，现在把它加回来：
    public List<Product> findAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setStock(rs.getInt("stock"));
                p.setDescription(rs.getString("description"));
                p.setMerchantId(rs.getInt("merchant_id"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 根据商户ID查询该商户名下的所有商品 */
    public List<Product> findByMerchantId(int merchantId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE merchant_id = ? ORDER BY id DESC";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, merchantId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setDescription(rs.getString("description"));
                    p.setMerchantId(rs.getInt("merchant_id"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
