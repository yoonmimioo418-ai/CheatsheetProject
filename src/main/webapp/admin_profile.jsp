<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servlet.model.User" %>

<%
    // Security Check: Login မဝင်ထားရင် login.jsp ကို ပြန်လွှတ်မယ်
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Profile - DevCheat Central</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fc; font-family: 'Segoe UI', sans-serif; color: #495057; }
        
        /* Sidebar Design (ရှိပြီးသား Theme အတိုင်း) */
        .sidebar { 
            min-height: 100vh; 
            background: linear-gradient(180deg, #4e73df 0%, #224abe 100%); 
            color: white; 
            padding-top: 30px; 
            border-radius: 0 20px 20px 0;
        }
        .sidebar h4 { font-weight: 700; letter-spacing: 1px; color: #ffffff; margin-bottom: 30px; }
        .sidebar a { color: rgba(255, 255, 255, 0.8); text-decoration: none; display: block; padding: 14px 22px; font-weight: 500; transition: all 0.3s; border-radius: 10px; margin: 4px 12px; }
        .sidebar a i { margin-right: 10px; font-size: 1.1rem; }
        .sidebar a:hover { background: rgba(255, 255, 255, 0.15); color: white; padding-left: 28px; }
        .sidebar a.active { background: white; color: #4e73df; font-weight: 700; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .sidebar a.text-danger { color: #ffb3b3 !important; }
        
        /* Profile Card Space */
        .profile-card { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05); background: white; }
        .avatar-circle { width: 120px; height: 120px; background: #e6f0fa; color: #4e73df; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 3.5rem; margin: 0 auto 20px; border: 4px solid #ffffff; box-shadow: 0 5px 15px rgba(78,115,223,0.2); }
        .info-label { font-weight: 600; color: #4e73df; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .info-value { font-size: 1.1rem; font-weight: 500; color: #2c3e50; padding: 10px 0; border-bottom: 1px solid #edf2f7; }
        .btn-blue-primary { background-color: #4e73df; color: white; border: none; font-weight: 600; border-radius: 10px; padding: 12px 25px; transition: 0.3s; }
        .btn-blue-primary:hover { background-color: #224abe; color: white; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(78,115,223,0.3); }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        
        <div class="col-md-2 sidebar shadow">
            <h4 class="text-center"><i class="bi bi-shield-lock-fill me-2"></i>Admin Panel</h4>
            <hr class="mx-3 opacity-25 text-white">
            <a href="admin_dashboard.jsp?view=users"><i class="bi bi-people-fill"></i> Manage Users</a>
            <a href="admin_dashboard.jsp?view=cheatsheets"><i class="bi bi-file-earmark-code-fill"></i> Manage Cheatsheets</a>
            <a href="admin_dashboard.jsp?view=categories"><i class="bi bi-tags-fill"></i> Manage Categories</a>
            <a href="admin_dashboard.jsp?view=recycle_bin"><i class="bi bi-trash-fill"></i> Recycle Bin</a>
            <a href="admin_profile.jsp" class="active"><i class="bi bi-person-bounding-box"></i> Admin Profile</a>
            <hr class="mx-3 opacity-25 text-white mt-4">
            <a href="logout" class="text-danger"><i class="bi bi-box-arrow-left"></i> Logout Account</a>
        </div>

        <div class="col-md-10 p-5 d-flex align-items-center justify-content-center" style="min-height: 100vh;">
            <div class="col-md-6">
                
                <div class="profile-card p-5 text-center shadow">
                    <div class="avatar-circle">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    
                    <h3 class="fw-bold text-dark mb-1"><%= currentUser.getUsername() %></h3>
                    <span class="badge bg-danger rounded-pill px-3 py-2 fw-bold mb-4" style="font-size: 0.85rem;"><i class="bi bi-patch-check-fill me-1"></i><%= currentUser.getRole() %></span>
                    
                    <div class="text-start mt-3 px-3">
                        <div class="mb-3">
                            <div class="info-label"><i class="bi bi-person me-1"></i> Account Username</div>
                            <div class="info-value"><%= currentUser.getUsername() %></div>
                        </div>
                        <div class="mb-4">
                            <div class="info-label"><i class="bi bi-envelope me-1"></i> Email Address</div>
                            <div class="info-value"><%= currentUser.getEmail() %></div>
                        </div>
                    </div>
                    
                    <div class="d-flex gap-3 justify-content-center mt-4 px-3">
                        <a href="admin_dashboard.jsp" class="btn btn-outline-secondary rounded-3 px-4 fw-semibold py-2">
                            <i class="bi bi-arrow-left-circle me-1"></i> Back to Admin Panel
                        </a>
                        
                        <a href="edit_profile.jsp" class="btn btn-blue-primary rounded-3 px-4 py-2">
                            <i class="bi bi-pencil-square me-1"></i> Edit Profile
                        </a>
                    </div>
                </div>

            </div>
        </div>
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>