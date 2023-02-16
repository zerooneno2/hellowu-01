window.addEventListener('load',()=>{
	getMiniNoticeList01();
	getMiniNoticeList02();
	getUserInfo();
}) 

//공지사항등 미니게시판 메인화면에 가져옴
function getMiniNoticeList01(){ 
	fetch('/test-board/getNotice')
	.then(function(res){
		return res.json();
	})
	.then(function(data){
		let html = '';
		for(let i=0; i<data.length; i++){
			const boardList = data[i]
			html +='<tr style="cursor:pointer" onclick="location.href=\'/board?tbNum=' + boardList.tbNum +'\'" boardList.tbNum">';
			html +='<td>' + boardList.tbNum + '</td>';
			html +='<td>' + boardList.tbTitle + '</td>';
			html +='<td>' + boardList.uiNickname + '</td>';
			html +='<td>' + boardList.tbRecommend + '</td>';
			html += '</tr>';
		}
		document.querySelector('#aBody').innerHTML = html;
		document.querySelector('#dBody').innerHTML = html;
	})
}

// 카테고리 2 최신글 5개까지 메인페이지에 표현
function getMiniNoticeList02(){ 
	fetch('/test-board')
	.then(function(res){
		return res.json();
	})
	.then(function(data){
		let html = '';
		for(let i=0; i<5; i++){
			const boardList = data[i]
			html +='<tr style="cursor:pointer" onclick="location.href=\'/board?tbNum=' + boardList.tbNum +'\'" boardList.tbNum">';
			html +='<td>' + boardList.tbNum + '</td>';
			html +='<td>' + boardList.tbTitle + '</td>';
			html +='<td>' + boardList.uiNickname + '</td>';
			html +='<td>' + boardList.tbRecommend + '</td>';
			html += '</tr>';
		}
		document.querySelector('#bBody').innerHTML = html;
		document.querySelector('#cBody').innerHTML = html;
	})
}

//슬라이드 유저 리스트
async function getUserInfo(){
	const imageValues = document.querySelectorAll('#slide');
	const response = await fetch('/user-info/list');
	const list = await response.json();
	const bodies = document.querySelectorAll('.userInfoBody');
		for(let i=0; i<bodies.length; i++) {
			//console.log(list[i]);
			const rNum = Math.floor(Math.random() * list.length);
			//console.log(list[rNum].uiProfileImgPath);
			imageValues[i].setAttribute('src',list[rNum].uiProfileImgPath);
			let html = list[rNum].uiNickname + '<br>';
			if(list[rNum].addr){
			html += list[rNum].addr + '<br>';

			}
			html += list[rNum].uiEmail + '<br>';
			html += '<a style="cursor:pointer;"onclick="getUserProfile(\''+list[rNum].uiNickname+'\')">프로필 보러가기</a><br>';
		bodies[i].insertAdjacentHTML('beforeend',html);

	}
}

//슬라이드 개인프로필 보기
async function getUserProfile(uiNickname){
	const response = await fetch('/user-info/profile/'+ uiNickname);
	const profileInfo = await response.text();
	if(profileInfo){
		sessionStorage.setItem('profileInfo',profileInfo);
		location.href= '/views/user/information';
	}
}
