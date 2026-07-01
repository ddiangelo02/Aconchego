package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import com.ddiangelo.aconchego.modelo.RelatorioDAO;
import com.ddiangelo.aconchego.modelo.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminRelatorioServlet", urlPatterns = {"/admin/relatorios"})
public class AdminRelatorioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RelatorioDAO relatorioDAO = new RelatorioDAO();
        ProdutoDAO produtoDAO = new ProdutoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        double faturamento = relatorioDAO.faturamentoTotal();
        int totalPedidos = relatorioDAO.totalPedidos();
        long itensVendidos = relatorioDAO.itensVendidos();
        double ticketMedio = (totalPedidos > 0) ? faturamento / totalPedidos : 0;

        List<?> produtos = produtoDAO.obterTodos();
        int totalProdutos = (produtos != null) ? produtos.size() : 0;
        int semEstoque = produtoDAO.contarSemEstoque();
        List<?> usuarios = usuarioDAO.obterTodos();
        int totalUsuarios = (usuarios != null) ? usuarios.size() : 0;

        request.setAttribute("faturamento", faturamento);
        request.setAttribute("totalPedidos", totalPedidos);
        request.setAttribute("itensVendidos", itensVendidos);
        request.setAttribute("ticketMedio", ticketMedio);
        request.setAttribute("totalProdutos", totalProdutos);
        request.setAttribute("semEstoque", semEstoque);
        request.setAttribute("totalUsuarios", totalUsuarios);
        request.setAttribute("maisVendidos", relatorioDAO.produtosMaisVendidos());
        request.setAttribute("porPagamento", relatorioDAO.porFormaPagamento());
        request.setAttribute("topClientes", relatorioDAO.topClientes());

        // Versão para impressão/PDF (com a logo) quando ?pdf=1
        String view = "1".equals(request.getParameter("pdf")) ? "/admin/relatorios-pdf.jsp" : "/admin/relatorios.jsp";
        request.getRequestDispatcher(view).forward(request, response);
    }
}
