package kr.co.hellowu.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.hellowu.service.UserInfoService;
import kr.co.hellowu.vo.EmailCodeVO;
import kr.co.hellowu.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
@SessionAttributes({"userInfo"})
public class UserInfoController {
	private final UserInfoService userInfoService;
	
	@PostMapping("/user-info/sign-up/{ecCode}") // 회원가입
	@ResponseBody
	public boolean signUp(UserInfoVO userInfoVO,@PathVariable String ecCode) { // formData로 받기때문에 @RequestBody가 붙지 않습니다
		return userInfoService.sendForm(userInfoVO,ecCode);
	}
	
	@PostMapping("/user-info/sign-in") // 로그인, 리턴타입 
	@ResponseBody
	public UserInfoVO signIn(@RequestBody UserInfoVO userInfoVO,Model model) {		
		userInfoVO = userInfoService.getUserInfo(userInfoVO);
		if(userInfoVO != null) {
			model.addAttribute("userInfo",userInfoVO);
			return userInfoVO;
		}
		return null;
	}
	
	@GetMapping("/user-info/sign-out") // 로그아웃, 로직 추가 필요
	@ResponseBody
	public boolean signOut(@ModelAttribute("userInfo") UserInfoVO userInfoVO,SessionStatus sessionStatus) {
		if(userInfoVO.getUiEmail() != null) {
			sessionStatus.setComplete();
			return true;
		}
		return false;
	}
	
	@GetMapping("/user-info/check-email-exist") // 비밀번호 찾기 시 이메일이 존재하는지 검증하여 객체를 리턴하는 메소드
	@ResponseBody
	public UserInfoVO findPwdByEmail(@RequestParam String uiEmail) {
		UserInfoVO userInfoVO = new UserInfoVO();
		userInfoVO.setUiNickname(userInfoService.getUserInfoByEmail(uiEmail).getUiNickname());
		userInfoVO.setUiEmail(userInfoService.getUserInfoByEmail(uiEmail).getUiEmail());
		return userInfoVO;
	}
	
	@PatchMapping("/user-info/change-pwd/{uiPwd}") // 비밀번호 변경 요청을 받는 메소드
	@ResponseBody
	public boolean changePwdByCode(@RequestBody EmailCodeVO emailCodeVO,@PathVariable String uiPwd) {
		return userInfoService.updateUserPwdByEmail(emailCodeVO, uiPwd);
	}
	
	@GetMapping("/user-info/check-dupl") // 회원가입 폼 or 프로필 수정에서 중복여부를 검사하는 메소드
	@ResponseBody
	public boolean checkDuplication(@RequestParam Map<String,String> param) { // param값은 uiEmail 또는 uiNickname로 옵니다
		return userInfoService.duplicationChecker(param);
	}
	@GetMapping("/user-info/get-info") // 아이디,비밀번호 값(세션에서 받아오는 값)으로 유저정보를 리턴하는 메소드
	@ResponseBody
	public UserInfoVO getUserInfoByEmailAndPwd(UserInfoVO userInfoVO) {
		return userInfoService.getUserInfoWithoutSHA256(userInfoVO);
	}
	
	@PutMapping("/user-info/modify") // 프로필 수정 메소드
	@ResponseBody
	public boolean modifyUserInfo(UserInfoVO userInfoVO,Model model) { // 로그아웃되게 되어있어서 코드 model.addAttribute 제거
		log.info("유저인포=>{}",userInfoVO);
		return userInfoService.modifyUserInfo(userInfoVO);
	}
	
	@DeleteMapping("/user-info/delete") // 회원탈퇴 메소드
	@ResponseBody
	public boolean deleteUserInfo(@RequestBody UserInfoVO userInfoVO,SessionStatus sessionStatus) {
		if(userInfoService.deleteUserInfo(userInfoVO)) {
			sessionStatus.setComplete();
			return true;
		}
		return false;
	}
	
	
	

	/* 유저 리스트 */
	@GetMapping("/user-info/list")
	@ResponseBody
	public List<UserInfoVO> selectUserInfoList() {
		return userInfoService.selectUserInfoList();
	}

	
	@GetMapping("/user-info/profile/{nickname}")
	@ResponseBody
	public UserInfoVO getUserProfile(@PathVariable String nickname) {
		return userInfoService.getUserProfileInfo(nickname);
	}
	
	@GetMapping("/user-info/profile/check")
	public String checkPwdBeforeModifyProfile(UserInfoVO userInfoVO,RedirectAttributes redirectAttributes,HttpServletResponse res) throws IOException {
		UserInfoVO profileInfo;
		if((profileInfo = userInfoService.profileChecker(userInfoVO)) != null) {
			redirectAttributes.addFlashAttribute("profileInfo",profileInfo);
			return "redirect:/views/user/profile";
		} else { 
			redirectAttributes.addFlashAttribute("msg", "비밀번호가 틀렸습니다.");
			redirectAttributes.addFlashAttribute("url", "/views/user/profile-check");
			return "redirect:/views/common/alert"; // 생략시 기본 forward, model.addAttribute(')
		}
		
	}

}
