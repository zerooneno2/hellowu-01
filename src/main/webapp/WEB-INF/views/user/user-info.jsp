<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<%@ include file="/WEB-INF/views/common/import.jsp"%>
<meta charset="UTF-8">
<title>HELLO友</title>
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.1.0/kakao.min.js"
	integrity="sha384-dpu02ieKC6NUeKFoGMOKz6102CLEWi9+5RQjWSV0ikYSFFd8M3Wp2reIcquJOemx"
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/index.css">
<script src="/js/index.js"></script>

</head>
<body>

	<div class="container">

		<div class="row">

			<div class="col-lg-3 col-md-2 col-sm-2 col-2"></div>
			<div class="col-lg-6 col-md-9 col-sm-12 col-12 login-box">
				<div class='console-container'>

					<span id='text'></span>
					<div class='console-underscore' id='console'>&#95;</div>
				</div>
				<div class="col-lg-12 login-key"></div>
				<div class="col-lg-12 login-title">

					<!-- 메인화면창 활용 기초 유저정보 페이지 생성, 이후 디자인 디테일 작업 예정 -->
					<div style="margin-left: -50px;">
						<img src="/resources/images/logo.png" width="300px;"><br>

						<div class="userInfoCheck">
							<table style="font-size: 20px; color: gray; margin-left: 110px;">
								<tr>

									<th>'${userInfo.uiNickname}'님의 회원정보입니다.<br></th>
								</tr>
								<tr>
									<th>닉네임 : ${userInfo.uiNickname}<br></th>
								</tr>
								<tr>
									<th>가입일자 : ${userInfo.uiCredat}<br></th>
								</tr>
								<tr>
									<th>회원 이미지 : ${userInfo.uiProfileImgPath}<br></th>
								</tr>

								<!-- 팔로우 작업 -->
								<th><button class="" onclick="">Follow</button></th>

								</tr>
							</table>
						</div>


					</div>

				</div>


			</div>

		</div>

	</div>

	</div>


</body>
</html>