<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<meta charset="UTF-8">
<title>HELLO友</title>
<link rel="stylesheet" href="/css/view.css">
<script>
function sendTableInfo(){
	fetch('/table/create/'+document.querySelector('#tableName').value)
	.then((response)=>{
		if(response.ok) {
			return response.json();
		}
	})
	.then((resultCode)=>{ 
		let msg;
		switch(resultCode){
			case 1 : msg = '게시판 생성 완료';
			break;
			case 2 : msg = '이미 존재하는 테이블 명입니다.';
			break;
			case 3 : msg = '관리자 계정이 아닙니다.';
			break;
			case 4 : msg = '영어를 사용하고 문자열 사이에 \'_\'가 하나 존재해야 합니다.';
			break;
			default : msg = '게시판 생성 실패';
		}
		alert(msg);
	})
}

function sendBoardRequest(){
	const param = {uiNickname : '${userInfo.uiNickname}'};
	const items = document.querySelectorAll('[id^=br]');
	for(let item of items){
		if(item.value.indexOf("\'") !== -1 || item.value.indexOf('\"') !== -1){
			alert("따옴표는 포함될 수 없습니다.");
			return;
		} else {
			param[item.getAttribute('id')] = item.value;
		}
		
	}
	
	fetch('/table/request',{
		method : 'POST',
		headers : {
			'Content-type' : 'application/json'
		},
		body : JSON.stringify(param)
	})
	.then((response)=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((result)=>{
		let msg;
		switch(result){
			case 1 : msg = '관리자에게 게시판 생성 요청을 전달하였습니다.';
			location.href = '/views/main';
			break;
			case 2 : msg = '로그인이 필요합니다.';
			break;
			case 3 : msg = '게시판 이름(한글)은 2~16자까지만 가능합니다.';
			break;
			case 4 : msg = '게시판 이름(영문)은 2~16자까지만 가능합니다.';
			break;
			case 5 : msg = '개설 목적을 입력해주세요.';
			break;
			case 6 : msg = '카테고리를 선택해주세요.';
			break;
			case 7 : msg = '게시판 소개를 입력해주세요.';
			break;
			default : msg = '게시판 이름(한글) 또는 게시판 이름(영문)이 중복됩니다.';
		}
		alert(msg);
	})
	
}
</script>
</head>
<body>
	<div class="container mt-3">
		<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
	</div>
	<main style="margin: -17px 0px 0 -8px;"
		class="flex-shrink-0 p-3 col-lg-12 col-md-12 col-sm-12 col-12">
		<div
			class="container mt-3 col-lg-3 col-md-4 col-sm-5 col-6 border border-3 border-secondary rounded">
			<div class="p-2">
				<div class="form-group">
					<label for="brBoardKorName">게시판 이름(한글)</label> <input type="text"
						class="form-control" id="brBoardKorName"> <label
						for="brBoardEngName">게시판 이름(영문)</label> <input type="text"
						class="form-control" id="brBoardEngName"> <label
						for="brWhatFor">개설 목적</label> <input type="text"
						class="form-control" id="brWhatFor">
				</div>
				<div class="form-group">
					<label for="brCategory">카테고리</label> <select class="form-control"
						id="brCategory">
						<option>운동</option>
						<option>취미</option>
						<option>공부</option>
						<option>게임</option>
						<option>지역</option>
					</select>
				</div>

				<div class="form-group">
					<label for="brComment">게시판 소개</label>
					<textarea class="form-control" id="brComment" style="resize: none;"
						rows="3"></textarea>
				</div>
				<div class="form-group" style="margin: 8px 0 4px 4px">
					<button onclick="sendBoardRequest()" class="btn btn-primary">전송</button>
				</div>
			</div>
		</div>
	</main>
</body>
</html>