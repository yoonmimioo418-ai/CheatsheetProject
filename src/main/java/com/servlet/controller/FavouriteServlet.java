package com.servlet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.servlet.model.User;
import com.servlet.repository.FavouriteRepository;


@WebServlet("/FavouriteServlet")
public class FavouriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FavouriteRepository favRepo = new FavouriteRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int cheatsheetId = Integer.parseInt(request.getParameter("cheatsheetId"));
        
        // ဘယ်စာမျက်နှာကနေ နှိပ်လိုက်တာလဲဆိုတာ သိအောင် လမ်းကြောင်းဖတ်မယ်
        String redirectUrl = request.getParameter("redirectUrl");

        try {
            // Favorite Toggle (ထည့်/ဖြုတ်) လုပ်ခြင်း
            favRepo.toggleFavorite(currentUser.getId(), cheatsheetId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // နှိပ်လိုက်တဲ့ မူလစာမျက်နှာဆီ ကွက်တိ လမ်းကြောင်းပြန်ပေးခြင်း
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("index.jsp");
        }
    }
}