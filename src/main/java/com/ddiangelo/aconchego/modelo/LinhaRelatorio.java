package com.ddiangelo.aconchego.modelo;

public class LinhaRelatorio {

    private String rotulo;
    private long quantidade;
    private double valor;

    public LinhaRelatorio() {
    }

    public LinhaRelatorio(String rotulo, long quantidade, double valor) {
        this.rotulo = rotulo;
        this.quantidade = quantidade;
        this.valor = valor;
    }

    public String getRotulo() {
        return rotulo;
    }

    public void setRotulo(String rotulo) {
        this.rotulo = rotulo;
    }

    public long getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(long quantidade) {
        this.quantidade = quantidade;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }
}
