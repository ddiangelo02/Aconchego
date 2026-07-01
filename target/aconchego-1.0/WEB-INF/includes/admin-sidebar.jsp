<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% String _pa = (String) request.getAttribute("paginaAtiva");
   if (_pa == null) { _pa = (String) pageContext.getAttribute("paginaAtiva"); }
   if (_pa == null) { _pa = ""; }
   String _base = "flex items-center gap-3 px-4 py-3 rounded-xl font-body font-medium transition-colors";
   String _ativo = " bg-brand-green-btn text-white shadow-sm";
   String _inativo = " text-brand-cream-light hover:bg-white/10";
%>
<aside class="w-64 shrink-0 bg-brand-brown-footer min-h-screen p-6 flex flex-col">

    <div class="flex items-center justify-center p-4 gap-2 mb-10 rounded-xl">
        <img src="${pageContext.request.contextPath}/images/aconchego-light.svg" >
    </div>

    <nav class="flex flex-col gap-2">
        <a href="${pageContext.request.contextPath}/admin" class="<%= _base + ("visao-geral".equals(_pa) ? _ativo : _inativo) %>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path></svg>
            Visão Geral
        </a>
        <a href="${pageContext.request.contextPath}/admin/produtos" class="<%= _base + ("produtos".equals(_pa) ? _ativo : _inativo) %>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
            Produtos
        </a>
        <a href="${pageContext.request.contextPath}/admin/estoque" class="<%= _base + ("estoque".equals(_pa) ? _ativo : _inativo) %>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
            Estoque
        </a>
        <a href="${pageContext.request.contextPath}/admin/categorias" class="<%= _base + ("categorias".equals(_pa) ? _ativo : _inativo) %>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M7 7h.01M7 3h5a1.99 1.99 0 011.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.99 1.99 0 013 12V7a4 4 0 014-4z"></path></svg>
            Categorias
        </a>
        <a href="${pageContext.request.contextPath}/admin/pedidos" class="<%= _base + ("pedidos".equals(_pa) ? _ativo : _inativo) %>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
            Pedidos
        </a>
        <a href="${pageContext.request.contextPath}/admin/usuarios" class="<%= _base + ("usuarios".equals(_pa) ? _ativo : _inativo) %>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87m6-1.13a4 4 0 10-4-4 4 4 0 004 4zm6 0a4 4 0 00-3-3.87"></path></svg>
            Usuários
        </a>
        <a href="${pageContext.request.contextPath}/admin/relatorios" class="<%= _base + ("relatorios".equals(_pa) ? _ativo : _inativo) %>">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M9 17v-6m4 6V7m4 10v-3M5 21h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
            Relatórios
        </a>
    </nav>
</aside>
