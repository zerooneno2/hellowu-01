package kr.co.hellowu.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.hellowu.mapper.UserFollowMapper;
import kr.co.hellowu.vo.UserFollowVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserFollowService {
	private final UserFollowMapper userFollowMapper;

	public int countFollowers(int uiFollowingNum) {
		return userFollowMapper.countFollowers(uiFollowingNum);
	}

	public int countFollowing(int uiFollowerNum) {
		return userFollowMapper.countFollowing(uiFollowerNum);
	}

	public int insertFollow(UserFollowVO userFollowVO) {
		return userFollowMapper.insertFollow(userFollowVO);
	}

	public int deleteFollow(UserFollowVO userFollowVO) {
		return userFollowMapper.deleteFollow(userFollowVO);
	}

	public List<UserFollowVO> selectFollowingUser(int uiNum) { // 내가 팔로우한 유저
		List<UserFollowVO> userFollowList = userFollowMapper.selectFollowingUser(uiNum);
		for (UserFollowVO userFollow : userFollowList) {
			if (userFollow.getUiAddr1().length() > 0 ) {
				String addr = "";
				String[] splitAddr = userFollow.getUiAddr1().split(" ");
				for (int i = 0; i < 2; i++) {
					if (i == 1)
						addr += " ";
					addr += splitAddr[i];
				}
				userFollow.setAddr(addr);
			}
		}
		return userFollowList;

	}

	public List<UserFollowVO> selectFollowUser(int uiNum) { // 나를 팔로우한 유저
		List<UserFollowVO> userFollowList = userFollowMapper.selectFollowUser(uiNum);
		for (UserFollowVO userFollow : userFollowList) {
			if (userFollow.getUiAddr1().length() > 0) {
				String addr = "";
				String[] splitAddr = userFollow.getUiAddr1().split(" ");
				for (int i = 0; i < 2; i++) {
					if (i == 1)
						addr += " ";
					addr += splitAddr[i];
				}
				userFollow.setAddr(addr);
			}
		}
		return userFollowList;
	}

	public boolean isFollowed(UserFollowVO userFollowVO) {
		return 1 == userFollowMapper.selectIsFollowed(userFollowVO); // 1 => 내가 이미 팔로우 했다
	}
}
