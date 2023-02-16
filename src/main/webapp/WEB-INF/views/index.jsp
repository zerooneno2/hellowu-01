<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/import.jsp"%>
<meta charset="UTF-8">
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<!-- 반응형 옵션  -->
<meta name="viewport" content=width=device-width user-scalable=yes,
	initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">

<title>HELLO友</title>

<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>
<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.1.0/kakao.min.js"
	integrity="sha384-dpu02ieKC6NUeKFoGMOKz6102CLEWi9+5RQjWSV0ikYSFFd8M3Wp2reIcquJOemx"
	crossorigin="anonymous"></script>


<script src="/js/index.js"></script>
<link rel="stylesheet" href="/css/index.css">
<link rel="stylesheet" href="/css/font-widona.css">

<svg xmlns="http://www.w3.org/2000/svg" version="1.1" class="goo">
  <defs>
    <filter id="goo">
      <feGaussianBlur in="SourceGraphic" stdDeviation="10" result="blur" />
      <feColorMatrix in="blur" mode="matrix"
		values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 19 -9" result="goo" />
      <feComposite in="SourceGraphic" in2="goo" />
    </filter>
  </defs>
</svg>

<style>
/* 다른 화면 크기에 대한 기본 스타일 정의 */
/* 모든 화면에 대한 기본 스타일 */
body {
	font-size: 16px;
}

/* 작은 화면 (예: 스마트폰)을 위한 미디어 쿼리 */
@media only screen and (max-width: 600px) {
	body {
		font-size: 14px;
	}
}

/* 중간 크기 화면 (예: 태블릿)을 위한 미디어 쿼리 */
@media only screen and (min-width: 600px) and (max-width: 1024px) {
	body {
		font-size: 18px;
	}
}

/* 큰 화면 (예: 랩탑, 데스크탑)을 위한 미디어 쿼리 */
@media only screen and (min-width: 1024px) {
	body {
		font-size: 22px;
	}
}

/* 비밀번호찾기-열쇠 아이콘 설정 */
.fa-solid {
	color: black; /* 예비색상 : #f3d7d7; */
	float: left;
	margin-left: 10px;
	margin-right: 80px;
	margin-top: 0px;
}
</style>

</head>

<body>

	<div class="container">

		<div class="row">

			<div class="col-lg-3 col-md-2 col-sm-2 col-2"></div>
			<div class="col-lg-6 col-md-9 col-sm-12 col-12 login-box">
				<div class='console-container' style="padding-top: 30px;">

					<span id='text'></span>
					<div class='console-underscore' id='console'>&#95;</div>
				</div>
				<div class="col-lg-12 login-key"></div>
				<div class="col-lg-12 login-title">

					<!-- 로그인이 안되어있다면 보여줄 이미지or텍스트 구상 바랍니다 -->
					<div style="margin-left: -30px;">
						<img src="/resources/images/logo.png" width="200px;">
					</div>

				</div>
				<!-- 이메일 코드 모달창 -->
				<div id="emailModal" class="modal-overlay">
					<div class="modal-window">
						<div id="close-area" onclick="toggleEmailModal(this)">X</div>
						<label class="form-control-label"
							style="font-weight: bold; font-size: 15px; color: lightyellow;"></label>
						<input placeholder="이메일을 입력하세요" id="findPwdByEmail" type="text"
							class="form-control"> <input placeholder=""
							id="inputEmailCode"
							style="display: none; margin: auto; margin-bottom: 20px;"
							type="text" class="form-control"> <input
							placeholder="변경할 비밀번호를 입력하세요" id="inputChangePwd"
							style="display: none;" type="password" class="form-control">
						<button onclick="findPwd()" id="findPwdBtn"
							class="btn btn-outline-secondary">비밀번호 찾기</button>
						<button style="display: none; width: 100px;" id="codeBtn"
							onclick="sendEmailCode()" class="btn btn-outline-secondary">코드
							입력</button>
						<button style="display: none;" id="changePwdBtn"
							onclick="changePwd()" class="btn btn-outline-secondary">비밀번호
							변경</button>

					</div>

				</div>
				<div class="col-lg-12 col-md-12 col-sm-12 col-12 login-form"
					style="margin-top: -20px;">
					<div class="col-lg-12 col-md-12 col-sm-12 col-12 login-form">





						<c:choose>
							<c:when test="${empty userInfo}">
								<div class="form-group">
								
									<div style="margin:auto; width:60%; display:flex; " id="emailLabel">
										<label class="form-control-label" style="margin:40px 0 0 -30px;">이메일</label> 
											<img id="naverLoginLabel" onclick="loginWithNaver();" src="/resources/images/naver_simple.png" alt="네이버 로그인"
											style="margin: 33px 0 0 5px; width:14%; height:14%; cursor: pointer;" />
											<img src="/resources/images/kakao_simple.png" onclick="loginWithKakao();" alt="카카오 로그인"
											style="margin-top:30px; width:16%; height:16%; cursor: pointer;" />
											<img onclick="loginWithGoogle();" src="/resources/images/google_simple.png" alt="구글 로그인"
											style="margin-top:33px; width:14%; height:14%; cursor: pointer;" />
											<div id="naverIdLogin" style="display: none;"></div>
											
										
									</div>
									<input id="uiEmail" type="text" class="form-control">

								</div>

								<div class="form-group">
									<label style="margin-bottom: 4px;" id="pwdLabel"
										class="form-control-label">비밀번호</label> <i
										onclick="toggleEmailModal(this)"
										style="cursor: pointer; display: none;"
										class="fa-sharp fa-solid fa-key"></i> <input id="uiPwd"
										type="password" class="form-control">
								</div>
							</c:when>
							<c:otherwise>
								<div class="form-group" style="margin-top: 50px;">
									<!-- 간격 조정 div -->
								</div>
							</c:otherwise>
						</c:choose>


						<div class="btnoption">

							<c:choose>
								<c:when test="${not empty userInfo}">
									<button onclick="signOut()" class="btn btn-outline-secondary">로그아웃</button>
								</c:when>
								<c:otherwise>
									<button onclick="signIn()" class="btn btn-outline-secondary">로그인</button>
								</c:otherwise>
							</c:choose>

							<button onclick="location.href='/views/main'"
								class="btn btn-outline-secondary">메인</button>


							<c:choose>
								<c:when test="${not empty userInfo}">
									<button onclick="location.href='/views/user/profile-check'"
										class="btn btn-outline-secondary">프로필</button>
								</c:when>
								<c:otherwise>

									<button onclick="location.href='/views/user/sign-up'"
										class="btn btn-outline-secondary">가입</button>

								</c:otherwise>
							</c:choose>


						</div>



					</div>
				</div>
			</div>

		</div>

	</div>


</body>

</html>