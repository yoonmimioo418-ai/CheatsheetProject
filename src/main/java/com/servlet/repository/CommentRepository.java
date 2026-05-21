package com.servlet.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servlet.model.Comment;


public class CommentRepository {

    // ၁။ Comment အသစ် သိမ်းဆည်းရန်
 // CommentRepository.java ထဲက addComment ကို ဒီအတိုင်း လိုက်ပြင်ပေးပါ
    public boolean addComment(int cheatsheetId, int userId, String commentText) throws Exception {
        // SQL Query ထဲက username ကို ဖြုတ်လိုက်ပါပြီ
        String sql = "INSERT INTO comments (cheatsheets_id, user_id, comment_text) VALUES (?, ?, ?)";
        
        try (Connection conn = com.servlet.config.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cheatsheetId);
            ps.setInt(2, userId);
            ps.setString(3, commentText);
            
            return ps.executeUpdate() > 0;
        }
    }
    // ၂။ Cheatsheet ID အလိုက် Comment များအားလုံးကို User နာမည်နှင့်တကွ ဆွဲထုတ်ရန်
    public List<Comment> getCommentsByCheatsheet(int cheatsheetId) throws Exception {
        List<Comment> list = new ArrayList<>();
        
        // Query ထဲမှာ c.created_at ကိုပါ ဆွဲထုတ်ဖို့ တိုးလိုက်ပါတယ်
        String sql = "SELECT c.*, u.username FROM comments c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "WHERE c.cheatsheets_id = ? " +
                     "ORDER BY c.id ASC"; 
                     
        try (Connection conn = com.servlet.config.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cheatsheetId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment comment = new Comment();
                    comment.setId(rs.getInt("id"));
                    comment.setCheatsheetId(rs.getInt("cheatsheets_id"));
                    comment.setUserId(rs.getInt("user_id"));
                    comment.setCommentText(rs.getString("comment_text"));
                    comment.setUsername(rs.getString("username"));
                    
                    // *** ဒီစာကြောင်းအသစ်ကို ထည့်ပါ- Database ထဲက အချိန်ကို ဖတ်ပြီး Model ထဲထည့်ခြင်း ***
                    comment.setCreatedAt(rs.getString("created_at")); 
                    
                    list.add(comment);
                }
            }
        }
        return list;
    }
}