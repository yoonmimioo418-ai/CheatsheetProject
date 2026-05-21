package com.servlet.repository;

import java.sql.*;
import com.servlet.config.DBConnection;

public class AdminRepository {
    
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // စုစုပေါင်း User အရေအတွက် (Admin ရော User ရော)
    public int getTotalUsers() throws Exception {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // စုစုပေါင်း Category အရေအတွက် (Soft delete မလုပ်ရသေးတာပဲ ယူမယ်)
    public int getTotalCategories() throws Exception {
        String sql = "SELECT COUNT(*) FROM categories WHERE is_deleted = 0";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // စုစုပေါင်း Cheatsheet အရေအတွက် (Soft delete မလုပ်ရသေးတာပဲ ယူမယ်)
    public int getTotalCheatsheets() throws Exception {
        String sql = "SELECT COUNT(*) FROM cheatsheets WHERE is_deleted = 0";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }
}