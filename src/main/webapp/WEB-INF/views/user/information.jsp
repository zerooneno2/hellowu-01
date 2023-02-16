<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<script src="/js/information.js"></script>
<script src="/js/follow.js"></script>
<meta charset="UTF-8">
<title>HELLO友</title>
<link rel="stylesheet" href="/css/tableform.css">

<script>
window.addEventListener('load',()=>{
	followChecker();
})

async function followChecker(){

	if(JSON.parse('${empty userInfo}')){		
		document.querySelector('button[onclick*=follow]').innerText = '팔로우';
		return;
	}
	const myUiNum = parseInt('${userInfo.uiNum}');
	const response = await fetch('/follow/check?uiFollowerNum='+myUiNum+'&uiFollowingNum='+userInfo.uiNum);
	const result = await response.json();
	const value = result? '언팔로우':'팔로우';
	document.querySelector('button[onclick*=follow]').innerText = value;
}

function getUserProfile(){ 
	
	const items = document.querySelectorAll('[id*=ui]');
	for(let item of items){

		if(item.getAttribute('id') === 'uiProfileImgPath'){
			item.setAttribute('src', userInfo[item.getAttribute('id')]);
			continue;
		}
		
		if(item.getAttribute('id') === 'uiaddr'){
			if(userInfo.addr){
				item.value = userInfo.addr;
				/* console.log(userInfo.uiAddr1.length); */
			}
			continue;
		}
		if(userInfo.uiNickname != '${userInfo.uiNickname}') {
			/* console.log(uiNickname); */
		document.querySelector('#btnDiv').style.display = '';
		}
		item.value = userInfo[item.getAttribute('id')];
	}
}

function follow(obj){
	const url = obj.innerText === '언팔로우'? '/follow/delete':'/follow/insert';
	const param = {
			uiFollowerNum : parseInt('${userInfo.uiNum}'),
			uiFollowingNum : userInfo.uiNum
	};
	/* console.log(param) */
	fetch(url,{
		method:'POST',
		headers:{
			'Content-Type': 'application/json'
		},
		body: JSON.stringify(param)
	})
	.then(function(res){
		if(res.ok){
			return res.json();
		}
	})
	.then(function(data){
		if(data){
			if(obj.innerText === '팔로우'){
				socket.send('FOLLOW&${userInfo.uiNickname}&'+userInfo.uiNickname);
			}
			alert(obj.innerText+' 완료');
			location.reload();
		} else {
			alert('로그인 해주세요.');
			location.href= '/';
		}
	});
}
</script>

</head>

<body>

	<main class="flex-shrink-0 p-3 col-lg-12 col-md-12 col-sm-12 col-12">
		<div class="container mt-3">
			<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

			<div class="container border" style="margin-top: 20px">
				프로필 사진<br> <img id="uiProfileImgPath" src=""
					style="width: 100px; height: 100px;">


				<div class="mb-3" style="width: 50%">
					<label for="exampleFormControlInput1" class="form-label">닉네임</label>
					<input type="text" readonly class="form-control userInfo"
						id="uiNickname">
				</div>

				<div class="mb-3" style="width: 50%">
					<label for="exampleFormControlInput1" class="form-label">주소</label>
					<input type="text" readonly class="form-control userInfo"
						id="uiaddr">
				</div>

				<div class="mb-3" style="width: 50%">
					<label for="exampleFormControlInput1" class="form-label">취미</label>
					<input type="text" readonly class="form-control userInfo"
						id="uiHobby">
				</div>


				<div class="buttonGroup">

					<div id="btnDiv"
						style="display: none; float: right; margin-top: 10px">
						<button type="button" class="btn btn-primary"
							onclick="follow(this)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</button>
					</div>

					<div style="float: left; margin-top: 10px">
						<button class="btn btn-primary" type="button"
							data-bs-toggle="collapse" data-bs-target="#containerCollapse"
							aria-expanded="false" aria-controls="containerCollapse">작성글
							보기</button>
					</div>
				</div>

			</div>

			<div class="container border collapse" id="containerCollapse"
				style="background-color: gray; margin-top: 58px; padding-bottom: 10px; padding-top: 10px; color: white;">
				<div id="myPost"></div>
			</div>

		</div>
	</main>

</body>
</html>