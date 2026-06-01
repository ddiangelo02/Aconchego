package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;
import com.ddiangelo.aconchego.Utils;

/**
 *
 * @author Thiago Moreira
 *
 * Classe que implementa o padrão DAO para a entidade Usuário
 */
public class UsuarioDAO {

    /**
     * Método utilizado para obter todos os usuários existentes
     *
     * @return
     */
    public List<Usuario> obterTodos() {
        List<Usuario> resultado = new ArrayList<Usuario>();
        try {
            
            Connection connection = ConnectionFactory.getConnection();
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT id, nome, endereco, email, login, senha, administrador FROM usuarios");
            
            while (resultSet.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(resultSet.getInt("id"));
                usuario.setNome(resultSet.getString("nome"));
                usuario.setEndereco(resultSet.getString("endereco"));
                usuario.setEmail(resultSet.getString("email"));
                usuario.setLogin(resultSet.getString("login"));
                usuario.setSenha(resultSet.getString("senha"));
                usuario.setAdministrador(resultSet.getBoolean("administrador"));
                resultado.add(usuario);
            }
            
            resultSet.close();
            statement.close();
            connection.close();
            
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
        return resultado;
    }

    /**
     * Método utilizado para obter um usuário existente pelo id
     *
     * @param id
     * @return
     */
    public Usuario obterPeloId(int id) {
        Usuario usuario = null;
        try {
            
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("SELECT id, nome, endereco, login, senha, administrador, email FROM usuarios WHERE id = ?");
            preparedStatement.setInt(1, id);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            while (resultSet.next()) {
                usuario = new Usuario();
                usuario.setId(resultSet.getInt("id"));
                usuario.setNome(resultSet.getString("nome"));
                usuario.setEndereco(resultSet.getString("endereco"));
                usuario.setEmail(resultSet.getString("email"));
                usuario.setLogin(resultSet.getString("login"));
                usuario.setSenha(resultSet.getString("senha"));
                usuario.setAdministrador(resultSet.getBoolean("administrador"));
            }
            
            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return usuario;
    }

    /**
     * Método utilizado para obter um usuário existente pelo login
     *
     * @param login
     * @return
     */
    public Usuario obterPeloLogin(String login) {
        Usuario usuario = null;
        try {
            Connection connection = ConnectionFactory.getConnection();
            System.out.println(connection);
            PreparedStatement preparedStatement = connection.prepareStatement("SELECT id, nome, endereco, login, senha, administrador, email FROM usuarios WHERE login = ?");
            preparedStatement.setString(1, login);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            while (resultSet.next()) {
                usuario = new Usuario();
                usuario.setId(resultSet.getInt("id"));
                usuario.setNome(resultSet.getString("nome"));
                usuario.setEndereco(resultSet.getString("endereco"));
                usuario.setEmail(resultSet.getString("email"));
                usuario.setLogin(resultSet.getString("login"));
                usuario.setSenha(resultSet.getString("senha"));
                usuario.setAdministrador(resultSet.getBoolean("administrador"));
            }
            
            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException ex) {
            return null;
        }
        return usuario;
    }

    /**
     * Método utilizado para inserir um usuário do tipo cliente
     *
     * @param nome
     * @param endereco
     * @param email
     * @param login
     * @param senha
     * @return
     */
    public boolean inserirCliente(String nome, String endereco, String email, String login, String senha) {
        boolean sucesso = false;
        try {
            
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO usuarios (nome, endereco, email, login, senha, administrador) VALUES (?, ?, ?, ?, ?, FALSE)");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, endereco);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, login);
            preparedStatement.setString(5, Utils.gerarSHA256(senha));
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
     * Método utilizado para atualizar os dados de um usuário existente exceto a
     * senha
     *
     * @param nome
     * @param endereco
     * @param email
     * @param login
     * @param id
     * @return
     */
    public boolean atualizar(String nome, String endereco, String email, String login, int id) {
        boolean sucesso = false;
        try {
            
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE usuarios SET nome = ?, endereco = ?, email = ?, login = ? WHERE id = ?");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, endereco);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, login);
            preparedStatement.setInt(5, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
            
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    /**
     * Método utilizado para atualizar um usuário existente
     * 
     * @param nome
     * @param endereco
     * @param email
     * @param login
     * @param senha
     * @param id
     * @return 
     */
    public boolean atualizar(String nome, String endereco, String email, String login, String senha, int id) {
        boolean sucesso = false;
        try {
            
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE usuarios SET nome = ?, endereco = ?, email = ?, login = ?, senha = ? WHERE id = ?");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, endereco);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, login);
            preparedStatement.setString(5, Utils.gerarSHA256(senha));
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
     * Método utilizado para remover um usuário existente pelo id
     * @param id
     * @return 
     */
    public boolean remover(int id) {
        boolean sucesso = false;
        try {
            
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("DELETE FROM usuarios WHERE id = ?");
            preparedStatement.setInt(1, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
            
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    /**
     * Método utilizado para remover um usuário existente pelo login
     * 
     * @param login
     * @return 
     */
    public boolean remover(String login) {
        boolean sucesso = false;
        try {
            
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("DELETE FROM usuarios WHERE login = ?");
            preparedStatement.setString(1, login);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();
            
        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

}
