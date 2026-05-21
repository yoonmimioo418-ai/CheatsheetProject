<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servlet.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Bio က null ဖြစ်နေရင် text box ထဲမှာ အလွတ်ပြပေးရန်
    String userBio = currentUser.getBio();
    if (userBio == null) {
        userBio = "";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="card mx-auto shadow" style="max-width: 500px;">
            <div class="card-header bg-primary text-white text-center">
                <h4 class="mb-0">Edit Profile</h4>
            </div>
            <div class="card-body">
                <form action="ProfileServlet" method="post">
                    
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" value="<%= currentUser.getUsername() %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">About Me (Bio)</label>
                        <textarea name="bio" class="form-control" rows="4" placeholder="Tell us about yourself..."><%= userBio %></textarea>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                       <%
    // 💡 Session ထဲက currentUser ကို သေချာပေါက် ပြန်ယူပြီး Role စစ်ပါမယ်
    com.servlet.model.User logUser = (com.servlet.model.User) session.getAttribute("currentUser");
%>

<div class="mt-4 d-flex gap-2">
    <button type="submit" class="btn btn-blue-primary">Update Profile</button>

    <% 
        // Role က Admin ဖြစ်နေရင် Admin Profile View ဆီကိုပဲ ပြန်လွှတ်မယ်
        if (logUser != null && "ADMIN".equalsIgnoreCase(logUser.getRole())) { 
    %>
        <a href="admin_profile.jsp" class="btn btn-outline-secondary rounded-2 px-4 fw-semibold">
            <i class="bi bi-x-circle me-1"></i> Cancel
        </a>
    <% } else { %>
        <a href="dashboard.jsp" class="btn btn-outline-secondary rounded-2 px-4 fw-semibold">
            <i class="bi bi-x-circle me-1"></i> Cancel
        </a>
    <% } %>
</div>
</div>
                    </div>
                
            </div>
        </div>
    

</body>
</html>