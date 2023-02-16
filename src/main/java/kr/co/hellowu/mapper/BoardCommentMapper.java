package kr.co.hellowu.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface BoardCommentMapper {
	List<Map<String,String>> getBoardCommentList(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	int insertBoardComment(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	int updateBoardComment(@Param("body") Map<String,String> body, @Param("param") Map<String,String> param);
	int updateBoardCommentActive(@Param("body") Map<String,String> body, @Param("commentNum") int commentNum);
	int totalViewCnt(@Param("body") Map<String,String> body, @Param("boardNum") String boardNum);
}
