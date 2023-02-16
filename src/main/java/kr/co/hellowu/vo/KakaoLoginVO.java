package kr.co.hellowu.vo;

import java.util.Map;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class KakaoLoginVO {
	private String access_token;
	private String token_type;
	private String refresh_token;
	private String id_token;
	private String expires_in;
	private String scope;
	private String refresh_token_expires_in;
	private String id;
	private String connected_at;
	private Map<String,Object> kakao_account;
}