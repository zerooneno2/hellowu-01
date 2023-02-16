package kr.co.hellowu.controller;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.hellowu.service.SocialLoginService;
import kr.co.hellowu.service.UserInfoService;
import kr.co.hellowu.vo.GoogleLoginVO;
import kr.co.hellowu.vo.KakaoLoginVO;
import kr.co.hellowu.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@SessionAttributes({"userInfo"})
@Slf4j
public class SocialLoginController {
	private final SocialLoginService socialLoginService;
	private final UserInfoService userInfoService;
	
	@GetMapping("/kakao/oauth") // 카카오 로그인 메소드
	public String kakaoOauth(@RequestParam String code,RedirectAttributes redirectAttributes,Model model) {	
		KakaoLoginVO kakaoLoginVO = socialLoginService.kakaoSignInRequester(code);
		final String socialLoginEmail = (String) kakaoLoginVO.getKakao_account().get("email");
		UserInfoVO tmpUserInfo = userInfoService.getUserInfoByEmail(socialLoginEmail);
		if(tmpUserInfo != null && (tmpUserInfo.getUiKakaoId().equals("(NULL)") || tmpUserInfo.getUiKakaoId().length() == 0)) {
			redirectAttributes.addFlashAttribute("msg", "해당 소셜 로그인 이메일로 가입한 아이디가 존재합니다.");
			redirectAttributes.addFlashAttribute("url", "/");
			return "redirect:/views/common/alert"; 
		}
		UserInfoVO userInfoVO = socialLoginService.kakaoSignIn(kakaoLoginVO.getId()); 
		if(userInfoVO.getUiEmail() != null) {
			model.addAttribute("userInfo", userInfoVO);
			return "redirect:/views/index";
		}
		redirectAttributes.addFlashAttribute("socialLoginValue","uiKakaoId");
		redirectAttributes.addFlashAttribute("socialLoginId",userInfoVO.getUiKakaoId());
		redirectAttributes.addFlashAttribute("socialLoginEmail",socialLoginEmail);
		return "redirect:/views/user/sign-up";
	}
	
	
	@GetMapping("/naver/oauth") // 네이버 로그인 메소드
	public String naverOAuth() {
		return "/views/common/auth/naver";
	}
	@GetMapping("/naver/oauth/callback") // 네이버 로그인 메소드
	public String naverOAuthCallback(@RequestParam Map<String,String> param,RedirectAttributes redirectAttributes,Model model) {
		final String socialLoginEmail = param.get("email");
		UserInfoVO tmpUserInfo = userInfoService.getUserInfoByEmail(socialLoginEmail);
		if(tmpUserInfo != null && (tmpUserInfo.getUiNaverId().equals("(NULL)") || tmpUserInfo.getUiNaverId().length() == 0)) {
			redirectAttributes.addFlashAttribute("msg", "해당 소셜 로그인 이메일로 가입한 아이디가 존재합니다.");
			redirectAttributes.addFlashAttribute("url", "/");
			return "redirect:/views/common/alert"; 
		}
		UserInfoVO userInfoVO = socialLoginService.naverSignIn(param.get("id"));
		if(userInfoVO.getUiEmail() != null) {
			model.addAttribute("userInfo", userInfoVO);
			return "redirect:/views/index";
		}
		redirectAttributes.addFlashAttribute("socialLoginValue","uiNaverId");
		redirectAttributes.addFlashAttribute("socialLoginId",userInfoVO.getUiNaverId());
		redirectAttributes.addFlashAttribute("socialLoginEmail",socialLoginEmail);
		return "redirect:/views/user/sign-up";
	}
	
	@GetMapping("/google")
    public ResponseEntity<Object> moveGoogleInitUrl() {
        String authUrl = socialLoginService.googleInitUrl();
        URI redirectUri = null;
        try {
            redirectUri = new URI(authUrl);
            HttpHeaders httpHeaders = new HttpHeaders();
            httpHeaders.setLocation(redirectUri);
            return new ResponseEntity<>(httpHeaders, HttpStatus.SEE_OTHER);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        return ResponseEntity.badRequest().build();
    }

    @GetMapping("/google/oauth") 
    public String redirectGoogleLogin(@RequestParam String code,RedirectAttributes redirectAttributes,Model model) {
        GoogleLoginVO googleLoginVO = socialLoginService.googleSignInRequester(code);
        final String socialLoginEmail = googleLoginVO.getEmail();
		UserInfoVO tmpUserInfo = userInfoService.getUserInfoByEmail(socialLoginEmail);
		if(tmpUserInfo != null && (tmpUserInfo.getUiGoogleId().equals("(NULL)") || tmpUserInfo.getUiGoogleId().length() == 0)) {
			redirectAttributes.addFlashAttribute("msg", "해당 소셜 로그인 이메일로 가입한 아이디가 존재합니다.");
			redirectAttributes.addFlashAttribute("url", "/");
			return "redirect:/views/common/alert"; 
		}
		UserInfoVO userInfoVO = socialLoginService.googleSignIn(googleLoginVO.getSub());
		if(userInfoVO.getUiEmail() != null) {
			model.addAttribute("userInfo", userInfoVO);
			return "redirect:/views/index";
		}
		redirectAttributes.addFlashAttribute("socialLoginValue","uiGoogleId");
		redirectAttributes.addFlashAttribute("socialLoginId",userInfoVO.getUiGoogleId());
		redirectAttributes.addFlashAttribute("socialLoginEmail",socialLoginEmail);
		return "redirect:/views/user/sign-up";
    }
}
