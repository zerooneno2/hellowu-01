package kr.co.hellowu.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CommentAlertVO {
	private String senderNickname;
	private int targetUiNum;
	private String targetTableName;
	private int targetPostNum;
}
