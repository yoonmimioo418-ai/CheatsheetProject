<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servlet.model.Category, com.servlet.repository.CategoryRepository" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Category - Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    /* Form ကို အလယ်ပို့ပေးတဲ့ background box */
    .edit-container {
        max-width: 500px;
        margin: 80px auto;
        background: #ffffff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }

    .edit-header {
        border-bottom: 2px solid #f1f1f1;
        margin-bottom: 20px;
        padding-bottom: 10px;
        color: #333;
    }

    .form-label {
        font-weight: 600;
        color: #555;
    }

    .form-control:focus {
        border-color: #0d6efd;
        box-shadow: 0 0 0 0.25 margin-top: auto;rem rgba(13, 110, 253, 0.25);
    }

    .btn-action {
        padding: 10px 20px;
        font-weight: 500;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .btn-update {
        background-color: #0d6efd;
        border: none;
    }

    .btn-update:hover {
        background-color: #0b5ed7;
        transform: translateY(-2px);
    }

    .btn-cancel {
        background-color: #6c757d;
        color: white;
        text-decoration: none;
    }
</style>
</head>
<body>

    <%
        // Parameter စစ်ဆေးခြင်း
        String idParam = request.getParameter("id");
        if(idParam == null) {
            response.sendRedirect("admin_dashboard.jsp");
            return;
        }
        
        int id = Integer.parseInt(idParam);
        CategoryRepository repo = new CategoryRepository();
        Category cat = repo.findById(id); 
        
        if(cat == null) {
            out.println("<div class='alert alert-danger'>Category not found!</div>");
            return;
        }
    %>

    <div class="container">
    <div class="edit-container">
        <h4 class="edit-header">
            <i class="bi bi-pencil-square"></i> Edit Category
        </h4>
        
        <form action="CategoryServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
            
            <div class="mb-4">
                <label class="form-label">Category Name</label>
                <input type="text" name="categoryName" 
                       class="form-control" 
                       value="<%= request.getParameter("name") %>" 
                       placeholder="Enter new category name"
                       required>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-action btn-update text-white flex-grow-1">
                    Update Category
                </button>
                <a href="admin_dashboard.jsp?view=categories" class="btn btn-action btn-cancel">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

</body>
</html>