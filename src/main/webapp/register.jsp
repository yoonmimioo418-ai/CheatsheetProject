<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - DevCheat Central</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .register-card { max-width: 450px; margin: 60px auto; border-radius: 12px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .btn-primary { background-color: #4e73df; border: none; padding: 10px; }
    </style>
</head>
<body>

<div class="container">
    <div class="card register-card">
        <div class="card-body p-5">
            <h3 class="text-center fw-bold mb-4">Create Account</h3>

            <%-- Success/Error Messages --%>
            <% String status = request.getParameter("status"); 
               if("fail".equals(status)) { %>
                <div class="alert alert-danger text-center py-2">Registration Failed. Email might exist!</div>
            <% } else if("mismatch".equals(status)) { %>
                <div class="alert alert-warning text-center py-2">Passwords do not match!</div>
            <% } %>

            <form action="register" method="post" id="regForm">
                <div class="mb-3">
                    <label class="form-label small fw-bold">Username</label>
                    <input type="text" name="username" class="form-control" placeholder="Name" required>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold">Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold">Password</label>
                    <input type="password" name="password" id="password" class="form-control" required>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-bold">Confirm Password</label>
                    <input type="password" name="confirm_password" id="confirm_password" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-3 shadow-sm">Register Now</button>
                
                <div class="text-center">
                    <span class="small text-muted">Already have an account? <a href="index.jsp" class="text-decoration-none">Go Back To Home</a></span>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.getElementById('regForm').addEventListener('submit', function(e) {
        const pass = document.getElementById('password').value;
        const confirm = document.getElementById('confirm_password').value;
        if (pass !== confirm) {
            e.preventDefault();
            alert("Passwords do not match!");
        }
    });
</script>
</body>
</html>