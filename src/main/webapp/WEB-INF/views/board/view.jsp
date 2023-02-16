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

<style>
.container {
	margin-top: 10px;
}

#btn {
	float: right;
	margin-top: 10px;
}

#comment {
	padding-top: 10px;
}

.card {
	margin-top: 80px;
}

#commentBtn {
	float: right;
	margin-top: 10px;
}

#recommendBtn {
	margin-left: 40%;
	margin-bottom: 10px;
}
</style>

<script>
let writer;
const columnNames = JSON.parse(sessionStorage.getItem('data'));

		window.onload = function(){	
			getView();
			getCommentList(1);
			getPrevPost();
			getNextPost();
		} 
		
		function getView(){
			fetch('/board/view/${param.num}',{
				method : 'POST',
				headers : {
					'Content-type' : 'application/json'
				},
				body : sessionStorage.getItem('data')
			})
			.then(function(res){
				return res.json();
			})
			.then(function(boardInfo){
				writer = boardInfo.UI_NICKNAME; // 웹소켓으로 게시물 작성자 아이디 전송하기 위함
				if(boardInfo[columnNames.ACTIVE] === 0){
					alert('잘못된 접근입니다.');
					return;
				}
				/* console.log(boardInfo) */
				const items = document.querySelectorAll('.boardInfo');
				for(let item of items){
					if(item.getAttribute('id') === 'CONTENT'){
						item.innerHTML = boardInfo[columnNames[item.getAttribute('id')]];
						continue;
					}
					if(item.getAttribute('id') === 'CNT'){
						item.innerText = '조회수 ' + boardInfo[columnNames[item.getAttribute('id')]];
						continue;
					}
					item.innerText = boardInfo[columnNames[item.getAttribute('id')]];
				}
				if('${userInfo.uiNickname}' === boardInfo[columnNames.NICKNAME]){
					document.querySelector('#btn').style.display = '';
					document.querySelector('#recommendBtn').style.display = 'none';
				}
			});
		}
		
		
		function recommend(obj){
			if(JSON.parse('${empty userInfo}')){
				alert('로그인이 필요합니다.');
				return;
			}
			const param = {
				num : '${param.num}',
				nickname : '${userInfo.uiNickname}'
			}
			fetch('/board/recommend/'+obj.innerText,{
				method:'PUT',
				headers : {
					'Content-type' : 'application/json'
				},
				body : JSON.stringify({
					body : columnNames,
					param : param
				})
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data){
					location.reload();
				} else {
					alert('이미 '+obj.innerText+'하셨습니다.');
				} 
			})
		}
		function getCommentList(nowPage){
			
			let now = 1; // 현재 페이지
			const bottomSize = 5; // 하단 사이즈
			const listSize = 10; // 한번에 보여줄 게시물 수
			if(typeof nowPage ==='number' && nowPage > 0){
				now = nowPage;
			}
			let url = '/comment/list?num=${param.num}&name=' + sessionStorage.getItem('name') + '&suffix=' + sessionStorage.getItem('suffix').substring(1);
			url += now==1? '&nowPage=0': '&nowPage='+((now-1)*listSize);
			fetch(url)
			.then((response)=>{
				if(response.ok){
					return response.json();
				}
			})
			.then((list)=>{
				/* console.log(list);
				console.log('now',now)
				console.log('nowPage',nowPage) */
				
				let total = list[0].TOTALSIZE;  // 전체 게시글 수
				/* console.log('total',total); */
				let totalPageSize = Math.ceil(total/listSize); // 하단 전체 사이즈
				let firstBottomNumber = now - now % bottomSize + 1; // 하단 최초 숫자
				let lastBottomNumber = now - now % bottomSize + bottomSize // 하단 마지막 숫자
				
				if(lastBottomNumber > totalPageSize){
					lastBottomNumber = totalPageSize;
				}
				
				let page = '<li style="cursor:pointer;"class="page-item"><a class="page-link" onclick="getCommentList('+((now-bottomSize)<firstBottomNumber? (now-bottomSize):firstBottomNumber)+')">PREV</a></li>';
				for(let i=firstBottomNumber; i<=lastBottomNumber; i++){
					if(i === now || now < 1){
						page += '<li style="cursor:pointer;"class="page-item"><a class="page-link active" onclick="getCommentList('+i+');">'+i+'</a></li>';
						continue;
					}
					page += '<li style="cursor:pointer;"class="page-item"><a class="page-link" onclick="getCommentList('+i+');">'+i+'</a></li>';
				}
				page += '<li style="cursor:pointer;"class="page-item"><a class="page-link" onclick="getCommentList('+((now+bottomSize)<lastBottomNumber? (now+bottomSize):lastBottomNumber)+')">NEXT</a></li>';
				document.getElementById('paging').innerHTML = page;
				
				document.getElementById('reply-box').innerHTML = '';
				for(let tmpObj of list){ 
					let html = '';
					const obj = {};
					for(let key in tmpObj){
						if(key.substring(1) === 'B_NUM'){
							obj.FKNUM = tmpObj[key];
							continue;
						}
						if(key.substring(1) === 'C_NUM'){
							obj.PKNUM = tmpObj[key];
							continue;
						}
						obj[key.substring(3)] = tmpObj[key];
						
					}

					html += '<li style="position: relative;" class="list-group-item d-flex justify-content-between">';
					html += '<p style="display:none;"'+obj.PKNUM+'<br></p>';
					html += '<div style="font-family: Roboto;">'+obj.NICKNAME+'<span><small class="text-muted"> '+obj.MODDAT+'</small></span><br><div>'+obj.CONTENT+'</div>';
					html += '<div class="collapse form-group" id="collapseExample'+obj.PKNUM+'">';
					html += '<textarea placeholder="댓글 수정" class="form-control" rows="3" cols="100%" id="updateBc'+obj.PKNUM+'" style="resize:none;">'+obj.CONTENT+'</textarea>';
					if('${userInfo.uiNickname}' === obj.NICKNAME){
						html += '<i id="updateBtn'+obj.PKNUM+'"style="cursor:pointer; position: absolute; margin: -22px 0 0 6px;" class="fa-sharp fa-solid fa-pen-nib" ></i></div></div>';
						html += '<div class="form-group" style="float: right;">';
						html += '<i style="cursor:pointer;" class="fa-regular fa-pen-to-square" data-bs-toggle="collapse" href="#collapseExample'+obj.PKNUM+'" role="button" aria-expanded="false" aria-controls="collapseExample"></i>';
						html += '<i id="deleteBtn'+obj.PKNUM+'"style="cursor:pointer;" class="fa-solid fa-trash-can"></i></div>';
					}
					html += '</li>';
					
					setTimeout(()=>{ // addEventListener로 이벤트 부여할 대상이 찾아지지가 않아서 딜레이 부여
						if('${userInfo.uiNickname}' === obj.NICKNAME){
							document.getElementById('updateBtn'+obj.PKNUM).addEventListener('click',(e)=>{
								
								updateComment(obj,tmpObj);
							});
							document.getElementById('deleteBtn'+obj.PKNUM).addEventListener('click',(e)=>{
								deleteComment(obj.PKNUM);
							});
						}
					},500)
					document.getElementById('reply-box').insertAdjacentHTML('beforeend',html);
				}
				

				

				
			})
		}
		
		function insertComment(){
			if(JSON.parse('${empty userInfo}')){
				alert('로그인이 필요합니다.');
				return;
			}
			
			const param = {
				content : document.getElementById('comment').value,
				nickname : '${userInfo.uiNickname}',
				num : '${param.num}'
			}
			if(param.content.length == 0){
				alert('댓글을 입력해주세요.');
				return;
			}
			fetch('/comment/insert',{
				method : 'POST',
				headers : {
					'Content-Type' : 'application/json'
				},
				body : JSON.stringify({
					body : columnNames,
					param : param
				})
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data){
					socket.send('COMMENT&${userInfo.uiNickname}&'+writer+'&'+columnNames.TABLENAME+'&${param.num}');	
					location.reload();
				}
			})
		}
		
		function deleteComment(num){
			
			fetch('/comment/delete/'+num,{
				method : 'PATCH',
				headers : {
					'Content-type' : 'application/json'
				},
				body : JSON.stringify({
					TABLENAME : columnNames.TABLENAME
				})
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data){
					location.reload();
				}
			});
		}
		function updateComment(obj,tmpObj){ 
			
			const body = {
				TABLENAME : columnNames.TABLENAME
			};
			for(let key in tmpObj){
				body[key.substring(3)] = key;
			}
			body.NUM = columnNames.TABLENAME.substring(0,1) + 'C_NUM';
			
			const param = {
				num : obj.PKNUM,
				content : document.getElementById('updateBc'+obj.PKNUM).value
			}
			
			if(param.content.length == 0){
				alert('댓글을 입력해주세요.');
				return;
			}
			fetch('/comment/update', {
				method : 'PATCH',
				headers :{
					'Content-Type':'application/json'
				},
				body : JSON.stringify({
					param : param,
					body : body
				})
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data){
					location.reload();
				}
			})

		}
		
		function deleteTestBoard(){
			fetch('/board/delete',{
				method:'PATCH',
				headers : {
					'Content-type' : 'application/json'
				},
				body : JSON.stringify({
					body : columnNames,
					param : {
						num : '${param.num}',
						nickname : '${userInfo.uiNickname}'
					}
				})
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data){
					location.href = '/views/board/list';
				}
			});
		}
		function getNextPost(){
			fetch('/board/next/${param.num}',{
				method : 'POST',
				headers : {
					'Content-type' : 'application/json'
				},
				body : sessionStorage.getItem('data')
			})
			.then(async function(res){
				if(res.ok){
					return res.json();
				} 
			})
			.then(function(next){
				let html = '';
				if(next[columnNames.TITLE] == null){
					html += '<div class="list-group" style="margin-top: 70px;">';
					html += '<span class="list-group-item" style="font-weight: bold;">다음 글이 없습니다.</span>';		
					html += '</div>';
				} else {
					html += '<div class="list-group" style="margin-top: 70px;">';
					html += '<a href="/views/board/view?num=' + next[columnNames.NUM] +'" class="list-group-item list-group-item-action nextNum">';
					html += '<span style="font-weight: bold;">다음 글</span>│';
					html += '<span style="color: blue;" id="nextTitle">'+ next[columnNames.TITLE] +'</span>';
					html += '</a></div>';
				}
				document.querySelector('.next').innerHTML = html;
			})
			
		}
		
		function getPrevPost(){
			fetch('/board/prev/${param.num}',{
				method : 'POST',
				headers : {
					'Content-type' : 'application/json'
				},
				body : sessionStorage.getItem('data')
			})
			.then(function(res){
				return res.json();
			})
			.then(function(prev){
				let html = '';
				if(prev[columnNames.TITLE] == null){
					html += '<div class="list-group" >';
					html += '<span class="list-group-item" style="font-weight: bold;">이전 글이 없습니다.</span>';		
					html += '</div>';
				} else {
					html += '<div class="list-group">';
					html += '<a href="/views/board/view?num=' + prev[columnNames.NUM] +'" class="list-group-item list-group-item-action prevNum">';
					html += '<span style="font-weight: bold;">이전 글</span>│';
					html += '<span style="color: blue;" id="prevTitle">'+ prev[columnNames.TITLE] +'</span>';
					html += '</a></div>';
				}
				document.querySelector('.prev').innerHTML = html;
			}); 
		}
		
		
	</script>
</head>

<header></header>
<body>


	<div class="container">
		<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
		<div class="card">
			<div class="card-body">
				<span class="card-text"> <small class="text-muted boardInfo"
					id="NICKNAME"></small> <!--글쓴이--> <small
					class="text-muted boardInfo" id="ADDR1"></small>
				</span>
				<h5 id="TITLE" class="card-title boardInfo"></h5>
				<!--제목-->
				<span class="card-text"> <small class="text-muted boardInfo"
					id="CATEGORY"></small> <!--카테고리-->
				</span> <span class="card-text"> <small class="text-muted boardInfo"
					id="CNT"></small> <!--조회수-->
				</span>
				<p class="card-text">
					<small class="text-muted">최종 수정일</small> <small
						class="text-muted boardInfo" id="MODDAT"></small>
					<!-- 수정한 날짜-->
				</p>
				<p class="card-text">
					<small class="text-muted">추천</small> <small
						class="text-muted tbRecommend boardInfo" id="RECOMMEND"></small>
					<!--추천 수-->
				</p>
				<p class="card-text boardInfo" id="CONTENT"></p>
				<!--내용-->
			</div>

			<div id="recommendBtn">
				<button class="btn btn-primary" onclick="recommend(this)">추천</button>
				<span id="RECOMMEND"></span>
				<button class="btn btn-primary" onclick="recommend(this)">비추천</button>
			</div>

		</div>
		
		<div>
			<button class="btn btn-primary" onclick="location.href='/views/board/list'" style="margin-top: 10px; float:left;">목록으로 가기</button>
		</div>


		<div id="btn" style="display: none;">
			<button class="btn btn-primary"
				onclick="location.href = '/views/board/update?num=${param.num}'">수정</button>
			<button class="btn btn-primary" data-bs-toggle="modal"
				data-bs-target="#deleteModal">삭제</button>
		</div>

		<!-- Modal -->
		<div class="modal fade" id="deleteModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h1 class="modal-title fs-5" id="exampleModalLabel">알림</h1>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">정말 삭제하시겠습니까?</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary"
							onclick="deleteTestBoard()">삭제</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 댓글리스트 -->
		<div class="card" style="margin-top: 110px;">
			<div class="card-header">댓글 목록</div>
			<ul id="reply-box" class="list-group">

			</ul>
		</div>
		<nav style="font-size: 13px; font-family: sans-serif;"
			aria-label="Page navigation example">
			<ul class="pagination justify-content-center" id="paging">

			</ul>
		</nav>



		<div class="form-group" style="margin-bottom: 70px; margin-top: 20px;">
			<textarea class="form-control" id="comment" rows="3"
				style="resize: none;"></textarea>
			<button type="button" class="btn btn-primary1" id="commentBtn"
				onclick="insertComment()">댓글 작성</button>
		</div>

		<div class='next'></div>
		<div class='prev'></div>


	</div>





</body>
</html>