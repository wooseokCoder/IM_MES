<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)code.jsp 1.0 2014/08/05                                            --%>
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
<%-- 영업일일활동보고 화면이다.                                                       	--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2017/04/24                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/company/saledailyactivityreport.js" />"></script>
<style>

/* pagination css수정 */
.pagination-info{display:none;}
.pagination table td:last-child .l-btn-plain{display:none;}
#item-search-dialog .datagrid .pagination table td:nth-child(3){display:none;}
#item-search-dialog .datagrid .pagination table td:nth-child(11){display:none;}
#account-layout{min-width:1100px !important;}
</style>
</head>

<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<!-- 거래처 팝업 사용하기 위한 코드 POPup -->
<input type="hidden" name="popCustName" id="popCustName" value=""/>
<input type="hidden" name="popCustCode" id="popCustCode" value=""/>
<input type="hidden" name="cShetType" id="cShetType" value="D"/>
<input type="hidden" name="hUserUpprDeptCode" id="hUserUpprDeptCode" value="${userUpprDeptCode}"/>
<input type="hidden" name="hUserDeptCode" id="hUserDeptCode" value="${userDeptCode}"/>
<!-- 거래처 팝업 사용하기 위한 코드 POPup -->

<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" style="display:none">
<div data-options="region:'north',border:false">
<!-- fieldset 구분 변경  20160928 박소현 -->
	<div id="search-toolbar2" class="wui-toolbar">
		<form id="search-form">
			<fieldset class="div-line-new" >
		        <table cellpadding="5" class="search-table tableSearch-c" >
		            <tr>
						<th class="h table-Search-h" data-item="LAB_001"><span>검색기간 </span></th>
						<td class="d">
							<input class="easyui-datebox" name="date1" id="date1" value="${date2}"/>~
							<input class="easyui-datebox" name="date2" id="date2" value="${date2}"/>
						</td>
						<th class="h" data-item="LAB_002"><span>사원명</span></th>
						<td class="d">
							<select class="easyui-combobox" name="salEply" ID="salEply" data-options="width:130">
								<option value="">전체</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'SAL_EPLY_TYPE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>

						<th class="h" data-item="LAB_003"><span>담당부서</span></th>
						<td class="d">
							<select class="easyui-combobox" name="searchStafDept" ID="searchStafDept" data-options="width:100">
								<option value="">전체</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'DEPT_CODE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>

						<td class="b">
							<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001">검색</a>
						</td>
		            </tr>
		        </table>
			</fieldset>

		    <fieldset class="div-line-new-sub">
				<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002">등록</a>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003">삭제</a>
			</fieldset>
				<input type="hidden" id="hdfIndex" value="-1" />
				<input type="hidden" id="hdfChk" value="" />
		</form>
	</div>
<!-- [NORTH1] end -->
</div>

	<!-- [CENTER] start -->
    <div data-options="region:'west',border:false,width:560">
		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox:true,halign:'center',align:'center'"></th>
					<th data-options="field:'shetNoType', halign:'center', align:'center',width:100,hidden:true,data_item:'GRD_001'">등록번호</th>
					<th data-options="field:'shetDate', halign:'center', align:'center',width:100,data_item:'GRD_002', sortable:true">일 자</th>
					<th data-options="field:'shetNT', halign:'center', align:'center',width:100,data_item:'GRD_003', sortable:true">등록번호</th>
					<th data-options="field:'userName', halign:'center',align:'center',width:80,data_item:'GRD_004', sortable:true">보고자</th>
				</tr>
			</thead>
		</table>
	<!-- [CENTER] end -->
	</div>

<!-- [CENTER1] start -->
    <div data-options="region:'center',border:false" style="position:relative;margin-left:10px;border-left:1px solid #dadada">
		<table id="detail-grid">
			<thead>
				<tr>
					<th data-options="field:'d_shetNoSeq', halign:'center', align:'center', width:100,hidden:true,data_item:'GRD_005'">등록번호</th>
					<th data-options="field:'d_custName', halign:'center', align:'left', width:190, data_item:'GRD_006'">업체명</th>
					<th data-options="field:'d_totAmt', halign:'center', align:'right', width:100, data_item:'GRD_007'" formatter="formatNumber">판매액</th>
					<th data-options="field:'d_itemPrce', halign:'center', align:'right',width:100, data_item:'GRD_008'"  formatter="formatNumber">현금수금</th>
					<th data-options="field:'d_itemCost', halign:'center', align:'right',width:100, data_item:'GRD_009'"  formatter="formatNumber">미수입금</th>
					<th data-options="field:'d_totPrce', halign:'center', align:'right',width:100, data_item:'GRD_010'"  formatter="formatNumber">은행송금</th>
					<th data-options="field:'d_totTax', halign:'center', align:'right',width:100, data_item:'GRD_011'"  formatter="formatNumber">어음</th>
					<th data-options="field:'d_remk', halign:'center', width:220, data_item:'GRD_012'">비고</th>
				</tr>
			</thead>
		</table>
    </div>
     <!-- [CENTER1] end -->
     <div data-options="region:'south',border:false" style="height:310px">
	     <fieldset class="div-line-new-sub">
			<span style="font-weight:600;font-size:15px" data-item="LAB_004">▣ 업무보고사항</span>
		</fieldset>
		<form id="detail-form" method="post">
			<input type="hidden" name="dShetType" id="dShetType" />
			<input type="hidden" name="dShetNo" id="dShetNo" />
		</form>
		<table class="sum-count-table">
			<tr>
				<th data-item="LAB_005"><span>전일업무</span></th>
				<th data-item="LAB_006"><span>오늘업무</span></th>
			</tr>
			<tr>
				<td style="width:50%">
					<textarea rows="5" cols="30"  name="remk1" id="d_remk1" style="vertical-align:middle;width:100%;height:236px;resize: none;border:0px;"></textarea>
				</td>
				<td style="width:50%">
					<textarea rows="5" cols="30"  name="remk3" id="d_remk3" style="vertical-align:middle;width:100%;height:236px;resize: none;border:0px;"></textarea>
				</td>
			</tr>
		</table>
	</div>

<!-- [LAYOUT] end -->
</div>
<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>
<!-- 등록화면 -->
<div id="regist-dialog" class="wui-dialog" style="border-top-width:1px;display:none">
	<div class="easyui-layout"  data-options="fit:true">
		<div data-options="region:'center',border:false">
			<table id="search-create-grid">
				<thead>
					<tr>
						<th data-options="field:'shetDate', halign:'center', align:'center',width:100, hidden:true, data_item:'GRD_013'">접수일자</th>
						<th data-options="field:'shetNoSeq', halign:'center', align:'center',width:100, hidden:true, data_item:'GRD_014'">등록번호</th>
						<th data-options="field:'shetType', halign:'center', align:'center',width:100, hidden:true, data_item:'GRD_015'">등록type</th>
						<th data-options="field:'shetSeq', halign:'center', align:'center',width:100, hidden:true, data_item:'GRD_016'">등록seq</th>
						<th data-options="field:'shetNo', halign:'center', align:'center',width:100, hidden:true, data_item:'GRD_017'">등록번호</th>
						<th data-options="field:'custCode', halign:'center', align:'center', width:100, data_item:'GRD_018'">Code</th>
						<th data-options="field:'custName', halign:'center', align:'left', width:190, data_item:'GRD_019'">업체명</th>
						<th data-options="field:'totAmt', halign:'center', align:'right', width:90, editor:{type:'numberbox'}, data_item:'GRD_020'" formatter="formatNumber">판매액</th>
						<th data-options="field:'itemPrce', halign:'center', align:'right', width:90, editor:{type:'numberbox'}, data_item:'GRD_021'"  formatter="formatNumber">현금수금</th>
						<th data-options="field:'itemCost', halign:'center', align:'right', width:90, editor:{type:'numberbox'}, data_item:'GRD_022'"  formatter="formatNumber">미수입금</th>
						<th data-options="field:'totPrce', halign:'center', align:'right', width:90, editor:{type:'numberbox'}, data_item:'GRD_023'"  formatter="formatNumber">은행송금</th>
						<th data-options="field:'totTax', halign:'center', align:'right', width:90, editor:{type:'numberbox'}, data_item:'GRD_024'"  formatter="formatNumber">어음</th>
						<th data-options="field:'remk', halign:'center', width:200, editor:{type:'textbox'}, data_item:'GRD_025'">비고</th>
					</tr>
				</thead>
			</table>
		</div>
		<div data-options="region:'south',border:false" style="height:320px">
		     <fieldset class="div-line-new-sub">
				<span style="font-weight:600;font-size:15px" data-item="LAB_007">▣ 업무보고사항</span>
			</fieldset>
			<table class="sum-count-table">
				<tr>
					<th data-item="LAB_008"><span>전일업무</span></th>
					<th data-item="LAB_009"><span>오늘업무</span></th>
				</tr>
				<tr>
					<td style="width:50%">
						<textarea rows="5" cols="30"  name="remk1" id="r_remk1" style="vertical-align:middle;width:100%;height:250px;resize: none;border:0px;"></textarea>
					</td>
					<td style="width:50%">
						<textarea rows="5" cols="30"  name="remk3" id="r_remk3" style="vertical-align:middle;width:100%;height:250px;resize: none;border:0px;"></textarea>
					</td>
				</tr>
			</table>
		</div>

	</div>
	<div id="search-create-toolbar" class="wui-toolbar">
		<form id="search-create-form">
			<input type="hidden" name="hShetType" id="hShetType" value=""/>
			<input type="hidden" name="hShetNo" id="hShetNo" value=""/>
			<input type="hidden" name="hUserName" id="hUserName" value="${userName}"/>

			<fieldset class="div-line-new" >
				<!-- 2017-06-01 박상후 작업중 -->
				<div class="popup-table-alignCenter" style="text-align:left">
				<table cellpadding="5" class="popup-search-table" >
					<tr>
						<th class="h" style="width:70px" colspan="2" data-item="LAB_010"><span>등록번호</span></th>
						<td class="d">
							<div class="popup-inputType-field">
								<span id="shetNT"></span>
							</div>
						</td>

						<th class="h" style="width:90px" data-item="LAB_011"><span>입력담당</span></th>
						<td class="d">
							<div class="popup-inputType-field" style="width:130px;">
								<span id="userName"></span>
							</div>
						</td>

					</tr>
					<tr>
						<th class="h" colspan="2" data-item="LAB_012"><span>일자</span></th>
						<td class="d" >
							<input class="easyui-datebox" name="cShetDate" id="cShetDate" value="${datecreate}" style="width:140px"/>
						</td>

						<th class="h" data-item="LAB_013"><span>담당부서</span></th>
						<td class="d">
							<select class="easyui-combobox" name="cStafDept" ID="cStafDept" data-options="width:130">
								<option value="">선택하세요</option>
								<c:forEach var="item" items="${result}">
									<c:if test="${item.CODE_GRUP eq 'DEPT_CODE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>


					</tr>
				</table>
				</div>
			</fieldset>

		    <fieldset class="div-line-new-sub">
		        <table cellpadding="5" class="search-table tableEtc-c">
		            <tr>
						<td class="h">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-create-button" data-item="BTN_004">추가</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-create-button" data-item="BTN_005">저장</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-create-button" data-item="BTN_006">삭제</a>
						</td>
		            </tr>
		        </table>
			</fieldset>
		</form>
	</div>
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>


<!-- PDF 출력 조회 -->
<div id="pdf-dialog" class="easyui-layout" style="width:1024px;height:720px">
<iframe id="pdf-redirect" src=""  frameborder="0" style="width:100%;height:672px"></iframe>
</div>

</html>
