/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ddiangelo.aconchego.controle.usuario;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ddiangelo.aconchego.modelo.Usuario;
import com.ddiangelo.aconchego.modelo.UsuarioDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Usuário
 */
@WebServlet(name = "UsuarioConfiguracoesServlet", urlPatterns = {"/configuracoes"})
public class UsuarioConfiguracoesServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();
            Usuario usuario = (Usuario) session.getAttribute("usuario");

            if (usuario == null) {
                throw new Exception("Você não possui sessão ativa.");
            }

            int id = usuario.getId();
            String nome = request.getParameter("nome");
            String endereco = request.getParameter("endereco");
            String email = request.getParameter("email");
            String login = request.getParameter("login");

            // processamento
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            boolean sucesso = usuarioDAO.atualizar(nome, endereco, email, login, id);
            if (sucesso) {
                request.setAttribute("mensagem", "Seu cadastro foi atualizado com sucesso!");
                request.setAttribute("status", "sucesso");
                
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("/configuracoes.jsp");
                requestDispatcher.forward(request, response);
               
            } else {
                request.setAttribute("mensagem", "Não foi possível atualizar seu cadastro!");
            }
            
            
        } catch (Exception ex) {
            request.setAttribute("mensagem", "Ocorreu um erro interno. Tente novamente mais tarde.");
            System.out.println(ex.getMessage());
        }
                

    }

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
        
        if (session.getAttribute("usuario") == null) {
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

        request.getRequestDispatcher("/configuracoes.jsp")
               .forward(request, response);
    }
}
