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
<%-- 도면 목록  화면이다.                                                      	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/drawing/drawinginformation.js?v=1206B" />"></script>
<script type="text/javascript">
var numBox = [];
</script>
<style>
.canvasWrap {
	position: relative;
	overflow: hidden; 
	border: 1px solid #ccc;
	padding: 0;
	margin-top: 5px;
}
#myCanvas {
	background-size: auto;
	background-position: center;
	background-repeat: no-repeat;
	margin: 0 auto;
	display: block;
}
.draw-info {
	overflow-y: scroll;
	height: 500px;
	font-size: 15px;
	padding-right: 0;
}
.draw-info::-webkit-scrollbar { -webkit-appearance: none;} 
.draw-info::-webkit-scrollbar:vertical { width: 12px; } 
.draw-info::-webkit-scrollbar:horizontal { height: 12px; }
.draw-info::-webkit-scrollbar-thumb { background-color: #b5b5b5; border-radius: 10px; border: 2px solid #ffffff;}
.draw-info::-webkit-scrollbar-track { border-radius: 10px; background-color: #ffffff;}

.draw-info > p {
	font-weight: bold;
}
.drawing-content {
	width: 100%;
}
.drawing-content tr td:nth-of-type(2n) {
	padding-left: 6px;
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
	margin: 10px 1px 5px 0;
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

input[type="text"]:read-only {
	background: #fff;
}

#regist-dialog {
	-webkit-user-select:none;
	-moz-user-select:none;
	-ms-user-select:none;
	user-select:none;
}

#regist-dialog input {
	font-style: italic;
}

#tooltipWrap > div {
    position:absolute;
    display: none;
    width: 100px;
    height: 100px;
    padding: 0 10px 10px 10px;
}
#tooltipWrap div div {
    position: absolute;
    width: 80px;
    height: 80px;
    background: #3e6fb1;
    font-size: 14px;
    user-select: none;
    color: #fff;
    padding: 10px;
}
#tooltipWrap div div::after {
    content: '';
    left: -4px;
    top: 7px;
    position: absolute;
    display: block;
    border-left: 15px solid #3e6fb1;
    border-bottom: 15px solid transparent;
    transform: rotate(-45deg);
}
#tooltipWrap button {
	position: absolute;
	left: 50%;
	transform: translate(-50%, 0);
	bottom: 30px;
	font-size: 20px;
	color: #3e6fb1;
	border: 1px solid #fff;
	background: #fff;
}
.pointer {
    cursor: pointer;
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
    <table id="search-grid">
	    <thead>
		     <tr>
				<th data-options="field:'listNo',   halign:'center', width:200, align:'center', data_item:'GRD_001', sortable:true">No</th>
				<th data-options="field:'listType', halign:'center', width:500, align:'center', data_item:'GRD_002', sortable:true">Type</th>
				<th data-options="field:'listCode', halign:'center', width:400, align:'center', data_item:'GRD_003', sortable:true">Item Code</th>
				<th data-options="field:'listName', halign:'center', width:500, align:'center', data_item:'GRD_004', sortable:true" >Name</th>
				<th data-options="field:'drawView',halign:'center', width:80,  align:'center', data_item:'GRD_005', sortable:true, styler:cellStyler, formatter:formatAttribute">Draw View</th>
			</tr>
	    </thead>
	</table>
	<div id="search-toolbar" class="wui-toolbar">
		<form id="search-form">
			<fieldset class="div-line4-new Remake-div-line-new" >
		        <table cellpadding="5" class="search-table tableSearch-c" >
		            <tr>
			            <th class="h table-Search-h search-label-h2"><span data-item="LAB_013">Item Code</span></th>
						<td class="d" style="min-width: 260px;">
							<input class="easyui-textbox" name="listCode" id="listCode" data-options="width:180, height: 30" />
						</td>
						<th class="h table-Search-h search-label-h2"><span data-item="LAB_006">Item Name</span></th>
						<td class="d">
		                    <input class="easyui-textbox" name="listName" id="listName" data-options="width:180, height: 30" />
						</td>
						<th class="h table-Search-h search-label-h2"><span data-item="LAB_003">Item Type</span></th>
						<td class="d w-200">
							<select class="easyui-combobox" name="listType" id="listType" data-options="height: 30, panelHeight: 'auto'">
			    				<option value="ALL"> ALL </option>
								<option value="Product">Product</option>
								<option value="Assembly">Assembly</option>
							</select>
						</td>
						<td class="b w-a" colspan="2" style="text-align: right;">
							<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="">Search</a>
							<a href="javascript:void(0)" style="width: 80px;" id="clear3-button" class="easyui-linkbutton c12" data-item="BTN_002" data-options="">Clear</a>
						</td>
		            </tr>
		        </table>
		   </fieldset>
		    <fieldset class="div-line-new-sub div-line-new-sub-left">
		        <table cellpadding="5" class="search-table tableEtc-c">
		            <tr>
						<td class="h">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_001" data-options="disabled:${DEL}" >Delete</a>
						</td>
						<td class="h">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="add-draw-button" data-item="BTN_002" data-options="width: 160">Add Drawings</a>
						</td>
		            </tr>
		        </table>
			</fieldset>
		</form>
	</div>
<!-- [LAYOUT] end -->
</div>

<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;display:none;">
	<div class="easyui-layout"  data-options="fit:true">
		<div data-options="region:'center',border:false" style="overflow: auto; padding-top: 20px;">
			<div class="col-md-7" style="padding-right: 0;">
				<div class="canvasWrap">
					<canvas id="myCanvas" width="600" height="500"></canvas>
				</div>
				<!-- 툴팁 -->
        		<div id="tooltipWrap"></div>
			</div>
			<div class="col-md-5">
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
				    			<input type="text" id="viewListType" class="ex-style" value="" disabled/>
				    		</td>
				    		<td>Code</td>
				    		<td>
				    			<input type="text" id="viewListCode" name="viewListCode" class="ex-style" value="" disabled/>
				    		</td>
				    	</tr>
				    	<tr>
				    		<td>Name</td>
				    		<td>
				    			<input type="text" id="viewListName" name="viewListName" class="ex-style" value="" disabled/>
				    		</td>
				    		<td>Count</td>
				    		<td>
				    			<input type="text" id="myInput" class="ex-style" value="" disabled/>
				    		</td>
				    	</tr>
				    </table>
				    <!-- on & off 버튼 및 내용 입력 input 생성 -->
			    	<div id="power"></div><br />
			    </div>
			</div>
		</div>
		<div data-options="region:'south',border:false" style="height:60px;">
			<div style="text-align: center; margin-top: 25px;">
				<a href="javascript:void(0)" style="width:120px;" class="easyui-linkbutton c6" data-item="BTN_003" id="close-button" >Close</a>
			</div>
		</div>
	</div>
</div>

<script>
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
    
    var toolWrap = document.getElementById('tooltipWrap');
    
	// 마우스 이동 시
    canvas.addEventListener('mousemove', function(e){
        var mouse = getMouseMove(canvas, e);
        var arr = numBox.map(e => cursorInRect(mouse.x, mouse.y, e.x, e.y, e.edge, e.edge) && e.onoff);
        !arr.every(e => e === false) ? canvas.classList.add('pointer') : canvas.classList.remove('pointer');
        for(var i = 0; i < toolWrap.childNodes.length; i++){
            // div의 childNodes i번째 대입
            var div = toolWrap.childNodes[i];
            // arr의 i값이 tru면 block, false면 none
            if(arr[i]){
                div.style.display = 'block';
            } else {
                div.style.display = 'none';
            }
        }
    });
	
	function animate(){
        ctx.clearRect(0, 0, canvas.width, ctx.canvas.height);
        numBox.forEach(function(e) {
            if(e.onoff){
                e.draw();
            }
        });
        requestAnimationFrame(animate);
    }
</script>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
