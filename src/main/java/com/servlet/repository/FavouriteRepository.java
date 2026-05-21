package com.servlet.repository;

import java.sql.*;
import com.servlet.config.DBConnection;

public class FavouriteRepository {

    // ၁။ Favorite ထည့်ခြင်း သို့မဟုတ် ရှိပြီးသားဆိုရင် ပြန်ဖြုတ်ခြင်း (Toggle စနစ်)
    public boolean toggleFavorite(int userId, int cheatsheetId) throws Exception {
        // ရှိမရှိ အရင်စစ်မယ်
        String checkSql = "SELECT id FROM users_favourite WHERE user_id = ? AND cheatsheets_id = ?";
        String insertSql = "INSERT INTO users_favourite (user_id, cheatsheets_id) VALUES (?, ?)";
        String deleteSql = "DELETE FROM users_favourite WHERE user_id = ? AND cheatsheets_id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            // ရှိမရှိ စစ်ဆေးခြင်း
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, userId);
                psCheck.setInt(2, cheatsheetId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        // ရှိနေရင်... Favorite ပြန်ဖြုတ်မယ် (Delete)
                        try (PreparedStatement psDelete = conn.prepareStatement(deleteSql)) {
                            psDelete.setInt(1, userId);
                            psDelete.setInt(2, cheatsheetId);
                            psDelete.executeUpdate();
                            return false; // Favorite ဖြုတ်လိုက်ကြောင်း အသိပေးရန် false ပြန်
                        }
                    } else {
                        // မရှိသေးရင်... Favorite အသစ်ထည့်မယ် (Insert)
                        try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                            psInsert.setInt(1, userId);
                            psInsert.setInt(2, cheatsheetId);
                            psInsert.executeUpdate();
                            return true; // Favorite ထည့်လိုက်ကြောင်း အသိပေးရန် true ပြန်
                        }
                    }
                }
            }
        }
    }

    // ၂။ User က Favorite လုပ်ထားဖူးသလား စစ်တဲ့ Method (JSP မှာ အသည်းပုံ နီ/မနီ ပြဖို့)
    public boolean isFavourite(int userId, int cheatsheetId) throws Exception {
        String sql = "SELECT id FROM users_favourite WHERE user_id = ? AND cheatsheets_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, cheatsheetId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // ရှိရင် true, မရှိရင် false
            }
        }
    }
}