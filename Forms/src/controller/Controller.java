package controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import model.GetLoginForms;
import model.SearchProvider;

/**
 * Servlet implementation class Controller
 */
@WebServlet("/Controller")
public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ArrayList<String> arrayList = new ArrayList<String>();
	static String requestType= "";
	static String SEARCH_SITE="SearchForSite";
	static String GET_FORM = "GetLoginForm";
	static String result = "";

	public Controller() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		requestType= request.getParameter("button");
		
		if (requestType.equals(SEARCH_SITE)){	
			SearchProvider sp = new SearchProvider();
			System.out.println(request.getParameter("siteString"));
			result = sp.search(request.getParameter("siteString"));			
		}
		
		else if(requestType.equals(GET_FORM)){
			GetLoginForms form = new GetLoginForms();
			System.out.println(request.getParameter("provider_id"));
			result = form.getForm(request.getParameter("provider_id"));
		}
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(result.toString());
	}

}
