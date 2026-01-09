<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)topnav.jsp 1.0 2016/09/20                                          --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 컨텐츠 내에 상단 내비 화면이다.                                                 --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2016/09/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- 
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>

<input type="hidden" name="BAS" id="BAS" value="${BAS}" /> <!--기본  -->
<input type="hidden" name="INS" id="INS" value="${INS}" /> <!--등록  -->
<input type="hidden" name="RET" id="RET" value="${RET}" /> <!--조회  -->
<input type="hidden" name="UPD" id="UPD" value="${UPD}" /> <!--수정  -->
<input type="hidden" name="DEL" id="DEL" value="${DEL}" /> <!--삭제  -->
<input type="hidden" name="AUP" id="AUP" value="${AUP}" /> <!--권한P -->
<input type="hidden" name="AUS" id="AUS" value="${AUS}" /> <!--권한S -->
<input type="hidden" name="AU1" id="AU1" value="${AU1}" /> <!--권한1 -->
<input type="hidden" name="AU2" id="AU2" value="${AU2}" /> <!--권한2 -->
<input type="hidden" name="AU3" id="AU3" value="${AU3}" /> <!--권한3 -->
<input type="hidden" name="AU4" id="AU4" value="${AU4}" /> <!--권한4 -->
<input type="hidden" name="AU5" id="AU5" value="${AU5}" /> <!--권한5 -->
 --%>
<%-- <div id="topnavSubMsgDiv" class="topnavSubMsg" style="color:${msgFontColor};"><b><span id="s_topnavSubMsg">${menuMsg}</span></b></div> --%>
<%-- <img style="width:24px; height:24px;" src="<%=request.getContextPath() %>/resources/images/tit_icons/webcart.png" /> --%>
<!-- justify-content: space-between; -->

<div class="topnav_div <c:choose><c:when test="${empty iconCls || iconCls eq ''}">default</c:when><c:otherwise>${iconCls}</c:otherwise></c:choose>" style="display:flex; flex: 1; margin: 0 10px; color: #000000; font-size: 15px; font-weight: 400; align-items: center;">
	<div>
	<c:choose>
		<c:when test="${groupIdC eq 'DEVADMIN4'}">
			<!-- Home >  -->
			${parentDesc} > <a href="javascript:void(0)" onclick="javascript:langTextSave()"><b>${menuDesc} </b></a>
		</c:when>
		<c:otherwise>
			<!-- Home >  -->
			${parentDesc} >
			<a href="javascript:void(0)" onclick="javascript:menuHelp('${menuKey}','${menuUrl}');">
				<b>${menuDesc}</b>
			</a>
			<c:if test="${not empty menuUrl}">
				<span id="menuHelpIcon" style="display:none;">
					<i class="fa fa-question-circle"
					   style="cursor:pointer; font-size:14px; transform:translate(-2px, -6px); color:#337ab7;"
					   title="Help"
					   onclick="javascript:menuHelp('${menuKey}','${menuUrl}');">
					</i>
				</span>
			</c:if>
		</c:otherwise>
	</c:choose>
	</div>

	<c:if test="${not empty menuMsg}">
		<div id="topnavSubMsgDiv" class="topnavSubMsg" style="color:${msgFontColor}; text-align: right;"><b><span id="s_topnavSubMsg">${menuMsg}</span></b></div>
	</c:if>
</div>

<script>
	$(function() {
		toggleMenuHelpIcon();
	});

	function toggleMenuHelpIcon() {
		var menuUrl = '<c:out value="${menuUrl}" />';
		if (!menuUrl) {
			return;
		}

		$.ajax({
			url: getUrl("/common/board/navHelp/exists.json"),
			type: "post",
			dataType: "json",
			data: {
				bordNo: menuUrl,
				sysId: gconsts.SYS_ID || '',
				bordGrup: 'H01'
			},
			success: function(res) {
				if (res && (res.exists === true || res.exists === 'true')) {
					$("#menuHelpIcon").show();
				} else {
					$("#menuHelpIcon").hide();
				}
			},
			error: function() {
				$("#menuHelpIcon").hide();
			}
		});
	}

	//메뉴얼 팝업창 띄우기
	function menuHelp(menuKey, menuUrl) {
		var _width = '1200';
	    var _height = '800';
	 
	    // 팝업을 가운데 위치시키기 위해 아래와 같이 값 구하기
	    var _left = Math.ceil(( window.screen.width - _width )/2);
	    var _top = Math.ceil(( window.screen.height - _height )/2); 
		
		let menualPop;
		let menualUrl = "";
		if( gconsts.ADMIN == 'Y' ) {
			//1. 관리자일 경우 매뉴얼 등록 및 수정화면
			menualUrl = "/common/board/navHelp/form.do";
		}
		else {
			//2. 그 외에는 상세화면
			menualUrl = "/common/board/navHelp/view.do";
		}	
		
		//menualPop = window.open(context + menualUrl + '?menuKey='+menuKey, 'menual_'+menuKey,'width='+ _width +',height='+ _height +',left=' + _left + ',top='+ _top);
		menualPop = window.open(context + menualUrl + '?bordNo='+menuUrl, 'menual_'+menuKey,'width='+ _width +',height='+ _height +',left=' + _left + ',top='+ _top);
	
		/* 
		let params = {
			"menuKey": menuKey
		};
		
		$.ajax({
			url: getUrl("/common/board/help"),
	        dataType: 'json',
	        data: params,
	        type: 'post',
			success: function(data) {
				//권한에 따라 오픈
				let menualPop;
				if( true ) {
					//1. 관리자일 경우 매뉴얼 등록 및 수정화면
					menualPop = window.open("");
				}
				else {
					//2. 그 외에는 상세화면
					menualPop = window.open("");
				}
				
			}
		});
		 */
		
	}
</script>
