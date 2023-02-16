package kr.co.hellowu.mapper;

import java.util.List;
import java.util.Map;

import kr.co.hellowu.vo.BoardListVO;

public interface BoardListMapper {
	List<BoardListVO> selectSidebarMenu();
	int insertBoardList(BoardListVO boardListVO);
	List<Map<String,String>> getBoardColumnNames(String tableName);
	String findNicknameBySuffixAndNickname(BoardListVO boardListVO);
	List<Map<String,String>> selectBoardListGroupByCategory();
}
