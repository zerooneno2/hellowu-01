window.addEventListener('load',()=>{
	getFiveBoardList();
	getUserInfo();
}) 

function setBoardInfo(tableName,boardNum){
	
	const prefix = tableName.substring(0,1);
	const data = {
		NICKNAME : 'UI_NICKNAME',
		RECOMMEND : prefix + 'B_RECOMMEND',
		ADDR1 : prefix +'B_ADDR1',
		ACTIVE : prefix + 'B_ACTIVE',
		TABLENAME : tableName,
		CATEGORY : prefix + 'B_CATEGORY',
		NUM : prefix+'B_NUM',
		CNT : prefix+'B_CNT',
		CREDAT : prefix + 'B_CREDAT',
		TITLE : prefix + 'B_TITLE',
		CONTENT : prefix +'B_CONTENT',
		MODDAT : prefix +'B_MODDAT'
	}
	sessionStorage.setItem('data',JSON.stringify(data));
	sessionStorage.setItem('name',tableName.substring(0,tableName.indexOf('_')).toLowerCase());
	sessionStorage.setItem('suffix',tableName.substring(tableName.lastIndexOf('_')));
	
	location.href = !boardNum? '/views/board/list':'/views/board/view?num='+boardNum;
}

async function getFiveBoardList(){
	let contentArray = ['a','b','c','d']; // 바디가 총 4개, a,b,c,d
	const response = await fetch('/table/get-main-list');
	let totalList = await response.json();
	totalList.splice(Math.floor(Math.random()*5),1); // 5개중에 하나 짜름
	
	for(let list of totalList){
		let body = '';
		let head = '';
		let cntNum = contentArray.length;
		let isBoardEmpty = false;
		if(!cntNum){ // 4개까지만 돌릴거기때문에 
			break;
		}
		let icon;
		const tableInfoObj = list[list.length-1];
		switch(tableInfoObj.BL_CATEGORY){
			case '운동' : icon = `<i class="fa-solid fa-baseball"></i>`;
			break;
			case '게임' : icon = `<i class="fa-solid fa-gamepad"></i>`;
			break;
			case '공부' : icon = `<i class="fa-solid fa-book"></i>`;
			break;
			case '지역' : icon = `<i class="fa-solid fa-location-dot"></i>`;
			break;
			case '취미' : icon = `<i class="fa-solid fa-user"></i>`;
			break;  
		}
		if(list.length === 1) { // 게시판에 글이 없으면 게시판 정보만 가진 오브젝트만 리스트에 담기므로 리스트의 길이가 무조건 1
			head += `${icon} ${list[0].BL_BOARD_KOR_NAME} 게시판에 글이 없습니다.&nbsp;|&nbsp; 개설자 : ${tableInfoObj.BL_REQUESTER_NICKNAME}`;
			body += `<tr style="cursor:pointer;" onclick="setBoardInfo('${tableInfoObj.BL_BOARD_ENG_NAME.toUpperCase()}'+'_BOARD'+'${tableInfoObj.BL_SUFFIX}')"><td>처음으로 글을 남겨보세요!</td></tr>`;
			isBoardEmpty = true;
		} else {
			head += `<th>${icon} ${tableInfoObj.BL_BOARD_KOR_NAME} 게시판 인기글 &nbsp;|&nbsp; 개설자 : ${tableInfoObj.BL_REQUESTER_NICKNAME} </th>`;	
		}
		let rNum = 0;
		for(let i = 0; i<list.length-1; i++){ // 리스트의 마지막 인덱스에는 게시판 정보가 담겨있기 때문에 length-1
			if(isBoardEmpty) break;
			const obj = list[i];
			rNum = Math.floor(Math.random()*cntNum); // 0~3 -> 0~2 -> 0~1 -> 0~0
			const prefix = tableInfoObj.BL_BOARD_ENG_NAME.substring(0,1).toUpperCase();	
			body += `<tr style="cursor:pointer;" onclick="setBoardInfo('${tableInfoObj.BL_BOARD_ENG_NAME.toUpperCase()}'+'_BOARD'+'${tableInfoObj.BL_SUFFIX}',${obj[prefix+'B_NUM']})">`;		
			body += `<td>${obj.UI_NICKNAME}님</td>`;
			body += `<td>${obj[prefix+'B_TITLE']}</td>`;
			body += `<td>추천 ${obj[prefix+'B_RECOMMEND']}</td>`;
			body += `</tr>`;
			
		} // end of inner for
		document.getElementById(contentArray[rNum]+'Head').insertAdjacentHTML('beforeend',head);
		document.getElementById(contentArray[rNum]+'Body').insertAdjacentHTML('beforeend',body);
		contentArray.splice(rNum,1); // a,b,c,d Body중에 쓴거는 배열에서 지움
		
	} // end of outer for
}


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
		document.querySelector('#dBody').innerHTML = html;
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
