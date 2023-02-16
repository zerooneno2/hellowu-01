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
			<h1 style="margin-bottom: 10px;">following</h1>
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
	let processing = false; 
	const followingList = listRequester();
	const userInfo = JSON.parse(sessionStorage.getItem('profileInfo'));
	window.onload = function(){
		if(window.innerHeight >= document.body.offsetHeight){	
	        now += 10;
			getFollowingList(followingList);
	    }
	}
	window.addEventListener('scroll', () => { 
		if(processing) return; 
	    let val = window.innerHeight + window.scrollY;
	    if(val >= document.body.offsetHeight){
	    	processing = true; 
	    	now += 5;
	    	getFollowingList(followingList);
	    }
	});
	
	async function listRequester(){
		const response = await fetch('/follow/following/${userInfo.uiNum}');
		return data = await response.json();
	}
	
	async function getFollowingList(followings){
		const data = await followings;
		let len = data.length;
		
		if(now > len){
			now = len;
		}
		for(let i = start; i<now; i++){
			let html = '';
			let following = data[i];
			html +='<div class="tbl-content">';
			html +='<table cellpadding="0" cellspacing="0" border="0">';
			html +='<tbody>';
			html +='<tr>';
			html +='<td><img src="'+following.uiProfileImgPath + '" style="width:120px; height:120px;"></td>';
			html +='<td style="cursor:pointer;"onclick="getUserProfile(\''+following.uiNickname+'\')">'+following.uiNickname + '</td>';
			html += following.addr? '<td>'+following.addr + '</td>' : '<td>주소 정보가 없습니다.</td>';
			html +='<td>'+following.uiHobby + '</td>';
			html +='<td><button class="btn btn-primary" onclick="unFollow('+following.uiNum+')">언팔로우</button></td>';
			html +='</tr>';
			html +='</tbody>';
			html +='</table>';
			html +='</div>';
			document.querySelector('.content').insertAdjacentHTML('beforeend',html);
		}	
		start = now;
		processing = false;
	}	
	
	function unFollow(targetNum){
		const param = {
				uiFollowerNum : parseInt('${userInfo.uiNum}'),
				uiFollowingNum : targetNum
		};
		
		fetch('/follow/delete',{
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
				alert('언팔로우');
				location.reload();
			} else{
				alert('실패');
			}
		})
	}
	
	async function getUserProfile(userNickname){
			
			const response = await fetch('/user-info/profile/'+userNickname);
			const profileInfo = await response.text();
			
			if(profileInfo){
				sessionStorage.setItem('profileInfo',profileInfo);
				location.href= '/views/user/information';
			}
		}
	</script>
</body>
</html>