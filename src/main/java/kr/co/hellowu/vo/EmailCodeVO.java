package kr.co.hellowu.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class EmailCodeVO {
	private String ecEmail;
	private String ecCode;
	private String ecIssueCode; // 0 회원가입 1 비밀번호 분실
	
}
