package kr.co.hellowu.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.hellowu.service.UserFollowService;
import kr.co.hellowu.vo.UserFollowVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/follow")
public class UserFollowController {
	private final UserFollowService userFollowService;
	
	@PostMapping("/insert")
	public int insertFollow(@RequestBody UserFollowVO userFollowVO) {
		
		return userFollowService.insertFollow(userFollowVO);
	}
	
	@PostMapping("/delete")
	public int deleteFollow(@RequestBody UserFollowVO userFollowVO) {
		
		return userFollowService.deleteFollow(userFollowVO);
	}
	
	@GetMapping("/following/{uiNum}")
	public List<UserFollowVO> selectFollowingUser(@PathVariable int uiNum){ //내가 팔로우한 유저
		return userFollowService.selectFollowingUser(uiNum);
	}
	
	@GetMapping("/follower/{uiNum}")
	public List<UserFollowVO> selectFollowUser(@PathVariable int uiNum){ //나를 팔로우한 유저
		return userFollowService.selectFollowUser(uiNum);
	}
	
	@GetMapping("/check")
	public boolean followCheck(UserFollowVO userFollowVO) {
		log.info("==>{}",userFollowVO);
		return userFollowService.isFollowed(userFollowVO);
	}
}
