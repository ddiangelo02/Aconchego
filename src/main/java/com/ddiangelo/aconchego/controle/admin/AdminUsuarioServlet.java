package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Usuario;
import com.ddiangelo.aconchego.modelo.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminUsuarioServlet", urlPatterns = {"/admin/usuarios"})
public class AdminUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        List<Usuario> todos = usuarioDAO.obterTodos();
        if (todos == null) {
            todos = new ArrayList<Usuario>();
        }

        String busca = request.getParameter("q");
        String filtro = (busca != null) ? busca.trim().toLowerCase() : "";

        List<Usuario> usuarios = new ArrayList<Usuario>();
        for (Usuario u : todos) {
            if (filtro.isEmpty()
                    || (u.getNome() != null && u.getNome().toLowerCase().contains(filtro))
                    || (u.getEmail() != null && u.getEmail().toLowerCase().contains(filtro))
                    || (u.getLogin() != null && u.getLogin().toLowerCase().contains(filtro))) {
                usuarios.add(u);
            }
        }

        request.setAttribute("usuarios", usuarios);
        request.setAttribute("busca", busca != null ? busca : "");
        request.getRequestDispatcher("/admin/usuarios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        HttpSession session = request.getSession();
        String acao = request.getParameter("acao");

        Usuario logado = (session.getAttribute("usuario") instanceof Usuario) ? (Usuario) session.getAttribute("usuario") : null;

        try {
            if ("excluir".equals(acao)) {

                int id = parseInt(request.getParameter("id"), -1);
                if (logado != null && logado.getId() == id) {
                    throw new IllegalArgumentException("Você não pode excluir a sua própria conta de administrador.");
                }
                boolean ok = usuarioDAO.remover(id);
                session.setAttribute("mensagem", ok ? "Usuário excluído com sucesso." : "Não foi possível excluir o usuário (verifique pedidos vinculados).");
                session.setAttribute("status", ok ? "sucesso" : "erro");

            } else {

                int id = parseInt(request.getParameter("id"), -1);
                String nome = trim(request.getParameter("nome"));
                String email = trim(request.getParameter("email"));
                String login = trim(request.getParameter("login"));
                String endereco = trim(request.getParameter("endereco"));
                String senha = request.getParameter("senha");
                boolean administrador = request.getParameter("administrador") != null;

                if (nome.isEmpty() || email.isEmpty() || login.isEmpty()) {
                    throw new IllegalArgumentException("Preencha nome, e-mail e login.");
                }

                boolean ok;
                if (id > 0) {
                    ok = usuarioDAO.atualizarComPerfil(nome, endereco, email, login, administrador, id);
                    session.setAttribute("mensagem", ok ? "Usuário atualizado com sucesso." : "Não foi possível atualizar o usuário.");
                } else {
                    if (senha == null || senha.length() < 6) {
                        throw new IllegalArgumentException("Defina uma senha de pelo menos 6 caracteres para o novo usuário.");
                    }
                    ok = usuarioDAO.inserir(nome, endereco, email, login, senha, administrador);
                    session.setAttribute("mensagem", ok ? "Usuário adicionado com sucesso." : "Não foi possível adicionar o usuário (login/e-mail já em uso?).");
                }
                session.setAttribute("status", ok ? "sucesso" : "erro");
            }
        } catch (IllegalArgumentException ex) {
            session.setAttribute("mensagem", ex.getMessage());
            session.setAttribute("status", "erro");
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios");
    }

    private static String trim(String v) {
        return v == null ? "" : v.trim();
    }

    private static int parseInt(String v, int padrao) {
        try {
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return padrao;
        }
    }
}
