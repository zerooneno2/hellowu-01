<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 파비콘  -->
<link rel="icon" type="image/png" sizes="96x96" href="/resources/images/favicon-96x96.png">
<!-- 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Poor+Story&display=swap" rel="stylesheet">
<!-- main Css -->
<link rel="stylesheet" href="/css/main.css">
<!-- main JS -->
<script src="/js/main.js"></script>
<!-- 슬라이드 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>


<title>HELLO友</title>
</head>


<body>
	<!-- 상단 네비바 -->
	<main
		class="container flex-shrink-0 p-3 col-lg-12 col-md-12 col-sm-12 col-12">
		<div style="margin-top: 20px">
			<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
		</div>
		<div id="body-wrapper"> <!-- footer -->
			<div id="body-content"> <!-- footer 제외 -->
			
				<!-- 슬라이드 영역 시작 -->
				<div class="swiper mySwiper">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<table>
								<thead>
									<tr>
										<div class="user-slider-img">
											<img src="" alt="" id="slide">
										</div>
									</tr>
								</thead>
								<tbody class="userInfoBody"></tbody>
							</table>
						</div>
						<div class="swiper-slide">
							<table>
								<thead>
									<tr>
										<div class="user-slider-img">
											<img src="" alt="" id="slide">
										</div>
									</tr>
								</thead>
								<tbody class="userInfoBody"></tbody>
							</table>
						</div>
						<div class="swiper-slide">
							<table>
								<thead>
									<tr>
										<div class="user-slider-img">
											<img src="" alt="" id="slide">
										</div>
									</tr>
								</thead>
								<tbody class="userInfoBody"></tbody>
							</table>
						</div>
						<div class="swiper-slide">
							<table>
								<thead>
									<tr>
										<div class="user-slider-img">
											<img src="" alt="" id="slide">
										</div>
									</tr>
								</thead>
								<tbody class="userInfoBody"></tbody>
							</table>
						</div>
						<div class="swiper-slide">
							<table>
								<thead>
									<tr>
										<div class="user-slider-img">
											<img src="" alt="" id="slide">
										</div>
									</tr>
								</thead>
								<tbody class="userInfoBody"></tbody>
							</table>
						</div>

					</div>
					<div class="swiper-button-next"></div>
					<div class="swiper-button-prev"></div>
					<div class="swiper-pagination"></div>
				</div>
				<!-- 슬라이드 script -->
				<script>
					var swiper = new Swiper(".mySwiper", {
						spaceBetween : 30,
						centeredSlides : true,
						autoplay : {
							delay : 5000,
							disableOnInteraction : false
						},
						pagination : {
							el : ".swiper-pagination",
							clickable : true
						},
						navigation : {
							nextEl : ".swiper-button-next",
							prevEl : ".swiper-button-prev"
						}
					});
				</script>

				<!-- 공지사항 및 카테고리 미리보기 영역 시작 -->

				<div id="mini-all" style="margin-left: 9%">
					<div class="mini-div-01">
						<table class="table table-hover" id="mini-01">
							<thead>
								<tr>
									<th colspan="3" class="table-active"id="aHead"></th>
								</tr>
							</thead>
							<tbody id="aBody"></tbody>
						</table>
					</div>
					<div class="mini-div-02">
						<table class="table table-hover" id="mini-02">
							<thead>
								<tr>
									<th colspan="3" class="table-active"id="bHead"></th>
								</tr>
							</thead>
							<tbody id="bBody"></tbody>
						</table>
					</div>
					<div class="mini-div-03">
						<table class="table table-hover" id="mini-03">
							<thead>
								<tr>
									<th colspan="3" class="table-active"id="cHead"></th>
								</tr>
							</thead>
							<tbody id="cBody"></tbody>
						</table>
					</div>
					<div class="mini-div-04">
						<table class="table table-hover" id="mini-04">
							<thead>
								<tr>
									<th colspan="3" class="table-active"id="dHead"></th>
								</tr>
							</thead>
							<tbody id="dBody"></tbody>
						</table>
					</div>
					
				</div>

			</div>
			<%@ include file="/WEB-INF/views/common/footer.jsp"%>
		</div>
	</main>

</body>
</html>