package kr.co.hellowu.handler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class WebSocketHandler extends TextWebSocketHandler {

	private Map<String, WebSocketSession> users = new ConcurrentHashMap<>();

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		users.put((String) session.getAttributes().get("userNickname"), session);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

		String[] msgValues = message.getPayload().split("&");
		switch (msgValues[0]) {
		case "COUNT": {
			StringBuffer sb = new StringBuffer();
			for(String userNickname : users.keySet()) {
				sb.append(userNickname+"&");
			}
			for (WebSocketSession user : users.values()) {	
				user.sendMessage(new TextMessage("현재 " + users.size() + "명 접속중입니다.&" + sb.toString()));
			}
		}
			break;
		case "COMMENT": {
			WebSocketSession senderSession = users.get(msgValues[1]); // 댓글 남긴 사람
			WebSocketSession receiverSession = users.get(msgValues[2]); // 게시물을 쓴 사람
			// [2] 테이블명 [3] 게시물 번호

			if (!senderSession.equals(receiverSession)) {
				TextMessage tmpMsg = new TextMessage(
						msgValues[1] + "님이 댓글을 남겼습니다." + "<b style=\"cursor:pointer;\" onclick=\"goToPost('"
								+ msgValues[3] + "'," + msgValues[4] + ")\"> 보러가기</b>");
				receiverSession.sendMessage(tmpMsg);
			}
		}
			break;
		case "FOLLOW": {
			TextMessage tmpMsg = new TextMessage(msgValues[1] + "님이 " + msgValues[2] + "님을 팔로우하셨습니다.");
			users.get(msgValues[2]).sendMessage(tmpMsg); // 팔로우 당하는 사람에게 메세지 전송
		}
			break;
		}

	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		users.remove(session.getAttributes().get("userNickname"));
	}
}
