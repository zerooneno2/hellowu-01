<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.2/sockjs.min.js" integrity="sha512-ayb5R/nKQ3fgNrQdYynCti/n+GD0ybAhd3ACExcYvOR2J1o3HebiAe/P0oZDx5qwB+xkxuKG6Nc0AFTsPT/JDQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="/js/sidebar.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/animejs/3.2.1/anime.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
 <link rel="stylesheet" href="/css/sidebar.css">
<%@ include file="/WEB-INF/views/common/import.jsp"%>
<!-- 폰트 -->
<link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
<script>
let socket;
let toggle = false || JSON.parse(localStorage.getItem('dark_mode'));
window.addEventListener('load',()=>{
	getSidebarMenu();
	document.getElementById('dark_mode').addEventListener('click',()=>{
		toggle = !toggle;
		localStorage.setItem('dark_mode',toggle);
		toggleDarkMode();
	})
	toggleDarkMode();
	
	
	socket = new SockJS('/ws/util');
	
	setTimeout(()=>{
		socket.send('COUNT&');
		socket.onmessage = (e)=>{
			if(e.data.indexOf('댓글') != -1){
				const alertDiv = document.createElement('div');
				const realtimeDiv = document.getElementById('realtime');
				realtimeDiv.appendChild(alertDiv);
				alertDiv.classList.add('animate__animated', 'animate__backInLeft');
				alertDiv.innerHTML = e.data;

				setTimeout(() => {
				  alertDiv.classList.add("animate__backOutLeft");
				  alertDiv.addEventListener('animationend', () => {
				    realtimeDiv.removeChild(alertDiv);
				  });
				}, 10000);
			} else if(e.data.indexOf('접속중입니다.') != -1){
				const datas = e.data.split('&');
				const usersUl = document.getElementById('usersUl');
				usersUl.innerHTML = '';
				for(let i = 1; i<datas.length; i++){
					usersUl.insertAdjacentHTML('beforeend','<li><div style="color:black; cursor:not-allowed;"class="dropdown-item">'+datas[i]+'</div></li>');
				}
				
				const countDiv = document.getElementById('countDiv');
				countDiv.innerText = datas[0];
				countDiv.style.visibility = 'visible';
				
				
				
			} else if(e.data.indexOf('팔로우') != -1){
				const followDiv = document.createElement('div');
				const realtimeDiv = document.getElementById('realtime');
				realtimeDiv.appendChild(followDiv);
				followDiv.classList.add('animate__animated', 'animate__backInLeft');
				followDiv.innerHTML = e.data;

				setTimeout(() => {
				  followDiv.classList.add("animate__backOutLeft");
				  followDiv.addEventListener('animationend', () => {
				    realtimeDiv.removeChild(followDiv);
				  });
				}, 5000);
			}
		}

	},700)

	if(JSON.parse('${not empty userInfo}')){
		document.querySelector('.myPage').addEventListener('click',async function(e){
			const userNickname = '${userInfo.uiNickname}';
			const response = await fetch('/user-info/profile/'+userNickname);
			const profileInfo = await response.text();
			
			if(profileInfo){
				sessionStorage.setItem('profileInfo',profileInfo);
				location.href= '/views/user/information';
			}
		});
	}	
})
function goToPost(tableName,boardNum){ // 댓글 보러가기
	const prefix = tableName.substring(0,1);
	const param = {
		NICKNAME : 'UI_NICKNAME',
		RECOMMEND : prefix+'B_RECOMMEND',
		ADDR1 : prefix+'B_ADDR1',
		ACTIVE : prefix+'B_ACTIVE',
		TABLENAME : tableName,
		CATEGORY : prefix+'B_CATEGORY',
		NUM : prefix+'B_NUM',
		CNT : prefix+'B_CNT',
		CREDAT : prefix+'B_CREDAT',
		TITLE : prefix+'B_TITLE',
		CONTENT : prefix+'B_CONTENT',
		MODDAT : prefix+'B_MODDAT'
	}
	
	sessionStorage.setItem('data',JSON.stringify(param));
	sessionStorage.setItem('name',tableName);
	sessionStorage.setItem('suffix',tableName.substring(tableName.lastIndexOf('_')));
	location.href = '/views/board/view?num='+boardNum;
	
}
function getBoard(name,suffix){
	const url = '/table/get-column?name='+name+'&suffix='+suffix;
	/* console.log(url); */
	fetch(url)
	.then((response)=>{
		if(response.ok){
			return response.json();
		} else {
			throw new Error('폐쇄된 게시판입니다.');
		}
	})
	.then((data)=>{
		sessionStorage.setItem('data',JSON.stringify(data)); // 테이블 칼럼명
		sessionStorage.setItem('name',name);
		sessionStorage.setItem('suffix',suffix);
		sessionStorage.removeItem('target'); // 쓴 글 검색
		location.replace('/views/board/list');
	})
	.catch((error)=>{
		alert(error);
	})
}
function getSidebarMenu(){
	fetch('/table/list')
	.then(response=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((list)=>{
		let target;
		
		for(let obj of list){
			switch(obj.blCategory){
			case '운동' : target = 'exercise';
			break;
			case '취미' : target = 'hobby';
			break;
			case '공부' : target = 'study';
			break;
			case '게임' : target = 'game';
			break;
			case '지역' : target = 'local';
			break;
			}
			let html = '<li><a style="cursor:pointer;" onclick="getBoard(\''+obj.blBoardEngName+'\''+',\''+obj.blSuffix+'\')" class="dropdown-item">'+obj.blBoardKorName+'</a></li>';
			document.getElementById(target).innerHTML += html;
		}
		
	})
}
// 작업 다 끝내고 모듈화
</script>

<body style="font-family: 'Poor Story', cursive;">

<!-- 사이드바 로고 사이즈 등 변경  --> <!-- navbar로 변경  -->
<div class="dropdown">
  <div class="dropdown-toggle" style="cursor:pointer; visibility: hidden;" id="countDiv" data-bs-toggle="dropdown" aria-expanded="false">
    
  </div>
  <ul class="dropdown-menu" aria-labelledby="countDiv" id="usersUl">
  </ul>
</div>



<!-- 오른쪽하단으로 이동, css참조 -->
		
			<svg id="dark_mode" width="55" height="55" viewBox="0 0 55 55"
				xmlns="http://www.w3.org/2000/svg">
				<path class="moon"
					d="M 27.5 0 C 34.791 0 41.79 2.899 46.945 8.055 C 52.101 13.21 55 20.209 55 27.5 C 55 34.791 52.101 41.79 46.945 46.945 C 41.79 52.101 34.791 55 27.5 55 C 20.209 55 13.21 52.101 8.055 46.945 C 2.899 41.79 0 34.791 0 27.5 C 0 20.209 2.899 13.21 8.055 8.055 C 13.21 2.899 20.209 0 27.5 0 Z"
					fill="#fee140" />
			</svg>

		
<c:if test="${empty userInfo}">
	<div id="uiInfo">
		로그인 해주세요
	<button id="login" class="btn btn-primary" onclick="location.href='/'">로그인</button>
	</div>
</c:if>

<c:if test="${not empty userInfo}">
	
	<div id="uiInfo">
		${userInfo.uiNickname } 님, 안녕하세요
		<button id="logout" class="btn btn-primary" onclick="signOut()">로그아웃</button>

<!-- 위 2개의 div 위치 조정 필요  -->
		<div style="visibility: hidden;"id="countDiv">&nbsp;</div>
		<div id="realtime">
		
		</div>
	</div>	
	
</c:if>


<nav class="navbar navbar-expand-lg border-top border-bottom border-2" style="margin-bottom: 0px;">

  <div class="container">
  	<!-- 로고 설정 -->
    <a class="navbar-brand" href="/views/main"><img src="/resources/images/logo.png" style="margin-right: 17px; width: 140px;" 
    class="logoImg"></a> <!-- col-lg-2 col-md-4 col-sm-6 col-8 제거하니 insert, update에서 로고 나옴 -->
    <!-- 드롭다운 아이콘 -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown1" aria-controls="navbarNavDropdown1" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    
    <div class="collapse navbar-collapse" id="navbarNavDropdown1">
      <ul class="navbar-nav">
      
       <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink1" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            운동
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink1" id="exercise">
          
          </ul>
        </li>
        
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink2" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            취미
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink2" id="hobby">
          
          </ul>
        </li>
        
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink3" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            공부
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink3" id="study">
          
          </ul>
        </li>
        
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink4" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            지역
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink4" id="local">
          
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink4" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            게임
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink5" id="game">
          
          </ul>
        </li>
      
       <c:if test="${not empty userInfo}"> <!-- 로그인했을때만 보이는 dropdown -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle " href="#" id="navbarDropdownMenuLink5" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            마이메뉴
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink5">
            <li><a class="dropdown-item"  href="/views/user/profile-check">프로필</a></li>
            <li><a class="dropdown-item myPage" style="cursor:pointer;" >마이페이지</a></li>
            <li><a class="dropdown-item" href="/views/user/request">게시판 생성요청</a></li>
            <li><a class="dropdown-item" href="/views/user/follower?uiNum=${userInfo.uiNum}">팔로워</a></li>
            <li><a class="dropdown-item" href="/views/user/following?uiNum=${userInfo.uiNum}">팔로잉</a></li>
          </ul>
        </li>
      </c:if>
      <!-- 일반유저메뉴 -->
      
      
      <c:if test="${userInfo.uiEmail eq 'demd@hanmail.net'}"> <!--관리자 메뉴 -->
      	<li class="nav-item"> 
          <a class="nav-link" href="/views/user/response">게시판 생성요청 관리</a>
        </li>
      </c:if>
      </ul>
      
    </div>
  </div>
</nav>

		





</body>