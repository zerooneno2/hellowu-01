package kr.co.hellowu.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonObject;

import kr.co.hellowu.mapper.BoardMapper;
import kr.co.hellowu.mapper.BoardRecommendMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class BoardService {
	private final BoardMapper boardMapper;
	private final BoardRecommendMapper boardRecommendMapper;
	
	@Value("${upload.board.image.path}")
	private String uploadBoardImagePath;
	
	public List<Map<String, String>> getBoardList(Map<String, String> param, Map<String, String> body) {
		
		final String tableName = body.get("TABLENAME");
		final String prefix = tableName.substring(0,1);
		body.put("COMMENT_TABLENAME", prefix+"B_COMMENT"+tableName.substring(tableName.lastIndexOf("_")));
		body.put("COMMENT_ACTIVE", prefix+"C_ACTIVE");
		List<Map<String, String>> boardList = boardMapper.selectBoardList(body, param);
		try {
			boardList.get(0).put("TOTALSIZE", String.valueOf(boardMapper.totalViewCnt(body, param)));
		} catch (IndexOutOfBoundsException e) {
			return new ArrayList<>();
		}
		return boardList;
	}

	public int insertBoard(Map<String, Map<String, String>> bodyValues,String userNickname) { // 게시글 작성
		if(!bodyValues.get("param").get("nickname").equals(userNickname)) return 0;
		return boardMapper.insertBoard(bodyValues.get("body"), bodyValues.get("param"));
	}

	public Map<String, String> selectBoard(@Param("body") Map<String, String> body, String boardNum) {
		boardMapper.increaseBoardViewCnt(body, boardNum);
		return boardMapper.selectBoard(body, boardNum);
	}
	
	public int updateBoard(@Param("body") Map<String,Map<String,String>> bodyValues) {

		return boardMapper.updateBoard(bodyValues.get("body"), bodyValues.get("param"));
	}

	public boolean boardRecommendSetter(String boardRecommendValue, Map<String, Map<String, String>> bodyValues) { 	
		Map<String, String> body = bodyValues.get("body"); // board테이블의 칼럼 정보가 들어있음
		Map<String, String> param = bodyValues.get("param"); // boardNum과 userNickname이 들어있음
		Map<String, String> recommendTable = new HashMap<>(); // 추천 테이블의 칼럼 정보가 들어갈 맵
		final String tableName = body.get("TABLENAME");
		final String columnNameOfNum = tableName.substring(0, 1) + "B_NUM";
		final String columnNameOfValue = tableName.substring(0, 1) + "R_VALUE";
		final String suffix = tableName.substring(tableName.lastIndexOf("_") + 1);
		recommendTable.put("TABLENAME", tableName.substring(0, 1) + "B_RECOMMEND_" + suffix); //
		recommendTable.put("NUM", columnNameOfNum);
		recommendTable.put("VALUE", columnNameOfValue);
		// UI_NICKNAME 칼럼은 어느 테이블이든 고정이므로 추가 안함
		int value = boardRecommendValue.equals("추천") ? 1 : 2;
		Map<String, String> selectedRecommendTable = boardRecommendMapper.selectBoardRecommendValue(recommendTable,param);
		String boardNum = param.get("num");
		if (selectedRecommendTable == null) { // 테이블에 추천,비추천 이력이 없다면
			boardRecommendMapper.setBoardRecommendDefaultValue(recommendTable, param); // value를 0으로 행을 하나 만듭니다
			if (value == 1) {
				boardMapper.recommendBoard(body, boardNum);
			} else {
				boardMapper.disRecommendBoard(body, boardNum);
			}
			return 1 == boardRecommendMapper.updateBoardRecommendValue(value, recommendTable, param);
		} else {
			int nowValue = Integer.parseInt(String.valueOf(selectedRecommendTable.get(columnNameOfValue)));
			// selectedRecommendTable의 데이터 타입은 Map<String,String> 이므로 value값은 String 타입 => Integer.parseInt로 int로 파싱해줬다
			// => ClassCastException 발생 => 왜??? (아마 DB의 데이터타입은 TINYINT라서?) => String.valueOf로 명시적으로 String으로 바꿨더니 정상 작동
			// 그럼 형변환을 하지 않고 바로 int nowValue에 담으면 되지않나? => Map<String,String> 이라 안됨 Map<String,Object>로 했었어야 한다
			
			if (nowValue == 1 && value == 2) { 
				// 사용자의 입력값이 비추천, 현재 brValue 값은 무조건 1 아니면 2(else문이니까), nowValue % 2 == 1 => 1(추천 한번 눌림)이라면 true
				boardMapper.disRecommendBoard(body, boardNum);
				return 1 == boardRecommendMapper.updateBoardRecommendValue(value, recommendTable, param);
			}
			if (nowValue == 2 && value == 1) { 
				// 사용자의 입력값이 추천, 현재 brValue 값은 무조건1 아니면 2, nowValue % 2 == 0 => 2(비추 한번 눌림)이라면 true
				boardMapper.recommendBoard(body, boardNum);
				return 1 == boardRecommendMapper.updateBoardRecommendValue(value, recommendTable, param);
			}

		}

		return false;
	}
	
	public int deleteBoard(Map<String,Map<String,String>> bodyValues) {
		Map<String,String> body = bodyValues.get("body");
		Map<String,String> param = bodyValues.get("param");	
		return boardMapper.updateBoardActive(body, param);
	}
	
	public Map<String,String> getPrevPost(Map<String,String> body, int boardNum){
		Map<String,String> prevPost = boardMapper.getPrevPost(body, boardNum);
		if(prevPost == null) {
			return new HashMap<>();
		}
		return prevPost;
	}
	public Map<String,String> getNextPost(Map<String,String> body, int boardNum){
		Map<String,String> nextPost = boardMapper.getNextPost(body, boardNum);
		if(nextPost == null) {
			return new HashMap<>();
		}
		return nextPost;
	}
	

	public JsonObject uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile) { // 이미지 업로드
		final String basePath = System.getProperty("os.name").toUpperCase().contains("WINDOW")? "C:" : "";
		JsonObject jsonObject = new JsonObject();
		String fileRoot = basePath+uploadBoardImagePath; // 저장될 외부 파일 경로
		String originalFileName = multipartFile.getOriginalFilename(); // 오리지날 파일명
		String extension = originalFileName.substring(originalFileName.lastIndexOf(".")); // 파일 확장자
		String savedFileName = UUID.randomUUID() + extension; // 저장될 파일 명
		File targetFile = new File(fileRoot + savedFileName);

		try { 
			InputStream fileStream = multipartFile.getInputStream();
			FileUtils.copyInputStreamToFile(fileStream, targetFile); // 파일 저장
			jsonObject.addProperty("url", "/summernoteImage/" + savedFileName);
			jsonObject.addProperty("responseCode", "success");
		} catch (IOException e) {
			FileUtils.deleteQuietly(targetFile); // 저장된 파일 삭제
			jsonObject.addProperty("responseCode", "error");
			e.printStackTrace();
		}
		return jsonObject;
	}
}
