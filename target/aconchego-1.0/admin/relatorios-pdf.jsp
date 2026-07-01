<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.ddiangelo.aconchego.modelo.LinhaRelatorio"%>
<%!
    String moeda(double v) { return "R$ " + String.format("%.2f", v).replace('.', ','); }
%>
<%
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
    String dataGeracao = new SimpleDateFormat("dd/MM/yyyy 'às' HH:mm").format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='/WEB-INF/includes/head.jsp' %>
        <title>Relatório Gerencial — Aconchegô</title>
        <style>
            body { background: #fff !important; }
            .rel-table { width: 100%; border-collapse: collapse; }
            .rel-table th, .rel-table td { border: 1px solid #EBE0D2; padding: 8px 12px; text-align: left; }
            .rel-table th { background: #FBF8F1; text-transform: uppercase; font-size: 11px; letter-spacing: .04em; }
            .rel-num { text-align: right; }
            @media print {
                .no-print { display: none !important; }
                @page { margin: 1.4cm; }
                .rel-card { break-inside: avoid; }
                table, .rel-block { break-inside: avoid; }
            }
        </style>
    </head>
    <body class="bg-white font-body text-brand-brown-dark">
        <div class="max-w-4xl mx-auto p-8">

            <%-- Cabeçalho com a logo do sistema --%>
            <div class="flex items-center justify-between border-b-2 border-brand-brown-footer pb-4 mb-6">
                <img src="${pageContext.request.contextPath}/images/aconchego-logo.svg" alt="Aconchegô" class="h-14">
                <div class="text-right">
                    <h1 class="font-heading text-3xl text-brand-brown-footer font-bold">Relatório Gerencial</h1>
                    <p class="font-body text-sm text-brand-brown-medium">Gerado em <%= dataGeracao %></p>
                </div>
            </div>

            <div class="no-print mb-6 flex justify-end gap-3">
                <a href="${pageContext.request.contextPath}/admin/relatorios" class="btn-base bg-white border border-brand-cream-dark text-brand-brown-medium">Voltar</a>
                <button onclick="window.print()" class="btn-brown">Imprimir / Salvar como PDF</button>
            </div>

            <%-- Indicadores --%>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mb-8">
                <div class="rel-card border border-brand-cream-dark rounded-xl p-4">
                    <p class="text-xs uppercase text-brand-brown-medium">Faturamento total</p>
                    <p class="font-heading text-2xl font-bold text-brand-green-btn"><%= moeda(faturamento) %></p>
                </div>
                <div class="rel-card border border-brand-cream-dark rounded-xl p-4">
                    <p class="text-xs uppercase text-brand-brown-medium">Pedidos</p>
                    <p class="font-heading text-2xl font-bold text-brand-brown-footer"><%= totalPedidos %></p>
                </div>
                <div class="rel-card border border-brand-cream-dark rounded-xl p-4">
                    <p class="text-xs uppercase text-brand-brown-medium">Itens vendidos</p>
                    <p class="font-heading text-2xl font-bold text-brand-brown-footer"><%= itensVendidos %></p>
                </div>
                <div class="rel-card border border-brand-cream-dark rounded-xl p-4">
                    <p class="text-xs uppercase text-brand-brown-medium">Ticket médio</p>
                    <p class="font-heading text-2xl font-bold text-brand-brown-footer"><%= moeda(ticketMedio) %></p>
                </div>
                <div class="rel-card border border-brand-cream-dark rounded-xl p-4">
                    <p class="text-xs uppercase text-brand-brown-medium">Produtos cadastrados</p>
                    <p class="font-heading text-2xl font-bold text-brand-brown-footer"><%= totalProdutos %></p>
                </div>
                <div class="rel-card border border-brand-cream-dark rounded-xl p-4">
                    <p class="text-xs uppercase text-brand-brown-medium">Produtos sem estoque</p>
                    <p class="font-heading text-2xl font-bold text-red-500"><%= semEstoque %></p>
                </div>
                <div class="rel-card border border-brand-cream-dark rounded-xl p-4">
                    <p class="text-xs uppercase text-brand-brown-medium">Usuários</p>
                    <p class="font-heading text-2xl font-bold text-brand-brown-footer"><%= totalUsuarios %></p>
                </div>
            </div>

            <%-- Detalhamento: produtos mais vendidos --%>
            <div class="rel-block mb-8">
                <h2 class="font-heading text-xl text-brand-brown-footer font-bold mb-3">Produtos mais vendidos</h2>
                <table class="rel-table">
                    <thead><tr><th>Produto</th><th>Qtd. vendida</th><th class="rel-num">Receita</th></tr></thead>
                    <tbody>
                        <% if (maisVendidos == null || maisVendidos.isEmpty()) { %>
                        <tr><td colspan="3">Nenhuma venda registrada.</td></tr>
                        <% } else { for (LinhaRelatorio l : maisVendidos) { %>
                        <tr><td><%= l.getRotulo() %></td><td><%= l.getQuantidade() %></td><td class="rel-num"><%= moeda(l.getValor()) %></td></tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <%-- Detalhamento: por forma de pagamento --%>
            <div class="rel-block mb-8">
                <h2 class="font-heading text-xl text-brand-brown-footer font-bold mb-3">Faturamento por forma de pagamento</h2>
                <table class="rel-table">
                    <thead><tr><th>Forma</th><th>Pedidos</th><th class="rel-num">Total</th></tr></thead>
                    <tbody>
                        <% if (porPagamento == null || porPagamento.isEmpty()) { %>
                        <tr><td colspan="3">Sem dados.</td></tr>
                        <% } else { for (LinhaRelatorio l : porPagamento) { %>
                        <tr><td><%= l.getRotulo() %></td><td><%= l.getQuantidade() %></td><td class="rel-num"><%= moeda(l.getValor()) %></td></tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <%-- Detalhamento: top clientes --%>
            <div class="rel-block mb-8">
                <h2 class="font-heading text-xl text-brand-brown-footer font-bold mb-3">Clientes que mais compraram</h2>
                <table class="rel-table">
                    <thead><tr><th>Cliente</th><th>Pedidos</th><th class="rel-num">Total gasto</th></tr></thead>
                    <tbody>
                        <% if (topClientes == null || topClientes.isEmpty()) { %>
                        <tr><td colspan="3">Sem dados.</td></tr>
                        <% } else { for (LinhaRelatorio l : topClientes) { %>
                        <tr><td><%= l.getRotulo() %></td><td><%= l.getQuantidade() %></td><td class="rel-num"><%= moeda(l.getValor()) %></td></tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <p class="text-xs text-center text-brand-brown-medium mt-10 pt-4 border-t border-brand-cream-dark">
                Aconchegô — Onde o amor faz morada · Relatório gerado pelo painel administrativo em <%= dataGeracao %>
            </p>
        </div>

        <script>
            window.addEventListener('load', function () {
                setTimeout(function () { window.print(); }, 500);
            });
        </script>
    </body>
</html>
