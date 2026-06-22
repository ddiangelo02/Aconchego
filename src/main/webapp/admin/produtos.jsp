<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%@page import="com.ddiangelo.aconchego.modelo.Categoria"%>
<%!

    private String esc(String s) {
        if (s == null) { return ""; }
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    pageContext.setAttribute("paginaAtiva", "produtos");
    pageContext.setAttribute("tituloPagina", "Produtos");

    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
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
                        <form action="${pageContext.request.contextPath}/admin/produtos" method="GET" class="relative w-full sm:max-w-md">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-brand-brown-medium">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M21 21l-4.35-4.35M11 19a8 8 0 100-16 8 8 0 000 16z"></path></svg>
                            </span>
                            <input type="text" name="q" value="<%= busca == null ? "" : busca %>" placeholder="Buscar por nome ou categoria..."
                                   class="w-full bg-white border border-brand-cream-dark rounded-full pl-11 pr-5 py-3 font-body text-brand-brown-footer placeholder:text-[#C4B4A9] focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button transition-colors">
                        </form>
                        <button type="button" onclick="abrirModalProduto()"
                                class="flex items-center justify-center gap-2 bg-brand-green-btn hover:bg-brand-green-btn-hover text-white font-body font-medium px-5 py-3 rounded-xl shadow-md transition-colors whitespace-nowrap">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                            Adicionar Produto
                        </button>
                    </div>

                    <div class="bg-white rounded-2xl border border-brand-cream-dark overflow-hidden">
                        <table class="w-full text-left">
                            <thead>
                                <tr class="border-b border-brand-cream-dark font-body text-sm uppercase tracking-wide text-brand-brown-medium">
                                    <th class="px-6 py-4 font-bold">Produto</th>
                                    <th class="px-6 py-4 font-bold">Categoria</th>
                                    <th class="px-6 py-4 font-bold">Preço</th>
                                    <th class="px-6 py-4 font-bold">Estoque</th>
                                    <th class="px-6 py-4 font-bold text-right">Ações</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-brand-cream-dark">
                                <% if (produtos == null || produtos.isEmpty()) { %>
                                <tr><td colspan="5" class="px-6 py-10 text-center font-body text-brand-brown-medium">Nenhum produto encontrado.</td></tr>
                                <% } else {
                                       for (Produto p : produtos) {
                                           String cat = (p.getCategoriaNome() == null) ? "" : p.getCategoriaNome();
                                           String preco = String.format("R$ %.2f", p.getPreco()).replace('.', ',');
                                           int q = p.getQuantidade();
                                           String badge; String estoqueTexto;
                                           if (q == 0) { badge = "bg-red-100 text-red-600"; estoqueTexto = "Esgotado"; }
                                           else if (q <= 5) { badge = "bg-amber-100 text-amber-700"; estoqueTexto = q + " unid."; }
                                           else { badge = "bg-green-100 text-green-700"; estoqueTexto = q + " unid."; }
                                           String fotoSafe = (p.getFoto() == null) ? "" : p.getFoto();
                                           String descSafe = (p.getDescricao() == null) ? "" : p.getDescricao();
                                %>
                                <tr class="hover:bg-brand-cream-lightener/60">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-12 h-12 rounded-lg bg-brand-cream-dark overflow-hidden flex items-center justify-center shrink-0">
                                                <% if (!fotoSafe.isEmpty()) { %>
                                                <img src="<%= fotoSafe %>" alt="<%= p.getNome() %>" class="w-full h-full object-cover">
                                                <% } else { %>
                                                <svg class="w-6 h-6 text-brand-brown-medium" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14M4 6h16v12H4z"></path></svg>
                                                <% } %>
                                            </div>
                                            <span class="font-body font-bold text-brand-brown-footer"><%= p.getNome() %></span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 font-body text-brand-brown-medium"><%= cat.isEmpty() ? "—" : cat %></td>
                                    <td class="px-6 py-4 font-body font-bold text-brand-brown-footer"><%= preco %></td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center rounded-full px-3 py-1 text-sm font-bold <%= badge %>"><%= estoqueTexto %></span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center justify-end gap-3">
                                            <button type="button" title="Editar"
                                                    class="text-brand-brown-medium hover:text-brand-button transition-colors"
                                                    onclick='editarProduto(this)'
                                                    data-id="<%= p.getId() %>"
                                                    data-nome="<%= esc(p.getNome()) %>"
                                                    data-preco="<%= p.getPreco() %>"
                                                    data-quantidade="<%= p.getQuantidade() %>"
                                                    data-categoria-id="<%= p.getCategoriaId() %>"
                                                    data-foto="<%= esc(fotoSafe) %>"
                                                    data-descricao="<%= esc(descSafe) %>">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/produtos" method="POST" onsubmit="return confirm('Excluir o produto &quot;<%= p.getNome() %>&quot;? Esta ação não pode ser desfeita.');">
                                                <input type="hidden" name="acao" value="excluir">
                                                <input type="hidden" name="id" value="<%= p.getId() %>">
                                                <button type="submit" title="Excluir" class="text-red-400 hover:text-red-600 transition-colors">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M19 7l-.87 12.14A2 2 0 0116.14 21H7.86a2 2 0 01-1.99-1.86L5 7m5 4v6m4-6v6M9 7V4a1 1 0 011-1h4a1 1 0 011 1v3M4 7h16"></path></svg>
                                                </button>
                                            </form>
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

        <div id="modal-produto" class="hidden fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4 overflow-y-auto">
            <div class="bg-brand-cream-lightener rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.2)] w-full max-w-lg my-8">
                <form action="${pageContext.request.contextPath}/admin/produtos" method="POST" enctype="multipart/form-data" class="p-8">
                    <input type="hidden" name="acao" value="salvar">
                    <input type="hidden" name="id" id="produto-id" value="">

                    <div class="flex items-center justify-between mb-6">
                        <h3 id="modal-produto-titulo" class="font-heading text-2xl text-brand-brown-footer font-bold">Adicionar Produto</h3>
                        <button type="button" onclick="fecharModalProduto()" class="text-brand-brown-medium hover:text-brand-brown-footer">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M6 18L18 6M6 6l12 12"></path></svg>
                        </button>
                    </div>

                    <div class="space-y-4">
                        <div>
                            <label for="produto-nome" class="block font-body text-brand-brown-footer font-bold mb-1.5">Nome do Produto <span class="text-red-500">*</span></label>
                            <input type="text" id="produto-nome" name="nome" required
                                   class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label for="produto-preco" class="block font-body text-brand-brown-footer font-bold mb-1.5">Preço (R$) <span class="text-red-500">*</span></label>
                                <input type="number" step="0.01" min="0" id="produto-preco" name="preco" required
                                       class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                            </div>
                            <div>
                                <label for="produto-quantidade" class="block font-body text-brand-brown-footer font-bold mb-1.5">Estoque</label>
                                <input type="number" min="0" id="produto-quantidade" name="quantidade" value="0"
                                       class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                            </div>
                        </div>

                        <div>
                            <label for="produto-categoria" class="block font-body text-brand-brown-footer font-bold mb-1.5">Categoria</label>
                            <select id="produto-categoria" name="categoriaId"
                                    class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                                <option value="">Sem categoria</option>
                                <% if (categorias != null) { for (Categoria c : categorias) { %>
                                <option value="<%= c.getId() %>"><%= c.getNome() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div>
                            <label class="block font-body text-brand-brown-footer font-bold mb-1.5">Imagem do produto</label>
                            <input type="text" id="produto-foto" name="foto" oninput="atualizarPreview()" placeholder="Cole um link (URL) da imagem"
                                   class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">

                            <div class="flex items-center gap-3 mt-2">
                                <label for="produto-imagem" class="cursor-pointer inline-flex items-center gap-2 bg-white border border-brand-cream-dark rounded-xl px-4 py-2 font-body text-sm text-brand-brown-footer hover:bg-brand-cream-dark/40 transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14M4 8h.01M7 4h10a2 2 0 012 2v12a2 2 0 01-2 2H7a2 2 0 01-2-2V6a2 2 0 012-2z"></path></svg>
                                    Enviar arquivo
                                </label>
                                <input type="file" id="produto-imagem" name="imagem" accept="image/*" class="hidden" onchange="atualizarPreview()">
                                <span id="produto-arquivo-nome" class="font-body text-xs text-brand-brown-medium truncate"></span>
                                <button type="button" id="produto-arquivo-limpar" onclick="limparArquivo()" class="hidden font-body text-xs text-red-500 hover:underline">remover</button>
                            </div>
                            <p class="font-body text-xs text-brand-brown-medium mt-1">Cole um link <strong>ou</strong> envie um arquivo (o arquivo tem prioridade). PNG/JPG até 5MB.</p>

                            <div class="mt-3 w-full h-44 rounded-xl bg-brand-cream-dark overflow-hidden flex items-center justify-center">
                                <img id="produto-preview" src="" alt="Pré-visualização" class="w-full h-full object-cover hidden">
                                <span id="produto-preview-placeholder" class="font-body text-sm text-brand-brown-medium">Pré-visualização da imagem</span>
                            </div>
                        </div>

                        <div>
                            <label for="produto-descricao" class="block font-body text-brand-brown-footer font-bold mb-1.5">Descrição</label>
                            <textarea id="produto-descricao" name="descricao" rows="3"
                                      class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-3 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button"></textarea>
                        </div>
                    </div>

                    <div class="flex justify-end gap-3 mt-8">
                        <button type="button" onclick="fecharModalProduto()"
                                class="font-body font-medium px-5 py-2.5 rounded-xl bg-white border border-brand-cream-dark text-brand-brown-medium hover:bg-brand-cream-dark/40 transition-colors">
                            Cancelar
                        </button>
                        <button type="submit"
                                class="bg-brand-green-btn hover:bg-brand-green-btn-hover text-white font-body font-medium px-6 py-2.5 rounded-xl shadow-md transition-colors">
                            Salvar Alterações
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            const modalProduto = document.getElementById('modal-produto');

            function mostrarPreview(src) {
                const img = document.getElementById('produto-preview');
                const ph = document.getElementById('produto-preview-placeholder');
                img.src = src; img.classList.remove('hidden'); ph.classList.add('hidden');
            }
            function limparPreview() {
                const img = document.getElementById('produto-preview');
                const ph = document.getElementById('produto-preview-placeholder');
                img.src = ''; img.classList.add('hidden'); ph.classList.remove('hidden');
            }

            function atualizarPreview() {
                const fileInput = document.getElementById('produto-imagem');
                const nomeSpan = document.getElementById('produto-arquivo-nome');
                const botaoLimpar = document.getElementById('produto-arquivo-limpar');
                const arquivo = fileInput.files && fileInput.files[0];

                if (arquivo) {
                    nomeSpan.textContent = arquivo.name;
                    botaoLimpar.classList.remove('hidden');
                    const leitor = new FileReader();
                    leitor.onload = (e) => mostrarPreview(e.target.result);
                    leitor.readAsDataURL(arquivo);
                    return;
                }
                nomeSpan.textContent = '';
                botaoLimpar.classList.add('hidden');
                const url = document.getElementById('produto-foto').value.trim();
                if (url) { mostrarPreview(url); } else { limparPreview(); }
            }

            function limparArquivo() {
                document.getElementById('produto-imagem').value = '';
                atualizarPreview();
            }

            function abrirModalProduto() {
                document.getElementById('modal-produto-titulo').textContent = 'Adicionar Produto';
                document.getElementById('produto-id').value = '';
                document.getElementById('produto-nome').value = '';
                document.getElementById('produto-preco').value = '';
                document.getElementById('produto-quantidade').value = '0';
                document.getElementById('produto-categoria').value = '';
                document.getElementById('produto-foto').value = '';
                document.getElementById('produto-imagem').value = '';
                document.getElementById('produto-descricao').value = '';
                atualizarPreview();
                modalProduto.classList.remove('hidden');
            }

            function editarProduto(botao) {
                const d = botao.dataset;
                document.getElementById('modal-produto-titulo').textContent = 'Editar Produto';
                document.getElementById('produto-id').value = d.id;
                document.getElementById('produto-nome').value = d.nome;
                document.getElementById('produto-preco').value = d.preco;
                document.getElementById('produto-quantidade').value = d.quantidade;
                document.getElementById('produto-foto').value = d.foto;
                document.getElementById('produto-imagem').value = '';
                document.getElementById('produto-descricao').value = d.descricao;
                document.getElementById('produto-categoria').value = (d.categoriaId && d.categoriaId !== '0') ? d.categoriaId : '';
                atualizarPreview();
                modalProduto.classList.remove('hidden');
            }

            function fecharModalProduto() { modalProduto.classList.add('hidden'); }

            modalProduto.addEventListener('click', (e) => { if (e.target === modalProduto) fecharModalProduto(); });
        </script>
    </body>
</html>
