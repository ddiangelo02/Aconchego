package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;

public class ProdutoDAO {

    private static final String SELECT_BASE =
            "SELECT p.id, p.nome, p.descricao, p.preco, p.foto, p.quantidade, p.categoria_id, "
            + "c.nome AS categoria_nome FROM produtos p LEFT JOIN categorias c ON c.id = p.categoria_id";

    public List<Produto> obterTodos() {
        List<Produto> resultado = new ArrayList<Produto>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery(SELECT_BASE + " ORDER BY p.id");
            while (resultSet.next()) {
                resultado.add(montar(resultSet));
            }
            resultSet.close();
            statement.close();
            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return resultado;
    }

    public Produto obterPeloId(int id) {
        Produto produto = null;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(SELECT_BASE + " WHERE p.id = ?");
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                produto = montar(resultSet);
            }
            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return produto;
    }

    public List<Produto> buscar(String termo) {
        List<Produto> resultado = new ArrayList<Produto>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    SELECT_BASE + " WHERE LOWER(p.nome) LIKE ? OR LOWER(p.descricao) LIKE ? ORDER BY p.nome LIMIT 8");
            String like = "%" + (termo == null ? "" : termo.toLowerCase()) + "%";
            preparedStatement.setString(1, like);
            preparedStatement.setString(2, like);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                resultado.add(montar(resultSet));
            }
            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return resultado;
        }
        return resultado;
    }

    public int inserirEObterId(String nome, String descricao, double preco, String foto, int quantidade, int categoriaId) {
        int id = -1;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "INSERT INTO produtos (nome, descricao, preco, foto, quantidade, categoria_id) VALUES (?, ?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, descricao);
            preparedStatement.setDouble(3, preco);
            preparedStatement.setString(4, foto);
            preparedStatement.setInt(5, quantidade);
            setCategoria(preparedStatement, 6, categoriaId);
            if (preparedStatement.executeUpdate() == 1) {
                ResultSet chaves = preparedStatement.getGeneratedKeys();
                if (chaves.next()) {
                    id = chaves.getInt(1);
                }
                chaves.close();
            }
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return -1;
        }
        return id;
    }

    public boolean atualizarProduto(String nome, String descricao, double preco, String foto, int quantidade, int categoriaId, int id) {
        boolean sucesso = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "UPDATE produtos SET nome = ?, descricao = ?, preco = ?, foto = ?, quantidade = ?, categoria_id = ? WHERE id = ?");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, descricao);
            preparedStatement.setDouble(3, preco);
            preparedStatement.setString(4, foto);
            preparedStatement.setInt(5, quantidade);
            setCategoria(preparedStatement, 6, categoriaId);
            preparedStatement.setInt(7, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    public boolean baixarEstoque(int id, int quantidade) {
        boolean sucesso = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "UPDATE produtos SET quantidade = quantidade - ? WHERE id = ? AND quantidade >= ?");
            preparedStatement.setInt(1, quantidade);
            preparedStatement.setInt(2, id);
            preparedStatement.setInt(3, quantidade);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    public boolean atualizarEstoque(int id, int quantidade) {
        boolean sucesso = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE produtos SET quantidade = ? WHERE id = ?");
            preparedStatement.setInt(1, quantidade);
            preparedStatement.setInt(2, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    public int contarSemEstoque() {
        int total = 0;
        try {
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) FROM produtos WHERE quantidade = 0");
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

    public boolean removerProduto(int id) {
        boolean sucesso = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("DELETE FROM produtos WHERE id = ?");
            preparedStatement.setInt(1, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    private void setCategoria(PreparedStatement ps, int index, int categoriaId) throws SQLException {
        if (categoriaId > 0) {
            ps.setInt(index, categoriaId);
        } else {
            ps.setNull(index, Types.INTEGER);
        }
    }

    private Produto montar(ResultSet resultSet) throws SQLException {
        Produto produto = new Produto();
        produto.setId(resultSet.getInt("id"));
        produto.setNome(resultSet.getString("nome"));
        produto.setDescricao(resultSet.getString("descricao"));
        produto.setPreco(resultSet.getDouble("preco"));
        produto.setFoto(resultSet.getString("foto"));
        produto.setQuantidade(resultSet.getInt("quantidade"));
        produto.setCategoriaId(resultSet.getInt("categoria_id"));
        produto.setCategoriaNome(resultSet.getString("categoria_nome"));
        return produto;
    }

}
