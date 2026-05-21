<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - DevCheat Central</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
    :root {
        --pale-blue-bg: #f0f7ff;
        --soft-blue: #e3f2fd;
        --border-blue: #bbdefb;
        --accent-blue: #2196f3;
        --dark-blue: #1565c0;
    }

    body { 
        background-color: var(--pale-blue-bg); 
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        height: 100vh;
        display: flex;
        align-items: center;
    }

    .login-card { 
        max-width: 420px; 
        width: 100%;
        margin: auto; 
        border: none;
        border-radius: 20px; 
        background: #ffffff;
        box-shadow: 0 10px 25px rgba(33, 150, 243, 0.1); 
    }

    .card-header-blue {
        background-color: var(--soft-blue);
        border-radius: 20px 20px 0 0 !important;
        padding: 25px;
        text-align: center;
        border-bottom: 1px solid var(--border-blue);
    }

    .card-header-blue h3 {
        color: var(--dark-blue);
        font-weight: 700;
        margin: 0;
    }

    .form-control {
        border-radius: 10px;
        border: 1px solid var(--border-blue);
        padding: 12px;
    }

    .form-control:focus {
        box-shadow: 0 0 0 0.25rem rgba(33, 150, 243, 0.1);
        border-color: var(--accent-blue);
    }

    .btn-login { 
        background-color: var(--accent-blue); 
        color: white; 
        width: 100%; 
        border-radius: 10px;
        padding: 12px;
        font-weight: 600;
        border: none;
        transition: all 0.3s ease;
    }

    .btn-login:hover { 
        background-color: var(--dark-blue); 
        color: white;
        transform: translateY(-2px);
    }

    .input-group-text {
        background-color: var(--soft-blue);
        border: 1px solid var(--border-blue);
        color: var(--accent-blue);
    }
</style>
</head>
<body>

<div class="container">
    <div class="card login-card">
        <div class="card-header-blue">
            <h3><i class="bi bi-person-circle"></i> Login</h3>
            <p class="text-muted mb-0 small">Please enter your credentials</p>
        </div>
        
        <div class="card-body p-4">
            
            <%-- Error Messages --%>
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2 text-center" style="font-size: 13px; border-radius: 10px;">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="LoginServlet" method="post">
                
                <div class="mb-3">
                    <label class="form-label text-secondary small fw-bold">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" name="email" class="form-control" placeholder="example@mail.com" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label text-secondary small fw-bold">Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-login shadow-sm">
                    Sign In
                </button>
                
                <% 
    if ("banned".equals(request.getParameter("msg"))) { 
        String reason = request.getParameter("reason");
%>
    <div class="alert alert-danger" role="alert">
        <i class="bi bi-slash-circle-fill me-2"></i>
        Your account has been banned! <br>
        <strong>Reason:</strong> <%= reason != null ? reason : "Because of a policy violation" %>
    </div>
<% } %>
                
                <div class="text-center mt-4">
                    <p class="mb-0 small text-muted">Go back to 
                        <a href="index.jsp" class="text-decoration-none fw-bold" style="color: var(--accent-blue);">Home</a>
                    </p>
                </div>

            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>