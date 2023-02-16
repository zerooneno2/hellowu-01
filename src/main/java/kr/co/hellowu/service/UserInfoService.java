package kr.co.hellowu.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.hellowu.mapper.UserInfoMapper;
import kr.co.hellowu.util.SHA256;
import kr.co.hellowu.vo.EmailCodeVO;
import kr.co.hellowu.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@PropertySource("classpath:env.properties")
@Service
@Slf4j
public class UserInfoService {
	private final UserInfoMapper userInfoMapper;
	private final EmailCodeService emailCodeService;
	@Value("${upload.user.image.path}")
	private String uploadUserImagePath;
	

	
	private static final String BASE_PATH = System.getProperty("os.name").toUpperCase().contains("WINDOW") ? "C:" : "";
	
	public UserInfoVO getUserInfo(UserInfoVO userInfoVO) {
		UserInfoVO userInfo = addrCutter(userInfoMapper.selectUserInfoByEmail(userInfoVO.getUiEmail()));
		return userInfo.getUiPwd().equals(SHA256.encode(userInfoVO.getUiPwd())) ? userInfo : null;
	}

	public UserInfoVO getUserInfoWithoutSHA256(UserInfoVO userInfoVO) {

		return userInfoMapper.selectUserInfoByEmail(userInfoVO.getUiEmail()).getUiPwd().equals(userInfoVO.getUiPwd())
				? userInfoMapper.selectUserInfoByEmail(userInfoVO.getUiEmail())
				: null;
	}

	
	public boolean userInfoFormChecker(UserInfoVO userInfoVO) {
		return Pattern.matches("^[가-힣]{2,4}$", userInfoVO.getUiName())
				&& Pattern.matches("^[가-힣a-zA-Z]{2,16}$", userInfoVO.getUiNickname())
				&& Pattern.matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$",
						userInfoVO.getUiPwd())
				&& Pattern.matches("^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$",
						userInfoVO.getUiEmail())
				&& Pattern.matches("^[1-2][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$",
						userInfoVO.getUiBirth())
				&& Pattern.matches("^[가-힣]{1,30}$", userInfoVO.getUiHobby());
	}
	public void userProfileImgSaver(UserInfoVO userInfoVO) {
		
		// 이미지 파일이 있다면 처리하는 로직
		MultipartFile imgFile = userInfoVO.getUiProfileImgFile();
		final String extension = imgFile.getOriginalFilename()
				.substring(imgFile.getOriginalFilename().lastIndexOf("."));
		// 파일 확장자를 구해 변수에 담는 코드 ex) .jpg .png .gif 등
		final String uniqueName = UUID.randomUUID().toString(); // 나중에 substring으로 수정
		final String fullPath = BASE_PATH + uploadUserImagePath + uniqueName + extension;
		
		userInfoVO.setUiProfileImgPath(uploadUserImagePath + uniqueName + extension); // UI_PROFILE_IMG_PATH에 fullPath 경로를 넣기위함
		File file = new File(fullPath);
		try {
			FileUtils.copyInputStreamToFile(userInfoVO.getUiProfileImgFile().getInputStream(), file);
			//imgFile.transferTo(file); // fullPath에 이미지 파일 저장
		} catch (IllegalStateException | IOException e) {
			FileUtils.deleteQuietly(file);
		}
	}

	
	public boolean sendForm(UserInfoVO userInfoVO, String ecCode) {
		if(!userInfoFormChecker(userInfoVO)) return false; // 정규식으로 검사해서 1차적으로 거름
		
		if(!ecCode.equals("DONE")) { // 일반 회원가입
			EmailCodeVO emailCodeVO = new EmailCodeVO();
			emailCodeVO.setEcCode(ecCode);
			emailCodeVO.setEcEmail(userInfoVO.getUiEmail());
			emailCodeVO.setEcIssueCode("0");
			if (!emailCodeService.codeChecker(emailCodeVO)) return false; // 일반 회원가입일 경우 => 2차적으로 해당 코드가 DB에 있는지 검증하는 로직
		} 
		// 소셜 로그인 회원가입의 경우 2차 검사를 하지 않음
		userInfoVO.setUiPwd(SHA256.encode(userInfoVO.getUiPwd())); // 검사 통과했다면 비밀번호 암호화
		if (userInfoVO.getUiProfileImgFile() == null) { // 프사를 등록 안했다면 디폴트 프사로 변경,
			userInfoVO.setUiProfileImgPath(uploadUserImagePath + "default.png");
		} else { // 아니라면 서버에 저장
			userProfileImgSaver(userInfoVO);
		}

		return 1 == userInfoMapper.insertUserInfo(userInfoVO);
	}
	
	

	public boolean modifyUserInfo(UserInfoVO userInfoVO) {
		UserInfoVO beforeUserInfo = userInfoMapper.selectUserInfoByEmail(userInfoVO.getUiEmail());
		String previousImgPath = beforeUserInfo.getUiProfileImgPath();
		if (previousImgPath != null && !previousImgPath.contains("default.png")) { // 기존 프사가 null 이거나 기본 프사가 아니라면
			File file = new File(BASE_PATH + previousImgPath); 
		  	FileUtils.deleteQuietly(file); // 서버에서 파일 삭제
		}
		
		if (userInfoFormChecker(userInfoVO)){ // 정규식 검사를 하고
			  userInfoVO.setUiPwd(SHA256.encode(userInfoVO.getUiPwd())); // 비밀번호 암호화
			  if (userInfoVO.getUiProfileImgFile() == null) {  // 이미지 파일이 없다면 디폴트 파일로 유저 이미지 패스 변경, 아니라면 서버에 이미지 저장
			    userInfoVO.setUiProfileImgPath(uploadUserImagePath + "default.png");
			  } else userProfileImgSaver(userInfoVO);
			  
			  return 1 == userInfoMapper.updateUserInfo(userInfoVO);
			}
		return false;
		
	}
	
	
	public UserInfoVO getUserInfoByEmail(String uiEmail) {

		return userInfoMapper.selectUserInfoByEmail(uiEmail);
	}
	
	public UserInfoVO profileChecker(UserInfoVO userInfoVO) {
		UserInfoVO foundUserInfo = userInfoMapper.selectUserInfoByEmail(userInfoVO.getUiEmail()); 
		if(foundUserInfo != null && foundUserInfo.getUiPwd().equals(SHA256.encode(userInfoVO.getUiPwd()))) {
			return foundUserInfo;
		}
		return null; 
	}

	public boolean updateUserPwdByEmail(EmailCodeVO emailCodeVO, String uiPwd) {
		// 정규식 검증하고 검증이 성공됐다면 update, 아니라면 false 리턴
		return Pattern.matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$", uiPwd)
				? 1 == userInfoMapper.updateUserPwdByEmailAndCode(emailCodeVO, SHA256.encode(uiPwd))
				: false;
	}

	public boolean duplicationChecker(Map<String, String> param) {
		final String key = param.keySet().iterator().next();
		return key.equals("uiNickname") ? userInfoMapper.selectUserInfoByNickname(param.get(key)) == null
				: userInfoMapper.selectUserInfoByEmail(param.get(key)) == null;
		// param의 키값이 uiNickname이라면 닉네임으로 db검색, 객체가 없다면(==null, 즉 중복되지 않는다면) true 반환,
		// 중복된다면 false
		// param의 키값이 uiNickname이 아니라면(uiEmail) 이메일로 db검색, 객체가 없다면(==null, 즉 중복되지 않는다면)
		// true반환, 중복된다면 false
	}

	public boolean deleteUserInfo(UserInfoVO userInfoVO) {
		String previousImgPath = userInfoMapper.selectUserInfoByEmail(userInfoVO.getUiEmail()).getUiProfileImgPath();
		if(previousImgPath != null && !previousImgPath.contains("default.png")) {
			File file = new File(BASE_PATH + previousImgPath); 
		  	FileUtils.deleteQuietly(file); // 서버에서 파일 삭제
		}
		
		return 1 == userInfoMapper.deleteUserInfo(userInfoVO);
	}

	
	

	/* 유저 리스트 */
	public List<UserInfoVO> selectUserInfoList() {
		List<UserInfoVO> userInfoList = userInfoMapper.selectUserInfoList();
		for (UserInfoVO userInfo : userInfoList) {
			userInfo = addrCutter(userInfo);
		}
		return userInfoList;
	}
	
	public UserInfoVO addrCutter(UserInfoVO userInfo) {
		if (userInfo.getUiAddr1().length() > 0) {
			String addr = "";
			String[] splitAddr = userInfo.getUiAddr1().split(" ");
			for (int i = 0; i < 2; i++) {
				if (i == 1)
					addr += " ";
				addr += splitAddr[i];
			}
			userInfo.setAddr(addr);
		}
		return userInfo;
	}
	
	/* 타 유저 정보 보기 */
	public UserInfoVO getUserProfileInfo(String nickname) {
		return addrCutter(userInfoMapper.selectSomeInfoByNickname(nickname));
	}
	
	
}
