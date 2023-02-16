<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<link rel="stylesheet" href="/css/footer.css">
    

<script>

window.addEventListener('load',()=>{
	const members = ['최강호','안성민','이원영','정지훈'];
	members.sort(()=> Math.random() - 0.5);
	document.getElementById('고생하셨습니다').innerText = members.join(',');
})
</script>
<footer id="footer">
	<div id="text-box">
	<nav>
		<span>Project Member </span> |
		<span id="고생하셨습니다"></span>
	</nav>
	
		<span>Project Name : hellowu</span><br>
		<span>Project Duration : 2023.01.12~2023.02.09</span><br>
		<span>Introduction : 커뮤니티 사이트</span><br>
		<span>contact us : 02-1234-5678</span>
	</div>
</footer>
