package kr.co.hellowu.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Component // Configuration으로 해도 된다. 근데 별개로 봐야
@Aspect // 메모리 생성하는 어노테이션이 아님
@Slf4j
public class LogAOP {

	@Around("execution( * kr.co.hellowu.controller..*Controller.*(..))") 
	// *Controller => 파일명이 Controller로 끝나는 모든 클래스의 *() => 모든 메소드의 매개변수는 상관없이 다
	// .. => controller 패키지 안의 어떤 패키지든 간에 상관없다.
	// 이 안에 들어가는 종류가 execution 외에도 되게 많다. 많이 쓰이는것 execution, within
	// 여기서 말하는 * 는 컨트롤러 안의 메소드들의 접근 제어자, 리턴타입이 상관 없다는 의미
	public Object aroundController(ProceedingJoinPoint pjp) throws Throwable { 
		String signatureInfo = getSignatureInfo(pjp);
		log.debug("start=>{}",signatureInfo);
		long start = System.nanoTime();
		// 여기에 before
		Object obj = pjp.proceed(); // 메소드의 실행결과가 여기에 대입되는것
		// 여기에 after
		long end = System.nanoTime();
		log.debug("end=>{}",signatureInfo);
		log.debug("걸린 시간=>{}나노초", end - start);
		return obj;
	}
	@Before("within(@org.springframework.web.bind.annotation.RestController *)") // 조인포인트 바로 전
	// 이 어노테이션이 있는 모든 애들 싹 다
	public void beforeController(JoinPoint joinPoint) {
		log.debug("@@before Controller@@");
	}
	
	@After("within(@org.springframework.web.bind.annotation.RestController *)") // 조인포인트 직후
	public void afterController(JoinPoint joinPoint) {
		log.debug("@@after Controller@@");
	}
	
	
	private String getSignatureInfo(JoinPoint joinPoint) {
		String signatureName = joinPoint.getSignature().getName();
		String className = joinPoint.getTarget().getClass().getSimpleName();
		StringBuilder sb = new StringBuilder();
		sb.append(className).append('.').append(signatureName).append('(');
		Object[] args = joinPoint.getArgs();
		if (args != null && args.length > 0) {
			for (int i = 0; i < args.length; i++) {
				if (args[i] instanceof String)
					sb.append('\"');
				sb.append(args[i]);
				if (args[i] instanceof String)
					sb.append('\"');
				if (i < args.length - 1) {
					sb.append(',');
				}
			}
		}
		sb.append(')');
		return sb.toString();
	}

}
