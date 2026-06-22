<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%@page import="com.ddiangelo.aconchego.modelo.Categoria"%>
<%@taglib prefix="ac" tagdir="/WEB-INF/tags" %>
<%
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    Map<Integer, Integer> contagemCategoria = (Map<Integer, Integer>) request.getAttribute("contagemCategoria");
    int totalGeral = (Integer) request.getAttribute("totalGeral");
    int emEstoque = (Integer) request.getAttribute("emEstoque");
    int totalEncontrados = (Integer) request.getAttribute("totalEncontrados");
    Set<Integer> favIds = (Set<Integer>) request.getAttribute("favIds");
    Set<Integer> selCategorias = (Set<Integer>) request.getAttribute("selCategorias");
    Set<String> selFaixas = (Set<String>) request.getAttribute("selFaixas");
    boolean somenteEstoque = (Boolean) request.getAttribute("somenteEstoque");
    String ordenar = (String) request.getAttribute("ordenar");
    String q = (String) request.getAttribute("q");

    String[][] faixas = {
        {"0-25", "Até R$ 25"},
        {"25-50", "R$ 25 a R$ 50"},
        {"50-100", "R$ 50 a R$ 100"},
        {"100-200", "R$ 100 a R$ 200"},
        {"200+", "Acima de R$ 200"}
    };
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='WEB-INF/includes/head.jsp' %>
    </head>
    <body>
        <%@ include file='WEB-INF/includes/header.jsp' %>
        <main>
            <section class="section-container mt-8">
                <h1 class="title-section">Nossa Loja</h1>

                <form action="${pageContext.request.contextPath}/loja" method="GET">
                    <div class="grid grid-cols-1 lg:grid-cols-4 gap-8 items-start">

                        <aside class="lg:col-span-1 bg-brand-cream-light rounded-3xl p-6 border border-brand-cream-dark lg:sticky lg:top-6">
                            <h2 class="font-heading text-2xl text-brand-brown-footer font-bold mb-5">Filtrar por</h2>

                            <div class="mb-6">
                                <div class="relative">
                                    <span class="absolute left-3 top-1/2 -translate-y-1/2 text-brand-brown-medium">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z"></path></svg>
                                    </span>
                                    <input type="text" name="q" value="<%= q == null ? "" : q %>" placeholder="Buscar..."
                                           class="w-full bg-white border border-brand-cream-dark rounded-full pl-9 pr-4 py-2 text-sm font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                                </div>
                            </div>

                            <div class="mb-6">
                                <h3 class="font-body font-bold text-brand-brown-dark uppercase text-sm tracking-wide mb-3">Categorias</h3>
                                <% if (categorias == null || categorias.isEmpty()) { %>
                                <p class="text-sm text-brand-brown-medium font-body">Nenhuma categoria.</p>
                                <% } else {
                                       for (Categoria c : categorias) {
                                           int cont = (contagemCategoria != null) ? contagemCategoria.getOrDefault(c.getId(), 0) : 0;
                                           boolean marcado = selCategorias != null && selCategorias.contains(c.getId()); %>
                                <label class="flex items-center justify-between gap-2 py-1.5 cursor-pointer font-body text-brand-brown-footer">
                                    <span class="flex items-center gap-2">
                                        <input type="checkbox" name="categoria" value="<%= c.getId() %>" <%= marcado ? "checked" : "" %> class="w-4 h-4 accent-brand-green-btn">
                                        <%= c.getNome() %>
                                    </span>
                                    <span class="text-xs text-brand-brown-medium">(<%= cont %>)</span>
                                </label>
                                <%     }
                                   } %>
                            </div>

                            <div class="mb-6">
                                <h3 class="font-body font-bold text-brand-brown-dark uppercase text-sm tracking-wide mb-3">Faixa de preço</h3>
                                <% for (String[] f : faixas) {
                                       boolean marcado = selFaixas != null && selFaixas.contains(f[0]); %>
                                <label class="flex items-center gap-2 py-1.5 cursor-pointer font-body text-brand-brown-footer">
                                    <input type="checkbox" name="faixa" value="<%= f[0] %>" <%= marcado ? "checked" : "" %> class="w-4 h-4 accent-brand-green-btn">
                                    <%= f[1] %>
                                </label>
                                <% } %>
                            </div>

                            <div class="mb-6">
                                <h3 class="font-body font-bold text-brand-brown-dark uppercase text-sm tracking-wide mb-3">Disponibilidade</h3>
                                <label class="flex items-center justify-between gap-2 py-1.5 cursor-pointer font-body text-brand-brown-footer">
                                    <span class="flex items-center gap-2">
                                        <input type="checkbox" name="disp" value="estoque" <%= somenteEstoque ? "checked" : "" %> class="w-4 h-4 accent-brand-green-btn">
                                        Somente em estoque
                                    </span>
                                    <span class="text-xs text-brand-brown-medium">(<%= emEstoque %>)</span>
                                </label>
                            </div>

                            <button type="submit" class="btn-green w-full !py-2.5">Aplicar filtros</button>
                            <a href="${pageContext.request.contextPath}/loja" class="block text-center mt-3 font-body text-sm text-brand-brown-medium hover:text-brand-brown-footer">Limpar filtros</a>
                        </aside>

                        <div class="lg:col-span-3">
                            <div class="flex flex-wrap items-center justify-between gap-3 border-b border-brand-cream-dark pb-4 mb-6">
                                <p class="font-body text-brand-brown-medium"><strong class="text-brand-brown-footer"><%= totalEncontrados %></strong> de <%= totalGeral %> produto(s) encontrado(s)</p>
                                <label class="flex items-center gap-2 font-body text-sm text-brand-brown-medium">
                                    ordenar por:
                                    <select name="ordenar" onchange="this.form.submit()"
                                            class="bg-white border border-brand-cream-dark rounded-full px-4 py-1.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <option value="relevancia" <%= "relevancia".equals(ordenar) ? "selected" : "" %>>mais relevantes</option>
                                        <option value="menor" <%= "menor".equals(ordenar) ? "selected" : "" %>>menor preço</option>
                                        <option value="maior" <%= "maior".equals(ordenar) ? "selected" : "" %>>maior preço</option>
                                        <option value="nome" <%= "nome".equals(ordenar) ? "selected" : "" %>>nome (A-Z)</option>
                                    </select>
                                </label>
                            </div>

                            <% if (produtos == null || produtos.isEmpty()) { %>
                            <div class="bg-brand-cream-light rounded-3xl p-12 text-center">
                                <p class="font-body text-brand-brown-medium">Nenhum produto encontrado com esses filtros.</p>
                                <a href="${pageContext.request.contextPath}/loja" class="inline-block mt-4 btn-brown">Limpar filtros</a>
                            </div>
                            <% } else { %>
                            <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-card-gap">
                                <% for (Produto p : produtos) {
                                       boolean fav = favIds != null && favIds.contains(p.getId()); %>
                                <ac:card-produto produto="<%= p %>" origem="/loja" favorito="<%= fav %>" />
                                <% } %>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </form>
            </section>
        </main>
        <%@ include file='WEB-INF/includes/footer.jsp' %>
    </body>
</html>
