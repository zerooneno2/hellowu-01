let isEmailChecked = false; // 프론트단에서 정규식 검증이 check됐는지
let isEmailVerified = false;


/** 이메일로 코드를 보내는 함수 */
function sendEmailVerifyCode(obj) {
	if(!isEmailChecked){
		alert('이메일 형식에 맞지 않거나, 중복된 이메일입니다.');
		return;
	}
	toggleEmailModal(obj); 
	alert('이메일 인증 코드를 전송했습니다.');
	fetch('/mail/send-verify-code', {
		method: 'POST',
		headers: {
			'Content-type': 'application/json'
		},
		body: JSON.stringify({uiEmail : document.querySelector('[data-val=uiEmail]').value})
	})
	.then((response)=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((result)=>{
		if(result){
			let cnt = 180;
			const textWindow = document.querySelector('#checkCode');
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
}
/** 이메일로 받은 코드를 서버에 전송하는 코드 */
function sendEmailCode(){
	const param ={
		ecEmail : document.querySelector('[data-val=uiEmail]').value,
		ecCode : document.querySelector('#checkCode').value,
		ecIssueCode : '0'
	}
	fetch('/mail/request-verify-code',{
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
			alert('이메일 인증이 완료되었습니다.');
			document.querySelector('#emailModal').style.display = 'none';
			isEmailVerified = true;
		} else {
			alert('올바른 코드가 아닙니다.')
		}
	})
}

/** 주소 modal toggle */
function toggleAddressModal(obj) {

	document.querySelector('#addressModal').style.display = obj.getAttribute('id') === 'close-area' ? 'none' : 'flex';
}
/** 이메일 modal toggle */
function toggleEmailModal(obj) {

	document.querySelector('#emailModal').style.display = obj.getAttribute('id') === 'close-area' ? 'none' : 'flex';
}

/** 백엔드에서 닉네임과 이메일을 정규식과 중복여부 검증해서 check표시 아이콘 띄워주는 함수 */
function checkDuplication(obj) {
	const val = obj.getAttribute('data-val');
	
	fetch('/user-info/check-dupl?'+val+'='+document.querySelector('[data-val='+val+']').value)
	.then((response)=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((result)=>{
		// result가 true => 중복되지 않음. false => 중복됨
		document.querySelector('#' + val + 'Check').style.display = result ? '' : 'none';
		document.querySelector('#' + val + 'Xmark').style.display = result ? 'none' : '';
		let str = (val==='uiNickname')? '닉네임':'이메일';
		
		document.querySelector('#'+val+'Label').innerText = !result? '중복된 '+str+'입니다.':val==='uiNickname'? '*닉네임':'*이메일';
		isEmailChecked = result;
	})
	
}

/** 프론트엔드에서 정규식으로 검증해서 check표시 아이콘 띄워주는 함수 */
function check(obj) {
	
	let regStr;
	let defaultName;
	let str; // innerText
	const val = obj.getAttribute('data-val');
	switch (val) {
		case 'uiName' : 
			regStr = '^[가-힣]{2,4}$';
			str = '이름은 2자 이상 4자 이하, 한글만 가능합니다.';
			defaultName = '*이름';
			break;
		case 'uiNickname' :
			regStr = '^[가-힣a-zA-Z]{2,16}$';
			str = '한글, 영어로 이루어진 2~16글자만 가능합니다.';
			defaultName = '*닉네임';
			break;
		case 'uiPwd': 
			regStr = '^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$';
			str = '문자, 숫자, 특수문자가 포함된 8자 이상이어야 합니다.';
			defaultName = '*비밀번호';
			break;
		case 'uiEmail': 
			regStr = '^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$';
			str = '이메일 형식에 맞지 않습니다.';
			defaultName = '*이메일';
			break;
		case 'uiBirth' : 
			regStr = '^[1-2][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$';
			str = '날짜 형식에 맞지 않습니다.';
			defaultName = '*생일';
			break;
		case 'uiHobby' : 
			regStr = '^[가-힣]{1,30}$';
			str = '1~30자 한글만 가능합니다.';
			defaultName = '*취미';
			break;
	}
	const regex = new RegExp(regStr);
	const isRegexOk =  regex.test(obj.value);
	if((val === 'uiNickname' || val === 'uiEmail') && isRegexOk) checkDuplication(obj);

	document.querySelector('#' + val + 'Check').style.display = isRegexOk ? '' : 'none';
	document.querySelector('#' + val + 'Xmark').style.display = isRegexOk ? 'none' : '';
	document.querySelector('#' + val + 'Label').innerText = isRegexOk? defaultName:str;
	
	
	
	
}





function writeTextLabel(){
	document.querySelector('#textLabel').value = document.querySelector('input[type=file]').value;
}