<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servlet.model.*, com.servlet.repository.*, java.util.List" %>

<%
    // Servlet ကနေ request.setAttribute("cheatsheet", cs) နဲ့ ထည့်ပေးလိုက်တာကို ယူတယ်
    Cheatsheet cs = (Cheatsheet) request.getAttribute("cheatsheet");
    
    // အကယ်၍ Servlet ကိုမဖြတ်ဘဲ တိုက်ရိုက်ဝင်လာရင် Dashboard ကို ပြန်မောင်းထုတ်မယ်
    if (cs == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    CommentRepository commentRepo = new CommentRepository();
    FavouriteRepository favRepo = new FavouriteRepository(); 
    User user = (User) session.getAttribute("currentUser");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= cs.getTitle() %> - DevCheat</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .custom-main-box {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }
        .custom-comment-section {
            background-color: #f8f9fa;
            border-top: 1px solid #eeeeee;
            padding: 12px 15px;
            border-radius: 0 0 12px 12px;
        }
    </style>
</head>
<body>

    <div class="container my-5">
<div class="mb-4">
    <%-- User ရှိရင် dashboard.jsp ကိုသွားမယ်၊ မရှိရင် login.jsp (သို့) index.jsp ကိုသွားမယ် --%>
    <a href="<%= (user != null) ? "dashboard.jsp" : "index.jsp" %>" class="btn btn-white bg-white text-dark shadow-sm rounded-pill px-4">
        <i class="bi bi-arrow-left me-2"></i>Back to <%= (user != null) ? "Dashboard" : "Home" %>
    </a>
</div>

        <div class="row justify-content-center">
            <div class="col-lg-9">
                
                <div class="custom-main-box p-0 overflow-hidden shadow-sm">
                    
                    <div class="p-3 d-flex align-items-center bg-white border-bottom">
                        <span class="badge bg-primary rounded-pill me-2"><%= cs.getCategoryName() != null ? cs.getCategoryName() : "General" %></span>
                        <strong class="text-dark">Posted by: <%= cs.getUsername() != null ? cs.getUsername() : "User" %></strong> 
                    </div>

                    <div class="p-4 bg-light text-center border-bottom">
                        <div class="mb-2"><i class="bi bi-code-slash text-primary fs-3"></i></div>
                        <h5 class="fw-bold text-dark mb-1"><%= cs.getTitle() %></h5>
                        <p class="text-muted small mb-0"><%= cs.getContent() %></p>
                    </div>

                    <div class="p-3 bg-white border-bottom position-relative">
                        <div class="d-flex align-items-center justify-content-between">
                            
                            <div style="min-width: 120px;">
                                <% if (user != null) { 
                                    boolean hasFavourited = favRepo.isFavourite(user.getId(), cs.getId());
                                %>
                                    <form action="FavouriteServlet" method="POST" class="m-0">
                                        <input type="hidden" name="cheatsheetId" value="<%= cs.getId() %>">
                                        <input type="hidden" name="redirectUrl" value="CheatsheetServlet?action=view&id=<%= cs.getId() %>">
                                        
                                        <button type="submit" class="btn btn-link text-danger p-0 border-0 d-flex align-items-center gap-1" style="text-decoration: none;">
                                            <% if (hasFavourited) { %>
                                                <i class="bi bi-heart-fill fs-5"></i>
                                            <% } else { %>
                                                <i class="bi bi-heart fs-5"></i>
                                            <% } %>
                                            <span class="small text-secondary">Favorite (<%= cs.getFavCount() %>)</span>
                                        </button>
                                    </form>
                                <% } else { %>
                                    <span class="text-muted small d-flex align-items-center gap-1">
                                        <i class="bi bi-heart fs-5"></i>
                                        <span class="small text-secondary">Favorite (<%= cs.getFavCount() %>)</span> 
                                    </span>
                                <% } %>
                            </div>

                            <div class="text-center flex-grow-1">
                                <span class="text-secondary small fw-bold">
                                    <i class="bi bi-chat-left-text me-2"></i>Comments
                                </span>
                            </div>

                            <div style="min-width: 120px;"></div>
                        </div>
                    </div>

                    <div class="custom-comment-section">
                        <% 
                            List<Comment> commentList = commentRepo.getCommentsByCheatsheet(cs.getId());
                            if (commentList != null && !commentList.isEmpty()) {
                                for(Comment c : commentList) { 
                        %>
                            <div class="d-flex align-items-start mb-2 bg-white p-2 rounded border">
                                <span class="badge bg-secondary rounded-pill me-2 small" style="font-size: 0.7rem;">PF</span>
                                <div class="w-100">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong class="text-dark small" style="font-size: 0.8rem;"><%= c.getUsername() %></strong>
                                        <small class="text-muted" style="font-size: 0.75rem;"><%= c.getCreatedAt() %></small>
                                    </div>
                                    <span class="text-secondary small d-block mt-1" style="font-size: 0.85rem;"><%= c.getCommentText() %></span>
                                </div>
                            </div>
                        <% 
                                }
                            } else { 
                        %>
                            <span class="text-muted small d-block text-center py-2">No comments on this sheet.</span>
                        <% } %>
                        
                        <% if (user != null) { %>
                            <form action="${pageContext.request.contextPath}/CommentServlet" method="POST" class="mt-3 d-flex gap-2">
                                <input type="hidden" name="cheatsheetId" value="<%= cs.getId() %>">
                                <input type="hidden" name="redirectUrl" value="CheatsheetServlet?action=view&id=<%= cs.getId() %>">
                                
                                <input type="text" name="commentText" class="form-control form-control-sm rounded-pill" placeholder="Write a comment..." required>
                                <button type="submit" class="btn btn-primary btn-sm rounded-pill px-3">Comment</button>
                            </form>
                        <% } %>
                    </div>

                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>