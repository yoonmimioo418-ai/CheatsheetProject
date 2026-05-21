package com.servlet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.servlet.model.User;
import com.servlet.repository.UserRepository;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
   
	private static final long serialVersionUID = 1L;
	private UserRepository userRepository = new UserRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
   
    	    String name = request.getParameter("username");
    	    String email = request.getParameter("email");
    	    String pass = request.getParameter("password");
    	    String confirmPass = request.getParameter("confirm_password");

    	    // 1. Password နှစ်ခု တူမတူ အရင်စစ်မယ်
    	    if (pass != null && pass.equals(confirmPass)) {
    	        User newUser = new User();
    	        newUser.setUsername(name);
    	        newUser.setEmail(email);
    	        newUser.setPassword(pass);
    	        newUser.setRole("USER");

    	        try {
    	            // 2. Database ထဲ ထည့်မယ်
    	            boolean result = userRepository.registerUser(newUser);
    	            
    	            if (result) {
    	                response.sendRedirect("index.jsp?msg=success");
    	            } else {
    	                response.sendRedirect("index.jsp?status=fail");
    	            }
    	        } catch (Exception e) {
    	            e.printStackTrace(); // Console မှာ error ကြည့်ဖို့
    	            // email တူနေရင် ဒါမှမဟုတ် DB error တက်ရင် ဒီကို ရောက်လာမယ်
    	            response.sendRedirect("index.jsp?status=error");
    	        }
    	    } else {
    	        // 3. Password မတူရင် mismatch error ပြမယ်
    	        response.sendRedirect("index.jsp?status=mismatch");
    	    }
    	}
}
  