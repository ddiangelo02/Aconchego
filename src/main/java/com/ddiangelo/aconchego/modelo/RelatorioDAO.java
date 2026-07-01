package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;

public class RelatorioDAO {

    public double faturamentoTotal() {
        return umDouble("SELECT COALESCE(SUM(total), 0) FROM pedidos");
    }

    public int totalPedidos() {
        return umInt("SELECT COUNT(*) FROM pedidos");
    }

    public long itensVendidos() {
        return umLong("SELECT COALESCE(SUM(quantidade), 0) FROM pedido_itens");
    }

    public List<LinhaRelatorio> produtosMaisVendidos() {
        return lista(
                "SELECT pr.nome, SUM(i.quantidade) AS qtd, SUM(i.quantidade * i.preco_unitario) AS receita "
                + "FROM pedido_itens i JOIN produtos pr ON pr.id = i.produto_id "
                + "GROUP BY pr.nome ORDER BY qtd DESC, receita DESC LIMIT 10");
    }

    public List<LinhaRelatorio> porFormaPagamento() {
        return lista(
                "SELECT COALESCE(forma_pagamento, 'Não informado') AS rotulo, COUNT(*) AS qtd, SUM(total) AS receita "
                + "FROM pedidos GROUP BY forma_pagamento ORDER BY receita DESC");
    }

    public List<LinhaRelatorio> topClientes() {
        return lista(
                "SELECT u.nome AS rotulo, COUNT(p.id) AS qtd, SUM(p.total) AS receita "
                + "FROM pedidos p JOIN usuarios u ON u.id = p.usuario_id "
                + "GROUP BY u.nome ORDER BY receita DESC LIMIT 10");
    }

    // ---- helpers ----

    private List<LinhaRelatorio> lista(String sql) {
        List<LinhaRelatorio> resultado = new ArrayList<LinhaRelatorio>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                resultado.add(new LinhaRelatorio(rs.getString(1), rs.getLong(2), rs.getDouble(3)));
            }
            rs.close();
            statement.close();
            connection.close();
        } catch (SQLException ex) {
            return resultado;
        }
        return resultado;
    }

    private double umDouble(String sql) {
        try {
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            double v = rs.next() ? rs.getDouble(1) : 0;
            rs.close();
            statement.close();
            connection.close();
            return v;
        } catch (SQLException ex) {
            return 0;
        }
    }

    private int umInt(String sql) {
        return (int) umLong(sql);
    }

    private long umLong(String sql) {
        try {
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            long v = rs.next() ? rs.getLong(1) : 0;
            rs.close();
            statement.close();
            connection.close();
            return v;
        } catch (SQLException ex) {
            return 0;
        }
    }
}
