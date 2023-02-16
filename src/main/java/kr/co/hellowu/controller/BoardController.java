package kr.co.hellowu.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonObject;

import kr.co.hellowu.service.BoardService;
import kr.co.hellowu.vo.UserInfoVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@SessionAttributes({"userInfo"})
@RequestMapping("/board")
public class BoardController {
	private final BoardService boardService;
	
	
	@PostMapping("/list") // list
	public List<Map<String,String>> getBoardList(@RequestParam Map<String,String> param,@RequestBody Map<String,String> body){
		
		return boardService.getBoardList(param,body);
	}
	
	
	@PostMapping("/insert") // 게시글 등록
	public int insertBoard(@RequestBody Map<String,Map<String,String>> bodyValues, @ModelAttribute("userInfo") UserInfoVO userInfoVO) {
		return boardService.insertBoard(bodyValues,userInfoVO.getUiNickname());
	}
	
	@PatchMapping("/update")
	public int updateBoard(@ModelAttribute("userInfo") UserInfoVO userInfoVO,@RequestBody Map<String,Map<String,String>> bodyValues) {
		return boardService.updateBoard(bodyValues);
	}
	
	
	@PostMapping("/view/{num}") // 게시글 보기
	public Map<String,String> getBoard(@PathVariable String num, @RequestBody Map<String,String> body) {
		log.info("body===>{}",body);
		return boardService.selectBoard(body, num);
	}
	
	@PutMapping("/recommend/{boardRecommendValue}") // 게시글 추천/비추천
	public boolean recommendBoard(@PathVariable String boardRecommendValue,@RequestBody Map<String,Map<String,String>> bodyValues) {
		return boardService.boardRecommendSetter(boardRecommendValue,bodyValues);
	}
	
	@PatchMapping("/delete") 
	public int deleteBoard(@RequestBody Map<String,Map<String,String>> bodyValues) {
		return boardService.deleteBoard(bodyValues);
	}
	
	@PostMapping("/prev/{boardNum}") 
	public Map<String,String> getPrevPost(@RequestBody Map<String,String> body,@PathVariable int boardNum) {
		return boardService.getPrevPost(body,boardNum);
	}
	
	@PostMapping("/next/{boardNum}") 
	public Map<String,String> getnextPost(@RequestBody Map<String,String> body,@PathVariable int boardNum) {
		return boardService.getNextPost(body,boardNum);
	}
	
	
	@PostMapping(value="/uploadSummernoteImageFile", produces = "application/json")
	public JsonObject uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile) {
		return boardService.uploadSummernoteImageFile(multipartFile);
	}
}
