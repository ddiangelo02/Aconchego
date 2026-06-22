package com.ddiangelo.aconchego.modelo;

import java.util.LinkedHashMap;
import java.util.Map;

public class Carrinho {

    private final Map<Integer, Integer> itens = new LinkedHashMap<Integer, Integer>();

    public void adicionar(int produtoId, int quantidade) {
        if (quantidade <= 0) {
            return;
        }
        int atual = itens.getOrDefault(produtoId, 0);
        itens.put(produtoId, atual + quantidade);
    }

    public void atualizar(int produtoId, int quantidade) {
        if (quantidade <= 0) {
            itens.remove(produtoId);
        } else {
            itens.put(produtoId, quantidade);
        }
    }

    public void remover(int produtoId) {
        itens.remove(produtoId);
    }

    public void limpar() {
        itens.clear();
    }

    public Map<Integer, Integer> getItens() {
        return itens;
    }

    public int getTotalItens() {
        int total = 0;
        for (int q : itens.values()) {
            total += q;
        }
        return total;
    }

    public boolean isVazio() {
        return itens.isEmpty();
    }

}
