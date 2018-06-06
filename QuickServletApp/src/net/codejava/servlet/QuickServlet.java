package net.codejava.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import SheetPackageTester.SheetsQuickstart;

public class QuickServlet extends HttpServlet {

	/**
	 * this life-cycle method is invoked when this servlet is first accessed
	 * by the client
	 */
	public void init(ServletConfig config) {
		System.out.println("Servlet is being initialized");
	}

	/**
	 * handles HTTP GET request
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException {

		PrintWriter writer = response.getWriter();
		SheetsQuickstart.updateSheet();
		writer.println("<html>Hello, I am a Java servlet!</html>");
		writer.flush();
	}

	/**
	 * handles HTTP POST request
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		String paramWidth = request.getParameter("width");
		int width = Integer.parseInt(paramWidth);

		String paramHeight = request.getParameter("height");
		int height = Integer.parseInt(paramHeight);

		long area = width * height;

		PrintWriter writer = response.getWriter();
		writer.println("<html>Area of the rectangle is: " + area + "</html>");
		writer.flush();

	}

	/**
	 * this life-cycle method is invoked when the application or the server
	 * is shutting down
	 */
	public void destroy() {
		System.out.println("Servlet is being destroyed");
	}
}