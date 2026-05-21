<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<head>
    <meta charset="UTF-8">
    <title>Edit Cheatsheet</title>
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f7f6;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .form-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 500px;
        }

        h2 {
            margin-top: 0;
            color: #333;
            font-size: 24px;
            text-align: center;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
            font-size: 14px;
        }

        input[type="text"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box; /* padding ကြောင့် width မပြောင်းအောင် */
            font-size: 15px;
            transition: border-color 0.3s ease;
            outline: none;
            background-color: #fafafa;
        }

        input[type="text"]:focus,
        select:focus,
        textarea:focus {
            border-color: #4A90E2;
            background-color: #fff;
        }

        textarea {
            resize: vertical;
            min-height: 120px;
        }

        .btn-update {
            width: 100%;
            background-color: #4A90E2;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 10px;
        }

        .btn-update:hover {
            background-color: #357ABD;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #888;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link:hover {
            color: #4A90E2;
        }
    </style>
</head>
</head>
<body>
    <div class="form-container">
        <h2>Edit Cheatsheet</h2>
        <form action="CheatsheetServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${cs.id}"> 

            <div class="form-group">
                <label>Title</label>
                <input type="text" name="title" value="${cs.title}" placeholder="Enter title" required>
            </div>

           <!-- JSP ထိပ်မှာ JSTL taglib ကို ထည့်ဖို့ မမေ့ပါနဲ့ -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="mb-3">
    <label class="form-label">Category</label>
    <select name="categoryId" class="form-select" required>
        <option value="">-- Select Category --</option>
        
        <c:forEach var="cat" items="${categories}">
            <!-- Edit လုပ်တဲ့အချိန်မှာ လက်ရှိ category ကို selected ဖြစ်အောင် လုပ်ပေးထားပါတယ် -->
            <option value="${cat.id}" ${cs != null && cs.categoryId == cat.id ? 'selected' : ''}>
                ${cat.name}
            </option>
        </c:forEach>
    </select>
</div>

            <div class="form-group">
                <label>Content</label>
                <textarea name="content" placeholder="Write your cheat code here..." required>${cs.content}</textarea>
            </div>
            
            <button type="submit" class="btn-update">Update Cheatsheet</button>
            <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
        </form>
    </div>
</body>
</html>