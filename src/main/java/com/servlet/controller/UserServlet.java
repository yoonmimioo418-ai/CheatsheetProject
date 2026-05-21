package com.servlet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.servlet.model.User;
import com.servlet.repository.UserRepository;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserRepository userRepo = new UserRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        // Null Check: action မပါလာရင် အလုပ်မလုပ်အောင် တားထားမယ်
        if (action == null) {
            response.sendRedirect("admin_dashboard.jsp?view=users");
            return;
        }

        // =========================================================
        // 💡 ၁။ Role Toggle လုပ်မည့် Logic
        // =========================================================
        if ("changeRole".equals(action)) {
            if (idStr == null || request.getParameter("currentRole") == null) {
                response.sendRedirect("admin_dashboard.jsp?view=users");
                return;
            }
            try {
                int id = Integer.parseInt(idStr);
                String currentRole = request.getParameter("currentRole");
                
                // Role ကို Toggle လုပ်ပေးခြင်း (ADMIN -> USER, USER -> ADMIN)
                String targetRole = "ADMIN".equalsIgnoreCase(currentRole) ? "USER" : "ADMIN";
                
                boolean success = userRepo.changeUserRole(id, targetRole);
                
                if (success) {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=role_updated");
                } else {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=role_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?view=users&msg=error");
            }
            return; 
        }

        // =========================================================
        // 💡 ၂။ Ban User Logic (အကြောင်းပြချက်ပါဝင်သော စနစ်သစ်)
        // =========================================================
        if ("banUser".equals(action)) {
            if (idStr == null) {
                response.sendRedirect("admin_dashboard.jsp?view=users");
                return;
            }
            try {
                int id = Integer.parseInt(idStr);
                String reason = request.getParameter("banReason");
                
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Violation of community guidelines."; // Default Reason
                }
                
                boolean success = userRepo.banUser(id, reason);
                
                if (success) {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=user_banned");
                } else {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=ban_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?view=users&msg=error");
            }
            return;
        }

        // =========================================================
        // 💡 ၃။ အခြား Action များ (Delete, Activate) အတွက် Logic
        // =========================================================
        if (idStr == null) {
            response.sendRedirect("admin_dashboard.jsp?view=users");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            User currentUser = (User) request.getSession().getAttribute("currentUser");

            if ("delete".equals(action)) {
                // ကိုယ့်ကိုယ်ကိုယ် ပြန်မဖျက်အောင် စစ်တာ
                if (currentUser != null && currentUser.getId() == id) {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=self_delete_error");
                    return;
                }
                if (userRepo.deleteUser(id)) {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=deleted");
                } else {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=error");
                }
            } 
            else if ("activate".equals(action)) {
                // ပြန်ဖွင့်ပေးမယ့် Logic (မင်းရဲ့ နဂို updateStatus ကို သုံးထားပါတယ်)
                if (userRepo.updateStatus(id, "Active")) {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=activated");
                } else {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=error");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?view=users&msg=error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("userId"));
                String name = request.getParameter("username");
                String email = request.getParameter("email");
                String role = request.getParameter("role");

                User user = new User();
                user.setId(id);
                user.setUsername(name);
                user.setEmail(email);
                user.setRole(role);

                if (userRepo.updateUser(user)) {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=updated");
                } else {
                    response.sendRedirect("admin_dashboard.jsp?view=users&msg=update_error");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?view=users&msg=update_error");
            }
        }
    }
}