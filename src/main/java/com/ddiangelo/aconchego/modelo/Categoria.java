/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thimo
 */
public class Categoria {

    private int id;
    private String nome;
    private List<Produto> lista_produto = new ArrayList<Produto>();


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

   

}
