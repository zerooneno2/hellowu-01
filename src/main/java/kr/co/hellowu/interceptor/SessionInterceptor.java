package kr.co.hellowu.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import kr.co.hellowu.vo.UserInfoVO;


public class SessionInterceptor implements HandshakeInterceptor{
	

	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Map<String, Object> attributes) throws Exception { // 세션 정보를 끄집어내서
		ServletServerHttpRequest ssreq = (ServletServerHttpRequest) request; 
		HttpServletRequest req = ssreq.getServletRequest();
		UserInfoVO userInfo = (UserInfoVO) req.getSession().getAttribute("userInfo"); // 방법 1
//		ServletRequestAttributes reqAttr =  (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
//		HttpServletRequest req = reqAttr.getRequest();
//		UserInfoVO userInfo = (UserInfoVO) req.getSession().getAttribute("userInfo"); // 방법 2
		if(userInfo != null) {
			attributes.put("userNickname", userInfo.getUiNickname()); // attributes에 담아 저장
		} else {
			String ip = req.getHeader("X-FORWARD-FOR");
			if(ip == null) { // 접속자 목록 구현할 경우를 대비해서 
				ip = req.getRemoteAddr();
			}
			attributes.put("userNickname", ip.split("\\.")[0]+"."+ip.split("\\.")[1]+".***.***");
		}
		return true;
	}
	
	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Exception exception) {
		
	}

}
