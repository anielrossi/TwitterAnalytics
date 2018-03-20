package com.tap;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.RequestToken;
import twitter4j.User;

public class ProcessFof extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    public ProcessFof() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		List<List<User>> fofList = new ArrayList<List<User>>();
	    int cursor = -1;
		String[] checkedUsers = request.getParameterValues("parameter"); 
		String[] previousCheckedUsers = (String[]) request.getSession().getAttribute("checkedUsers");
		
		Twitter twitter = (Twitter) request.getSession().getAttribute("twitter");
		List<User> myFollowers = (ArrayList<User>) request.getSession().getAttribute("myFollowers");

		boolean b = true;
	    if (checkedUsers != null && previousCheckedUsers != null){
	    	if (checkedUsers.length != previousCheckedUsers.length)
	    		b = false;
	        else
	        	for (int i = 0; i < previousCheckedUsers.length; i++) {
	        		if (!(previousCheckedUsers[i].equals(checkedUsers[i]))) {
	        			b = false;    
	                }                 
	            }
	        }
	     	else{
	     		b = false;
	        }
		if(b){
		//	fofList = (ArrayList<List<User>>) request.getSession().getAttribute("fofList");
			response.sendRedirect("views/followersoffollowers.jsp");
			return;
		}
		else{
			for(int i = 0; i < checkedUsers.length ; i++) {
				List<User> singleList = new ArrayList<User>();
				try {
					User userIsProtected = twitter.showUser(checkedUsers[i]);
					if ((userIsProtected.isProtected()) && (userIsProtected.isFollowRequestSent() == true)){
						singleList = Collections.<User>emptyList();
					}
					else{
						singleList = twitter.getFollowersList(checkedUsers[i], cursor, 20);
					}
				fofList.add(i, singleList);
			}
			catch (TwitterException twitterException) {
				if (twitterException.getErrorCode() == 88){
					twitterException.printStackTrace();
					response.sendRedirect("http://127.0.0.1:8082/TAProject/views/errorlimit.jsp");
					return;
				}
				else {
					twitterException.printStackTrace();	
				}
			}
		}
		response.sendRedirect("http://127.0.0.1:8082/TAProject/views/followersoffollowers.jsp");
		request.getSession().setAttribute("fofList", fofList);
		request.getSession().setAttribute("checkedUsers", checkedUsers);
	}	
}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
