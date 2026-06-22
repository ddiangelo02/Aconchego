package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;
import com.ddiangelo.aconchego.Utils;


public class UsuarioDAO {

    
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

    
    public boolean inserir(String nome, String endereco, String email, String login, String senha, boolean administrador) {
        boolean sucesso = false;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO usuarios (nome, endereco, email, login, senha, administrador) VALUES (?, ?, ?, ?, ?, ?)");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, endereco);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, login);
            preparedStatement.setString(5, Utils.gerarSHA256(senha));
            preparedStatement.setBoolean(6, administrador);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return false;
        }
        return sucesso;
    }

    
    public boolean atualizarComPerfil(String nome, String endereco, String email, String login, boolean administrador, int id) {
        boolean sucesso = false;
        try {

            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement("UPDATE usuarios SET nome = ?, endereco = ?, email = ?, login = ?, administrador = ? WHERE id = ?");
            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, endereco);
            preparedStatement.setString(3, email);
            preparedStatement.setString(4, login);
            preparedStatement.setBoolean(5, administrador);
            preparedStatement.setInt(6, id);
            sucesso = (preparedStatement.executeUpdate() == 1);
            preparedStatement.close();
            connection.close();

        } catch (SQLException ex) {
            return false;
        }
        return sucesso;
    }

    
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
