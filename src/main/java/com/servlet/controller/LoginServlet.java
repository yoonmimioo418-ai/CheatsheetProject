package com.servlet.controller;

import java.io.IOException;
import java.net.URLEncoder; // 💡 URLEncoder အတွက် မဖြစ်မနေ Import ထည့်ရပါမယ်
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.servlet.model.User;
import com.servlet.repository.UserRepository;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserRepository userRepository = new UserRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        
        try {
            User user = userRepository.loginUser(email, pass);

            if (user != null) {
                
                // 💡 ၁။ အကောင့်က BANNED ဖြစ်နေလား အရင်ဆုံး စစ်ဆေးမယ် (Session ထဲ မထည့်ခင် စစ်တာ ပိုစိတ်ချရပါတယ်)
                if ("BANNED".equalsIgnoreCase(user.getStatus())) {
                    String reason = user.getBan_reason();
                    if (reason == null) reason = "Violation of community guidelines.";
                    
                    // အကြောင်းပြချက်နဲ့အတူ login.jsp ဆီ ပြန်မောင်းထုတ်မယ်
                    response.sendRedirect("login.jsp?msg=banned&reason=" + URLEncoder.encode(reason, "UTF-8"));
                    return; // 💡 အောက်က ကုဒ်တွေဆီ ဆက်မဆင်းအောင် ချက်ချင်း ဖြတ်ချမယ်
                }

                // 💡 ၂။ ပုံမှန် Active ဖြစ်တဲ့ User/Admin မှသာ Session ဆောက်ပေးမယ်
                request.getSession().setAttribute("currentUser", user);

                // 💡 ၃။ Role အလိုက် လမ်းကြောင်းခွဲမယ်
                if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }
                
            } else {
                // ၄။ forward သုံးမှ request.getAttribute("error") ကို JSP မှာ ပြနိုင်မယ်
                request.setAttribute("error", "Invalid Email or Password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server Error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}