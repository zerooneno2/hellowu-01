package kr.co.hellowu.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.hellowu.service.TableService;
import kr.co.hellowu.vo.BoardListVO;
import kr.co.hellowu.vo.BoardRequestVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j 
@RequestMapping("/table")
public class TableController {
	private final TableService tableService;
	
	@PostMapping("/create/{adminEmail}") // 게시판 생성 요청 승인
	public int createTable(@RequestBody BoardRequestVO boardRequestVO,@PathVariable String adminEmail) {
		return tableService.createBoard(boardRequestVO,adminEmail);
	}
	
	@PostMapping("/refuse/{adminEmail}") // 게시판 생성 요청 거절
	public boolean refuseRequest(@RequestBody BoardRequestVO boardRequestVO,@PathVariable String adminEmail) {
		return tableService.deleteBoardRequest(boardRequestVO,adminEmail);
	}
	
	@PostMapping("/request") // 게시판 생성 요청
	public int requestTable(@RequestBody BoardRequestVO boardRequestVO) {
		return tableService.insertBoardRequest(boardRequestVO);
	}
	
	@GetMapping("/request-list") // 게시판 생성 요청 리스트
	public List<BoardRequestVO> getRequestList(){
		return tableService.selectBoardRequestList();
	}
	
	@GetMapping("/list")
	public List<BoardListVO> getSidebarBoardList(){
		return tableService.getSidebarMenu();
	}
	
	@GetMapping("/get-column")
	public Map<String,String> getBoardColumnNames(@RequestParam("name") String name, @RequestParam("suffix") String suffix){
		return tableService.getBoardColumnNames(name,suffix);
	}
	
	@PostMapping("/get-every-post/{nickname}")
	public Map<String,List<Map<String,String>>> getEveryPost(@RequestBody Map<String,String> tableMap, @PathVariable String nickname){
		
		return tableService.getEveryPost(tableMap,nickname);
	}
	
	@GetMapping("/check-requester")
	public boolean checkRequester(BoardListVO boardListVO) {
		return tableService.checkRequester(boardListVO);
	}
	
	@GetMapping("/get-main-list")
	public List<List<Map<String,String>>> getMainBoardList(){
		return tableService.getFiveRandomBoardList();
	}
	
}
