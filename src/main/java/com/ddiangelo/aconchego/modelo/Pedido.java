package com.ddiangelo.aconchego.modelo;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Pedido {

    private int id;
    private Timestamp dataHora;
    private int usuarioId;
    private String formaPagamento;
    private double total;

    private String usuarioNome;
    private List<PedidoItem> itens = new ArrayList<PedidoItem>();

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getDataHora() {
        return dataHora;
    }

    public void setDataHora(Timestamp dataHora) {
        this.dataHora = dataHora;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getFormaPagamento() {
        return formaPagamento;
    }

    public void setFormaPagamento(String formaPagamento) {
        this.formaPagamento = formaPagamento;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getUsuarioNome() {
        return usuarioNome;
    }

    public void setUsuarioNome(String usuarioNome) {
        this.usuarioNome = usuarioNome;
    }

    public List<PedidoItem> getItens() {
        return itens;
    }

    public void setItens(List<PedidoItem> itens) {
        this.itens = itens;
    }

    public int getQuantidadeTotal() {
        int q = 0;
        for (PedidoItem i : itens) {
            q += i.getQuantidade();
        }
        return q;
    }

}
