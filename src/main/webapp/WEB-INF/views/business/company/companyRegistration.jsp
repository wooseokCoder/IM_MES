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
<%-- 회사정보관리 화면이다.                                                      		--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>

<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript" src="<c:url value="/resources/js/business/company/companyregistration.js" />"></script>
<script>
$(function(){

	
		var tableWidth = $(".company-info-table").width();
		$(".company-info-mark").css("width",tableWidth);

	
})


</script>


<style>
.company-info-table{border-top:2px solid #1f1f1f;}
</style>
</head>



<!-- BODY 상단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.head.jsp" %>
<%@ include file="/WEB-INF/views/include/topnav.jsp" %>
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




<div class="panel datagrid easyui-fluid">
	<div id="search-toolbar" class="wui-toolbar" style="border-bottom: 2px solid #4d4d4d;">
	</div>
	
	<div class="company-info-content">
	<div class="company-info-mark"><i class="fa fa-circle" style="font-size:10px;padding-bottom:5px;vertical-align:middle;"></i>&nbsp;<span style="font-size:16px;" data-item = 'LAB_1'>기본정보</span></div>
	<table class="company-info-table" style="margin:auto;">
			<tr>
				<th data-item = 'LAB_2'>회사코드</th>
				<td colspan="3">
					<span class="textbox"><input type="text" name="compCode" id="r_compCode" class="textbox-text" readonly="readonly" style="width:190px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_3'>회사명(한글)</span></th>
				<td>
					<span class="textbox"><input type="text" name="compName" id="r_compName" class="textbox-text" style="width:190px;" /></span>
				</td>
				<th><span data-item = 'LAB_4'>회사명(영문)</span></th>
				<td>
					<span class="textbox"><input type="text" name="compNameEN" id="r_compNameEN" class="textbox-text" style="width:190px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_5'>회사명(한자)</span></th>
				<td>
					<span class="textbox"><input type="text" name="compNameHAN" id="r_compNameHAN" class="textbox-text" style="width:190px;"/></span>
				</td>
				<th><span data-item = 'LAB_6'>회사명(약어)</span></th>
				<td>
					<span class="textbox"><input type="text" name="compNameALT" id="r_compNameALT" class="textbox-text" style="width:190px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_7'>사업자번호</span></th>
				<td>
					<span class="textbox"><input type="text" name="bizNo" id="r_bizNo" class="textbox-text" style="width:190px;"/></span>
				</td>
				<th><span data-item = 'LAB_8'>대표자</span></th>
				<td>
					<span class="textbox"><input type="text" name="ownName" id="r_ownName" class="textbox-text" style="width:190px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_9'>업태</span></th>
				<td>
					<span class="textbox"><input type="text" name="bizClss" id="r_bizClss" class="textbox-text" style="width:190px;"/></span>
				</td>
				<th><span data-item = 'LAB_10'>종목</span></th>
				<td>
					<span class="textbox"><input type="text" name="bizType" id="r_bizType" class="textbox-text" style="width:190px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_11'>우편번호</span></th>
				<td>
					<span class="textbox"><input type="text" name="addrZip" id="r_addrZip" class="textbox-text" placeholder="___-___" style="width:190px;"/></span>
				</td>
				<th style="border-right:1px solid #ccc;text-align:center !important;padding:0px !important;">
						<a onClick="execDaumPostCode()" class="easyui-linkbutton c6" style="width:100px !important;line-height:24px;font-size:12px;font-weight:normal;padding:0;color:#fff;border:none;background-color:#b5b5b5;" data-item="BTN_001" >
						우편번호찾기
						</a>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_12'>사업장주소</span></th>
				<td colspan="3">
					<span class="textbox"><input type="text" name="addrMain" id="r_addrMain" class="textbox-text" style="width:533px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_13'>대표전화</span></th>
				<td>
					<span class="textbox"><input type="text" name="compTel1" id="r_compTel1" class="textbox-text" placeholder="___-____-____" style="width:190px;"/></span>
				</td>
				<th><span data-item = 'LAB_14'>FAX번호</span></th>
				<td>
					<span class="textbox"><input type="text" name="compFax" id="r_compFax" class="textbox-text" placeholder="___-____-____" style="width:190px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_15'>HomePage</span></th>
				<td colspan="3">
					<span class="textbox"><input type="text" name="compHome" id="r_compHome" class="textbox-text" style="width:190px;"/></span>
				</td>
			</tr>
		</table>
		<div class="company-info-mark"><i class="fa fa-circle" style="font-size:10px;padding-bottom:5px;vertical-align:middle;"></i>&nbsp;<span style="font-size:16px;" data-item = 'LAB_16'>회계정보</span></div>
		<table class="company-info-table" style="margin:auto;">
			<tr>
				<th><span data-item = 'LAB_17'>SetUp일자</span></th>
				<td>
					<span class="textbox" style="border:none;"><input class="easyui-datebox" type="text" name="setDate" id="r_setDate" class="textbox-text" style="width:134px;height:25px;"/></span>
				</td>
				<th><span data-item = 'LAB_18'>결산월</span></th>
				<td>
					<span class="textbox"><input type="text" name="settMnth" id="r_settMnth" class="textbox-text"  style="width:60px;"/></span><span style="padding-left:5px;" data-item = 'LAB_19'>월</span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_20'>회계년도</span></th>
				<td>
					<span class="textbox"><input type="text" name="ficsYear" id="r_ficsYear" class="textbox-text" style="width:60px;"/></span><span style="padding-left:5px;" data-item = 'LAB_21'>년도</span>
				</td>
				<th><span data-item = 'LAB_22'>회계기수</span></th>
				<td>
					<span class="textbox"><input type="text" name="ficsJock" id="r_ficsJock" class="textbox-text" style="width:60px;"/></span>
				</td>
			</tr>
			<tr>
				<th><span data-item = 'LAB_23'>부가세율</span></th>
				<td>
					<span class="textbox"><input type="text" name="taxRate" id="r_taxRate" class="textbox-text" style="width:60px;"/></span><span style="padding-left:5px;">%</span>
				</td>
				<th><span data-item = 'LAB_24'>현금계정</span></th>
				<td>
					<span class="textbox"><input type="text" name="cashAcct" id="r_cashAcct" class="textbox-text" style="width:60px;"/></span>
				</td>
			</tr>
		</table>
		
		</table>
		<form id="search-form">
			<fieldset class="div-line-new-sub" style="text-align:center;border-bottom:0px;">
		        <table cellpadding="5" class="search-table  tableEtc-c" style="display:inline-block;margin-top:10px;">
		            <tr>
						<td class="h" style="width:600px">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_002" data-options="disabled:${UPD}" >저장</a>
						</td>
		            </tr>
		        </table>
			</fieldset>
		</form>
		</div>
	
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
