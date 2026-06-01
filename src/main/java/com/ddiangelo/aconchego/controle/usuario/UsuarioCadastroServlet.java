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
import com.ddiangelo.aconchego.modelo.UsuarioDAO;
import jakarta.servlet.annotation.WebServlet;


/**
 *
 * @author Usuário
 */
@WebServlet(name = "UsuarioCadastroServlet", urlPatterns = {"/cadastro"})
public class UsuarioCadastroServlet extends HttpServlet {

   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        /* entrada */
        String nome = request.getParameter("nome");
        String endereco = request.getParameter("endereco");
        String email = request.getParameter("email");
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");
        /* processamento */
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean sucesso = usuarioDAO.inserirCliente(nome, endereco, email, login, senha);
        /* saída */
        if (sucesso) {
            request.setAttribute("mensagem", "Cadastro efetuado com sucesso!");
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/login.jsp");
            requestDispatcher.forward(request, response);
        } else {
            request.setAttribute("mensagem", "Não foi possível realizar seu cadastro.");
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/cadastro.jsp");
            requestDispatcher.forward(request, response);
        }
    }

}
