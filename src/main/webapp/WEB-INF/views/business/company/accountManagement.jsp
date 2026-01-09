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
<%-- 코드관리 화면이다.                                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/company/accountmanagement.js" />"></script>

<style>
	/* .sub-table-height26{margin-top:10px;border-top:2px solid #3879D9;} */
	.sub-table-height26 > .easyui-fluid > .panel-header{height:26px;line-height:26px;padding:0;}
	.sub-table-height26 > .easyui-fluid > .panel-header > .panel-title{height:26px !important;line-height:26px !important;padding-left:25px;}
	.sub-table-height26 .select-table th{text-align:center;}



	#account-layout{min-width:1200px !important;}
	/* 오른쪽 테이블 그리드 강제 넓이 고정 */
	.adjust-table1 .textbox{width:100% !important;height:25px !important;}

	@media screen and (max-width:1100px){
		.pagination table td:nth-child(-n+3){display:none;}
		.pagination table td:nth-child(11){display:none;}
		.pagination table td:nth-child(12){display:none;}
		.pagination table td:nth-child(13){display:none;}
		.pagination-info{display:none;}
	}

	.table-customPage-inputBox .textbox{width:100px !important;}
	.table-customPage-inputBox2 .textbox{width:86px !important;}
    .company-info-table th{width: 110px;}

    .numberbox .textbox-text{
	  text-align: right;
	}


</style>
</head>

<!-- 팝업 -->
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

<script>


    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }

    function execDaumPostCode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('r_addrZip').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('r_addrMain').value = fullAddr;

                document.getElementById('r_addrMain').focus();
                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%'
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 300; //우편번호 서비스가 들어갈 element의 width
        var height = 460; //우편번호 서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>
<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
<!-- 화면 첫 로딩시 필요한 ProgressBar -->
<div id="loadingProgressBar">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true" id="account-layout" >

		<div data-options="region:'north',border:false">
			<div id="search-toolbar" class="wui-toolbar">
				<form id="search-form">
					<fieldset class="div-line-new" >
				        <table cellpadding="5" class="search-table tableSearch-c" >
				            <tr>
				            	<th class="h table-Search-h"><span data-item="LAB_001">거래처명</span></td>
								<td class="d"><input class="easyui-textbox"  name="searchCustName" id="searchCustName" style="width:150px"/></td>
				            	<th class="h table-Search-h"><span data-item="LAB_002">거래처 코드</span></td>
								<td class="d"><input class="easyui-textbox"  name="searchCustCode" id="searchCustCode" style="width:100px"/></td>
				            	<th class="h table-Search-h"><span data-item="LAB_003">거래처구분</span></td>
				            	<td class="d">
				            	<select class="easyui-combobox" name="searchCustType" id="s_searchCustType" data-options="width:100">
									<option value="" data-item = 'LAB_004'>전체</option>
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'CUST_TYPE' }">
											<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
								</select>
				            	</td>
				            	<th class="h table-Search-h"><span data-item="LAB_005">대표자</span></td>
								<td class="d"><input class="easyui-textbox"  name="searchOwnName" id="searchOwnName" style="width:100px"/></td>
								<th class="h table-Search-h"><span data-item="LAB_006">입금자</span></td>
								<td class="d"><input class="easyui-textbox"  name="searchDepositor1" id="searchDepositor1" style="width:100px"/></td>
								<th class="h table-Search-h"><span data-item="LAB_007">사업자번호</span></td>
								<td class="d"><input class="easyui-textbox"  name="searchBizNo" id="searchBizNo" style="width:100px"/></td>
								<td class="b"><a href="javascript:void(0)" class="easyui-linkbutton cgray" id="search-button" data-item="BTN_001" data-options="disabled:${RET}" >검색</a></td>
				            </tr>
				        </table>
				   </fieldset>
				   
				</form>
			</div>
		</div>


		  <!-- [CENTER] start -->
    <div data-options="region:'center',border:false">
  		<fieldset class="div-line-new-sub">
		   <!-- <div class="div-line"></div> -->
	        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:${INS}">추가</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
	        <a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_004"  data-options="disabled:${UPD}">저장</a>
			<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel" data-item="BTN_005" id="excel-button" >엑셀</a>
			<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_006" >초기화</a>

		<!-- 테이블 가운데 보더 안보이게 하는 강제 공간 -->
		</fieldset>
					
		<table id="search-grid">
			<thead>
				<tr>
					<th data-options="field:'custCode'    , halign:'center',width:80 , data_item:'GRD_000', align:'center', sortable:true">거래처 코드</th>				
					<th data-options="field:'custInfoName', halign:'center',width:250, data_item:'GRD_000', align:'left' ">약호</th>
					<th data-options="field:'custName'    , halign:'center',width:200, data_item:'GRD_000', align:'left' , sortable:true ">상호</th>
					<th data-options="field:'bizNo'     , halign:'center',width:100, data_item:'GRD_000', align:'center'">사업자번호</th>					
					<th data-options="field:'ownName'     , halign:'center',width:60, data_item:'GRD_000', align:'center'">대표자명</th>
					<th data-options="field:'bizClss'     , halign:'center',width:100, data_item:'GRD_000', align:'center'">업태</th>
					<th data-options="field:'bizType'     , halign:'center',width:100, data_item:'GRD_000', align:'center'">종목</th>
					<th data-options="field:'taxClsName'     , halign:'center',width:100, data_item:'GRD_000', align:'center'">세무구분</th>
					<th data-options="field:'addrZip'     , halign:'center',width:100, data_item:'GRD_000', align:'center'">우편번호</th>
					<th data-options="field:'addrMain'     , halign:'center',width:300, data_item:'GRD_000', align:'left'">주소</th>
					<th data-options="field:'compTel1'     , halign:'center',width:100, data_item:'GRD_000', align:'center'">전화번호</th>
				</tr>
			</thead>
		</table>

    <!-- [CENTER] end -->
	</div>

	<!-- [EAST] start -->
<div data-options="region:'east',border:false" style="width:580px;">

			<div class="easyui-tabs"  id="schedule-tab" >
			<div title="거래처상세"  style="padding:10px" >
				<div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:550px;position:relative !important;"><span data-item="LAB_045">상세정보</span></div>
				<div class="easyui-panel" style="overflow:hidden;" data-options="fit:true" >
			    <form id="regist-form" method="post">
<!-- 			    	<fieldset style="border-right:1px solid #dadada;"> -->
			    		<input type="hidden" name="sysId"       id="r_sysId" />
			    		<input type="hidden" name="oper"        id="r_oper"  />

			    		<input type="hidden" name="hdfCustCode" id="r_hdfCustCode" />						

				        <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada;">

 							<tr>
								<th style="width:99px;"><span data-item="LAB_009">약호</span></th>
								<td style="width:260px;">
									<span class="textbox"><input class="textbox-text" name="custInfoName" id="r_custInfoName" data-options="required:true" /></span>
								</td>
								<th  style="width:99px;"><span data-item="LAB_010">거래처코드</span></th>
								<td style="width:99px;">
									<span class="textbox"><input class="textbox-text" name="custCode" id="r_custCode" readonly/></span>
								</td>								
				            </tr>

				            <tr style='border-bottom:0px !important;'>
								<th style="width:99px;"><span data-item="LAB_011">* 상호</span></th>
								<td style="width:260px;">
									<span class="textbox" ><input class="textbox-text" name="custName" id="r_custName" data-options="required:true" /></span>
								</td>
								<th  style="width:99px;"><span data-item="LAB_010">등록일자</span></th>
								<td style="width:99px;">
									<span class="textbox"><input class="textbox-text" name="regiDate" id="r_regiDate" readonly/></span>
								</td>
<!-- 								<th style="width:99px;"> -->
<!-- 									<span data-item="LAB_012">거래처 구분</span> -->
<!-- 								</th> -->
<!-- 								<td style="width:99px;"> -->
									
<!-- 									<select class="easyui-combobox" name="custType" ID="r_custType" data-options="width:100"> -->
<%-- 									<c:forEach var="item" items="${result}"> --%>
<%-- 										<c:if test="${item.CODE_GRUP eq 'CUST_TYPE' }"> --%>
<%-- 										<option value="${item.CODE_CD}">${item.CODE_NAME}</option> --%>
<%-- 										</c:if> --%>
<%-- 									</c:forEach> --%>
<!-- 									</select>									 -->
<!-- 								</td> -->
				            </tr>
			           </table>
			           

			            <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
				            <tr>
								<th><span data-item="LAB_025">사업자번호</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="bizNo" id="r_bizNo" placeholder="___-____-____" maxlength="12"/></span></td>
								<th style="width:99px;">
									<span data-item="LAB_012">세무 구분</span>
								</th>
								<td style="width:99px;">
									
									<select class="easyui-combobox" name="taxCls" ID="r_taxCls" data-options="width:100">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'TAX_CLASS' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
									</select>
									
								</td> 
								
				            </tr>
				            <tr>
								<th><span data-item="LAB_027">업태</span></th>
								<td><span class="textbox"><input class="textbox-text" name="bizClss" id="r_bizClss" /></span></td>
								<th><span data-item="LAB_028">종목</span></th>
								<td><span class="textbox"><input class="textbox-text" name="bizType" id="r_bizType" /></span></td>
				            </tr>
				             <tr>
								<th><span data-item="LAB_031">전화</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="compTel1" id="r_compTel1" placeholder="___-____-____" /></span></td>
								<th><span data-item="LAB_033">FAX</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="compFax" id="r_compFax" placeholder="___-____-____" /></span></td>
				            </tr>
				            <tr>
								<th><span data-item="LAB_026">대표자</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="ownName" id="r_ownName" /></span></td>
								<th><span data-item="LAB_026">대표HP</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="ownHP" id="r_ownHP" /></span></td>
				            </tr>
				            <tr>
				            	<th><span data-item="LAB_030">대표자택</span></th>
								<td colspan="3" ><span class="textbox"><input type="text" class="textbox-text" name="ownHome" id="r_ownHome" /></span></td>
				            </tr>
				            
				            <tr>
								<th><span data-item="LAB_029">우편번호</span></th>
								<td><span class="textbox"><input type="text" class="textbox-text" name="addrZip" id="r_addrZip" /></span></td>
								<th style="border-right:1px solid #ccc;text-align:center !important;">
								<a onClick="execDaumPostCode()" class="easyui-linkbutton c6" style="width:100px !important;line-height:24px;font-size:12px;font-weight:normal;padding:0;color:#fff;border:none;background-color:#b5b5b5;" data-item="BTN_007" >
								우편번호찾기
								</a>
								</th>
				            </tr>
				            <tr>
								<th><span data-item="LAB_030">주소</span></th>
								<td colspan="3" ><span class="textbox"><input type="text" class="textbox-text" name="addrMain" id="r_addrMain" /></span></td>
				            </tr>
				            <tr>
				            	<th><span data-item="LAB_030">거래처 구분</span></th>
				            	<td colspan="3" >
				           			<input type="checkbox" name="checkCustType" id='11' value="11" style='width:20px !important'/><label for='11' style="margin-bottom:0"  data-item="LAB_037" >판매처</label>
									<input type="checkbox" name="checkCustType" id='12' value="12" style='width:20px !important'/><label for='12' style="margin-bottom:0"  data-item="LAB_038">구매처</label>
									<input type="checkbox" name="checkCustType" id='13' value="13" style='width:20px !important'/><label for='13' style="margin-bottom:0"  data-item="LAB_039">은행</label>
									<input type="checkbox" name="checkCustType" id='14' value="14" style='width:20px !important'/><label for='14' style="margin-bottom:0"  data-item="LAB_040">기타</label>
									<input type="checkbox" name="checkCustType" id='15' value="15" style='width:20px !important'/><label for='15' style="margin-bottom:0"  data-item="LAB_041" >외주</label>
									<input type='textbox'  name="custType" id="r_custType" style='visibility: hidden;display:none;'/>									
				            	</td>				            	
				            </tr>	
				            </table>			           
							<table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
				            <tr style="border-top:0px;border-bottom:0px;">
					            <th style="width:99px;">
					            	<span data-item="LAB_013">관리항목</span>
					            </th>
								<td style="width:300px;">
									<input type="checkbox" name="stopTrad" id='stopTrad'  style="width:15px!important;"/>
									<label for='stopTrad' style="margin-bottom:0"  data-item="LAB_037" >거래중지</label>
									
									<input type="checkbox" name="misuChkYn" id='misuChkYn' style="width:15px!important;"/>
									<label for='misuChkYn' style="margin-bottom:0"  data-item="LAB_037" >미수관리</label>
									
									<input type="checkbox" name="mijiChkYn" id='mijiChkYn' style="width:15px!important;"/>
									<label for='mijiChkYn' style="margin-bottom:0"  data-item="LAB_037" >미지관리</label>
									
									<input type="checkbox" name="tempRele" id='tempRele' style="width:15px!important;"/>
									<label for='tempRele' style="margin-bottom:0"  data-item="LAB_037" >한도해지</label>
									
									<!-- <input type="checkbox" name="prePayYn" id='prePayYn' style="width:15px!important;" />
									<label for='prePayYn' style="margin-bottom:0"  data-item="LAB_037" >선결제</label> -->
									<input type="checkbox" name="prePayYn" id="prePayYn" style="width:15px!important;" />
									<span data-item="LAB_015">선결제</span>
								
<!-- 									<input type="checkbox" name="stopTrad" id="stopTrad" style="width:15px!important;" /> -->
<!-- 									<span style="color:red;" data-item="LAB_014">거래중지</span> -->
<!-- 									<input type="checkbox" name="misuChkYn" id="misuChkYn" style="width:15px!important;" /> -->
<!-- 									<span data-item="LAB_015">미수관리</span> -->
<!-- 									<input type="checkbox" name="mijiChkYn" id="mijiChkYn" style="width:15px!important;" /> -->
<!-- 									<span data-item="LAB_016">미지관리</span> -->
<!-- 									<input type="checkbox" name="tempRele" id="tempRele" style="width:15px!important;" /> -->
<!-- 									<span data-item="LAB_017">한도해지</span> -->
<!-- 									<input type="checkbox" name="prePayYn" id="prePayYn" style="width:15px!important;" /> -->
<!-- 									<span data-item="LAB_017">선결제</span> -->
								</td>
								<th style="width:57px">
									<span data-item="LAB_018">한도액</span>
								</th>
								<td style="width:99px" >
									<input type="text" class="easyui-numberbox" name="creditAmt" id="r_creditAmt"  data-options="width:60 ,label:'Number in the United States',labelPosition:'top',groupSeparator:','"  />
								</td>
				            </tr>
			            </table>
			            <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
				            <tr>
				            	<th style="width:80px;"><span data-item="LAB_019">현재미수</span></th>
				            	<td style="width:105px;">
				            		<input type="text" class="easyui-numberbox cashType-input-text" style="text-align:right !important;" name="payableAmt" id="r_payableAmt"  data-options="width:140,label:'Number in the United States',labelPosition:'top',groupSeparator:','"  />
								</td >
								<th style="width:80px;"><span data-item="LAB_020">기초미수</span></th>
								<td style="width:105px;">
									<input type="text" class="easyui-numberbox" name="baseMisuAmt" id="r_baseMisuAmt"  data-options="width:140,label:'Number in the United States',labelPosition:'top',groupSeparator:','"  />
								</td>
								<th style="width:80px;border-left:1px solid #ccc;"><span data-item="LAB_021">미수기준일</span></th>
								<td style="width:105px;">
			            			<input class="easyui-datebox" name="baseMisuDate" id="r_baseMisuDate" />
				            	</td>
				            </tr>
				            <tr style="border-bottom:0px;">
				            	<th><span data-item="LAB_022">현재미지</span></th>
				            	<td>
				            		<input type="text" class="easyui-numberbox" name="payablemijiAmt" id="r_payablemijiAmt"  data-options="width:140,label:'Number in the United States',labelPosition:'top',groupSeparator:','"  />
								</td>
								<th><span data-item="LAB_023">기초미지</span></th>
								<td>
									<input type="text" class="easyui-numberbox" name="baseMijiAmt" id="r_baseMijiAmt"  data-options="width:140,label:'Number in the United States',labelPosition:'top',groupSeparator:','"  />
								</td>
				            	<th style="border-left:1px solid #ccc;">
				            		<span data-item="LAB_024">미지기준일</span>
				            	</th>
				            	<td>
				            		<input class="easyui-datebox" name="baseMijiDate" id="r_baseMijiDate" />
				            	</td>
				            </tr>
			            </table>
			            <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
			             	 <tr>								
								<th><span data-item="LAB_032">편재코드</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="ubiqCode" id="r_ubiqCode" placeholder="" /></span></td>
								<th><span data-item="LAB_034">출고시간</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="rlTm" id="r_rlTm" /></span></td>
				            </tr>
				             <tr>								
								<th><span data-item="LAB_032">할인율</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="dcRate" id="r_dcRate" placeholder="" /></span></td>
								<th><span data-item="LAB_034">압축할인율</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="cpDcRate" id="r_cpDcRate" /></span></td>
				            </tr>
			            </table>
			            </form>
			            </div>
       		</div>
			
			<div title="계산서"  style="padding:10px">
					<div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:550px;position:relative !important;"><span data-item="LAB_046">계산서</span></div>
			
					<div class="easyui-panel" style="overflow:hidden;"  data-options="fit:true" >
					<form id="regist-form" method="post">
					 <table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
				            <tr>								
								<th><span data-item="LAB_032">담당자명</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="compStafName" id="r_compStafName" placeholder="" /></span></td>
								<th><span data-item="LAB_034">담당부서</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="compStafDept" id="r_compStafDept" /></span></td>								
				            </tr>
				            <tr>
				            	<th><span data-item="LAB_034">담당자전화</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="compStafTel1" id="r_compStafTel1" /></span></td>
								<th><span data-item="LAB_034">담당자휴대폰</span></th>
								<td><span class="textbox"><input class="textbox-text txt-center" name="compStafHP" id="r_compStafHP" /></span></td>								
				            </tr>
				            <tr>
				            	<th><span data-item="LAB_035">이메일</span></th>
								<td style="border-right:1px solid #ccc;"><span class="textbox"><input class="textbox-text txt-center" name="compMail" id="r_compMail" /></span></td>
								<th><span data-item="LAB_041">계산서발행구분</span></th>
								<td>									
									<select class="easyui-combobox" name="billIssue" ID="r_billIssue" data-options="width:100">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'BILL_ISSUE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
									</select>
								</td>
					        </tr>
					        <tr>
								<th><span data-item="LAB_037">마감일</span></th>
								<td><span class="textbox">
									<input class="easyui-datebox" name="billCloseDt" id="r_billCloseDt" />									
									</span>
								</td>
								<th><span data-item="LAB_035">계산서 비고</span></th>
								<td style="border-right:1px solid #ccc;"><span class="textbox"><input class="textbox-text txt-center" name="billRemk" id="r_billRemk" /></span></td>
					        </tr>
					        <tr>
					        	<th><span data-item="LAB_036">입금자명1</span></th>
								<td><span class="textbox"><input class="textbox-text" name="depositor1" id="r_depositor1" /></span></td>
								<th><span data-item="LAB_037">입금자명2</span></th>
								<td><span class="textbox"><input class="textbox-text" name="depositor2" id="r_depositor2" /></span></td>
					        </tr>
				            <tr>
								<th><span data-item="LAB_038">현장주소</span></th>
								<td colspan="3"><span class="textbox"><input class="textbox-text" name="shopAdd" id="r_shopAdd" /></span></td>
				            </tr>
				            <tr>
								<th><span data-item="LAB_039">현장경리담당</span></th>
								<td><span class="textbox"><input class="textbox-text" name="shopStafName" id="r_shopStafName" /></span></td>
								<th><span data-item="LAB_040">현장경리연락처</span></th>
								<td><span class="textbox"><input class="textbox-text" name="shopStafTel" id="r_shopStafTel" /></span></td>
				            </tr>
				            <tr>
								<th><span data-item="LAB_041">거래처 등급</span></th>
								<td>									
									<select class="easyui-combobox" name="compGrade" id="r_compGrade" data-options="width:100">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'COMP_GRADE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
									</select>
								</td>
								<th><span data-item="LAB_042">부가세적용</span></th>
								<td>
									<span class="textbox" style="width:70px !important;"><input class="textbox-text" name="taxGp" id="r_taxGp" /></span>%
				            </tr>
				            <tr>
								<th><span data-item="LAB_043">과세구분</span></th>
								<td style="border-right:1px solid #ccc;">
									
									<select class="easyui-combobox" name="taxType" ID="r_taxType" data-options="width:100">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'TAX_TYPE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
									</select>
								</td>
								<th><span data-item="LAB_044">정기결제일</span></th>
								<td style="border-right:1px solid #ccc;">
									<input class="easyui-datebox" name="rgpayDate" id="r_rgpayDate" ></input>
								</td>
				            </tr>
				            </table>
				            
				            
				            <div class="accountInfo-header" style="border-bottom:1px solid #8a8a8a;margin-left:10px;width:550px;position:relative !important;"><span data-item="LAB_046">일반거래조건</span></div>
				          	
				          	<table class="company-info-table adjust-table1" style="margin-left:10px;border-left:1px solid #dadada">
				            <tr>
								<th><span data-item="LAB_045">* 담당부서</span></th>
								<td>
									
									<select class="easyui-combobox" name="shopDept" ID="r_shopDept" data-options="width:100">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'SITE_DEPT' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
									</select>
								</td>
								<th><span data-item="LAB_046">* 영업담당</span></th>
								<td>
									<select class="easyui-combobox" name="stafName" ID="r_stafName" data-options="width:100">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'SAL_EPLY_TYPE' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
									</select>
								
								</td>
				            </tr>
				            <tr>
				            	<th><span data-item="LAB_046">세금계산서구분</span></th>
								<td>
									<select class="easyui-combobox" name="taxbillCls" ID="r_taxbillCls" data-options="width:100">
									<c:forEach var="item" items="${result}">
										<c:if test="${item.CODE_GRUP eq 'TAX_BILL_CLASS' }">
										<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
										</c:if>
									</c:forEach>
									</select>
								
								</td>
				            </tr>
				            <tr>
								<th><span data-item="LAB_048">특기사항</span></th>
								<td colspan="3" >
									<textarea rows="5" cols="30"  name="custRemk" id="r_custRemk" style="width:100%; height:62px;border-radius:5px 5px 5px 5px;border:1px solid #cccccc;resize: none;filter:none !important;"></textarea>
								</td>
				            </tr>
				        </table>
					 </form>
					</div>
					
			</div>	
			</div>
			<%-- 
			
			            
			            
			           
			</div>
			<!-- EASY UI PANEL END -->
			 --%>
	    	
 <!-- [EAST] end -->
</div>

<!-- [LAYOUT] end -->
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
