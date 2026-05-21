package com.servlet.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servlet.model.Cheatsheet;
import com.servlet.config.DBConnection;

public class CheatsheetRepository {

    // Connection ဗဟိုချက်
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // ၁။ Cheatsheet အသစ်သိမ်းဆည်းခြင်း
    public boolean save(Cheatsheet cs) throws Exception {
        String sql = "INSERT INTO cheatsheets (title, content, categories_id, user_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cs.getTitle());
            ps.setString(2, cs.getContent());
            ps.setInt(3, cs.getCategoryId());
            ps.setInt(4, cs.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    // ၂။ User တစ်ယောက်ချင်းစီရဲ့ ကိုယ်ပိုင် Cheatsheet များကို ဆွဲထုတ်ခြင်း (Dashboard အတွက်)
    public List<Cheatsheet> findByUserId(int userId) throws Exception {
        List<Cheatsheet> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS catName, u.username AS creator_name, " +
                     "COUNT(f.id) AS fav_count " +
                     "FROM cheatsheets s " +
                     "LEFT JOIN categories c ON s.categories_id = c.id " +
                     "LEFT JOIN users u ON s.user_id = u.id " +
                     "LEFT JOIN users_favourite f ON s.id = f.cheatsheets_id " +
                     "WHERE s.user_id = ? " +
                     "GROUP BY s.id, c.name, u.username";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cheatsheet cs = new Cheatsheet();
                    cs.setId(rs.getInt("id"));
                    cs.setTitle(rs.getString("title"));
                    cs.setContent(rs.getString("content"));
                    cs.setCategoryId(rs.getInt("categories_id"));
                    cs.setCategoryName(rs.getString("catName"));
                    cs.setUserId(rs.getInt("user_id"));
                    cs.setUsername(rs.getString("creator_name")); 
                    cs.setFavCount(rs.getInt("fav_count"));
                    list.add(cs);
                }
            }
        }
        return list;
    }

    // ၃။ Category အလိုက် ရှာဖွေခြင်း (Home Screen / Public View အတွက်)
    public List<Cheatsheet> findByCategory(int categoryId) throws Exception {
        List<Cheatsheet> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS catName, u.username AS creator_name, " +
                     "COUNT(f.id) AS fav_count " +
                     "FROM cheatsheets s " +
                     "LEFT JOIN categories c ON s.categories_id = c.id " +
                     "LEFT JOIN users u ON s.user_id = u.id " +
                     "LEFT JOIN users_favourite f ON s.id = f.cheatsheets_id " +
                     "WHERE s.categories_id = ? " +
                     "GROUP BY s.id, c.name, u.username";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cheatsheet cs = new Cheatsheet();
                    cs.setId(rs.getInt("id"));
                    cs.setTitle(rs.getString("title"));
                    cs.setContent(rs.getString("content"));
                    cs.setCategoryId(rs.getInt("categories_id"));
                    cs.setCategoryName(rs.getString("catName"));
                    cs.setUserId(rs.getInt("user_id"));
                    cs.setUsername(rs.getString("creator_name")); 
                    cs.setFavCount(rs.getInt("fav_count"));       
                    list.add(cs);
                }
            }
        }
        return list;
    }

    // ၄။ ID တစ်ခုတည်းဖြင့် အသေးစိတ်ရှာဖွေခြင်း (View Detail Page အတွက် အင်မတန် အရေးကြီးသည်)
    public Cheatsheet findById(int id) throws Exception {
        String sql = "SELECT s.*, c.name as catName, u.username AS creator_name, " +
                     "COUNT(f.id) AS fav_count " +
                     "FROM cheatsheets s " +
                     "LEFT JOIN categories c ON s.categories_id = c.id " +
                     "LEFT JOIN users u ON s.user_id = u.id " +
                     "LEFT JOIN users_favourite f ON s.id = f.cheatsheets_id " +
                     "WHERE s.id = ? " +
                     "GROUP BY s.id, c.name, u.username";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Cheatsheet cs = new Cheatsheet();
                    cs.setId(rs.getInt("id"));
                    cs.setTitle(rs.getString("title"));
                    cs.setContent(rs.getString("content"));
                    cs.setCategoryId(rs.getInt("categories_id"));
                    cs.setCategoryName(rs.getString("catName"));
                    cs.setUserId(rs.getInt("user_id")); // 💡 ဖြည့်စွက်ချက်- user_id ထည့်ပေးလိုက်ပြီ
                    cs.setUsername(rs.getString("creator_name")); 
                    cs.setFavCount(rs.getInt("fav_count"));
                    return cs;
                }
            }
        }
        return null;
    }
    
    // ၅။ ရှိသမျှ Cheatsheets အကုန်လုံးကို ဆွဲထုတ်ခြင်း
    public List<Cheatsheet> findAll() throws Exception {
        List<Cheatsheet> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS catName, u.username AS creator_name, " +
                     "COUNT(f.id) AS fav_count " + 
                     "FROM cheatsheets s " +
                     "LEFT JOIN categories c ON s.categories_id = c.id " +
                     "LEFT JOIN users u ON s.user_id = u.id " +
                     "LEFT JOIN users_favourite f ON s.id = f.cheatsheets_id " + 
                     "GROUP BY s.id, c.name, u.username " +
                     "ORDER BY s.id DESC"; 
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Cheatsheet cs = new Cheatsheet();
                cs.setId(rs.getInt("id"));
                cs.setTitle(rs.getString("title"));
                cs.setContent(rs.getString("content"));
                cs.setCategoryId(rs.getInt("categories_id"));
                
                String catName = rs.getString("catName");
                if(catName == null) {
                    catName = "General";
                }
                cs.setCategoryName(catName);
                
                cs.setUserId(rs.getInt("user_id"));
                cs.setUsername(rs.getString("creator_name")); 
                cs.setFavCount(rs.getInt("fav_count"));
                list.add(cs);
            }
        }
        return list;
    }

    // ၆။ Cheatsheet အား ပြင်ဆင်ပြုလုပ်ခြင်း (Update)
    public boolean update(Cheatsheet cs) throws Exception {
        String sql = "UPDATE cheatsheets SET title = ?, content = ?, categories_id = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cs.getTitle());
            ps.setString(2, cs.getContent());
            ps.setInt(3, cs.getCategoryId());
            ps.setInt(4, cs.getId());
            ps.setInt(5, cs.getUserId());
            return ps.executeUpdate() > 0;
        }
    }
    
    // ၇။ Cheatsheet အား ဖျက်သိမ်းခြင်း (Delete)
    public boolean delete(int id, int userId) throws Exception {
        String sql = "DELETE FROM cheatsheets WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // ၈။ အသည်းပေး (Saved Favourites) ထားသော Cheatsheets များကို ဆွဲထုတ်ခြင်း
    public List<Cheatsheet> findFavouritesByUserId(int userId) throws Exception {
        List<Cheatsheet> list = new ArrayList<>();
        
        // 💡 ဖြည့်စွက်ချက်- u.username AS creator_name ကိုပါ တွဲဆွဲထုတ်ပြီး INNER JOIN users u ချိတ်ပေးလိုက်သည်
        String sql = "SELECT s.*, c.name AS catName, u.username AS creator_name, " +
                     "(SELECT COUNT(*) FROM users_favourite WHERE cheatsheets_id = s.id) AS fav_count " +
                     "FROM users_favourite f " +
                     "INNER JOIN cheatsheets s ON f.cheatsheets_id = s.id " +
                     "INNER JOIN categories c ON s.categories_id = c.id " +
                     "INNER JOIN users u ON s.user_id = u.id " +
                     "WHERE f.user_id = ?"; 
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cheatsheet cs = new Cheatsheet();
                    cs.setId(rs.getInt("id"));
                    cs.setTitle(rs.getString("title"));
                    cs.setContent(rs.getString("content"));
                    cs.setCategoryId(rs.getInt("categories_id"));
                    cs.setCategoryName(rs.getString("catName"));
                    cs.setUserId(rs.getInt("user_id"));
                    cs.setUsername(rs.getString("creator_name")); // ယခု ပုံမှန်အတိုင်း သုံးလို့ရပါပြီ
                    cs.setFavCount(rs.getInt("fav_count"));
                    list.add(cs);
                }
            }
        }
        return list;
    }
    
    // ၉။ အကုန်လုံးကို User Name နှင့်တကွ ဆွဲထုတ်ခြင်း
    public List<Cheatsheet> findAllWithUser() throws Exception {
        List<Cheatsheet> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS catName, u.username AS creatorName " +
                     "FROM cheatsheets s " +
                     "INNER JOIN categories c ON s.categories_id = c.id " +
                     "INNER JOIN users u ON s.user_id = u.id " +
                     "ORDER BY s.id DESC";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Cheatsheet cs = new Cheatsheet();
                cs.setId(rs.getInt("id"));
                cs.setTitle(rs.getString("title"));
                cs.setContent(rs.getString("content"));
                cs.setCategoryId(rs.getInt("categories_id"));
                cs.setCategoryName(rs.getString("catName"));
                cs.setUserId(rs.getInt("user_id"));
                cs.setUsername(rs.getString("creatorName")); 
                list.add(cs);
            }
        }
        return list;
    }
}