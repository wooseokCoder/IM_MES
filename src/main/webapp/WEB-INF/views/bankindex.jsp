<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)index.jsp 1.0 2014/07/30                                           --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 인덱스 화면이다.                                                       		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp"%>
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<link rel="stylesheet" type="text/css"
		href="<c:url value="/resources/css/index.css?v=0115A" />" />

	<!-- BUSINESS JAVASCRIPT -->
	<script type="text/javascript"
		src="<c:url value="/resources/js/index.js?v=251118A" />"></script>
	<script type="text/javascript">
		$(window).load(function() {
			$("#loadingProgressBar").hide();
			
			notiSlide = setInterval(notiDown, 3000);
		});

		doInit({
			sysId : '${model.sysId}',
			title : '${model.bordName}',
			bordGrup : 'B01',
			bordType : '${model.bordType}',
			rows : '50',
			page : '${model.page}'
		});
		doInit2({
			sysId : '${model.sysId}',
			title : '${model.bordName}',
			bordGrup : 'B02',
			bordType : '${model.bordType}',
			pageSize : '${pageSize}'
		});
		
		let popupList = [];
	     let notiIndex = 0;
	     let notiSlide;

		//var didScroll;
		//var lastScrollTop = 0;

		/* $(window).scroll(function(event){
		 //didScroll=true;
		});
		setInterval(function(){
		if(didScroll){
			hasScrolled();
			didScroll =false;
		
		}
		},250);
		
		function hasScrolled(){
		
		
		 var check = 0;
		 var navbarHeight = $("#copyright").parents().parents().outerHeight();
		
		 var st = $(this).scrollTop();
		
		 if(lastScrollTop ==st ){
			 lastScrollTop = st;
		 }
		 else if(lastScrollTop < st){
			 console.log("down");
			 lastScrollTop = st;
			 $("#copyright").parent().parent().hide();
		 }
		 else{
			 console.log("up");
			 lastScrollTop = st;
			 $("#copyright").parent().parent().show();
		 }
		
		
		} */
		$(function() {
			var userGd = $("#user_gd").val(); //유저 분류
			//alert("call");

			if (window.innerWidth < 421) {
				$(window).scroll(function() {
					height = $(document).scrollTop();
				});
			}

			/* 		if(getCookie("reportLogin") == 'N') {
						console.log($("#reportUrl").val());
						var reportWin = window.open($("#reportUrl").val()+'/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lsdp&reportUnit=/reports/lsdp/dummy_login&decorate=no&output=pdf&j_username=lsdpuser&j_password=lsdp1@3$','pdfReport', 'toolbar=no, width=1, height=1, top=5000, left=5000, directories=no, status=no, scrollorbars=yes, resizable=no');
						setTimeout(function (){
							reportWin.close();
						},5000); 
						setCookie("reportLogin", "Y", 30);
					} */

			$("#help-button").click(function() {
				if (window.innerWidth < 900) {

					var check = window.innerWidth - 5;
					$(".window").addClass("forcedLeft");
					$(".window").css("width", check);
				}
			});

			$(".bord-list")
					.click(
							function() {
								if (window.innerWidth > 421
										&& window.innerWidth < 1100) {
									var check = window.innerWidth - 5;
									$(".window").addClass("forcedLeft");
									$("#bord-popup-dialog").css("width", 335);
									$("#bord-popup-dialog table").addClass(
											"forcedTable");
								} else if (window.innerWidth <= 421) {
									var check = window.innerWidth - 5;
									replaceClassProp('forcedLeft', 'top',
											(height + 30) + "px !important");
									$(".window").addClass("forcedLeft");
									$("#bord-popup-dialog").css("width", 335);
									$("#bord-popup-dialog table").addClass(
											"forcedTable");
								}
							});

			bordListGet();
			tractorStatCount();
			if ($("#user_gd").val() == "DEAL") {
				//getSoapCount(); //SAP시 STOCK_QTY 에러
			}
		});

		function replaceClassProp(cl, prop, val) {

			if (!cl || !prop || !val) {
				console.error('Wrong function arguments');
				return false;
			}

			// Select style tag value

			var tag = '#style';

			var style = $(tag).text();
			var str = style;

			// Find the class you want to change
			var n = str.indexOf('.' + cl);
			str = str.substr(n, str.length);
			n = str.indexOf('}');
			str = str.substr(0, n + 1);

			var before = str;

			// Find specific property

			n = str.indexOf(prop);
			str = str.substr(n, str.length);
			n = str.indexOf(';');
			str = str.substr(0, n + 1);

			// Replace the property with values you selected

			var after = before.replace(str, prop + ':' + val + ';');
			style = style.replace(before, after);

			// Submit changes

			$(tag).text(style);

		}

		function bordListGet() {
			var rows19;
			var rows17;

			var bord19 = $("#bord19");
			var bord17 = $("#bord17");
			/* var bord17Top = $("#bord17Top");
			var bord17etc = $("#bord17etc"); */
			$
					.ajax({
						url : getUrl("/common/board/searchbordindexb19.json"),
						dataType : "text",
						type : 'post',
						data : {},
						success : function(result) {
							var obj = JSON.parse(result);
							rows19 = obj.rows;

						},
						error : function(result) {
						},
						complete : function() { // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
							for (var i = 0; i < rows19.length; i++) {
								//var removeTagText = removeTag(rows19[i].BORD_CONTENT)
								var content = "";
								if (i == 0) {
									content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder dbActive dbCursor\" onClick=\"javascript:blockActive19(this)\">";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_GRUP\" value=\""+rows19[i].BORD_GRUP+"\" />";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_NO\" value=\""+rows19[i].BORD_NO+"\" />";
									content += "	<span class=\"txt_line bordTitle\" style=\"font-size: 15px; font-weight: 400;\">";
									content += rows19[i].BORD_TITLE;
									content += "	</span>";

									//REGI_DATE
									content += "	<span class=\"bordDt\" >";
									content += rows19[i].REGI_DATE;
									content += "	</span>";

									content += "	<span class=\"bordMore\" onClick=\"javascript:changeBoard('"
											+ rows19[i].BORD_NO + "')\">>";
									content += "	</span>";
									//content += "	<br/><span class=\"txt_post\">"+removeTagText+"</span>";
									content += "</div>";

								} else {
									content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder dbCursor\" onClick=\"javascript:blockActive19(this)\">";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_GRUP\" value=\""+rows19[i].BORD_GRUP+"\" />";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_NO\" value=\""+rows19[i].BORD_NO+"\" />";
									content += "	<span class=\"txt_line bordTitle\" style=\"font-size: 15px; font-weight: 400;\">";
									content += rows19[i].BORD_TITLE;
									content += "	</span>";

									//REGI_DATE
									content += "	<span class=\"bordDt\" >";
									content += rows19[i].REGI_DATE;
									content += "	</span>";

									content += "	<span class=\"bordMore\" onClick=\"javascript:changeBoard('"
											+ rows19[i].BORD_NO + "')\">>";
									content += "	</span>";
									//content += "	<br/><span class=\"txt_post\">"+removeTagText+"</span>";
									content += "</div>";
								}
								bord19.append(content);
							}

							fnGetImage19();
						}
					});

			$
					.ajax({
						url : getUrl("/common/board/searchbordindexb17.json"),
						dataType : "text",
						type : 'post',
						data : {},
						success : function(result) {
							var obj = JSON.parse(result);
							rows17 = obj.rows;

						},
						error : function(result) {
						},
						complete : function() { // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
							for (var i = 0; i < rows17.length; i++) {
								//var removeTagText = removeTag(rows17[i].BORD_CONTENT)
								var content = "";
								if (i == 0) {
									content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder dbActive dbCursor\" onClick=\"javascript:blockActive17(this)\">";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_GRUP\" value=\""+rows17[i].BORD_GRUP+"\" />";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_NO\" value=\""+rows17[i].BORD_NO+"\" />";
									content += "	<span class=\"txt_line txt_post2 bordTitle\" style=\"font-size: 15px; font-weight: 400;\">";
									content += rows17[i].BORD_TITLE;
									content += "	</span>";
									//REGI_DATE
									content += "	<span class=\"bordDt\" >";
									content += rows17[i].REGI_DATE;
									content += "	</span>";

									//content += "	<span class=\"\" style=\"font-size: 14px; float: right; font-weight: bold;\" onClick=\"javascript:changeBoard2('"+rows17[i].BORD_NO+"')\">More +";
									content += "	<span class=\"bordMore\" onClick=\"javascript:changeBoard2('"
											+ rows17[i].BORD_NO + "')\">>";
									content += "	</span>";
									//content += "	<br/><span class=\"txt_post\">"+removeTagText+"</span>";
									content += "</div>";

								} else {
									content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder dbCursor\" onClick=\"javascript:blockActive17(this)\">";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_GRUP\" value=\""+rows17[i].BORD_GRUP+"\" />";
									content += "	<input type=\"hidden\" id=\"\" name=\"\" class=\"BORD_NO\" value=\""+rows17[i].BORD_NO+"\" />";
									content += "	<span class=\"txt_line txt_post2 bordTitle\" style=\"font-size: 15px; font-weight: 400;\">";
									content += rows17[i].BORD_TITLE;
									content += "	</span>";

									//REGI_DATE
									content += "	<span class=\"bordDt\" >";
									content += rows17[i].REGI_DATE;
									content += "	</span>";

									//content += "	<span class=\"\" style=\"font-size: 14px; float: right; font-weight: bold;\" onClick=\"javascript:changeBoard2('"+rows17[i].BORD_NO+"')\">More +";
									content += "	<span class=\"bordMore\" onClick=\"javascript:changeBoard2('"
											+ rows17[i].BORD_NO + "')\">>";
									content += "	</span>";
									//content += "	<br/><span class=\"txt_post\">"+removeTagText+"</span>";
									content += "</div>";
								}
								bord17.append(content);
							}

							fnGetImage17();
						}
					});
		}

		function tractorStatCount() {
			var rowsTc;
			var bordTc = $("#bordTc");

			$
					.ajax({
						url : getUrl("/common/board/searchbordtc.json"),
						dataType : "text",
						type : 'post',
						data : {},
						success : function(result) {
							var obj = JSON.parse(result);
							rowsTc = obj.rows;

						},
						error : function(result) {
						},
						complete : function() { // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수 
							/* console.log(rowsTc);
							console.log(rowsTc[0].v_cnt_100); */
							var content = "";
							/* content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 listHDiv \">";
							content += "	<span style=\"width: 200px; display: inline-block;\">";
							content += "	</span>";
							content += "	<span class=\"\" style=\"font-size: 18px; font-weight: bold; \">";
							content += "Tractor";
							content += "	</span>";
							content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; \">";
							content += "Others"
							content += "	</span>";
							content += "</div>"; 
							
							//content += "<div class=\"col-md-12 dash_footer_line\"></div>";
							content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
							//content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Ordered";
							content += "	<span class=\"spnTit\" style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">Ordered";
							content += "	</span>";
							content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_cnt_200;
							content += "	</span>";
							content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_o_cnt_200;
							content += "	</span>";
							content += "</div>";
							
							//content += "<div class=\"col-md-12 dash_footer_line\"></div>";
							content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
							//content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Reviewed";
							content += "	<span class=\"spnTit\" style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">Reviewed";
							content += "	</span>";
							content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_cnt_300;
							content += "	</span>";
							content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_o_cnt_300;
							content += "	</span>";
							content += "</div>";
							
							//content += "<div class=\"col-md-12 dash_footer_line\"></div>";
							content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
							//content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Confirmed";
							content += "	<span class=\"spnTit\" style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">Confirmed";
							content += "	</span>";
							content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_cnt_400;
							content += "	</span>";
							content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_o_cnt_400;
							content += "	</span>";
							content += "</div>";
							
							//content += "<div class=\"col-md-12 dash_footer_line\"></div>";
							content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
							//content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· RTS";
							content += "	<span class=\"spnTit\" style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">RTS";
							content += "	</span>";
							content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_cnt_500;
							content += "	</span>";
							content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_o_cnt_500;
							content += "	</span>";
							content += "</div>";
							
							//content += "<div class=\"col-md-12 dash_footer_line\"></div>";
							content += "<div class=\"col-md-12 g-pa-2 g-mb-5 DashBoder2 \">";
							//content += "	<span style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">· Shipped";
							content += "	<span class=\"spnTit\" style=\"width: 200px; display: inline-block;font-size: 18px; font-weight: bold;\">Shipped";
							content += "	</span>";
							content += "	<span class=\"\" style=\"width: 55px;display: inline-block;text-align: right;font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_cnt_550;
							content += "	</span>";
							content += "	<span class=\"\" style=\"float:right; font-size: 18px; font-weight: bold; color: #ff0000;\">";
							content += rowsTc[0].v_o_cnt_550;
							content += "	</span>";
							content += "</div>";
							
							 */

							content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 listHDiv \">";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += "Tractor";
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += "Others"
							content += "	</div>";
							content += "</div>";

							content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
							content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4\" >Ordered";
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_cnt_200;
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_o_cnt_200;
							content += "	</div>";
							content += "</div>";

							content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
							content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4\" >Reviewed";
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_cnt_300;
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_o_cnt_300;
							content += "	</div>";
							content += "</div>";

							content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
							content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4\" >Confirmed";
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_cnt_400;
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_o_cnt_400;
							content += "	</div>";
							content += "</div>";

							content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
							content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4\" >RTS";
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_cnt_500;
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_o_cnt_500;
							content += "	</div>";
							content += "</div>";

							content += "<div class=\"col-md-12 col-sm-12 col-xs-12 g-pa-2 g-mb-5 DashBoder2 \">";
							content += "	<div class=\"spnTit col-md-4 col-sm-4 col-xs-4\" >Shipped";
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_cnt_550;
							content += "	</div>";
							content += "	<div class=\"col-md-4 col-sm-4 col-xs-4\" >";
							content += rowsTc[0].v_o_cnt_550;
							content += "	</div>";
							content += "</div>";

							bordTc.append(content);
						}

					});
		}

		function removeTag(html) {
			return html.replace(/(<([^>]+)>)/gi, "");
		}

		function blockActive19(obj) {
			var bord19 = $("#bord19").find("div.DashBoder");
			for (var i = 0; i < bord19.length; i++) {
				$(bord19[i]).removeClass("dbActive");
			}
			$(obj).addClass("dbActive");
			fnGetImage19();
		}

		function fnGetImage19() {
			var bord19 = $("#bord19").find("div.DashBoder");
			var ATCH_GRUP;
			var ATCH_NO;
			for (var i = 0; i < bord19.length; i++) {
				if ($(bord19[i]).hasClass("dbActive")) {
					ATCH_GRUP = $(bord19[i]).children(".BORD_GRUP").val();
					ATCH_NO = $(bord19[i]).children(".BORD_NO").val();
				}
			}

			var rows;
			$.ajax({
				url : getUrl("/common/board/searchbordimg.json"),
				dataType : "text",
				type : 'post',
				data : {
					ATCH_GRUP : ATCH_GRUP,
					ATCH_NO : ATCH_NO
				},
				success : function(result) {
					var obj = JSON.parse(result);
					rows = obj.rows;
				},
				error : function(result) {
				},
				complete : function() { // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
					//
					if (rows.length > 0) {
						var fp = rows[0].FULL_PATH;
						fp = fp.replace('.pdf', '-ThumbNail.png');
						$("#SalesImg").prop("src", fp);

					} else {
						$("#SalesImg").prop("src", "");
					}
				}
			});

		}

		function blockActive17(obj) {
			var bord17 = $("#bord17").find("div.DashBoder");
			for (var i = 0; i < bord17.length; i++) {
				$(bord17[i]).removeClass("dbActive");
			}
			$(obj).addClass("dbActive");
			fnGetImage17();
		}

		function fnGetImage17() {
			var bord17 = $("#bord17").find("div.DashBoder");
			var ATCH_GRUP;
			var ATCH_NO;
			for (var i = 0; i < bord17.length; i++) {
				if ($(bord17[i]).hasClass("dbActive")) {
					ATCH_GRUP = $(bord17[i]).children(".BORD_GRUP").val();
					ATCH_NO = $(bord17[i]).children(".BORD_NO").val();
				}
			}

			var rows;
			$.ajax({
				url : getUrl("/common/board/searchbordimg.json"),
				dataType : "text",
				type : 'post',
				data : {
					ATCH_GRUP : ATCH_GRUP,
					ATCH_NO : ATCH_NO
				},
				success : function(result) {
					var obj = JSON.parse(result);
					rows = obj.rows;
				},
				error : function(result) {
				},
				complete : function() { // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
					//
					if (rows.length > 0) {
						var fp = rows[0].FULL_PATH;
						fp = fp.replace('.pdf', '-ThumbNail.png');
						$("#NewsImg").prop("src", fp);
					} else {
						$("#NewsImg").prop("src", "");
					}
				}
			});

		}
		
		// 팝업 제목 클릭 시 오픈
          function notiPopup () {
        	jwidget.popup.open(popupList[notiIndex]);
          }
		
          function notiUp() {
            	notiIndex = (notiIndex - 1 + popupList.length) % popupList.length;
            	$("#notiTit").text(popupList[notiIndex].bordTitle);
              }
              
          function notiDown() {
           	notiIndex = (notiIndex + 1) % popupList.length;
           	$("#notiTit").text(popupList[notiIndex].bordTitle);
           	//console.log("notiDown")
           	
           	if(popupList.length < 2) {
           	  	clearInterval(notiSlide);
           		//console.log("notiDown clearInterval")
           	}
          }
              

		
	</script>
	<style id='style'>
#bord-popup-dialog .panel-header {
	padding-left: 15px !important;
	border-bottom: 1px solid #ccc !important;
}

.forcedLeft {
	left: 2px !important;
	top: 35px !important;
}

.window-shadow {
	display: none !important;
}

.forcedTable th {
	width: 70px !important;
}

#main1 {
	min-height: 150px;
	width: 295px;
	margin-bottom: -10px;
}

#main2 {
	min-height: 150px;
	width: 295px;
	margin-bottom: -10px;
}

#main3 {
	min-height: 150px;
	width: 295px;
	margin-bottom: -10px;
}

#main1 .span {
	padding-left: 70px;
}

#main2 .span {
	padding-left: 40px;
}

#main3 .span {
	padding-left: 20px;
}

@media screen and (max-width: 421px) {
	#main1 {
		width: 295px;
		float: left;
		min-height: 150px;
		margin-bottom: 10px;
		padding-left: 15px
	}
	#main2 {
		width: 295px;
		min-height: 150px;
		margin-bottom: 10px;
		padding-left: 15px
	}
	#main3 {
		width: 295px;
		min-height: 150px;
		margin-bottom: 10px;
		padding-left: 15px
	}
	#main1 .span {
		text-align: center
	}
	#main2 .span {
		text-align: center
	}
	#main3 .span {
		text-align: center
	}
	.float-frame {
		overflow: auto;
		text-align: center;
	}
	#bord-popup-dialog {
		height: 545px !important;
	}
	.wui-tareas {
		padding: 10px;
		height: 231px
	}
}

@media screen and (min-width: 421px) {
	.wui-tareas {
		padding: 10px;
		height: 354px
	}
	#bord-popup-dialog {
		height: 700px !important;
	}
	.float-frame {
		overflow: auto;
		text-align: center;
		width: 900px;
		height: 230px;
	}
}

.float-unit {
	align: center;
	font-weight: bold;
	float: left;
}

.in {
	display: inline-block;
}

#main-navbar {
	position: fixed;
	width: 100%;
}
/* #navbar-inner{ background-color: #ffffff;} */
.txc-image {
	width: 100%;
}

#loadingProgressBar {
	width: 100%;
	height: 100%;
	position: absolute;
	background-color: white;
	z-index: 999;
}
/* .col-md-12{
			height: 38px;
		} */
.MainConA .DashBoder2 {
	/* 			max-width: 490px; */
	
}

.main-bord .g-mb-5 {
	margin-bottom: 0px !important;
}

.main-bord .MainConA {
	/* height: 270px; */
	height: 236px;
	/* padding-bottom: 10px; */
	/* box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.2);  */
	border-top: 0;
    border-bottom: 0;
}

.main-bord .MainConB {
	/* height: 270px; */
	height: 216px;
	/* padding-bottom: 10px; */
	/* box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.2);  */
}

.main-bord .MainConC {
	/* height: 270px; */
	height: 216px;
	/* padding-bottom: 10px; */
	/* box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.2);  */
}

.MainConA, .MainConB, .MainConC {
	padding: 0;
}

.main-bord-bottom {
	width: 100%;
	height: 40px;
	line-height: 40px;
	font-weight: bold;
	text-align: center;
	/* background-color: #FAFCFF !important; */
	background-color: #DFE8F4 !important;
	border-bottom-left-radius: 16px !important;
	border-bottom-right-radius: 16px !important;
	border: 1px solid #eeeff2 !important;
}

.main-bord-bottom > a {
	color: #1869C1;
	font-size: 15px;
	font-weight: 400;
}

.DashBoder {
	height: 42px;
	padding: 10px;
}
/* 
.DashBoder2 {
	height: 42px;
	padding: 10px;
}
 */
.qMenu {
	width: 100%;
	padding: 20px;
	/* background-color: #e0e0e0; */
	background-color: #f5f5f5;
	border-radius: 16px;
	font-weight: 600;
	color: #000000;
	margin-top: 5px;
	font-size: 17px;
	cursor: pointer;
	text-align: center;
}

.appendDiv > div:not(.listHDiv):not(.float-unit) {
   	height: 40px;
   	padding: 0px 20px;
   	border-bottom: 1px solid #e5e5e5;
}

.appendDiv > div:not(.listHDiv) > .spnTit {
	font-size: 15px !important;
	color: #191e3a !important;
	padding-left: 0 !important;
	line-height : 40px !important;
	/* text-align: center !important;
    		font-weight: bold; */
}

.appendDiv > div:not(.listHDiv) > div:not(.spnTit) {
   		font-size: 17px !important;
  		color: #1869C1 !important;
  		/* text-align: center !important;
  		font-weight: bold; */
   }

.listHDiv {
	color: #757575 !important;
	background-color: #e1e1e1;
	padding: 0 20px;
	border-bottom: 1px solid #e5e5e5;
	font-size: 15px !important;
}
/* 
	    .listHDiv > div {
	    	font-size: 15px !important;
	    	font-weight: bold;
	    }
	     */
.appendDiv > div {
	font-weight: 400 !important;
}

.appendDiv > div > div:not(.spnTit) {
   	text-align: center !important;
   }

.bordTitle {
	font-size: 15px;
	/* font-weight: 400 !important; */
	width: calc(100% - 127px);
	/* display: inline-flex; */
	display: inline-block;
}

.bordDt {
	font-size: 14px;
	font-weight: 400;
	width: 100px;
	display: inline-flex;
}

.bordMore {
	font-size: 14px;
	font-weight: 400;
	width: 20px;
	display: inline-flex;
	color: #cacaca;
}

.dt04 {
	width: 17% !important;
}

.dspIb {
	display: inline-block !important;
}

.wd30 {
	width: 30% !important;
}

.rts04footer, .dt04footer {
	display: block !important;
}

.notification-container {
      display: flex;
      align-items: flex-start;
      /* border: 1px solid #ddd;
      border-radius: 8px;
      max-width: 900px;
      background-color: #f9f9f9;
      padding: 10px 15px; */
      position: relative;
      padding: 10px;
    }

    .noti_icon {
      margin-right: 10px;
      /* color: #1a73e8;
      font-size: 20px; */
      padding: 10px 0;
    }

    .noti_content {
      flex: 1;
      overflow: hidden;
      text-align: left;
    }

    .notiTit {
      font-weight: bold;
      color: #333;
      padding: 11px 0;
      cursor: pointer;
      font-size: 15px;
      width: 70%;
    }

    .noti_message {
      color: #555;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .noti_scroll-buttons {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      margin-left: 10px;
      margin-top: 2px;
    }

    .noti_scroll-button {
      width: 20px;
      height: 20px;
      text-align: center;
      line-height: 18px;
      cursor: pointer;
      color: #888;
      font-size: 12px;
      border-radius: 50%;
    }

    .noti_scroll-button:hover {
      background-color: #ddd;
    }
    
      .dt05footer {
	    	width: 100%;
	    }
	    
	.ordrAbbrSpn {
    	position: absolute;
    	right: 10px;
    }
    
    .noDataSyl {
    	margin: 0 auto; 
    	width: 100%; 
    	height: 100% !important;
    	font-size: 12px; 
    	color: gray; 
    	display: flex; 
    	justify-content: center; 
    	align-items: center; 
    	text-align: center;
    }
    
    .scrlCst {
    	overflow-y : scroll;
    	scrollbar-width: thin;
    }
    
    ::-webkit-scrollbar {
	  width: 10px; /* 세로 스크롤 너비 */
	  height: 10px; /* 가로 스크롤 높이 */
	}
    
    /* Chrome, Edge, Safari */
	.scroll-area::-webkit-scrollbar {
	  width: 12px; /* 세로 스크롤 너비 */
	  height: 12px; /* 가로 스크롤 높이 */
	}
	
	.scroll-area::-webkit-scrollbar-track {
	  background: #f1f1f1;
	}
	
	.scroll-area::-webkit-scrollbar-thumb {
	  background-color: #888;
	  border-radius: 6px;
	  border: 3px solid #f1f1f1; /* thumb 안쪽 여백 */
	}
	
	.scroll-area::-webkit-scrollbar-thumb:hover {
	  background: #555;
	}

	.backLogo {
		background-image: url('resources/images/lsta_logo.png');
		background-repeat: no-repeat;
	  	background-position: center center;
	  	background-size: 40%;
	  	
	  	/* display: flex; 
	  	justify-content: center; 
	  	align-items: center; */
	}
		
   

</style>
</head>




<body class="easyui-layout" id="main-layout">

	<!-- 상단레이아웃 =========================================================== -->
	<%@ include file="/WEB-INF/views/include/head.jsp"%>

	<!-- 화면 첫 로딩시 필요한 ProgressBar -->
	<div id="loadingProgressBar">
		<br></br>
		<center>
			<img src="<%=request.getContextPath()%>/resources/images/ajax_loader_red_48.gif"></img>
		</center>
	</div>

	<!-- [LAYOUT] start -->
	<div class="easyui-layout" data-options="fit:true">
		<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}" />
		<input type="hidden" name="userType" id="s_userType" value="${userType}" />
		<input type="hidden" name="hOrgAuthCode" id="hOrgAuthCode" value="${user.orgAuthCode}" />
		<input type="hidden" name="user_gd" id="user_gd" value="${user.orgAuthCode}" />
		<input type="hidden" name="user_id" id="user_id" value="${user.userId}" />
		<input type="hidden" name="userDashType" id="userDashType" value="${user.dashType}" />

		<%-- <center> --%>

			<!-- <div class="header" style="padding-top: 16px; margin-top: 16px;"> -->
			<div class="header" style="padding-top: 16px; ">
				<div style="width: 34px; height: 34px; position: relative;">
					<!-- <i class="fa fa-user fa-2x" aria-hidden="true" style="text-align: left;position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); color:white; font-size: 22px;"></i> -->
					<img style="width: 34px; height: 34px;" src="<%=request.getContextPath()%>/resources/images/icon_new/T.png" />
				</div>
				<div>
					<div style="margin-left: 16px;">
						<span style="font-size: 20px; font-weight: 600;">${user.userName}</span>
						<span style="font-size: 14px; font-weight: 400;">Welcome!!</span>
					</div>
				</div>
			</div>
	
			<div class="col-md-10 col-sm-12 col-xs-12 container">
				<div class="notification-container">
				  <div class="noti_icon">
				    <img style="width: 24px; height: 24px; margin-right: 5px;" alt="" src="<%=request.getContextPath() %>/resources/images/icon_new/volume_high_blue.png">
				  </div>
				  <div class="noti_content">
				    <div class="notiTit" id="notiTit" onclick="notiPopup();"></div>
				  </div>
				  <div class="noti_scroll-buttons">
				    <div class="noti_scroll-button" onclick="notiUp();" >&#9650;</div>
				   	<div class="noti_scroll-button" onclick="notiDown();" >&#9660;</div>
				  </div>
				</div>
				
			</div>
			
			<div class="col-md-12 col-sm-12 col-xs-12 pdl-0 pdr-0 backLogo" style="height: calc(100% - 200px);">
				<%-- <img class="logoImg" src="<c:url value="/resources/images/lsta_logo.png" />" style="width: 40%; min-width: 300px;" > --%>
			</div>
	
			<!-- <div class="col-md-2 col-sm-6 col-xs-6" id="buttonDashArea"
				style="padding-left: 0px; padding-right: 0px; width: 16.7%; float: left; margin-top: 15px;">
			</div> -->
		<%-- </center> --%>

		<!-- [LAYOUT] end -->
	</div>
	<!-- 세션의 초기화를 위한 히든 form 삭제 하면 안됨 -->
	<form id="hidden-form" method="post">
		<input type="hidden" name="oper" id="h_oper" value="" />
		<input type="hidden" name="bordNo" id="h_bordNo" value="" />
		<input type="hidden" name="sysId" id="h_sysId" value="${model.sysId}" />
		<input type="hidden" name="bordGrup" id="h_bordGrup" value="B01" />
		<input type="hidden" name="bordType" id="h_bordType"
			value="${model.bordType}" />
		<input type="hidden" name="searchKey" id="h_searchKey"
			value="${model.searchKey}" />
		<input type="hidden" name="searchText" id="h_searchText"
			value="${model.searchText}" />
		<input type="hidden" name="rows" id="h_rows" value="${model.rows}" />
		<input type="hidden" name="page" id="h_page" value="${model.page}" />
	</form>
	<form id="bord-search-form" method="post">
		<input type="hidden" name="atchNo" id="h_atchNo" value="" />
		<input type="hidden" name="atchGrup" id="h_atchGrup" value="" />
	</form>
	<input type="hidden" name="text_menuKey" id="text_menuKey"
		value="${menuKey}" />
	<!-- 하단레이아웃 =========================================================== -->
	<%-- <%@ include file="/WEB-INF/views/include/foot.jsp"%> --%>

	<!-- 팝업용 레이어 -->
	<div id="popup-dialog"></div>
	<!-- 알림방 및 자료실 -->
	<%-- <div id="bord-popup-dialog" class="wui-dialog"
		style="border-top-width: 1px; height: 700px !important;">

		<table cellpadding="5" cellspacing="2" class="adjust-select">
			<tr>
				<th data-item="LAB_005"><span>제목</span>${model.button_stts}</th>
				<td colspan="3" style="border: 0px;"><span id="v_bordTitle"></span></td>
			</tr>
			<tr>
				<th data-item="LAB_006"><span>작성자</span></th>
				<td><span id="v_regiName"></span></td>
				<th data-item="LAB_007"><span>조회수 </span></th>
				<td><span id="v_readCnt"></span></td>
			</tr>
			<tr>
				<th data-item="LAB_008"><span>등록일</span></th>
				<td><span id="v_regiDate"></span></td>
				<th data-item="LAB_009"><span>수정일</span></th>
				<td><span id="v_chngDate"></span></td>
			</tr>
		</table>
		<div class="easyui-panel wui-tareas" title="내용">
			<span id="v_bordText"></span>
		</div>

		<div class="wui-upload" style="height: 130px">
			<!-- <div id="select-fileupload"></div> -->
			<div class="panel-header" style="border-top: 1px solid #ccc;">
				<div class="panel-title">첨부파일</div>
				<div class="panel-tool"></div>
			</div>
			<table id="select-fileupload">
				<thead>
					<tr>
						<th
							data-options="field:'fileName',   halign:'center', align:'left', data_item:'GRD_001'"
							width="40%">파일명</th>
						<th
							data-options="field:'fileSize', halign:'center', align:'center', data_item:'GRD_002'"
							width="20%">파일크기</th>
						<th
							data-options="field:'fileType',   halign:'center', align:'center', data_item:'GRD_003'"
							width="20%">파일타입</th>
						<th
							data-options="field:'fileDown', halign:'center', align:'center', data_item:'GRD_004',
							styler: function(value,row,index) {
		    						return {class:'icon-saveblack'}
			    				}"
							width="20%">다운로드</th>
					</tr>
				</thead>
			</table>
		</div>
	</div> --%>

</body>

</html>
