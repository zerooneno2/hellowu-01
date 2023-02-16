package kr.co.hellowu.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


public class SHA256 { 
	private static final String SALT = "v!k@d3l$x5l^d&";
	// 암호화 메소드
	public static String encode(String source) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA256");
			md.update((SALT+source).getBytes());
			byte[] bytes = md.digest();
			StringBuffer sb = new StringBuffer();
			for(byte b : bytes) {
				sb.append(String.format("%02X", b)); // 16진수 변환
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			return "";
	}
	
	
}
