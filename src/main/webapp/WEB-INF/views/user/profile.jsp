<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/common/import.jsp"%>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<!-- services와 clusterer, drawing 라이브러리 불러오기 -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d69974cc147aa21fc45d411516772a47&libraries=services,clusterer,drawing"></script>
<link rel="stylesheet" href="/css/index.css">
<link rel="stylesheet" href="/css/signUp.css">
<link rel="stylesheet" href="/css/kakaoMapSearch.css">
<meta charset="UTF-8">
<title>HELLO友</title>
<script src="/js/profile.js"></script>
<script src="/js/kakaoMap.js"></script>
<style>
label {
	margin-left: -160px;
}

.form-group label {
	text-align: center;
	text-indent: 140px;
}
</style>
<script>
window.addEventListener('load',()=>{
	if(JSON.parse('${empty profileInfo}')) {
		location.replace('/');
	}
}) 
/** 로그아웃 */
function signOut(){
	fetch('/user-info/sign-out')
	.then((response)=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((result)=>{
		if(result){
			location.href='/';
		}
	})
	
}
	


/** 회원가입 폼을 서버에 보내는 함수 */
function modifyUserInfo() { // submit시 백엔드 교차검증 필요
	const fileName = document.querySelector('input[type=file]').value;
	const fileExtension = fileName.substring(fileName.lastIndexOf('.')+1);
	if(fileName.length > 0 && !(fileExtension === 'jpg' || fileExtension === 'png' || fileExtension === 'gif')){
		alert('이미지 확장자는 jpg, png, gif만 가능합니다.');
		return;
	}
	const items = document.querySelectorAll('[data-val]');
	let formData = new FormData();

	for (let item of items) {
		const val = item.getAttribute('data-val');
		if(val === 'uiName' || val === 'uiEmail') continue;
		formData.append(val, item.value);
	}
	formData.append('uiName','${userInfo.uiName}');
	formData.append('uiEmail','${userInfo.uiEmail}');
	if(fileName !== ''){
		formData.append('uiProfileImgFile', document.querySelector('input[type=file]').files[0]);
	}
	

	fetch('/user-info/modify', { // restful하게 안함
		method: 'PUT', 
		body: formData
	})
		.then((response) => {
			if (response.ok) {
				return response.json();
			}
		})
		.then((result) => {
			if (result) {
				alert('수정 완료, 다시 로그인 해주세요');
				signOut();
			} else {
				alert('필수 정보가 다 입력되지 않았거나, 형식에 맞지 않습니다.');
			}
		})
}

function deleteUserInfo(){
	if(!confirm('정말로 회원 탈퇴하시겠습니까?')) return;
	const param = {
			uiNum : '${userInfo.uiNum}',
			uiEmail : '${userInfo.uiEmail}',
			uiPwd : '${userInfo.uiPwd}',
			uiName : '${userInfo.uiName}'
	}
	fetch('/user-info/delete',{ // restful하게 안함
		method : 'DELETE',
		headers : {
			'Content-type' : 'application/json'
		},
		body : JSON.stringify(param)
	})	
	.then((response)=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((result)=>{
		if(result){
			alert('이용해주셔서 감사합니다.');
			location.href='/';
		}
	})
}
</script>
</head>

<body>

	<div class="container-fluid">
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

					</div>
					<div class="form-group" style="margin-bottom: 30px;">
						<label id="uiNameLabel" class="form-control-label">*이름</label> <i
							id="uiNameCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine;"></i> <input
							onkeyup="check(this)" data-val="uiName" type="text"
							class="form-control" value="${profileInfo.uiName}" readonly>
					</div>
					<div class="form-group" style="margin-bottom: 30px;">
						<label id="uiNicknameLabel" class="form-control-label">*닉네임</label>
						<i id="uiNicknameCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine;"></i> <i id="uiNicknameXmark"
							class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onkeyup="check(this)" data-val="uiNickname" value="${profileInfo.uiNickname}" type="text"
							class="form-control">
					</div>
					<div class="form-group" style="margin-bottom: 40px;">
						<label id="uiEmailLabel" class="form-control-label">*이메일</label> <i
							id="uiEmailCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine;"></i> <input
							onkeyup="check(this);" data-val="uiEmail" value="${profileInfo.uiEmail}" type="email"
							class="form-control" readonly>

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

					<div class="form-group" style="margin-bottom: 30px;">
						<label id="uiHobbyLabel" class="form-control-label">*취미</label> <i
							id="uiHobbyCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine;"></i> <i id="uiHobbyXmark"
							class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onkeyup="check(this)" data-val="uiHobby" value="${profileInfo.uiHobby}" type="text"
							class="form-control">
					</div>



					<div class="form-group" style="margin-bottom: 20px;">
						<label id="uiBirthLabel" class="form-control-label">*생일</label> <i
							id="uiBirthCheck" class="fa-solid fa-check"
							style="color: mediumaquamarine;"></i> <i id="uiBirthXmark"
							class="fa-sharp fa-solid fa-xmark"
							style="color: red; display: none;"></i> <input
							onchange="check(this)" data-val="uiBirth" value="${profileInfo.uiBirth}" type="date"
							class="form-control">
					</div>



					<div class="form-group">
						<label class="form-control-label">주소</label> <input
							data-val="uiAddr1" type="text" class="form-control" value="${profileInfo.uiAddr1}" readonly>

						<button onclick="toggleAddressModal(this); openMap();"
							style="margin-left: -17px; width: 100px;"
							class="btn btn-outline-secondary">주소 검색</button>

					</div>

					<div class="form-group">
						<label class="form-control-label">상세 주소</label> <input type="text"
							data-val="uiAddr2" value="${profileInfo.uiAddr2}"class="form-control">
					</div>
					<div class="form-group filebox">
						<c:if test="${not empty profileInfo.uiProfileImgPath}">
							<div class="form-group">
								<img src="${profileInfo.uiProfileImgPath}" width="50px;">
							</div>
						</c:if>
						<label class="form-control-label">프로필 이미지</label> <input
							type="text" id="textLabel" class="form-control" readonly>
						<button
							onclick="document.querySelector('input[type=file]').click()"
							class="btn btn-outline-secondary"
							style="margin-bottom: 30px; margin-right: 40px;">이미지 업로드
						</button>
						<input type="file" onchange="writeTextLabel()"
							style="display: none;" class="form-control">

					</div>

					<div style="margin-bottom: 30px">

						<button onclick="modifyUserInfo()"
							class="btn btn-outline-secondary" style="margin: auto;">수정
						</button>
						<button onclick="deleteUserInfo()"
							class="btn btn-outline-secondary"
							style="margin: 0; margin-left: 20px;">탈퇴</button>

					</div>

				</div>
			</div>

		</div>
	</div>

</body>
</html>