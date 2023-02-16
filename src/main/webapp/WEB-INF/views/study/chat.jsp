<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.2/sockjs.min.js" integrity="sha512-ayb5R/nKQ3fgNrQdYynCti/n+GD0ybAhd3ACExcYvOR2J1o3HebiAe/P0oZDx5qwB+xkxuKG6Nc0AFTsPT/JDQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js" integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>
<body>
<input type="text" id="name"><br>
<button onclick="connection();">연결</button>
<div id="chatDiv" style="display:none;">
<textarea id="chatContent" style="resize: none;"rows="20" cols="40"></textarea>
<input type="text" id="msg"><button onclick="sendMessage();">전송</button>
</div>
<button onclick="disconnect();">연결 해제</button>

<script>

let stompClient;
function connection(){
	let socket = new SockJS('/ws/chat');
	stompClient = Stomp.over(socket);
	stompClient.connect({}, evt=>{
		document.getElementById('chatDiv').style.display = '';
		console.log('evt')
		console.log(evt);
		stompClient.subscribe('/topic/message',data=>{
			alert(data);
			const msg = JSON.parse(data.body);
			document.getElementById('chatContent').value += '\r\n[' + msg.sender + ']:' + msg.msg; 
			console.log(msg);
		})
		const param = {
			sender : document.getElementById('name').value,
			msg : document.getElementById('name').value + '님 입장'
		}
		stompClient.send('/app/message',{},JSON.stringify(param));
		
	}, error=>{
		alert(error);
	})
}
function disconnect(){
	stompClient.disconnect(function() { 
        console.log('disconnected');
        
    }); 
}

function sendMessage(){

	const param = {
		sender : document.getElementById('name').value,
		msg : document.getElementById('msg').value
	}
	stompClient.send('/app/message',{},JSON.stringify(param));
}
</script>
</body>
</html>