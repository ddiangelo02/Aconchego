package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;

public class CategoriaDAO {

    public List<Categoria> obterTodos() {
        List<Categoria> resultado = new ArrayList<Categoria>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT id, nome FROM categorias ORDER BY nome");
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

    public Categoria obterPeloId(int id) {
        Categoria categoria = null;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("SELECT id, nome FROM categorias WHERE id = ?");
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                categoria = montar(resultSet);
            }
            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return categoria;
    }

    public boolean inserir(String nome) {
        boolean sucesso = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO categorias (nome) VALUES (?)");
            preparedStatement.setString(1, nome);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return false;
        }
        return sucesso;
    }

    public boolean atualizar(String nome, int id) {
        boolean sucesso = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE categorias SET nome = ? WHERE id = ?");
            preparedStatement.setString(1, nome);
            preparedStatement.setInt(2, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    public boolean remover(int id) {
        boolean sucesso = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement desvincula = connection.prepareStatement("UPDATE produtos SET categoria_id = NULL WHERE categoria_id = ?");
            desvincula.setInt(1, id);
            desvincula.executeUpdate();
            desvincula.close();

            PreparedStatement preparedStatement = connection.prepareStatement("DELETE FROM categorias WHERE id = ?");
            preparedStatement.setInt(1, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    private Categoria montar(ResultSet resultSet) throws SQLException {
        Categoria categoria = new Categoria();
        categoria.setId(resultSet.getInt("id"));
        categoria.setNome(resultSet.getString("nome"));
        return categoria;
    }

}
