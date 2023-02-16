package kr.co.hellowu.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Component
@Aspect
public class ControllerAOP {

	@Around("@annotation(kr.co.hellowu.anno.CheckAuth)")
	public Object aroundController(ProceedingJoinPoint pjp) throws Throwable {
		ServletRequestAttributes reqAttr =  (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
		HttpServletRequest req = reqAttr.getRequest();
		HttpSession session = req.getSession();
		if(session.getAttribute("userInfo") == null) {
			ResponseEntity.badRequest().body("로그인 안함");
			return new ResponseEntity<>("로그인 안했습니다.",HttpStatus.UNAUTHORIZED); // HttpStatus.UNAUTHORIZED => status 401
		}
		Object obj = pjp.proceed();
		 if(obj==null) { // "execution(public * kr.co.hellowu.controller..*Controller.*(..))" => void일경우 obj는 null
			
			return null;
		}
		
		return obj;
	}
	
	@Around("execution(* kr.co.hellowu.controller.ViewsController.goJsp(..))")
	public Object viewAuthChecker(ProceedingJoinPoint pjp) throws Throwable { // 얘는 ProceedingJoinPoint 말고는 파라미터 못받음
		ServletRequestAttributes reqAttr =  (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
		HttpServletRequest req = reqAttr.getRequest();
		HttpSession session = req.getSession();
		// 위 코드가 서블릿에서 session을 뽑아오는 과정=> 스프링이 다 해줌
		String uri = req.getRequestURI();
		if(uri.startsWith("/views/board/insert") && session.getAttribute("userInfo") == null) {
			req.setAttribute("msg", "로그인이 필요합니다.");
			req.setAttribute("url", "/");
			return "/views/common/alert";
		}
		return pjp.proceed();
	}
}
