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
import com.ddiangelo.aconchego.Utils;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Usuário
 *
 * Servlet responsável exclusivamente pela alteração de senha do usuário.
 */
@WebServlet(name = "UsuarioSenhaServlet", urlPatterns = {"/alterar-senha"})
public class UsuarioSenhaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuarioSessao = (Usuario) session.getAttribute("usuario");

        if (usuarioSessao == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        try {

            // Recarrega os dados atuais (a sessão pode estar defasada)
            Usuario usuario = usuarioDAO.obterPeloId(usuarioSessao.getId());
            if (usuario == null) {
                throw new Exception("Não foi possível localizar a sua conta.");
            }

            String senhaAtual = request.getParameter("senha-atual");
            String senhaNova = request.getParameter("senha-nova");
            String senhaConfirmacao = request.getParameter("senha-confirmacao");

            // A senha atual é obrigatória para confirmar a alteração
            if (senhaAtual == null || senhaAtual.isEmpty()) {
                throw new Exception("Informe a sua senha atual para alterar a senha.");
            }

            if (!usuario.getSenha().equals(Utils.gerarSHA256(senhaAtual))) {
                throw new Exception("A senha atual está incorreta.");
            }

            if (senhaNova == null || senhaNova.isEmpty()) {
                throw new Exception("Informe a nova senha.");
            }

            if (senhaNova.length() < 6) {
                throw new Exception("A nova senha deve possuir, pelo menos, 6 caracteres.");
            }

            if (!senhaNova.equals(senhaConfirmacao)) {
                throw new Exception("A confirmação da nova senha não coincide.");
            }

            // Mantém os demais dados; altera apenas a senha
            boolean sucesso = usuarioDAO.atualizar(
                    usuario.getNome(),
                    usuario.getEndereco(),
                    usuario.getEmail(),
                    usuario.getLogin(),
                    senhaNova,
                    usuario.getId());

            if (!sucesso) {
                throw new Exception("Não foi possível alterar a sua senha. Tente novamente.");
            }

            // Atualiza a sessão com os dados recém-salvos
            Usuario atualizado = usuarioDAO.obterPeloId(usuario.getId());
            session.setAttribute("usuario", atualizado);

            request.setAttribute("status", "sucesso");
            request.setAttribute("mensagem", "Sua senha foi alterada com sucesso!");

        } catch (Exception ex) {
            request.setAttribute("status", "erro");
            request.setAttribute("mensagem", ex.getMessage());
        }

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("/configuracoes.jsp");
        requestDispatcher.forward(request, response);
    }
}
