<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)index02.jsp 1.0 2025/12/22                                           --%>
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
<%-- 대시보드 화면 (dash_type = DT02)                                        --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2025/12/22                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp"%>
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
	<link rel="stylesheet" type="text/css"
		href="<c:url value="/resources/css/index.css?v=251120A" />" />
	<script type="text/javascript" src="<c:url value="/resources/js/chartjs/Chart.bundle.js" />"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/index02.js?v=251120A" />"></script>
	<style>
		.dashboard-container {
			padding-top: 10px;
			width: 100%;
			max-width: 100%;
			box-sizing: border-box;
			overflow: hidden;
			margin: 0 auto;
			height: 100%;
		}
		
		.dashboard-header {
			margin-bottom: 20px;
		}
		
		.dashboard-header h1 {
			font-size: 24px;
			font-weight: 600;
			margin: 0;
			color: #333;
		}
		
		.dashboard-header h2 {
			font-size: 16px;
			font-weight: 400;
			margin: 5px 0 0 0;
			color: #666;
		}
		
		.dashboard-grid {
			display: grid;
			grid-template-columns: 1fr 1fr 300px;
			grid-template-rows: 1fr 1fr;
			gap: 10px;
			margin-bottom: 0;
			width: 100%;
			height: 100%;
		}
		
		.dashboard-grid .quick-link-card {
			grid-row: span 2;
		}
		
		.dashboard-card {
			background: #fff;
			border: 1px solid #e5e5e5;
			border-radius: 8px;
			padding: 10px;
			box-shadow: 0 2px 4px rgba(0,0,0,0.1);
			box-sizing: border-box;
			display: flex;
			flex-direction: column;
			width: 100%;
			height: 100%;
			overflow: hidden;
		}
		
		.dashboard-card h3 {
			font-size: 16px;
			font-weight: 600;
			margin: 0 0 8px 0;
			color: #333;
			border-bottom: 2px solid #1869C1;
			padding-bottom: 5px;
		}
		
		.stats-table {
			width: 100%;
			border-collapse: collapse;
			flex: 1;
		}
		
		.dashboard-card > div:has(table) {
			flex: 1;
			display: flex;
			flex-direction: column;
			overflow: auto;
		}
		
		.stats-table th {
			text-align: left;
			padding: 5px;
			font-weight: 600;
			color: #666;
			border-bottom: 1px solid #e5e5e5;
			font-size: 13px;
		}
		
		.stats-table td {
			padding: 5px;
			border-bottom: 1px solid #f0f0f0;
			font-size: 13px;
		}
		
		.stats-table tr:last-child td {
			border-bottom: none;
		}
		
		.stats-value {
			font-size: 14px;
			font-weight: 600;
			color: #1869C1;
		}
		
		.quick-link-container {
			display: flex;
			flex-direction: column;
			gap: 8px;
			justify-content: flex-start;
			align-items: stretch;
			padding: 10px 0;
		}
		
		.quick-link-btn {
			width: 100%;
			padding: 10px 15px;
			background: #f5f5f5;
			border: 1px solid #e5e5e5;
			border-radius: 6px;
			font-size: 14px;
			font-weight: 500;
			color: #333;
			cursor: pointer;
			text-align: center;
			transition: all 0.3s;
			white-space: nowrap;
		}
		
		.quick-link-btn:hover {
			background: #1869C1;
			color: #fff;
			border-color: #1869C1;
		}
		
		.quick-link-btn.gray {
			background: #666;
			color: #fff;
			border-color: #666;
		}
		
		.quick-link-btn.gray:hover {
			background: #555;
			border-color: #555;
		}
		
		@media screen and (max-width: 1200px) {
			.dashboard-grid {
				grid-template-columns: 1fr;
			}
		}
		
		.header {
			display: flex;
			align-items: center;
			margin-bottom: 10px;
		}
		
		.notification-container {
			display: flex;
			align-items: flex-start;
			position: relative;
			padding: 10px;
		}
		
		.noti_icon {
			margin-right: 10px;
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
		
		.backLogo {
			background-image: url('resources/images/lsta_logo.png');
			background-repeat: no-repeat;
			background-position: center center;
			background-size: 40%;
			overflow: hidden;
			display: flex;
			flex-direction: column;
		}
		
		/* Chrome, Edge, Safari */
		.scroll-area::-webkit-scrollbar {
			width: 12px;
			height: 12px;
		}
		
		.scroll-area::-webkit-scrollbar-track {
			background: #f1f1f1;
		}
		
		.scroll-area::-webkit-scrollbar-thumb {
			background-color: #888;
			border-radius: 6px;
			border: 3px solid #f1f1f1;
		}
		
		.scroll-area::-webkit-scrollbar-thumb:hover {
			background: #555;
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
						<span style="font-size: 14px; font-weight: 400; color: #0969da; padding-left: 7px;">Welcome!!</span>
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
				
				<div class="dashboard-container">
					<div class="dashboard-grid">
						<div class="dashboard-card">
							<h3>Wholegoods Order Status</h3>
							<table class="stats-table">
								<thead>
									<tr>
										<th></th>
										<th>Tractor</th>
										<th>Others</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><strong>Ordered</strong></td>
										<td class="stats-value" style="color: red;">3,334</td>
										<td class="stats-value" style="color: red;">3,788</td>
									</tr>
									<tr>
										<td><strong>Reviewed</strong></td>
										<td class="stats-value" style="color: red;">740</td>
										<td class="stats-value" style="color: red;">832</td>
									</tr>
									<tr>
										<td><strong>Confirmed</strong></td>
										<td class="stats-value" style="color: red;">99</td>
										<td class="stats-value" style="color: red;">130</td>
									</tr>
									<tr>
										<td><strong>RTS</strong></td>
										<td class="stats-value" style="color: red;">13</td>
										<td class="stats-value" style="color: red;">14</td>
									</tr>
									<tr>
										<td><strong>Shipped</strong></td>
										<td class="stats-value" style="color: red;">78</td>
										<td class="stats-value" style="color: red;">89</td>
									</tr>
								</tbody>
							</table>
						</div>

						<!-- 파란 박스: 하드코딩 데이터 -->
						<div class="dashboard-card">
							<h3>Annual Plan vs. Actual Performance</h3>
							<div style="position: relative; height: 100%; padding: 5px; flex: 1; min-height: 200px;">
								<canvas id="performanceChart"></canvas>
							</div>
						</div>

						<div class="dashboard-card quick-link-card">
							<h3>Quick Link</h3>
							<div class="quick-link-container">
								<button class="quick-link-btn" onclick="doMemuGo('LS101')">
									Location Manager
								</button>
								<button class="quick-link-btn" onclick="doMemuGo('LS102')">
									Sample Board
								</button>
								<button class="quick-link-btn" onclick="doMemuGo('LS103')">
									Auto Login
								</button>
								<button class="quick-link-btn gray" onclick="doMemuGo('LS104')">
									WSDL Test
								</button>
							</div>
						</div>
						
						<!-- 하단 첫 번째 카드: Wholegoods Open Order Aging -->
						<div class="dashboard-card">
							<h3>Wholegoods Open Order Aging</h3>
							<div style="margin-bottom: 10px;">
								<select style="padding: 5px; border: 1px solid #ddd; border-radius: 4px;">
									<option>Tractor</option>
									<option>Others</option>
								</select>
							</div>
							<table class="stats-table">
								<thead>
									<tr>
										<th></th>
										<th>~30D</th>
										<th>~60D</th>
										<th>~90D</th>
										<th>90D~</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><strong>Ordered</strong></td>
										<td class="stats-value" style="color: red;">1,345</td>
										<td class="stats-value" style="color: red;">0</td>
										<td class="stats-value" style="color: red;">59</td>
										<td class="stats-value" style="color: red;">1,930</td>
									</tr>
									<tr>
										<td><strong>Reviewed</strong></td>
										<td class="stats-value" style="color: red;">600</td>
										<td class="stats-value" style="color: red;">69</td>
										<td class="stats-value" style="color: red;">35</td>
										<td class="stats-value" style="color: red;">36</td>
									</tr>
									<tr>
										<td><strong>Confirmed</strong></td>
										<td class="stats-value" style="color: red;">49</td>
										<td class="stats-value" style="color: red;">27</td>
										<td class="stats-value" style="color: red;">9</td>
										<td class="stats-value" style="color: red;">14</td>
									</tr>
									<tr>
										<td><strong>RTS</strong></td>
										<td class="stats-value" style="color: red;">13</td>
										<td class="stats-value" style="color: red;">0</td>
										<td class="stats-value" style="color: red;">0</td>
										<td class="stats-value" style="color: red;">0</td>
									</tr>
									<tr>
										<td><strong>Shipped</strong></td>
										<td class="stats-value" style="color: red;">58</td>
										<td class="stats-value" style="color: red;">4</td>
										<td class="stats-value" style="color: red;">2</td>
										<td class="stats-value" style="color: red;">14</td>
									</tr>
								</tbody>
							</table>
						</div>

						<!-- 하단 두 번째 카드: Whole Sales Report -->
						<div class="dashboard-card">
							<h3>Whole Sales Report</h3>
							<table class="stats-table">
								<thead>
									<tr>
										<th></th>
										<th>NC</th>
										<th>TX</th>
										<th>CA</th>
										<th>ON</th>
										<th>Total</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><strong>Monthly Target</strong></td>
										<td class="stats-value">260</td>
										<td class="stats-value">220</td>
										<td class="stats-value">50</td>
										<td class="stats-value">20</td>
										<td class="stats-value">550</td>
									</tr>
									<tr>
										<td><strong>MTD Actual Sales</strong></td>
										<td class="stats-value">179</td>
										<td class="stats-value">84</td>
										<td class="stats-value">52</td>
										<td class="stats-value">0</td>
										<td class="stats-value">315</td>
									</tr>
									<tr>
										<td><strong>Traffic Light</strong></td>
										<td class="stats-value" style="color: red;">78%</td>
										<td class="stats-value" style="color: red;">43.4%</td>
										<td class="stats-value" style="color: green;">119.5%</td>
										<td class="stats-value" style="color: red;">0%</td>
										<td class="stats-value" style="color: red;">65%</td>
									</tr>
									<tr>
										<td><strong>Daily Target</strong></td>
										<td class="stats-value">15.3</td>
										<td class="stats-value">12.9</td>
										<td class="stats-value">2.9</td>
										<td class="stats-value">1.2</td>
										<td class="stats-value">32.3</td>
									</tr>
									<tr>
										<td><strong>Actual Sales (Avg/Day)</strong></td>
										<td class="stats-value">11.9</td>
										<td class="stats-value">5.6</td>
										<td class="stats-value">3.5</td>
										<td class="stats-value">0</td>
										<td class="stats-value">21</td>
									</tr>
									<tr>
										<td><strong>Expected monthly Closing</strong></td>
										<td class="stats-value">203</td>
										<td class="stats-value">95</td>
										<td class="stats-value">59</td>
										<td class="stats-value">0</td>
										<td class="stats-value">357</td>
									</tr>
									<tr>
										<td><strong>Balance</strong></td>
										<td class="stats-value" style="color: red;">-57</td>
										<td class="stats-value" style="color: red;">-125</td>
										<td class="stats-value" style="color: green;">9</td>
										<td class="stats-value" style="color: red;">-20</td>
										<td class="stats-value" style="color: red;">-193</td>
									</tr>
								</tbody>
							</table>
						</div>

					</div>
				</div>
			</div>
	
		<%-- </center> --%>

	</div>
	<!-- [LAYOUT] end -->
	
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
<%-- 	<%@ include file="/WEB-INF/views/include/foot.jsp"%> --%>

	<!-- 팝업용 레이어 -->
	<div id="popup-dialog"></div>

</body>
</html>

