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
 *
 * Servlet responsável pela exclusão permanente da conta do usuário.
 */
@WebServlet(name = "UsuarioExclusaoServlet", urlPatterns = {"/excluir-conta"})
public class UsuarioExclusaoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean sucesso = usuarioDAO.remover(usuario.getId());

        if (sucesso) {
            // Conta removida: encerra a sessão e leva o usuário ao início
            session.invalidate();
            HttpSession nova = request.getSession();
            nova.setAttribute("mensagem", "Sua conta foi excluída com sucesso.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            // Falha (ex.: existem pedidos vinculados): retorna às configurações
            request.setAttribute("status", "erro");
            request.setAttribute("mensagem", "Não foi possível excluir a sua conta. Caso possua pedidos vinculados, entre em contato com o suporte.");
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/configuracoes.jsp");
            requestDispatcher.forward(request, response);
        }
    }
}
