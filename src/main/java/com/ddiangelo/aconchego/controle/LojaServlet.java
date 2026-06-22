package com.ddiangelo.aconchego.controle;

import com.ddiangelo.aconchego.modelo.Categoria;
import com.ddiangelo.aconchego.modelo.CategoriaDAO;
import com.ddiangelo.aconchego.modelo.FavoritoDAO;
import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import com.ddiangelo.aconchego.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "LojaServlet", urlPatterns = {"/loja"})
public class LojaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdutoDAO produtoDAO = new ProdutoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();

        List<Produto> todos = produtoDAO.obterTodos();
        if (todos == null) {
            todos = new ArrayList<Produto>();
        }
        List<Categoria> categorias = categoriaDAO.obterTodos();
        if (categorias == null) {
            categorias = new ArrayList<Categoria>();
        }

        Set<Integer> selCategorias = paraInts(request.getParameterValues("categoria"));
        Set<String> selFaixas = paraSet(request.getParameterValues("faixa"));
        boolean somenteEstoque = request.getParameter("disp") != null;
        String ordenar = request.getParameter("ordenar");
        if (ordenar == null || ordenar.isEmpty()) {
            ordenar = "relevancia";
        }
        String q = request.getParameter("q");
        String filtro = (q != null) ? q.trim().toLowerCase() : "";

        Map<Integer, Integer> contagemCategoria = new HashMap<Integer, Integer>();
        int emEstoque = 0;
        for (Produto p : todos) {
            contagemCategoria.merge(p.getCategoriaId(), 1, Integer::sum);
            if (p.getQuantidade() > 0) {
                emEstoque++;
            }
        }

        List<Produto> produtos = new ArrayList<Produto>();
        for (Produto p : todos) {
            if (!filtro.isEmpty() && !p.getNome().toLowerCase().contains(filtro)) {
                continue;
            }
            if (!selCategorias.isEmpty() && !selCategorias.contains(p.getCategoriaId())) {
                continue;
            }
            if (!precoNaFaixa(p.getPreco(), selFaixas)) {
                continue;
            }
            if (somenteEstoque && p.getQuantidade() <= 0) {
                continue;
            }
            produtos.add(p);
        }

        ordenarLista(produtos, ordenar);

        Set<Integer> favIds = new HashSet<Integer>();
        Object u = request.getSession().getAttribute("usuario");
        if (u instanceof Usuario) {
            favIds = new FavoritoDAO().idsFavoritos(((Usuario) u).getId());
        }

        request.setAttribute("produtos", produtos);
        request.setAttribute("categorias", categorias);
        request.setAttribute("contagemCategoria", contagemCategoria);
        request.setAttribute("totalGeral", todos.size());
        request.setAttribute("emEstoque", emEstoque);
        request.setAttribute("totalEncontrados", produtos.size());
        request.setAttribute("favIds", favIds);
        request.setAttribute("selCategorias", selCategorias);
        request.setAttribute("selFaixas", selFaixas);
        request.setAttribute("somenteEstoque", somenteEstoque);
        request.setAttribute("ordenar", ordenar);
        request.setAttribute("q", q != null ? q : "");

        request.getRequestDispatcher("/loja.jsp").forward(request, response);
    }

    private boolean precoNaFaixa(double preco, Set<String> faixas) {
        if (faixas.isEmpty()) {
            return true;
        }
        for (String f : faixas) {
            try {
                if (f.endsWith("+")) {
                    double min = Double.parseDouble(f.substring(0, f.length() - 1));
                    if (preco >= min) {
                        return true;
                    }
                } else {
                    String[] mm = f.split("-");
                    double min = Double.parseDouble(mm[0]);
                    double max = Double.parseDouble(mm[1]);
                    if (preco >= min && preco < max) {
                        return true;
                    }
                }
            } catch (Exception ignore) {
            }
        }
        return false;
    }

    private void ordenarLista(List<Produto> produtos, String ordenar) {
        switch (ordenar) {
            case "menor":
                produtos.sort(Comparator.comparingDouble(Produto::getPreco));
                break;
            case "maior":
                produtos.sort(Comparator.comparingDouble(Produto::getPreco).reversed());
                break;
            case "nome":
                produtos.sort(Comparator.comparing(p -> p.getNome().toLowerCase()));
                break;
            default:
                produtos.sort(Comparator.comparing((Produto p) -> p.getQuantidade() <= 0));
        }
    }

    private Set<Integer> paraInts(String[] valores) {
        Set<Integer> set = new HashSet<Integer>();
        if (valores != null) {
            for (String v : valores) {
                try {
                    set.add(Integer.parseInt(v.trim()));
                } catch (Exception ignore) {
                }
            }
        }
        return set;
    }

    private Set<String> paraSet(String[] valores) {
        Set<String> set = new HashSet<String>();
        if (valores != null) {
            for (String v : valores) {
                if (v != null && !v.trim().isEmpty()) {
                    set.add(v.trim());
                }
            }
        }
        return set;
    }
}
