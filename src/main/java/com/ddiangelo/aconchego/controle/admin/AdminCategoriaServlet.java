package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Categoria;
import com.ddiangelo.aconchego.modelo.CategoriaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminCategoriaServlet", urlPatterns = {"/admin/categorias"})
public class AdminCategoriaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CategoriaDAO categoriaDAO = new CategoriaDAO();

        String busca = request.getParameter("q");
        String filtro = (busca != null) ? busca.trim().toLowerCase() : "";

        List<Categoria> todas = categoriaDAO.obterTodos();
        if (todas == null) {
            todas = new ArrayList<Categoria>();
        }

        List<Categoria> categorias = new ArrayList<Categoria>();
        for (Categoria c : todas) {
            if (filtro.isEmpty() || (c.getNome() != null && c.getNome().toLowerCase().contains(filtro))) {
                categorias.add(c);
            }
        }

        request.setAttribute("categorias", categorias);
        request.setAttribute("busca", busca != null ? busca : "");
        request.getRequestDispatcher("/admin/categorias.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CategoriaDAO categoriaDAO = new CategoriaDAO();
        HttpSession session = request.getSession();
        String acao = request.getParameter("acao");

        try {
            if ("excluir".equals(acao)) {

                int id = parseInt(request.getParameter("id"), -1);
                boolean ok = categoriaDAO.remover(id);
                session.setAttribute("mensagem", ok ? "Categoria excluída com sucesso." : "Não foi possível excluir a categoria.");
                session.setAttribute("status", ok ? "sucesso" : "erro");

            } else {

                int id = parseInt(request.getParameter("id"), -1);
                String nome = trim(request.getParameter("nome"));

                if (nome.isEmpty()) {
                    throw new IllegalArgumentException("Informe o nome da categoria.");
                }

                boolean ok;
                if (id > 0) {
                    ok = categoriaDAO.atualizar(nome, id);
                    session.setAttribute("mensagem", ok ? "Categoria atualizada com sucesso." : "Não foi possível atualizar a categoria.");
                } else {
                    ok = categoriaDAO.inserir(nome);
                    session.setAttribute("mensagem", ok ? "Categoria adicionada com sucesso." : "Não foi possível adicionar a categoria.");
                }
                session.setAttribute("status", ok ? "sucesso" : "erro");
            }
        } catch (IllegalArgumentException ex) {
            session.setAttribute("mensagem", ex.getMessage());
            session.setAttribute("status", "erro");
        }

        response.sendRedirect(request.getContextPath() + "/admin/categorias");
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
