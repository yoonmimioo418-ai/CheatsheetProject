<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.servlet.model.*, com.servlet.repository.*" %>

<%
    // ၁။ Admin ထည့်ထားတဲ့ Category list ကို Database ကနေ ဆွဲထုတ်မယ်
    CategoryRepository catRepo = new CategoryRepository();
    List<Category> categoryList = null;
    try {
        categoryList = catRepo.findAll();
    } catch(Exception e) {
        e.printStackTrace();
    }
    
    // ၂။ Public User တွေအကုန်လုံး မြင်တွေ့နိုင်ဖို့ ရှိသမျှ Cheatsheet အားလုံးကို ဆွဲထုတ်ခြင်း
    CheatsheetRepository sheetRepo = new CheatsheetRepository();
    List<Cheatsheet> allSheets = null;
    try {
        allSheets = sheetRepo.findAll(); // Favorite Count တွက်ပြီးသား မက်သတ်
    } catch(Exception e) {
        e.printStackTrace();
    }
    
    User user = (User) session.getAttribute("currentUser");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DevCheat Central</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        
        /* Navbar Custom Style */
        .navbar { background-color: #ffffff; border-bottom: 1px solid #ddd; }
        .navbar-brand { font-weight: 800; color: #1877f2 !important; }

        /* Hero Section Blue Gradient */
        .hero-section {
            background: linear-gradient(135deg, #1877f2 0%, #0056b3 100%);
            padding: 80px 0;
            color: white;
            margin-bottom: -50px;
        }

        /* Search Pill Style */
        .search-pill {
            border-radius: 50px;
            padding: 12px 25px;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        /* FB Style Card */
        .fb-card {
            border: none;
            border-radius: 12px;
            transition: 0.2s;
            overflow: hidden;
        }
        .fb-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
        
        .category-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #212529;
        }

        /* Cheatsheet Box Feed Style (FB Newsfeed Style) */
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

    <!-- Navbar Section -->
    <nav class="navbar navbar-expand-lg sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="index.jsp"><i class="bi bi-code-square me-2"></i>DEVCHEAT</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <% if (user == null) { %>
                        <li class="nav-item">
                            <a class="nav-link fw-bold text-dark me-3" href="login.jsp">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary rounded-pill px-4" href="register.jsp">Register</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle fw-bold text-dark" href="#" data-bs-toggle="dropdown">
                                <img src="https://ui-avatars.com/api/?name=<%= user.getUsername() %>&background=1877f2&color=fff" class="rounded-circle me-1" width="30" height="30">
                                <%= user.getUsername() %>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                                <li>
                                    <a class="dropdown-item" href="<%= "admin".equalsIgnoreCase(user.getRole()) ? "admin_dashboard.jsp" : "dashboard.jsp" %>">Dashboard</a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="logout">Logout</a></li>
                            </ul>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section text-center">
        <div class="container">
            <h1 class="fw-bold">Explore Technologies</h1>
            <p class="lead">Discover, learn, and share developer cheatsheets instantly.</p>
            
            <div class="row justify-content-center mt-4">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-0 ps-4 rounded-start-pill">
                            <i class="bi bi-search text-primary"></i>
                        </span>
                        <input type="text" id="mainSearch" class="form-control search-pill rounded-start-0" 
                               placeholder="Search categories..." onkeyup="filterCategories()">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Category Section -->
    <div class="container mt-5 pt-5">
        <h3 class="fw-bold text-dark mb-4"><i class="bi bi-grid-3x3-gap text-primary me-2"></i>Browse by Categories</h3>
        <div class="row g-4" id="cardsGrid">
            <% if (categoryList != null && !categoryList.isEmpty()) { 
                for(Category cat : categoryList) { %>
                
                <div class="col-6 col-md-4 col-lg-3 category-item">
                    <div class="card h-100 fb-card shadow-sm">
                        <div class="card-body text-center p-4">
                            <i class="bi bi-folder2-open text-primary fs-1 mb-3 d-block"></i>
                            <h6 class="category-name d-none"><%= cat.getName() %></h6>
                            <h6 class="fw-bold category-title mt-2"><%= cat.getName() %></h6>
                            <p class="text-muted small mb-0">Learn <%= cat.getName() %> cheats</p>
                        </div>
                        <div class="card-footer bg-white border-0 pb-4 px-4">
                           <a href="category_view.jsp?id=<%= cat.getId() %>&category=<%= cat.getName() %>" class="btn btn-outline-primary btn-sm rounded-pill mt-2 w-100">
                                View Cheatsheets
                            </a>
                        </div>
                    </div>
                </div>
                
            <% } } else { %>
                <div class="col-12 text-center text-muted py-5">No categories found. Admin has not added any categories yet.</div>
            <% } %>
        </div>
    </div>

    <hr class="container my-5" style="border-top: 2px dashed #ddd;">

    <!-- 🛠️ ပြည်သူလူထုအားလုံးအတွက် Cheatsheets အားလုံးကို စုပြပေးမည့် Feed Section 🛠️ -->
    <div class="container mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <h3 class="fw-bold text-dark mb-4"><i class="bi bi-globe2 text-success me-2"></i>Recent Community Cheatsheets</h3>
                
                <% 
                    if (allSheets != null && !allSheets.isEmpty()) {
                        for(Cheatsheet sheet : allSheets) { 
                %>
                    <div class="custom-main-box shadow-sm bg-white">
                        
                        <!-- Top Header Box -->
                        <div class="p-3 d-flex align-items-center justify-content-between border-bottom">
                            <div class="d-flex align-items-center">
                                <img src="https://ui-avatars.com/api/?name=<%= sheet.getUsername() != null ? sheet.getUsername() : "User" %>&background=random" class="rounded-circle me-2" width="35" height="35">
                                <div>
                                    <strong class="text-dark d-block"><%= sheet.getUsername() != null ? sheet.getUsername() : "Anonymous" %></strong>
                                    <span class="badge bg-secondary" style="font-size: 0.7rem;"><%= sheet.getCategoryName() != null ? sheet.getCategoryName() : "General" %></span>
                                </div>
                            </div>
                            
                            <!-- အသေးစိတ်ဝင်ဖတ်ရန် ခလုတ် -->
                            <a href="CheatsheetServlet?action=view&id=<%= sheet.getId() %>" class="btn btn-light btn-sm rounded-pill text-primary fw-bold border">
                                <i class="bi bi-eye me-1"></i>View Details
                            </a>
                        </div>

                        <!-- Content Code Snippet Box -->
                        <div class="p-4 bg-light border-bottom text-center">
                            <h5 class="fw-bold text-dark mb-2"><%= sheet.getTitle() %></h5>
                            <p class="text-secondary small mb-0 text-truncate w-100" style="max-height: 50px;"><%= sheet.getContent() %></p>
                        </div>

                        <!-- Like/Favorite Statistics Bar -->
                        <div class="p-2 px-3 bg-white d-flex align-items-center justify-content-between text-muted small">
                            <div>
                                <i class="bi bi-heart-fill text-danger me-1"></i> <%= sheet.getFavCount() %> People favorited
                            </div>
                            <div>
                                <i class="bi bi-chat-square-text me-1"></i> Click detail to comment
                            </div>
                        </div>

                    </div>
                <% 
                        }
                    } else { 
                %>
                    <div class="text-center py-5 text-muted bg-white rounded-3 border">
                        <i class="bi bi-journal-x fs-2 d-block mb-2"></i>
                        <span>No cheatsheets available in the system yet.</span>
                    </div>
                <% } %>
                
            </div>
        </div>
    </div>

    <!-- JavaScript Filter for Live Search -->
    <script>
        function filterCategories() {
            let input = document.getElementById('mainSearch').value.toLowerCase();
            let cards = document.querySelectorAll('.category-item');
            cards.forEach(card => {
                let catTitle = card.querySelector('.category-title').innerText.toLowerCase();
                card.style.display = (catTitle.includes(input)) ? "" : "none";
            });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>