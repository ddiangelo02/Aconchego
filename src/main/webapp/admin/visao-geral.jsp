<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%@page import="com.ddiangelo.aconchego.modelo.Pedido"%>
<%
    pageContext.setAttribute("paginaAtiva", "visao-geral");
    pageContext.setAttribute("tituloPagina", "Visão Geral");

    int totalProdutos = (Integer) request.getAttribute("totalProdutos");
    int semEstoque = (Integer) request.getAttribute("semEstoque");
    int totalPedidos = (Integer) request.getAttribute("totalPedidos");
    int totalUsuarios = (Integer) request.getAttribute("totalUsuarios");
    List<Produto> estoqueBaixo = (List<Produto>) request.getAttribute("estoqueBaixo");
    List<Produto> estoqueVazio = (List<Produto>) request.getAttribute("estoqueVazio");
    List<Pedido> ultimosPedidos = (List<Pedido>) request.getAttribute("ultimosPedidos");
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

                    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-6 mb-8">
                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-brand-green-btn/15 text-brand-green-btn flex items-center justify-center">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
                            </div>
                            <div>
                                <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Produtos</p>
                                <p class="font-heading text-3xl font-bold text-brand-brown-footer"><%= totalProdutos %></p>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-red-100 text-red-500 flex items-center justify-center">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M12 9v2m0 4h.01M5.07 19h13.86a2 2 0 001.74-2.99l-6.93-12a2 2 0 00-3.48 0l-6.93 12A2 2 0 005.07 19z"></path></svg>
                            </div>
                            <div>
                                <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Sem Estoque</p>
                                <p class="font-heading text-3xl font-bold text-brand-brown-footer"><%= semEstoque %></p>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-brand-button/15 text-brand-button flex items-center justify-center">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                            </div>
                            <div>
                                <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Pedidos</p>
                                <p class="font-heading text-3xl font-bold text-brand-brown-footer"><%= totalPedidos %></p>
                            </div>
                        </div>

                        <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 flex items-center gap-4">
                            <div class="w-12 h-12 rounded-xl bg-brand-green-btn/15 text-brand-green-btn flex items-center justify-center">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87m6-1.13a4 4 0 10-4-4 4 4 0 004 4z"></path></svg>
                            </div>
                            <div>
                                <p class="font-body text-xs tracking-widest uppercase text-brand-brown-medium">Usuários</p>
                                <p class="font-heading text-3xl font-bold text-brand-brown-footer"><%= totalUsuarios %></p>
                            </div>
                        </div>
                    </div>

                    <% if (estoqueVazio != null && !estoqueVazio.isEmpty()) { %>
                    <div class="bg-red-100/60 border border-rose-200 rounded-2xl p-6 mb-8">
                        <div class="flex items-center gap-2 mb-3">
                            <svg class="w-5 h-5 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 9v2m0 4h.01M5.07 19h13.86a2 2 0 001.74-2.99l-6.93-12a2 2 0 00-3.48 0l-6.93 12A2 2 0 005.07 19z"></path></svg>
                            <h3 class="font-heading text-lg font-bold text-brand-brown-footer">Atenção: Produtos sem estoque</h3>
                        </div>
                        <div class="flex flex-wrap gap-2">
                            <% for (Produto p : estoqueVazio) { %>
                            <span class="inline-flex items-center bg-white/70 border border-rose-200 rounded-lg px-3 py-1.5 font-body text-sm font-bold text-brand-brown-footer">
                                <%= p.getNome() %> — <%= p.getQuantidade() %> unid.
                            </span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <% if (estoqueBaixo != null && !estoqueBaixo.isEmpty()) { %>
                    <div class="bg-brand-yellow-highlight/60 border border-amber-200 rounded-2xl p-6 mb-8">
                        <div class="flex items-center gap-2 mb-3">
                            <svg class="w-5 h-5 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 9v2m0 4h.01M5.07 19h13.86a2 2 0 001.74-2.99l-6.93-12a2 2 0 00-3.48 0l-6.93 12A2 2 0 005.07 19z"></path></svg>
                            <h3 class="font-heading text-lg font-bold text-brand-brown-footer">Atenção: Estoque Baixo</h3>
                        </div>
                        <div class="flex flex-wrap gap-2">
                            <% for (Produto p : estoqueBaixo) { %>
                            <span class="inline-flex items-center bg-white/70 border border-amber-200 rounded-lg px-3 py-1.5 font-body text-sm font-bold text-brand-brown-footer">
                                <%= p.getNome() %> — <%= p.getQuantidade() %> unid.
                            </span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <div class="bg-white rounded-2xl border border-brand-cream-dark p-6">
                        <h3 class="font-heading text-lg font-bold text-brand-brown-footer mb-4">Últimos pedidos</h3>
                        <% if (ultimosPedidos == null || ultimosPedidos.isEmpty()) { %>
                        <div class="flex flex-col items-center text-center py-10 text-brand-brown-medium">
                            <svg class="w-12 h-12 mb-3 text-brand-cream-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-4l-2 3h-4l-2-3H4"></path></svg>
                            <p class="font-body">Nenhum pedido realizado ainda.</p>
                        </div>
                        <% } else { %>
                        <div class="divide-y divide-brand-cream-dark">
                            <% for (Pedido v : ultimosPedidos) {
                                   String totalPed = String.format("R$ %.2f", v.getTotal()).replace('.', ','); %>
                            <div class="flex items-center justify-between py-3">
                                <div>
                                    <p class="font-body font-bold text-brand-brown-footer">Pedido #<%= v.getId() %> <span class="text-brand-brown-medium font-normal">· <%= v.getItens().size() %> item(ns) · <%= v.getQuantidadeTotal() %> un.</span></p>
                                    <p class="font-body text-sm text-brand-brown-medium"><%= v.getUsuarioNome() %> — <%= v.getDataHora() %></p>
                                </div>
                                <span class="font-body font-bold text-brand-green-btn"><%= totalPed %></span>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    </div>

                </main>
            </div>
        </div>
    </body>
</html>
