package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;

/**
 *
 * @author Dailane Florencio
 *
 * Classe que implementa o padrão DAO para a entidade Produtos
 */
public class ProdutoDAO {

    /**
     * Método utilizado para obter todos os produtos existentes
     *
     * @return
     */
    public List<Produto> obterTodos() {
        List<Produto> resultado = new ArrayList<Produto>();
        try {

            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT id, nome, descricao, preco, foto, quantidade FROM produtos");

            while (resultSet.next()) {
                Produto produto = new Produto();
                produto.setId(resultSet.getInt("id"));
                produto.setNome(resultSet.getString("nome"));
                produto.setDescricao(resultSet.getString("descricao"));
                produto.setPreco(resultSet.getDouble("preco"));
                produto.setFoto(resultSet.getString("foto"));
                produto.setQuantidade(resultSet.getInt("quantidade"));
                resultado.add(produto);
            }

            resultSet.close();
            statement.close();
            connection.close();

        } catch (SQLException ex) {
            return null;
        }
        return resultado;
    }

    /**
     * Método utilizado para obter um produto existente pelo id
     *
     * @param id
     * @return
     */
    public Produto obterPeloId(int id) {
        Produto produto = null;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("SELECT id, nome, descricao, preco, foto, quantidade FROM produtos WHERE id = ?");
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                produto = new Produto();
                produto.setId(resultSet.getInt("id"));
                produto.setNome(resultSet.getString("nome"));
                produto.setDescricao(resultSet.getString("descricao"));
                produto.setPreco(resultSet.getDouble("preco"));
                produto.setFoto(resultSet.getString("foto"));
                produto.setQuantidade(resultSet.getInt("quantidade"));

            }

            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return produto;
    }

    /**
     * Método utilizado para inserir um produto
     *
     * @param nome
     * @param descricao
     * @param preco
     * @param foto
     * @param quantidade
     * @return
     */
    public boolean inserirProduto(String nome, String descricao, double preco, String foto, int quantidade) {
        boolean sucesso = false;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO produtos (nome, descricao, preco, foto, quantidade) VALUES (?, ?, ?, ?, ?)");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, descricao);
            preparedStatement.setDouble(3, preco);
            preparedStatement.setString(4, foto);
            preparedStatement.setInt(5, quantidade);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();

        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    /**
     * Método utilizado para atualizar os dados de um produto existente
     *
     * @param nome
     * @param descricao
     * @param preco
     * @param foto
     * @param quantidade
     * @param id
     * @return
     */
    public boolean atualizarProduto(String nome, String descricao, double preco, String foto, int quantidade, int id) {
        boolean sucesso = false;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE produtos SET nome = ?, descricao = ?, preco = ?, foto = ?, quantidade = ? WHERE id = ?");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, descricao);
            preparedStatement.setDouble(3, preco);
            preparedStatement.setString(4, foto);
            preparedStatement.setInt(5, quantidade);
            preparedStatement.setInt(6, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();

        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    /**
     * Método utilizado para remover um produto existente pelo id
     *
     * @param id
     * @return
     */
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

}
