package com.servlet.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.servlet.model.User;

public class UserRepository {
    
    private String dbUrl = "jdbc:mysql://localhost:3306/cheatsheet_db?useSSL=false&allowPublicKeyRetrieval=true";
    private String dbUser = "root";
    private String dbPassword = "minpyae"; // မင်းရဲ့ MySQL password

    public UserRepository() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public User loginUser(String email, String password) throws Exception {
        User user = null;
        // SQL ကို email နဲ့ password ပဲ စစ်ဖို့ ပြင်လိုက်ပါ
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim());
            ps.setString(2, password.trim());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                }
            }
        }
        return user; // user မတွေ့ရင် null ပြန်မယ်
    }
    
    public boolean registerUser(User user) throws Exception {
        // Status ကို Default 'Active' လို့ ထည့်ပေးထားပါတယ်
        String sql = "INSERT INTO users (username, password, email, role, status) VALUES (?, ?, ?, 'USER', 'Active')";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            
            int row = ps.executeUpdate();
            return row > 0;
        }
    }

    public List<User> getAllUsers() throws Exception {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY username ASC"; 
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        }
        return list;
    }

    public User getUserById(int id) throws Exception {
        User user = null;
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                }
            }
        }
        return user;
    }

    public boolean updateUser(User user) throws Exception {
        String sql = "UPDATE users SET username = ?, email = ?, role = ? WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getRole());
            ps.setInt(4, user.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int id) throws Exception {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
    
 // UserRepository.java ထဲတွင် ထည့်သွင်းရန်
    public boolean banUser(int userId, String reason) {
        String sql = "UPDATE users SET status = 'BANNED', ban_reason = ? WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reason);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> searchUsers(String keyword) throws Exception {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE (username LIKE ? OR email LIKE ?) AND role != 'ADMIN' ORDER BY username ASC";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchKey = "%" + keyword + "%";
            ps.setString(1, searchKey);
            ps.setString(2, searchKey);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setStatus(rs.getString("status"));
                    list.add(u);
                }
            }
        }
        return list;
    }
    
    public boolean updateStatus(int userId, String status) throws Exception {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
		return false;
    }
        public List<User> findAll() throws Exception {
            List<User> users = new ArrayList<>();
            String sql = "SELECT * FROM users ORDER BY id DESC";
            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    users.add(u);
                }
            }
            return users;
        }
        
     // Profile ပြင်ဆင်ခြင်းအတွက် Method အသစ်
        public boolean updateProfile(int userId, String username, String bio) throws Exception {
            String sql = "UPDATE users SET username = ?, bio = ? WHERE id = ?";
            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, bio);
                ps.setInt(3, userId);
                return ps.executeUpdate() > 0;
            }
        }
     // UserRepository.java ထဲမှာ သွားထည့်ရန် Method
        public boolean changeUserRole(int userId, String newRole) {
            String sql = "UPDATE users SET role = ? WHERE id = ?";
            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);// မင်းသုံးထားတဲ့ Connection Class နာမည် ပြောင်းသုံးပါ
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                
                ps.setString(1, newRole.toUpperCase());
                ps.setInt(2, userId);
                
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
            return false;
        }

		
    }
