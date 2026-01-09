<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)emailTarget.jsp 1.0 2014/09/12                                     --%>
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
<%-- 전자메일 수신자설정 화면이다.                                              --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/09/12                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<!-- [LAYOUT] start -->
<div class="easyui-layout" data-options="fit:true">
    
    <!-- [WEST] start -->
    <div data-options="region:'west',border:false" style="width:380px;padding-right:5px;">
  
		<!-- 주소록 accordion -->
		<div id="address-accordion" class="easyui-accordion" fit="true">
			<div title="전체사용자" iconCls="icon-users"><table id="address-all-grid"></table></div>
			<div title="개인주소록" iconCls="icon-user" ><table id="address-user-grid"></table></div>
			<div title="그룹주소록" iconCls="icon-group"><table id="address-grup-grid"></table></div>
		</div>
		
    
    <!-- [WEST] end -->
	</div>

    <!-- [CENTER] start -->
    <div data-options="region:'center',border:false" style="padding-left:5px;padding-right:5px;padding-top:100px;">

  		<a href="javascript:void(0)" id="target-append-button"></a>
  		<br/><br/>
  		<a href="javascript:void(0)" id="target-remove-button"></a>

    <!-- [CENTER] end -->
	</div>

    <!-- [EAST] start -->
    <div data-options="region:'east',border:false" style="width:380px;padding-left:5px;">
  
		<!-- 수신자목록 -->
		<table id="target-grid"></table>
    
    <!-- [EAST] end -->
	</div>

<!-- [LAYOUT] end -->
</div>


<script type="text/javascript">

$(function() {
	jsystemaddress.create({
		appendBtn: $("#target-append-button"), //수신자등록
		removeBtn: $("#target-remove-button")  //수신자삭제
	});
});
</script>
