package kr.co.hellowu.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface BoardRecommendMapper {
	Map<String,String> selectBoardRecommendValue(@Param("body") Map<String,String> body,@Param("param") Map<String,String> param);
	int setBoardRecommendDefaultValue(@Param("body") Map<String,String> body,@Param("param") Map<String,String> param);
	int updateBoardRecommendValue(@Param("value") int value,@Param("body") Map<String,String> body,@Param("param") Map<String,String> param);
}
