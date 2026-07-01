package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Pedido;
import com.ddiangelo.aconchego.modelo.PedidoDAO;
import com.ddiangelo.aconchego.modelo.PedidoItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminPedidoServlet", urlPatterns = {"/admin/pedidos"})
public class AdminPedidoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PedidoDAO pedidoDAO = new PedidoDAO();
        List<Pedido> todos = pedidoDAO.obterTodos();
        if (todos == null) {
            todos = new ArrayList<Pedido>();
        }

        String busca = request.getParameter("q");
        String filtro = (busca != null) ? busca.trim().toLowerCase() : "";

        List<Pedido> pedidos = new ArrayList<Pedido>();
        double total = 0;
        for (Pedido p : todos) {
            boolean bate = filtro.isEmpty()
                    || (p.getUsuarioNome() != null && p.getUsuarioNome().toLowerCase().contains(filtro))
                    || String.valueOf(p.getId()).contains(filtro);
            if (!bate) {
                for (PedidoItem it : p.getItens()) {
                    if (it.getProdutoNome() != null && it.getProdutoNome().toLowerCase().contains(filtro)) {
                        bate = true;
                        break;
                    }
                }
            }
            if (bate) {
                pedidos.add(p);
                total += p.getTotal();
            }
        }

        request.setAttribute("pedidos", pedidos);
        request.setAttribute("totalGeral", total);
        request.setAttribute("busca", busca != null ? busca : "");
        request.getRequestDispatcher("/admin/pedidos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String acao = request.getParameter("acao");

        if ("excluir".equals(acao)) {
            int id = parseInt(request.getParameter("id"), -1);
            boolean ok = new PedidoDAO().excluir(id);
            session.setAttribute("mensagem", ok ? "Pedido cancelado e removido. O estoque dos itens foi devolvido." : "Não foi possível cancelar o pedido.");
            session.setAttribute("status", ok ? "sucesso" : "erro");
        }

        response.sendRedirect(request.getContextPath() + "/admin/pedidos");
    }

    private static int parseInt(String v, int padrao) {
        try {
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return padrao;
        }
    }
}
