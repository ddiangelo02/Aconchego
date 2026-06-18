<%--
    Document   : configuracoes
    Created on : 1 de jun. de 2026, 16:21:27
    Author     : Usuário
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='WEB-INF/includes/head.jsp' %>
    </head>
    <body>
        <%@ include file='WEB-INF/includes/header.jsp' %>

        <main class="bg-white py-12 px-4">
            <div class="container mx-auto max-w-5xl">

                <h1 class="font-heading text-4xl md:text-5xl text-brand-brown-footer text-center font-bold mb-10">
                    Minha Conta
                </h1>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">

                    <%-- ===================== BARRA LATERAL ===================== --%>
                    <aside class="md:col-span-1">
                        <div class="bg-brand-cream-light rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.06)] p-8 flex flex-col h-full">

                            <div class="flex flex-col items-center text-center">
                                <svg class="w-20 h-20 text-brand-green-btn" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <circle cx="12" cy="12" r="10" stroke-width="1.5"></circle>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 13a3 3 0 100-6 3 3 0 000 6z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M6.5 18.5a6 6 0 0111 0"></path>
                                </svg>
                                <h2 class="font-heading text-2xl text-brand-brown-footer font-bold mt-3">
                                    <%= usuario.getNome() %>
                                </h2>
                                <p class="font-body text-sm text-brand-brown-medium break-all">
                                    <%= usuario.getEmail() %>
                                </p>
                            </div>

                            <hr class="my-6 border-brand-cream-dark">

                            <nav class="flex flex-col gap-2 font-body text-brand-brown-medium">
                                <button type="button" data-tab-target="dados-panel"
                                        class="config-tab flex items-center gap-3 px-4 py-3 rounded-xl text-left transition-colors bg-brand-cream-dark text-brand-brown-dark font-medium">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="8" r="3.25" stroke-width="1.5"></circle><path stroke-linecap="round" stroke-width="1.5" d="M5.5 19a6.5 6.5 0 0113 0"></path></svg>
                                    Meus Dados
                                </button>

                                <button type="button" data-tab-target="pedidos-panel"
                                        class="config-tab flex items-center gap-3 px-4 py-3 rounded-xl text-left transition-colors hover:bg-brand-cream-dark/60">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3.27 6.96L12 12l8.73-5.04M12 22V12"></path></svg>
                                    Meus Pedidos
                                </button>

                                <% if (usuario.isAdministrador()) { %>
                                <button type="button" data-tab-target="estoque-panel"
                                        class="config-tab flex items-center gap-3 px-4 py-3 rounded-xl text-left transition-colors hover:bg-brand-cream-dark/60">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
                                    Meu Estoque
                                </button>
                                <% } %>
                            </nav>

                            <a href="${pageContext.request.contextPath}/logout"
                               class="mt-auto flex items-center justify-center gap-2 px-4 py-3 rounded-xl bg-brand-cream-dark/60 hover:bg-brand-cream-dark text-brand-brown-dark font-body font-medium transition-colors">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                                Sair
                            </a>
                        </div>
                    </aside>

                    <%-- ===================== CONTEÚDO ===================== --%>
                    <section class="md:col-span-2">
                        <div class="bg-white rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.06)] border border-brand-cream-dark p-8 md:p-10">

                            <%
                                String mensagem = (String) request.getAttribute("mensagem");
                                String status = (String) request.getAttribute("status");
                                if (mensagem != null) {
                                    boolean sucesso = "sucesso".equals(status);
                            %>
                            <div class="mb-6 px-4 py-3 rounded-xl border <%= sucesso ? "bg-green-100 border-green-400 text-green-700" : "bg-red-100 border-red-400 text-red-700" %>" role="alert">
                                <strong class="font-bold"><%= sucesso ? "Sucesso!" : "Erro!" %></strong>
                                <span class="block sm:inline"><%= mensagem %></span>
                            </div>
                            <% } %>

                            <%-- ----- Painel: Meus Dados ----- --%>
                            <div id="dados-panel" class="config-panel">
                                <h3 class="font-heading text-3xl text-brand-brown-footer font-bold mb-8">Meus Dados</h3>

                                <form id="form-dados" action="configuracoes" method="POST" class="space-y-5">
                                    <input type="hidden" id="dados-senha-atual" name="senha-atual" value="">

                                    <div>
                                        <label for="nome" class="block font-body text-brand-brown-footer font-bold mb-1.5">Nome Completo</label>
                                        <input type="text" id="nome" name="nome" required value="<%= usuario.getNome() %>"
                                               class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors">
                                    </div>

                                    <div>
                                        <label for="email" class="block font-body text-brand-brown-footer font-bold mb-1.5">E-mail</label>
                                        <input type="email" id="email" name="email" required value="<%= usuario.getEmail() %>"
                                               class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors">
                                    </div>

                                    <button type="submit"
                                            class="bg-brand-green-btn hover:bg-brand-green-btn-hover text-white font-body font-medium px-6 py-3 rounded-xl shadow-md transition-colors">
                                        Salvar Alterações
                                    </button>
                                </form>

                                <hr class="my-8 border-brand-cream-dark">

                                <%-- ----- Seção: Senha ----- --%>
                                <div class="flex items-center justify-between gap-4">
                                    <div>
                                        <h3 class="font-heading text-2xl text-brand-brown-footer font-bold">Senha</h3>
                                        <p class="font-body text-sm text-brand-brown-medium mt-1">
                                            Altere a senha de acesso à sua conta.
                                        </p>
                                    </div>
                                    <button type="button" id="btn-editar-senha"
                                            class="flex items-center gap-2 border border-brand-button text-brand-button hover:bg-brand-button hover:text-white font-body font-medium px-5 py-2.5 rounded-xl transition-colors whitespace-nowrap">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                                        Editar
                                    </button>
                                </div>

                                <%-- ----- Zona de Perigo ----- --%>
                                <div class="mt-10 border border-red-300 bg-red-50 rounded-2xl p-6">
                                    <div class="flex items-center gap-2 mb-2">
                                        <svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 9v4m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"></path></svg>
                                        <h4 class="font-heading text-xl text-red-700 font-bold">Zona de Perigo</h4>
                                    </div>
                                    <p class="font-body text-sm text-red-600 mb-4">
                                        A exclusão da conta é permanente e remove todos os seus dados, favoritos e histórico de pedidos.
                                    </p>
                                    <form action="excluir-conta" method="POST"
                                          onsubmit="return confirm('Tem certeza de que deseja excluir sua conta? Esta ação é permanente e não pode ser desfeita.');">
                                        <button type="submit"
                                                class="flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white font-body font-medium px-5 py-2.5 rounded-xl shadow-md transition-colors">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M19 7l-.87 12.14A2 2 0 0116.14 21H7.86a2 2 0 01-1.99-1.86L5 7m5 4v6m4-6v6M9 7V4a1 1 0 011-1h4a1 1 0 011 1v3M4 7h16"></path></svg>
                                            Excluir minha conta
                                        </button>
                                    </form>
                                </div>
                            </div>

                            <%-- ----- Painel: Meus Pedidos ----- --%>
                            <div id="pedidos-panel" class="config-panel hidden">
                                <h3 class="font-heading text-3xl text-brand-brown-footer font-bold mb-8">Meus Pedidos</h3>
                                <div class="flex flex-col items-center text-center py-12 text-brand-brown-medium">
                                    <svg class="w-16 h-16 mb-4 text-brand-cream-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"></path></svg>
                                    <p class="font-body">Você ainda não realizou nenhum pedido.</p>
                                    <a href="${pageContext.request.contextPath}/" class="mt-4 text-brand-green-btn hover:text-brand-green-btn-hover font-bold">Explorar produtos</a>
                                </div>
                            </div>

                            <%-- ----- Painel: Meu Estoque ----- --%>
                            <% if (usuario.isAdministrador()) { %>
                            <div id="estoque-panel" class="config-panel hidden">
                                <h3 class="font-heading text-3xl text-brand-brown-footer font-bold mb-8">Meu Estoque</h3>
                                <div class="flex flex-col items-center text-center py-12 text-brand-brown-medium">
                                    <svg class="w-16 h-16 mb-4 text-brand-cream-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
                                    <p class="font-body">Gerencie aqui os produtos disponíveis na loja.</p>
                                    <a href="${pageContext.request.contextPath}/" class="mt-4 text-brand-green-btn hover:text-brand-green-btn-hover font-bold">Ir para o catálogo</a>
                                </div>
                            </div>
                            <% } %>

                        </div>
                    </section>
                </div>
            </div>
        </main>

        <%-- ===================== MODAL: confirmar senha (dados) ===================== --%>
        <div id="modal-dados" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div class="bg-white rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.2)] w-full max-w-sm p-8">
                <h3 class="font-heading text-2xl text-brand-brown-footer font-bold mb-2">Confirme sua senha</h3>
                <p class="font-body text-sm text-brand-brown-medium mb-5">
                    Para salvar as alterações dos seus dados, digite a sua senha atual.
                </p>
                <input type="password" id="modal-dados-senha" placeholder="Senha atual"
                       class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3.5 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors">
                <p id="modal-dados-erro" class="hidden text-sm text-red-600 mt-2"></p>
                <div class="flex justify-end gap-3 mt-6">
                    <button type="button" data-fechar-modal="modal-dados"
                            class="font-body font-medium px-5 py-2.5 rounded-xl text-brand-brown-medium hover:bg-brand-cream-dark/60 transition-colors">
                        Cancelar
                    </button>
                    <button type="button" id="modal-dados-confirmar"
                            class="bg-brand-green-btn hover:bg-brand-green-btn-hover text-white font-body font-medium px-5 py-2.5 rounded-xl shadow-md transition-colors">
                        Confirmar
                    </button>
                </div>
            </div>
        </div>

        <%-- ===================== MODAL: alterar senha ===================== --%>
        <div id="modal-senha" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div class="bg-white rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.2)] w-full max-w-sm p-8">
                <h3 class="font-heading text-2xl text-brand-brown-footer font-bold mb-5">Alterar senha</h3>
                <form id="form-senha" action="alterar-senha" method="POST" class="space-y-4">
                    <div>
                        <label for="senha-atual" class="block font-body text-brand-brown-footer font-bold mb-1.5">Senha Atual</label>
                        <input type="password" id="senha-atual" name="senha-atual" required placeholder="Sua senha atual"
                               class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors">
                    </div>
                    <div>
                        <label for="senha-nova" class="block font-body text-brand-brown-footer font-bold mb-1.5">Nova Senha</label>
                        <input type="password" id="senha-nova" name="senha-nova" required minlength="6" placeholder="Mín. 6 caracteres"
                               class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors">
                    </div>
                    <div>
                        <label for="senha-confirmacao" class="block font-body text-brand-brown-footer font-bold mb-1.5">Confirmar Nova Senha</label>
                        <input type="password" id="senha-confirmacao" name="senha-confirmacao" required placeholder="Repita a nova senha"
                               class="w-full bg-white border border-[#EBE0D2] rounded-xl px-5 py-3 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors">
                    </div>
                    <p id="modal-senha-erro" class="hidden text-sm text-red-600"></p>

                    <div class="flex justify-end gap-3 pt-2">
                        <button type="button" data-fechar-modal="modal-senha"
                                class="font-body font-medium px-5 py-2.5 rounded-xl text-brand-brown-medium hover:bg-brand-cream-dark/60 transition-colors">
                            Cancelar
                        </button>
                        <button type="submit"
                                class="bg-brand-green-btn hover:bg-brand-green-btn-hover text-white font-body font-medium px-5 py-2.5 rounded-xl shadow-md transition-colors">
                            Salvar
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <%@ include file='WEB-INF/includes/footer.jsp' %>

        <script>
            (function () {
                const tabs = document.querySelectorAll('.config-tab');
                const panels = document.querySelectorAll('.config-panel');

                function ativar(target) {
                    panels.forEach(p => p.classList.toggle('hidden', p.id !== target));
                    tabs.forEach(t => {
                        const ativo = t.dataset.tabTarget === target;
                        t.classList.toggle('bg-brand-cream-dark', ativo);
                        t.classList.toggle('text-brand-brown-dark', ativo);
                        t.classList.toggle('font-medium', ativo);
                        t.classList.toggle('hover:bg-brand-cream-dark/60', !ativo);
                    });
                }

                tabs.forEach(t => t.addEventListener('click', () => ativar(t.dataset.tabTarget)));
            })();

            // ---------- Modais ----------
            (function () {
                const abrir = (id) => document.getElementById(id).classList.remove('hidden');
                const fechar = (id) => document.getElementById(id).classList.add('hidden');

                // Fechar (botões "Cancelar" e clique no fundo)
                document.querySelectorAll('[data-fechar-modal]').forEach(b =>
                    b.addEventListener('click', () => fechar(b.dataset.fecharModal)));
                document.querySelectorAll('#modal-dados, #modal-senha').forEach(overlay =>
                    overlay.addEventListener('click', (e) => { if (e.target === overlay) fechar(overlay.id); }));

                // --- Fluxo: salvar dados (confirmação de senha em modal) ---
                const formDados = document.getElementById('form-dados');
                const inputSenhaOculto = document.getElementById('dados-senha-atual');
                const modalSenhaInput = document.getElementById('modal-dados-senha');
                const modalDadosErro = document.getElementById('modal-dados-erro');

                formDados.addEventListener('submit', (e) => {
                    // Sem senha confirmada ainda: valida campos, abre o modal
                    if (!inputSenhaOculto.value) {
                        e.preventDefault();
                        if (!formDados.reportValidity()) return;
                        modalDadosErro.classList.add('hidden');
                        modalSenhaInput.value = '';
                        abrir('modal-dados');
                        modalSenhaInput.focus();
                    }
                });

                document.getElementById('modal-dados-confirmar').addEventListener('click', () => {
                    if (!modalSenhaInput.value) {
                        modalDadosErro.textContent = 'Digite a sua senha atual.';
                        modalDadosErro.classList.remove('hidden');
                        return;
                    }
                    inputSenhaOculto.value = modalSenhaInput.value;
                    formDados.submit();
                });

                // --- Fluxo: alterar senha ---
                document.getElementById('btn-editar-senha').addEventListener('click', () => {
                    document.getElementById('form-senha').reset();
                    document.getElementById('modal-senha-erro').classList.add('hidden');
                    abrir('modal-senha');
                    document.getElementById('senha-atual').focus();
                });

                const formSenha = document.getElementById('form-senha');
                formSenha.addEventListener('submit', (e) => {
                    const nova = document.getElementById('senha-nova').value;
                    const confirma = document.getElementById('senha-confirmacao').value;
                    const erro = document.getElementById('modal-senha-erro');
                    if (nova !== confirma) {
                        e.preventDefault();
                        erro.textContent = 'A confirmação da nova senha não coincide.';
                        erro.classList.remove('hidden');
                    }
                });
            })();
        </script>
    </body>
</html>
