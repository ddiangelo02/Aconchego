<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%
    List<Produto> itens = (List<Produto>) request.getAttribute("itens");
    List<Integer> quantidades = (List<Integer>) request.getAttribute("quantidades");
    double total = (Double) request.getAttribute("total");
    String totalFmt = String.format("R$ %.2f", total).replace('.', ',');
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
                <h1 class="title-section">Pagamento</h1>
                <p class="text-center font-body text-brand-brown-medium -mt-6 mb-10">Ambiente de simulação — nenhum dado de pagamento é cobrado ou armazenado.</p>

                <form id="form-pagamento" action="${pageContext.request.contextPath}/carrinho" method="POST">
                    <input type="hidden" name="acao" value="finalizar">
                    <input type="hidden" name="forma-pagamento" id="forma-pagamento" value="Pix">

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">

                        <%-- ===== Método de pagamento ===== --%>
                        <div class="lg:col-span-2 space-y-4">
                            <h2 class="font-heading text-2xl text-brand-brown-footer font-bold mb-2">Como você quer pagar?</h2>

                            <% String[][] metodos = {
                                   {"Pix", "Pix", "Aprovação imediata"},
                                   {"Cartão de crédito", "Cartão de crédito", "Em até 12x"},
                                   {"Cartão de débito", "Cartão de débito", "À vista"},
                                   {"Boleto bancário", "Boleto bancário", "Compensa em 1-2 dias"}
                               };
                               int idx = 0;
                               for (String[] m : metodos) { boolean primeiro = (idx++ == 0); %>
                            <label class="metodo-opcao flex items-center gap-3 bg-white border <%= primeiro ? "border-brand-green-btn ring-1 ring-brand-green-btn" : "border-brand-cream-dark" %> rounded-2xl p-4 cursor-pointer transition-colors">
                                <input type="radio" name="metodo" value="<%= m[0] %>" data-painel="painel-<%= idx %>" <%= primeiro ? "checked" : "" %> class="w-4 h-4 accent-brand-green-btn">
                                <div class="flex-1">
                                    <span class="font-body font-bold text-brand-brown-footer"><%= m[1] %></span>
                                    <span class="block font-body text-xs text-brand-brown-medium"><%= m[2] %></span>
                                </div>
                            </label>
                            <% } %>

                            <%-- Painéis simulados por método --%>
                            <div class="bg-brand-cream-light rounded-2xl p-6 mt-4">
                                <%-- Pix --%>
                                <div id="painel-1" class="painel-metodo">
                                    <p class="font-body font-bold text-brand-brown-footer mb-3">Pague com Pix</p>
                                    <div class="flex flex-col sm:flex-row items-center gap-5">
                                        <div class="w-36 h-36 bg-white border border-brand-cream-dark rounded-xl grid grid-cols-5 grid-rows-5 gap-0.5 p-2">
                                            <% for (int i = 0; i < 25; i++) { %>
                                            <div class="<%= (i*7+3) % 3 == 0 ? "bg-brand-brown-dark" : "bg-transparent" %> rounded-[1px]"></div>
                                            <% } %>
                                        </div>
                                        <div class="flex-1 w-full">
                                            <p class="font-body text-sm text-brand-brown-medium mb-2">Escaneie o QR Code ou copie o código:</p>
                                            <div class="flex items-center gap-2">
                                                <input type="text" readonly value="00020126aconchego5204000053039865802BR-PIX-SIMULADO"
                                                       class="flex-1 bg-white border border-brand-cream-dark rounded-lg px-3 py-2 text-xs font-body text-brand-brown-footer">
                                                <button type="button" onclick="copiarPix(this)" class="bg-brand-button hover:bg-brand-button-hover text-white text-sm px-3 py-2 rounded-lg">Copiar</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%-- Cartão de crédito --%>
                                <div id="painel-2" class="painel-metodo hidden">
                                    <p class="font-body font-bold text-brand-brown-footer mb-3">Dados do cartão de crédito</p>
                                    <div class="grid grid-cols-2 gap-3">
                                        <input type="text" placeholder="Número do cartão" inputmode="numeric" class="col-span-2 bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <input type="text" placeholder="Nome impresso no cartão" class="col-span-2 bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <input type="text" placeholder="Validade (MM/AA)" class="bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <input type="text" placeholder="CVV" inputmode="numeric" class="bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <select class="col-span-2 bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                            <option>1x sem juros</option><option>2x sem juros</option><option>3x sem juros</option>
                                            <option>6x sem juros</option><option>12x</option>
                                        </select>
                                    </div>
                                </div>
                                <%-- Cartão de débito --%>
                                <div id="painel-3" class="painel-metodo hidden">
                                    <p class="font-body font-bold text-brand-brown-footer mb-3">Dados do cartão de débito</p>
                                    <div class="grid grid-cols-2 gap-3">
                                        <input type="text" placeholder="Número do cartão" inputmode="numeric" class="col-span-2 bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <input type="text" placeholder="Nome impresso no cartão" class="col-span-2 bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <input type="text" placeholder="Validade (MM/AA)" class="bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                        <input type="text" placeholder="CVV" inputmode="numeric" class="bg-white border border-brand-cream-dark rounded-lg px-3 py-2.5 font-body text-brand-brown-footer focus:outline-none focus:ring-1 focus:ring-brand-button">
                                    </div>
                                </div>
                                <%-- Boleto --%>
                                <div id="painel-4" class="painel-metodo hidden">
                                    <p class="font-body font-bold text-brand-brown-footer mb-3">Boleto bancário</p>
                                    <p class="font-body text-sm text-brand-brown-medium mb-3">Ao confirmar, o boleto será gerado. Use a linha digitável abaixo (simulada):</p>
                                    <div class="bg-white border border-brand-cream-dark rounded-lg px-3 py-3 font-mono text-xs text-brand-brown-footer tracking-wider">
                                        34191.79001 01043.510047 91020.150008 9 99990000<%= String.format("%06d", (int)(total*100) % 1000000) %>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- ===== Resumo do pedido ===== --%>
                        <aside class="lg:col-span-1">
                            <div class="bg-white rounded-2xl border border-brand-cream-dark p-6 lg:sticky lg:top-8">
                                <h2 class="font-heading text-2xl text-brand-brown-footer font-bold mb-4">Resumo</h2>
                                <div class="space-y-2 mb-4">
                                    <% for (int i = 0; i < itens.size(); i++) {
                                           Produto p = itens.get(i); int qtd = quantidades.get(i);
                                           String sub = String.format("R$ %.2f", p.getPreco() * qtd).replace('.', ','); %>
                                    <div class="flex justify-between font-body text-sm">
                                        <span class="text-brand-brown-footer"><%= p.getNome() %> <span class="text-brand-brown-medium">× <%= qtd %></span></span>
                                        <span class="text-brand-brown-footer font-bold"><%= sub %></span>
                                    </div>
                                    <% } %>
                                </div>
                                <hr class="border-brand-cream-dark mb-4">
                                <div class="flex items-center justify-between mb-6">
                                    <span class="font-body text-brand-brown-medium">Total</span>
                                    <span class="font-heading text-3xl font-bold text-brand-brown-footer"><%= totalFmt %></span>
                                </div>
                                <button type="submit" class="btn-green w-full text-lg">Confirmar pagamento</button>
                                <a href="${pageContext.request.contextPath}/carrinho" class="block text-center mt-3 font-body text-sm text-brand-brown-medium hover:text-brand-brown-footer">← Voltar ao carrinho</a>
                            </div>
                        </aside>
                    </div>
                </form>
            </section>
        </main>
        <%@ include file='WEB-INF/includes/footer.jsp' %>

        <%-- Overlay de processamento --%>
        <div id="overlay-processando" class="hidden fixed inset-0 z-50 flex flex-col items-center justify-center bg-white/90">
            <div class="w-14 h-14 border-4 border-brand-cream-dark border-t-brand-green-btn rounded-full animate-spin mb-4"></div>
            <p class="font-heading text-2xl text-brand-brown-footer font-bold">Processando pagamento...</p>
            <p class="font-body text-brand-brown-medium mt-1" id="overlay-metodo">Pix</p>
        </div>

        <script>
            (function () {
                const hidden = document.getElementById('forma-pagamento');
                const overlayMetodo = document.getElementById('overlay-metodo');

                document.querySelectorAll('input[name="metodo"]').forEach(function (radio) {
                    radio.addEventListener('change', function () {
                        hidden.value = radio.value;
                        document.querySelectorAll('.painel-metodo').forEach(function (pn) { pn.classList.add('hidden'); });
                        const alvo = document.getElementById(radio.dataset.painel);
                        if (alvo) { alvo.classList.remove('hidden'); }
                        document.querySelectorAll('.metodo-opcao').forEach(function (op) {
                            op.classList.remove('border-brand-green-btn', 'ring-1', 'ring-brand-green-btn');
                            op.classList.add('border-brand-cream-dark');
                        });
                        const opcao = radio.closest('.metodo-opcao');
                        opcao.classList.add('border-brand-green-btn', 'ring-1', 'ring-brand-green-btn');
                        opcao.classList.remove('border-brand-cream-dark');
                    });
                });

                let enviando = false;
                document.getElementById('form-pagamento').addEventListener('submit', function (e) {
                    if (enviando) { return; }
                    e.preventDefault();
                    enviando = true;
                    overlayMetodo.textContent = hidden.value;
                    document.getElementById('overlay-processando').classList.remove('hidden');
                    setTimeout(function () { e.target.submit(); }, 1600);
                });
            })();

            function copiarPix(botao) {
                const input = botao.previousElementSibling;
                input.select();
                try { document.execCommand('copy'); botao.textContent = 'Copiado!'; setTimeout(function(){ botao.textContent = 'Copiar'; }, 1500); } catch (e) {}
            }
        </script>
    </body>
</html>
