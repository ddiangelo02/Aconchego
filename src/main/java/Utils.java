/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.ddiangelo.aconchego;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *
 * @author thimo
 */
public class Utils {
    
    public static String gerarSHA256(String senha) {
        try {
            byte[] hash = MessageDigest.getInstance("SHA-256").digest(senha.getBytes("UTF-8"));
            return new BigInteger(1, hash).toString(16);
        } catch (NoSuchAlgorithmException ex) {
            return null;
        } catch (UnsupportedEncodingException ex) {
            return null;
        }
    }
    
}
