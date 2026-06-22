<%@tag description="Card de produto padronizado (estoque, favoritar, carrinho)" pageEncoding="UTF-8" body-content="empty" %>
<%@tag import="com.ddiangelo.aconchego.modelo.Produto" %>
<%@attribute name="produto" required="true" type="com.ddiangelo.aconchego.modelo.Produto" %>
<%@attribute name="origem" required="false" type="java.lang.String" %>
<%@attribute name="favorito" required="false" type="java.lang.Boolean" %>
<%
    String ctx = request.getContextPath();

    boolean esgotado = produto.getQuantidade() <= 0;
    boolean fav = (favorito != null && favorito);
    String org = (origem == null || origem.isEmpty()) ? "/loja" : origem;
    String preco = String.format("R$ %.2f", produto.getPreco()).replace('.', ',');
    String foto = (produto.getFoto() == null) ? "" : produto.getFoto();
%>
<div class="card-product bg-white w-full <%= esgotado ? "" : "" %>">
    <a href="<%= ctx %>/produto?id=<%= produto.getId() %>" class="block w-full">
        <div class="card-product-image-wrapper relative flex items-center justify-center">
            <% if (!foto.isEmpty()) { %>
            <img src="<%= foto %>" alt="<%= produto.getNome() %>" class="w-full h-full object-cover <%= esgotado ? "saturate-0 opacity-60" : "" %>">
            <% } else { %>
            <svg class="w-10 h-10 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
            <% } %>
            <% if (esgotado) { %>
            <div class="absolute inset-0 flex items-center justify-center bg-black/10 pointer-events-none">
                <span class="bg-black/50 text-white text-sm font-bold uppercase tracking-wider px-3 py-1.5 rounded shadow-md">Esgotado</span>
            </div>
            <% } %>
        </div>
        <h3 class="card-product-title <%= esgotado ? "!text-gray-600" : "" %>"><%= produto.getNome() %></h3>
        <p class="card-product-value <%= esgotado ? "!text-gray-500" : "" %>"><%= preco %></p>
    </a>

    <form action="<%= ctx %>/favoritos" method="POST" class="absolute top-3 right-3">
        <input type="hidden" name="acao" value="<%= fav ? "remover" : "adicionar" %>">
        <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
        <input type="hidden" name="origem" value="<%= org %>">
        <button type="submit" title="<%= fav ? "Remover dos favoritos" : "Favoritar" %>"
                class="w-9 h-9 flex items-center justify-center rounded-full bg-white/90 shadow-sm transition-colors <%= fav ? "text-red-500" : "text-brand-brown-medium hover:text-red-500" %>">
            <span class="material-symbols-rounded text-xl" style="<%= fav ? "font-variation-settings:'FILL' 1;" : "" %>">favorite</span>
        </button>
    </form>

    <% if (!esgotado) { %>
    <form action="<%= ctx %>/carrinho" method="POST" class="absolute bottom-4 right-4">
        <input type="hidden" name="acao" value="adicionar">
        <input type="hidden" name="produtoId" value="<%= produto.getId() %>">
        <button type="submit" title="Adicionar ao carrinho" class="bg-brand-button hover:bg-brand-button-hover text-white p-2 rounded-full shadow-sm transition-colors">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
        </button>
    </form>
    <% } else { %>
    <div class="absolute bottom-4 right-4">
        <button type="button" disabled class="bg-gray-200 text-gray-400 p-2 rounded-full cursor-not-allowed">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
        </button>
    </div>
    <% } %>
</div>
