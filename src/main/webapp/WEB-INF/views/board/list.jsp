<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<!-- 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Black+And+White+Picture&display=swap" rel="stylesheet">
<meta charset="UTF-8">
<!-- 반응형 옵션  -->
<meta name="viewport" content=width=device-width user-scalable=yes,
	initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">

<!-- css -->
<link rel="stylesheet" href="/css/list.css">

<title>HELLO友</title>

<script>
const columnNames = JSON.parse(sessionStorage.getItem('data'));
let cols; 
window.onload = function(){
	if(Object.keys(columnNames).length === 1){
		alert('폐쇄된 게시판입니다.');
		location.href='/views/main';
	}
	cols = document.querySelectorAll('th[data-col]');
	for(let col of cols){ // 어떤 게시판을 눌렀냐에 따라 data-col 속성의 값을 바꾸는 코드
		col.setAttribute('data-col',columnNames[col.getAttribute('data-col')]);
	}
	getBoardList(1);
	
	document.getElementById('searchValue').addEventListener('keypress',(e)=>{
	if(e.keyCode === 13){
		e.preventDefault();
		getBoardList();	
		}
	})
	//document.querySelector('#tBody').innerHTML = sessionStorage.getItem('html');
}



function getBoardList(nowPage){
	
	let url = '/board/list?title=';
	
	const dropdown = document.getElementById('dropdown').innerText;
	const searchValue = document.getElementById('searchValue').value;
	
	if(sessionStorage.getItem('target') !== null){
		document.getElementById('searchDiv').style.display = 'none';
		document.querySelector('button[onclick*=Insert]').style.display = 'none';
		url += '&nickname='+JSON.parse(sessionStorage.getItem('target'));	
	}
	
	switch(dropdown){
	case '제목': url += searchValue 
		break;
	case '제목+내용': url += searchValue + '&content=' + searchValue 
		break;
	case '글쓴이' : url +='&nickname='+ searchValue 
		break;
	case '지역' : url +='&addr1=' + searchValue 
		break;
	} 
	
	
	const now = nowPage? nowPage : 1; 
	const bottomSize = 10; // 하단 사이즈
	const listSize = 15; // 한번에 보여줄 게시물 수
	
	if(document.querySelector('a[aria-selected]')){ //카테고리별로 보기
	  url += '&category=' + document.querySelector('a[aria-selected=true]').innerText;
	}
	url += now === 1? '&nowPage=0': '&nowPage='+((now-1)*listSize);
	
	
	fetch(url,{
		method : 'POST',
		headers : {
			'Content-type' : 'application/json'
		},
		body : sessionStorage.getItem('data')
	})
	.then(function(res){
		if(res.ok){
			return res.json();
		} else throw new Error('');
	}).then(function(data){
		/* console.log(data) */
		if(data.length == 0){
			document.getElementById('tBody').innerHTML = '';
			return;
		}
		
		let total = data[0].TOTALSIZE;  // 전체 게시글 수
		
		let totalPageSize = Math.ceil(total/listSize); // 하단 전체 사이즈
		let firstBottomNumber = now - now % bottomSize + 1; // 하단 최초 숫자
		let lastBottomNumber = now - now % bottomSize + bottomSize // 하단 마지막 숫자
		
		if(lastBottomNumber > totalPageSize){
			lastBottomNumber = totalPageSize;
		}
		
		
		
		let page = '<li style="cursor:pointer;"class="page-item"><a class="page-link" onclick="getBoardList('+((now-bottomSize)<firstBottomNumber? (now-bottomSize):firstBottomNumber)+')">PREV</a></li>';
		for(let i=firstBottomNumber; i<=lastBottomNumber; i++){
			if(i === now || now < 1){ // nowpage였는데 왜 에러 안났지
				page += '<li style="cursor:pointer;"class="page-item"><a class="page-link active" onclick="getBoardList('+i+');">'+i+'</a></li>';
				continue;
			}
			page += '<li style="cursor:pointer;"class="page-item"><a class="page-link" onclick="getBoardList('+i+');">'+i+'</a></li>';
		}
		page += '<li style="cursor:pointer;"class="page-item"><a class="page-link" onclick="getBoardList('+((now+bottomSize)<lastBottomNumber? (now+bottomSize):lastBottomNumber)+')">NEXT</a></li>';
		document.getElementById('paging').innerHTML = page;
		
		
		document.getElementById('tBody').innerHTML = '';
		for(let obj of data){
			let html = '<tr>';
			const commentCount = obj.COMMENT_COUNT > 0? '&nbsp;['+obj.COMMENT_COUNT+']' : '';
			
			if(obj[columnNames.CATEGORY] === '공지사항'){
				
				for(let col of cols){
					
					switch(col.getAttribute('data-col')){
					case columnNames.TITLE : html += '<td style="cursor:pointer;" onclick=\"location.href=\'/views/board/view?num='+obj[columnNames.NUM]+'\'\"><b>'+obj[col.getAttribute('data-col')]+'</b>'+commentCount+'</td>';
						continue;
					
					case columnNames.CATEGORY : html += '<td><b>'+obj[col.getAttribute('data-col')]+'</b></td>';
						continue;
					case columnNames.NUM : html += '<td><i class="fa-solid fa-star"></i></td>';
						continue;
					case columnNames.CREDAT : html += '<td>'+ new Intl.DateTimeFormat('ja').format(new Date(obj[col.getAttribute('data-col')])) +'</td>'; 
						continue;
					default : html += '<td><b>'+obj[col.getAttribute('data-col')]+'</b></td>'; 
					}
				}
				
			} else {
				for(let col of cols){
					switch(col.getAttribute('data-col')){
					case columnNames.NICKNAME : html += '<td style="cursor:pointer;" onclick="getUserProfile(\''+obj[columnNames.NICKNAME]+'\');">'+obj[col.getAttribute('data-col')]+'</td>';
						continue;
					case columnNames.TITLE : html += '<td style="cursor:pointer;" onclick=\"location.href=\'/views/board/view?num='+obj[columnNames.NUM]+'\'\">'+obj[col.getAttribute('data-col')]+commentCount+'</td>';
						continue;
					case columnNames.NUM : {
						if(obj[columnNames.RECOMMEND] > 0){
							html += '<td><i class="fa-regular fa-thumbs-up"></i></td>';
						} else html += '<td>'+obj[col.getAttribute('data-col')]+'</td>';
					}
						continue;
					case columnNames.CREDAT : html += '<td>'+ new Intl.DateTimeFormat('ja').format(new Date(obj[col.getAttribute('data-col')])) +'</td>';
						continue;
					default : html += '<td>'+obj[col.getAttribute('data-col')]+'</td>';
					}
				}
			}
			html += '</tr>';
			document.getElementById('tBody').insertAdjacentHTML('beforeend',html);
		}
		
		
	})
	.catch(()=>{
		// alert('글이 없습니다.');
	})
}

function getValue(self){
	document.querySelector('#dropdown').innerText = self.innerText
}

	

function goInsert(){
	if('${empty userInfo}' == 'true'){
		alert('로그인이 필요합니다.');
		location.href='/';
	} else{
		location.href='/views/board/insert';
	}
}	

async function getUserProfile(userNickname){
	
	const response = await fetch('/user-info/profile/'+userNickname);
	const profileInfo = await response.text();
	
	if(profileInfo){
		sessionStorage.setItem('profileInfo',profileInfo);
		location.href= '/views/user/information';
	}
}
</script>


</head>
<body>

	<main class="flex-shrink-0 p-3 col-lg-12 col-md-12 col-sm-12 col-12">
		<div id="footer-wrapper" style="margin-top: -60px;">
			<!-- 푸터사용 위해 만듦 -->
			<div id="footer-content">
				<!-- 푸터사용 위해 만듦 -->
				<div class="container mt-3">
					<div style="margin-bottom: 20px">
						<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
					</div>
					<ul class="nav nav-tabs" style="margin-bottom: 20px;">
						<li class="nav-item"><a class="nav-link active"
							aria-current="page" href="/views/board/list">전체보기</a></li>
						<li class="nav-item"><a type="button"
							class="nav-link category" data-bs-toggle="tab"
							onclick="getBoardList(1)">인기글</a></li>
						<li class="nav-item"><a type="button"
							class="nav-link category" data-bs-toggle="tab"
							onclick="getBoardList(1)">잡담</a></li>
						<li class="nav-item"><a type="button"
							class="nav-link category" data-bs-toggle="tab"
							onclick="getBoardList(1)">정보</a></li>
						<li class="nav-item"><a type="button"
							class="nav-link category" data-bs-toggle="tab"
							onclick="getBoardList(1)">질문</a></li>
					</ul>

					<div style="white-space: nowrap;">
						<table class="table">
							<tr>

								<th data-col="NUM">번호</th>
								<th data-col="CATEGORY">카테고리</th>
								<th data-col="ADDR1">지역</th>
								<th data-col="TITLE">제목</th>
								<th data-col="NICKNAME">작성자</th>
								<th data-col="CNT">조회수</th>
								<th data-col="CREDAT">작성일</th>
								<th data-col="RECOMMEND">추천수</th>

							</tr>
							<tbody id=tBody class="table-group-divider"></tbody>
						</table>
					</div>

					<nav style="font-size: 13px; font-family: sans-serif;"
						aria-label="Page navigation example">
						<ul class="pagination justify-content-center" id="paging"></ul>
					</nav>

					<div id="search-write-Div" style="display: flex;">
						<div class="container" id="searchDiv">
							<button id="dropdown"
								class="btn btn-outline-secondary dropdown-toggle" type="button"
								data-bs-toggle="dropdown" aria-expanded="false"
								style="width: 100px; height: 35px; border-radius: 0px;">제목</button>
							<ul class="dropdown-menu">
								<li><a class="dropdown-item" onclick="getValue(this)">제목</a></li>
								<li><a class="dropdown-item" onclick="getValue(this)">제목+내용</a></li>
								<li><a class="dropdown-item" onclick="getValue(this)">글쓴이</a></li>
								<li><a class="dropdown-item" onclick="getValue(this)">지역</a></li>
							</ul>
							<input id="searchValue" type="text" class="col-md-3"
								style="height: 35px; width: 200px;"
								aria-label="Text input with dropdown button">

							<button type="button" style="margin-bottom: 4px;"
								class="btn btn-primary" onclick="getBoardList()">검색</button>
						</div>
						<div class="container" id="writeDiv">
							<button type="button" onclick="goInsert()"
								class="btn btn-primary" style="min-width: 100px; float: right;">게시글
								작성</button>
							<br>
						</div>
					</div>
				</div>


			</div>
			<%@ include file="/WEB-INF/views/common/footer.jsp"%>
		</div>
	</main>

</body>
</html>