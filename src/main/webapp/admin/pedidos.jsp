<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Pedido"%>
<%@page import="com.ddiangelo.aconchego.modelo.PedidoItem"%>
<%
    pageContext.setAttribute("paginaAtiva", "pedidos");
    pageContext.setAttribute("tituloPagina", "Pedidos");

    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
    double totalGeral = (Double) request.getAttribute("totalGeral");
    String totalFmt = String.format("R$ %.2f", totalGeral).replace('.', ',');
    String busca = (String) request.getAttribute("busca");
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

                    <div class="flex flex-col sm:flex-row gap-4 sm:items-center sm:justify-between mb-6">
                        <form action="${pageContext.request.contextPath}/admin/pedidos" method="GET" class="relative w-full sm:max-w-md">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-brand-brown-medium">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z"></path></svg>
                            </span>
                            <input type="text" name="q" value="<%= busca == null ? "" : busca %>" placeholder="Buscar por cliente, produto ou nº do pedido..."
                                   class="w-full bg-white border border-brand-cream-dark rounded-full pl-11 pr-5 py-3 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </form>
                        <div class="bg-white border border-brand-cream-dark rounded-xl px-5 py-3 whitespace-nowrap">
                            <span class="font-body text-sm text-brand-brown-medium">Total faturado: </span>
                            <span class="font-body font-bold text-brand-green-btn"><%= totalFmt %></span>
                        </div>
                    </div>

                    <% if (pedidos == null || pedidos.isEmpty()) { %>
                    <div class="bg-white rounded-2xl border border-brand-cream-dark p-10 text-center font-body text-brand-brown-medium">
                        Nenhum pedido encontrado.
                    </div>
                    <% } else {
                           for (Pedido p : pedidos) {
                               String dataFmt = (p.getDataHora() != null) ? p.getDataHora().toString() : "";
                               String totalPedido = String.format("R$ %.2f", p.getTotal()).replace('.', ','); %>
                    <div class="bg-white rounded-2xl border border-brand-cream-dark mb-4 overflow-hidden">

                        <div class="flex flex-wrap items-center justify-between gap-3 px-6 py-4 bg-brand-cream-lightener/60 border-b border-brand-cream-dark">
                            <div>
                                <span class="font-heading text-lg font-bold text-brand-brown-footer">Pedido #<%= p.getId() %></span>
                                <span class="font-body text-sm text-brand-brown-medium ml-3"><%= p.getUsuarioNome() %></span>
                            </div>
                            <div class="flex items-center gap-4">
                                <span class="font-body text-sm text-brand-brown-medium"><%= dataFmt %></span>
                                <span class="inline-flex items-center rounded-full bg-brand-cream-dark px-3 py-1 text-xs font-bold text-brand-brown-footer"><%= p.getFormaPagamento() %></span>
                            </div>
                        </div>

                        <table class="w-full text-left">
                            <thead>
                                <tr class="font-body text-xs uppercase tracking-wide text-brand-brown-medium border-b border-brand-cream-dark">
                                    <th class="px-6 py-2 font-bold">Produto</th>
                                    <th class="px-6 py-2 font-bold">Qtd.</th>
                                    <th class="px-6 py-2 font-bold">Preço unit.</th>
                                    <th class="px-6 py-2 font-bold text-right">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-brand-cream-dark">
                                <% for (PedidoItem it : p.getItens()) {
                                       String precoU = String.format("R$ %.2f", it.getPrecoUnitario()).replace('.', ',');
                                       String sub = String.format("R$ %.2f", it.getSubtotal()).replace('.', ','); %>
                                <tr>
                                    <td class="px-6 py-2 font-body font-bold text-brand-brown-footer"><%= it.getProdutoNome() %></td>
                                    <td class="px-6 py-2 font-body text-brand-brown-medium"><%= it.getQuantidade() %></td>
                                    <td class="px-6 py-2 font-body text-brand-brown-medium"><%= precoU %></td>
                                    <td class="px-6 py-2 font-body font-bold text-brand-brown-footer text-right"><%= sub %></td>
                                </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr class="border-t border-brand-cream-dark">
                                    <td colspan="3" class="px-6 py-3 font-body text-sm text-brand-brown-medium text-right">Total do pedido</td>
                                    <td class="px-6 py-3 font-body font-bold text-brand-green-btn text-right"><%= totalPedido %></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <%     }
                       } %>
                </main>
            </div>
        </div>
    </body>
</html>
