package com.ddiangelo.aconchego.controle.admin;

import com.ddiangelo.aconchego.modelo.Usuario;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AdminFilter", urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        Object atributo = session.getAttribute("usuario");
        String contexto = req.getContextPath();

        if (!(atributo instanceof Usuario)) {
            res.sendRedirect(contexto + "/login");
            return;
        }

        Usuario usuario = (Usuario) atributo;
        if (!usuario.isAdministrador()) {
            session.setAttribute("mensagem", "Acesso restrito: área exclusiva de administradores.");
            res.sendRedirect(contexto + "/");
            return;
        }

        chain.doFilter(request, response);
    }
}
