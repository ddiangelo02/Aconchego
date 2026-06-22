<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%@page import="com.ddiangelo.aconchego.modelo.Usuario"%>
<%
    List<Produto> itens = (List<Produto>) request.getAttribute("itens");
    List<Integer> quantidades = (List<Integer>) request.getAttribute("quantidades");
    double total = (Double) request.getAttribute("total");
    String totalFmt = String.format("R$ %.2f", total).replace('.', ',');

    Usuario usuarioLogado = (session.getAttribute("usuario") instanceof Usuario) ? (Usuario) session.getAttribute("usuario") : null;
    String endereco = (usuarioLogado != null && usuarioLogado.getEndereco() != null) ? usuarioLogado.getEndereco().trim() : "";

    String mensagem = (String) session.getAttribute("mensagem");
    String statusMsg = (String) session.getAttribute("status");
    if (mensagem != null) { session.removeAttribute("mensagem"); session.removeAttribute("status"); }

    boolean vazio = (itens == null || itens.isEmpty());
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='WEB-INF/includes/head.jsp' %>
    </head>
    <body>
        <%@ include file='WEB-INF/includes/header.jsp' %>
        <main>
            <section class="section-container mt-8 max-w-5xl">
                <h1 class="title-section">Seu Carrinho</h1>

                <% if (mensagem != null) {
                       boolean ok = "sucesso".equals(statusMsg); %>
                <div class="mb-6 px-4 py-3 rounded-xl border <%= ok ? "bg-green-100 border-green-400 text-green-700" : "bg-red-100 border-red-400 text-red-700" %>" role="alert">
                    <strong class="font-bold"><%= ok ? "Tudo certo!" : "Atenção!" %></strong>
                    <span class="ml-1"><%= mensagem %></span>
                </div>
                <% } %>

                <% if (vazio) { %>
                <div class="bg-brand-cream-light rounded-3xl p-12 text-center">
                    <svg class="w-16 h-16 mx-auto mb-4 text-brand-cream-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    <p class="font-body text-brand-brown-medium mb-6">Seu carrinho está vazio.</p>
                    <a href="${pageContext.request.contextPath}/loja" class="btn-brown">Explorar a loja</a>
                </div>
                <% } else { %>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">

                    <div class="lg:col-span-2 space-y-4" id="lista-itens">
                        <% for (int i = 0; i < itens.size(); i++) {
                               Produto p = itens.get(i);
                               int qtd = quantidades.get(i);
                               int estoque = p.getQuantidade();
                               String preco = String.format("R$ %.2f", p.getPreco()).replace('.', ',');
                               String subtotal = String.format("R$ %.2f", p.getPreco() * qtd).replace('.', ',');
                               String foto = (p.getFoto() == null) ? "" : p.getFoto(); %>
                        <div class="item-carrinho bg-white rounded-2xl border border-brand-cream-dark flex items-center gap-4 p-5"
                             data-produto-id="<%= p.getId() %>" data-preco="<%= p.getPreco() %>" data-estoque="<%= estoque %>">
                            <div class="w-16 h-16 rounded-xl bg-brand-cream-dark overflow-hidden flex items-center justify-center shrink-0">
                                <% if (!foto.isEmpty()) { %>
                                <img src="<%= foto %>" alt="<%= p.getNome() %>" class="w-full h-full object-cover">
                                <% } else { %>
                                <svg class="w-7 h-7 text-brand-brown-medium" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16M4 6h16v12H4z"></path></svg>
                                <% } %>
                            </div>
                            <div class="flex-1 min-w-0">
                                <h3 class="font-body font-bold text-brand-brown-footer"><%= p.getNome() %></h3>
                                <p class="text-sm text-brand-brown-medium"><%= preco %> cada</p>
                            </div>

                            <div class="flex items-center bg-white border border-brand-cream-dark rounded-xl overflow-hidden">
                                <button type="button" class="px-3 py-2 text-brand-brown-footer hover:bg-brand-cream-dark/40 transition-colors" onclick="alterarQtd(<%= p.getId() %>, -1)" aria-label="Diminuir">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"></path></svg>
                                </button>
                                <input type="text" inputmode="numeric" id="qtd-<%= p.getId() %>" value="<%= qtd %>" readonly
                                       class="w-12 text-center font-body font-bold text-brand-brown-footer border-x border-brand-cream-dark py-2 focus:outline-none">
                                <button type="button" class="px-3 py-2 text-brand-brown-footer hover:bg-brand-cream-dark/40 transition-colors" onclick="alterarQtd(<%= p.getId() %>, 1)" aria-label="Aumentar">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                </button>
                            </div>

                            <span class="w-28 text-right font-body font-bold text-brand-brown-footer subtotal-item" id="sub-<%= p.getId() %>"><%= subtotal %></span>

                            <button type="button" title="Remover" class="text-red-400 hover:text-red-600 p-2" onclick="removerItem(<%= p.getId() %>)">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M19 7l-.87 12.14A2 2 0 0116.14 21H7.86a2 2 0 01-1.99-1.86L5 7m5 4v6m4-6v6M9 7V4a1 1 0 011-1h4a1 1 0 011 1v3M4 7h16"></path></svg>
                            </button>
                        </div>
                        <% } %>

                        <a href="${pageContext.request.contextPath}/loja" class="inline-block font-body text-brand-brown-medium hover:text-brand-brown-footer">← Continuar comprando</a>
                    </div>

                    <aside class="lg:col-span-1">
                        <form action="${pageContext.request.contextPath}/carrinho" method="POST"
                              class="bg-white rounded-2xl border border-brand-cream-dark p-6 lg:sticky lg:top-8 space-y-5">
                            <input type="hidden" name="acao" value="finalizar">

                            <h2 class="font-heading text-2xl text-brand-brown-footer font-bold">Resumo do pedido</h2>

                            <div>
                                <p class="flex items-center gap-2 font-body text-sm font-bold text-brand-brown-footer mb-1">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M17.657 16.657L13.414 20.9a2 2 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.7" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                    Local de entrega
                                </p>
                                <% if (usuarioLogado == null) { %>
                                <p class="font-body text-sm text-brand-brown-medium">
                                    <a href="${pageContext.request.contextPath}/login" class="text-brand-green-btn font-bold hover:underline">Faça login</a> para informar o endereço de entrega.
                                </p>
                                <% } else if (endereco.isEmpty()) { %>
                                <p class="font-body text-sm text-brand-brown-medium">
                                    Nenhum endereço cadastrado.
                                    <a href="${pageContext.request.contextPath}/configuracoes" class="text-brand-green-btn font-bold hover:underline">Adicionar</a>.
                                </p>
                                <% } else { %>
                                <p class="font-body text-sm text-brand-brown-medium"><%= endereco %></p>
                                <a href="${pageContext.request.contextPath}/configuracoes" class="font-body text-xs text-brand-green-btn hover:underline">Alterar endereço</a>
                                <% } %>
                            </div>

                            <hr class="border-brand-cream-dark">

                            <div>
                                <label for="forma-pagamento" class="block font-body text-sm font-bold text-brand-brown-footer mb-1.5">Forma de pagamento</label>
                                <select id="forma-pagamento" name="forma-pagamento"
                                        class="w-full bg-white border border-brand-cream-dark rounded-xl px-4 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button focus:border-brand-button">
                                    <option value="Pix">Pix</option>
                                    <option value="Cartão de crédito">Cartão de crédito</option>
                                    <option value="Cartão de débito">Cartão de débito</option>
                                    <option value="Boleto bancário">Boleto bancário</option>
                                </select>
                            </div>

                            <hr class="border-brand-cream-dark">

                            <div class="flex items-center justify-between">
                                <span class="font-body text-brand-brown-medium">Total</span>
                                <span id="total-carrinho" class="font-heading text-3xl font-bold text-brand-brown-footer"><%= totalFmt %></span>
                            </div>

                            <button type="submit" class="btn-green w-full text-lg">Finalizar compra</button>
                        </form>
                    </aside>
                </div>
                <% } %>
            </section>
        </main>
        <%@ include file='WEB-INF/includes/footer.jsp' %>

        <% if (!vazio) { %>
        <script>
            const CTX = '${pageContext.request.contextPath}';
            const timers = {};

            function formatarMoeda(v) {
                return 'R$ ' + v.toFixed(2).replace('.', ',');
            }

            function recalcularTotal() {
                let total = 0;
                document.querySelectorAll('.item-carrinho').forEach(row => {
                    const preco = parseFloat(row.dataset.preco);
                    const qtd = parseInt(document.getElementById('qtd-' + row.dataset.produtoId).value, 10) || 0;
                    total += preco * qtd;
                });
                document.getElementById('total-carrinho').textContent = formatarMoeda(total);
            }

            function alterarQtd(produtoId, delta) {
                const row = document.querySelector('.item-carrinho[data-produto-id="' + produtoId + '"]');
                if (!row) return;
                const estoque = parseInt(row.dataset.estoque, 10) || 1;
                const input = document.getElementById('qtd-' + produtoId);
                let qtd = (parseInt(input.value, 10) || 1) + delta;
                if (qtd < 1) qtd = 1;
                if (qtd > estoque) { qtd = estoque; avisarEstoque(row); }
                input.value = qtd;

                const preco = parseFloat(row.dataset.preco);
                document.getElementById('sub-' + produtoId).textContent = formatarMoeda(preco * qtd);

                recalcularTotal();
                sincronizar(produtoId, qtd);
            }

            function avisarEstoque(row) {
                row.classList.add('ring-1', 'ring-amber-400');
                setTimeout(() => row.classList.remove('ring-1', 'ring-amber-400'), 600);
            }

            function sincronizar(produtoId, qtd) {
                clearTimeout(timers[produtoId]);
                timers[produtoId] = setTimeout(() => {
                    const corpo = new URLSearchParams({ acao: 'atualizar', produtoId: produtoId, quantidade: qtd });
                    fetch(CTX + '/carrinho', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                        body: corpo.toString()
                    }).catch(err => console.error('Falha ao sincronizar o carrinho:', err));
                }, 350);
            }

            function removerItem(produtoId) {
                const corpo = new URLSearchParams({ acao: 'remover', produtoId: produtoId });
                fetch(CTX + '/carrinho', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                    body: corpo.toString()
                }).then(() => {
                    const row = document.querySelector('.item-carrinho[data-produto-id="' + produtoId + '"]');
                    if (row) row.remove();
                    if (document.querySelectorAll('.item-carrinho').length === 0) {
                        window.location.reload();
                    } else {
                        recalcularTotal();
                    }
                }).catch(err => console.error('Falha ao remover item:', err));
            }

            recalcularTotal();
        </script>
        <% } %>
    </body>
</html>
