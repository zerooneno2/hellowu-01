package kr.co.hellowu.service;

import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import kr.co.hellowu.mapper.EmailCodeMapper;
import kr.co.hellowu.vo.EmailCodeVO;
import kr.co.hellowu.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor // final붙은 모든 필드변수에 의존성 주입(생성자 주입)
@Service
@PropertySource("classpath:env.properties")
@Slf4j
public class EmailCodeService {
	private final JavaMailSender javaMailSender;
	private final EmailCodeMapper emailCodeMapper;
	

	@Value("${from.email}")
	private String fromEmail;

	public boolean codeSender(UserInfoVO userInfoVO, String subject,String issueCode) {
		char[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray(); // 36자
		// toCharArray() -> 문자열을 하나하나 쪼개서 char로 만들어서 char[] 에 담는 메소드
		Random rd = new Random();
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < 10; i++) {
			sb.append(chars[rd.nextInt(36)]);
		}
		// chars에 담긴 문자열을 랜덤으로 꺼내옵니다 rd.nextInt(36)-> 0부터 35까지의 랜덤한 수 생성 -> chars[0~35]
		// 그리고 sb에 담습니다(sb.append)

		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(userInfoVO.getUiEmail()); // 누구에게 보낼건지
		message.setFrom(fromEmail); // 누가 보낼건지(env.properties에 제 이메일로 설정해놨습니다)
		message.setSubject(subject); // 제목 뭘로 할건지
		message.setText(sb.toString()); // 내용은 뭘로 할건지
		javaMailSender.send(message); // 메일 보내는 메소드

		EmailCodeVO emailCodeVO = new EmailCodeVO();
		emailCodeVO.setEcEmail(userInfoVO.getUiEmail());
		emailCodeVO.setEcCode(sb.toString());
		emailCodeVO.setEcIssueCode(issueCode);
		
		Timer deleteCodeTimer = new Timer();
		deleteCodeTimer.schedule(new TimerTask() {
			
			@Override 
			public void run() {
				if(emailCodeMapper.deleteEmailCode(emailCodeVO)==1) {
					log.info("[System]{}로 전송한 코드 삭제 완료", userInfoVO.getUiEmail());
				}
			}
		},180000); 
		
		
		
		return 1 == emailCodeMapper.insertEmailCode(emailCodeVO);
	}
	
	public boolean codeChecker(EmailCodeVO emailCodeVO) {
		return emailCodeMapper.selectEmailCode(emailCodeVO)!=null;
	}
	
	

}
