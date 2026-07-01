package com.ddiangelo.aconchego.controle;

import com.ddiangelo.aconchego.modelo.Carrinho;
import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import com.ddiangelo.aconchego.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PagamentoServlet", urlPatterns = {"/pagamento"})
public class PagamentoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String contexto = request.getContextPath();

        // Exige sessão válida de usuário
        if (!(session.getAttribute("usuario") instanceof Usuario)) {
            session.setAttribute("mensagem", "Faça login para finalizar a compra.");
            session.setAttribute("status", "erro");
            response.sendRedirect(contexto + "/login");
            return;
        }

        Carrinho carrinho = (session.getAttribute("carrinho") instanceof Carrinho)
                ? (Carrinho) session.getAttribute("carrinho") : new Carrinho();

        if (carrinho.isVazio()) {
            response.sendRedirect(contexto + "/carrinho");
            return;
        }

        // Monta o resumo (produto + quantidade) e o total
        ProdutoDAO produtoDAO = new ProdutoDAO();
        List<Produto> itens = new ArrayList<Produto>();
        List<Integer> quantidades = new ArrayList<Integer>();
        double total = 0;
        for (Map.Entry<Integer, Integer> e : carrinho.getItens().entrySet()) {
            Produto p = produtoDAO.obterPeloId(e.getKey());
            if (p == null) {
                continue;
            }
            itens.add(p);
            quantidades.add(e.getValue());
            total += p.getPreco() * e.getValue();
        }

        request.setAttribute("itens", itens);
        request.setAttribute("quantidades", quantidades);
        request.setAttribute("total", total);
        request.getRequestDispatcher("/pagamento.jsp").forward(request, response);
    }
}
