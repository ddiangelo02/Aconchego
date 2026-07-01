package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;

public class PedidoDAO {

    public int criar(int usuarioId, String formaPagamento, List<PedidoItem> itens) {
        if (itens == null || itens.isEmpty()) {
            return -1;
        }
        double total = 0;
        for (PedidoItem item : itens) {
            total += item.getSubtotal();
        }

        Connection connection = null;
        try {
            connection = ConnectionFactory.getConnection();
            connection.setAutoCommit(false);

            int pedidoId;
            try (PreparedStatement ps = connection.prepareStatement(
                    "INSERT INTO pedidos (data_hora, usuario_id, forma_pagamento, total) VALUES (?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                ps.setInt(2, usuarioId);
                ps.setString(3, formaPagamento);
                ps.setDouble(4, total);
                ps.executeUpdate();
                try (ResultSet chaves = ps.getGeneratedKeys()) {
                    if (!chaves.next()) {
                        connection.rollback();
                        return -1;
                    }
                    pedidoId = chaves.getInt(1);
                }
            }

            try (PreparedStatement psItem = connection.prepareStatement(
                    "INSERT INTO pedido_itens (pedido_id, produto_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)")) {
                for (PedidoItem item : itens) {
                    psItem.setInt(1, pedidoId);
                    psItem.setInt(2, item.getProdutoId());
                    psItem.setInt(3, item.getQuantidade());
                    psItem.setDouble(4, item.getPrecoUnitario());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            connection.commit();
            return pedidoId;

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            try { if (connection != null) connection.rollback(); } catch (SQLException ignore) {}
            return -1;
        } finally {
            try { if (connection != null) { connection.setAutoCommit(true); connection.close(); } } catch (SQLException ignore) {}
        }
    }

    public List<Pedido> obterTodos() {
        List<Pedido> resultado = new ArrayList<Pedido>();
        try {
            Connection connection = ConnectionFactory.getConnection();

            try (Statement statement = connection.createStatement();
                 ResultSet rs = statement.executeQuery(
                     "SELECT p.id, p.data_hora, p.usuario_id, p.forma_pagamento, p.total, u.nome AS usuario_nome "
                     + "FROM pedidos p JOIN usuarios u ON u.id = p.usuario_id ORDER BY p.data_hora DESC, p.id DESC")) {
                while (rs.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setId(rs.getInt("id"));
                    pedido.setDataHora(rs.getTimestamp("data_hora"));
                    pedido.setUsuarioId(rs.getInt("usuario_id"));
                    pedido.setFormaPagamento(rs.getString("forma_pagamento"));
                    pedido.setTotal(rs.getDouble("total"));
                    pedido.setUsuarioNome(rs.getString("usuario_nome"));
                    resultado.add(pedido);
                }
            }

            try (PreparedStatement psItens = connection.prepareStatement(
                    "SELECT i.produto_id, i.quantidade, i.preco_unitario, pr.nome AS produto_nome "
                    + "FROM pedido_itens i JOIN produtos pr ON pr.id = i.produto_id WHERE i.pedido_id = ? ORDER BY i.id")) {
                for (Pedido pedido : resultado) {
                    psItens.setInt(1, pedido.getId());
                    try (ResultSet ri = psItens.executeQuery()) {
                        List<PedidoItem> itens = new ArrayList<PedidoItem>();
                        while (ri.next()) {
                            PedidoItem item = new PedidoItem();
                            item.setProdutoId(ri.getInt("produto_id"));
                            item.setQuantidade(ri.getInt("quantidade"));
                            item.setPrecoUnitario(ri.getDouble("preco_unitario"));
                            item.setProdutoNome(ri.getString("produto_nome"));
                            itens.add(item);
                        }
                        pedido.setItens(itens);
                    }
                }
            }

            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return resultado;
    }

    public List<Pedido> obterPorUsuario(int usuarioId) {
        List<Pedido> resultado = new ArrayList<Pedido>();
        try {
            Connection connection = ConnectionFactory.getConnection();

            try (PreparedStatement ps = connection.prepareStatement(
                    "SELECT p.id, p.data_hora, p.usuario_id, p.forma_pagamento, p.total, u.nome AS usuario_nome "
                    + "FROM pedidos p JOIN usuarios u ON u.id = p.usuario_id "
                    + "WHERE p.usuario_id = ? ORDER BY p.data_hora DESC, p.id DESC")) {
                ps.setInt(1, usuarioId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Pedido pedido = new Pedido();
                        pedido.setId(rs.getInt("id"));
                        pedido.setDataHora(rs.getTimestamp("data_hora"));
                        pedido.setUsuarioId(rs.getInt("usuario_id"));
                        pedido.setFormaPagamento(rs.getString("forma_pagamento"));
                        pedido.setTotal(rs.getDouble("total"));
                        pedido.setUsuarioNome(rs.getString("usuario_nome"));
                        resultado.add(pedido);
                    }
                }
            }

            try (PreparedStatement psItens = connection.prepareStatement(
                    "SELECT i.produto_id, i.quantidade, i.preco_unitario, pr.nome AS produto_nome "
                    + "FROM pedido_itens i JOIN produtos pr ON pr.id = i.produto_id WHERE i.pedido_id = ? ORDER BY i.id")) {
                for (Pedido pedido : resultado) {
                    psItens.setInt(1, pedido.getId());
                    try (ResultSet ri = psItens.executeQuery()) {
                        List<PedidoItem> itens = new ArrayList<PedidoItem>();
                        while (ri.next()) {
                            PedidoItem item = new PedidoItem();
                            item.setProdutoId(ri.getInt("produto_id"));
                            item.setQuantidade(ri.getInt("quantidade"));
                            item.setPrecoUnitario(ri.getDouble("preco_unitario"));
                            item.setProdutoNome(ri.getString("produto_nome"));
                            itens.add(item);
                        }
                        pedido.setItens(itens);
                    }
                }
            }

            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return resultado;
    }

    public boolean excluir(int pedidoId) {
        Connection connection = null;
        try {
            connection = ConnectionFactory.getConnection();
            connection.setAutoCommit(false);

            // Cancelamento: devolve ao estoque a quantidade de cada item do pedido
            try (PreparedStatement psRestore = connection.prepareStatement(
                    "UPDATE produtos p SET quantidade = p.quantidade + i.quantidade "
                    + "FROM pedido_itens i WHERE i.produto_id = p.id AND i.pedido_id = ?")) {
                psRestore.setInt(1, pedidoId);
                psRestore.executeUpdate();
            }

            boolean ok;
            try (PreparedStatement ps = connection.prepareStatement("DELETE FROM pedidos WHERE id = ?")) {
                ps.setInt(1, pedidoId);
                ok = ps.executeUpdate() == 1;
            }

            if (ok) {
                connection.commit();
            } else {
                connection.rollback();
            }
            return ok;

        } catch (SQLException ex) {
            try { if (connection != null) connection.rollback(); } catch (SQLException ignore) {}
            return false;
        } finally {
            try { if (connection != null) { connection.setAutoCommit(true); connection.close(); } } catch (SQLException ignore) {}
        }
    }

    public int contarTodos() {
        int total = 0;
        try {
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) FROM pedidos");
            if (resultSet.next()) {
                total = resultSet.getInt(1);
            }
            resultSet.close();
            statement.close();
            connection.close();
        } catch (SQLException ex) {
            return 0;
        }
        return total;
    }

}
