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
public class CategoriaDAO {

    /**
     * Método utilizado para obter todos os produtos existentes
     *
     * @return
     */
    public List<Assinatura> obterTodos() {
        List<Assinatura> resultado = new ArrayList<Assinatura>();
        try {

            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT id, nome, descricao, preco FROM assinatura");

            while (resultSet.next()) {
                Assinatura assinatura = new Assinatura();
                assinatura.setId(resultSet.getInt("id"));
                assinatura.setNome(resultSet.getString("nome"));
                assinatura.setDescricao(resultSet.getString("descricao"));
                assinatura.setPreco(resultSet.getDouble("preco"));
                resultado.add(assinatura);
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
     * Método utilizado para obter um assinatura existente pelo id
     *
     * @param id
     * @return
     */
    public Assinatura obterPeloId(int id) {
        Assinatura assinatura = null;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("SELECT id, nome, descricao, preco FROM assinatura WHERE id = ?");
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                assinatura = new Assinatura();
                assinatura.setId(resultSet.getInt("id"));
                assinatura.setNome(resultSet.getString("nome"));
                assinatura.setDescricao(resultSet.getString("descricao"));
                assinatura.setPreco(resultSet.getDouble("preco"));

            }

            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return assinatura;
    }

    /**
     * Método utilizado para inserir um assinatura
     *
     * @param nome
     * @param descricao
     * @param preco
     * @param foto
     * @param quantidade
     * @return
     */
    public boolean inserirAssinatura(String nome, String descricao, double preco) {
        boolean sucesso = false;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO assinatura (nome, descricao, preco) VALUES (?, ?, ?)");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, descricao);
            preparedStatement.setDouble(3, preco);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return false;
        }
        return sucesso;
    }

    /**
     * Método utilizado para atualizar os dados de um assinatura existente
     *
     * @param nome
     * @param descricao
     * @param preco
     * @param foto
     * @param quantidade
     * @param id
     * @return
     */
    public boolean atualizarAssinatura(String nome, String descricao, double preco, int id) {
        boolean sucesso = false;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE assinatura SET nome = ?, descricao = ?, preco = ? WHERE id = ?");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, descricao);
            preparedStatement.setDouble(3, preco);
            preparedStatement.setInt(4, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();

        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    /**
     * Método utilizado para remover um assinatura existente pelo id
     *
     * @param id
     * @return
     */
    public boolean removerAssinatura(int id) {
        boolean sucesso = false;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("DELETE FROM assinatura WHERE id = ?");
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
