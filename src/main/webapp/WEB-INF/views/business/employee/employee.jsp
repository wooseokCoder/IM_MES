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
<script type="text/javascript" src="<c:url value="/resources/js/business/employee/employee.js" />"></script>
<script type="text/javascript">
doInit({
		domain: '<spring:eval expression="@app['domain.user']"/>'
	});
</script>
<script>

$(function(){

	$("#append-button").click(function(){
		if(window.innerWidth<1400){

			//alert("call");
			$(".window #regist-popup").css("height",390);
			$(".window-shadow").css("height",390);
			$("#regist-form fieldset").css("height",345);
			$("#regist-form fieldset").css("overflow-y","scroll");
			$("#regist-form fieldset").css("overflow-x","hidden");
			$(".window").addClass("forcedLeft");
			$(".window-shadow").addClass("forcedLeft");
			$("#regist-popup .div-line-new-sub").css("border-top","1px solid #ccc")
		}
	})
});

</script>
</head>
<!-- 다음 우편번호 검색 팝업 -->

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:9021;-webkit-overflow-scrolling:touch;">
	<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:9020" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>

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
                document.getElementById('r_addNo').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('r_address').value = fullAddr;

                document.getElementById('r_address').focus();
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
        element_layer.style.border = borderWidth + 'px solid #000';


        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>

<style>
#account-layout{min-width:970px !important;}
.forcedLeft{left:2px !important;top:2px !important;}
</style>
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
<table id="search-grid">

	<thead data-options="">
		<tr>
			<th data-options="field:'ck',            checkbox:true"></th>
			<th data-options="field:'compCode',      width:120, halign:'center', align:'center',   data_item:'GRD_001', formatter:jformat.compCode, sortable:true">사업장</th>
			<th data-options="field:'emplNo',   	 width: 80, halign:'center', align:'center',   data_item:'GRD_002', sortable:true">사번</th>
			<th data-options="field:'emplName', 	 width:100, halign:'center', align:'center',   data_item:'GRD_003', sortable:true">사원명</th>
			<th data-options="field:'birthDay', 	 width: 80, halign:'center', align:'center',   data_item:'GRD_004', sortable:true">생년월일</th>
			<th data-options="field:'gender',        width: 80, halign:'center', align:'center',   data_item:'GRD_005', sortable:true">성별</th>
			<th data-options="field:'joinDay',       width:120, halign:'center', align:'center',   data_item:'GRD_006', sortable:true">입사일</th>
			<th data-options="field:'deptName',      width:120, halign:'center', align:'center',   data_item:'GRD_007', sortable:true">부서명</th>
			<th data-options="field:'position',      width:80,  halign:'center', align:'center',   data_item:'GRD_008', sortable:true">직급</th>
			<th data-options="field:'emplHp',        width:150, halign:'center', align:'center',   data_item:'GRD_009', sortable:true">핸드폰번호</th>
			<th data-options="field:'emplMail',      width:120, halign:'center', align:'left',     data_item:'GRD_010', sortable:true">이메일</th>
			<th data-options="field:'exitYn',        width:100, halign:'center', align:'center',   data_item:'GRD_011', sortable:true">재직여부</th>
		</tr>
	</thead>
</table>

<div id="search-toolbar" class="wui-toolbar">
<!-- fieldset 변경 20190628 박소현 -->
	<form id="search-form">
		<fieldset  class="div-line-new" style="padding-left:20px;">
	        <table cellpadding="5" class="search-table tableSearch-c">
	            <tr>
					<th class="h"><span data-item="LAB_001">부서&nbsp;</span></th>
					<td class="d">
						<input class="easyui-combobox" name="deptCode" id="deptCode"
							data-options="width:100,
										mode:'remote',
										editable:false,
										loader:jcombo.loader,
										params:{codeGrup:'DEPT_CODE'}
										"
						/>
					</td>
					<th class="h "><span data-item="LAB_002">사원명</span></td>
								<td class="d"><input class="easyui-textbox"  name="searchEmplName" id="searchEmplName" style="width:150px"/></td>
	            	<th class="h "><span data-item="LAB_003">사번</span></td>
								<td class="d"><input class="easyui-textbox"  name="searchEmplNo" id="searchEmplNo" style="width:150px"/></td>

					<th class="h"><span data-item="LAB_004">재직여부 </span></th>
					<td class="d">
						<select class="easyui-combobox" name="exitYn" ID="s_exitYn" style="width:80px" data-options="panelHeight:'auto'"/>
							<option value="ALL">전체</option>
							<c:forEach var="item" items="${result}">
								<c:if test="${item.CODE_GRUP eq 'EXIT_YN' }">
									<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<td class="b">
						<a href="javascript:void(0)" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="disabled:${RET}" >검색</a>
						<input type="hidden" id="hdfIndex" value="-1" />
						<input type="hidden" id="hdfChk" value="" />
					</td>
	            </tr>
	        </table>
	      </fieldset>
	        <!-- <div class="div-line"></div> -->
	      <fieldset class="div-line-new-sub">
	        <table cellpadding="5" class="search-table  tableEtc-c" style="width:100%;">
	            <tr>
					<td class="h" style="width:600px">
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_002" data-options="disabled:false">추가</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c6" id="remove-button" data-item="BTN_003" data-options="disabled:${DEL}">삭제</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c4" iconCls="icon-excel"  id="excel-button" data-item="BTN_004">엑셀</a>
						<a href="javascript:void(0)" class="easyui-linkbutton c8" id="dreload-button" data-item="BTN_005">초기화</a>
					</td>
					<td class="h etctext" style="text-align:right;" data-item="TXT_001"><span>상세 정보는 해당 행을 더블클릭하시면 확인 할수 있습니다.</span></td>
	            </tr>
	        </table>
		</fieldset>
	</form>
</div>


<!-- [LAYOUT] end -->
</div>

<!-- 2016/12/05 김영진 -- title 한영변환 재검토 -->
<div id="regist-popup" class="easyui-dialog" data-options="
	 	width: 800,
	 	height: 670,
	 	closed: true,
	 	title:'${progName} 상세',
	 	iconCls:'icon-edit',
	 	buttons:'#regist-buttons'
	 ">

    <form id="regist-form" method="post" style="display:none">
    	<fieldset style="overflow:auto;height:566px;overflow-x:hidden;">

    		<input type="hidden" name="sysId" id="r_sysId" />
    		<input type="hidden" name="oper"  id="r_oper"  />

	        <div class="company-info-mark" style="padding-left:10px;margin-top:10px !important;margin-bottom:10px;">
				<i class="fa fa-circle" style="font-size:10px;padding-bottom:5px;vertical-align:middle;"></i>
				<span style="font-size:14px;" data-item="LAB_005">&nbsp;기본정보</span>
			</div>
			<table class="employee-enroll-table">
				<tr>
					<th><span data-item="LAB_006">사원명:</span></th>
					<td><input class="easyui-textbox" name="emplName" id="r_emplName" data-options="required:true" /></td>
					<th><span data-item="LAB_007">사원번호:</span></th>
					<td><input class="easyui-textbox" name="emplNo" id="r_emplNo" readonly="readonly" /></td>
					<!-- 그리드를 위한 공백 -->

					<td rowspan="5" style="width:140px;text-align:center;">
						<i class="fa fa-picture-o fa-5x imgCompMark" ></i>
						<input type="file" name="compMark" id="compMark" style="display:none;" onChange="readURL(this, 'imgCompMark');"/>
						<img src="" id="imgCompMark" alt="이미지 첨부" class="userView" />

					</td>
				</tr>
				<tr>
					<th><span data-item="LAB_008">영문명:</span></th>
					<td><input class="easyui-textbox" name="emplNameEng" id="r_emplNameEng" /></td>
					<th><span data-item="LAB_009">한자:</span></th>
					<td><input name="emplNameHan" id="r_emplNameHan" maxlength="5" /></td>

				</tr>
				<tr>
					<th><span data-item="LAB_010">주민번호:</span></th>
					<td><input class="easyui-textbox" name="sociSecuNo" id="r_sociSecuNo" /></td>
					<th><span data-item="LAB_011">생년월일:</span></th>
					<td><input class="easyui-textbox" name="birthDay" id="r_birthDay" /></td>
				</tr>
				<tr>
					<th><span data-item="LAB_012">성별:</span></th>
					<td><input name="gender" id="r_gender" size="2" maxlength="1" style="width:35px !important;text-align:center; padding-left:0px;"/></td>
					<th><span data-item="LAB_013">양력음력:</span></th>
					<td><input name="solLunCal" id="r_solLunCal" size="2" maxlength="1" style="width:35px !important;text-align:center; padding-left:0px;"/>&nbsp;력</td>

				</tr>
				<tr>
					<th><span data-item="LAB_014">우편번호:</span></th>
					<td><input type="text" name="addNo" id="r_addNo" class="textbox-text" /></td>
					<th style="padding:5px;text-align:center;" data-item='LAB_030'>
					<a onClick="execDaumPostCode()" class="easyui-linkbutton c6" style="width:100px !important;line-height:24px;font-size:12px;font-weight:normal;padding:0;color:#fff;border:none;background-color:#b5b5b5;" data-item="BTN_008" >
					우편번호찾기
					</a>
					</th>
					<td style="background-color:#f8f7f6;"></td>
				</tr>
				<tr>
					<th><span data-item="LAB_015">주소:</span></th>
					<td colspan="3"><input type="text" class="textbox-text" name="address" id="r_address" /></td>
					<th rowspan="2" style="text-align:center; padding:3px;">
						<div style="width:80px;line-height:24px;font-size:12px;font-weight:normal;padding:0;color:#fff;border:none;background-color:#b5b5b5;display:inline-block;margin-bottom:5px;">
							<a onclick="doImgClick('compMark');" style="color:#fff;cursor:pointer;" data-item="LAB_016">이미지 첨부</a>
						</div>
						<br/><span data-item="LAB_017">사진</span>
					</th>
				</tr>
				<tr>
					<th><span data-item="LAB_018">전화번호:</span></th>
					<td><input class="easyui-textbox" name="emplTel" id="r_emplTel" /></td>
					<th><span data-item="LAB_019">핸드폰번호:</span></th>
					<td><input class="easyui-textbox" name="emplHp" id="r_emplHp" /></td>

				</tr>
				<tr>
					<th><span data-item="LAB_020">이메일:</span></th>
					<td ><input class="easyui-textbox" name="emplMail" id="r_emplMail" /></td>
					<th><span data-item="LAB_021">재직여부:</span></th>
					<td >
					 <input class="easyui-combobox" name="exitYn" id="r_exitYn"
							data-options="
										mode:'remote',
										editable:false,
										loader:jcombo.loader,
										params:{codeGrup:'EXIT_YN'}
										"
						/>
					</td>
				</tr>
			</table>
			<div class="company-info-mark" style="padding-left:10px;margin-top:10px !important;margin-bottom:10px;">
				<i class="fa fa-circle" style="font-size:10px;padding-bottom:5px;vertical-align:middle;"></i>
				<span style="font-size:14px;" data-item="LAB_022">&nbsp;부서정보</span>
			</div>
			<table class="employee-enroll-table">
				<tr>
					<th><span data-item="LAB_023">사업장:</span></th>
					<td>
					<input class="easyui-combobox" name="compCode" id="s_compCode"
						data-options="width:100,
									mode:'remote',
									editable:false,
									loader:jcombo.loader,
									params:{codeGrup:'BSNS_PT_TYPE'}
									" />

					</td>
					<th><span data-item="LAB_024">입사일:</span></th>
					<td><input class="easyui-textbox" name="joinDay" id="r_joinDay" /></td>
					<td rowspan="3" style="width:140px;"></td>
				</tr>
				<tr>
					<th><span data-item="LAB_025">부서코드:</span></th>
					<td><input class="easyui-textbox" name="deptCode" id="r_deptCode" /></td>
					<th><span data-item="LAB_026">부서명:</span></th>
					<td>
						<input class="easyui-combobox" name="deptName" id="r_deptName"
							data-options="
										mode:'remote',
										editable:false,
										loader:jcombo.loader,
										params:{codeGrup:'DEPT_CODE'}
										"
						/>
					</td>

				</tr>
				<tr>
					<th><span data-item="LAB_027">직급:</span></th>
					<td>
						<input class="easyui-combobox" name="position" id="s_position"
							data-options="width:60,
										mode:'remote',
										editable:false,
										loader:jcombo.loader,
										params:{codeGrup:'PST_TYPE'}
										"
						/>
					</td>
					<th><span data-item="LAB_028">담당업무:</span></th>
					<td><input class="easyui-textbox" name="busiCharge" id="r_busiCharge" /></td>

				</tr>
				<tr>
					<th><span data-item="LAB_029">비고:</span></th>
					<td colspan="4" style="border-top:1px solid #ccc;"><textarea rows="5" cols="20" name="emplRemk" id="r_emplRemk" style="resize: none;"></textarea></td>
				</tr>
			</table>
    	</fieldset>
    </form>
    <div id="search-toolbar" style="display:none">
	<fieldset class="div-line-new-sub">
       <table cellpadding="5" class="search-table  tableEtc-c" style="margin:0 auto;">
           <tr>
			<td>
				<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button" data-item="BTN_006">저장</a>
				<a href="javascript:void(0)" class="easyui-linkbutton c6"    id="cancel-button" data-item="BTN_007">취소</a>
			</td>
           </tr>
       </table>
	</fieldset>
	</div>
</div>

<!-- 엑셀  진행상태 -->
<div id="progress-popup" class="wui-dialog" style="display:none">
    <br></br>
    <center><img src="<%=request.getContextPath() %>/resources/images/ajax_loader_red_48.gif"></img></center>
</div>

<!-- BODY 하단 INCLUDE -->
<%@ include file="/WEB-INF/views/include/body.foot.jsp" %>

</html>
