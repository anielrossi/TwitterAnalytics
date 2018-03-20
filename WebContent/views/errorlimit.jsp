<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" isErrorPage = "true"%>
<%@ page import="twitter4j.TwitterException"%>
<%@ page import="twitter4j.User"%>
<%@ page import="twitter4j.TwitterFactory"%>
<%@ page import="twitter4j.Twitter"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        body {
            background-color: #eee;
            font-family: "Open Sans", Calibri, Candara, Arial, sans-serif;
            min-height: 100vh;
        }

        .container {
            max-width: 50rem;
            margin-right: auto;
            margin-left: auto;
            padding: 2rem;
        }

        .mt1 {
            margin-top: 1rem;
        }

        .align-right {
            text-align: right;
        }

        .mouse-pointer {
            cursor: pointer;
        }
    </style>

<title>Insert title here</title>

</head>
<body>
<div class="container">
  <div class="jumbotron">
    <h1>Ops!</h1> 
    <p>It seems that you have reached the rate limit for your requests :( <br>
    	Please wait a few minutes. </p> 
    <br>
   <a href="http://127.0.0.1:8082/TAProject/views/redirect.jsp" class="text-center"> Back to login page </a>
  </div>
  
  
  
</div>

</body>
</html>