// 초기 선언해 주는 부분

// 화면 컨트롤 객체
var consts = {};
consts = {
	title: "Location Manager",
	url: {
		list: getUrl("/common/sample/locmanager.do"),
		search: getUrl("/common/sample/locmanager/search.json"),
		save: getUrl("/common/sample/locmanager/save.json"),
		checkSign: getUrl("/common/sample/locmanager/checkSign.json")
	},
	init: function() {
	}
};

// 전역 변수
var canvas = null;
var ctx = null;
var numBox = [];

// Box 클래스 생성
class Box {
	constructor(x, y, color, label) {
		this.x = x;
		this.y = y;
		this.width = 150;
		this.height = 80;
		this.color = color;
		this.label = label;
		this.select = false;
		this.active = false;
		this.offset = null;
	}
	
	draw() {
		ctx.save();
		
		// 박스 그리기
		ctx.fillStyle = this.color;
		ctx.globalAlpha = this.active ? 0.7 : 0.5;
		ctx.fillRect(this.x, this.y, this.width, this.height);
		
		// 테두리
		ctx.strokeStyle = this.color;
		ctx.lineWidth = 2;
		ctx.globalAlpha = 1.0;
		ctx.strokeRect(this.x, this.y, this.width, this.height);
		
		// 텍스트
		ctx.fillStyle = '#000';
		ctx.font = 'bold 16px Arial';
		ctx.textAlign = 'center';
		ctx.textBaseline = 'middle';
		ctx.fillText(this.label, this.x + this.width / 2, this.y + this.height / 2);
		
		ctx.restore();
	}
	
	activate() {
		this.active = !this.active;
	}
}

$(function() {
	// canvas 초기화
	canvas = document.getElementById('myCanvas');
	if (!canvas) {
		console.error('Canvas element not found');
		return;
	}
	ctx = canvas.getContext('2d');
	
	// 이벤트 리스너 등록
	initEventListeners();
	
	// 캔버스 초기화
	initCanvas();
	
	$("#reset-button").bind("click", doReset);
	$("#search-button").bind("click", doSearch);
	$("#add-button").bind("click", doAddBox);
	$("#check-sign-button").bind("click", doCheckSign);
	
	// 서명 관련 초기화
	initSignDialog();
	// 저장된 사인 확인 다이얼로그 초기화
	initCheckSignDialog();
});

// 서명 다이얼로그 초기화
function initSignDialog() {
	// 서명 다이얼로그 초기화
	$('#sign-dialog').dialog({
		title: 'Signature',
		top: 10,
		width: 560,
		height: 335,
		closed: true,
		modal: true,
		resizable: true
	});
	
	// 서명 버튼
	$("#confirm-location-button").bind("click", doOpenSign);
	// 서명 저장 버튼
	$("#save-sign-button").bind("click", doSaveSign);
	// 서명 닫기 버튼
	$("#close-sign-button").bind("click", doCloseSign);
	
	$('#sign-dialog').window({
		onClose: function (){
			setTimeout('doSignClear()', 10);
		}
	});
	
	// 서명 캔버스 초기화
	var signCanvas, signCtx;
	signCanvas = document.getElementById("sign-canvas");
	if (signCanvas && signCanvas.getContext) {
		signCtx = signCanvas.getContext('2d');
		
		signCtx.lineWidth = 4;
		signCtx.strokeStyle = "black";
		
		var signStartX = 0, signStartY = 0;
		var signDrawing = false;
		var signEmptyImg = "";
		
		function signDraw(curX, curY) {
			signCtx.beginPath();
			signCtx.moveTo(signStartX, signStartY);
			signCtx.lineTo(curX, curY);
			signCtx.stroke();
		}
		
		function signDown(e) {
			signStartX = e.offsetX;
			signStartY = e.offsetY;
			signDrawing = true;
		}
		
		function signUp(e) {
			signDrawing = false;
		}
		
		function signMove(e) {
			if(!signDrawing) return;
			var curX = e.offsetX, curY = e.offsetY;
			signDraw(curX, curY);
			signStartX = curX;
			signStartY = curY;
		}
		
		function signOut(e) {
			signDrawing = false;
		}
		
		// 마우스 리스너 등록
		signCanvas.addEventListener("mousemove", signMove, false);
		signCanvas.addEventListener("mousedown", signDown, false);
		signCanvas.addEventListener("mouseup", signUp, false);
		signCanvas.addEventListener("mouseout", signOut, false);
		
		// 전역 변수로 함수 노출
		window.signCanvas = signCanvas;
		window.signCtx = signCtx;
		window.signEmptyImg = signEmptyImg;
		window.doSignClear = function() {
			if (signCtx && signCanvas) {
				signCtx.clearRect(0, 0, signCanvas.width, signCanvas.height);
				signCtx.fillStyle = '#ffffff';
				signCtx.fillRect(0, 0, signCanvas.width, signCanvas.height);
			}
		};
	}
	
	$(".wui-dialog").show();
}

function initCanvas() {
	if (!canvas || !ctx) {
		return;
	}
	
	// 박스 배열 초기화 (검색 데이터로만 표시)
	numBox = [];
	
	// 애니메이션 시작
	animate();
}

// 마우스의 정보
function getMouseMove(canvas, event) {
	// 이벤트 타겟이 canvas가 아닌 경우(offsetX/offsetY 기준이 달라짐)에도 좌표가 일치하도록
	// clientX/clientY + canvas.getBoundingClientRect() 기준으로 통일
	var canvasXY = canvas.getBoundingClientRect();
	var scaleX = canvas.width / canvasXY.width;
	var scaleY = canvas.height / canvasXY.height;
	
	var clientX = null, clientY = null;
	
	// 터치 이벤트 지원
	if (event.touches && event.touches.length > 0) {
		clientX = event.touches[0].clientX;
		clientY = event.touches[0].clientY;
	} else if (event.changedTouches && event.changedTouches.length > 0) {
		clientX = event.changedTouches[0].clientX;
		clientY = event.changedTouches[0].clientY;
	} else {
		clientX = event.clientX;
		clientY = event.clientY;
	}
	
	return {
		x: (clientX - canvasXY.left) * scaleX,
		y: (clientY - canvasXY.top) * scaleY
	}
}

// 마우스 offset 값 계산한 함수
function getOffset(mouse, box) {
	return {
		x: mouse.x - box.x,
		y: mouse.y - box.y
	}
}

// 마우스가 사각형 안에 진입했는지 여부
function cursorInRect(mouseX, mouseY, boxX, boxY, boxW, boxH) {
	// 경계를 포함하여 체크 (>=, <= 사용)
	let xCoord = mouseX >= boxX && mouseX <= boxX + boxW;
	let yCoord = mouseY >= boxY && mouseY <= boxY + boxH;
	return xCoord && yCoord;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////// event //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 선택 상태 해제 함수
function releaseBoxes() {
	numBox.forEach(function(box) {
		box.select = false;
		box.offset = null;
	});
}

function initEventListeners() {
	if (!canvas) {
		return;
	}
	
	// 마우스 왼쪽 버튼 클릭 시
	canvas.addEventListener('mousedown', function(e) {
		var mouse = getMouseMove(canvas, e);
		// 모든 박스 선택 해제
		releaseBoxes();
		// 배열을 역순으로 순회하여 가장 위에 있는(마지막에 그려진) 박스만 선택
		for (var i = numBox.length - 1; i >= 0; i--) {
			var box = numBox[i];
			if (cursorInRect(mouse.x, mouse.y, box.x, box.y, box.width, box.height)) {
				box.select = true;
				box.offset = getOffset(mouse, box);
				break; // 첫 번째로 발견된 박스(가장 위)만 선택하고 중단
			}
		}
	});
	
	// 마우스 이동 시
	canvas.addEventListener('mousemove', function(e) {
		var mouse = getMouseMove(canvas, e);
		var arr = numBox.map(box => cursorInRect(mouse.x, mouse.y, box.x, box.y, box.width, box.height));
		!arr.every(e => e === false) ? canvas.classList.add('pointer') : canvas.classList.remove('pointer');
		
		// 드래그 중인 박스 위치 업데이트
		var hasDragging = false;
		numBox.forEach(function(box) {
			if (box.select && box.offset) {
				hasDragging = true;
				box.x = mouse.x - box.offset.x;
				box.y = mouse.y - box.offset.y;
				
				// 캔버스 범위 내로 제한
				if (box.x < 0) box.x = 0;
				if (box.y < 0) box.y = 0;
				if (box.x + box.width > canvas.width) box.x = canvas.width - box.width;
				if (box.y + box.height > canvas.height) box.y = canvas.height - box.height;
			}
			
			cursorInRect(mouse.x, mouse.y, box.x, box.y, box.width, box.height) ?
				box.active != true ? box.activate() : false
				: box.active = false;
		});
	});
	
	// 마우스 뗐을 때 (캔버스 내에서)
	canvas.addEventListener('mouseup', function(e) {
		releaseBoxes();
	});
	
	// 캔버스 밖으로 나갔을 때 (드래그 중이 아닐 때만 해제)
	canvas.addEventListener('mouseleave', function(e) {
		// 드래그 중인 박스가 없을 때만 해제
		var hasDragging = numBox.some(function(box) {
			return box.select && box.offset;
		});
		if (!hasDragging) {
			releaseBoxes();
		}
	});
	
	// 전역 mouseup 이벤트 (캔버스 밖에서도 마우스를 떼면 해제)
	document.addEventListener('mouseup', function(e) {
		releaseBoxes();
	});
	
	// 전역 mousemove 이벤트 (캔버스 밖에서도 드래그 처리)
	document.addEventListener('mousemove', function(e) {
		var canvasXY = canvas.getBoundingClientRect();
		// 캔버스 내부인지 확인
		if (e.clientX >= canvasXY.left && e.clientX <= canvasXY.right && 
			e.clientY >= canvasXY.top && e.clientY <= canvasXY.bottom) {
			// 캔버스 내부에서는 getMouseMove 함수 사용
			var mouse = getMouseMove(canvas, e);
			
			// 드래그 중인 박스가 있으면 위치 업데이트
			numBox.forEach(function(box) {
				if (box.select && box.offset) {
					box.x = mouse.x - box.offset.x;
					box.y = mouse.y - box.offset.y;
					
					// 캔버스 범위 내로 제한
					if (box.x < 0) box.x = 0;
					if (box.y < 0) box.y = 0;
					if (box.x + box.width > canvas.width) box.x = canvas.width - box.width;
					if (box.y + box.height > canvas.height) box.y = canvas.height - box.height;
				}
			});
		} else {
			// 캔버스 밖에서는 드래그 해제
			var hasDragging = numBox.some(function(box) {
				return box.select && box.offset;
			});
			if (!hasDragging) {
				releaseBoxes();
			}
		}
	});
	
	// 더블클릭 이벤트 - 박스 제거
	canvas.addEventListener('dblclick', function(e) {
		var mouse = getMouseMove(canvas, e);
		// 배열을 역순으로 순회하여 가장 위에 있는 박스 찾기
		for (var i = numBox.length - 1; i >= 0; i--) {
			var box = numBox[i];
			if (cursorInRect(mouse.x, mouse.y, box.x, box.y, box.width, box.height)) {
				// 클로저 문제 해결을 위해 변수 저장
				var boxIndex = i;
				var boxLabel = box.label;
				// 확인 메시지
				$.messager.confirm(msg.MSG0123, msg.MSG0099 + ' "' + boxLabel + '"?', function(r) {
					if (!r) return;
					// 박스 제거
					numBox.splice(boxIndex, 1);
					// 캔버스 다시 그리기
					if (canvas && ctx) {
						ctx.clearRect(0, 0, canvas.width, canvas.height);
						ctx.fillStyle = '#f5f5f5';
						ctx.fillRect(0, 0, canvas.width, canvas.height);
						numBox.forEach(function(box) {
							box.draw();
						});
					}
					$.messager.alert(msg.MSG0122, msg.MSG0100 + ' "' + boxLabel + '" ' + msg.MSG0101 + '.', msg.MSG0122);
				});
				break;
			}
		}
	});
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////// animation ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function animate() {
	if (!canvas || !ctx) {
		return;
	}
	
	// 박스 이동시 잔상 제거
	ctx.clearRect(0, 0, canvas.width, canvas.height);
	
	// 배경 그리기
	ctx.fillStyle = '#f5f5f5';
	ctx.fillRect(0, 0, canvas.width, canvas.height);
	
	// 모든 박스 그리기
	numBox.forEach(function(box) {
		box.draw();
	});
	
	// 다음 애니메이션 실행
	requestAnimationFrame(animate);
}

// 위치 초기화
function doReset() {
	// 모든 선택 상태 완전히 초기화
	numBox.forEach(function(box) {
		box.select = false;
		box.active = false;
		box.offset = null;
	});
	
	// 박스 배열 초기화
	numBox = [];
	
	// 초기화 직후 강제로 그리기
	if (canvas && ctx) {
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		ctx.fillStyle = '#f5f5f5';
		ctx.fillRect(0, 0, canvas.width, canvas.height);
	}
}

// 서명 팝업 열기
function doOpenSign() {
	$("#sign-dialog").dialog('center');
	$("#sign-dialog").dialog('open');
	if (window.signCanvas) {
		window.signEmptyImg = window.signCanvas.toDataURL('image/png');
	}
}

// 서명 저장
function doSaveSign() {
	if (!window.signCanvas) {
		return;
	}
	
	var canvasImg = window.signCanvas.toDataURL('image/png');
	
	if (canvasImg == window.signEmptyImg) {
		$.messager.alert(msg.MSG0121, msg.MSG0094, msg.MSG0121);
		return;
	}
	
	// base64 데이터에서 헤더 제거
	var signImg = canvasImg.replace(/^data:image\/png;base64,/, "");
	$("#signTemp").val(signImg);
	
	// 현재 캔버스에 있는 모든 박스 데이터 수집
	var wareHous = $("#WARE_HOUS").combobox("getValue");
	if (!wareHous || wareHous.trim() === '') {
		$.messager.alert(msg.MSG0121, msg.MSG0047, msg.MSG0121);
		return;
	}
	
	// 박스 데이터 배열 생성 (박스가 없어도 빈 배열로 저장 가능)
	var boxData = [];
	numBox.forEach(function(box) {
		boxData.push({
			locNo: box.label,
			wareHous: wareHous,
			latitude: (box.x / 10).toFixed(8), // 캔버스 좌표를 위도로 변환
			longitude: (box.y / 10).toFixed(8), // 캔버스 좌표를 경도로 변환
			signImg: signImg
		});
	});
	
	// 서버로 저장 요청 (form 데이터 형식)
	var formData = {
		wareHous: wareHous,
		signImg: signImg,
		boxList: JSON.stringify(boxData)
	};
	
	$.ajax({
		url: consts.url.save,
		type: 'POST',
		data: formData,
		dataType: 'json',
		success: function(result) {
			$.messager.alert(msg.MSG0122, msg.MSG0096, msg.MSG0122);
			doCloseSign();
		},
		error: function(xhr, status, error) {
			$.messager.alert(msg.MSG0121, msg.MSG0097 + ': ' + error, msg.MSG0121);
		}
	});
}

// 서명 팝업 닫기
function doCloseSign() {
	$("#sign-dialog").dialog('close');
}

// 조회 함수
function doSearch() {
	if($('#'+this.id).hasClass('l-btn-disabled')){
		return false;
	}
	
	var wareHous = $("#WARE_HOUS").combobox("getValue");
	
	$.ajax({
		url: consts.url.search,
		type: 'POST',
		data: {
			wareHous: wareHous
		},
		dataType: 'json',
		success: function(result) {
			if (result && result.rows) {
				// 조회된 데이터로 박스 생성
				numBox = [];
				var colors = ['blue', 'green', 'orange', 'red', 'purple', 'brown', 'pink', 'gray'];
				var colorIndex = 0;
				
				result.rows.forEach(function(item, index) {
					// DB에서 가져온 latitude/longitude를 캔버스 좌표로 변환
					// 저장 시: latitude = box.x / 10, longitude = box.y / 10
					// 조회 시: x = latitude * 10, y = longitude * 10
					var lat = item.latitude != null && item.latitude !== '' ? parseFloat(item.latitude) : null;
					var lng = item.longitude != null && item.longitude !== '' ? parseFloat(item.longitude) : null;
					
					var x = lat != null && !isNaN(lat) ? lat * 10 : 100 + (index % 4) * 200;
					var y = lng != null && !isNaN(lng) ? lng * 10 : 100 + Math.floor(index / 4) * 200;
					
					var label = item.locNo || ('LOC' + (index + 1));
					var color = colors[colorIndex % colors.length];
					colorIndex++;
					
					numBox.push(new Box(x, y, color, label));
				});
				
				// 캔버스 다시 그리기
				if (canvas) {
					// 캔버스 크기 확인 및 재설정 (필요시)
					if (canvas.width !== 1000 || canvas.height !== 700) {
						canvas.width = 1000;
						canvas.height = 700;
						// 크기 재설정 후 context 다시 가져오기
						ctx = canvas.getContext('2d');
					}
					
					if (ctx) {
						ctx.clearRect(0, 0, canvas.width, canvas.height);
						ctx.fillStyle = '#f5f5f5';
						ctx.fillRect(0, 0, canvas.width, canvas.height);
						numBox.forEach(function(box) {
							box.draw();
						});
					}
				}
			}
		},
		error: function(xhr, status, error) {
			$.messager.alert(msg.MSG0121, msg.MSG0098 + ': ' + error, msg.MSG0121);
		}
	});
}

// 박스 추가 (팝업 없이 바로 생성)
function doAddBox() {
	var wareHous = $("#WARE_HOUS").combobox("getValue");
	if (!wareHous || wareHous.trim() === '') {
		$.messager.alert(msg.MSG0121, msg.MSG0047, msg.MSG0121);
		return;
	}
	
	// 새 박스 번호 생성 (기존 박스 번호 확인)
	var boxNum = 1;
	var existingLabels = numBox.map(function(box) { return box.label; });
	while (existingLabels.indexOf('LOC' + boxNum) !== -1) {
		boxNum++;
	}
	
	var locNo = 'LOC' + boxNum;
	
	// 새 박스 생성 (캔버스 중앙에 배치)
	var colors = ['blue', 'green', 'orange', 'red', 'purple', 'brown', 'pink', 'gray'];
	var colorIndex = numBox.length % colors.length;
	var x = canvas.width / 2 - 75; // 박스 너비의 절반만큼 왼쪽으로
	var y = canvas.height / 2 - 40; // 박스 높이의 절반만큼 위로
	
	var newBox = new Box(x, y, colors[colorIndex], locNo);
	numBox.push(newBox);
	
	// 캔버스 다시 그리기
	if (canvas && ctx) {
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		ctx.fillStyle = '#f5f5f5';
		ctx.fillRect(0, 0, canvas.width, canvas.height);
		numBox.forEach(function(box) {
			box.draw();
		});
	}
}

// 저장된 사인 확인 다이얼로그 초기화
function initCheckSignDialog() {
	$('#check-sign-dialog').dialog({
		title: 'Check Sign',
		top: 10,
		width: 600,
		height: 500,
		closed: true,
		modal: true,
		resizable: true
	});
	
	// 닫기 버튼
	$("#close-check-sign-button").bind("click", doCloseCheckSign);
}

// 저장된 사인 확인
function doCheckSign() {
	var wareHous = $("#WARE_HOUS").combobox("getValue");
	if (!wareHous || wareHous.trim() === '') {
		$.messager.alert(msg.MSG0121, msg.MSG0047, msg.MSG0121);
		return;
	}
	
	$.ajax({
		url: consts.url.checkSign,
		type: 'POST',
		data: {
			wareHous: wareHous
		},
		dataType: 'json',
		success: function(response) {
			var result = response.result || response;
			if (result && result.signImg) {
				// base64 이미지 데이터를 img 태그에 설정
				var imgSrc = 'data:image/png;base64,' + result.signImg;
				$("#check-sign-image").attr("src", imgSrc);
				$("#check-sign-dialog").dialog('center');
				$("#check-sign-dialog").dialog('open');
			} else {
				$.messager.alert(msg.MSG0121, msg.MSG0102, msg.MSG0121);
			}
		},
		error: function(xhr, status, error) {
			$.messager.alert(msg.MSG0121, msg.MSG0098 + ': ' + error, msg.MSG0121);
		}
	});
}

// 저장된 사인 확인 다이얼로그 닫기
function doCloseCheckSign() {
	$("#check-sign-dialog").dialog('close');
	$("#check-sign-image").attr("src", "");
}


