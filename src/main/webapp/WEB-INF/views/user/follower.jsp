<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<meta charset="UTF-8">
<title>HELLO友</title>
<link rel="stylesheet" href="/css/follower.css">
<link rel="stylesheet" href="/css/view.css">
<style>
tbody, td, tfoot, th, thead, tr {
	color: black;
}
</style>
</head>
<body>

	<div class="container mt-3">
		<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>

		<section>
			<!--for demo wrap-->
			<h1 style="margin-bottom: 10px;">follower</h1>
			<div class="tbl-header">
				<table cellpadding="0" cellspacing="0" border="1">
					<thead>
						<tr>
							<th>사진</th>
							<th>닉네임</th>
							<th>지역</th>
							<th>취미</th>
							<th></th>
						</tr>
					</thead>
					<tbody id="tBody"></tbody>
				</table>
			</div>
			<div class="content"></div>
		</section>
	</div>

	<script>
	let now = 5;
	let start = 0;
	let processing = false; // 스크롤이 브라우저 하단에 닿으면 딱 1번만 if문의 코드를 호출해야하는데 여러번 호출하게 되는걸 방지하기 위함
	const userInfo = JSON.parse(sessionStorage.getItem('profileInfo'));
	const followerList = listRequester(); // 유저 리스트는 딱 1번만 호출
	window.onload = function(){
		if(window.innerHeight >= document.body.offsetHeight){ // 스크롤바가 안보인다면 now += 10	
	        now += 10;
			getFollowerList(followerList);
	    }
	}
	// document도 전체 페이지인데 scroll 이벤트리스너는 관습적으로 window에 붙인다
	window.addEventListener('scroll', () => { 
		if(processing) return; // if문의 코드가 진행중이라면 return
	    let val = window.innerHeight + window.scrollY;
	    if(val >= document.body.offsetHeight){
	    	processing = true; // 진행중
	    	now += 5; // 스크롤바 끝에 닿을때마다 5개씩 더보게함
	    	getFollowerList(followerList);
	    }
	});
	async function listRequester(){
		const response = await fetch('/follow/follower/${userInfo.uiNum}');
		return await response.json();
	}
	
	async function getFollowerList(followers){
		const data = await followers;
		let len = data.length;
		/* if(start >= len){ 
			return;
		} */
		
		if(now > len){
			now = len; // 데이터의 길이보다 요구하는 개수가 많으면 길이에 맞춰줌
		}
		
		/* console.log(data);
		console.log('len',len);
		console.log('now',now);
		console.log('start',start); */
		for(let i = start; i<now; i++){
			let html = '';
			let follower = data[i];
			const isFollowed = await followChecker(follower.uiNum);
			html +='<div class="tbl-content">';
			html +='<table cellpadding="0" cellspacing="0" border="0">';
			html +='<tbody>';
			html +='<tr>';
			html +='<td><img src="'+follower.uiProfileImgPath + '" style="width:120px; height:120px;"></td>';
			html +='<td style="cursor:pointer;"onclick="getUserProfile(\''+follower.uiNickname+'\')">'+follower.uiNickname + '</td>';
			html += follower.addr? '<td>'+follower.addr + '</td>' : '<td>주소 정보가 없습니다.</td>';
			html +='<td>'+follower.uiHobby + '</td>';
			if(!isFollowed){
				html +='<td><button class="btn btn-primary" onclick="follow('+follower.uiNum+')">팔로우</button></td>';	
			} else{
				html +='<td></td>'
			}
			html +='</tr>';
			html +='</tbody>';
			html +='</table>';
			html +='</div>';
			document.querySelector('.content').insertAdjacentHTML('beforeend',html);
		}
		start = now;
		processing = false;	// 작업이 다 끝났으면 다시 false로 바꿔줌
	}
	
	async function followChecker(targetNum){
	
		
		const myUiNum = parseInt('${userInfo.uiNum}');
		const response = await fetch('/follow/check?uiFollowerNum='+myUiNum+'&uiFollowingNum='+targetNum);
		const result = await response.json();
		
		return result; // 검색 결과가 없다, 즉 null이다? => isFollowed = false 팔로우 안했음, 아니라면 => 팔로우 했음
	}
	
	async function getUserProfile(userNickname){
		
		const response = await fetch('/user-info/profile/'+userNickname);
		const profileInfo = await response.text();
		
		if(profileInfo){
			sessionStorage.setItem('profileInfo',profileInfo);
			location.href= '/views/user/information';
		}
	}
	
	function follow(targetNum){
		const param = {
				uiFollowerNum : parseInt('${userInfo.uiNum}'),
				uiFollowingNum : targetNum
		};
		fetch('/follow/insert',{
			method:'POST',
			headers:{
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(param)
		})
		.then(function(res){
			return res.json();
		})
		.then(function(data){
			if(data===1){
				socket.send('FOLLOW&${userInfo.uiNickname}&'+userInfo.uiNickname);
				alert('팔로우');
				location.reload();
			} else{
				alert('실패');
			}
		})
	}
	
	
	</script>
</body>
</html>