package com.ddiangelo.aconchego.controle;

import com.ddiangelo.aconchego.modelo.Carrinho;
import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import com.ddiangelo.aconchego.modelo.Usuario;
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
import java.util.Map;

@WebServlet(name = "CarrinhoServlet", urlPatterns = {"/carrinho"})
public class CarrinhoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Carrinho carrinho = obterCarrinho(session);
        ProdutoDAO produtoDAO = new ProdutoDAO();

        List<Produto> itens = new ArrayList<Produto>();
        List<Integer> quantidades = new ArrayList<Integer>();
        double total = 0;

        for (Map.Entry<Integer, Integer> e : carrinho.getItens().entrySet()) {
            Produto p = produtoDAO.obterPeloId(e.getKey());
            if (p == null) {
                continue;
            }
            int qtd = e.getValue();
            itens.add(p);
            quantidades.add(qtd);
            total += p.getPreco() * qtd;
        }

        request.setAttribute("itens", itens);
        request.setAttribute("quantidades", quantidades);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/carrinho.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Carrinho carrinho = obterCarrinho(session);
        String acao = request.getParameter("acao");
        String contexto = request.getContextPath();
        boolean ajax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));

        if ("adicionar".equals(acao)) {
            int produtoId = parseInt(request.getParameter("produtoId"), -1);
            int qtd = parseInt(request.getParameter("quantidade"), 1);
            if (produtoId > 0) {
                carrinho.adicionar(produtoId, qtd <= 0 ? 1 : qtd);
                session.setAttribute("mensagem", "Produto adicionado ao carrinho.");
                session.setAttribute("status", "sucesso");
            }
            response.sendRedirect(contexto + "/carrinho");

        } else if ("atualizar".equals(acao)) {
            int produtoId = parseInt(request.getParameter("produtoId"), -1);
            int qtd = parseInt(request.getParameter("quantidade"), 1);
            if (produtoId > 0) {
                carrinho.atualizar(produtoId, qtd);
            }

            if (ajax) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                response.sendRedirect(contexto + "/carrinho");
            }

        } else if ("remover".equals(acao)) {
            int produtoId = parseInt(request.getParameter("produtoId"), -1);
            if (produtoId > 0) {
                carrinho.remover(produtoId);
            }
            if (ajax) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                response.sendRedirect(contexto + "/carrinho");
            }

        } else if ("finalizar".equals(acao)) {
            finalizar(request, response, session, carrinho);

        } else {
            response.sendRedirect(contexto + "/carrinho");
        }
    }

    private void finalizar(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, Carrinho carrinho) throws IOException {

        String contexto = request.getContextPath();

        Usuario usuario = (session.getAttribute("usuario") instanceof Usuario) ? (Usuario) session.getAttribute("usuario") : null;
        if (usuario == null) {
            session.setAttribute("mensagem", "Faça login para finalizar a compra.");
            session.setAttribute("status", "erro");
            response.sendRedirect(contexto + "/login");
            return;
        }

        if (carrinho.isVazio()) {
            session.setAttribute("mensagem", "Seu carrinho está vazio.");
            session.setAttribute("status", "erro");
            response.sendRedirect(contexto + "/carrinho");
            return;
        }

        String formaPagamento = request.getParameter("forma-pagamento");
        if (formaPagamento == null || formaPagamento.trim().isEmpty()) {
            formaPagamento = "Pix";
        }

        ProdutoDAO produtoDAO = new ProdutoDAO();
        PedidoDAO pedidoDAO = new PedidoDAO();

        List<PedidoItem> itens = new ArrayList<PedidoItem>();
        List<String> falhas = new ArrayList<String>();

        for (int produtoId : new ArrayList<Integer>(carrinho.getItens().keySet())) {
            int qtd = carrinho.getItens().get(produtoId);
            Produto p = produtoDAO.obterPeloId(produtoId);
            if (p == null) {
                carrinho.remover(produtoId);
                continue;
            }
            if (p.getQuantidade() < qtd) {
                falhas.add(p.getNome() + " (estoque insuficiente: " + p.getQuantidade() + ")");
                continue;
            }
            itens.add(new PedidoItem(produtoId, qtd, p.getPreco()));
        }

        if (itens.isEmpty()) {
            session.setAttribute("mensagem", "Não foi possível concluir o pedido. " + String.join(", ", falhas) + ".");
            session.setAttribute("status", "erro");
            response.sendRedirect(contexto + "/carrinho");
            return;
        }

        int pedidoId = pedidoDAO.criar(usuario.getId(), formaPagamento, itens);
        if (pedidoId <= 0) {
            session.setAttribute("mensagem", "Não foi possível registrar o pedido. Tente novamente.");
            session.setAttribute("status", "erro");
            response.sendRedirect(contexto + "/carrinho");
            return;
        }

        for (PedidoItem item : itens) {
            produtoDAO.baixarEstoque(item.getProdutoId(), item.getQuantidade());
            carrinho.remover(item.getProdutoId());
        }

        if (falhas.isEmpty()) {
            session.setAttribute("mensagem", "Pedido #" + pedidoId + " concluído! " + itens.size() + " produto(s), estoque atualizado. Pagamento via " + formaPagamento + ".");
            session.setAttribute("status", "sucesso");
        } else {
            session.setAttribute("mensagem", "Pedido #" + pedidoId + " concluído com " + itens.size() + " produto(s). Pendências: " + String.join(", ", falhas) + ".");
            session.setAttribute("status", "erro");
        }

        response.sendRedirect(contexto + "/carrinho");
    }

    private Carrinho obterCarrinho(HttpSession session) {
        Object atributo = session.getAttribute("carrinho");
        if (atributo instanceof Carrinho) {
            return (Carrinho) atributo;
        }
        Carrinho carrinho = new Carrinho();
        session.setAttribute("carrinho", carrinho);
        return carrinho;
    }

    private static int parseInt(String v, int padrao) {
        try {
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return padrao;
        }
    }
}
