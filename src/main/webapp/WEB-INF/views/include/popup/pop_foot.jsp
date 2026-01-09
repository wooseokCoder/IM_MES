<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)pop_footer.jsp 1.0 2025/08/12                                          --%>
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
<%-- 팝업 BODY 내의 하단 화면이다.                                                 		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2025/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- </div> -->

<script type="text/javascript">

// $(".select-table").keydown(function(){
// 	consts.easygrid.rowIndex();
// });


$(window).load(function() {

	$('#cust-search-dialog').show();

	$("#loadingProgressBar").hide();

	//doLangSettingTable();

	//$(window).trigger('resize');

});

/* 
$(function() {

	$('#cust-search-dialog').dialog({
	    title: tit.TITLE0009,//샘플게시판 등록
	    iconCls: 'icon-search',
	    top:     10,
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
} */

</script>

</body>