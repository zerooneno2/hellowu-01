package kr.co.hellowu.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.hellowu.vo.EmailCodeVO;
import kr.co.hellowu.vo.UserInfoVO;

public interface UserInfoMapper {
	UserInfoVO selectUserInfoByNickname(String uiNickname);
	UserInfoVO selectUserInfoByEmail(String uiEmail);
	int insertUserInfo(UserInfoVO userInfoVO);
	int updateUserPwdByEmailAndCode(@Param("emailCodeVO") EmailCodeVO emailCodeVO,@Param("uiPwd") String uiPwd);
	int updateUserInfo(UserInfoVO userInfoVO);
	int deleteUserInfo(UserInfoVO userInfoVO);
	UserInfoVO selectUserInfoByKakaoId(String uiKakaoId);
	UserInfoVO selectUserInfoByNaverId(String uiNaverId);
	UserInfoVO selectUserInfoByGoogleId(String uiGoogleId);
	
	/* 유저 리스트 */
	List<UserInfoVO> selectUserInfoList();
	
	UserInfoVO selectSomeInfoByNickname(String uiNickname);

}
