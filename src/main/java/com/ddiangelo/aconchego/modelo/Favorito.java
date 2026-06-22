package com.ddiangelo.aconchego.modelo;

public class Favorito {

    private int usuarioId;
    private int produtoId;

    public Favorito() {
    }

    public Favorito(int usuarioId, int produtoId) {
        this.usuarioId = usuarioId;
        this.produtoId = produtoId;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public int getProdutoId() {
        return produtoId;
    }

    public void setProdutoId(int produtoId) {
        this.produtoId = produtoId;
    }

}
