<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
window.onload = function(){
	getBoxOfficeList();
}

function saveListIntoDB(){
	let url = '/box-office/save?targetDt=';
	const val = document.querySelector('input[type=date]').value;
	if(val != ''){
		url += val;
	} else {
		url += 'default';
	}
	console.log(url)
	fetch(url)
	.then((response)=>{
		if(response.ok){
			return response.json();
		} else throw new Error('이미 DB에 저장했습니다.');
	})
	.then((result)=>{
		console.log(result)
		if(result){
			alert('데이터를 DB에 성공적으로 저장했습니다.');
		}
	})
	.catch((error)=>{
		alert(error);
	})
}

function getBoxOfficeList(){
	let url = '/box-office/list?targetDt=';
	const cols = document.querySelectorAll('[data-col]');
	const val = document.querySelector('input[type=date]').value;
	if(val != ''){
		url += val;
	} else {
		url += 'default';
	}
	
	console.log(url);
	fetch(url)
	.then((response)=>{
		if(response.ok){
			return response.json();
		}
	})
	.then((data)=>{
		let html = '';
		for(let obj of data){
			html += '<tr>';
			for(let col of cols){
				html += '<td>'+obj[col.getAttribute('data-col')]+'</td>';
			}
			html += '</tr>';
		}
		document.querySelector('#getList').innerHTML = html;
	})
}
</script>
</head>
<body>
<table border=1>
<tr>
<th data-col="rank">순위</th>
<th data-col="movieNm">제목</th>
<th data-col="audiCnt">일일 관객수</th>
<th data-col="openDt">개봉일</th>
</tr>
<tbody id="getList"></tbody>
</table>
<input type="date" ><button onclick="getBoxOfficeList()">보기</button><button onclick="saveListIntoDB()">저장</button>
</body>
</html>