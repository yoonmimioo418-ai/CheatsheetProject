package com.servlet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.servlet.model.User;
import com.servlet.repository.UserRepository;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserRepository userRepo = new UserRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String newUsername = request.getParameter("username");
        String newBio = request.getParameter("bio");

        try {
            // UserRepository ထဲက updateProfile ကို လှမ်းခေါ်ခြင်း
            boolean isUpdated = userRepo.updateProfile(currentUser.getId(), newUsername, newBio);
            
            if (isUpdated) {
                // Session ထဲက data ပါ တစ်ခါတည်း လိုက်ပြောင်းပေးခြင်း
                currentUser.setUsername(newUsername);
                currentUser.setBio(newBio);
                session.setAttribute("currentUser", currentUser);
                
                // 💡 🔴 🟢 ဒီနေရာမှာ Role ကို သေသေချာချာ စစ်ပြီး လမ်းကြောင်းခွဲလိုက်ပါပြီ!
                if ("ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                    // Admin ဖြစ်ရင် admin_profile.jsp ဆီ အောင်အောင်မြင်မြင် ပြန်လွှတ်မယ်
                    response.sendRedirect("admin_profile.jsp?msg=profile_success");
                } else {
                    // ရိုးရိုး User ဆိုရင်တော့ သူ့ dashboard.jsp ဆီ သွားမယ်
                    response.sendRedirect("dashboard.jsp?msg=profile_success");
                }
                
            } else {
                response.sendRedirect("edit_profile.jsp?msg=fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_profile.jsp?msg=error");
        }
    }
}