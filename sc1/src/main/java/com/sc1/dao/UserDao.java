package com.sc1.dao;

import com.sc1.entity.User;
import com.sc1.utils.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    
    // 1. 登录验证
    public User login(String username, String password) {
        User user = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getInt("role")); // 0:管, 1:客, 2:商
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { DBUtil.close(conn, pstmt, rs); }
        return user;
    }

    // 2. 管理员专用：查询所有用户
    public List<User> findAllUsers() {
        List<User> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM users ORDER BY id ASC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getInt("role"));
                list.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally { DBUtil.close(conn, pstmt, rs); }
        return list;
    }

    // 3. 管理员专用：更新权限
    public boolean updateRole(int userId, int newRole) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE users SET role = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, newRole);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; } 
        finally { DBUtil.close(conn, pstmt, null); }
    }
}
