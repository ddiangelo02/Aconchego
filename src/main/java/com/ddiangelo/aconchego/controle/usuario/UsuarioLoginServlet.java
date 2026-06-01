/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ddiangelo.aconchego.controle.usuario;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ddiangelo.aconchego.modelo.Usuario;
import com.ddiangelo.aconchego.Utils;
import com.ddiangelo.aconchego.modelo.UsuarioDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author thimo
 */
@WebServlet(name = "UsuarioLoginServlet", urlPatterns = {"/login"})
public class UsuarioLoginServlet extends HttpServlet {


    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        
        if (session.getAttribute("usuario") != null) {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/");
            requestDispatcher.forward(request, response);
            return;
        }
        
        // System.out.println("Mensagem: " + request.getAttribute("mensagem"));

        Object mensagem = session.getAttribute("mensagem");

        if (mensagem != null) {
            request.setAttribute("mensagem", mensagem);
            session.removeAttribute("mensagem");
        }

        request.getRequestDispatcher("/login.jsp")
               .forward(request, response);
    }
    
    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
           
            String login = request.getParameter("login");
            String senha = request.getParameter("senha");

            if (login == null || senha == null) {
                throw new Exception("Por favor, preencha todos os campos obrigatórios.");
            }

            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.obterPeloLogin(login);
            
            if (usuario == null) {
                throw new Exception("Login e/ou senha inválidos.");
            }
            
            if (!usuario.getSenha().equals(Utils.gerarSHA256(senha))) {
                throw new Exception("Login e/ou senha inválidos.");
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/index.jsp");
            requestDispatcher.forward(request, response);
            
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensagem", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/login");
        }
        
    }

}
