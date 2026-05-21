package com.servlet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.servlet.model.User;
import com.servlet.repository.UserRepository;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private UserRepository repo = new UserRepository();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<User> userList = repo.getAllUsers();
            request.setAttribute("userList", userList);
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}