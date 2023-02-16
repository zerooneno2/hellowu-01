

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
			location.reload();
		}
	})
	
}

const moonPath = "M 27.5 0 C 34.791 0 41.79 2.899 46.945 8.055 C 52.101 13.21 55 20.209 55 27.5 C 55 34.791 52.101 41.79 46.945 46.945 C 41.79 52.101 34.791 55 27.5 55 C 20.209 55 13.21 52.101 8.055 46.945 C 2.899 41.79 0 34.791 0 27.5 C 0 20.209 2.899 13.21 8.055 8.055 C 13.21 2.899 20.209 0 27.5 0 Z";
const sunPath = "M 27.5 0 C 34.791 0 41.79 2.899 46.945 8.055 C 33.991 9.89 26.93 20.209 26.93 27.5 C 26.93 34.791 33.689 45.261 46.945 46.945 C 41.79 52.101 34.791 55 27.5 55 C 20.209 55 13.21 52.101 8.055 46.945 C 2.899 41.79 0 34.791 0 27.5 C 0 20.209 2.899 13.21 8.055 8.055 C 13.21 2.899 20.209 0 27.5 0 Z";
const darkMode = document.querySelector("#dark_mode");
function toggleDarkMode(){
	
	//여기에 타임라인을 더한다
	const timeline = anime.timeline({
		duration : 750,
		easing : "easeOutExpo"
	});
	//add 다른 애니메이션 타임라인에
	timeline
	.add({
		targets:".moon",
		d:[{value: !toggle ? moonPath: sunPath}] //moonPath ->sunpath
	})
	.add({
		targets:'#dark_mode',
		backgroundColor : !toggle? 'rgba(22,22,22)' : 'rgba(255,255,255)', /*일반상태에서 배경색은 검은색, 다크모드로 들어가면 배경색을 흰색으로*/
		rotate : !toggle? 0 : 360
	},"-=350")
	.add({
		targets: "*:not(button)",
		backgroundColor: !toggle ? 'rgba(255,255,255)' : 'rgba(22,22,22)',		//여기서 다크모드 시 색상 변경
	},"-750")
	.add({
		targets: "*",
		color: !toggle ? 'rgba(22,22,22)' : 'rgba(255,255,255)', // 다크모드라면 흰색, 아니라면 검은색
	},"-750")
	.add({
		targets: "",
		backgroundColor: !toggle ? 'rgba(22,22,22)' : 'rgba(255,255,255)',
	},"-750")

	// 아래는 연습용
	.add({
		targets: "#footer *",
		backgroundColor: !toggle ? 'rgba(255,255,255)' : 'rgba( 0, 0, 0, 0.2)',	
	},"-750")
	
	// 사이드 바 색상 설정
	.add({
		targets: "#sidebar",
		/*backgroundColor: !toggle ? 'rgba(221, 221, 221, 1)' : 'rgba(140, 140, 140, 1)',*/
		boxShadow: !toggle? '0px 3px 6px rgba(0, 0, 0, 0), 0 3px 6px black' : '0px 6px 12px rgba(0, 0, 0, 0), 0 3px 6px gray'
	},"-750"); // -= 700 딜레이
	
	const logoPath = toggle? '/resources/images/logo_dark.png' : '/resources/images/logo.png';
	document.querySelector('.logoImg').setAttribute('src',logoPath);

}

