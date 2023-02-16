const userInfo = JSON.parse(sessionStorage.getItem('profileInfo'));

async function getMyEveryPost(){
		const firstResponse = await fetch('/table/list');
		const list = await firstResponse.json();
		const param = {};
		for(let tableInfo of list){
			param[(tableInfo.blBoardEngName.toUpperCase() + "_BOARD" + tableInfo.blSuffix)] = tableInfo.blBoardKorName;
		}
		const secondResponse = await fetch('/table/get-every-post/'+userInfo.uiNickname,{
			method : 'POST',
			headers : {
				'Content-type' : 'application/json'
			},
			body : JSON.stringify(param)
		})
		
		const result = await secondResponse.json();
		/*console.log(result);*/
		const myPost = document.getElementById('myPost');
		for(let [key,value] of Object.entries(result)){
			const html = value.length > 0? `${key.split(",")[1]}에 작성한 글 내역 ${value.length}개 <b style="cursor:pointer;" onclick=getMyPost(\'${key.split(",")[0]}\',\'${value[0].UI_NICKNAME}\')>자세히 보기</b><br>` : `${key.split(",")[1]}에 작성한 글 내역 ${value.length}개<br>`;
			// 사용자가 쓴 글이 0개라면 자세히 보기 버튼은 만들어지지 않음
			myPost.insertAdjacentHTML('beforeend',html); 
			// innerHTML += 와 같은 기능이지만 속도가 더 빠름
		}
	}

function getMyPost(tableName,userName){
	const prefix = tableName.substring(0,1)+tableName.substring(tableName.indexOf('_')+1,tableName.indexOf('_')+2);
	const data = {
		NICKNAME : 'UI_NICKNAME',
		RECOMMEND : prefix + '_RECOMMEND',
		ADDR1 : prefix + '_ADDR1',
		ACTIVE : prefix + '_ACTIVE',
		TABLENAME : tableName,
		CATEGORY : prefix + '_CATEGORY',
		NUM : prefix + '_NUM',
		TITLE : prefix + '_TITLE',
		CONTENT : prefix + '_CONTENT',
		CNT : prefix + '_CNT',
		CREDAT : prefix + '_CREDAT',
		MODDAT : prefix + '_MODDAT'
	}
	sessionStorage.setItem('data',JSON.stringify(data));
	sessionStorage.setItem('target',JSON.stringify(userName));
	
	location.href="/views/board/list";
}
	
window.addEventListener('load',()=>{
	getUserProfile();
	getMyEveryPost();
	
})


