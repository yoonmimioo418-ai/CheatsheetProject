package com.servlet.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.servlet.model.User;
import com.servlet.model.Cheatsheet;
import com.servlet.repository.CheatsheetRepository;

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // 💡 Security Check: လူတိုင်း ဝင်မွှေလို့မရအောင် Role ကိုပါ စစ်ထားမယ်
        // (မင်းရဲ့ User Model ထဲမှာ Role စနစ် ရှိတယ်မလား၊ ဥပမာ- "ADMIN")
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        CheatsheetRepository repo = new CheatsheetRepository();
        try {
            List<Cheatsheet> allSheets = repo.findAllWithUser();
            // JSP ဘက်ကို ဒေတာ သယ်သွားဖို့ သတ်မှတ်ခြင်း
            request.setAttribute("allSheets", allSheets);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }
}