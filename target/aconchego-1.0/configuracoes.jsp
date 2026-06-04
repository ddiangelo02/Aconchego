<%-- 
    Document   : editar-usuario
    Created on : 1 de jun. de 2026, 16:21:27
    Author     : Usuário
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file='WEB-INF/includes/head.jsp' %>
    </head>
    <body>
        <%@ include file='WEB-INF/includes/header.jsp' %>
        <main>

            <div class="min-h-[75vh] flex items-center justify-center bg-white p-4">

                <div
                    class="bg-brand-cream-light rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.08)] p-10 w-full max-w-md">

                    <h2 class="font-heading text-4xl text-brand-brown-footer text-center font-bold mb-10">
                        Edite suas informações
                    </h2>
                    <% if (request.getAttribute("mensagem") != null) {%>
                    <% if ("sucesso".equals(request.getAttribute("status"))) { %>
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
                        <strong class="font-bold">Sucesso!</strong>
                    <% } else { %>
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                        <strong class="font-bold">Erro!</strong>
                    <% } %>
                        <span class="block sm:inline">
                            <%= request.getAttribute("mensagem")%>
                        </span>
                    </div>
                    <% }%>
                    <form action="configuracoes" method="POST" class="space-y-6">

                        <div>
                            <input type="text" placeholder="Seu nome"
                                   class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] placeholder focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors"
                                   required name="nome" value="<%= usuario.getNome()%>">
                        </div>

                        <div>
                            <input type="text" name="endereco" placeholder="Seu endereço"
                                   class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] placeholder focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors"
                                   required value="<%= usuario.getEndereco()%>">
                        </div>

                        <div>
                            <input type="email" name="email" placeholder="Seu e-mail"
                                   class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] placeholder focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors"
                                   required value="<%= usuario.getEmail()%>">
                        </div>

                        <div>
                            <input type="text" name="login" placeholder="Seu nome de usuário"
                                   class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] placeholder focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors"
                                   required value="<%= usuario.getLogin()%>">
                        </div>


                        <button type="submit"
                                class="bg-brand-brown-footer text-white w-full text-xl py-3.5 rounded-xl shadow-md mt-2">
                            Salvar Atualizações
                        </button>

                    </form>
                    </main>

                    <%@ include file='WEB-INF/includes/footer.jsp' %>
                    </body>
                    </html>
