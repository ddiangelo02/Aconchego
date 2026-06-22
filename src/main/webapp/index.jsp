

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.ddiangelo.aconchego.modelo.Produto"%>
<%@page import="com.ddiangelo.aconchego.modelo.ProdutoDAO"%>
<%@taglib prefix="ac" tagdir="/WEB-INF/tags" %>
<%

    List<Produto> produtosVitrine = new ProdutoDAO().obterTodos();

    java.util.Set<Integer> favIds = new java.util.HashSet<Integer>();
    Object _usuarioLogado = session.getAttribute("usuario");
    if (_usuarioLogado instanceof com.ddiangelo.aconchego.modelo.Usuario) {
        favIds = new com.ddiangelo.aconchego.modelo.FavoritoDAO().idsFavoritos(((com.ddiangelo.aconchego.modelo.Usuario) _usuarioLogado).getId());
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <%@ include file='WEB-INF/includes/head.jsp' %>
    </head>
    <body>
        <%@ include file='WEB-INF/includes/header.jsp' %>
        <main>
            <section class="section-container mt-16 grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                <div>
                    <h1 class="font-heading text-display-1 text-brand-brown-footer font-bold mb-6">Que bom que você está aqui!</h1>
                    <p class="text-description mb-6">
                        Se você nos encontrou, é porque está em busca de um momento de aconchego, de pausa e de conexão... Conexão com alguém que você deixou para trás em algum momento... Você!
                    </p>
                    <p class="text-description">
                        Sinta-se à vontade para nos conhecer e assim, talvez, se conhecer também! É sempre um prazer poder se reencontrar.
                    </p>
                </div>
                <div>
                    <img src="${pageContext.request.contextPath}/images/aconchego-espaco-1.png" alt="Um espaço de aconchegô" class="w-full aspect-video flex items-center justify-center rounded-xl shadow-lg">
                </div>
            </section>
            
            <section class="mx-auto mt-16 bg-brand-cream-light py-12 rounded-3xl">
                <h2 class="title-section !mb-4">Artesanatos</h2>
                <p class="text-description text-center mx-auto mb-10">Peças únicas e finalizadas com todo o cuidado por nossas mãos.<br>Itens prontos para levar beleza e identidade para o seu dia a dia ou para o lar de quem você ama.</p>

                <% if (produtosVitrine != null && !produtosVitrine.isEmpty()) {

                       produtosVitrine.sort((pv1, pv2) -> Boolean.compare(pv1.getQuantidade() <= 0, pv2.getQuantidade() <= 0)); %>
                <div class="relative px-4">
                    <div class="flex justify-end gap-2 mb-4">
                        <button type="button" onclick="moverSlider(-1)" aria-label="Anterior" class="w-10 h-10 rounded-full border border-brand-cream-dark bg-white flex items-center justify-center text-brand-brown-footer hover:bg-brand-cream-dark/40 transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                        </button>
                        <button type="button" onclick="moverSlider(1)" aria-label="Próximo" class="w-10 h-10 rounded-full border border-brand-cream-dark bg-white flex items-center justify-center text-brand-brown-footer hover:bg-brand-cream-dark/40 transition-colors">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                        </button>
                    </div>
                    <div id="slider-track" class="flex gap-card-gap overflow-x-auto scroll-smooth pb-4" style="scrollbar-width:none;-ms-overflow-style:none;">
                        <% for (Produto pv : produtosVitrine) {
                               boolean fav = favIds.contains(pv.getId()); %>
                        <div class="shrink-0 w-60">
                            <ac:card-produto produto="<%= pv %>" origem="/" favorito="<%= fav %>" />
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>

                <div class="mt-10 text-center">
                    <a href="${pageContext.request.contextPath}/loja" class="btn-brown">Ver todos os produtos</a>
                </div>
                <script>
                    function moverSlider(dir) {
                        var t = document.getElementById('slider-track');
                        if (t) { t.scrollBy({ left: dir * 320, behavior: 'smooth' }); }
                    }
                </script>
            </section>

            
            
            <section class="section-container grid grid-cols-1 md:grid-cols-2 gap-12 mt-16 items-center">
                <div class="w-full aspect-video bg-gray-200 rounded-2xl overflow-hidden flex items-center justify-center">
                    <img src="${pageContext.request.contextPath}/images/aconchego-espaco-2.png" alt="Um espaço de aconchegô" class="w-full aspect-video flex items-center justify-center rounded-xl shadow-lg">
                </div>
                <div>
                    <h2 class="font-heading text-heading-1 font-bold text-brand-green-btn mb-4">Oficina do Criar</h2>
                    <p class="text-description mb-6 !text-brand-green-btn">
                        Acreditamos no poder curativo do fazer manual. Nossos kits de "Faça Você Mesmo" (DIY) oferecem tudo o que você precisa para criar sua própria arte, seja bordado, pintura ou customização. Não é sobre perfeição, é sobre o prazer de ver algo nascer entre seus dedos. O guia perfeito para o seu momento de lazer criativo.
                    </p>
                    <button class="btn-green">Conheça nossos kits</button>
                </div>
            </section>

            <div class="bg-brand-cream-dark py-16 mb-section-gap mt-16">
                <section class="container mx-auto px-gutter max-w-5xl">
                    <h2 class="title-section mb-4">Clube de Cartas</h2>
                    <p class="text-description text-center max-w-3xl mx-auto mb-10">Este é o coração do nosso projeto. Ao assinar, você recebe mensalmente em sua casa uma curadoria inspirada no ritmo da natureza. Cada kit é um convite para “pausar”, contendo cartas, poesias, elementos naturais, calendários lunares e presentes que alimentam a alma. Escolha o seu plano e permita-se o luxo de desacelerar.</p>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="card-plan">
                            <div class="w-full h-40 bg-gray-100 rounded-xl mb-6 flex items-center justify-center overflow-hidden">
                                <span class="text-gray-400">Imagem Teclado/Mesa</span>
                            </div>
                            <div>
                                <h3 class="font-heading text-xl font-bold text-brand-brown-footer">Plano Mensal</h3>
                                <p class="font-body text-price text-brand-brown-footer font-bold mt-2 mb-4">R$ 44,90 <span class="text-sm font-normal">/mês</span></p>
                                <p class="text-sm font-bold text-brand-brown-footer mb-2">Este plano irá te oferecer:</p>
                                <p class="text-sm text-brand-brown-medium mb-6">Acesso à nossa curadoria mensal de referências e inspirações.</p>
                            </div>
                            <button class="btn-brown w-full">Quero receber esta oferta!</button>
                        </div>

                        <div class="card-plan-highlight relative overflow-hidden">
                            <div class="w-full h-40 bg-yellow-400 rounded-xl mb-6 flex items-center justify-center overflow-hidden">
                                <span class="text-gray-800">Imagem Câmera/Mão (Amarelo)</span>
                            </div>
                            <div>
                                <h3 class="font-heading text-xl font-bold text-brand-brown-footer">Plano Anual</h3>
                                <p class="font-body text-price text-brand-brown-footer font-bold mt-2 mb-4">R$ 149,90 <span class="text-sm font-normal">/ano</span></p>
                                <p class="text-sm font-bold text-brand-brown-footer mb-2">Este plano irá te oferecer:</p>
                                <p class="text-sm text-brand-brown-medium mb-6">Acesso total à plataforma, projetos e caixas exclusivas.</p>
                            </div>
                            <button class="btn-brown w-full">Quero receber esta oferta!</button>
                        </div>
                    </div>
                </section>
            </div>

            <section class="section-container grid grid-cols-1 md:grid-cols-3 gap-12 items-center mb-16">
                <div class="col-span-2">
                    <h2 class="font-heading text-display-1 text-brand-brown-footer font-bold mb-6">Aqui é onde o amor faz morada...</h2>
                    <p class="text-description mb-6">
                        No Aconchegô, nosso bem mais precioso é o tempo.<br>Cada um de nossos produtos carrega o cuidado das mãos e um convite para desacelerar. Mais do que apenas um produto, queremos entregar um momento, uma experiência de se conectar com o que é importante e perceber que a vida acontece nos intervalos, e a beleza se esconde na simplicidade de um detalhe feito com afeto.
                    </p>
                    <button class="btn-brown">Saiba mais</button>
                </div>
                    <img src="${pageContext.request.contextPath}/images/aconchego-espaco-3.png" alt="Um espaço de aconchegô" class="w-full flex items-center justify-center rounded-xl shadow-lg">
            </section>
        </main>
        <%@ include file='WEB-INF/includes/footer.jsp' %>
    </body>
</html>
