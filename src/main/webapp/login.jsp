<%-- Document : index Created on : 31 de mai. de 2026, 15:04:38 Author : thimo --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="pt-BR">

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
                                Entrar no Aconchegô
                            </h2>

                            <form action="login" method="POST" class="space-y-6">

                                    <% if (request.getAttribute("mensagem") !=null) {%>
                                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative"
                                            role="alert">
                                            <strong class="font-bold">Erro!</strong>
                                            <span class="block sm:inline">
                                                <%= request.getAttribute("mensagem")%>
                                            </span>
                                        </div>
                                        <% }%>

                                            <div>
                                                <input type="email" placeholder="Seu e-mail"
                                                    class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] placeholder focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors"
                                                    required name="login">
                                            </div>

                                            <div>
                                                <input type="password" placeholder="Sua senha"
                                                    class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] placeholder focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors"
                                                    required name="senha">
                                            </div>

                                            <button type="submit"
                                                class="bg-brand-brown-footer text-white w-full text-xl py-3.5 rounded-xl shadow-md mt-2">
                                                Entrar
                                            </button>

                            </form>

                            <p class="text-center mt-8 font-body text-brand-brown-medium">
                                Não tem uma conta?
                                <a href="#"
                                    class="font-bold text-brand-green-btn hover:text-brand-green-btn-hover not transition-colors">
                                    Cadastre-se
                                </a>
                            </p>

                        </div>
                    </div>

                </main>
                <%@ include file='WEB-INF/includes/footer.jsp' %>
        </body>

        </html>