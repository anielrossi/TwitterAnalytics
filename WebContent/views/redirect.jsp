<%@page import="twitter4j.TwitterException"%>
<%@page import="twitter4j.User"%>
<%@page import="twitter4j.TwitterFactory"%>
<%@page import="twitter4j.Twitter"%>
<%@page import="twitter4j.auth.RequestToken"%>
<%@page import="twitter4j.auth.AccessToken"%>
<html>
<head>
	<title>Home</title>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
      
    <link rel="stylesheet" href="../css/materialize.css">
    <link rel="stylesheet" href="../css/materialize.min.css">
    <link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/bootstrap.min.css">  
    <link rel="stylesheet" href="../css/style.css">
   	
	<%
	
	long userId = (long) request.getSession().getAttribute("userId");
	Twitter twitter = (Twitter) request.getSession().getAttribute("twitter");
			
	User loggedUser = twitter.showUser(userId);
	request.getSession().setAttribute("loggedUser", loggedUser);
	
	%>	
	<script type="text/javascript">
		function Window(){	
			window.open('<%="https://www.twitter.com/" + loggedUser.getScreenName()%>');	
		};
	</script>
</head>
<body onload="javascript:profile()" bgcolor="#99FFFF">
	<div class="page-header">
  		<h1 class="text-center  title">Personal Informations</h1> 
	</div>
	<div class="text-center">	
    	<div class="row text-center" id="profile">
        	<div class="col s12 m6">
          		<div class="card teal lighten-2">
            		<div class="card-content white-text">              
              			<p><img src=<%=loggedUser.getBiggerProfileImageURL()%> class="img-rounded" class="text-center"></img>
						<br>
						<br>
						<div>ID: <%= loggedUser.getId() %></div><br>
						<div>NAME: <%= loggedUser.getName() %></div><br>
						<div>
							<button class="btn btn-info" onclick="Window()">Twitter Profile</button> 
							<a class="btn btn-info" href="followers.jsp">Get Followers</a>
						</div>
						<br>
						<div class="btn btn-danger"> Remaining Requests: <%= twitter.getRateLimitStatus().get("/followers/list").getRemaining() %> </div>
           			</div>
            	</div>
          	</div>
        </div>
      </div>     
</body>
</html>