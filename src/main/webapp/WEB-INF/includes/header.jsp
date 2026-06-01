<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.ddiangelo.aconchego.modelo.Usuario"%>
<%
    Usuario usuario = null;
    if (session.getAttribute("usuario") != null && session.getAttribute("usuario") instanceof Usuario) {
        usuario = (Usuario) session.getAttribute("usuario");
    }
%>
<header class="flex items-center justify-center py-8 gap-16 shadow-md">

    <div class="flex items-center gap-2">
        <a href="${pageContext.request.contextPath}">
            <img src="${pageContext.request.contextPath}/images/aconchego-logo.svg" >
        </a>
    </div>

    <%
        String urlAtual = request.getRequestURI();
        String link = "/login";

        if (!urlAtual.equals(link)) { %>

    <div class="hidden md:flex w-1/3">
        <input type="text" placeholder="O que você procura?" class="w-full bg-white border border-gray-200 rounded-full px-6 py-2 text-sm focus:outline-none focus:border-brand-button">
    </div>
    <% } %>

    <div class="flex items-center justify-center gap-4 text-brand-brown-medium">
        <% if (usuario == null) { %>
        <button class="px-4 py-2 bg-brand-brown-footer text-white rounded-xl">
            <a href="${pageContext.request.contextPath}/login">
                <div class="flex items-center justify-center gap-2">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M7.5 17.5H4.16667C3.72464 17.5 3.30072 17.3244 2.98816 17.0118C2.67559 16.6993 2.5 16.2754 2.5 15.8333V4.16667C2.5 3.72464 2.67559 3.30072 2.98816 2.98816C3.30072 2.67559 3.72464 2.5 4.16667 2.5H7.5" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M13.3335 14.1667L17.5002 10L13.3335 5.83337" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M17.5 10H7.5" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <span>
                        Faça login
                    </span>
                </div>
            </a>
        </button>
        <% } else { %>
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
        <a href="${pageContext.request.contextPath}/editar-usuario.jsp"><svg class="w-6 h-6" fill="currentColor" stroke="currentColor" viewBox="0 0 448 512"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"  d="M144 128a80 80 0 1 1 160 0 80 80 0 1 1 -160 0zm208 0a128 128 0 1 0 -256 0 128 128 0 1 0 256 0zM48 480c0-70.7 57.3-128 128-128l96 0c70.7 0 128 57.3 128 128l0 8c0 13.3 10.7 24 24 24s24-10.7 24-24l0-8c0-97.2-78.8-176-176-176l-96 0C78.8 304 0 382.8 0 480l0 8c0 13.3 10.7 24 24 24s24-10.7 24-24l0-8z"/></svg>
        <p><% out.println(usuario.getNome()); %>
        <% }%> </a>
    </div>

</header>