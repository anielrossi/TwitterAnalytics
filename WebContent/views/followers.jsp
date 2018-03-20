<%@page import="twitter4j.RateLimitStatus"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="twitter4j.TwitterException"%>
<%@ page import="twitter4j.User"%>
<%@ page import="twitter4j.TwitterFactory"%>
<%@ page import="twitter4j.Twitter"%>
<%@ page import="java.util.*" %>
	
<%	
	List<User> myFollowers = new ArrayList<User>();
	long cursor = -1;
	long userId =(long) request.getSession().getAttribute("userId");
	Twitter twitter =(Twitter) request.getSession().getAttribute("twitter");	
	
	
	
	if (request.getSession().getAttribute("myFollowers") == null){
		try {
			myFollowers = twitter.getFollowersList(userId, cursor, 20);
		}
		catch (TwitterException twitterException) {
			if (twitterException.getErrorCode() == 88){
				twitterException.printStackTrace();
				response.sendRedirect("errorlimit.jsp");
				return;
			}
			else {
				twitterException.printStackTrace();		
			}
		}
	}
	
	else {
		myFollowers = (List<User>) request.getSession().getAttribute("myFollowers");
	}
	
	int size = myFollowers.size();	
%>
	   
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Followers</title>
	<link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
	<link rel="stylesheet" href="../css/style.css" type="text/css">
	
	<script type="text/javascript">
		function validateForm(){
			var bool = false;
			var checkbox = document.getElementsByName("parameter");
			
			for (var i = 0; i < checkbox.length; i++){
				if (checkbox[i].checked)
					bool = true;
				}
			
			if (bool == false){
				alert("Seleziona almeno 1 tra i tuoi followers!");
				return false;
			}
				return true;
		}
	</script>
	
</head>
<body>
	<form id = "followers" action="../ProcessFof" method="POST">
		<div class="page-header">
  			<h1 class="text-center title">Followers</h1>
		</div>
	
		<div class="checkbox">		
			<% 
		
			for(int i = 0; i < size ; i++) { %>				
				
				<%if(myFollowers.get(i).isProtected()){ %>
				<label>
					<input type="checkbox" disabled="disabled" name="parameter" value =<%=myFollowers.get(i).getScreenName()%>> <%=myFollowers.get(i).getName() %>
					<span style = "color:#3598ae; font-style: italic; font-size: 13px; "> (<%=myFollowers.get(i).getFollowersCount() %> followers) </span>
					<span style = "color:#006600; font-style: oblique; font-size: 13px;">private</span>
				</label>
				<br>
				<%}
				else{
				%>
				<label>
					<input type="checkbox" name="parameter" value =<%=myFollowers.get(i).getScreenName()%>> <%=myFollowers.get(i).getName() %>
					<span style = "color:#3598ae; font-style: italic; font-size: 13px; "> (<%=myFollowers.get(i).getFollowersCount() %> followers) </span>
					<span style = "color:#006600; font-style: oblique; font-size: 13px;"></span>
				</label>
				<br>
				
				<%	}
				}
				%>
				
				</div>
			<% request.getSession().setAttribute("myFollowers", myFollowers); %>
			<br>
		
			<input class="btn btn-info" id="button" type="submit" value="Get Followers of Followers"   onClick="return validateForm()" >			
			<div class="btn btn-danger text-right" > Remaining Requests: <%= twitter.getRateLimitStatus().get("/followers/list").getRemaining() %> </div>
			<a class="btn btn-warning" href="redirect.jsp"> Back to your profile </a>
	</form>
	<br>
	
	
</body>
</html>