<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%
    pageContext.setAttribute("paginaAtiva", "estoque");
    pageContext.setAttribute("tituloPagina", "Estoque");

    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
    String busca = (String) request.getAttribute("busca");

    String mensagem = (String) session.getAttribute("mensagem");
    String statusMsg = (String) session.getAttribute("status");
    if (mensagem != null) { session.removeAttribute("mensagem"); session.removeAttribute("status"); }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='/WEB-INF/includes/head.jsp' %>
    </head>
    <body class="bg-brand-cream-lightener">
        <div class="flex min-h-screen">
            <%@ include file='/WEB-INF/includes/admin-sidebar.jsp' %>
            <div class="flex-1 flex flex-col min-w-0">
                <%@ include file='/WEB-INF/includes/admin-header.jsp' %>
                <main class="flex-1 p-8">

                    <% if (mensagem != null) {
                           boolean ok = "sucesso".equals(statusMsg); %>
                    <div class="mb-6 px-4 py-3 rounded-xl border <%= ok ? "bg-green-100 border-green-400 text-green-700" : "bg-red-100 border-red-400 text-red-700" %>" role="alert">
                        <strong class="font-bold"><%= ok ? "Sucesso!" : "Erro!" %></strong>
                        <span class="ml-1"><%= mensagem %></span>
                    </div>
                    <% } %>

                    <div class="flex flex-col sm:flex-row gap-4 sm:items-center sm:justify-between mb-6">
                        <p class="font-body text-brand-brown-medium">Ajuste a quantidade em estoque de cada produto e salve.</p>
                        <form action="${pageContext.request.contextPath}/admin/estoque" method="GET" class="relative w-full sm:max-w-xs">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-brand-brown-medium">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z"></path></svg>
                            </span>
                            <input type="text" name="q" value="<%= busca == null ? "" : busca %>" placeholder="Buscar produto..."
                                   class="w-full bg-white border border-brand-cream-dark rounded-full pl-11 pr-5 py-3 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </form>
                    </div>

                    <div class="bg-white rounded-2xl border border-brand-cream-dark overflow-hidden">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="border-b border-brand-cream-dark font-body text-sm uppercase tracking-wide text-brand-brown-medium">
                                    <th class="px-6 py-4 font-bold">Produto</th>
                                    <th class="px-6 py-4 font-bold">Quantidade</th>
                                    <th class="px-6 py-4 font-bold">Situação</th>
                                    <th class="px-6 py-4 font-bold">Nova quantidade</th>
                                    <th class="px-6 py-4 font-bold text-right">Ação</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-brand-cream-dark">
                                <% if (produtos == null || produtos.isEmpty()) { %>
                                <tr><td colspan="4" class="px-6 py-10 text-center font-body text-brand-brown-medium">Nenhum produto cadastrado.</td></tr>
                                <% } else {
                                       for (Produto p : produtos) {
                                           int q = p.getQuantidade();
                                           String badge; String texto;
                                           if (q == 0) { badge = "bg-red-100 text-red-600"; texto = "Esgotado"; }
                                           else if (q <= 5) { badge = "bg-amber-100 text-amber-700"; texto = "Últimas unidades"; }
                                           else { badge = "bg-green-100 text-green-700"; texto = "Disponível"; }
                                %>
                                <tr class="hover:bg-brand-cream-lightener/60">
                                    <td class="px-6 py-4 font-body font-bold text-brand-brown-footer"><%= p.getNome() %></td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-full px-3 py-1 text-sm font-bold"><%= p.getQuantidade() %></span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-full px-3 py-1 text-sm font-bold <%= badge %>"><%= texto %></span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <form action="${pageContext.request.contextPath}/admin/estoque" method="POST" class="flex items-center gap-3" id="form-estoque-<%= p.getId() %>">
                                            <input type="hidden" name="id" value="<%= p.getId() %>">
                                            <input type="number" name="quantidade" min="0" value="<%= q %>"
                                                   class="w-28 bg-white border border-brand-cream-dark rounded-xl px-3 py-2 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                                        </form>
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <button type="submit" form="form-estoque-<%= p.getId() %>"
                                                class="bg-brand-button hover:bg-brand-button-hover text-white font-body font-medium px-4 py-2 rounded-xl shadow-sm transition-colors">
                                            Salvar
                                        </button>
                                    </td>
                                </tr>
                                <%     }
                                   } %>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>
