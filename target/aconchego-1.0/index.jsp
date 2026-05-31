<%-- 
    Document   : index
    Created on : 31 de mai. de 2026, 15:04:38
    Author     : thimo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <%@ include file='WEB-INF/includes/head.jsp' %>
</head>
<body>
    <%@ include file='WEB-INF/includes/header.jsp' %>
    <main>
        <section class="section-container mt-8 grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
            <div>
              <h1 class="font-heading text-display-1 text-brand-brown-dark font-bold italic mb-6">Que bom que você está aqui!</h1>
              <p class="text-description mb-6">
                Se você nos encontrou, é porque está em busca de um momento de aconchego... de pausa, e de conexão... também com aquilo que você decora para sua casa, escritório...
              </p>
              <p class="text-description">
                Sinta-se à vontade para nos conhecer e curtir todas as nossas novidades! É sempre um prazer poder te encontrar.
              </p>
            </div>
            <div class="w-full aspect-video bg-gray-100 flex items-center justify-center rounded-xl">
              <svg class="w-16 h-16 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
            </div>
          </section>

          <section class="section-container bg-brand-cream-light py-12 rounded-3xl">
            <h2 class="title-section">Artesanatos</h2>
            <p class="text-description text-center max-w-3xl mx-auto mb-10">Toda a nossa linha de cerâmica é feita à mão, curada e modelada com muito cuidado. Buscamos resgatar a arte do "fazer manual" que traz aconchego e originalidade para os ambientes onde elas ganham vida.</p>

            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-card-gap">
              <div class="card-product">
                <div class="card-product-image-wrapper">
                  <div class="absolute top-2 left-2 text-gray-400"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg></div>
                  <span class="text-gray-400">Imagem do Vaso</span>
                </div>
                <h3 class="card-product-title">Vaso Decorativo</h3>
                <p class="text-sm text-brand-brown-medium mb-4">R$ 59,90</p>
                <button class="absolute bottom-4 right-4 bg-white p-2 rounded-full shadow-sm border border-gray-100 hover:bg-gray-50">
                  <svg class="w-5 h-5 text-brand-button" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </button>
              </div>

              <div class="card-product">
                <div class="card-product-image-wrapper">
                  <div class="absolute top-2 left-2 text-gray-400"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg></div>
                  <span class="text-gray-400">Imagem Caneca</span>
                </div>
                <h3 class="card-product-title">Caneca Plano</h3>
                <p class="text-sm text-brand-brown-medium mb-4">R$ 35,90</p>
                <button class="absolute bottom-4 right-4 bg-white p-2 rounded-full shadow-sm border border-gray-100 hover:bg-gray-50">
                  <svg class="w-5 h-5 text-brand-button" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </button>
              </div>

              <div class="card-product">
                <div class="card-product-image-wrapper">
                  <div class="absolute top-2 left-2 text-gray-400"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg></div>
                  <svg class="w-10 h-10 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="card-product-title">Prato Retrô</h3>
                <p class="text-sm text-brand-brown-medium mb-4">R$ 49,90</p>
                <button class="absolute bottom-4 right-4 bg-white p-2 rounded-full shadow-sm border border-gray-100 hover:bg-gray-50">
                  <svg class="w-5 h-5 text-brand-button" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </button>
              </div>

              <div class="card-product">
                <div class="card-product-image-wrapper">
                  <div class="absolute top-2 left-2 text-gray-400"><svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg></div>
                  <svg class="w-10 h-10 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="card-product-title">Cesto Trama</h3>
                <p class="text-sm text-brand-brown-medium mb-4">R$ 89,90</p>
                <button class="absolute bottom-4 right-4 bg-white p-2 rounded-full shadow-sm border border-gray-100 hover:bg-gray-50">
                  <svg class="w-5 h-5 text-brand-button" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </button>
              </div>
            </div>

            <div class="mt-10 text-center">
              <button class="btn-brown">Ver mais</button>
            </div>
          </section>

          <section class="section-container grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
            <div class="w-full aspect-video bg-gray-200 rounded-2xl overflow-hidden flex items-center justify-center">
              <span class="text-gray-500">Imagem Cesta/Lavanda/Janela</span>
            </div>
            <div>
              <h2 class="font-heading text-heading-1 font-bold text-brand-green-btn italic mb-4">Oficina do Criar</h2>
              <p class="text-description mb-6">
                Acreditamos no poder curativo do fazer manual. O projeto "Faça Você Mesmo" (FVM) promove a arte como terapia para criar um universo onde haja harmonia e presença nas pequenas coisas. Este é o nosso espaço de refúgio, um lugar para resgatar sua essência criativa.
              </p>
              <button class="btn-green">Conheça nossos kits</button>
            </div>
          </section>

          <div class="bg-brand-cream-dark py-16 mb-section-gap">
            <section class="container mx-auto px-gutter max-w-5xl">
              <h2 class="title-section mb-4">Clube de Cortes</h2>
              <p class="text-description text-center max-w-3xl mx-auto mb-10">Este é o coração do nosso projeto de curadoria. Toda a curadoria é pensada para "juntar" histórias de cortes, criatividade e projetos manuais para quem busca conectar o seu lado criativo a uma rede de fazedores.</p>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div class="card-plan">
                  <div class="w-full h-40 bg-gray-100 rounded-xl mb-6 flex items-center justify-center overflow-hidden">
                     <span class="text-gray-400">Imagem Teclado/Mesa</span>
                  </div>
                  <div>
                    <h3 class="font-heading text-xl font-bold italic text-brand-brown-dark">Plano Mensal</h3>
                    <p class="font-body text-price text-brand-brown-dark font-bold mt-2 mb-4">R$ 44,90 <span class="text-sm font-normal">/mês</span></p>
                    <p class="text-sm font-bold text-brand-brown-dark mb-2">Este plano irá te oferecer:</p>
                    <p class="text-sm text-brand-brown-medium mb-6">Acesso à nossa curadoria mensal de referências e inspirações.</p>
                  </div>
                  <button class="btn-brown w-full">Quero receber esta oferta!</button>
                </div>

                <div class="card-plan-highlight relative overflow-hidden">
                  <div class="w-full h-40 bg-yellow-400 rounded-xl mb-6 flex items-center justify-center overflow-hidden">
                     <span class="text-gray-800">Imagem Câmera/Mão (Amarelo)</span>
                  </div>
                  <div>
                    <h3 class="font-heading text-xl font-bold italic text-brand-brown-dark">Plano Anual</h3>
                    <p class="font-body text-price text-brand-brown-dark font-bold mt-2 mb-4">R$ 149,90 <span class="text-sm font-normal">/ano</span></p>
                    <p class="text-sm font-bold text-brand-brown-dark mb-2">Este plano irá te oferecer:</p>
                    <p class="text-sm text-brand-brown-medium mb-6">Acesso total à plataforma, projetos e caixas exclusivas.</p>
                  </div>
                  <button class="btn-brown w-full">Quero receber esta oferta!</button>
                </div>
              </div>
            </section>
          </div>

          <section class="section-container grid grid-cols-1 md:grid-cols-2 gap-12 items-center mb-16">
            <div>
              <h2 class="font-heading text-display-1 text-brand-brown-dark font-bold italic mb-6">Aqui é onde o amor faz morada...</h2>
              <p class="text-description mb-6">
                No "Artesanal", o seu espaço de aconchego te espera... Faça de suas peças, projetos que carregam história... um reflexo de sua alma. É aqui que o seu dia a dia se mistura com o que é belo, criando um refúgio para onde você se retira e encontra o conforto e a criatividade de que tanto precisa.
              </p>
              <button class="btn-brown">Saiba mais</button>
            </div>
            <div class="w-full aspect-square bg-gray-100 flex items-center justify-center rounded-xl">
              <svg class="w-16 h-16 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
            </div>
          </section>
    </main>
    <%@ include file='WEB-INF/includes/footer.jsp' %>
</body>
</html>