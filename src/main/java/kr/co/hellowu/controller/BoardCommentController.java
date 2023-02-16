package kr.co.hellowu.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.hellowu.service.BoardCommentService;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/comment")
public class BoardCommentController {
	private final BoardCommentService boardCommentService;


	@GetMapping("/list")
	public List<Map<String,String>> getBoardCommentList(@RequestParam Map<String,String> param) {
		return boardCommentService.getCommentList(param);
	}
	
	@PostMapping("/insert")
	public int insertBoardComment(@RequestBody Map<String,Map<String,String>> bodyValues) {
		return boardCommentService.insertBoardComment(bodyValues);
	}
	
	@PatchMapping("/update")
	public int updateBoardComment(@RequestBody Map<String,Map<String,String>> bodyValues) {
		return boardCommentService.updateBoardComment(bodyValues);
	}
	
	@PatchMapping("/delete/{commentNum}")
	public int deleteBoardComment(@RequestBody Map<String,String> body,@PathVariable int commentNum) {
		return boardCommentService.deleteBoardComment(body,commentNum);
	}

}
