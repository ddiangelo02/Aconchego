<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.LinhaRelatorio"%>
<%!
    String moeda(double v) { return "R$ " + String.format("%.2f", v).replace('.', ','); }
%>
<%
    pageContext.setAttribute("paginaAtiva", "relatorios");
    pageContext.setAttribute("tituloPagina", "Relatórios Gerenciais");

    double faturamento = (Double) request.getAttribute("faturamento");
    int totalPedidos = (Integer) request.getAttribute("totalPedidos");
    long itensVendidos = (Long) request.getAttribute("itensVendidos");
    double ticketMedio = (Double) request.getAttribute("ticketMedio");
    int totalProdutos = (Integer) request.getAttribute("totalProdutos");
    int semEstoque = (Integer) request.getAttribute("semEstoque");
    int totalUsuarios = (Integer) request.getAttribute("totalUsuarios");
    List<LinhaRelatorio> maisVendidos = (List<LinhaRelatorio>) request.getAttribute("maisVendidos");
    List<LinhaRelatorio> porPagamento = (List<LinhaRelatorio>) request.getAttribute("porPagamento");
    List<LinhaRelatorio> topClientes = (List<LinhaRelatorio>) request.getAttribute("topClientes");
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

                    <div class="flex items-center justify-between mb-6">
                        <p class="font-body text-brand-brown-medium">Indicadores de vendas e desempenho da loja.</p>
                        <a href="${pageContext.request.contextPath}/admin/relatorios?pdf=1" target="_blank"
                           class="flex items-center gap-2 bg-brand-brown-footer hover:bg-brand-button-hover text-white font-body font-medium px-5 py-2.5 rounded-xl shadow-md transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M12 10v6m0 0l-3-3m3 3l3-3M4 6a2 2 0 012-2h8l6 6v6a2 2 0 01-2 2H6a2 2 0 01-2-2V6z"></path></svg>
                            Exportar PDF
                        </a>
                    </div>

                    <%-- Indicadores principais --%>
                    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-6 mb-8">
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6">
                            <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Faturamento total</p>
                            <p class="font-heading text-3xl font-bold text-brand-green-btn"><%= moeda(faturamento) %></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6">
                            <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Pedidos</p>
                            <p class="font-heading text-3xl font-bold text-brand-brown-footer"><%= totalPedidos %></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6">
                            <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Itens vendidos</p>
                            <p class="font-heading text-3xl font-bold text-brand-brown-footer"><%= itensVendidos %></p>
                        </div>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6">
                            <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Ticket médio</p>
                            <p class="font-heading text-3xl font-bold text-brand-brown-footer"><%= moeda(ticketMedio) %></p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-8">
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 flex items-center justify-between">
                            <span class="font-body text-brand-brown-medium">Produtos cadastrados</span>
                            <span class="font-heading text-2xl font-bold text-brand-brown-footer"><%= totalProdutos %></span>
                        </div>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 flex items-center justify-between">
                            <span class="font-body text-brand-brown-medium">Produtos sem estoque</span>
                            <span class="font-heading text-2xl font-bold text-red-500"><%= semEstoque %></span>
                        </div>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 flex items-center justify-between">
                            <span class="font-body text-brand-brown-medium">Usuários</span>
                            <span class="font-heading text-2xl font-bold text-brand-brown-footer"><%= totalUsuarios %></span>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

                        <%-- Produtos mais vendidos --%>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark overflow-hidden lg:col-span-2">
                            <h3 class="font-heading text-lg font-bold text-brand-brown-footer px-6 py-4 border-b border-brand-cream-dark">Produtos mais vendidos</h3>
                            <table class="w-full text-left">
                                <thead>
                                    <tr class="font-body text-xs uppercase tracking-wide text-brand-brown-medium border-b border-brand-cream-dark">
                                        <th class="px-6 py-2 font-bold">Produto</th>
                                        <th class="px-6 py-2 font-bold">Qtd. vendida</th>
                                        <th class="px-6 py-2 font-bold text-right">Receita</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-brand-cream-dark">
                                    <% if (maisVendidos == null || maisVendidos.isEmpty()) { %>
                                    <tr><td colspan="3" class="px-6 py-8 text-center font-body text-brand-brown-medium">Nenhuma venda registrada.</td></tr>
                                    <% } else { for (LinhaRelatorio l : maisVendidos) { %>
                                    <tr>
                                        <td class="px-6 py-2.5 font-body font-bold text-brand-brown-footer"><%= l.getRotulo() %></td>
                                        <td class="px-6 py-2.5 font-body text-brand-brown-medium"><%= l.getQuantidade() %></td>
                                        <td class="px-6 py-2.5 font-body font-bold text-brand-green-btn text-right"><%= moeda(l.getValor()) %></td>
                                    </tr>
                                    <% } } %>
                                </tbody>
                            </table>
                        </div>

                        <%-- Por forma de pagamento --%>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark overflow-hidden">
                            <h3 class="font-heading text-lg font-bold text-brand-brown-footer px-6 py-4 border-b border-brand-cream-dark">Faturamento por forma de pagamento</h3>
                            <table class="w-full text-left">
                                <thead>
                                    <tr class="font-body text-xs uppercase tracking-wide text-brand-brown-medium border-b border-brand-cream-dark">
                                        <th class="px-6 py-2 font-bold">Forma</th>
                                        <th class="px-6 py-2 font-bold">Pedidos</th>
                                        <th class="px-6 py-2 font-bold text-right">Total</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-brand-cream-dark">
                                    <% if (porPagamento == null || porPagamento.isEmpty()) { %>
                                    <tr><td colspan="3" class="px-6 py-8 text-center font-body text-brand-brown-medium">Sem dados.</td></tr>
                                    <% } else { for (LinhaRelatorio l : porPagamento) { %>
                                    <tr>
                                        <td class="px-6 py-2.5 font-body font-bold text-brand-brown-footer"><%= l.getRotulo() %></td>
                                        <td class="px-6 py-2.5 font-body text-brand-brown-medium"><%= l.getQuantidade() %></td>
                                        <td class="px-6 py-2.5 font-body font-bold text-brand-green-btn text-right"><%= moeda(l.getValor()) %></td>
                                    </tr>
                                    <% } } %>
                                </tbody>
                            </table>
                        </div>

                        <%-- Top clientes --%>
                        <div class="bg-white rounded-2xl border border-brand-cream-dark overflow-hidden">
                            <h3 class="font-heading text-lg font-bold text-brand-brown-footer px-6 py-4 border-b border-brand-cream-dark">Clientes que mais compraram</h3>
                            <table class="w-full text-left">
                                <thead>
                                    <tr class="font-body text-xs uppercase tracking-wide text-brand-brown-medium border-b border-brand-cream-dark">
                                        <th class="px-6 py-2 font-bold">Cliente</th>
                                        <th class="px-6 py-2 font-bold">Pedidos</th>
                                        <th class="px-6 py-2 font-bold text-right">Total gasto</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-brand-cream-dark">
                                    <% if (topClientes == null || topClientes.isEmpty()) { %>
                                    <tr><td colspan="3" class="px-6 py-8 text-center font-body text-brand-brown-medium">Sem dados.</td></tr>
                                    <% } else { for (LinhaRelatorio l : topClientes) { %>
                                    <tr>
                                        <td class="px-6 py-2.5 font-body font-bold text-brand-brown-footer"><%= l.getRotulo() %></td>
                                        <td class="px-6 py-2.5 font-body text-brand-brown-medium"><%= l.getQuantidade() %></td>
                                        <td class="px-6 py-2.5 font-body font-bold text-brand-green-btn text-right"><%= moeda(l.getValor()) %></td>
                                    </tr>
                                    <% } } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </body>
</html>
