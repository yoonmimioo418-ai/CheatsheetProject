<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List, java.util.ArrayList, com.servlet.model.User, com.servlet.model.Cheatsheet, com.servlet.repository.CheatsheetRepository" %>



<%

// ၁။ Security Check & Data Fetching

User currentUser = (User) session.getAttribute("currentUser");

if (currentUser == null) {

response.sendRedirect("login.jsp");

return;

}



CheatsheetRepository dashboardRepo = new CheatsheetRepository();

List<Cheatsheet> userSheets = new ArrayList<>();

List<Cheatsheet> favSheets = new ArrayList<>();


try {

// ကိုယ်ပိုင်တင်ထားတဲ့ Cheatsheet စာရင်းကို ယူတယ်

userSheets = dashboardRepo.findByUserId(currentUser.getId());


// 💡 ကိုယ်တကယ် အသည်းပေး (Save) ထားတဲ့ စာရင်းကိုပဲ သီးသန့်ယူတယ်

favSheets = dashboardRepo.findFavouritesByUserId(currentUser.getId());

} catch(Exception e) {

e.printStackTrace();

}

%>



<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Dashboard - <%= currentUser.getUsername() %></title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<style>

body { background-color: #f0f2f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }


/* Card Hover Effect */

.fb-card {

transition: all 0.2s ease;

cursor: pointer;

border: 1px solid rgba(0,0,0,0.1) !important;

}

.fb-card:hover {

filter: brightness(0.95);

transform: scale(0.98);

}


.cheatsheet-section { min-height: 400px; }


.profile-img {

object-fit: cover;

border: 4px solid white;

}



.dropdown-toggle::after { display: none; }

.text-truncate { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

</style>

</head>

<body>



<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">

<div class="container">

<a class="navbar-brand fw-bold" href="dashboard.jsp"><i class="bi bi-code-square me-2"></i>DevCheat</a>

<div class="d-flex align-items-center">


<a href="logout" class="btn btn-danger btn-sm rounded-pill px-3">Logout</a>

</div>

</div>

</nav>



<div class="container mt-4 mb-5">


<div class="profile-header bg-white rounded-4 shadow-sm p-4 mb-4 text-center">

<div class="position-relative d-inline-block">

<img src="https://ui-avatars.com/api/?name=<%= currentUser.getUsername() %>&background=4facfe&color=fff&size=128"

class="rounded-circle profile-img shadow-sm" width="120" height="120">

</div>

<h2 class="fw-bold mt-3 mb-1"><%= currentUser.getUsername() %></h2>


<p class="text-muted">

<%= (currentUser.getBio() != null && !currentUser.getBio().isEmpty()) ? currentUser.getBio() : "No bio added yet." %>

</p>


<div class="d-flex justify-content-center gap-2 mt-3">

<a href="CheatsheetServlet?action=add_page" class="btn btn-primary rounded-3 px-4 fw-bold">

<i class="bi bi-plus-lg me-1"></i> Add Cheatsheet

</a>

<a href="ProfileServlet" class="btn btn-light border rounded-3 px-4 fw-bold">Edit Profile</a>

</div>

</div>



<div class="cheatsheet-section bg-white rounded-4 shadow-sm p-4">


<ul class="nav nav-tabs mb-4" id="dashboardTabs" role="tablist">

<li class="nav-item" role="presentation">

<button class="nav-link active fw-bold" id="my-sheets-tab" data-bs-toggle="tab" data-bs-target="#my-sheets-pane" type="button" role="tab">

<i class="bi bi-file-earmark-code me-1"></i> My Cheatsheets (<%= userSheets != null ? userSheets.size() : 0 %>)

</button>

</li>

<li class="nav-item" role="presentation">

<button class="nav-link fw-bold text-danger" id="fav-sheets-tab" data-bs-toggle="tab" data-bs-target="#fav-sheets-pane" type="button" role="tab">

<i class="bi bi-heart-fill me-1"></i> Saved Favourites (<%= favSheets != null ? favSheets.size() : 0 %>)

</button>

</li>

</ul>



<div class="tab-content" id="dashboardTabsContent">


<div class="tab-pane fade show active" id="my-sheets-pane" role="tabpanel">

<div class="row g-3">

<%

if (userSheets != null && !userSheets.isEmpty()) {

for(Cheatsheet myCs : userSheets) {

%>

<div class="col-6 col-md-4 col-lg-3">

<div class="position-relative">


<a href="CheatsheetServlet?action=view&id=<%= myCs.getCategoryId()%>&category=<%= myCs.getCategoryName() %> " class="text-decoration-none">

<div class="card h-100 border-0 rounded-3 text-center fb-card shadow-sm">

<div class="card-body p-3 d-flex flex-column align-items-center justify-content-center" style="min-height: 160px; background-color: #f0f2f5;">

<i class="bi bi-file-earmark-code display-6 text-primary mb-2"></i>


<h6 class="fw-bold text-dark mb-1 text-truncate w-100">

<%= myCs.getCategoryName() != null ? myCs.getCategoryName() : "General" %>

</h6>


<span class="text-muted text-truncate w-100 mb-2" style="font-size: 0.75rem;"><%= myCs.getTitle() %></span>


<div class="text-danger small mt-1" style="font-size: 0.8rem;">

<i class="bi bi-heart-fill me-1"></i> <%= myCs.getFavCount() %>

</div>

</div>

</div>

</a>


<div class="dropdown position-absolute top-0 end-0 mt-2 me-2">

<button class="btn btn-link text-muted p-0 dropdown-toggle" data-bs-toggle="dropdown">

<i class="bi bi-three-dots"></i>

</button>

<ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3">

<li><a class="dropdown-item py-2" href="CheatsheetServlet?action=edit&id=<%= myCs.getId() %>"><i class="bi bi-pencil-square me-2"></i>Edit</a></li>

<li><hr class="dropdown-divider"></li>

<li><a class="dropdown-item py-2 text-danger" href="CheatsheetServlet?action=delete&id=<%= myCs.getId() %>" onclick="return confirm"><i class="bi bi-trash3 me-2"></i>Delete</a></li>

</ul>

</div>

</div>

</div>

<%

}

} else {

%>

<div class="col-12 text-center py-5">

<i class="bi bi-grid-3x3-gap text-muted display-4"></i>

<p class="text-muted mt-3">No cheatsheets yet. Start creating!</p>

</div>

<% } %>

</div>

</div>


<div class="tab-pane fade" id="fav-sheets-pane" role="tabpanel">

<div class="row g-3">

<%

if (favSheets != null && !favSheets.isEmpty()) {

for(Cheatsheet favCs : favSheets) {

%>

<div class="col-6 col-md-4 col-lg-3">

<a href="view_cheatsheet.jsp?id=<%= favCs.getCategoryId() %>&category=<%= favCs.getCategoryName() %>" class="text-decoration-none">

<div class="card h-100 border-0 rounded-3 text-center fb-card shadow-sm border-start border-danger border-3">

<div class="card-body p-3 d-flex flex-column align-items-center justify-content-center" style="min-height: 160px; background-color: #fdf2f2;">

<i class="bi bi-heart-fill display-6 text-danger mb-2"></i>


<h6 class="fw-bold text-dark mb-1 text-truncate w-100">

<%= favCs.getCategoryName() != null ? favCs.getCategoryName() : "General" %>

</h6>


<span class="text-muted text-truncate w-100 mb-2" style="font-size: 0.75rem;"><%= favCs.getTitle() %></span>


<span class="badge bg-danger rounded-pill px-3 mt-1" style="font-size: 0.7rem;">Saved</span>

</div>

</div>

</a>

</div>

<%

}

} else {

%>

<div class="col-12 text-center py-5">

<i class="bi bi-heart text-muted display-4"></i>

<p class="text-muted mt-3">No favourite cheatsheets saved yet.</p>

</div>

<% } %>

</div>

</div>



</div> </div> </div>



<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html> 