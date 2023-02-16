package kr.co.hellowu.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.co.hellowu.mapper.BoardListMapper;
import kr.co.hellowu.mapper.TableMapper;
import kr.co.hellowu.vo.BoardListVO;
import kr.co.hellowu.vo.BoardRequestVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class TableService {
	private final TableMapper tableMapper;
	private final BoardListMapper boardListMapper;
	@Value("${admin.email}")
	private String adminEmail;
	
	public int createBoard(BoardRequestVO boardRequestVO,String adminEmail) {
		log.info("보드뤼퀘스트=>{}",boardRequestVO);
		char[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
		StringBuilder sb = new StringBuilder();
		Random rd = new Random();
		for (int i = 0; i < 5; i++) {
			sb.append(chars[rd.nextInt(26)]);
		}
		final String suffix = "_"+sb.toString();
		String tableName = boardRequestVO.getBrBoardEngName()+"_BOARD"+suffix;
		
		if(!this.adminEmail.equals(adminEmail)) return 3; 
		
		tableName = tableName.toUpperCase();
		final String prefix = tableName.substring(0,1)+tableName.substring(tableName.indexOf("_")+1,tableName.indexOf("_")+2);
		Map<String,String> queryMap = new HashMap<>();
		StringBuilder SQLBuilder = new StringBuilder();
		SQLBuilder.append("CREATE TABLE ")
		.append(tableName+" (")
		.append(prefix+"_NUM INT(11) NOT NULL AUTO_INCREMENT,")
		.append(prefix+"_CATEGORY VARCHAR(10) NOT NULL,")
		.append("UI_NICKNAME VARCHAR(16) NOT NULL,")
		.append(prefix+"_TITLE VARCHAR(100) NOT NULL,")
		.append(prefix+"_CONTENT TEXT NOT NULL,")
		.append(prefix+"_ADDR1 VARCHAR(100) NOT NULL,")
		.append(prefix+"_CNT INT(11) DEFAULT '0',")
		.append(prefix+"_ACTIVE CHAR(1) DEFAULT '1',")
		.append(prefix+"_RECOMMEND INT(11) DEFAULT '0',")
		.append(prefix+"_CREDAT DATETIME DEFAULT current_timestamp(),")
		.append(prefix+"_MODDAT DATETIME DEFAULT current_timestamp(),")
		.append("PRIMARY KEY ("+prefix+"_NUM) USING BTREE,\r\n"
				+ "	INDEX FK_"+tableName+"_USER_INFO (UI_NICKNAME) USING BTREE,\r\n"
				+ "	CONSTRAINT FK_"+tableName+"_USER_INFO FOREIGN KEY (UI_NICKNAME) REFERENCES USER_INFO (UI_NICKNAME) ON UPDATE CASCADE ON DELETE CASCADE)");
		queryMap.put("createTable", SQLBuilder.toString());
		queryMap.put("tableName", tableName);
		
		try {
			tableMapper.createTable(queryMap);
			createBoardComment(tableName,prefix,suffix);
			createBoardRecommend(tableName,prefix,suffix);
			
		} catch(Exception e) {
			return 2;
		}
		BoardListVO boardListVO = new BoardListVO();
		boardListVO.setBlRequesterNickname(boardRequestVO.getUiNickname());
		boardListVO.setBlBoardKorName(boardRequestVO.getBrBoardKorName());
		boardListVO.setBlBoardEngName(boardRequestVO.getBrBoardEngName());
		boardListVO.setBlCategory(boardRequestVO.getBrCategory());
		boardListVO.setBlSuffix(String.valueOf(suffix));
		boardListVO.setBlComment(boardRequestVO.getBrComment());
		if(boardListMapper.insertBoardList(boardListVO) != 1) {
			return 2;
		}

		tableMapper.deleteBoardRequest(boardRequestVO); // 게시판 생성 요청 리스트에서 삭제
		log.info("체크=>{}",tableMapper.checkTableCreated(queryMap));
		return null!=tableMapper.checkTableCreated(queryMap)? 1:2;
	}
	
	public void createBoardComment(String tableName,String prefix,String suffix) {
		StringBuilder SQLBuilder = new StringBuilder();
		Map<String,String> queryMap = new HashMap<>();
		final String commentPrefix = prefix.substring(0,1)+"C";
		SQLBuilder.append("CREATE TABLE ")
		.append(prefix+"_COMMENT"+suffix+"(")
		.append(commentPrefix+"_NUM INT(11) NOT NULL AUTO_INCREMENT,")
		.append(prefix+"_NUM INT(11) NOT NULL,")
		.append("UI_NICKNAME VARCHAR(16) NOT NULL,")
		.append(commentPrefix+"_CONTENT VARCHAR(400) NOT NULL,")
		.append(commentPrefix+"_ACTIVE CHAR(1) DEFAULT '1',")
		.append(commentPrefix+"_CREDAT DATETIME DEFAULT current_timestamp(),")
		.append(commentPrefix+"_MODDAT DATETIME DEFAULT current_timestamp(),")
		.append("PRIMARY KEY ("+commentPrefix+"_NUM) USING BTREE,\r\n"
				+ "	INDEX "+prefix+"_COMMENT_ibfk_"+suffix+" ("+prefix+"_NUM) USING BTREE,\r\n"
				+ "	INDEX FK_"+prefix+"_COMMENT_USER_INFO"+suffix+" (UI_NICKNAME) USING BTREE,\r\n"
				+ "	CONSTRAINT "+prefix+"_COMMENT_ibfk_"+suffix+" FOREIGN KEY ("+prefix+"_NUM) REFERENCES "+tableName+" ("+prefix+"_NUM) ON UPDATE CASCADE ON DELETE CASCADE,\r\n"
				+ "	CONSTRAINT FK_"+prefix+"_COMMENT_USER_INFO"+suffix+" FOREIGN KEY (UI_NICKNAME) REFERENCES USER_INFO (UI_NICKNAME) ON UPDATE CASCADE ON DELETE CASCADE)");
		queryMap.put("createTable", SQLBuilder.toString());
		tableMapper.createTable(queryMap);
	}
	
	public void createBoardRecommend(String tableName,String prefix,String suffix) {
		StringBuilder SQLBuilder = new StringBuilder();
		Map<String,String> queryMap = new HashMap<>();
		final String recommendPrefix = prefix.substring(0,1)+"R";
		SQLBuilder.append("CREATE TABLE ")
		.append(prefix+"_RECOMMEND"+suffix+"(")
		.append(prefix+"_NUM INT(11) NOT NULL,")
		.append("UI_NICKNAME VARCHAR(16) NOT NULL,")
		.append(recommendPrefix+"_VALUE TINYINT(4) DEFAULT '0',")
		.append("PRIMARY KEY("+prefix+"_NUM,UI_NICKNAME) USING BTREE,")
		.append("INDEX FK_"+prefix+"_RECOMMEND_USER_INFO"+suffix+" (UI_NICKNAME) USING BTREE,")
		.append("INDEX FK_"+prefix+"_RECOMMEND_"+tableName+suffix+"("+prefix+"_NUM) USING BTREE,"
				+ "	CONSTRAINT FK_"+prefix+"_RECOMMEND_"+tableName+suffix+" FOREIGN KEY ("+prefix+"_NUM) REFERENCES "+tableName+" ("+prefix+"_NUM) ON UPDATE CASCADE ON DELETE CASCADE,\r\n"
				+ "	CONSTRAINT FK_"+prefix+"_RECOMMEND_USER_INFO"+suffix+" FOREIGN KEY (UI_NICKNAME) REFERENCES USER_INFO (UI_NICKNAME) ON UPDATE CASCADE ON DELETE CASCADE)");
		queryMap.put("createTable", SQLBuilder.toString());
		tableMapper.createTable(queryMap);
	}
	public List<BoardRequestVO> selectBoardRequestList(){
		return tableMapper.selectBoardRequestList();
	}
	
	public int insertBoardRequest(BoardRequestVO boardRequestVO) {
		if(!Pattern.matches("^[가-힣a-zA-Z]{2,16}$", boardRequestVO.getUiNickname())) return 2;
		if(!Pattern.matches("^[가-힣]{2,16}$", boardRequestVO.getBrBoardKorName())) return 3;
		if(!Pattern.matches("^[a-zA-Z]{2,16}$", boardRequestVO.getBrBoardEngName())) return 4;
		if(boardRequestVO.getBrWhatFor().length() < 1) return 5;
		if(boardRequestVO.getBrCategory().length() < 1) return 6;
		if(boardRequestVO.getBrComment().length() < 1) return 7;
		return tableMapper.insertBoardRequest(boardRequestVO);
	}
	
	public boolean deleteBoardRequest(BoardRequestVO boardRequestVO,String adminEmail) {
		return this.adminEmail.equals(adminEmail)? 1==tableMapper.deleteBoardRequest(boardRequestVO) : false;
	}
	
	public List<BoardListVO> getSidebarMenu(){
		return boardListMapper.selectSidebarMenu();
	}
	
	public Map<String,String> getBoardColumnNames(String tableName,String suffix){
		List<Map<String,String>> columnNameList = boardListMapper.getBoardColumnNames(tableName.toUpperCase()+"_BOARD"+suffix);
		Map<String,String> columnNameMap = new HashMap<>();
		for(Map<String,String> map : columnNameList) {
			columnNameMap.put(map.get("COLUMN_NAME").substring(3), map.get("COLUMN_NAME"));
		}
		columnNameMap.put("TABLENAME", tableName.toUpperCase()+"_BOARD"+suffix);
		return columnNameMap;
	}
	
	public Map<String,List<Map<String,String>>> getEveryPost(Map<String,String> tableMap, String nickname){ // 내가 쓴 게시물 보기 => 테이블 영문명, 게시판 한글명 : List<Map<String,String>>으로 반환
		Map<String,List<Map<String,String>>> postMap = new HashMap<>();
		for(Entry<String,String> entry : tableMap.entrySet()) {
			List<Map<String,String>> resultList = tableMapper.getMyEveryPost(entry.getKey(),entry.getKey().substring(0,1)+"B_ACTIVE", nickname);
			postMap.put(entry.getKey()+","+entry.getValue(), resultList);
		}
		
		return postMap;
	}
	
	public boolean checkRequester(BoardListVO boardListVO) {
		String boardRequesterNickname = boardListMapper.findNicknameBySuffixAndNickname(boardListVO);
		return boardRequesterNickname != null? boardRequesterNickname.equals(boardListVO.getBlRequesterNickname()) : false;
		}
	
	public List<List<Map<String,String>>> getFiveRandomBoardList(){
		List<List<Map<String,String>>> resultList = new ArrayList<>();
		List<Map<String,String>> randomFiveBoardList = boardListMapper.selectBoardListGroupByCategory(); // 카테고리별로 랜덤한 5개의 게시판 정보를 담은 맵 리스트
		for(Map<String,String> board : randomFiveBoardList) { // for문 돌려~
			try {
				final String prefix = board.get("BL_BOARD_ENG_NAME").toUpperCase(); // 테이블 prefix 따와서
				board.put("TABLE", prefix+"_BOARD"+board.get("BL_SUFFIX")); // 테이블명 넣어주고
				board.put("RECOMMEND", prefix.substring(0,1)+"B_RECOMMEND"); // 추천 많이 받은 순으로 최대 5개 가져올거니까 추천수 칼럼명도 넣어주고
				board.put("ACTIVE", prefix.substring(0,1)+"B_ACTIVE"); // 삭제된것까지 불러오면 안되니까 넣어주고
				List<Map<String,String>> boardList = tableMapper.getBoardList(board); // 추천 높은순으로 정렬한 리스트 가져와서
				board.remove("ACTIVE"); // 임시로 넣어준 key,value값을 지운다.
				boardList.add(board); // 게시판 정보도 넣어준다 
				board.remove("TABLE"); // add하고나서 지워도 참조값을 지우는 것이기 때문에 순서는 상관없음1
				resultList.add(boardList); 
				board.remove("RECOMMEND"); // 순서는 상관없음2
			} catch (Exception e) { // 게시판이 삭제됐는데 navbar에서는 남아있어 유저가 접속할 경우 발생
				resultList.add(null); 
			}
		}
		return resultList;
	}
}
