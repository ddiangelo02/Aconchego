<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%@taglib prefix="ac" tagdir="/WEB-INF/tags" %>
<%
    List<Produto> favoritos = (List<Produto>) request.getAttribute("favoritos");
    boolean vazio = (favoritos == null || favoritos.isEmpty());
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='WEB-INF/includes/head.jsp' %>
    </head>
    <body>
        <%@ include file='WEB-INF/includes/header.jsp' %>
        <main>
            <section class="section-container mt-8">
                <h1 class="title-section">Meus Favoritos</h1>

                <% if (vazio) { %>
                <div class="bg-brand-cream-light rounded-3xl p-12 text-center max-w-xl mx-auto">
                    <span class="material-symbols-rounded text-5xl text-brand-cream-dark">favorite</span>
                    <p class="font-body text-brand-brown-medium mt-2 mb-6">Você ainda não tem produtos favoritos.</p>
                    <a href="${pageContext.request.contextPath}/loja" class="btn-brown">Explorar a loja</a>
                </div>
                <% } else { %>
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-card-gap">
                    <% for (Produto p : favoritos) { %>
                    <ac:card-produto produto="<%= p %>" origem="/favoritos" favorito="<%= true %>" />
                    <% } %>
                </div>
                <% } %>
            </section>
        </main>
        <%@ include file='WEB-INF/includes/footer.jsp' %>
    </body>
</html>
