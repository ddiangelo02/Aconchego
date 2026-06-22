package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminEstoqueServlet", urlPatterns = {"/admin/estoque"})
public class AdminEstoqueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdutoDAO produtoDAO = new ProdutoDAO();
        List<Produto> todos = produtoDAO.obterTodos();
        if (todos == null) {
            todos = new ArrayList<Produto>();
        }

        String busca = request.getParameter("q");
        String filtro = (busca != null) ? busca.trim().toLowerCase() : "";

        List<Produto> produtos = new ArrayList<Produto>();
        for (Produto p : todos) {
            if (filtro.isEmpty() || p.getNome().toLowerCase().contains(filtro)) {
                produtos.add(p);
            }
        }

        request.setAttribute("produtos", produtos);
        request.setAttribute("busca", busca != null ? busca : "");
        request.getRequestDispatcher("/admin/estoque.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdutoDAO produtoDAO = new ProdutoDAO();
        HttpSession session = request.getSession();

        int id = parseInt(request.getParameter("id"), -1);
        int quantidade = parseInt(request.getParameter("quantidade"), -1);

        if (id <= 0 || quantidade < 0) {
            session.setAttribute("mensagem", "Quantidade inválida.");
            session.setAttribute("status", "erro");
        } else {
            boolean ok = produtoDAO.atualizarEstoque(id, quantidade);
            session.setAttribute("mensagem", ok ? "Estoque atualizado com sucesso." : "Não foi possível atualizar o estoque.");
            session.setAttribute("status", ok ? "sucesso" : "erro");
        }

        response.sendRedirect(request.getContextPath() + "/admin/estoque");
    }

    private static int parseInt(String v, int padrao) {
        try {
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return padrao;
        }
    }
}
