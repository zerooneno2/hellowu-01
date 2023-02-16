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
window.addEventListener('load',()=>{
	if('${userInfo.uiEmail}' != 'demd@hanmail.net'){
		location.href = '/views/main';
	} else getRequestList();
})
	
function sendTableInfo(uiNickname,brBoardKorName,brBoardEngName,brCategory,brComment,brNum,isApproved){ // admin 검증 필요, 지금은 검증x
	let url = '/table/';
	url += isApproved? 'create':'refuse';
	url += '/${userInfo.uiEmail}';
	const param = {
		uiNickname : uiNickname,
		brBoardKorName : brBoardKorName,
		brBoardEngName : brBoardEngName,
		brCategory : brCategory,
		brComment : brComment,
		brNum : brNum
	}
	fetch(url,{
		method : 'POST',
		headers : {
			'Content-type' : 'application/json'
		},
		body : JSON.stringify(param)
	})
	.then((response)=>{
		if(response.ok) {
			return response.json();
		}
	})
	.then((resultCode)=>{ 
		if(!isApproved && resultCode){
			alert('요청이 반려되었습니다.');
			location.reload();
			return;
		} 
		let msg;
		switch(resultCode){
			case 1 : msg = '게시판 생성 완료';
			break;
			case 2 : msg = '이미 존재하는 테이블 명입니다.';
			break;
			case 3 : msg = '관리자 계정이 아닙니다.';
			break;
			default : msg = '게시판 생성 실패';
		}
		alert(msg);
		location.reload();
	})
}
function getRequestList(){ // pathvariable로 admin 검증 필요, 지금은 검증x
	const cols = document.querySelectorAll('[data-val]');
	fetch('/table/request-list')
	.then((response)=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((list)=>{
		
		let html = '';
		for(let obj of list){
			html += '<tr>';
			for(let col of cols){
				html += '<td>'+obj[col.getAttribute('data-val')]+'</td>';
				
			}
			html += `<td><button onclick="sendTableInfo('`+obj.uiNickname+`','`+obj.brBoardKorName+`',\'`+obj.brBoardEngName+`\',\'`+obj.brCategory+`\',\'`+obj.brComment+`\',\'`+obj.brNum+`\',true`+`)" class="btn btn-outline-secondary">승인</button></td>`;
			html += `<td><button onclick="sendTableInfo('`+obj.uiNickname+`','`+obj.brBoardKorName+`',\'`+obj.brBoardEngName+`\',\'`+obj.brCategory+`\',\'`+obj.brComment+`\',\'`+obj.brNum+`\',false`+`)" class="btn btn-outline-secondary">거절</button></td>`;
			
			html += '</tr>';
		}
		document.querySelector('#getRequestList').innerHTML = html;
		
	})
}

</script>
</head>
<body style="overflow-y: scroll">
	<main class="flex-shrink-0 p-3 col-lg-12 col-md-12 col-sm-12 col-12">
		<div class="container mt-3">
			<div style="margin-bottom: 20px;">
				<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
			</div>
			<table class="table col">
				<tr>
					<th data-val="uiNickname">신청자 닉네임</th>
					<th data-val="brBoardKorName">신청 게시판명</th>
					<th data-val="brBoardEngName">영문명</th>
					<th data-val="brWhatFor">개설 목적</th>
					<th data-val="brCategory">카테고리</th>
					<th data-val="brComment">소개글</th>
					<th></th>
					<th></th>
				</tr>
				<tbody id="getRequestList">

				</tbody>
			</table>
		</div>

	</main>

</body>
</html>