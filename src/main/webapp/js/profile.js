let uiNickname;
/** 주소 modal toggle */
function toggleAddressModal(obj) {

	document.querySelector('#addressModal').style.display = obj.getAttribute('id') === 'close-area' ? 'none' : 'flex';
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
			//document.querySelector('#uiPwdLabel').style.marginLeft = '10px';
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
			str = '취미는 1자 이상 30자 이하, 한글만 가능합니다.';
			defaultName = '*취미';
			//document.querySelector('#uiHobbyLabel').style.marginLeft = '-30px';
			break;
	}
	const regex = new RegExp(regStr);
	const isRegexOk =  regex.test(obj.value);
	if((val === 'uiNickname' || val === 'uiEmail') && isRegexOk) checkDuplication(obj);
	
	document.querySelector('#' + val + 'Check').style.display = isRegexOk ? '' : 'none';
	document.querySelector('#' + val + 'Xmark').style.display = isRegexOk ? 'none' : '';
	document.querySelector('#'+val+'Label').innerText = isRegexOk? defaultName:str;
	
	
	
}
/** 백엔드에서 닉네임과 이메일을 정규식과 중복여부 검증해서 check표시 아이콘 띄워주는 함수 */
function checkDuplication(obj) {
	const val = obj.getAttribute('data-val');
	
	if(uiNickname === obj.value){ // 자신의 본래 닉네임은 중복 처리X
		document.querySelector('#' + val + 'Check').style.display = '';
		return;
	}
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
		
	})
	
}






function writeTextLabel(){
	document.querySelector('#textLabel').value = document.querySelector('input[type=file]').value;
}