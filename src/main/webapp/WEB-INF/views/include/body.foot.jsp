<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)footer.jsp 1.0 2014/07/30                                          --%>
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
<%-- BODY 내의 하단 화면이다.                                                 		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<script type="text/javascript">

// $(".select-table").keydown(function(){
// 	consts.easygrid.rowIndex();
// });



$(window).load(function() {

	$('#cust-search-dialog').show();

	$("#loadingProgressBar").hide();

	doLangSettingTable();

	$(window).trigger('resize');

});

$(function() {

	$('#cust-search-dialog').dialog({
	    title: tit.TITLE0009,//샘플게시판 등록
	    iconCls: 'icon-search',
	    top:     10,
	    /* width: 580, */
	    width:  680,
	    height: 463,
	    closed: true,
	    modal: true,
	    resizable: true
	});
});


//업체조회 - CustPop
function doCustSearch(custName, custCode, parentsCustName){
	//1:업체명,2:업체코드,3:부모에받을 객체명
	if(custName != ""){	$("#popCustName").val(custName); }
	if(custCode != ""){	$("#popCustCode").val(custCode); }

	$("#search-cust-dialog").datagrid('unselectAll');
	$("#search-cust-dialog").datagrid('clearSelections');

	if(parentsCustName != ""){
		$("#"+parentsCustName).textbox("setValue",$("#"+custName).textbox("getValue"));
	}

	consts_cust.easygrid.search();
	$("#cust-search-dialog").dialog('center');
	$("#cust-search-dialog").dialog('open');
}

//mm.dd.yyyy date정렬
function dateReSort(date1, date2) {
	var toDate = function(str){
		var parts = str.split(' ');
	    var dd = parts[0].split('.');
	    var date = new Date(dd[2]+'-'+dd[0]+'-'+dd[1]);
	    return date;
	}
	if(date1 == undefined || date1 == '') {
		date1 = '01.01.1900';
	}
	if(date1.length != 10) {
		date1 = '01.01.1900';
	}
	if(date2 == undefined || date2 == '') {
		date2 = '01.01.1900';
	}
	if(date2.length != 10) {
		date2 = '01.01.1900';
	}
	var d1 = toDate(date1);
	var d2 = toDate(date2);
	return d1.getTime()<d2.getTime()?-1:1;
}
function dateReSort2(date1, date2) {
	var toDate = function(str){
		var parts = str.split(' ');
	    var dd = parts[0].split('.');
	    var hh = parts[1].split(':');
	    var date = new Date(dd[2],parseInt(dd[0])-1,dd[1],hh[0],hh[1],hh[2]);
	    return date;
	}
	if(date1 == undefined || date1 == '') {
		date1 = '01.01.1900 00:00:00';
	}
	if(date1.length != 19) {
		date1 = '01.01.1900 00:00:00';
	}
	if(date2 == undefined || date2 == '') {
		date2 = '01.01.1900 00:00:00';
	}
	if(date2.length != 19) {
		date2 = '01.01.1900 00:00:00';
	}
	var d1 = toDate(date1);
	var d2 = toDate(date2);
	return d1.getTime()<d2.getTime()?-1:1;
}

</script>

<!-- 업체조회 -->
<div id="cust-search-dialog" class="wui-dialog" style="border-top-width:1px;display:none">
<table id="search-cust-grid">
	<thead>
		<tr>
			<th data-options="field:'custName', halign:'center',width:180">거래처명</th>
			<th data-options="field:'custInfoName', halign:'center', align:'left',width:180">약식명칭</th>
			<th data-options="field:'custTypeName', halign:'center', align:'center',width:80">거래처구분</th>
			<th data-options="field:'ownName', halign:'center', align:'center',width:80">대표자</th>
			<th data-options="field:'ownHp', halign:'center', align:'center',width:105,hidden:true">핸드폰</th>
			<th data-options="field:'compTel1', halign:'center', align:'left',width:105">전화번호</th>
			<th data-options="field:'compTel2', halign:'center', align:'center',width:105,hidden:true">전화번호2</th>
			<th data-options="field:'compFax', halign:'center', align:'left',width:105">팩스</th>
			<th data-options="field:'compMail', halign:'center', align:'left',width:150">이메일</th>
			<th data-options="field:'compHome', halign:'center', align:'left',width:150,hidden:true">홈페이지</th>
			<th data-options="field:'stafName', halign:'center', align:'center',width:80,hidden:true">담당자</th>
			<th data-options="field:'custRemk', halign:'center', align:'left',width:130,hidden:true">비고</th>
			<th data-options="field:'custMemo', halign:'center', align:'left',width:180,hidden:true">메모</th>
		</tr>
	</thead>
</table>

<!-- fieldset 구분 변경  20160928 박소현 -->
<div id="search-cust-toolbar" class="wui-toolbar">
	<form id="search-cust-form">
		<fieldset class="div-line-new" >
	        <table cellpadding="5" class="search-table tableSearch-c" >
	            <tr>
					<th class="h table-Search-h"><span>거래처명 </span></th>
					<td class="d">
						<input class="easyui-textbox" name="pCustName" id="pCustName" data-options="width:100"/>
					</td>

					<th class="h table-Search-h"><span>거래처구분</span></td>
	            	<td class="d">
	            	<select class="easyui-combobox" name="pCustType" id="pCustType" data-options="width:100">
						<option value="">전체</option>
						<c:forEach var="item" items="${result}">
							<c:if test="${item.CODE_GRUP eq 'CUST_TYPE' }">
								<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
							</c:if>
						</c:forEach>
					</select>
	            	</td>
					<th class="h table-Search-h"><span>대표자검색 </span></th>
					<td class="d">
						<input class="easyui-textbox" name="pOwnName" id="pOwnName" data-options="width:100"/>
					</td>

				<td class="b">
					<a href="javascript:void(0)" id="search-cust_pop-button" class="easyui-linkbutton cgray">검색</a>
				</td>
	            </tr>
	        </table>
	   </fieldset>
	</form>
</div>
</div>

<!-- =========================== CONTENTS END ============================= -->
 	</div>
</div>
<c:if test="${layoutYn == 'Y'}">

    </div>

	<!-- FOOTER -->
	<div data-options="region:'south',split:false,border:false" id="footer-region" style="height:1px;">
		<%@ include file="/WEB-INF/views/include/south.jsp" %>
	</div>
</c:if>
</body>