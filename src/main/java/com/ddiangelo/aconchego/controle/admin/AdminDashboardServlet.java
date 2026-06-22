package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import com.ddiangelo.aconchego.modelo.Usuario;
import com.ddiangelo.aconchego.modelo.UsuarioDAO;
import com.ddiangelo.aconchego.modelo.Pedido;
import com.ddiangelo.aconchego.modelo.PedidoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin", "/admin/visao-geral"})
public class AdminDashboardServlet extends HttpServlet {

    private static final int LIMITE_ESTOQUE_BAIXO = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdutoDAO produtoDAO = new ProdutoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        PedidoDAO pedidoDAO = new PedidoDAO();

        List<Produto> produtos = produtoDAO.obterTodos();
        if (produtos == null) {
            produtos = new ArrayList<Produto>();
        }
        List<Usuario> usuarios = usuarioDAO.obterTodos();
        int totalUsuarios = (usuarios != null) ? usuarios.size() : 0;

        List<Pedido> pedidos = pedidoDAO.obterTodos();
        if (pedidos == null) {
            pedidos = new ArrayList<Pedido>();
        }

        List<Produto> estoqueBaixo = new ArrayList<Produto>();
        List<Produto> estoqueVazio = new ArrayList<Produto>();
        int semEstoque = 0;
        for (Produto p : produtos) {
            if (p.getQuantidade() == 0) {
                semEstoque++;
                estoqueVazio.add(p);
            } else if (p.getQuantidade() <= LIMITE_ESTOQUE_BAIXO) {
                estoqueBaixo.add(p);
            }
        }

        List<Pedido> ultimosPedidos = pedidos.size() > 5 ? new ArrayList<Pedido>(pedidos.subList(0, 5)) : pedidos;

        request.setAttribute("totalProdutos", produtos.size());
        request.setAttribute("semEstoque", semEstoque);
        request.setAttribute("totalPedidos", pedidos.size());
        request.setAttribute("totalUsuarios", totalUsuarios);
        request.setAttribute("estoqueBaixo", estoqueBaixo);
        request.setAttribute("estoqueVazio", estoqueVazio);
        request.setAttribute("ultimosPedidos", ultimosPedidos);

        request.getRequestDispatcher("/admin/visao-geral.jsp").forward(request, response);
    }
}
