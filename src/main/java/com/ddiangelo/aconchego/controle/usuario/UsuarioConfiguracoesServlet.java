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

@WebServlet(name = "UsuarioConfiguracoesServlet", urlPatterns = {"/configuracoes"})
public class UsuarioConfiguracoesServlet extends HttpServlet {

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

            Usuario usuario = usuarioDAO.obterPeloId(usuarioSessao.getId());
            if (usuario == null) {
                throw new Exception("Não foi possível localizar a sua conta.");
            }

            String nome = request.getParameter("nome");
            String email = request.getParameter("email");
            String endereco = request.getParameter("endereco");
            String senhaAtual = request.getParameter("senha-atual");

            if (senhaAtual == null || senhaAtual.isEmpty()) {
                throw new Exception("Informe a sua senha atual para salvar as alterações.");
            }

            if (!usuario.getSenha().equals(Utils.gerarSHA256(senhaAtual))) {
                throw new Exception("A senha atual está incorreta.");
            }

            if (nome == null || nome.trim().isEmpty() || email == null || email.trim().isEmpty() || endereco == null || endereco.trim().isEmpty()) {
                throw new Exception("Preencha os campos obrigatórios.");
            }

            String login = usuario.getLogin();

            boolean sucesso = usuarioDAO.atualizar(nome.trim(), endereco, email.trim(), login, usuario.getId());

            if (!sucesso) {
                throw new Exception("Não foi possível atualizar o seu cadastro. Tente novamente.");
            }

            Usuario atualizado = usuarioDAO.obterPeloId(usuario.getId());
            session.setAttribute("usuario", atualizado);

            request.setAttribute("status", "sucesso");
            request.setAttribute("mensagem", "Seus dados foram atualizados com sucesso!");

        } catch (Exception ex) {
            request.setAttribute("status", "erro");
            request.setAttribute("mensagem", ex.getMessage());
        }

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("/configuracoes.jsp");
        requestDispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        if (session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Object mensagem = session.getAttribute("mensagem");

        if (mensagem != null) {
            request.setAttribute("mensagem", mensagem);
            session.removeAttribute("mensagem");
        }

        request.getRequestDispatcher("/configuracoes.jsp")
               .forward(request, response);
    }
}
