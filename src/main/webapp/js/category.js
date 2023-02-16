/** 로그아웃 */
function logOut(){
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

window.onload = function(){
	document.querySelector('#tbTitle').addEventListener('keypress',(e)=>{
		if(e.keyCode === 13) getBoardInfos();
	})
}