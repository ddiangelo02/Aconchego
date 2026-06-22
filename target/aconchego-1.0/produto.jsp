<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%
    Produto p = (Produto) request.getAttribute("produto");
    boolean favorito = Boolean.TRUE.equals(request.getAttribute("favorito"));
    String preco = String.format("R$ %.2f", p.getPreco()).replace('.', ',');
    String foto = (p.getFoto() == null) ? "" : p.getFoto();
    String descricao = (p.getDescricao() == null || p.getDescricao().trim().isEmpty()) ? "Produto artesanal feito com muito carinho." : p.getDescricao();
    boolean disponivel = p.getQuantidade() > 0;
    String origem = "/produto?id=" + p.getId();
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='WEB-INF/includes/head.jsp' %>
    </head>
    <body>
        <%@ include file='WEB-INF/includes/header.jsp' %>
        <main>
            <section class="section-container mt-8 max-w-5xl">
                <a href="${pageContext.request.contextPath}/loja" class="inline-block mb-6 font-body text-brand-brown-medium hover:text-brand-brown-footer">← Voltar à loja</a>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-10 items-start">

                    <div class="w-full aspect-square rounded-3xl bg-brand-cream-light overflow-hidden flex items-center justify-center shadow-sm">
                        <% if (!foto.isEmpty()) { %>
                        <img src="<%= foto %>" alt="<%= p.getNome() %>" class="w-full h-full object-cover <%= disponivel ? "" : "saturate-0 opacity-60" %>">
                        <% } else { %>
                        <svg class="w-20 h-20 text-brand-cream-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <% } %>
                    </div>

                    <div>
                        <% if (p.getCategoriaNome() != null && !p.getCategoriaNome().isEmpty()) { %>
                        <span class="inline-flex items-center rounded-full bg-brand-cream-dark px-3 py-1 text-xs font-bold text-brand-brown-footer mb-3"><%= p.getCategoriaNome() %></span>
                        <% } %>
                        <h1 class="font-heading text-4xl text-brand-brown-footer font-bold mb-3"><%= p.getNome() %></h1>
                        <p class="font-body text-price text-brand-brown-footer font-bold mb-4"><%= preco %></p>

                        <p class="font-body text-brand-brown-medium leading-relaxed mb-6"><%= descricao %></p>

                        <p class="font-body text-sm mb-6 <%= disponivel ? "text-brand-green-btn" : "text-red-500" %>">
                            <%= disponivel ? (p.getQuantidade() + " em estoque") : "Produto esgotado" %>
                        </p>

                        <div class="flex items-center gap-3">
                            <% if (disponivel) { %>
                            <form action="${pageContext.request.contextPath}/carrinho" method="POST">
                                <input type="hidden" name="acao" value="adicionar">
                                <input type="hidden" name="produtoId" value="<%= p.getId() %>">
                                <button type="submit" class="btn-green text-lg px-8 flex items-center gap-2">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                                    Adicionar ao carrinho
                                </button>
                            </form>
                            <% } else { %>
                            <span class="btn-base bg-gray-200 text-gray-500 cursor-not-allowed">Indisponível</span>
                            <% } %>

                            <form action="${pageContext.request.contextPath}/favoritos" method="POST">
                                <input type="hidden" name="acao" value="<%= favorito ? "remover" : "adicionar" %>">
                                <input type="hidden" name="produtoId" value="<%= p.getId() %>">
                                <input type="hidden" name="origem" value="<%= origem %>">
                                <button type="submit" title="<%= favorito ? "Remover dos favoritos" : "Adicionar aos favoritos" %>"
                                        class="w-12 h-12 flex items-center justify-center rounded-full border border-brand-cream-dark hover:bg-brand-cream-light transition-colors <%= favorito ? "text-red-500" : "text-brand-brown-medium" %>">
                                    <span class="material-symbols-rounded text-3xl" style="<%= favorito ? "font-variation-settings:'FILL' 1;" : "" %>">favorite</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <%@ include file='WEB-INF/includes/footer.jsp' %>
    </body>
</html>
