package kr.co.hellowu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface BoardMapper {
	List<Map<String,String>> selectBoardList(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	
	int totalViewCnt(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	
	int insertBoard(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	
	Map<String,String> selectBoard(@Param("body") Map<String,String> body,@Param("boardNum") String boardNum);
	
	int recommendBoard(@Param("body") Map<String,String> body,@Param("boardNum") String boardNum);
	
	int disRecommendBoard(@Param("body") Map<String,String> body,@Param("boardNum") String boardNum);
	
	int updateBoardActive(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	
	int increaseBoardViewCnt(@Param("body") Map<String,String> body, @Param("boardNum") String boardNum);
	
	Map<String,String> getPrevPost(@Param("body") Map<String,String> body, @Param("boardNum") int boardNum);
	
	Map<String,String> getNextPost(@Param("body") Map<String,String> body, @Param("boardNum") int boardNum);
	
	int updateBoard(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	
	
}
