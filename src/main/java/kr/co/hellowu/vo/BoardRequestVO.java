package kr.co.hellowu.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardRequestVO {
	private int brNum;
	private String uiNickname;
	private String brBoardKorName;
	private String brBoardEngName;
	private String brWhatFor;
	private String brCategory;
	private String brComment;
	private String brCredat;
}
