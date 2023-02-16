
window.onload = function(){
	consoleText(['Exercise', 'Hobbies', 'Studying','Let\'s share it here'], 'text',['black','black','black','black']);
	const pwdInput = document.getElementById('uiPwd');
	if(pwdInput){
		pwdInput.addEventListener('keypress',(e)=>{
			if(e.keyCode === 13) signIn();
		})
	}
	
	
	let naverLogin = new naver.LoginWithNaverId(
		{
			clientId: "Z6MlqPxJR80jkZ__UcBB",
			callbackUrl: "https://hellowu.co.kr/naver/oauth",
			isPopup: false, /* 팝업을 통한 연동처리 여부 */
			loginButton: {color: "green", type: 1, height: 20}
		}
	);
	naverLogin.init();
}

Kakao.init('d69974cc147aa21fc45d411516772a47');



function loginWithGoogle(){
	if(confirm('테스트 사용자로 등록된 구글 계정만 로그인이 가능합니다.')){
		location.replace('/google');
	}
}
function loginWithNaver(){
	if(confirm('아직 검수되지 않아 테스트 사용자로 등록된 네이버 계정만 로그인이 가능합니다.')){
		const loginBtn = document.getElementById('naverIdLogin').firstChild;
		loginBtn.click();
	}
}

	
function loginWithKakao() {
    Kakao.Auth.authorize({
      redirectUri: 'https://hellowu.co.kr/kakao/oauth',
    });
  }

  // 아래는 데모를 위한 UI 코드입니다.
  displayToken()
  function displayToken() {
    var token = getCookie('authorize-access-token');

    if(token) {
      Kakao.Auth.setAccessToken(token);
      Kakao.Auth.getStatusInfo()
        .then(function(res) {
          if (res.status === 'connected') {
            document.getElementById('token-result').innerText
              = 'login success, token: ' + Kakao.Auth.getAccessToken();
          }
        })
        .catch(function(err) {
          Kakao.Auth.setAccessToken(null);
        });
    }
  }

  function getCookie(name) {
    var parts = document.cookie.split(name + '=');
    if (parts.length === 2) { return parts[1].split(';')[0]; }
  }




/** 인덱스 메세지 */
function consoleText(words, id, colors) {
 if (colors === undefined) colors = ['#fff'];
 let visible = true;
 let con = document.getElementById('console');
 let letterCount = 1;
 let x = 1;
 let waiting = false;
 let target = document.getElementById(id)
 target.setAttribute('style', 'color:' + colors[0])
 window.setInterval(function() {

   if (letterCount === 0 && waiting === false) {
     waiting = true;
     target.innerHTML = words[0].substring(0, letterCount)
     window.setTimeout(function() {
       let usedColor = colors.shift();
       colors.push(usedColor);
       let usedWord = words.shift();
       words.push(usedWord);
       x = 1;
       target.setAttribute('style', 'color:' + colors[0])
       letterCount += x;
       waiting = false;
     }, 1000)
   } else if (letterCount === words[0].length + 1 && waiting === false) {
     waiting = true;
     window.setTimeout(function() {
       x = -1;
       letterCount += x;
       waiting = false;
     }, 1000)
   } else if (waiting === false) {
     target.innerHTML = words[0].substring(0, letterCount)
     letterCount += x;
   }
 }, 120)
 window.setInterval(function() {
   if (visible === true) {
     con.className = 'console-underscore hidden'
     visible = false;

   } else {
     con.className = 'console-underscore'

     visible = true;
   }
 }, 400)
}

/** 로그인 */
function signIn(){
	const param = { 
			uiEmail : document.querySelector('#uiEmail').value,
			uiPwd : document.querySelector('#uiPwd').value
	} 
	fetch('/user-info/sign-in',{
		method: 'POST',
		headers : {
			'Content-type' : 'application/json'
		},
		body : JSON.stringify(param) 
	})
	.then((response)=>{
		if(response.ok){ 
			return response.json();
		} else {
			throw new Error('');
		}
	})
	.then((result)=>{ 
		console.log(result);
		if(result){ 
			location.href='/';
		}
	})
	.catch(()=>{
		alert('이메일 또는 비밀번호가 틀렸습니다.');
		document.querySelector('#pwdLabel').innerText = '비밀번호를 분실하셨나요?';
		//document.querySelector('#pwdLabel').style.marginLeft = '95px';
		document.querySelector('#pwdLabel').style.marginLeft = '40px';
		document.querySelector('#pwdLabel').style.marginRight = 'auto';
		document.querySelector('#pwdLabel').style.float = 'left';
		document.querySelector('[class*=fa-key]').style.display = '';
	
		
	})
}


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
			alert('로그아웃 완료');
			location.href='/';
		}
	})
	
}

/** 비밀번호 분실 modal toggle */
function toggleEmailModal(obj) {
	document.querySelector('#emailModal').style.display = obj.getAttribute('id') === 'close-area' ? 'none' : 'flex';
}

/** 비밀번호 찾기 first-step 이메일이 존재하는지 검증하고 코드를 보내는 함수 */
function findPwd(){
	const email = document.querySelector('#findPwdByEmail').value;
	fetch('/user-info/check-email-exist?uiEmail='+email)
	.then((response)=>{
		if(response.ok){
			return response.json(); // 이부분 리턴하지말고 바로 fetch로 수정
		} 
	})
	.then((result)=>{
		if(result){
			//console.log(result); // 이메일, 이름(or닉네임) 외에는 필요한 정보 없음, 보내기 위한 메일정보, 제목에 쓸 아이디(or닉네임)
			alert('이메일로 코드를 전송하였습니다.');
			document.querySelector('#codeBtn').style.display = '';
			document.querySelector('#findPwdBtn').style.display = 'none';
			document.querySelector('#inputEmailCode').style.display = '';
			document.querySelector('#findPwdByEmail').style.display = 'none';
			fetch('/mail/send-pwd-code',{
				method: 'POST',
				headers : {
					'Content-type' : 'application/json'
				},
				body : JSON.stringify(result)
			})
			.then((response)=>{
				if(response.ok){
					return response.json();
				}
			})
			.then((result)=>{
				 if(result){
				 let cnt = 180;
				 const textWindow = document.querySelector('#inputEmailCode');
				 let limitTime = setInterval(()=> {
					 cnt--;
					 let minute = Math.floor(cnt/60);
					 let second = cnt % 60;
					 textWindow.setAttribute('placeholder',minute+'분 '+second+'초');
					 if(cnt == 0) {
						 textWindow.setAttribute('placeholder','시간 초과. 다시 시도해주세요.');
						 clearInterval(limitTime);
					 }
				 },1000);
			
		} else {
			textWindow.setAttribute('placeholder','코드 전송에 실패했습니다.');
		}
			})
		} else {
			alert('해당 이메일로 가입한 회원은 존재하지 않습니다.');
		}
	})
	
	
}
/** 비밀번호 찾기 second-step 이메일로 보낸 코드와 서버에 저장된 코드가 일치하는지 검증하는 함수 */
function sendEmailCode(){
	const param ={
		ecEmail : document.querySelector('#findPwdByEmail').value,
		ecCode : document.querySelector('#inputEmailCode').value,
		ecIssueCode : '1'
	}
	fetch('/mail/request-pwd-code',{
		method: 'POST',
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
			document.querySelector('#inputChangePwd').style.display = '';
			document.querySelector('#codeBtn').style.display = 'none';
			document.querySelector('#changePwdBtn').style.display = '';
			document.querySelector('#inputEmailCode').style.display = 'none';
		} else {
			alert('올바른 코드가 아닙니다.')
		}
	})
}

/** 비밀번호 찾기 third-step 비밀번호를 변경하는 함수=> 백엔드에서도 검증 */
function changePwd(){
	const param = {
		ecEmail : document.querySelector('#findPwdByEmail').value,
		ecCode : document.querySelector('#inputEmailCode').value,
		ecIssueCode : '1',
	};
	fetch('/user-info/change-pwd/'+document.querySelector('#inputChangePwd').value,{
		method : 'PATCH',
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
			alert('비밀번호 변경이 완료되었습니다.');
			location.href='/';
		} else {
			alert('문자, 숫자, 특수문자가 포함된 8자 이상이어야 합니다.');
		}
	})
	
}

