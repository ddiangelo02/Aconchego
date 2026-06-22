package com.ddiangelo.aconchego.controle;

import com.ddiangelo.aconchego.modelo.FavoritoDAO;
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

@WebServlet(name = "ProdutoDetalheServlet", urlPatterns = {"/produto"})
public class ProdutoDetalheServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/loja");
            return;
        }

        Produto produto = new ProdutoDAO().obterPeloId(id);
        if (produto == null) {
            response.sendRedirect(request.getContextPath() + "/loja");
            return;
        }

        boolean favorito = false;
        HttpSession session = request.getSession();
        if (session.getAttribute("usuario") instanceof Usuario) {
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            favorito = new FavoritoDAO().existe(usuario.getId(), id);
        }

        request.setAttribute("produto", produto);
        request.setAttribute("favorito", favorito);
        request.getRequestDispatcher("/produto.jsp").forward(request, response);
    }
}
