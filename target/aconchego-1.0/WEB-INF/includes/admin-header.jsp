<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.ddiangelo.aconchego.modelo.Usuario"%>

<% String _tp = (String) pageContext.getAttribute("tituloPagina");
   if (_tp == null) { _tp = (String) request.getAttribute("tituloPagina"); }
   if (_tp == null) { _tp = "Painel"; }
   Usuario _adm = (session.getAttribute("usuario") instanceof Usuario) ? (Usuario) session.getAttribute("usuario") : null;
%>
<header class="flex items-center justify-between px-8 py-5 border-b border-brand-cream-dark">
    <h2 class="font-heading text-2xl text-brand-brown-footer font-bold"><%= _tp %></h2>

    <div class="flex items-center gap-6">
        <a href="${pageContext.request.contextPath}/" class="flex items-center gap-2 font-body text-brand-brown-medium hover:text-brand-brown-footer transition-colors">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Voltar ao site
        </a>

        <a href="${pageContext.request.contextPath}/configuracoes" title="Minha conta (editar dados / excluir cadastro)"
           class="flex items-center gap-3 hover:opacity-80 transition-opacity">
            <div class="w-10 h-10 rounded-full bg-brand-cream-dark flex items-center justify-center text-brand-brown-footer">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87m6-1.13a4 4 0 10-4-4 4 4 0 004 4z"></path></svg>
            </div>
            <div class="leading-tight">
                <p class="font-body font-bold text-brand-brown-footer"><%= _adm != null ? _adm.getNome() : "Admin" %></p>
                <p class="font-body text-xs text-brand-brown-medium">Administrador</p>
            </div>
        </a>
    </div>
</header>
