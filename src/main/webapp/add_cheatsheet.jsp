<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
    body {
        font-family: 'Segoe UI', Arial, sans-serif;
        background-color: #f0f2f5;
        color: #333;
        margin: 0;
        padding: 20px;
    }

    .container {
        max-width: 600px;
        margin: 40px auto;
        background: #fff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    h5 {
        margin-top: 0;
        color: #007bff;
        font-size: 1.5rem;
        border-bottom: 2px solid #f0f0f0;
        padding-bottom: 10px;
        text-align: center;
    }

    .mb-3 { margin-bottom: 20px; }

    .form-label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        font-size: 0.9rem;
    }

    .form-control, .form-select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box; 
        font-size: 1rem;
    }

    .form-control:focus {
        border-color: #007bff;
        outline: none;
    }

    textarea.form-control {
        font-family: 'Consolas', 'Monaco', monospace;
        background-color: #fafafa;
        resize: vertical;
    }

    .btn-save {
        width: 100%;
        padding: 12px;
        background-color: #007bff;
        border: none;
        color: white;
        font-size: 1rem;
        font-weight: bold;
        border-radius: 4px;
        cursor: pointer;
        transition: background 0.3s;
    }

    .btn-save:hover {
        background-color: #0056b3;
    }

    .btn-back {
        display: block;
        text-align: center;
        margin-top: 15px;
        color: #666;
        text-decoration: none;
        font-size: 0.9rem;
    }

    .btn-back:hover {
        text-decoration: underline;
    }

    .text-muted {
        font-size: 0.8rem;
        color: #888;
        margin-top: 5px;
    }
</style>
</head>
<body>
<%@ page import="java.util.List, com.servlet.model.Category, com.servlet.repository.CategoryRepository" %>
<div class="container mt-5 mb-5">
    <div class="card shadow-lg mx-auto" style="max-width: 750px;">
        <div class="card-header text-white text-center">
            <h5 class="mb-0"><i class="bi bi-plus-circle me-2"></i>Create New Cheatsheet</h5>
        </div>
        <div class="card-body p-4">
            <form action="CheatsheetServlet" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" 
                           placeholder="e.g. Spring Boot Controller Setup" required>
                </div>

                <div class="mb-3">
    <label class="form-label">Select Category</label>
    <select name="categoryId" class="form-select" required>
        <% 
            // Admin ရဲ့ Category List ကို Loop ပတ်ပြီး ထုတ်ပြတာ
            CategoryRepository catRepo = new CategoryRepository();
            List<Category> catList = catRepo.findAll();
            for(Category cat : catList) { 
        %>
            <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
        <% } %>
    </select>
</div>

                <div class="mb-4">
                    <label class="form-label">Content (Cheat Code / Notes)</label>
                    <textarea name="content" class="form-control" rows="10" 
                              placeholder="Paste your snippets or notes here..." required></textarea>
                    <div class="form-text text-muted">Use clear comments to explain your code.</div>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-save text-white">Save Cheatsheet</button>
                    <a href="dashboard.jsp" class="btn-back text-center mt-2">Go back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>