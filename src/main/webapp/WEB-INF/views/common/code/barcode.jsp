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
<%-- 사용자관리 화면이다.                                                      --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/common/code/barcode.js" />"></script>
<script type="text/javascript">
	 doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
</head>



<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>

<div id="container">
			<img width="400" height="300" src="about:blank" alt="" id="picture">
			<input id="Take-Picture" type="file" accept="image/*;capture=camera" />
			<p id="textbit"></p>
		</div>
		<script type="text/javascript">
			var takePicture = document.querySelector("#Take-Picture"),
			showPicture = document.querySelector("#picture");
			Result = document.querySelector("#textbit");
			Canvas = document.createElement("canvas");
			Canvas.width=640;
			Canvas.height=480;
			var resultArray = [];
			ctx = Canvas.getContext("2d");
			var workerCount = 0;
			function receiveMessage(e) {
				if(e.data.success === "log") {
					//console.log(e.data.result);
					return;
				}
				if(e.data.finished) {
					workerCount--;
					if(workerCount) {
						if(resultArray.length == 0) {
							DecodeWorker.postMessage({ImageData: ctx.getImageData(0,0,Canvas.width,Canvas.height).data, Width: Canvas.width, Height: Canvas.height, cmd: "flip"});
						} else {
							workerCount--;
						}
					}
				}
				if(e.data.success){
					var tempArray = e.data.result;
					for(var i = 0; i < tempArray.length; i++) {
						if(resultArray.indexOf(tempArray[i]) == -1) {
							resultArray.push(tempArray[i]);
						}
					}
					Result.innerHTML=resultArray.join("<br />");
				}else{
					if(resultArray.length === 0 && workerCount === 0) {
						Result.innerHTML="Decoding failed.";
					}
				}
			}
			var DecodeWorker = new Worker(context+"/resources/js/common/code/barcodeReader.js");
			DecodeWorker.onmessage = receiveMessage;
			if(takePicture && showPicture) {
				takePicture.onchange = function (event) {
					var files = event.target.files
					if (files && files.length > 0) {
						file = files[0];
						try {
							//BBUG.CHANGE
							//var URL = window.URL || window.webkitURL;
							var URL = window.URL;
							var imgURL = URL.createObjectURL(file);
							showPicture.src = imgURL;
							//alert( "BBUG.CHECK 5 : " + showPicture.src);
							//BBUG.ADD
							document.getElementById("picture").src = url;
							DecodeBar()
							//BBUG.MOVE
							URL.revokeObjectURL(imgURL);
						}
						catch (e) {
							try {
								var fileReader = new FileReader();
								fileReader.onload = function (event) {
									showPicture.src = event.target.result;
								};
								fileReader.readAsDataURL(file);
								DecodeBar()
							}
							catch (e) {
								Result.innerHTML = "Neither createObjectURL or FileReader are supported";
							}
						}
					}
				};
			}
			function DecodeBar(){
				showPicture.onload = function(){
					ctx.drawImage(showPicture,0,0,Canvas.width,Canvas.height);
					resultArray = [];
					workerCount = 2;
					Result.innerHTML="";
					DecodeWorker.postMessage({ImageData: ctx.getImageData(0,0,Canvas.width,Canvas.height).data, Width: Canvas.width, Height: Canvas.height, cmd: "normal"});
				}
			}
		</script>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>