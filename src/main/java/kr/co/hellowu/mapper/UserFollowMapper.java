package kr.co.hellowu.mapper;

import java.util.List;

import kr.co.hellowu.vo.UserFollowVO;

public interface UserFollowMapper {
	int countFollowers(int uiFollowingNum);
	int countFollowing(int uiFollowerNum);
	int insertFollow(UserFollowVO userFollowVO);
	int deleteFollow(UserFollowVO userFollowVO);
	
	List<UserFollowVO> selectFollowingUser (int uiNum); //내가 추가한 유저
	List<UserFollowVO> selectFollowUser (int uiNum); //나를 추가한 유저
	
	int selectIsFollowed(UserFollowVO userFollowVO);
}
