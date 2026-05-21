package com.servlet.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.servlet.model.Category;
import com.servlet.model.Cheatsheet;
import com.servlet.model.User;
import com.servlet.repository.CategoryRepository;
import com.servlet.repository.CheatsheetRepository;

@WebServlet("/CheatsheetServlet")
public class CheatsheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CheatsheetRepository csRepo = new CheatsheetRepository();
    private CategoryRepository catRepo = new CategoryRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("Action received: " + action);
        
        try {
            List<Category> catList = catRepo.findAll();
            request.setAttribute("categories", catList);
        } catch (Exception e) {
            System.out.println("Error fetching categories: " + e.getMessage());
            e.printStackTrace();
        }

        // ၁။ Add Page Logic
        if ("add_page".equals(action)) {
            request.getRequestDispatcher("add_cheatsheet.jsp").forward(request, response);
        } 

        // ၂။ Edit Page Logic
        else if ("edit".equals(action)) {
            String sid = request.getParameter("id");
            if (sid != null && !sid.isEmpty()) {
                try {
                    int id = Integer.parseInt(sid);
                    Cheatsheet cs = csRepo.findById(id);
                    if (cs != null) {
                        request.setAttribute("cs", cs);
                        request.getRequestDispatcher("edit_cheatsheet.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("dashboard.jsp?msg=notfound");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("dashboard.jsp?msg=error");
                }
            } else {
                response.sendRedirect("dashboard.jsp");
            }
        } 

        // ၃။ Delete Logic
        else if ("delete".equals(action)) {
            String sid = request.getParameter("id");
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser != null && sid != null && !sid.isEmpty()) {
                try {
                    int id = Integer.parseInt(sid);
                    if (csRepo.delete(id, currentUser.getId())) {
                        response.sendRedirect("dashboard.jsp?msg=del_success");
                    } else {
                        response.sendRedirect("dashboard.jsp?msg=del_fail");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("dashboard.jsp?msg=error");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }

        // ၄။ View Logic (ကုဒ်နှစ်ထပ်ဖြစ်နေတာကို ရှင်းပြီး နာမည်ညှိလိုက်ပြီ)
        else if ("view".equals(action)) {
        	
            String sid = request.getParameter("id");
            if (sid != null && !sid.isEmpty()) {
                try {
                    int id = Integer.parseInt(sid);
                    Cheatsheet cs = csRepo.findById(id);
                    if (cs != null) {
                        // အရေးကြီးတယ်- JSP ဘက်က ခေါ်တဲ့ "cheatsheet" ဆိုတဲ့ နာမည်နဲ့ ကွက်တိညှိပေးလိုက်တယ်
                    	
                        request.setAttribute("cheatsheet", cs);
                        request.getRequestDispatcher("view_cheatsheet.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("index.jsp");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("index.jsp");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser != null) {
                Cheatsheet cs = new Cheatsheet();
                cs.setTitle(title);
                cs.setContent(content);
                cs.setCategoryId(categoryId);
                cs.setUserId(currentUser.getId());
                try {
                    if (csRepo.save(cs)) {
                        response.sendRedirect("dashboard.jsp?msg=success");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("add_cheatsheet.jsp?msg=error");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
        
        else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");

            if (currentUser != null) {
                Cheatsheet cs = new Cheatsheet();
                cs.setId(id);
                cs.setTitle(title);
                cs.setContent(content);
                cs.setCategoryId(categoryId);
                cs.setUserId(currentUser.getId());

                try {
                    if (csRepo.update(cs)) {
                        response.sendRedirect("dashboard.jsp?msg=update_success");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("edit_cheatsheet.jsp?id=" + id + "&msg=error");
                }
            }
        }
    }
}