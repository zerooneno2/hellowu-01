<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<meta charset="UTF-8">
<title>HELLO友</title>
<%@ include file="/WEB-INF/views/common/import.jsp"%>

<!-- services와 clusterer, drawing 라이브러리 불러오기 -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d69974cc147aa21fc45d411516772a47&libraries=services,clusterer,drawing"></script>
<link rel="stylesheet" href="/css/index.css">
<link rel="stylesheet" href="/css/signUp.css">
<link rel="stylesheet" href="/css/kakaoMapSearch.css">
<script src="/js/kakaoMap.js"></script>
<script src="/js/signUp.js"></script>
<style>
label {
	margin-left: -160px;
}
</style>
<script>
window.addEventListener('load',()=>{
	
	if('${socialLoginEmail}'){
		const emailInput = document.querySelector('[data-val=uiEmail]');
		emailInput.value = '${socialLoginEmail}';
		emailInput.readOnly = true;
		document.querySelector('[onclick*=sendEmailVerifyCode]').style.display ='none';
		document.getElementById('uiEmailCheck').style.display = '';
		isEmailVerified = true;
	} 
})
/** 회원가입 폼을 서버에 보내는 함수 */
function signUp() { // submit시 백엔드 교차검증 필요
	const fileName = document.querySelector('input[type=file]').value;
	const fileExtension = fileName.substring(fileName.lastIndexOf('.')+1);
	if(!isEmailVerified){
		alert('이메일 인증이 필요합니다.');
		return;
	} else if(fileName.length > 0 && !(fileExtension === 'jpg' || fileExtension === 'png' || fileExtension === 'gif')){
		alert('이미지 확장자는 jpg, png, gif만 가능합니다.');
		return;
	}
	
	const items = document.querySelectorAll('[data-val]')
	let formData = new FormData();

	for (let item of items) {
		formData.append(item.getAttribute('data-val'), item.value);
	}
	if(fileName !== ''){
		formData.append('uiProfileImgFile', document.querySelector('input[type=file]').files[0]);
	}
	const socialLoginId = {
			uiKakaoId(id){
				formData.append('uiKakaoId',id);
			},
			uiNaverId(id){
				formData.append('uiNaverId',id);
			},
			uiGoogleId(id){
				formData.append('uiGoogleId',id)
			}
	}
	socialLoginId['${socialLoginValue}']('${socialLoginId}');
	/* formData.append('uiKakaoId','${uiKakaoId}');
	formData.append('uiNaverId','${uiNaverId}');
	formData.append('uiGoogleId','${uiGoogleId}'); */
	const url = '${socialLoginEmail}'? '/user-info/sign-up/DONE' : '/user-info/sign-up/'+document.querySelector('#checkCode').value;
	fetch(url, {
		method: 'POST',
		body: formData
	})
		.then((response) => {
			if (response.ok) {
				return response.json();
			}
		})
		.then((result) => {
			if (result) {
				alert('가입 완료');
				location.href='/';
			} else {
				alert('필수 정보가 다 입력되지 않았거나, 형식에 맞지 않습니다.');
			}
		})
}
</script>


</head>

<body>

	<div class="container">
		<div class="row">
			<div class="col-lg-3 col-md-2"></div>
			<div class="col-lg-6 col-md-8 login-box">
				<div class="col-lg-12 login-key"></div>
				<div class="col-lg-12 login-form" style="margin-top: -100px">
					<div class="col-lg-12 login-form">
						<!-- 주소 모달창 -->
						<div id="addressModal" class="modal-overlay">
							<div class="modal-window">
								<div id="close-area" onclick="toggleAddressModal(this)">X</div>
								<div class="map_wrap">
									<div id="map"
										style="width: 100%; height: 460px; position: relative; overflow: hidden;"></div>

									<div id="menu_wrap" class="bg_white">
										<div class="option">
											<div>
												<form onsubmit="searchPlaces(); return false;">
													키워드 : <input type="text" placeholder="주소를 입력하세요"
														id="keyword" size="15">
													<button class="btn btn-outline-secondary">검색하기</button>
												</form>
											</div>
										</div>
										<hr>
										<ul id="placesList"></ul>
										<div id="pagination"></div>
									</div>
								</div>
							</div>
							<div class="form-group"></div>
						</div>
						<!-- 이메일 코드 모달창 -->
						<div id="emailModal" class="modal-overlay">
							<div class="modal-window">
								<div id="close-area" onclick="toggleEmailModal(this)">X</div>
								<label class="form-control-label"
									style="font-weight: bold; margin: auto; font-size: 15px; margin-left: 40px; color: lightyellow;">전송된
									코드 입력</label> <input placeholder="" id="checkCode" type="text"
									class="form-control"
									style="margin: auto; margin-top: 15px; margin-bottom: 10px">
								<button id="changePwdBtn" onclick="sendEmailCode()"
									class="btn btn-outline-secondary" style="width: 100px; color:black;">코드
									입력</button>
							</div>
							<div class="form-group"></div>
						</div>
					</div>
					<div class="form-group" style="margin-bottom: 40px;">
						<label id="uiNameLabel" class="form-control-label">*이름</label> <i
							id="uiNameCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine; display: none;"></i> <i
							id="uiNameXmark" class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onkeyup="check(this)" data-val="uiName" type="text"
							class="form-control">
					</div>
					<div class="form-group" style="margin-bottom: 40px;">
						<label id="uiNicknameLabel" class="form-control-label">*닉네임</label>
						<i id="uiNicknameCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine; display: none;"></i> <i
							id="uiNicknameXmark" class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onkeyup="check(this)" data-val="uiNickname" type="text"
							class="form-control">
					</div>
					<div class="form-group">
						<label id="uiEmailLabel" class="form-control-label">*이메일</label> <i
							id="uiEmailCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine; display: none;"></i> <i
							id="uiEmailXmark" class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onkeyup="check(this);" data-val="uiEmail" type="email"
							class="form-control">
						<button onclick="sendEmailVerifyCode(this);"
							style="margin-left: -17px; width: 100px;"
							class="btn btn-outline-secondary">이메일 확인</button>
					</div>
					<div class="form-group" style="margin-bottom: 40px;">
						<label id="uiPwdLabel" class="form-control-label">*비밀번호</label> <i
							id="uiPwdCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine; display: none;"></i> <i
							id="uiPwdXmark" class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onkeyup="check(this)" data-val="uiPwd" type="password"
							class="form-control">
					</div>

					<div class="form-group" style="margin-bottom: 40px;">
						<label id="uiHobbyLabel" class="form-control-label">*취미</label> <i
							id="uiHobbyCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine; display: none;"></i> <i
							id="uiHobbyXmark" class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onkeyup="check(this)" data-val="uiHobby" type="text"
							class="form-control">
					</div>


					<div class="form-group">
						<label id="uiBirthLabel" class="form-control-label">*생일</label> <i
							id="uiBirthCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine; display: none;"></i> <i
							id="uiBirthXmark" class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onchange="check(this)" data-val="uiBirth" type="date"
							class="form-control">
					</div>


					<div class="form-group">
						<label class="form-control-label">주소</label> <input
							data-val="uiAddr1" type="text" class="form-control" readonly>

						<button onclick="toggleAddressModal(this); openMap();"
							style="margin-left: -17px; width: 100px;"
							class="btn btn-outline-secondary">주소 검색</button>

					</div>

					<div class="form-group">
						<label id="detailaddr" class="form-control-label">상세 주소</label> <input
							type="text" data-val="uiAddr2" class="form-control">
					</div>

					<div class="form-group filebox">
						<label class="form-control-label">프로필 이미지</label> <input
							type="text" id="textLabel" class="form-control" readonly>
						<button
							onclick="document.querySelector('input[type=file]').click()"
							class="btn btn-outline-secondary"
							style="margin-bottom: 30px; margin-right: 40px;">이미지 업로드</button>
						<input type="file" onchange="writeTextLabel()"
							style="display: none;" class="form-control">

					</div>

					<div>
						<button onclick="signUp()" class="btn btn-outline-secondary"
							style="margin-bottom: 30px; margin-right: 13px;">가입</button>
					</div>

				</div>
			</div>

		</div>
	</div>

</body>
</html>