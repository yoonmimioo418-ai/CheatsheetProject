<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.servlet.model.User, com.servlet.model.Category, com.servlet.model.Cheatsheet, com.servlet.repository.UserRepository, com.servlet.repository.CategoryRepository, com.servlet.repository.AdminRepository, com.servlet.repository.CheatsheetRepository"%>

<%
    // Security Check: Login မဝင်ထားရင် login.jsp ကို ပြန်လွှတ်မယ်
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Repositories များကို အပေါ်ဆုံးမှာ ကြေညာပေးရမယ်
    AdminRepository adminRepo = new AdminRepository();
    CategoryRepository repo = new CategoryRepository();
    UserRepository userRepo = new UserRepository();
    CheatsheetRepository cheatsheetRepo = new CheatsheetRepository();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - DevCheat Central</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f7fc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #495057; }
        
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
        .sidebar a.text-danger:hover { background: rgba(220, 53, 69, 0.2) !important; color: #ffffff !important; }
        
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05); overflow: hidden; background: white; }
        
        .bg-blue-1 { background: linear-gradient(45deg, #4facfe 0%, #00f2fe 100%) !important; }
        .bg-blue-2 { background: linear-gradient(45deg, #2575fc 0%, #6a11cb 100%) !important; }
        .bg-blue-3 { background: linear-gradient(45deg, #13f1fc 0%, #0470dc 100%) !important; }
        
        .table-blue-hdr { background-color: #e6f0fa !important; color: #224abe !important; font-weight: 600; }
        .btn-blue-primary { background-color: #4e73df; color: white; border: none; font-weight: 600; border-radius: 8px; transition: 0.3s; }
        .btn-blue-primary:hover { background-color: #224abe; color: white; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(78,115,223,0.3); }
        
        .form-control { border-radius: 8px; border: 1px solid #ced4da; padding: 10px 15px; }
        .form-control:focus { border-color: #4e73df; box-shadow: 0 0 0 0.25rem rgba(78,115,223,0.25); }
        
        .table > :not(caption) > * > * { padding: 15px 20px; }
        h3 { font-weight: 700; color: #2c3e50; }
        .text-truncate-custom { max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        
        <div class="col-md-2 sidebar shadow">
            <h4 class="text-center"><i class="bi bi-shield-lock-fill me-2"></i>Admin Panel</h4>
            <hr class="mx-3 opacity-25 text-white">
            
            <a href="admin_dashboard.jsp?view=users" class="<%= "users".equals(request.getParameter("view")) || request.getParameter("view") == null ? "active" : "" %>">
                <i class="bi bi-people-fill"></i> Manage Users
            </a>
            
            <a href="admin_dashboard.jsp?view=cheatsheets" class="<%= "cheatsheets".equals(request.getParameter("view")) ? "active" : "" %>">
                <i class="bi bi-file-earmark-code-fill"></i> Manage Cheatsheets
            </a>
            
            <a href="admin_dashboard.jsp?view=categories" class="<%= "categories".equals(request.getParameter("view")) ? "active" : "" %>">
                <i class="bi bi-tags-fill"></i> Manage Categories
            </a>
            
            <a href="admin_dashboard.jsp?view=recycle_bin" class="<%= "recycle_bin".equals(request.getParameter("view")) ? "active" : "" %>">
                <i class="bi bi-trash-fill"></i> Recycle Bin
            </a>
            
            <a href="admin_profile.jsp">
                <i class="bi bi-person-bounding-box"></i> Admin Profile
            </a>
            
            <hr class="mx-3 opacity-25 text-white mt-4">
            <a href="logout" class="text-danger"><i class="bi bi-box-arrow-left"></i> Logout Account</a>
        </div>

        <div class="col-md-10 p-5">
            
            <div class="row mb-5">
                <div class="col-md-4">
                    <div class="card bg-blue-1 text-white shadow-sm">
                        <div class="card-body py-4 d-flex justify-content-between align-items-center">
                            <div><h6 class="opacity-75 fw-medium">Total Users</h6><h1 class="mb-0 fw-bold"><%= adminRepo.getTotalUsers() %></h1></div>
                            <i class="bi bi-people-fill fs-1 opacity-25"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card bg-blue-2 text-white shadow-sm">
                        <div class="card-body py-4 d-flex justify-content-between align-items-center">
                            <div><h6 class="opacity-75 fw-medium">Total Categories</h6><h1 class="mb-0 fw-bold"><%= adminRepo.getTotalCategories() %></h1></div>
                            <i class="bi bi-tags-fill fs-1 opacity-25"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <a href="admin_dashboard.jsp?view=cheatsheets" class="text-decoration-none">
                        <div class="card bg-blue-3 text-white shadow-sm">
                            <div class="card-body py-4 d-flex justify-content-between align-items-center">
                                <div><h6 class="opacity-75 fw-medium">Total Cheatsheets</h6><h1 class="mb-0 fw-bold"><%= adminRepo.getTotalCheatsheets() %></h1></div>
                                <i class="bi bi-file-code-fill fs-1 opacity-25"></i>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

            <%
                String view = request.getParameter("view");
                
                // ==========================================
                // 1. USER MANAGEMENT SECTION
                // ==========================================
                if (view == null || view.equals("users")) {
            %>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3><i class="bi bi-people text-primary me-2"></i>User Management</h3>
                    <form action="admin_dashboard.jsp" method="get" class="d-flex" style="max-width: 350px; width: 100%;">
                        <input type="hidden" name="view" value="users">
                        <div class="input-group">
                            <input type="text" name="userSearch" class="form-control" placeholder="Search user by name..." 
                                   value="<%= request.getParameter("userSearch") != null ? request.getParameter("userSearch") : "" %>">
                            <button type="submit" class="btn btn-blue-primary px-3"><i class="bi bi-search"></i></button>
                        </div>
                    </form>
                </div>
                <div class="card shadow-sm">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr class="table-blue-hdr"><th>#</th><th>Username</th><th>Email</th><th>Role / Status</th><th class="text-center">Actions</th></tr>
                        </thead>
                        <tbody>
                            <%
                                String q = request.getParameter("userSearch");
                                List<User> uList = (q != null && !q.trim().isEmpty()) ? userRepo.searchUsers(q) : userRepo.getAllUsers();
                                int uCount = 1;
                                if (uList != null && !uList.isEmpty()) {
                                    for(User u : uList) {
                            %>
                                <tr>
                                    <td class="fw-bold text-muted"><%= uCount++ %></td>
                                    <td class="fw-bold text-dark"><%= u.getUsername() %></td>
                                    <td><%= u.getEmail() %></td>
                                    
                                    <td>
                                        <% if ("BANNED".equalsIgnoreCase(u.getStatus())) { %>
                                            <span class="badge bg-secondary rounded-pill px-3" title="Reason: <%= u.getBan_reason() != null ? u.getBan_reason() : "" %>">BANNED 🚫</span>
                                        <% } else { %>
                                            <span class="badge <%= "admin".equalsIgnoreCase(u.getRole()) ? "bg-danger" : "bg-primary" %> rounded-pill px-3"><%= u.getRole() %></span>
                                        <% } %>
                                    </td>

                                    <td class="text-center">
                                        <a href="UserServlet?action=changeRole&id=<%= u.getId() %>&currentRole=<%= u.getRole() %>" 
                                           class="btn btn-sm btn-outline-success border-0 me-1"
                                           onclick="return confirm('<%= u.getUsername() %> ရဲ့ Role ကို ပြောင်းလဲမှာ သေချာပါသလား?')">
                                           <i class="bi bi-person-up fs-5"></i> Toggle Role
                                        </a>

                                        <% if (!"BANNED".equalsIgnoreCase(u.getStatus())) { %>
                                            <button class="btn btn-sm btn-outline-danger border-0" 
                                                    onclick="banUserPrompt(<%= u.getId() %>, '<%= u.getUsername() %>')">
                                                <i class="bi bi-slash-circle-fill fs-5"></i> Ban User
                                            </button>
                                        <% } else { %>
                                            <a href="UserServlet?action=activate&id=<%= u.getId() %>" 
                                               class="btn btn-sm btn-outline-primary border-0"
                                               onclick="return confirm('<%= u.getUsername() %> ကို အသုံးပြုခွင့် ပြန်ပေးမှာ သေချာပါသလား?');">
                                                <i class="bi bi-check-circle-fill fs-5"></i> Unban User
                                            </a>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr><td colspan="5" class="text-center text-muted py-4">No users found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            <% 
                // ==========================================
                // 2. CHEATSHEETS MANAGEMENT SECTION
                // ==========================================
                } else if (view.equals("cheatsheets")) { 
            %>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3><i class="bi bi-file-earmark-code text-primary me-2"></i>Cheatsheets Management</h3>
                </div>
                <div class="card shadow-sm">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr class="table-blue-hdr">
                                <th>#</th>
                                <th>Title</th>
                                <th>Content</th>
                                <th>Category</th>
                                <th>Created By</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Cheatsheet> allSheets = cheatsheetRepo.findAllWithUser();
                                int sheetCount = 1; 
                                
                                if (allSheets != null && !allSheets.isEmpty()) {
                                    for(Cheatsheet cs : allSheets) {
                            %>
                                <tr>
                                    <td class="fw-bold text-muted">#<%= sheetCount++ %></td> 
                                    <td class="fw-bold text-dark"><%= cs.getTitle() %></td>
                                    <td><p class="text-muted small mb-0 text-truncate-custom"><%= cs.getContent() %></p></td>
                                    <td><span class="badge bg-primary rounded-pill px-3"><%= cs.getCategoryName() %></span></td>
                                    <td><span class="text-secondary fw-semibold"><i class="bi bi-person me-1"></i><%= cs.getUsername() %></span></td>
                                    <td class="text-center">
                                        <a href="CheatsheetServlet?action=delete&id=<%= cs.getId() %>" 
                                           class="btn btn-sm btn-outline-danger border-0" 
                                           onclick="return confirm('ဤ Cheatsheet ကို စနစ်ထဲမှ အပြီးဖျက်ရန် သေချာပါသလား?');">
                                            <i class="bi bi-trash3-fill fs-5"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% 
                                    } 
                                } else { 
                            %>
                                <tr><td colspan="6" class="text-center text-muted py-4">No cheatsheets found in the system.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            <% 
                // ==========================================
                // 3. CATEGORY MANAGEMENT SECTION
                // ==========================================
                } else if (view.equals("categories")) { 
            %>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3><i class="bi bi-tags text-primary me-2"></i>Manage Categories</h3>
                    
                    <div class="d-flex gap-3">
                        <form action="CategoryServlet" method="post" class="d-flex align-items-center bg-white p-2 rounded-3 shadow-sm border">
                            <input type="hidden" name="action" value="add">
                            <input type="text" name="categoryName" class="form-control form-control-sm border-0" placeholder="New Category Name" required style="box-shadow: none;">
                            <button type="submit" class="btn btn-sm btn-blue-primary px-3 rounded-2">Add</button>
                        </form>
                        
                        <form action="admin_dashboard.jsp" method="get" class="d-flex">
                            <input type="hidden" name="view" value="categories">
                            <div class="input-group">
                                <input type="text" name="categoriesSearch" class="form-control" placeholder="Search categories..." 
                                       value="<%= request.getParameter("categoriesSearch") != null ? request.getParameter("categoriesSearch") : "" %>">
                                <button type="submit" class="btn btn-blue-primary"><i class="bi bi-search"></i></button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="card shadow-sm">
                    <table class="table table-hover align-middle mb-0">
                        <thead><tr class="table-blue-hdr"><th>#</th><th>Category Name</th><th class="text-center">Actions</th></tr></thead>
                        <tbody>
                            <%
                                List<Category> list = repo.findAll();
                                int cCount = 1;
                                for (Category cat : list) {
                            %>
                            <tr>
                                <td class="fw-bold text-muted"><%= cCount++ %></td>
                                <td class="fw-bold text-dark"><%= cat.getName() %></td>
                                <td class="text-center">
                                    <a href="edit_category.jsp?id=<%= cat.getId() %>" class="btn btn-sm btn-outline-warning border-0 me-2"><i class="bi bi-pencil-square fs-5"></i></a>
                                    <a href="CategoryServlet?action=delete&id=<%= cat.getId() %>" class="btn btn-sm btn-outline-danger border-0" onclick="return confirm('ဖျက်မှာလား?')"><i class="bi bi-trash3-fill fs-5"></i></a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            <% 
                // ==========================================
                // 4. RECYCLE BIN SECTION
                // ==========================================
                } else if (view.equals("recycle_bin")) { 
            %>
                <div class="mb-4">
                    <h3><i class="bi bi-trash text-danger me-2"></i>Recycle Bin</h3>
                    <p class="text-muted small">Restore Category </p>
                </div>
                <div class="card shadow-sm border border-danger-subtle">
                    <table class="table table-hover align-middle mb-0">
                        <thead><tr class="table-danger text-danger"><th>#</th><th>Category Name</th><th class="text-center">Actions</th></tr></thead>
                        <tbody>
                            <%
                                List<Category> deletedList = repo.findAllDeleted();
                                int dCount = 1;
                                if (!deletedList.isEmpty()) {
                                    for (Category cat : deletedList) {
                            %>
                            <tr>
                                <td class="fw-bold text-muted"><%= dCount++ %></td>
                                <td class="fw-bold text-muted text-decoration-line-through"><%= cat.getName() %></td>
                                <td class="text-center">
                                    <a href="CategoryServlet?action=restore&id=<%= cat.getId() %>" class="btn btn-sm btn-success rounded-2 px-3 me-2"><i class="bi bi-arrow-counterclockwise me-1"></i>Restore</a>
                                    <a href="CategoryServlet?action=perm_delete&id=<%= cat.getId() %>" class="btn btn-sm btn-danger rounded-2 px-3" onclick="return confirm('အပြီးတိုင် ဖျက်မှာလား?')"><i class="bi bi-x-circle me-1"></i>Delete Permanently</a>
                                </td>
                            </tr>
                            <% } } else { %>
                                <tr><td colspan="3" class="text-center text-muted py-5"><i class="bi bi-trash2 display-4 opacity-25 d-block mb-2"></i>Recycle bin is completely empty.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
function banUserPrompt(userId, username) {
    let reason = prompt("Why did"+username + " get banned?");
    if (reason === null) return; 
    
    if (reason.trim() === "") {
        alert("A reason is required to ban the account!");
        return;
    }
    window.location.href = "UserServlet?action=banUser&id=" + userId + "&banReason=" + encodeURIComponent(reason);
}
</script>
</body>
</html>