<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servlet.model.*, com.servlet.repository.*, java.util.List, java.util.ArrayList" %>

<%
    // URL Parameter ကနေ ပို့လိုက်တဲ့ Category ID နဲ့ နာမည်ကို ဖတ်ယူခြင်း
    String idParam = request.getParameter("id");
    String categoryName = request.getParameter("category");
    
    if (categoryName == null) {
        categoryName = "Technology";
    }
    
    CheatsheetRepository repo = new CheatsheetRepository();
    List<Cheatsheet> categorySheets = new ArrayList<>();
    
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            int categoryId = Integer.parseInt(idParam.trim());
            // အဆိုပါ Category ID နဲ့ ဆိုင်တဲ့ Cheatsheets စာရင်းကိုပဲ ဆွဲထုတ်မယ်
            categorySheets = repo.findByCategory(categoryId);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    
    User user = (User) session.getAttribute("currentUser");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= categoryName %> Cheatsheets - DevCheat</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        
        /* FB Style Card Box */
        .custom-main-box {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 0px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
            overflow: hidden;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-white bg-white border-bottom sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="index.jsp" style="text-decoration: none; font-size: 1.5rem;">
                <i class="bi bi-code-square me-2"></i>DEVCHEAT
            </a>
            <a href="index.jsp" class="btn btn-light btn-sm rounded-pill border px-3">
                <i class="bi bi-arrow-left me-1"></i> Back to Home
            </a>
        </div>
    </nav>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <!-- Category Title Banner -->
                <div class="d-flex align-items-center justify-content-between mb-4 bg-white p-4 rounded-3 shadow-sm border">
                    <div>
                        <span class="text-muted text-uppercase small tracking-wider">Category Category</span>
                        <h2 class="fw-bold text-dark m-0">
                            <i class="bi bi-folder2-open text-primary me-2"></i><%= categoryName %>
                        </h2>
                    </div>
                    <span class="badge bg-primary rounded-pill px-3 py-2 fs-6">
                        <%= categorySheets != null ? categorySheets.size() : 0 %> Sheets
                    </span>
                </div>

                <% 
                    if (categorySheets != null && !categorySheets.isEmpty()) {
                        for(Cheatsheet cs : categorySheets) { 
                %>
                    <div class="custom-main-box shadow-sm">
                        
                        <!-- Top Row: Creator Profile & Badge -->
                        <div class="p-3 d-flex align-items-center justify-content-between bg-white border-bottom">
                            <div class="d-flex align-items-center">
                                <img src="https://ui-avatars.com/api/?name=<%= cs.getUsername() != null ? cs.getUsername() : "User" %>&background=random" class="rounded-circle me-2" width="35" height="35">
                                <div>
                                    <strong class="text-dark d-block"><%= cs.getUsername() != null ? cs.getUsername() : "Anonymous User" %></strong>
                                    <small class="text-muted" style="font-size: 0.75rem;">Community Member</small>
                                </div>
                            </div>
                            <span class="badge bg-light text-primary border rounded-pill"><%= categoryName %></span>
                        </div>

                        <!-- Middle Row: Content Display -->
                        <div class="p-4 bg-light text-center border-bottom">
                            <div class="mb-2"><i class="bi bi-braces text-primary fs-3"></i></div>
                            <h5 class="fw-bold text-dark mb-2"><%= cs.getTitle() %></h5>
                            <p class="text-secondary small mb-0 text-truncate w-100" style="max-height: 45px;"><%= cs.getContent() %></p>
                        </div>

                        <!-- Bottom Row: View Details Link & Fav Stats -->
                        <div class="p-3 bg-white d-flex align-items-center justify-content-between">
                            <div class="text-muted small">
                                <i class="bi bi-heart-fill text-danger me-1"></i> <%= cs.getFavCount() %> favorites
                            </div>
                            
                            <!-- စနစ်တကျ ညှိထားသော Servlet Action link -->
                            <a href="CheatsheetServlet?action=view&id=<%= cs.getId() %>" class="btn btn-primary btn-sm rounded-pill px-4 fw-bold shadow-sm">
                                <i class="bi bi-eye me-1"></i> Read Details
                            </a>
                        </div>

                    </div>
                <% 
                        }
                    } else { 
                %>
                    <!-- Data မရှိလျှင် ပြသမည့် Box -->
                    <div class="text-center py-5 text-muted bg-white rounded-3 border shadow-sm">
                        <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                        <span class="fw-bold">No cheatsheets found.</span>
                        <p class="small text-muted mb-0 mt-1">Be the first to create a cheatsheet under <%= categoryName %> category!</p>
                        <a href="dashboard.jsp" class="btn btn-sm btn-outline-primary rounded-pill mt-3 px-3">+ Create One</a>
                    </div>
                <% } %>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>