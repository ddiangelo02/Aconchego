package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Categoria;
import com.ddiangelo.aconchego.modelo.CategoriaDAO;
import com.ddiangelo.aconchego.modelo.Produto;
import com.ddiangelo.aconchego.modelo.ProdutoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminProdutoServlet", urlPatterns = {"/admin/produtos"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class AdminProdutoServlet extends HttpServlet {

    private static final String PASTA_UPLOAD = "/images/produtos";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdutoDAO produtoDAO = new ProdutoDAO();
        CategoriaDAO categoriaDAO = new CategoriaDAO();

        String busca = request.getParameter("q");
        String filtro = (busca != null) ? busca.trim().toLowerCase() : "";

        List<Produto> todos = produtoDAO.obterTodos();
        if (todos == null) {
            todos = new ArrayList<Produto>();
        }

        List<Produto> produtos = new ArrayList<Produto>();
        for (Produto p : todos) {
            String cat = (p.getCategoriaNome() == null) ? "" : p.getCategoriaNome();
            if (filtro.isEmpty()
                    || p.getNome().toLowerCase().contains(filtro)
                    || cat.toLowerCase().contains(filtro)) {
                produtos.add(p);
            }
        }

        List<Categoria> categorias = categoriaDAO.obterTodos();
        if (categorias == null) {
            categorias = new ArrayList<Categoria>();
        }

        request.setAttribute("produtos", produtos);
        request.setAttribute("categorias", categorias);
        request.setAttribute("busca", busca != null ? busca : "");
        request.getRequestDispatcher("/admin/produtos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProdutoDAO produtoDAO = new ProdutoDAO();
        HttpSession session = request.getSession();
        String acao = request.getParameter("acao");
        String contexto = request.getContextPath();

        try {
            if ("excluir".equals(acao)) {

                int id = parseInt(request.getParameter("id"), -1);
                boolean ok = produtoDAO.removerProduto(id);
                session.setAttribute("mensagem", ok ? "Produto excluído com sucesso." : "Não foi possível excluir o produto (verifique pedidos vinculados).");
                session.setAttribute("status", ok ? "sucesso" : "erro");

            } else {

                int id = parseInt(request.getParameter("id"), -1);
                String nome = trim(request.getParameter("nome"));
                String descricao = trim(request.getParameter("descricao"));
                String foto = trim(request.getParameter("foto"));
                int categoriaId = parseInt(request.getParameter("categoriaId"), 0);

                String fotoUpload = salvarImagem(request);
                if (fotoUpload != null) {
                    foto = fotoUpload;
                }
                double preco = parseDouble(request.getParameter("preco"), -1);
                int quantidade = parseInt(request.getParameter("quantidade"), -1);

                if (nome.isEmpty() || preco < 0 || quantidade < 0) {
                    throw new IllegalArgumentException("Preencha nome, preço e estoque válidos.");
                }

                boolean ok;
                if (id > 0) {
                    ok = produtoDAO.atualizarProduto(nome, descricao, preco, foto, quantidade, categoriaId, id);
                    session.setAttribute("mensagem", ok ? "Produto atualizado com sucesso." : "Não foi possível atualizar o produto.");
                } else {
                    int novoId = produtoDAO.inserirEObterId(nome, descricao, preco, foto, quantidade, categoriaId);
                    ok = novoId > 0;
                    session.setAttribute("mensagem", ok ? "Produto adicionado com sucesso." : "Não foi possível adicionar o produto.");
                }
                session.setAttribute("status", ok ? "sucesso" : "erro");
            }
        } catch (IllegalArgumentException ex) {
            session.setAttribute("mensagem", ex.getMessage());
            session.setAttribute("status", "erro");
        }

        response.sendRedirect(contexto + "/admin/produtos");
    }

    private String salvarImagem(HttpServletRequest request) {
        try {
            Part parte = request.getPart("imagem");
            if (parte == null || parte.getSize() == 0) {
                return null;
            }
            String contentType = parte.getContentType();
            if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                return null;
            }

            String enviado = parte.getSubmittedFileName();
            String ext = "";
            if (enviado != null && enviado.contains(".")) {
                ext = enviado.substring(enviado.lastIndexOf('.')).toLowerCase();
            } else {
                ext = "." + contentType.substring(contentType.indexOf('/') + 1);
            }
            String nomeUnico = "prod_" + System.currentTimeMillis() + ext;

            String pastaReal = getServletContext().getRealPath(PASTA_UPLOAD);
            if (pastaReal == null) {
                return null;
            }
            File pasta = new File(pastaReal);
            if (!pasta.exists()) {
                pasta.mkdirs();
            }

            try (InputStream in = parte.getInputStream()) {
                Files.copy(in, Paths.get(pastaReal, nomeUnico), StandardCopyOption.REPLACE_EXISTING);
            }

            return request.getContextPath() + PASTA_UPLOAD + "/" + nomeUnico;

        } catch (Exception ex) {
            System.out.println("Falha no upload da imagem do produto: " + ex.getMessage());
            return null;
        }
    }

    private static String trim(String v) {
        return v == null ? "" : v.trim();
    }

    private static int parseInt(String v, int padrao) {
        try {
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return padrao;
        }
    }

    private static double parseDouble(String v, double padrao) {
        try {
            return Double.parseDouble(v.trim().replace(',', '.'));
        } catch (Exception e) {
            return padrao;
        }
    }
}
