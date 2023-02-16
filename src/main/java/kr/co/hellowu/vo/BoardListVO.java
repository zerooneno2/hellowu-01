package kr.co.hellowu.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardListVO {
	private int blNum;
	private String blRequesterNickname;
	private String blBoardKorName;
	private String blBoardEngName;
	private String blCategory;
	private String blComment;
	private String blSuffix;
	private String blApprovalDate;
}
