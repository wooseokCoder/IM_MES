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
<script type="text/javascript" src="<c:url value="/resources/js/common/lstractor/dashboardview.js?v=1202A" />"></script>
<script type="text/javascript" src="https://public.tableau.com/javascripts/api/tableau-2.min.js"></script>
<style>
	.col-md-12 {
		position: relative;
		margin-top: 20px;
		height: 97%;
	}
	.col-md-2 {
		position: relative;
		height: 100%;
		overflow-y: scroll;
		padding-right: 15px;
	}
	.col-md-2::-webkit-scrollbar { -webkit-appearance: none;} 
	.col-md-2::-webkit-scrollbar:vertical { width: 12px; } 
	.col-md-2::-webkit-scrollbar:horizontal { height: 12px; }
	.col-md-2::-webkit-scrollbar-thumb { background-color: #b5b5b5; border-radius: 10px; border: 2px solid #ffffff;}
	.col-md-2::-webkit-scrollbar-track { border-radius: 10px; background-color: #ffffff;}
	
	.col-md-10 {
		padding-left: 30px;
	}
	.dashboard-menu {
		width: 100%;
		height: 100%;
	}
	.dashboard-menu a {
		margin-top: 10px;
		display: block;
		position: relative;
	}
	.dashboard-menu a:first-of-type {
		margin-top: 0;
	}
	.dashboard-menu a p {
		font-size: 16px;
		font-weight: bold;
		position: absolute;
		bottom: -6px;
		left: 8px;
	}
	.dashboard-menu a img {
		width: 100%;
		opacity: 1;
		transition: all cubic-bezier(0, 0, 0.21, 0.96) 0.1s;
	}
	.dashboard-menu a img:nth-of-type(2) {
		width: 100%;
		opacity: 0;
		position: absolute;
		left: 0;
		top: 0;
	}
	.dashboard-title {
		font-size: 30px;
		font-weight: bold;
		margin-top: 13px;
	}
	.dashboard-list {
		display: flex;
		flex-wrap: wrap;
		width: 100%;
		background: #f7f7f7;
		padding: 20px;
	}
	.dashboard-list .dashboard-item {
		position: relative;
		width: calc(20% - 30px);
		margin-right: 30px;
	}
	.dashboard-list .dashboard-item:last-of-type {
		margin-right: 0;
	}
	.dashboard-list .dashboard-item .dashboard-tooltip::before{
		content: '';
		display: block;
	    border-left: 10px solid #dddddd;
	    border-bottom: 10px solid transparent;
	    transform: rotate(180deg);
	    border-right: 10px solid transparent;
	    border-top: 10px solid transparent;
	    position: absolute;
	    left: -20px;
	    top: 39px;
	    z-index: 3;
	}
	.dashboard-list .dashboard-item .dashboard-tooltip {
		position: absolute;
		color: #222;
		/* border: 1px solid #bfbfbf; */
		background-color: #dddddd;
		display: flex;
		align-items: center;
		justify-content: center;
		text-align: center;
		top: 50%;
		left: 50%;
		z-index: 3;
		opacity: 0;
		padding: 0 10px;
		width: 70%;
		min-height: 100px;
		box-shadow: 2px 2px 4px #9d9d9d;
		transition: all ease 0.2s;
	}
	.dashboard-list .dashboard-item:hover .dashboard-tooltip {
		opacity: 1;
	}
	.dashboard-list .dashboard-item:hover::after {
		content: '';
		display: block;
		width: 100%;
		height: calc(100% - 26.5%);
		background: #222;
		opacity: 0.2;
		position: absolute;
		top: 0;
		left: 0;
		z-index: 2;
		transition: all ease 0.2s;
	}
	.dashboard-list .dashboard-item img {
		position: relative;
		z-index: 1;
		width: auto;
		max-width: 100%;
		height: 100%;
	}
	.dashboard-list p {
		width: 100%;
		margin-top: 5%;
		margin-bottom: 10%;
		font-size: 18px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.dashboard-list .img-box {
		position: relative;
		text-align: center;
		width: 100%;
		border: 1px solid #ccc;
		min-height: 180px;
		z-index: 1;
		display: flex;
	    justify-content: center;
	    align-items: center;
	}
	.dashboard-list .dashboard-item .img-box::before {
		content: '';
		position: absolute;
		display: block;
		width: 100%;
		height: 100%;
		background: #fff;
		top: 0;
		left: 0;
		z-index: 1;
	}
	.dashboard-list .dashboard-item .img-box::after {
		content: '';
		position: absolute;
		display: block;
		width: 100%;
		height: 100%;
		border: 1px solid #ccc;
		top: 4px;
		left: 4px;
		z-index: 0;
		box-shadow: 1px 2px 3px #999;
	}
	@media screen and (max-width:990px) {
		#account-layout {
			min-width: auto !important;
		}
		.col-md-12 {
			height: 100%;
		}
		.col-md-2 {
			padding-right: 0;
			height: auto;
			border: none;
			overflow-x: scroll;
			overflow-y: hidden;
		}
		.col-md-10, .col-md-2 {
			width: 100%;
		}
		.col-md-10 {
			padding: 0;
		}
		.dashboard-list p {
			font-size: 16px;
		}
		.dashboard-title {
			font-size: 20px;
		}
		.dashboard-menu {
			height: auto;
			padding-right: 0;
			display: flex;
		}
		.dashboard-menu a:first-of-type {
			margin-left: 0;
		}
		.dashboard-menu a {
			margin-left: 10px;
			margin-top: 0;
			min-width: 195px;
			margin-bottom: 10px;
		}
		.dashboard-menu a p {
			font-size: 14px;
		}
		.dashboard-list .dashboard-item {
			width: calc(50% - 15px);
		}
		.dashboard-list .dashboard-item:nth-of-type(2n) {
			margin-right: 0;
		}
	}
	@media screen and (min-width:991px) and (max-width:1400px) {
		#account-layout {
			min-width: auto !important;
		}
		.col-md-12 {
			height: 100%;
		}
		.col-md-2 {
			padding-right: 0;
			height: auto;
			border: none;
			overflow-x: scroll;
			overflow-y: hidden;
		}
		.col-md-2::-webkit-scrollbar { -webkit-appearance: none;} 
		.col-md-2::-webkit-scrollbar:vertical { width: 12px; } 
		.col-md-2::-webkit-scrollbar:horizontal { height: 12px; }
		.col-md-2::-webkit-scrollbar-thumb { background-color: #b5b5b5; border-radius: 10px; border: 2px solid #ffffff;}
		.col-md-2::-webkit-scrollbar-track { border-radius: 10px; background-color: #ffffff;}
		.col-md-10, .col-md-2 {
			width: 100%;
		}
		.col-md-10 {
			padding: 0;
		}
		.dashboard-list p {
			font-size: 16px;
		}
		.dashboard-title {
			font-size: 20px;
		}
		.dashboard-menu {
			height: auto;
			padding-right: 0;
			display: flex;
		}
		.dashboard-menu a:first-of-type {
			margin-left: 0;
		}
		.dashboard-menu a {
			margin-left: 10px;
			margin-top: 0;
			min-width: 195px;
			margin-bottom: 20px;
		}
		.dashboard-menu a p {
			font-size: 14px;
		}
		.dashboard-list .dashboard-item {
			width: calc(25% - 23px);
		}
		.dashboard-list .dashboard-item:nth-of-type(4n) {
			margin-right: 0;
		}
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
	<div class="col-md-12">
		<div class="col-md-2">
			<div class="dashboard-menu">
				<c:forEach var="item" items="${searchMenu}" varStatus="status">
					<a href="javascript:doDashMenu('${item.EXT_CHR01}')">
						<c:choose>
							<c:when test="${status.index < 7}">
								<img src="<c:url value="/resources/images/tree/${status.index + 1}.png" />"/>
								<img class="hover" src="<c:url value="/resources/images/tree/${status.index + 1}_hover.png" />"/>
							</c:when>
							<c:when test="${status.index >= 7}">
								<img src="<c:url value="/resources/images/tree/7.png" />"/>
								<img src="<c:url value="/resources/images/tree/7_hover.png" />"/>
							</c:when>
						</c:choose>
						<p>${item.EXT_CHR01}</p>
					</a>
				</c:forEach>
			</div>
		</div>
		<div class="col-md-10">
			<p class="dashboard-title">${sdv[0].menu}</p>
			<div class="dashboard-list">
				<c:forEach var="items" items="${sdv}">
					<c:if test="${items.no eq '1'}">
						<a href="javascript:doTableu('${items.link}')" class="dashboard-item">
							<div class="dashboard-tooltip">
								${items.tooltip}
							</div>
							<div class="img-box">
								<img src="<c:url value="https://dealerportal.lstractorusa.com/lsdp_data/upload/real/DB/${items.saveName}"/>" onerror="this.src='<%=request.getContextPath() %>/resources/images/tree/no-image-icon.png'" />
								<!-- <img src="<c:url value="http://52.40.215.183:8080/lsdp_data/upload/real/DB/${items.saveName}"/>" onerror="this.src='<%=request.getContextPath() %>/resources/images/tree/no-image-icon.png'" />  -->
							</div>
							<p>${items.title}</p>
						</a>
					</c:if>
				</c:forEach>
			</div>
		</div>
	</div>
<!-- [LAYOUT] end -->
</div>

<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;display:none;">
	<div class="easyui-layout"  data-options="fit:true" onload="initViz();" style="overflow-y:scroll;height:600px;">
		<div id="vizContainer" style="width:1400px; height: 750px;"></div> <!-- style="width:100%;" -->
	</div>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
