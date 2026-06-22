package com.ddiangelo.aconchego.controle;

import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "BuscaServlet", urlPatterns = {"/busca"})
public class BuscaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String termo = request.getParameter("q");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder("[");

        if (termo != null && !termo.trim().isEmpty()) {
            List<Produto> produtos = new ProdutoDAO().buscar(termo.trim());
            for (int i = 0; i < produtos.size(); i++) {
                Produto p = produtos.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                    .append("\"id\":").append(p.getId()).append(",")
                    .append("\"nome\":\"").append(escapar(p.getNome())).append("\",")
                    .append("\"preco\":").append(p.getPreco()).append(",")
                    .append("\"foto\":\"").append(escapar(p.getFoto())).append("\"")
                    .append("}");
            }
        }
        json.append("]");

        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }

    private String escapar(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
    }
}
