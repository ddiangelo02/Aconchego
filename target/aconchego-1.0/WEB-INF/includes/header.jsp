<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.ddiangelo.aconchego.modelo.Usuario"%>
<%@page import="com.ddiangelo.aconchego.modelo.UsuarioDAO"%>
<%
    Usuario usuario = null;
    if (session.getAttribute("usuario") != null && session.getAttribute("usuario") instanceof Usuario) {
        Usuario usuario_sessao = (Usuario)session.getAttribute("usuario");
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        usuario = usuarioDAO.obterPeloId(usuario_sessao.getId());
    }
%>
<header class="flex items-center justify-center py-8 gap-16 shadow-md">

    <div class="flex items-center gap-2">
        <a href="${pageContext.request.contextPath}">
            <img src="${pageContext.request.contextPath}/images/aconchego-logo.svg" >
        </a>
    </div>

    <%
        String urlAtual = request.getRequestURI();
        String link = "/login";

        if (!urlAtual.equals(link)) { %>

    <div class="hidden md:flex w-1/3 relative">
        <input type="search" id="busca-input" placeholder="O que você procura?" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" readonly onfocus="this.removeAttribute('readonly')" data-lpignore="true" class="w-full bg-white border border-gray-200 rounded-full px-6 py-2 text-sm focus:outline-none focus:border-brand-button">
        <div id="busca-resultados" class="hidden absolute top-full left-0 right-0 mt-2 bg-white border border-gray-200 rounded-2xl shadow-lg z-50 overflow-hidden max-h-96 overflow-y-auto"></div>
    </div>
    <% } %>

    <div class="flex items-center justify-center gap-4 text-brand-brown-medium">
        <% if (usuario == null) { %>
        <button class="px-4 py-2 bg-brand-brown-footer text-white rounded-xl">
            <a href="${pageContext.request.contextPath}/login">
                <div class="flex items-center justify-center gap-2">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M7.5 17.5H4.16667C3.72464 17.5 3.30072 17.3244 2.98816 17.0118C2.67559 16.6993 2.5 16.2754 2.5 15.8333V4.16667C2.5 3.72464 2.67559 3.30072 2.98816 2.98816C3.30072 2.67559 3.72464 2.5 4.16667 2.5H7.5" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M13.3335 14.1667L17.5002 10L13.3335 5.83337" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M17.5 10H7.5" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <span>
                        Faça login
                    </span>
                </div>
            </a>
        </button>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/favoritos" title="Loja"><span class="material-symbols-rounded text-3xl">favorite</span></a>
        <a href="${pageContext.request.contextPath}/carrinho" title="Carrinho"><span class="material-symbols-rounded text-3xl">shopping_bag</span></a>
        <% if (usuario.isAdministrador()) { %>
        <a href="${pageContext.request.contextPath}/admin" title="Painel Admin"><span class="material-symbols-rounded text-3xl">dashboard_customize</span></a>
        <% } %>
        <a href="${pageContext.request.contextPath}/configuracoes"><span class="material-symbols-rounded text-3xl">account_circle</span></a>
        <button class="px-4 py-2 bg-brand-brown-footer text-white rounded-xl">
            <a href="logout">
                <div class="flex items-center justify-center gap-2">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M7.5 17.5H4.16667C3.72464 17.5 3.30072 17.3244 2.98816 17.0118C2.67559 16.6993 2.5 16.2754 2.5 15.8333V4.16667C2.5 3.72464 2.67559 3.30072 2.98816 2.98816C3.30072 2.67559 3.72464 2.5 4.16667 2.5H7.5" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M13.3335 14.1667L17.5002 10L13.3335 5.83337" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M17.5 10H7.5" stroke="#FFFFFFCC" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <span>
                        Sair
                    </span>
                </div> 
            </a> </button><% }%> 
    </div>

</header>

<script>

    (function () {
        var input = document.getElementById('busca-input');
        var box = document.getElementById('busca-resultados');
        if (!input || !box) { return; }
        var ctx = '<%= request.getContextPath() %>';
        var timer;

        function fmtPreco(v) { return 'R$ ' + Number(v).toFixed(2).replace('.', ','); }

        input.addEventListener('input', function () {
            clearTimeout(timer);
            var q = input.value.trim();
            if (q.length < 2) { box.classList.add('hidden'); box.innerHTML = ''; return; }
            timer = setTimeout(function () {
                fetch(ctx + '/busca?q=' + encodeURIComponent(q))
                    .then(function (r) { return r.json(); })
                    .then(function (itens) {
                        if (!itens.length) {
                            box.innerHTML = '<div class="px-4 py-3 text-sm text-gray-400 font-body">Nenhum produto encontrado</div>';
                        } else {
                            box.innerHTML = itens.map(function (p) {
                                return '<a href="' + ctx + '/produto?id=' + p.id + '" class="flex items-center gap-3 px-4 py-2 hover:bg-gray-50">'
                                    + '<div class="w-10 h-10 rounded-lg bg-gray-100 overflow-hidden flex items-center justify-center shrink-0">'
                                    + (p.foto ? '<img src="' + p.foto + '" class="w-full h-full object-cover">' : '')
                                    + '</div><div class="min-w-0">'
                                    + '<p class="text-sm font-bold text-brand-brown-footer truncate">' + p.nome + '</p>'
                                    + '<p class="text-xs text-brand-brown-medium">' + fmtPreco(p.preco) + '</p>'
                                    + '</div></a>';
                            }).join('');
                        }
                        box.classList.remove('hidden');
                    })
                    .catch(function () { box.classList.add('hidden'); });
            }, 250);
        });

        document.addEventListener('click', function (e) {
            if (!input.contains(e.target) && !box.contains(e.target)) { box.classList.add('hidden'); }
        });
    })();
</script>
