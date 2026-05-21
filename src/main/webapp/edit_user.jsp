<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servlet.model.User, com.servlet.repository.UserRepository" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit User - Admin Panel</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .edit-container {
            margin-top: 80px;
        }

        .card {
            border: none;
            border-radius: 15px;
            transition: all 0.3s ease;
        }

        .card-header {
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
            font-weight: bold;
            color: #333;
            background: linear-gradient(45deg, #ffca2c, #ffcd39); /* Warning gradient */
        }

        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #ddd;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 0.25rem rgba(255, 193, 7, 0.2);
            border-color: #ffc107;
        }

        .btn-update {
            background-color: #0d6efd;
            border: none;
            padding: 12px;
            font-weight: bold;
            border-radius: 8px;
            transition: 0.3s;
        }

        .btn-update:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
        }

        .btn-cancel {
            background-color: #6c757d;
            color: white;
            padding: 12px;
            border-radius: 8px;
            text-decoration: none;
            display: block;
            text-align: center;
            margin-top: 10px;
            transition: 0.3s;
        }

        .btn-cancel:hover {
            background-color: #5a6268;
            color: white;
        }
    </style>
</head>
<body>

<%
    // ID မပါလာရင် Dashboard ပြန်လွှတ်ဖို့ safety check
    String idStr = request.getParameter("id");
    if(idStr == null) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);
    UserRepository repo = new UserRepository();
    User user = repo.getUserById(id);
    
    if(user == null) {
        out.println("<div class='container mt-5 alert alert-danger'>User not found!</div>");
        return;
    }
%>

<div class="container edit-container">
    <div class="card shadow-lg mx-auto" style="max-width: 480px;">
        <div class="card-header text-center">
            <h5 class="mb-0">Edit User Profile</h5>
        </div>
        <div class="card-body p-4">
            <form action="UserServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="userId" value="<%= user.getId() %>">
                
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" value="<%= user.getUsername() %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" required>
                </div>

                <div class="mb-4">
                    <label class="form-label">Account Role</label>
                    <select name="role" class="form-select">
                        <option value="USER" <%= "USER".equals(user.getRole()) ? "selected" : "" %>>USER</option>
                        <option value="ADMIN" <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>ADMIN</option>
                    </select>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-update text-white">Save Changes</button>
                    <a href="admin_dashboard.jsp" class="btn btn-cancel text-white">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>