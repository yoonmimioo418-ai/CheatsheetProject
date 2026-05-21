package com.servlet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.servlet.model.User;
import com.servlet.repository.CommentRepository;

@WebServlet("/CommentServlet")
public class CommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CommentRepository commentRepo = new CommentRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int cheatsheetId = Integer.parseInt(request.getParameter("cheatsheetId"));
        String commentText = request.getParameter("commentText");
        String redirectUrl = request.getParameter("redirectUrl");

     // CommentServlet.java ရဲ့ doPost ထဲက သိမ်းတဲ့အပိုင်းကို ဒီလိုပဲ ထားလိုက်ပါ
        if (commentText != null && !commentText.trim().isEmpty()) {
            try {
                // ပါရာမီတာ ၃ ခုပဲ ပို့တော့တယ်
                commentRepo.addComment(cheatsheetId, currentUser.getId(), commentText.trim());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("CheatsheetServlet?action=view&id=" + cheatsheetId);
        }
    }
}