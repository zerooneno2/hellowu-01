<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.2/sockjs.min.js" integrity="sha512-ayb5R/nKQ3fgNrQdYynCti/n+GD0ybAhd3ACExcYvOR2J1o3HebiAe/P0oZDx5qwB+xkxuKG6Nc0AFTsPT/JDQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>

window.addEventListener('load',()=>{
	
	let socket = new SockJS('/ws/echo');
	socket.onmessage = (e)=>{
		document.getElementById('echoDiv').innerHTML += e.data +'<br>';
	}
	socket.onclose = ()=>{
		document.getElementById('echoDiv').innerText += '연결 종료';
	}
	document.querySelector('button').addEventListener('click',(e)=>{
		e.preventDefault();
		let input = document.getElementById('message');
		socket.send(input.value);
		input.value = '';
		input.focus();
	})
})
</script>
</head>
<body>
<div id="echoDiv"></div>
<input type="text" id="message"><button>전송</button>
</body>
</html>