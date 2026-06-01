/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ddiangelo.aconchego;

import com.ddiangelo.aconchego.modelo.Usuario;
import com.ddiangelo.aconchego.modelo.UsuarioDAO;

/**
 *
 * @author thimo
 */
public class App {

    public static void main(String[] args) {

        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            boolean sucesso = usuarioDAO.inserirCliente("Dailane Florencio", "Rua 12345", "dailane.florencio@faetec.rj.gov.br", "dailane.florencio@faetec.rj.gov.br", "admin123");

            if (sucesso) {
                System.out.println("Deu bom");
            } else {
                System.out.println("Deu ruim");
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

    }
}
