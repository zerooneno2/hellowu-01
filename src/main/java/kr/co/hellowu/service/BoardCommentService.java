package kr.co.hellowu.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.co.hellowu.mapper.BoardCommentMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class BoardCommentService {
	private final BoardCommentMapper boardCommentMapper;
	
	public List<Map<String,String>> getCommentList(Map<String,String> param){
		Map<String,String> body = new HashMap<>();
		Map<String,String> tmpMap = new HashMap<>();
		final String prefix = param.get("name").substring(0,1).toUpperCase();
		body.put("TABLENAME", prefix+"B_COMMENT_"+param.get("suffix").toUpperCase());
		body.put("PKNUM", prefix+"C_NUM");
		body.put("FKNUM", prefix+"B_NUM");
		body.put("CONTENT", prefix+"C_CONTENT");
		body.put("ACTIVE", prefix+"C_ACTIVE");
		body.put("MODDAT", prefix+"C_MODDAT");
		// UI_NICKNAME => 고정이므로 CREDAT => 안써서
		tmpMap.put("boardNum", param.get("num"));
		tmpMap.put("nowPage", param.get("nowPage"));
		List<Map<String,String>> commentList = boardCommentMapper.getBoardCommentList(body, tmpMap);
		try {
			commentList.get(0).put("TOTALSIZE", String.valueOf(boardCommentMapper.totalViewCnt(body,param.get("num"))));
		} catch (IndexOutOfBoundsException e) {
			return new ArrayList<>();
		}
		return commentList;
	}
	
	public int insertBoardComment(Map<String,Map<String,String>> bodyValues) {
		Map<String,String> body = bodyValues.get("body");
		Map<String,String> param = bodyValues.get("param");
		Map<String,String> commentTable = new HashMap<>();
		final String tableName = body.get("TABLENAME");
		final String prefix = tableName.substring(0,1);
		commentTable.put("TABLENAME", prefix+"B_COMMENT_"+tableName.substring(tableName.lastIndexOf("_")+1));
		commentTable.put("PKNUM", prefix+"C_NUM");
		commentTable.put("FKNUM", prefix+"B_NUM");
		// 닉네임 칼럼명은 고정이므로 넣지 않음
		commentTable.put("CONTENT", prefix+"C_CONTENT");
		commentTable.put("ACTIVE", prefix+"C_ACTIVE");
		commentTable.put("CREDAT", prefix+"C_CREDAT");
		commentTable.put("MODDAT", prefix+"C_MODDAT");
		
		return boardCommentMapper.insertBoardComment(commentTable, param);
	}
	
	public int updateBoardComment(Map<String,Map<String,String>> bodyValues) {
		Map<String,String> body = bodyValues.get("body");
		Map<String,String> param = bodyValues.get("param");
		final String tableName = body.get("TABLENAME");
		body.put("TABLENAME", tableName.substring(0,1)+"B_COMMENT"+tableName.substring(tableName.lastIndexOf("_")));
		return boardCommentMapper.updateBoardComment(body,param);
	}
	
	public int deleteBoardComment(Map<String,String> body, int boardNum) {
		final String tableName = body.get("TABLENAME");
		final String prefix = tableName.substring(0,1);
		body.put("TABLENAME", prefix+"B_COMMENT"+tableName.substring(tableName.lastIndexOf("_")));
		body.put("ACTIVE", prefix+"C_ACTIVE");
		body.put("NUM", prefix+"C_NUM");
		log.info("body=>{}",body);
		return boardCommentMapper.updateBoardCommentActive(body,boardNum);
	}
}
