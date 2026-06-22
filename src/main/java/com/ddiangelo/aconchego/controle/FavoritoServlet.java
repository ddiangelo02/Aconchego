package com.ddiangelo.aconchego.controle;

import com.ddiangelo.aconchego.modelo.FavoritoDAO;
import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "FavoritoServlet", urlPatterns = {"/favoritos"})
public class FavoritoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = usuarioLogado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Produto> favoritos = new FavoritoDAO().listarProdutos(usuario.getId());
        request.setAttribute("favoritos", favoritos);
        request.getRequestDispatcher("/favoritos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = usuarioLogado(request);
        String contexto = request.getContextPath();
        boolean ajax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));

        if (usuario == null) {
            if (ajax) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            } else {
                session.setAttribute("mensagem", "Faça login para favoritar produtos.");
                session.setAttribute("status", "erro");
                response.sendRedirect(contexto + "/login");
            }
            return;
        }

        String acao = request.getParameter("acao");
        int produtoId = parseInt(request.getParameter("produtoId"), -1);
        FavoritoDAO favoritoDAO = new FavoritoDAO();

        if (produtoId > 0) {
            if ("remover".equals(acao)) {
                favoritoDAO.remover(usuario.getId(), produtoId);
            } else {
                favoritoDAO.adicionar(usuario.getId(), produtoId);
            }
        }

        if (ajax) {
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } else {

            String origem = request.getParameter("origem");
            response.sendRedirect(contexto + (origem != null && !origem.isEmpty() ? origem : "/favoritos"));
        }
    }

    private Usuario usuarioLogado(HttpServletRequest request) {
        Object u = request.getSession().getAttribute("usuario");
        return (u instanceof Usuario) ? (Usuario) u : null;
    }

    private static int parseInt(String v, int padrao) {
        try {
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return padrao;
        }
    }
}
