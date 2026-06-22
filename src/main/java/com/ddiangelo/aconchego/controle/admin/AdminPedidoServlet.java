package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Pedido;
import com.ddiangelo.aconchego.modelo.PedidoDAO;
import com.ddiangelo.aconchego.modelo.PedidoItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
}
