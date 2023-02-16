<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<meta charset="UTF-8">
<title>HELLO友</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/css/view.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<script
	src=" https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>

<style>
.note-color-select {
	visibility: hidden;
}

.note-color-select::before {
	visibility: visible;
	content: '직접선택';
}

.modal-footer {
	display: none !important;
}

.close {
	display: none !important;
}

.note-dimension-picker-mousecatcher {
	background-color: transparent !important;
}

.note-modal {
	background-color: transparent !important;
}
</style>

<script>


const columnNames = JSON.parse(sessionStorage.getItem('data'));
	window.onload = function(){
		/* if(JSON.parse('${empty userInfo}')){
		 	alert('로그인 해주세요');
		 	location.href='/views/board/list';
		 } */
		
		
		
		$('.summernote').summernote({
			height:400,
			minheight:400,
			lang: 'ko-KR',
			focus: true,
			toolbar :[
				['fontname',['fontname']],
				['fontsize',['fontsize']],
				['style',['bold','italic','underline','strikethrough','clear']],
				['color',['forecolor','color']],
				['table',['table']],
				['para',['ul','ol','paragraph']],
				['height',['height']],
				['insert',['picture','link','video']],
				['view',['codeview','fullscreen','help']]
			],
			fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체'],
			fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
			
			callbacks: {	//여기 부분이 이미지를 첨부하는 부분
				onImageUpload : function(files) {
					uploadSummernoteImageFile(files[0],this);
				},
				onPaste: function (e) {
					var clipboardData = e.originalEvent.clipboardData;
					if (clipboardData && clipboardData.items && clipboardData.items.length) {
						var item = clipboardData.items[0];
						if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
							e.preventDefault();
						}
					}
				}
			}

		});
		
		checkRequester();
        
		
	} // end of window.onload
	
		
	
		function uploadSummernoteImageFile(file, editor) {
			data = new FormData();
			data.append("file", file);
			$.ajax({
				data : data,
				type : "POST",
				url : "/board/uploadSummernoteImageFile",
				contentType : false,
				processData : false,
				success : function(data) {
	            	//항상 업로드된 파일의 url이 있어야 한다.
					$(editor).summernote('insertImage', data.url);
				}
			});
		}
		
		$("div.note-editable").on('drop',function(e){
	         for(i=0; i< e.originalEvent.dataTransfer.files.length; i++){
	         	uploadSummernoteImageFile(e.originalEvent.dataTransfer.files[i],$("#summernote")[0]);
	         }
	        e.preventDefault();
	   })
	
		function insertBoard(){
			const valueNames = ['nickname','title','content','category','addr'];
			const param = {};
			for(let valueName of valueNames){
				param[valueName] = document.getElementById(valueName).value;
			}
			
			
			fetch('/board/insert',{
				method:'POST',
				headers : {
					'Content-Type' : 'application/json'
				},
				body : JSON.stringify({
					body : columnNames,
					param : param
				})
			})
			.then(function(res){
				if(res.ok){
					return res.json();
				} else throw new Error('');
			})
			.then(function(data){
				location.href = data === 1? '/views/board/list':'/';
			})
			.catch(function(){
				alert('로그인이 필요합니다.');
			});
		}
	async function checkRequester(){
		const data = JSON.parse(sessionStorage.getItem('data'));
		const tableName = data.TABLENAME;
		const response = await fetch ('/table/check-requester?blRequesterNickname=${userInfo.uiNickname}&blSuffix='+tableName.substring(tableName.lastIndexOf('_')));
		const result = await response.json();
		
		if(result){
			const option = document.createElement('option');
			option.value = '공지사항';
			option.innerText = '공지사항';
			document.getElementById('category').appendChild(option);
		}
	}
		
	</script>
</head>

<body>

	<div class="container mt-3">
		<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
	</div>

	<div class="container mt-3 border d-flex justify-content-center"
		style="padding-top: 30px">
		<table>
			<tr>
				<td>작성자</td>
				<td><input type="text" readonly id="nickname" name="writer"
					value="${userInfo.uiNickname}" style="width: 300px;"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" id="title" name="subject"
					style="width: 300px;"></td>
			</tr>
			<tr>
				<td>지역</td>
				<td><input type="text" readonly id="addr" name="subject"
					value="${userInfo.addr}" style="width: 300px;"></td>
			</tr>
			<tr>
				<td>분류</td>
				<td><select id="category">
						<!-- 아래거 지우고 카테고리 세부 분류 필요, 우선순위 낮으므로 나중에 -->
						<option value="잡담">잡담</option>
						<option value="정보">정보</option>
						<option value="질문">질문</option>
				</select></td>
			</tr>
			<tr>
				<td colspan="2"><textarea class="summernote" id="content"
						name="memo" style="resize: none"></textarea></td>
			</tr>
			<tr>
				<th colspan="2">
					<button class="btn btn-primary" onclick="insertBoard()"
						style="float: right; margin-top: 10px; margin-bottom: 10px">등록</button>
				</th>
			</tr>
		</table>
	</div>




</body>
</html>