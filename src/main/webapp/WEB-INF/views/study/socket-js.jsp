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

        <div class="container">
            <div class="py-5 text-center">
                <h2>WebSocket</h2>
                <p class="lead">WebSocket Broadcast - with STOMP & SockJS.</p>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <div class="input-group">
                            <input type="text" id="from" class="form-control" placeholder="Choose a nickname"/>
                            <div class="btn-group">
                                <button type="button" id="connect" class="btn btn-sm btn-outline-secondary" onclick="connect()">Connect</button>
                            <button type="button" id="disconnect" class="btn btn-sm btn-outline-secondary" onclick="disconnect()" disabled>Disconnect</button>
                            </div>                        
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="input-group" id="sendmessage" style="display: none;">
                            <input type="text" id="message" class="form-control" placeholder="Message">
                            <div class="input-group-append">
                                <button id="send" class="btn btn-primary" onclick="send()">Send</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div id="content"></div>
                    <div>
                        <span class="float-right">
                            <button id="clear" class="btn btn-primary" onclick="clearBroadcast()" style="display: none;">Clear</button>
                        </span>
                    </div>                    
                </div>
            </div>
        </div>
        <script type="text/javascript">
        
            var stompClient = null; // ?????? ????????? ??????
            
            function setConnected(connected) { // ????????? disabled??? ????????? ??????
           
            	document.querySelector("#from").disabled = connected;
            	document.querySelector("#connect").disabled = connected;
            	document.querySelector("#disconnect").disabled = !connected;
            	document.querySelector("#sendmessage").style.display = connected? 'block':'none';
            	
            }
            
            function connect() {
                var socket = new SockJS('/hello'); // /hello ?????????????????? sockJS ??????????????? ???????????? ?????? ????????? ??????
                console.log('??????');
                console.log(socket);
                stompClient = Stomp.over(socket); // stompClient ????????? socket?????? ??????
                stompClient.connect({}, function () { // ????????? ???????????? ???????????? ????????????
                    stompClient.subscribe('/topic/hello', function (output) { // ????????? ???????????? ???????????? ????????????
                    	
                    	alert(output)
                        showBroadcastMessage(createTextNode(JSON.parse(output.body)));
                    });
                    
                    sendConnection(' connected to server');                
                    setConnected(true); 
                }, function (err) {
                    alert('error' + err);
                });                
            }
 
            function disconnect() {
            	console.log('stomp ???????????????');
            	console.log(stompClient);
                if (stompClient != null) {
                    sendConnection(' disconnected from server'); 
                    
                    stompClient.disconnect(function() { // ?????????????????? ??????????????? ??????????????? ??????
                        console.log('disconnected...');
                        setConnected(false);
                    });                    
                }                
            }
            
            function sendConnection(message) { // ????????? ???????????? ??????
            	clientSend({
            		name: 'server', 
            		message: document.querySelector("#from").value + message
            	});
            }
            
            function clientSend(json) { // send ?????? ?????? ??????, JSON
                stompClient.send("/app/hello", {}, JSON.stringify(json));
            }
            // stompClient.send() ????????? ??????????????? connect() ????????? ???????????? ???????
            function send() { // send -> clientSend -> stompClient.send
            	clientSend({
            		name: document.querySelector("#from").value, 
            		message: document.querySelector("#message").value
            	});

            	document.querySelector("#message").value = "";
            }
 
            function createTextNode(messageObj) { // div?????? ?????? ??????
                return '<div class="row alert alert-info"><div class="col-md-8">' +
                        messageObj.message +
                        '</div><div class="col-md-4 text-right"><small>[<b>' +
                        messageObj.name +
                        '</b> ' +
                        messageObj.time + 
                        ']</small>' +
                        '</div></div>';
            }
            
            function showBroadcastMessage(message) { 
            	// div????????? ?????????(createElement) => messageDiv ???????????? ?????? ??? => messageDiv.innerHTML = message; 
            	// content.appendChild()??? content?????? ?????? ??????
            	const messageDiv = document.createElement("div");
            	messageDiv.innerHTML = message;
            	document.querySelector("#content").appendChild(messageDiv);
            	document.querySelector("#clear").style.display = "block";
            }
            
            function clearBroadcast() { // ?????? ?????? ????????? ??????
            	document.querySelector("#content").innerHTML = "";
            	document.querySelector("#clear").style.display = "none";
            }
        </script>
</body>
</html>