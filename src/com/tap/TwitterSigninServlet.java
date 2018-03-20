package com.tap;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.RequestToken;
/**
 * Servlet implementation class TwitterSigninServlet
 */
public class TwitterSigninServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TwitterSigninServlet() {
        super();
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Twitter twitter = new TwitterFactory().getInstance();
			RequestToken requestToken;
			request.getSession().setAttribute("twitter", twitter);
			twitter.setOAuthConsumer("4v803xru5GLf3Y31pU1wO0MnB", "MmdXYxcGFHLxWlISH9YgicGkXrTIgskpXYDJ1sxsj2jwhSM1as");			
			requestToken = twitter.getOAuthRequestToken("http://127.0.0.1:8082/TAProject/Callback");			
			String authURL = requestToken.getAuthenticationURL();
			request.getSession().setAttribute("requestToken", requestToken);
			response.sendRedirect(authURL);
		} catch (TwitterException  twitterException) {
			twitterException.printStackTrace();
		}
	}
}
