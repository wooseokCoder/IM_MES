<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Canvas Test</title>
<style>
body {
    margin: 30px;
    padding: 0;
}
#fileUpload {
	font-size: 12px;
	display: block;
	margin-bottom: 2%;
}
.canvasWrap {
	position: relative; 
	width: 600px; 
	height: 400px; 
	overflow: hidden; 
	border: 1px solid #ccc;
	margin-bottom: 2%;
}
#myCanvas {
	background-size: 430px;
	background-position: center;
	background-repeat: no-repeat;
}
input[type="text"] {
    height: 20px;
}

input[type="button"], button {
    width: 100px;
    height: 26px;
    background-color: #222;
    color: #fff;
    border: none;
}
.pointer {
    cursor: pointer;
}
</style>
<script type="text/javascript" src="<c:url value="/resources/jquery/easyui-1.4/jquery.min.js" />"></script>
</head>
<body>
	<form id="submitForm" action="/fileUpload.do" method="post" enctype="multipart/form-data">
		<input type="file" id="fileUpload" accept="image/*" />
	</form>
	<!-- file이 여러 개일 경우 multiple = "multiple" 추가 -->
    <div class="canvasWrap">
        <canvas id="myCanvas" width="600" height="400"></canvas>
        <!-- 툴팁 -->
        <div id="tooltipWrap"></div>
    </div>
    <!-- 몇 개의 버튼, 박스를 생성할 지 정하는 인풋, 버튼 -->
    <input type="text" id="myInput"><button onclick="btnCreate()">create</button>
    <!-- on & off 버튼 및 내용 입력 input 생성 -->
    <div id="power"></div><br />
    <!-- save -->
    <button id="sendForm" onclick="hiddenValue()">save</button>
    <!-- script start -->
    <script>

	   	// file upload
	   	const fileInput = document.getElementById('fileUpload');
	   	
	   	const handleFile = (e) => {
	   		const selectedFile = fileInput.files[0];
	   		const fileReader = new FileReader();
	   		
	   		fileReader.readAsDataURL(selectedFile);
	   		
	   		// 이미지 출력
	   		fileReader.onload = function(){
	   			var loadingImg = document.getElementById('myCanvas');
	   			loadingImg.style.backgroundImage = "url(" + fileReader.result + ")";
	   			console.log(fileReader.result);
	   		};
	   	};
	   	
	   	fileInput.addEventListener('change', handleFile);
	   	
	 // hidden 값 전달 및 페이지 이동
        function hiddenValue(){
            var submitForm = document.getElementById('submitForm');
            for(var j = 0; j < numBox.length; j++){
                saveX = document.getElementById('x' + j);
                saveY = document.getElementById('y' + j);
                saveNum = document.getElementById('num' + j);
                saveEdge = document.getElementById('edge');
                if((saveX == null && saveY == null) || saveX.value == 0 && saveY.value == 0){
                    saveX = saveY = saveNum = saveEdge = 0;
                } else {
                    saveX.value = numBox[j].x;
                    saveY.value = numBox[j].y;
                    saveNum.value = numBox[j].num;
                    saveEdge.value = numBox[j].edge;
                }
                x.push(saveX.value);
                y.push(saveY.value);
                num.push(saveNum.value);
                edge.push(saveEdge.value);
            }
            $.ajax({
		        url: getUrl("/canvas/canvasSave.json"),
		        dataType: "text",
		        type: 'post',
		        data: {},
		        success: function(result) {
		        	var obj = JSON.parse(result);
		        	rowsTc = obj.rows;
		        	
		        },
		        error:  function(result) {
		        }
            });
        }
    	
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////// button ///////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        
        var numBox = [];
        var x = [];
        var y = [];
        var num = [];
        var edge = [];
        var saveX, saveY, saveNum, saveEdge;
        
        // 버튼을 만드는 함수
        function btnCreate(){
            // input의 value 값
            var myInput = Number(document.getElementById('myInput').value);
            // 파워 버튼이 들어갈 div
            var power = document.getElementById('power');
            numBox = new Array(myInput);
            toolArr = new Array(myInput);
            if(power.childNodes.length > 0){
                power.replaceChildren();
            }
            // value 값만큼 반복
            for(var i = 0; i < myInput; i++){
                // div에 버튼 및 input 생성
                power.innerHTML += "<p>#" + (i + 1) + "</p>";
                power.innerHTML += "<input type='text' id='powerText" + i + "'/>";
                power.innerHTML += "<input type='button' onclick='drawSet(" + i + ")' value='off' class='powerButton'/>";
            }
        }

        //////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////// canvas ///////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        
        // canvas 세팅
        var canvas = document.getElementById('myCanvas');
        var ctx = canvas.getContext('2d');

        // 마우스 오버 했을 시 박스 색 변경
        function hoverStyle(ctx, x, y, color) {
            ctx.save();
            ctx.translate(x, y);
            ctx.fillStyle = color;
            ctx.restore();
        }

        // box 클래스 생성
        class box{
            // 생성자 메소드 동작
            // 파라미터 : x, y, color, num, edge
            constructor(x, y, color, num, edge){
                // 속성 : x, y, color, num, edge, select, actvie, onoff
                this.x = x;
                this.y = y;
                this.color = color;
                this.num = num;
                this.edge = edge;
                this.activeColor = 'gray';
                this.select = false;
                this.active = false;
                this.onoff = false;
            }
            // 그림 그리는 메소드
            draw(){
                // 흰 사각형 + 1px solid #000 + 검정 텍스트 그리기
                ctx.fillStyle = 'white';
                // 만약 움직이고 있는 상태(true)면 호버 색상 적용
                if(this.active) {
                    ctx.fillStyle = this.activeColor;
                    ctx.save();
                    hoverStyle(ctx, this.x, this.y, this.activeColor);
                    ctx.restore();
                }
                ctx.fillRect(this.x, this.y, this.edge, this.edge);
                ctx.lineWidth = 1;
                ctx.strokeStyle = this.color;
                ctx.strokeRect(this.x, this.y, this.edge, this.edge);
                ctx.fillStyle = this.color;
                ctx.font = '12px Arial';
                ctx.fillText(this.num, this.x + 8, this.y + 16);
            }
            // 움직임 여부
            activate(){
                this.active = !this.active;
            }
        }

        // 버튼 클릭 시 실행
        function drawSet(i){
            // on & off 버튼
            var powerBtn = document.getElementsByClassName('powerButton');
            // 만약 클릭한 버튼의 value가 off 라면
            if(powerBtn[i].value == 'off'){
                // value를 on으로 변경
                powerBtn[i].value = 'on';
                // 만약 i번째 numBox의 x 값이 비어있다면 새 박스 생성
                if(numBox[i] == undefined){
                    numBox.splice(i, 1, new box(20, 20, 'black', i + 1, 23));
                    submitForm.innerHTML += "<input type='hidden' id='x" + i + "' name='x' value='20'/>";
                    submitForm.innerHTML += "<input type='hidden' id='y" + i + "' name='y' value='20'/>";
                    submitForm.innerHTML += "<input type='hidden' id='num" + i + "' name='num' value='20'/>";
                    submitForm.innerHTML += "<input type='hidden' id='edge' name='edge' value='20'/>";
                } else {
                    numBox.splice(i, 1, new box(numBox[i].x, numBox[i].y, 'black', i + 1, 23));
                }
                // 그림 그리기
                animate();
                // on&off 값 true(on)로 변경
                numBox[i].onoff = true;
            } else {
                // 아니라면 value를 off로 변경
                powerBtn[i].value = 'off';
                // on&off 값 false(off)로 변경
                numBox[i].onoff = false;
                var x = document.getElementById('x' + i);
                var y = document.getElementById('y' + i);
                var num = document.getElementById('num' + i);
                x.value = 0;
                y.value = 0;
                num.value = 0;
            }
        }

        // 마우스의 정보
        function getMouseMove(canvas, event){
            // event : mouse의 모든 이벤트(움직임, 클릭 등)
            // 마우스가 canvas에서 움직이는 내역을 canvasXY에 저장
            let canvasXY = canvas.getBoundingClientRect();
            return {
                // x : 화면에서의 캔버스 x값 - 도형의 x값
                x: event.pageX - canvasXY.left,
                // y : 화면에서의 캔버스 y값 - 도형의 y값
                y: event.pageY - canvasXY.top
            }
        }
        // 마우스 offset 값 계산한 함수
        function getOffset(mouse, e) {
            return {
                // x : 마우스 x 값에서 움직인 것의 x 값 빼기
                x : mouse.x - e.x,
                // x : 마우스 y 값에서 움직인 것의 y 값 빼기
                y : mouse.y - e.y
            }
        }
        // 마우스가 사각형 안에 진입했는 지 여부
        function cursorInRect(mouseX, mouseY, boxX, boxY, boxW, boxH){
            // mouse의 x값 > box의 x값 AND mouse의 x값 < box의 x값 + box의 width
            let xCoord = mouseX > boxX && mouseX < boxX + boxW;
            // mouse의 y값 > box의 y값 AND mouse의 y값 < box의 y값 + box의 height
            let yCoord = mouseY > boxY && mouseY < boxY + boxH;
            // true OR false
            return xCoord && yCoord
        }

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////// event //////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        // 마우스 왼쪽 버튼 클릭 시
        canvas.addEventListener('mousedown', function(e){
            // mouse에 마우스 움직이는 값들을 저장
            var mouse = getMouseMove(canvas, e);
            // numBox 값을 갖고 반복 실행
            numBox.forEach(function(e){
                // 만약 마우스가 사각형에 들어오면
                if(cursorInRect(mouse.x, mouse.y, e.x, e.y, e.edge, e.edge) && e.onoff){
                    // 선택 값은 true
                    e.select = true;
                    // offset(움직이는 값)에 getOffset 값 대입
                    e.offset = getOffset(mouse, e);
                } else {
                    // 선택 값은 false
                    e.select = false;
                }
            });
        });

        // 마우스 이동 시
        canvas.addEventListener('mousemove', function(e){
            // mouse에 마우스 움직이는 값들을 저장
            var mouse = getMouseMove(canvas, e);
            // arr = numBox 내부 값에 cursorInRect 값 대입
            var arr = numBox.map(e => cursorInRect(mouse.x, mouse.y, e.x, e.y, e.edge, e.edge) && e.onoff);
            // 선택한 요소가 true면
            !arr.every(e => e === false) ? canvas.classList.add('pointer') : canvas.classList.remove('pointer');
            // numBox 값을 갖고 반복 실행
            numBox.forEach(function(e){
                // 버튼을 클릭 했다면
                if(e.select){
                    // 해당 x 값 = 마우스의 x 값 - 움직이는 값
                    e.x = mouse.x - e.offset.x;
                    // 해당 y 값 = 마우스의 y 값 - 움직이는 값
                    e.y = mouse.y - e.offset.y;
                }
                cursorInRect(mouse.x, mouse.y, e.x, e.y, e.edge, e.edge) ?
                // 마우스가 커서에 들어오면 실행 : active가 true가 아니면 activate 함수를 실행하고(true로 변경) 아니면 false 출력
                e.active != true ? e.activate() : false
                // 마우스가 커서에 들어오지 않으면 false
                : e.active = false;
            });
        });
        // 마우스 뗐을 때
        canvas.addEventListener('mouseup',function(e) {
            // select를 계속해서 false : 뗄 떼마다 이동을 멈춰야 해서 작성
            numBox.forEach(function(e){
                e.select = false;
            });
        });

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////// animation ///////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        function animate(){
            // 박스를 초기화(초기화 하면서 그림)
            ctx.clearRect(0, 0, canvas.width, ctx.canvas.height);
            // numBox 값을 갖고 반복 실행
            numBox.forEach(function(e) {
                // onoff 가 true면
                if(e.onoff){
                    // 그리기 실행
                    e.draw();
                }
            });
            // 다음 애니메이션 실행(반복 애니메이션 실행을 위함)
            requestAnimationFrame(animate);
        }
        
    </script>
</body>
</html>