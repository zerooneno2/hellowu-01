<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script>
window.onload = function(){
	document.querySelector('button').addEventListener('click',(e)=>{
		const file1 = document.getElementById('file1');
		if(file1.files.length === 0){ 
			alert('파일을 선택해주세요.');
			return;
		}
		const uploadFile = file1.files[0];
		const formData = new FormData();
		formData.append('file',uploadFile);
		const xhr = new XMLHttpRequest();
		const proDiv = document.getElementById('proDiv');
		
		xhr.open('POST','/file-upload');
		xhr.onreadystatechange = function(){
			if(xhr.readyState === xhr.DONE){
				if(xhr.status === 200){
					alert('전송 완료');
					location.href='/files/'+xhr.responseText;
				} else {
					alert('전송 실패');
				}
			}
		}
		
		xhr.upload.addEventListener('progress',function(e){
			if(proDiv.style.display === 'none'){
				proDiv.style.display = '';
			}
			const per = e.loaded / e.total * 100;
			document.getElementById('pg').value = per;
			document.getElementById('per').innerText = Math.round(per) +'%';
		})
		xhr.send(formData); 
		
		
	}) 
}
</script>
<body>
<input type="file" id="file1">
<button>파일 전송</button>
<div id="proDiv" style="display: none;">
	<progress id="pg" value="0" max="100"></progress>
</div>
<div id="per"></div>
</body>
</html>