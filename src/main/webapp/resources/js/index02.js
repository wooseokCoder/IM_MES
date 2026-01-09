/**
 * index02 대시보드를 처리하는 스크립트이다.
 */

let popupList = [];
let notiIndex = 0;
let notiSlide;

$(function() {
	//상단메뉴 로딩
	jwidget.menu.load();
	
	//핫메뉴 로딩
	jwidget.hotmenu.load();
	
	//팝업 로딩
	jwidget.popup.load();
	
	$(window).load(function() {
		$("#loadingProgressBar").hide();
		initChart();
		
		notiSlide = setInterval(notiDown, 3000);
	});
});

function doMemuGo(key) {
	jmenus.go(key);
}

function initChart() {
	var ctx = document.getElementById('performanceChart');
	if (!ctx) return;
	
	ctx = ctx.getContext('2d');
	
	// 하드코딩 데이터 (파란 박스)
	var chartData = {
		labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
		datasets: [
			{
				label: '2024',
				type: 'bar',
				backgroundColor: 'rgba(54, 162, 235, 0.6)',
				borderColor: 'rgba(54, 162, 235, 1)',
				borderWidth: 1,
				data: [449, 520, 580, 650, 720, 800, 850, 900, 950, 1000, 719, 680]
			},
			{
				label: '2025',
				type: 'bar',
				backgroundColor: 'rgba(255, 159, 64, 0.6)',
				borderColor: 'rgba(255, 159, 64, 1)',
				borderWidth: 1,
				data: [954, 980, 1020, 1050, 1100, 1150, 1200, 1250, 1300, 1350, 304, 800]
			},
			{
				label: 'Plan',
				type: 'line',
				backgroundColor: 'rgba(255, 99, 132, 0)',
				borderColor: 'rgba(255, 99, 132, 1)',
				borderWidth: 2,
				fill: false,
				data: [1000, 1050, 1100, 1150, 1200, 1409, 1300, 1250, 1200, 1150, 753, 1100],
				pointRadius: 4,
				pointHoverRadius: 6
			}
		]
	};
	
	var chartOptions = {
		responsive: true,
		maintainAspectRatio: false,
		scales: {
			yAxes: [{
				beginAtZero: false,
				min: 200,
				max: 1600,
				ticks: {
					stepSize: 200
				}
			}]
		},
		legend: {
			display: true,
			position: 'top'
		},
		tooltips: {
			mode: 'index',
			intersect: false
		}
	};
	
	// Chart.js v2.x 방식으로 혼합 차트 생성
	var myChart = new Chart(ctx, {
		type: 'bar',
		data: chartData,
		options: chartOptions
	});
}

// 팝업 제목 클릭 시 오픈
function notiPopup() {
	if(popupList.length > 0){
	jwidget.popup.open(popupList[notiIndex]);
	}
}

function notiUp() {
	if(popupList.length > 0){
	notiIndex = (notiIndex - 1 + popupList.length) % popupList.length;
	$("#notiTit").text(popupList[notiIndex].bordTitle);
	}
}

function notiDown() {
	if(popupList.length > 0){
	notiIndex = (notiIndex + 1) % popupList.length;
	$("#notiTit").text(popupList[notiIndex].bordTitle);
	
	if(popupList.length < 2) {
		clearInterval(notiSlide);
	}
	}
}

