package kr.co.hellowu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.hellowu.service.EmailCodeService;
import kr.co.hellowu.vo.EmailCodeVO;
import kr.co.hellowu.vo.UserInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class EmailCodeController {
	@Autowired
	private EmailCodeService mailService;
	
	@PostMapping("/mail/send-pwd-code")
	public boolean sendForgotPwdCode(@RequestBody UserInfoVO userInfoVO) {
		return mailService.codeSender(userInfoVO, "[Hello友]"+userInfoVO.getUiNickname()+"님의 비밀번호 분실 코드입니다.","1"); // UserInfoController에서 이메일, 닉네임 정보만 받게끔 했기 때문에 나머지 다 null 
	}
	
	@PostMapping("/mail/request-pwd-code")
	public boolean checkForgotPwdCode(@RequestBody EmailCodeVO emailCodeVO) {
		return mailService.codeChecker(emailCodeVO);
	}
	
	@PostMapping("/mail/send-verify-code")
	public boolean sendVerifyEmailCode(@RequestBody UserInfoVO userInfoVO) {
		return mailService.codeSender(userInfoVO, "[Hello友]이메일 인증 코드입니다", "0");
	}
	
	@PostMapping("/mail/request-verify-code")
	public boolean checkVerifyEmailCode(@RequestBody EmailCodeVO emailCodeVO) {
		return mailService.codeChecker(emailCodeVO);
	}
}
