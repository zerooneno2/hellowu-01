package kr.co.hellowu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.co.hellowu.vo.BoardRequestVO;

public interface TableMapper {
	int createTable(Map<String,String> queryMap);
	List<Map<String,String>> checkTableCreated(Map<String,String> queryMap);
	List<BoardRequestVO> selectBoardRequestList();
	int insertBoardRequest(BoardRequestVO boardRequestVO);
	int deleteBoardRequest(BoardRequestVO boardRequestVO);
	List<Map<String,String>> getMyEveryPost(@Param("table") String table,@Param("active") String active, @Param("nickname") String nickname);
	List<Map<String,String>> getBoardList(@Param("body") Map<String,String> body); 
}
