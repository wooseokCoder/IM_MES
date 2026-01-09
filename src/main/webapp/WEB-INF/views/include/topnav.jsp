<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)topnav.jsp 1.0 2016/09/20                                          --%>
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
<%-- 컨텐츠 내에 상단 내비 화면이다.                                                 --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2016/09/20                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<input type="hidden" name="text_menuKey" id="text_menuKey" value="${menuKey}"/>

<input type="hidden" name="BAS" id="BAS" value="${BAS}" /> <!--기본  -->
<input type="hidden" name="INS" id="INS" value="${INS}" /> <!--등록  -->
<input type="hidden" name="RET" id="RET" value="${RET}" /> <!--조회  -->
<input type="hidden" name="UPD" id="UPD" value="${UPD}" /> <!--수정  -->
<input type="hidden" name="DEL" id="DEL" value="${DEL}" /> <!--삭제  -->
<input type="hidden" name="AUP" id="AUP" value="${AUP}" /> <!--권한P -->
<input type="hidden" name="AUS" id="AUS" value="${AUS}" /> <!--권한S -->
<input type="hidden" name="AU1" id="AU1" value="${AU1}" /> <!--권한1 -->
<input type="hidden" name="AU2" id="AU2" value="${AU2}" /> <!--권한2 -->
<input type="hidden" name="AU3" id="AU3" value="${AU3}" /> <!--권한3 -->
<input type="hidden" name="AU4" id="AU4" value="${AU4}" /> <!--권한4 -->
<input type="hidden" name="AU5" id="AU5" value="${AU5}" /> <!--권한5 -->

<div class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',border:false">
