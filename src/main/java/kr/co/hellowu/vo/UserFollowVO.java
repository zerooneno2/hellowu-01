package kr.co.hellowu.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserFollowVO {
	private int ufNum;
	private int uiFollowerNum;
	private int uiFollowingNum;
	
	//UserInfoVO 필드
	private int uiNum;
	private String uiName;
	private String uiNickname;
	private String uiEmail;
	private String uiPwd;
	private String uiBirth;	
	private String uiCredat;
	private String uiAddr1;
	private String uiAddr2;
	private String uiProfileImgPath; // 컬럼명
	private MultipartFile uiProfileImgFile; // 변수명을 uiProfileImgFile 으로 했을때는 이미지파일 업로드 자체가 안됐을때 400에러가 난다. 이미지를 업로드해야만 회원가입이 된다
	// file로 변수명을 바꾸니 이미지 파일 업로드 자체를 안했을때 회원가입이 됨. => file이라고 하면 formData key값과 매핑이 안돼서 값이 안들어온걸로 간주하고 vo에 입력이 안돼서 회원가입은 되지만 getFile()하면 null이 나옴
	private String uiKakaoId;
	private String addr; // 게시판 글 작성시 주소 자동 입력값
	private String uiHobby; //취미
}
