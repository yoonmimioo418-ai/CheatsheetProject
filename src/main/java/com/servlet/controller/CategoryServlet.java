package com.servlet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.servlet.repository.CategoryRepository;

@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryRepository repo = new CategoryRepository();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String name = request.getParameter("categoryName");

        try {
            if ("add".equals(action)) {
                repo.save(name);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                repo.update(id, name);
            }
            response.sendRedirect("admin_dashboard.jsp?view=categories");
        } catch (Exception e) { 
            e.printStackTrace(); 
            response.sendRedirect("admin_dashboard.jsp?error=server_error");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        // Null check: ID မပါရင် ဘာမှမလုပ်ဘဲ ပြန်ပို့မယ် (NullPointerException မတက်အောင်)
        if (idStr == null || action == null) {
            response.sendRedirect("admin_dashboard.jsp?view=categories");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            if ("delete".equals(action)) {
                repo.delete(id);
                response.sendRedirect("admin_dashboard.jsp?view=categories");
            } 
            else if ("restore".equals(action)) {
                repo.restore(id);
                response.sendRedirect("admin_dashboard.jsp?view=recycle_bin");
            } 
            else if ("perm_delete".equals(action)) {
                repo.permanentDelete(id);
                response.sendRedirect("admin_dashboard.jsp?view=recycle_bin");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?error=action_failed");
        }
    }
}