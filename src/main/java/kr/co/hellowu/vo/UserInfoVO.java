package kr.co.hellowu.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class UserInfoVO {
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
	private String uiNaverId;
	private String uiGoogleId;
	private String addr; // 게시판 글 작성시 주소 자동 입력값
	private String uiHobby; //취미
	
	@Builder
	public UserInfoVO(int uiNum, String uiName, String uiNickname, String uiEmail, String uiPwd, String uiBirth,
			String uiCredat, String uiAddr1, String uiAddr2, String uiProfileImgPath, MultipartFile uiProfileImgFile,
			String uiKakaoId, String uiNaverId, String addr, String uiHobby,String uiGoogleId) {
		super();
		this.uiNum = uiNum;
		this.uiName = uiName;
		this.uiNickname = uiNickname;
		this.uiEmail = uiEmail;
		this.uiPwd = uiPwd;
		this.uiBirth = uiBirth;
		this.uiCredat = uiCredat;
		this.uiAddr1 = uiAddr1;
		this.uiAddr2 = uiAddr2;
		this.uiProfileImgPath = uiProfileImgPath;
		this.uiProfileImgFile = uiProfileImgFile;
		this.uiKakaoId = uiKakaoId;
		this.uiNaverId = uiNaverId;
		this.uiGoogleId = uiGoogleId;
		this.addr = addr;
		this.uiHobby = uiHobby;
	}
	
}
