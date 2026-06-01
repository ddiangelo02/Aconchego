/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ddiangelo.aconchego.modelo;

/**
 *
 * @author Usuário
 */
public class App {

    public static void main(String[] args) {
        try {
            AssinaturaDAO assinaturaDAO = new AssinaturaDAO();

            boolean sucesso = assinaturaDAO.inserirAssinatura("Clube de Cartas - Mensal", "Você receberá um conjunto de peças afetivas para o seu tempo de pausa.", 69.9);
            if (sucesso) {
                System.out.println("Deu bom");
            } else {
                System.out.println("Deu ruim");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
