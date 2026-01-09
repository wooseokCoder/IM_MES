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
<%-- BODY 내의 하단 화면이다.                                                 --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

	<div class="footer" id="copyright">
	    <div class="footer-left">
	      Copyright &copy; 2020 LS Mtron Tractor. All Rights Reserved
	    </div>
	    
	    <div class="footer-right">
	      <div class="dropdown-bt" id="lsNtDropdown">
	        <div class="dropdown-bt-title">LS Network</div>
	        <div class="dropdown-bt-menu">
	          <ul>
	            <li onclick="">
	            	<a href="https://www.lsmtron.com/us/en" target="_blank" class="aLink" >LS Mtron</a>
	            </li>
	          </ul>
	        </div>
	      </div>
	      <div class="dropdown-bt" id="lsBsDropdown">
	        <div class="dropdown-bt-title">Business support</div>
	        <div class="dropdown-bt-menu">
	          <ul>
	            <li>
	            	<a href="https://lstractorusa.com/" target="_blank" class="aLink"  >LSTA</a>
	            </li>
	          </ul>
	        </div>
	      </div>
	    </div>
 	 </div>
  
  </div>
	
	<!-- FOOTER -->
	<div data-options="region:'south',split:false,border:false" id="footer-region">
		<%@ include file="/WEB-INF/views/include/south.jsp" %>
	</div>
	<!-- <div id="copyright">
	    <p>2019 LS Tractor USA11.</p>
	</div>
	 -->
	<!-- <div id="copyright">
		Copyright ⓒ 2019 LS Tractor USA. All Rights Reserved
	</div> -->
	
	
	<!-- <div class="footer" id="copyright">
	    <div class="footer-left">
	      Copyright ⓒ 2020 LS Mtron Tractor. All Rights Reserved
	    </div>
	    
	    <div class="footer-right">
	      <div class="dropdown-bt" id="lsNtDropdown">
	        <div class="dropdown-bt-title">LS Network</div>
	        <div class="dropdown-bt-menu">
	          <ul>
	            <li onclick="">LS Mtron</li>
	          </ul>
	        </div>
	      </div>
	      <div class="dropdown-bt" id="lsBsDropdown">
	        <div class="dropdown-bt-title">Business suppor</div>
	        <div class="dropdown-bt-menu">
	          <ul>
	            <li>LSTA</li>
	          </ul>
	        </div>
	      </div>
	    </div>
  </div> -->
  
   <style>
    .footer {
      width: calc(100% - 240px);
      border-top: 1px solid #ddd;
      /* padding: 10px 20px; */
      /* padding: 0 0 0 250px !important; */
      /* padding-left: 250px !important; */
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
      background-color: #fff;
      /* position: fixed; */
      display: flex;
      bottom: 0;
      left: 0;
      box-sizing: border-box;
      z-index: 100;
      height: 56px !important;
      font-weight: 400;
      color: #757575 !important;
      border-top: 1px solid #e0e0e0 !important;
      
      padding: 0 18px !important;
      position: absolute !important;
    	bottom: -30px !important;
    }

    .footer-left {
      /* color: #555; */
    }

    .footer-right {
      display: flex;
      /* gap: 20px; */
      position: relative;
      padding-left: 260px;
    }

    .dropdown-bt {
      position: relative;
      border-left : 1px solid #e0e0e0;
	    padding: 18px 14px;
	    text-align: left;
	    width: 150px;
    }

    .dropdown-bt-title {
      cursor: pointer;
    }

    .dropdown-bt-menu {
      position: absolute;
      bottom: 56px;
      /* top: -52px !important; */
      left: -1px;
      display: none;
      background-color: white;
      border: 1px solid #ccc;
      padding: 5px 0;
      z-index: 999;
      /* box-shadow: 0 2px 8px rgba(0,0,0,0.15); */
      width: 150px;
      cursor: pointer;
    }

    .dropdown-bt-menu.show {
      display: block;
    }

    .dropdown-bt-menu ul {
      list-style: none;
      margin: 0;
      padding: 0;
    }

    .dropdown-bt-menu li {
      padding: 10px;
      white-space: nowrap;
    }

    .dropdown-bt-menu li:hover {
      background-color: #f0f0f0;
    }
    
    .aLink, .aLink:hover {
    	text-decoration: none;
    	color: #757575 !important;
    	cursor: pointer;
    }

    
  </style>
  
   <script>
    const dropdownBt1 = document.getElementById('lsNtDropdown');
    const menuBt1 = dropdownBt1.querySelector('.dropdown-bt-menu');
    
    const dropdownBt2 = document.getElementById('lsBsDropdown');
    const menuBt2 = dropdownBt2.querySelector('.dropdown-bt-menu');

    dropdownBt1.addEventListener('mouseover', () => {
    	menuBt1.classList.add('show');
    });

    dropdownBt1.addEventListener('mouseleave', () => {
    	menuBt1.classList.remove('show');
    });
    
    dropdownBt2.addEventListener('mouseover', () => {
    	menuBt2.classList.add('show');
    });

    dropdownBt2.addEventListener('mouseleave', () => {
    	menuBt2.classList.remove('show');
    });
  </script>

