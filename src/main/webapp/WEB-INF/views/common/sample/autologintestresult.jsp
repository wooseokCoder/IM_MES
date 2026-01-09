<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Auto Login Test Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 50px;
            background-color: #f5f5f5;
        }
        .result-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .result-title {
            color: #002658;
            border-bottom: 2px solid #002658;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .result-item {
            margin: 15px 0;
            padding: 10px;
            background-color: #f9f9f9;
            border-left: 4px solid #002658;
        }
        .result-success {
            color: #28a745;
            font-weight: bold;
            font-size: 18px;
        }
        .result-fail {
            color: #dc3545;
            font-weight: bold;
            font-size: 18px;
        }
        .back-button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #002658;
            color: white;
            text-decoration: none;
            border-radius: 3px;
        }
        .back-button:hover {
            background-color: #003d7a;
        }
    </style>
</head>
<body>
    <div class="result-container">
        <h1 class="result-title">Auto Login Test Result</h1>
        
        <div class="result-item">
            <strong>User ID:</strong> ${ssoUserId}
        </div>
        
        <div class="result-item">
            <strong>Token Validation Result:</strong> 
            <c:choose>
                <c:when test="${token == 'Y'}">
                    <span class="result-success">Success</span>
                </c:when>
                <c:otherwise>
                    <span class="result-fail">Failed</span>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="result-item">
            <strong>Message:</strong> ${message}
        </div>
        
        <c:if test="${not empty tempId}">
            <div class="result-item">
                <strong>TEMP_ID:</strong> ${tempId}
            </div>
        </c:if>
        
        <a href="javascript:history.back()" class="back-button">Back</a>
    </div>
</body>
</html>
