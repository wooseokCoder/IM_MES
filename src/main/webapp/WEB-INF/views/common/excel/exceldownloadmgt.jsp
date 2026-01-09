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
<%-- Conf. for Mail Send  Y/N 화면이다.                                       --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/08/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<%@ include file="/WEB-INF/views/include/common.jsp" %>
<!-- BUSINESS JAVASCRIPT -->
<script type="text/javascript">
     /* doInit({
        domain: '<spring:eval expression="@app['domain.user']"/>'
    }); */
</script>
<script type="text/javascript" src="<c:url value="/resources/js/common/excel/exceldownloadmgt.js?v=0630d" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jquery/datagrid-detailview.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/common/user/pdiupdate.js" />"></script>
<script type="text/javascript">
      doInitPdi({
        domain: '<spring:eval expression="@app['pdi.addr']"/>'
    });
</script>
<style>
#account-layout{min-width:1200px !important;}
/* .datagrid-body {height:60px !important;} */
.search-label-h2 {
    width: 90px;
}
#Progress_Loading{
 position: absolute;
 left: 50%;
 z-index:99;
 transform: translate(-50%, -50%);
}
.textbox-button {background: #c8c8c8;}
.textbox-button .l-btn:hover {background:#1e65bd;}
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

	<table id="search-grid">
	    <thead>
	        <tr>
	            <th data-options="field:'userName', 	halign:'center', width:150, align:'center',data_item:'GRD_001', sortable:true">User Name</th>
	            <th data-options="field:'windName',   	halign:'center', width:200, align:'left',  data_item:'GRD_002', sortable:true">Window</th>
	            <th data-options="field:'viewDesc',   	halign:'center', width:200, align:'left',  data_item:'GRD_002', sortable:true">View Description</th>
	            <th data-options="field:'fileDesc',   	halign:'center', width:200, align:'left',  data_item:'GRD_002', sortable:true">File Description</th>
	            <th data-options="field:'fileName',   	halign:'center', width:300, align:'left',data_item:'GRD_003', sortable:true, styler:cellStylerFile"">File Name</th>
	            <th data-options="field:'eMailList',   	halign:'center', width:200, align:'left',  data_item:'GRD_005', sortable:true">Email List</th>
	            <th data-options="field:'rqstDate',   	halign:'center', width:120, align:'center',data_item:'GRD_006', sortable:true">Request Date</th>
	            <th data-options="field:'fileCrtDate',  halign:'center', width:120, align:'center',data_item:'GRD_006', sortable:true">File Create Date</th>
	            <th data-options="field:'dataCnt', halign:'center', width:120, align:'center',data_item:'GRD_007', sortable:true">Data Count</th>
	            <th data-options="field:'filePath', halign:'center', width:120, align:'center',data_item:'GRD_007', sortable:true, hidden:true">File Download Date</th>
	            <th data-options="field:'remk', halign:'left', width:800, align:'left',data_item:'GRD_007', sortable:true">Remark</th>
	        </tr>
	    </thead>
	</table>
	<div id="search-toolbar" class="wui-toolbar" style="border-bottom: none;">
	    <form id="search-form">
	        <fieldset class="Remake-div-line-new" >
	        	<input type="hidden" name="bordNo"   id="r_bordNo"   value="${model.bordNo}"  />
				<input type="hidden" name="bordGrup" id="r_bordGrup" value="${model.bordGrup}"/>
				<input type="hidden" name="hOrgAuthCode" id="hOrgAuthCode" value="${user.orgAuthCode}"/>
				
	            <table cellpadding="5" class="search-table tableSearch-c wd-100" >
	            	<colgroup>
	            		<col width="10%" style="min-width: 80px;" />
	            		<col width="15%" style="min-width: 110px;" />
	            		<col width="10%" style="min-width: 80px;" />
	            		<col width="15%" style="min-width: 110px;" />
	            		<col width="10%" style="min-width: 80px;" />
	            		<col width="15%" style="min-width: 110px;" />
	            		<col width="10%" style="min-width: 80px;" />
	            		<col width="15%" style="min-width: 110px;" />
	            	</colgroup>
	            	<tr class="topnav_sty">
	            		<td colspan="8" >
	            			<div>
		            			<%@ include file="/WEB-INF/views/include/topnav2.jsp" %>
		            			<div>
			            			<a href="javascript:void(0)" style="width: 80px;" id="search-button" class="easyui-linkbutton cgray" data-item="BTN_001" data-options="">Search</a>
			                        <a href="javascript:void(0)" style="width: 80px;" id="clear-button" class="easyui-linkbutton btn-clear" data-item="BTN_002" data-options="">Clear</a>
		                        </div>
	                        </div>
	            		</td>
	            	</tr>
	                <tr>
	<%-- 					<th class="h table-Search-h-right" data-item="LAB_002"><span>Org Auth </span></th>
						<td class="d">
							<select class="easyui-combobox" name="orgAuthCode" ID="s_orgAuthCode" style="width:100px;height:30px;" data-options="panelHeight:'auto'">
								<option value="">ALL</option>
								<c:forEach var="item" items="${result}">
											<c:if test="${item.CODE_GRUP eq 'ORG_AUTH' }">
											<option value="${item.CODE_CD}">${item.CODE_NAME}</option>
											</c:if>
								</c:forEach>
							</select>
						</td> --%>
						<th class="h table-Search-h-right" data-item="LAB_004"><span>User ID </span></th>
						<td class="d">
							<c:choose>
								<c:when test="${user.orgAuthCode ne 'ADMIN'}">
									<input type="text" class="easyui-textbox" name="userId" id="userId" value="${gsUserId}" readonly data-options="width:120">
								</c:when>
								<c:otherwise>
									<input type="text" class="easyui-textbox" name="userId" id="userId" value="" data-options="width:120">
								</c:otherwise>
							</c:choose>
						</td>
	                    <th class="h table-Search-h search-label-h2"><span data-item="LAB_045">Request Date</span></th>
	                    <td class="d" style="min-width: 290px;">
	                    	<div style="display: flex; align-items: center;">
		                        <input class="easyui-datebox date-L" value="" textboxname="rqstDateFr" comboname="rqstDateFr" id="rqstDateFr" name="rqstDateFr"/>
		                        <input class="easyui-datebox date-R" value="" textboxname="rqstDateTo" comboname="rqstDateTo" id="rqstDateTo" name="rqstDateTo"/>
	                    	</div>
	                    </td>
	                </tr>
	            </table>
	       </fieldset>
	       <%-- <fieldset class="div-line-new-sub grd-div-btn">
		        <table cellpadding="5" class="search-table tableEtc-c">
		            <tr>
						<td class="h">
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="append-button" data-item="BTN_001" data-options="disabled:${INS}" >Add</a>
							<a href="javascript:void(0)" class="easyui-linkbutton c6" id="save-button"  data-item="BTN_003" data-options="disabled:${UPD}" >Save</a>
	<!-- 						<a href="javascript:void(0)" style="margin-left: 10px;" class="easyui-linkbutton c4" iconCls="icon-excel" id="excel-button" data-item="BTN_004">Excel Download</a> -->
						</td>
		            </tr>
		        </table>
			</fieldset> --%>
	    </form>
	</div>
<!-- [LAYOUT] end -->
</div>

<div id="regist-dialog" class="wui-dialog" style="overflow:scroll;height:850px;border-top-width:1px;display:none">
	<div data-options="region:'center',border:false">
		<div  style="height: 25px;">
	        <table cellpadding="5" class="search-table tableSearch-c">
	        	<thead>
		            <tr>
						<th class="h table-Search-h"><span data-item="LAB_002"> </span></th>
					</tr>
				</thead>
	        </table>
	   </div>
<!-- 	   <table id="search-grid2"> -->
<!-- 			<thead> -->
<!-- 				<tr> -->
<!-- 				    <th data-options="field:'fileName',   halign:'center', width:300,  align:'left', data_item:'GRD_101', sortable:true">File Name</th> -->
<!-- 				</tr> -->
<!-- 			</thead> -->
<!-- 		</table> -->
		<div>
			<form id="search-form2" method="post" enctype="multipart/form-data">
				<input type="hidden" id="h_codeCd" name="codeCd" value="" />
				<input type="hidden" id="h_codeGrup" name="codeGrup" value="" />
				<input type="hidden" id="h_atchGrup" name="atchGrup" value="AF" />
				<input type="hidden" id="h_atchNo" name="atchNo" value="" />
				<input type="hidden" id="h_oper" name="oper" value="I" />
		        <table cellpadding="5" class="search-table tableSearch-c" style="margin-left:12px;">
			        <tr>
						<th class="d">
							<span class="textbox"style="width: 100%;">
								<input class="easyui-filebox" name="excelFile" id="s_excelFile" style="width:300px"/>
								<span id="upload-frame"></span>
							</span>
						</td>
				    </tr>
		        </table>
	        </form>
	   </div>
		   <div style="text-align: center; margin-top: 25px;">
		   		<a href="javascript:void(0)" style="margin-right: 5px;" class="easyui-linkbutton c6" id="save-button2" data-item="BTN_005"  >Add</a>
		 		<a href="javascript:void(0)" class="easyui-linkbutton c6" id="cl-btn" data-item="BTN_006" data-options="width:100">Cancel</a>
		   </div>
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