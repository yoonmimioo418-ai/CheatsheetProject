package com.servlet.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servlet.model.Category;
import com.servlet.config.DBConnection;

public class CategoryRepository {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Category အသစ်ထည့်ရန်
    public boolean save(String name) throws Exception {
        String sql = "INSERT INTO categories (name) VALUES (?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        }
    }

    // Category အားလုံးထုတ်ရန် (Soft Delete ဖြစ်နေတာတွေ မပါစေရ)
    public List<Category> findAll() throws Exception {
        List<Category> list = new ArrayList<>();
        // WHERE is_deleted = 0 ထည့်မှ ဖျက်ထားတဲ့ Category တွေ ပေါ်မလာမှာပါ
        String sql = "SELECT * FROM categories WHERE is_deleted = 0 ORDER BY name ASC"; 
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                list.add(cat);
            }
        }
        return list;
    }

    // Category ပြင်ရန်
    public boolean update(int id, String newName) throws Exception {
        String sql = "UPDATE categories SET name = ? WHERE id = ? AND is_deleted = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Category ဖျက်ရန် (Soft Delete logic)
    public boolean delete(int id) throws Exception {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); 

            // ၁။ Category အောက်က Cheatsheet တွေကို Soft Delete အရင်လုပ်မယ်
            // database column နာမည်ကို သတိထားပါ (categories_id ဟု ယူဆသည်)
            String sql1 = "UPDATE cheatsheets SET is_deleted = 1 WHERE categories_id = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(sql1)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }

            // ၂။ Category ကို Soft Delete လုပ်မယ်
            String sql2 = "UPDATE categories SET is_deleted = 1 WHERE id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(sql2)) {
                ps2.setInt(1, id);
                int result = ps2.executeUpdate();
                
                conn.commit(); 
                return result > 0;
            }
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }

    // ID တစ်ခုတည်းကို ရှာတဲ့ Method (ပြင်ဆင်ပြီး)
    public Category findById(int id) throws Exception {
        Category cat = null;
        // အရေးကြီး- WHERE id = ? ထည့်ရပါမယ်။ အရင် code မှာ ဒါကျန်ခဲ့လို့ error တက်တာပါ
        String sql = "SELECT * FROM categories WHERE id = ? AND is_deleted = 0";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id); // အခုဆိုရင် SQL မှာ ? ပါလို့ ဒီ index 1 က အလုပ်လုပ်ပါပြီ
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cat = new Category();
                    cat.setId(rs.getInt("id"));
                    cat.setName(rs.getString("name"));
                }
            }
        }
        return cat;
    }
 // ဖျက်လိုက်တဲ့ Category တွေကို ပြန်ဆယ်ရန် (Restore)
    public boolean restore(int id) throws Exception {
        String sql = "UPDATE categories SET is_deleted = 0 WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Database ထဲကနေ အပြီးတိုင် ဖျက်ပစ်ရန် (Permanent Delete)
    public boolean permanentDelete(int id) throws Exception {
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ဖျက်ထားတဲ့ Category တွေချည်းပဲ သီးသန့် ထုတ်ပေးမယ့် Method
    public List<Category> findAllDeleted() throws Exception {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE is_deleted = 1 ORDER BY name ASC";
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                list.add(cat);
            }
        }
        return list;
    }
    
 // CategoryRepository.java ထဲမှာ ထည့်ရန်
    public List<Category> searchCategories(String query) throws Exception {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE is_deleted = 0 AND name LIKE ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + query + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category cat = new Category();
                    cat.setId(rs.getInt("id"));
                    cat.setName(rs.getString("name"));
                    list.add(cat);
                }
            }
        }
        return list;
    }
    
    public List<Category> getAllCategories() throws Exception {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name FROM categories WHERE is_deleted = 0";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                list.add(cat);
            }
        }
        return list;
    }
}