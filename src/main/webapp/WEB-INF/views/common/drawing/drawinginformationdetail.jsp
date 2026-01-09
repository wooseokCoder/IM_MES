<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)user.jsp 1.0 2014/08/12                                            --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 대시보드 조회 화면이다.                                                      	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/drawing/drawinginformationdetail.js?v=1206B" />"></script>
<script type="text/javascript">
var numBox = [];
</script>
<style>
.canvasWrap {
	position: relative;
	overflow: hidden; 
	border: 1px solid #ccc;
	padding: 0;
}
#myCanvas {
	background-size: auto;
	background-position: center;
	background-repeat: no-repeat;
	margin: 0 auto;
	display: block;
}
.pointer {
    cursor: pointer;
}
.col-md-8 table {
	width: 100%;
	margin-bottom: 2%;
	font-size: 17px;
}
.col-md-8 table td:first-of-type {
	text-align: center;
	background: #cae2ff;
	font-weight: bold;
}
.col-md-8 table td:last-of-type {
	padding-left: 10px;
}
.col-md-8 table td {
	border: 1px solid #ccc;
}
.draw-info {
	overflow-y: scroll;
	height: 500px;
	font-size: 15px;
	padding-right: 10px;
}
.draw-info::-webkit-scrollbar { -webkit-appearance: none;} 
.draw-info::-webkit-scrollbar:vertical { width: 12px; } 
.draw-info::-webkit-scrollbar:horizontal { height: 12px; }
.draw-info::-webkit-scrollbar-thumb { background-color: #b5b5b5; border-radius: 10px; border: 2px solid #ffffff;}
.draw-info::-webkit-scrollbar-track { border-radius: 10px; background-color: #ffffff;}

.draw-info > p {
	font-weight: bold;
}
.drawing-title {
	font-size: 24px;
	text-align: center;
	font-weight: bold;
}
.drawing-content {
	width: 100%;
}
.drawing-content tr td:last-of-type {
	padding-left: 10px;
}
.drawing-content tr td:first-of-type, .drawing-content tr td:nth-of-type(3) {
	background: #cae2ff;
	text-align: center;
	font-weight: bold;
}
.drawing-content td {
	border: 1px solid #ccc;
}
.drawing-items {
	display: flex; 
	justify-content: space-between; 
	align-items: center; 
	margin: 10px 0 5px 0;
}
.drawing-create {
	display: flex;
	width: 100%;
}
/* 임시로 스타일 잡기 */
.ex-style {
	border: none;
	border-radius: 5px;
	height: 23px;
	width: 100%;
}
.powerButton {
	display: none;
}
.toggleSwitch {
  width: 35px;
  height: 20px;
  display: block;
  position: relative;
  border-radius: 30px;
  background-color: #fff;
  box-shadow: 0 0 0px 1px rgb(0 0 0 / 15%);
  cursor: pointer;
  margin-bottom: 0;
}

.toggleSwitch .toggleButton {
  width: 13px;
  height: 13px;
  position: absolute;
  top: 50%;
  left: 4px;
  transform: translateY(-50%);
  border-radius: 50%;
  background: #919191;
}

.toggleSwitch.active {
  background: #3e6fb1;
}

.toggleSwitch.active .toggleButton {
  left: calc(100% - 17px);
  background: #fff;
}

.toggleSwitch, .toggleButton {
  transition: all 0.2s ease-in;
}
</style>
</head>
<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">
    <div class="col-md-12" style="margin-top: 20px;">
    	<form id="regist-form">
    		<input type="hidden" name="oper"     id="r_oper"     value="${model.oper}"    />
	        <input type="hidden" name="sysId"    id="r_sysId"    value="${model.sysId}"   />
	        <input type="hidden" name="listNo"   id="r_listNo"   value="${model.listNo}"  />
	        <input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
	        <input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>
	        <input type="hidden" name="atchNo"   id="r_atchNo"   value=""/>
	        <input type="hidden" name="applId"   id="r_applId"   value="DI"/>
    	</form>
    	<div class="col-md-8">
    		<table>
				<tr>
					<td>Drawing</td>
					<td>
						<div class="wui-upload">
							<div id="regist-fileupload"></div>
						</div>
					</td>
				</tr>
			</table>
			<div class="canvasWrap">
				<canvas id="myCanvas" width="600" height="500"></canvas>
			</div>
	    </div>
	    <div class="col-md-4">
	    	<p class="drawing-title">Drawing Information</p>
		    <!-- 몇 개의 버튼, 박스를 생성할 지 정하는 인풋, 버튼 -->
		    <div class="draw-info">
		    	<p>▶ Items</p>
			    <table class="drawing-content">
			    	<colgroup>
			    		<col width="15%" />
			    		<col width="35%" />
			    		<col width="15%" />
			    		<col width="35%" />
			    	</colgroup>
			    	<tr>
			    		<td>Type</td>
			    		<td>
			    			<select class="ex-style" id="listType">
			    				<option value=""> -- choice -- </option>
								<option value="Product">Product</option>
								<option value="Assembly">Assembly</option>
							</select>
			    		</td>
			    		<td>Code</td>
			    		<td>
			    			<input type="text" id="codeSearch" name="codeSearch" class="ex-style" value=""/>
			    		</td>
			    	</tr>
			    	<tr>
			    		<td>Name</td>
			    		<td>
			    			<input type="text" id="nameSearch" name="nameSearch" class="ex-style" value=""/>
			    		</td>
			    		<td>Count</td>
			    		<td>
			    			<div class="drawing-create">
						    	<input type="text" id="myInput" class="ex-style" />
						    	<a href="javascript:void(0)" id="item-create" class="easyui-linkbutton c6 l-btn l-btn-small" style="font-size: 11px; height: 21px; width: 30px;">
						    		<i class="fa fa-arrow-down" aria-hidden="true"></i>
						    	</a>
						    </div>
			    		</td>
			    	</tr>
			    </table>
			    <!-- on & off 버튼 및 내용 입력 input 생성 -->
			    <div id="power"></div><br />
		    </div>
		    <!-- save -->
		    <button id="item-save" class="easyui-linkbutton c6 l-btn l-btn-small" style="margin-top: 10px;">save</button>
		    <!-- view -->
		    <button id="item-list" class="easyui-linkbutton c6 l-btn l-btn-small" style="margin-top: 10px;">Go to List</button>
		</div>
    </div>
<!-- [LAYOUT] end -->
</div>

<script>
	function doSelect(){
		var listNo = new URL(location.href).searchParams.get('listNo');
		if(listNo != ""){
			$.ajax({
				url: getUrl("/common/drawing/drawinginformationdetail/select.json"),
		        dataType: "json",
		        type: 'post',
		        data: { 
		        	listNo: listNo
		        },
		        success: function(data) {
		        	if(data.rows != null){
		        		$("#r_atchNo").val(data.rows.atchNo);
		        		$("#listType").val(data.rows.listType);
			        	$("#codeSearch").val(data.rows.listCode);
			        	$("#nameSearch").val(data.rows.listName);
			        	var realUrl = 'http://52.40.215.183:8080/lsdp_data/upload/real/' + data.rows.fileName ;
			    		$("#myCanvas").css('background-image', "url(" + realUrl + ")");
			        	$.ajax({
			    			url: getUrl("/common/drawing/drawinginformationdetail/getItemList.json"),
			    	        dataType: "json",
			    	        type: 'post',
			    	        data: { 
			    	        	listNo: listNo
			    	        },
			    	        success: function(data2) {
			    	        	$("#myInput").val(data2.rows.length);
			    	        	btnCreate();
			    	        	$("#r_oper").val("U");
			    	        	for(var i = 0; i< data2.rows.length; i++){
			    	        		$("#itemType" + i).val(data2.rows[i].itemType);
			    	        		$("#itemCode" + i).val(data2.rows[i].itemCode);
			    	        		$("#itemName" + i).val(data2.rows[i].itemName);
			    	        		$("#num" + i).val(data2.rows[i].itemNo);
			    	        		$("#boxX" + i).val(data2.rows[i].boxX);
			    	        		$("#boxY" + i).val(data2.rows[i].boxY);
			    	        		$("#toggle" + i).val(data2.rows[i].itemUse);
			    	        		if($("#toggle" + i).val() == 'on'){
			    	        			$("label:eq(" + i + ")").addClass("active");
			    	        			numBox.splice(i, 1, new box(Number($("#boxX" + i).val()), Number($("#boxY" + i).val()), 'black', i + 1, 23));
			    	        			numBox[i].onoff = true;
			    	        			animate();
			    	        		} else {
			    	        			
			    	        		}
			    	        	}
			            	},
			    	        error:  function(data2) {
			    	        	
			    	        }
			    		});
		        	}
	        	},
		        error:  function(result) {
		        	
		        }
			});
		}
	}
	// 버튼 클릭 시 실행
    function drawSet(i){
        var powerBtn = document.getElementsByClassName('powerButton');
        if(powerBtn[i].value == 'off'){
        	powerBtn[i].value = 'on';
            if(numBox[i] == undefined){
                numBox.splice(i, 1, new box(20, 20, 'black', i + 1, 23));
            } else {
                numBox.splice(i, 1, new box(numBox[i].x, numBox[i].y, 'black', i + 1, 23));
            }
            animate();
            numBox[i].onoff = true;
            
        } else {
            powerBtn[i].value = 'off';
            numBox[i].onoff = false;
        }
    }
	
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
            ctx.fillStyle = 'white';
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
    
 	// 마우스의 정보
    function getMouseMove(canvas, event){
        let canvasXY = canvas.getBoundingClientRect();
        return {
            x: event.pageX - canvasXY.left,
            y: event.pageY - canvasXY.top
        }
    }
    // 마우스 offset 값 계산한 함수
    function getOffset(mouse, e) {
        return {
            x : mouse.x - e.x,
            y : mouse.y - e.y
        }
    }
    // 마우스가 사각형 안에 진입했는 지 여부
    function cursorInRect(mouseX, mouseY, boxX, boxY, boxW, boxH){
        let xCoord = mouseX > boxX && mouseX < boxX + boxW;
        let yCoord = mouseY > boxY && mouseY < boxY + boxH;
        return xCoord && yCoord
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////// event //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // 마우스 왼쪽 버튼 클릭 시
    canvas.addEventListener('mousedown', function(e){
        var mouse = getMouseMove(canvas, e);
        numBox.forEach(function(e){
            if(cursorInRect(mouse.x, mouse.y, e.x, e.y, e.edge, e.edge) && e.onoff){
                e.select = true;
                e.offset = getOffset(mouse, e);
            } else {
                e.select = false;
            }
        });
    });

    // 마우스 이동 시
    canvas.addEventListener('mousemove', function(e){
        var mouse = getMouseMove(canvas, e);
        var arr = numBox.map(e => cursorInRect(mouse.x, mouse.y, e.x, e.y, e.edge, e.edge) && e.onoff);
        !arr.every(e => e === false) ? canvas.classList.add('pointer') : canvas.classList.remove('pointer');
        numBox.forEach(function(e){
            if(e.select){
                e.x = mouse.x - e.offset.x;
                e.y = mouse.y - e.offset.y;
            }
            cursorInRect(mouse.x, mouse.y, e.x, e.y, e.edge, e.edge) ?
            e.active != true ? e.activate() : false
            : e.active = false;
        });
    });
    
    // 마우스 뗐을 때
    canvas.addEventListener('mouseup',function(e) {
        numBox.forEach(function(e){
            e.select = false;
        });
    });

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////// animation ///////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function animate(){
        ctx.clearRect(0, 0, canvas.width, ctx.canvas.height);
        numBox.forEach(function(e) {
            if(e.onoff){
                e.draw();
            }
        });
        // 다음 애니메이션 실행(반복 애니메이션 실행을 위함)
        requestAnimationFrame(animate);
    }
</script>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
