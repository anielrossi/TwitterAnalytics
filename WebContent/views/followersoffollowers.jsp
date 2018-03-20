<%@page import="twitter4j.TwitterResponse"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<%@page import="twitter4j.TwitterException"%>
<%@page import="twitter4j.User"%>
<%@page import="twitter4j.TwitterFactory"%>
<%@page import="twitter4j.Twitter"%>
<%@page import="java.util.*" %>

<%! @SuppressWarnings("unchecked") %>  
<% 
	String[] checkedUsers = (String[])request.getSession().getAttribute("checkedUsers");
	List<List<User>> fofList = (ArrayList<List<User>>) request.getSession().getAttribute("fofList");
	List<User> myFollowers = (ArrayList<User>) request.getSession().getAttribute("myFollowers");
	int cursor=-1;
	Twitter twitter = (Twitter) request.getSession().getAttribute("twitter");		
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Followers of followers</title>

   	<link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
	<link rel="stylesheet" href="../css/style.css" type="text/css">
	
	<style type="text/css">

	#firstLevel {
    	list-style-image: url("../images/Blue_Circle_Full.png");
	}

	#secondLevel {
   		list-style-image: url("../images/Blue_Circle_Empty.png");
	}

	</style>
</head>
<body>
	<div class="page-header">
  		<h1 class="text-center title">Hierarchy</h1>
	</div>
	<ul class="checkbox">
 	<%	for (int i = 0; i < myFollowers.size(); i++){ %>
			<li id = "firstLevel">
				<%= myFollowers.get(i).getName()%> <br>
			</li>
	   		<% for (int j = 0; j < checkedUsers.length; j++){
					if (checkedUsers[j].equals(myFollowers.get(i).getScreenName())){ %>
						<ul>
							<% for (int a = 0; a < fofList.get(j).size(); a++){ %>
							<li id = "secondLevel">
							<%= fofList.get(j).get(a).getName() %> <br>
							</li>
							<% } %>
						</ul>
						<% 	
					}
				}
		}
 	
	%>
	</ul> <br>
	<span>
		<a href="network.jsp" class="btn btn-info" id="button"> See Graph </a>
		<span class="btn btn-danger"> Remaining Requests: <%= twitter.getRateLimitStatus().get("/followers/list").getRemaining() %> </span>
		<a class="btn btn-warning" href="followers.jsp"> Back to your followers </a>
		<a class="btn btn-warning" href="redirect.jsp"> Back to your profile </a>
	</span>
</body>
</html>