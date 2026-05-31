package com.ddiangelo.aconchego;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;

public class ConnectionFactory {
    
    private static final String JDBC_DRIVER = "org.postgresql.Driver";
    
    private static final String JDBC_URL = "jdbc:postgresql://localhost:5432/aconchegoecommerce";

    private static final String JDBC_USER = "root";

    private static final String JDBC_PASSWORD = "";
    

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
            return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            
        } catch (ClassNotFoundException e) {
            System.out.println("PostgreSQL Driver not found!");
            e.printStackTrace();
            return null;
            
        } catch (SQLException e) {
            System.out.println("Connection failed!");
            e.printStackTrace();
            return null;
            
        }
    }
    
}