package com.servlet.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	public static void main(String agrs[]) throws SQLException {
		Connection conn= getConnection();
		
		if(conn != null) {
			System.out.println("Connection is working.");
		}
	}
	
	
	public  static Connection getConnection() throws SQLException {
        Connection con = null;

		/*
		 * private static final String URL = "jdbc:mysql://localhost:3306/library_db";
		 * private static final String USER = "root"; private static final String
		 * PASSWORD = "minpyae";
		 */
	    
	        try {
	            // Load Driver
	            Class.forName("com.mysql.cj.jdbc.Driver");

	            // Create Connection
	            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cheatsheet_db","root","minpyae");

	            System.out.println("Connection is Successfully");

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return con;
	    }
	}




