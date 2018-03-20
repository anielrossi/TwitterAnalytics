package com.tap;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.RequestToken;
import twitter4j.auth.AccessToken;

/**
 * Servlet implementation class Callback
 */

public class Callback extends HttpServlet {

	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Callback() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		long userId;
		AccessToken accessToken;
		
		Twitter twitter = (Twitter) request.getSession().getAttribute("twitter");
		RequestToken requestToken = (RequestToken) request.getSession().getAttribute("requestToken");
		String verifier = request.getParameter("oauth_verifier");
		accessToken = null;
		try {			
				accessToken = twitter.getOAuthAccessToken(requestToken,verifier);
				request.getSession().removeAttribute("requestToken");
			} 
		catch (TwitterException twitterException) {
		   
			twitterException.printStackTrace();
			}
		userId = accessToken.getUserId();
		request.getSession().removeAttribute("userId");
		request.getSession().removeAttribute("myFollowers");
		request.getSession().removeAttribute("checkedUsers");
		request.getSession().removeAttribute("fofList");
		request.getSession().setAttribute("userId", userId);
		response.sendRedirect("views/redirect.jsp");
		}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request,response);
	}

}
