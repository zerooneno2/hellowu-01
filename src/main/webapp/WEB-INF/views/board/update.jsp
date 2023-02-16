<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">

<meta charset="UTF-8">
<title>HELLO友</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
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


</head>
<script>
const valueNames = ['NICKNAME','TITLE','CONTENT','CATEGORY','ADDR1'];
const columnNames = JSON.parse(sessionStorage.getItem('data'));
	window.onload = function(){
		getView();
		getSummernote();
	}

		function getSummernote(){
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
		}
		
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
		
		
		function updateBoard(){
			
			const param = {};
			for(let valueName of valueNames){
				param[valueName.toLowerCase()] = document.getElementById(valueName).value;
			}
			param.num = '${param.num}';
			
			fetch('/board/update',{
				method:'PATCH',
				headers:{
					'Content-Type' : 'application/json'
				},
				body:JSON.stringify({
					body : columnNames,
					param : param
				})
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data){
					location.href = data === 1? '/views/board/view?num=${param.num}':'/';
				}
			});
		}
		function getView(){
			
			fetch('/board/view/${param.num}',{
				method : 'POST',
				headers : {
					'Content-Type' : 'application/json'
				},
				body : sessionStorage.getItem('data')
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				/* console.log(data); */
				
				for(let valueName of valueNames){
					if(valueName === 'CONTENT'){
						$('.summernote').summernote('pasteHTML', data[columnNames[valueName]]);
						continue;
					}
					document.getElementById(valueName).value = data[columnNames[valueName]]; 
				}
				if('${userInfo.uiNickname}' !== data[columnNames.NICKNAME]){
				   alert('올바르지 못한 접근입니다');
				   location.href='/views/board/list';
			   	}
			});
		}
		
		
		
	</script>
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

<body>

	<div class="container mt-3">
		<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
	</div>

	<div class="container mt-3 border d-flex justify-content-center"
		style="padding-top: 30px">
		<table>
			<tr>
				<td>작성자</td>
				<td><input type="text" readonly id="NICKNAME" name="writer"
					style="width: 300px;"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" id="TITLE" name="subject"
					style="width: 300px;"></td>
			</tr>
			<tr>
				<td>지역</td>
				<td><input type="text" readonly id="ADDR1" name="subject"
					style="width: 300px;"></td>
			</tr>
			<tr>
				<td>분류</td>
				<td><select id="CATEGORY">
						<option value="잡담">잡담</option>
						<option value="정보">정보</option>
						<option value="질문">질문</option>
						<option value="공지사항">공지사항</option>
				</select></td>
			</tr>
			<tr>
				<td colspan="2"><textarea class="summernote" id="CONTENT"
						name="memo" style="resize: none"></textarea></td>
			</tr>
			<tr>
				<th colspan="2">
					<button class="btn btn-primary" onclick="updateBoard()"
						style="float: right; margin-top: 10px; margin-bottom: 10px">등록</button>
				</th>
			</tr>
		</table>
	</div>



</body>
</html>