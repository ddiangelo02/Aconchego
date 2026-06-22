package com.ddiangelo.aconchego.modelo;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.sql.*;
import com.ddiangelo.aconchego.ConnectionFactory;

public class FavoritoDAO {

    public boolean adicionar(int usuarioId, int produtoId) {
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement ps = connection.prepareStatement(
                    "INSERT INTO favoritos (usuario_id, produto_id) VALUES (?, ?) ON CONFLICT DO NOTHING");
            ps.setInt(1, usuarioId);
            ps.setInt(2, produtoId);
            ps.executeUpdate();
            ps.close();
            connection.close();
            return true;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            return false;
        }
    }

    public boolean remover(int usuarioId, int produtoId) {
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement ps = connection.prepareStatement("DELETE FROM favoritos WHERE usuario_id = ? AND produto_id = ?");
            ps.setInt(1, usuarioId);
            ps.setInt(2, produtoId);
            ps.executeUpdate();
            ps.close();
            connection.close();
            return true;
        } catch (SQLException ex) {
            return false;
        }
    }

    public boolean existe(int usuarioId, int produtoId) {
        boolean existe = false;
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement ps = connection.prepareStatement("SELECT 1 FROM favoritos WHERE usuario_id = ? AND produto_id = ?");
            ps.setInt(1, usuarioId);
            ps.setInt(2, produtoId);
            ResultSet rs = ps.executeQuery();
            existe = rs.next();
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException ex) {
            return false;
        }
        return existe;
    }

    public List<Produto> listarProdutos(int usuarioId) {
        List<Produto> resultado = new ArrayList<Produto>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement ps = connection.prepareStatement(
                    "SELECT p.id, p.nome, p.descricao, p.preco, p.foto, p.quantidade, p.categoria_id, c.nome AS categoria_nome "
                    + "FROM favoritos f JOIN produtos p ON p.id = f.produto_id "
                    + "LEFT JOIN categorias c ON c.id = p.categoria_id "
                    + "WHERE f.usuario_id = ? ORDER BY p.nome");
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Produto p = new Produto();
                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setDescricao(rs.getString("descricao"));
                p.setPreco(rs.getDouble("preco"));
                p.setFoto(rs.getString("foto"));
                p.setQuantidade(rs.getInt("quantidade"));
                p.setCategoriaId(rs.getInt("categoria_id"));
                p.setCategoriaNome(rs.getString("categoria_nome"));
                resultado.add(p);
            }
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException ex) {
            return resultado;
        }
        return resultado;
    }

    public Set<Integer> idsFavoritos(int usuarioId) {
        Set<Integer> ids = new HashSet<Integer>();
        try {
            Connection connection = ConnectionFactory.getConnection();
            PreparedStatement ps = connection.prepareStatement("SELECT produto_id FROM favoritos WHERE usuario_id = ?");
            ps.setInt(1, usuarioId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt(1));
            }
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException ex) {
            return ids;
        }
        return ids;
    }

}
