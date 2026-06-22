<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Usuario"%>
<%!
    private String esc(String s) {
        if (s == null) { return ""; }
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    pageContext.setAttribute("paginaAtiva", "usuarios");
    pageContext.setAttribute("tituloPagina", "Usuários");

    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    Usuario logado = (session.getAttribute("usuario") instanceof Usuario) ? (Usuario) session.getAttribute("usuario") : null;
    int meuId = (logado != null) ? logado.getId() : -1;
    String busca = (String) request.getAttribute("busca");

    String mensagem = (String) session.getAttribute("mensagem");
    String statusMsg = (String) session.getAttribute("status");
    if (mensagem != null) { session.removeAttribute("mensagem"); session.removeAttribute("status"); }
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

                    <% if (mensagem != null) {
                           boolean ok = "sucesso".equals(statusMsg); %>
                    <div class="mb-6 px-4 py-3 rounded-xl border <%= ok ? "bg-green-100 border-green-400 text-green-700" : "bg-red-100 border-red-400 text-red-700" %>" role="alert">
                        <strong class="font-bold"><%= ok ? "Sucesso!" : "Erro!" %></strong>
                        <span class="ml-1"><%= mensagem %></span>
                    </div>
                    <% } %>

                    <div class="flex flex-col sm:flex-row gap-4 sm:items-center sm:justify-between mb-6">
                        <form action="${pageContext.request.contextPath}/admin/usuarios" method="GET" class="relative w-full sm:max-w-md">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-brand-brown-medium">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z"></path></svg>
                            </span>
                            <input type="text" name="q" value="<%= busca == null ? "" : busca %>" placeholder="Buscar por nome, e-mail ou login..."
                                   class="w-full bg-white border border-brand-cream-dark rounded-full pl-11 pr-5 py-3 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </form>
                        <button type="button" onclick="abrirModalUsuario()"
                                class="flex items-center justify-center gap-2 bg-brand-green-btn hover:bg-brand-green-btn-hover text-white font-body font-medium px-5 py-3 rounded-xl shadow-md transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                            Adicionar Usuário
                        </button>
                    </div>

                    <div class="bg-white rounded-2xl border border-brand-cream-dark overflow-hidden">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="border-b border-brand-cream-dark font-body text-sm uppercase tracking-wide text-brand-brown-medium">
                                    <th class="px-6 py-4 font-bold">Nome</th>
                                    <th class="px-6 py-4 font-bold">E-mail</th>
                                    <th class="px-6 py-4 font-bold">Login</th>
                                    <th class="px-6 py-4 font-bold">Perfil</th>
                                    <th class="px-6 py-4 font-bold text-right">Ações</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-brand-cream-dark">
                                <% if (usuarios == null || usuarios.isEmpty()) { %>
                                <tr><td colspan="5" class="px-6 py-10 text-center font-body text-brand-brown-medium">Nenhum usuário cadastrado.</td></tr>
                                <% } else {
                                       for (Usuario u : usuarios) {
                                           boolean ehAdmin = u.isAdministrador();
                                           String perfilBadge = ehAdmin ? "bg-brand-green-btn/15 text-brand-green-btn" : "bg-brand-cream-dark text-brand-brown-medium";
                                           String perfilTexto = ehAdmin ? "Administrador" : "Cliente";
                                           String enderecoSafe = (u.getEndereco() == null) ? "" : u.getEndereco(); %>
                                <tr class="hover:bg-brand-cream-lightener/60">
                                    <td class="px-6 py-4 font-body font-bold text-brand-brown-footer"><%= u.getNome() %></td>
                                    <td class="px-6 py-4 font-body text-brand-brown-medium"><%= u.getEmail() %></td>
                                    <td class="px-6 py-4 font-body text-brand-brown-medium"><%= u.getLogin() %></td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-full px-3 py-1 text-sm font-bold <%= perfilBadge %>"><%= perfilTexto %></span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center justify-end gap-3">
                                            <button type="button" title="Editar" class="text-brand-brown-medium hover:text-brand-button transition-colors"
                                                    onclick="editarUsuario(this)"
                                                    data-id="<%= u.getId() %>"
                                                    data-nome="<%= esc(u.getNome()) %>"
                                                    data-email="<%= esc(u.getEmail()) %>"
                                                    data-login="<%= esc(u.getLogin()) %>"
                                                    data-endereco="<%= esc(enderecoSafe) %>"
                                                    data-admin="<%= ehAdmin %>">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                                            </button>
                                            <% if (u.getId() != meuId) { %>
                                            <form action="${pageContext.request.contextPath}/admin/usuarios" method="POST" onsubmit="return confirm('Excluir o usuário &quot;<%= u.getNome() %>&quot;?');">
                                                <input type="hidden" name="acao" value="excluir">
                                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                                <button type="submit" title="Excluir" class="text-red-400 hover:text-red-600 transition-colors">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M19 7l-.87 12.14A2 2 0 0116.14 21H7.86a2 2 0 01-1.99-1.86L5 7m5 4v6m4-6v6M9 7V4a1 1 0 011-1h4a1 1 0 011 1v3M4 7h16"></path></svg>
                                                </button>
                                            </form>
                                            <% } else { %>
                                            <span class="text-xs font-body text-brand-brown-medium italic">você</span>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                                <%     }
                                   } %>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>

        <div id="modal-usuario" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4 overflow-y-auto">
            <div class="bg-brand-cream-lightener rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.2)] w-full max-w-md my-8">
                <form action="${pageContext.request.contextPath}/admin/usuarios" method="POST" class="p-8">
                    <input type="hidden" name="acao" value="salvar">
                    <input type="hidden" name="id" id="usuario-id" value="">

                    <div class="flex items-center justify-between mb-6">
                        <h3 id="modal-usuario-titulo" class="font-heading text-2xl text-brand-brown-footer font-bold">Adicionar Usuário</h3>
                        <button type="button" onclick="fecharModalUsuario()" class="text-brand-brown-medium hover:text-brand-brown-footer">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M6 18L18 6M6 6l12 12"></path></svg>
                        </button>
                    </div>

                    <div class="space-y-4">
                        <div>
                            <label for="usuario-nome" class="block font-body text-brand-brown-footer font-bold mb-1.5">Nome <span class="text-red-500">*</span></label>
                            <input type="text" id="usuario-nome" name="nome" required
                                   class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </div>
                        <div>
                            <label for="usuario-email" class="block font-body text-brand-brown-footer font-bold mb-1.5">E-mail <span class="text-red-500">*</span></label>
                            <input type="email" id="usuario-email" name="email" required
                                   class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </div>
                        <div>
                            <label for="usuario-login" class="block font-body text-brand-brown-footer font-bold mb-1.5">Login <span class="text-red-500">*</span></label>
                            <input type="text" id="usuario-login" name="login" required
                                   class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </div>
                        <div>
                            <label for="usuario-endereco" class="block font-body text-brand-brown-footer font-bold mb-1.5">Endereço</label>
                            <input type="text" id="usuario-endereco" name="endereco"
                                   class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </div>
                        <div id="usuario-senha-wrapper">
                            <label for="usuario-senha" class="block font-body text-brand-brown-footer font-bold mb-1.5">Senha <span class="text-red-500">*</span></label>
                            <input type="password" id="usuario-senha" name="senha" minlength="6" placeholder="Mín. 6 caracteres"
                                   class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                            <p id="usuario-senha-aviso" class="text-xs text-brand-brown-medium mt-1 hidden">A senha não é alterada pela edição.</p>
                        </div>
                        <label class="flex items-center gap-2 font-body text-brand-brown-footer">
                            <input type="checkbox" id="usuario-admin" name="administrador" class="w-4 h-4 accent-brand-green-btn">
                            Administrador
                        </label>
                    </div>

                    <div class="flex justify-end gap-3 mt-8">
                        <button type="button" onclick="fecharModalUsuario()"
                                class="font-body font-medium px-5 py-2.5 rounded-xl bg-white border border-brand-cream-dark text-brand-brown-medium hover:bg-brand-cream-dark/40 transition-colors">Cancelar</button>
                        <button type="submit"
                                class="bg-brand-green-btn hover:bg-brand-green-btn-hover text-white font-body font-medium px-6 py-2.5 rounded-xl shadow-md transition-colors">Salvar</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            const modalUsuario = document.getElementById('modal-usuario');
            const senhaInput = document.getElementById('usuario-senha');
            const senhaAviso = document.getElementById('usuario-senha-aviso');

            function abrirModalUsuario() {
                document.getElementById('modal-usuario-titulo').textContent = 'Adicionar Usuário';
                document.getElementById('usuario-id').value = '';
                document.getElementById('usuario-nome').value = '';
                document.getElementById('usuario-email').value = '';
                document.getElementById('usuario-login').value = '';
                document.getElementById('usuario-endereco').value = '';
                senhaInput.value = '';
                senhaInput.required = true;
                senhaInput.disabled = false;
                senhaAviso.classList.add('hidden');
                document.getElementById('usuario-admin').checked = false;
                modalUsuario.classList.remove('hidden');
            }
            function editarUsuario(botao) {
                const d = botao.dataset;
                document.getElementById('modal-usuario-titulo').textContent = 'Editar Usuário';
                document.getElementById('usuario-id').value = d.id;
                document.getElementById('usuario-nome').value = d.nome;
                document.getElementById('usuario-email').value = d.email;
                document.getElementById('usuario-login').value = d.login;
                document.getElementById('usuario-endereco').value = d.endereco;

                senhaInput.value = '';
                senhaInput.required = false;
                senhaInput.disabled = true;
                senhaAviso.classList.remove('hidden');
                document.getElementById('usuario-admin').checked = (d.admin === 'true');
                modalUsuario.classList.remove('hidden');
            }
            function fecharModalUsuario() { modalUsuario.classList.add('hidden'); }
            modalUsuario.addEventListener('click', (e) => { if (e.target === modalUsuario) fecharModalUsuario(); });
        </script>
    </body>
</html>
