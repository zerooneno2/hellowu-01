package kr.co.hellowu.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import kr.co.hellowu.mapper.UserInfoMapper;
import kr.co.hellowu.util.ConfigUtils;
import kr.co.hellowu.vo.GoogleLoginRequestVO;
import kr.co.hellowu.vo.GoogleLoginResponseVO;
import kr.co.hellowu.vo.GoogleLoginVO;
import kr.co.hellowu.vo.KakaoLoginVO;
import kr.co.hellowu.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class SocialLoginService {
	private final RestTemplate restTemplate;
	private final ConfigUtils configUtils;
	private final UserInfoMapper userInfoMapper;
	@Value("${kakao.client.id}")
	private String kakaoClientId;
	
	public KakaoLoginVO kakaoSignInRequester(String code) {
		String uri = "https://kauth.kakao.com/oauth/token";
		// 헤더 만들기
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		// 바디 만들기

		MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
		body.add("grant_type", "authorization_code");
		body.add("client_id", kakaoClientId);
		body.add("redirect_uri", "https://hellowu.co.kr/kakao/oauth");
		body.add("code", code);
		// MultiValueMap은 key의 중복 저장이 가능 -> Value를 리스트로 받아옴
		// 헤더와 바디를 하나의 오브젝트로 만들기
		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body,
				headers);

		ResponseEntity<KakaoLoginVO> response = restTemplate.postForEntity(uri, request, KakaoLoginVO.class);
		KakaoLoginVO kakaoLoginVO = response.getBody();
		// response 토큰 받아서 vo로 만들고 그 값으로 아이디 코드를 받아옴
		uri = "https://kapi.kakao.com/v2/user/me";
		headers.set("Authorization", "Bearer " + kakaoLoginVO.getAccess_token()); // request에 헤더 추가
		response = restTemplate.postForEntity(uri, request, KakaoLoginVO.class);
		return response.getBody();
		
	}
	public UserInfoVO naverSignIn(String idCode) {
		UserInfoVO userInfoVO = userInfoMapper.selectUserInfoByNaverId(idCode);
		return userInfoVO != null? userInfoVO : new UserInfoVO().builder().uiNaverId(idCode).build();
	}
	public UserInfoVO kakaoSignIn(String idCode) {
		UserInfoVO userInfoVO = userInfoMapper.selectUserInfoByKakaoId(idCode);
		return userInfoVO != null? userInfoVO : new UserInfoVO().builder().uiKakaoId(idCode).build();
	}
	public UserInfoVO googleSignIn(String idCode) {
		UserInfoVO userInfoVO = userInfoMapper.selectUserInfoByGoogleId(idCode);
		return userInfoVO != null? userInfoVO : new UserInfoVO().builder().uiGoogleId(idCode).build();
	}
	
	public String googleInitUrl() {
		return configUtils.googleInitUrl();
	}
	
	public GoogleLoginVO googleSignInRequester(String code) {
		// HTTP 통신을 위해 RestTemplate 활용
        GoogleLoginRequestVO requestParams = GoogleLoginRequestVO.builder()
                .clientId(configUtils.getGoogleClientId())
                .clientSecret(configUtils.getGoogleSecret())
                .code(code)
                .redirectUri(configUtils.getGoogleRedirectUri())
                .grantType("authorization_code")
                .build();

        
        try {
        	// Http Header 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<GoogleLoginRequestVO> httpRequestEntity = new HttpEntity<>(requestParams, headers);
            ResponseEntity<String> apiResponseJson = restTemplate.postForEntity(configUtils.getGoogleAuthUrl() + "/token", httpRequestEntity, String.class);

            // ObjectMapper를 통해 String to Object로 변환
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL); // NULL이 아닌 값만 응답받기(NULL인 경우는 생략)
            GoogleLoginResponseVO googleLoginResponse = objectMapper.readValue(apiResponseJson.getBody(), new TypeReference<GoogleLoginResponseVO>() {});
            log.info("googleLoginResponse=>{}",googleLoginResponse);
            // 사용자의 정보는 JWT Token으로 저장되어 있고, Id_Token에 값을 저장한다.
            String jwtToken = googleLoginResponse.getIdToken();

            // JWT Token을 전달해 JWT 저장된 사용자 정보 확인
            String requestUrl = UriComponentsBuilder.fromHttpUrl(configUtils.getGoogleAuthUrl() + "/tokeninfo").queryParam("id_token", jwtToken).toUriString();

            String resultJson = restTemplate.getForObject(requestUrl, String.class);
            log.info("결과=>{}",resultJson);
            if(resultJson != null) {
                return objectMapper.readValue(resultJson, new TypeReference<GoogleLoginVO>() {});
            }
        } catch (Exception e) {
        	e.printStackTrace();
        }
        return null;
	}
}
