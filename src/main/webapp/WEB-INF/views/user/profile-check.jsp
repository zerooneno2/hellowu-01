<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/import.jsp"%>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<meta charset="UTF-8">
<title>HELLO友</title>
<link rel="stylesheet" href="/css/index.css">
<script>
window.onload = function(){
	document.querySelector('#uiPwd').addEventListener('keypress',(e)=>{
		if(e.keyCode === 13) checkPwd();
	})
}

function checkPwd(){
	if(JSON.parse('${not empty userInfo}')){
		location.href='/user-info/profile/check?uiEmail=${userInfo.uiEmail}&uiPwd='+document.getElementById('uiPwd').value;	
	} else {
		alert('로그인이 필요합니다.');
	}
	
}

</script>
</head>
<body>
	<div class="container">

		<div class="row">

			<div class="col-lg-3 col-md-2 col-sm-2"></div>
			<div class="col-lg-6 col-md-8 col-sm-10 login-box">

				<div class="col-lg-12 login-key"></div>
				<div style="margin: -50px 0 0 -50px;">
					<img src="/resources/images/logo.png" width="300px;">
				</div>
				<div class="col-lg-12 login-title">
					<span style="color: black; font-family: Amatic-bold;">Please
						enter your password</span>
				</div>

				<div class="col-lg-12 col-md-12 col-sm-12 login-form"
					style="margin-top: -20px;">
					<div class="col-lg-12 col-md-12 col-sm-12 login-form">


						<div class="form-group" style="position: relative;">
							<label class="form-control-label" style="margin-left: -10px;">비밀번호</label>
							<input id="uiPwd" type="password" class="form-control"
								style="width: 270px; margin-left: 30px;"">
							<button onclick="checkPwd()"
								style="color: #404040; position: absolute; margin: -15px 0 0 -43px;"
								class="btn btn-outline-secondary">확인</button>
						</div>

						<div class="form-group" style="margin-top: 50px;">
							<!-- 간격 조정 div -->
						</div>


					</div>
				</div>
			</div>

		</div>

	</div>
</body>
</html>