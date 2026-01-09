<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)menu.jsp 1.0 2014/07/30                                            --%>
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
<%-- 메뉴 및 알람 섹션 화면이다.                                               --%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2014/07/30                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<style>
#west-menu-new .easyui-fluid .panel-header{
	background-color: #0a1e5a;
}
div#left-region {
    background: #0a1e5a !important;
    height: calc(100% - 158px) !important;
}

.tree-node-selected {
	position: relative;
	padding: 0.25rem 0.875rem 0.5rem;
	background: rgba(84, 84, 84, 0.3);
	opacity: 1;
	position: relative;
    color: #fff !important;
}

.easyui-fluid {
	background-color: rgba(255, 255, 255, 0.004) !important;
}

.tree-level2 {
	height: 48px !important;
    padding: 8px 14px !important;
	border-bottom: 0 !important;
	position: relative;
	
	background-color: #0a1e5a;
}

.tree-level2 > .tree-title {
	font-size: 18px !important;
    line-height: 25.2px !important;
    color: rgb(166 174 195) !important;
    margin: 0 0 0 8px !important;
}

.tree-level2 > .tree-icon {
	width: 18px;
}

.tree-level3 {
	height: 35px !important;
    padding: 5px 14px !important;
	border-bottom: 0 !important;
	background-color: #181d39 !important;
}

.tree-level3 > .tree-title {
	font-size: 16px !important;
    line-height: 22.2px !important;
    color: rgb(166 174 195) !important;
    margin: 0 !important;
}

.tree-level3 > .tree-icon {
	width: 16px;
	position: absolute;
	right: 10px;
}

.tree-level3 > .tree-icon:nth-of-type(1) {
  display: none;
}

.tree-level4 {
	height: 33px !important;
	padding: 8px 14px !important;
	border-bottom: 0 !important;
	background-color: #0d121e !important;
}

.tree-level4 > .tree-title {
	font-size: 14px !important;
    line-height: 19.6px !important;
    color: rgb(166 174 195) !important;
    margin: 0 !important;
}

.tree-level2 > .tree-indent {
	width: 0 !important;
}

.tree-level3 > .tree-indent {
	/* width: 44.8px !important; */
	width: 35px !important;
}
.tree-level4 > .tree-indent {
	/* width: 60.8px !important; */
	width: 45px !important;
}

/* tree-title 앞에 ㄴ 추가 */
.tree-level4 .tree-title {
  position: relative;
  padding-left: 1.4em; /* 공간 확보 */
}

.tree-level4 .tree-title::before {
  font-family: 'xeicon';  /* xeicon으로 변경 */
  content: "\e93d";       /* 원하는 아이콘의 코드 */
  position: absolute;
  left: 0;
  color: #aaa;
  font-size: 13pt;
  transform: rotate(315deg) translate(-7px, -2px);
  display: inline-block;
  opacity: 0.5;
}

.tree-level4 .tree-title::before {
  font-family: 'xeicon';  /* xeicon으로 변경 */
  content: "\e93d";       /* 원하는 아이콘의 코드 */
  position: absolute;
  left: 0;
  color: #aaa;
  font-size: 13pt;
  transform: rotate(315deg) translate(-7px, -2px);
  display: inline-block;
  opacity: 0.5;
}

.fa-angle-right {
  position: relative;
  padding-left: 1.4em; /* 공간 확보 */
}

.fa-angle-right::before {
	font-family: 'xeicon';  /* xeicon으로 변경 */
  content: "\e941";       /* 원하는 아이콘의 코드 */
  position: absolute;
  left: 0;
  color: #aaa;
  font-size: 13pt;
}

.fa-angle-left {
  position: relative;
  padding-left: 1.4em; /* 공간 확보 */
}

.fa-angle-left::before {
	font-family: 'xeicon';  /* xeicon으로 변경 */
  content: "\e944";       /* 원하는 아이콘의 코드 */
  position: absolute;
  left: 0;
  color: #aaa;
  font-size: 13pt;
}

.tree li {
	position: relative;
}

.tree-node-hover, .menuHover {
	background-color: #2e4073 !important;
	/* color: #f1f3f5 !important; */
	color: #ffef74 !important;
}

.tree-node-hover > .tree-title {
	color: #ffef74 !important;
}

.tree-submenu-icon-angle-right {
	position: absolute !important;
	right: 10px;
}

/* 축소된 메뉴 스타일 */
#menu-region.collapsed, #menu-region.collapsed .layout-panel-center, #menu-region.collapsed  .layout-panel-west {
  width: 48px !important;
}

#menu-region.collapsed .tree-title, #menu-region.collapsed .fa-angle-right, #menu-region.collapsed .fa-angle-left,
#menu-region.collapsed .menu-text, #menu-region.collapsed .logoImg, #menu-region.collapsed .menuBtLst {
  display: none;
}
 
#hoverTextPopup {
  pointer-events: none;  /* 마우스 이벤트 무시 */
  position: fixed;
  
}

@media (max-width: 768px) {
  #menu-region.collapsed, #menu-region.collapsed .layout-panel-center, #menu-region.collapsed  .layout-panel-west {
	  width: 1px !important;
	}
}

.noAuth > .tree-title {
	color: #616161 !important;
	pointer-events: none;
}

.noAuth {
	pointer-events: none;
}
    
</style>
<!--  20160929 박소현  -->
<div class="easyui-layout" fit="true">
    <div data-options="region:'center',split:false,border:false" style="background-color:#0a1e5a; height:calc(100% - 158px);  ">
		<div id="hideShowMenu" style="text-align: center; background-color: #0a1e5a; height: 48px; display: flex;">
			<span style="width: 48px; height: 48px; background-color: #ff0000 !important; padding: 12px;">
				<img src="<c:url value="/resources/images/icon_new/hambuger.png" />" style="float: left; cursor: pointer;" onclick="hideShowMenu();">
			</span>
			<span  data-item="LAB_012"  style="font-weight: bold; color:white; font-size: 12px; width: calc(100% - 48px);">
				<%-- <a href="<c:url value="/index.do" />" style="display: flex; height: 100%;"> --%>
				<a href="javascript:goHome();" style="display: flex; height: 100%;">
				<img class="logoImg" src="<c:url value="/resources/images/lsta_logo.png" />" 
					style="margin-left: 20px !important; margin: auto; height: 28px; width: 121.72px;">
				</a>
			</span>
		</div>
		<div class="easyui-layout" fit="true" id="left-region" style="height: calc(100% - 158px) !important; ">
		    <div data-options="region:'center',split:false,border:false,minHeight:180, maxHeight:775" id="west-menu-new" style="overflow: auto; background-color:#0a1e5a; height: 100%; ">
				<div id="left-submenu" class="wui-menu" style="height: 100% important; scrollbar-width: none;">
					<ul  id="left-menu">
					</ul>
				</div>
		    </div>
		</div>
		
		<div class="menuBtLst" style="background:rgb(10, 30, 90); height: 110px; padding-left: 16px; padding-top: 15px;">
			<div>
				<span style="color: white; font-size: 15px; font-weight: 700;">Related Site</span>
			</div>
			<div style="color: #e1e1e1; display: flex; flex-direction: column; color: rgb(166 174 195) !important;">
			    <span onclick="goToSite('https://scm.lstractorusa.com/lspdi')" style="cursor: pointer;">Assembly Management System</span>
				<span onclick="goToSite('https://scm.lstractorusa.com/lslogi')" style="cursor: pointer;">Gate Pass</span>
				<span onclick="goToSite('https://lstractorusa.com/')" style="cursor: pointer;">LS Tractor</span>
			</div>
		</div>
    </div>
</div>

<div id="hoverTextPopup" class="custom-hover-popup"></div>

<script type="text/javascript">
var windowSizeChk = false;
//모바일 체크
var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ? true : false;
let isCollapsed = false;

window.onload = function(){
	var windowWidth = $(window).width();
	
	//모바일일 떄 메뉴 축소
	if (windowWidth <= 768 || isMobile) {
		let layout = $('body');
        let westPanel = layout.layout('panel', 'west');
        
		$('#menu-region').addClass('collapsed');
        westPanel.panel('resize', { width: 1 });
        $(".top-buttons").removeClass("pdl-260");
        $(".top-buttons").addClass("pdl-60");
        layout.layout('resize');
        
        windowSizeChk = true;
        isCollapsed = true;
        
        $(".layout-expand-west").css("display","none");
        $("#menu-region").css("display","block");
        $("#menu-region").parent().css("display","block");
        
	}
	else {
		$(".top-buttons").addClass("pdl-260");
	}
	
	//메뉴 권한 없을 경우 설정
	$(".fa-angle-right").parent().removeClass("noAuth");
	$("#left-menu > li > div:not(.tree-level3, .tree-level4)").removeClass("noAuth").addClass("tree-level2");
};

$(document).ready(function() {
	
	 $(window).resize(function(){
	        var width = $(window).width();
	        var height = $(window).height();
	        $("#result").text("창의 너비: " + width + ", 높이: " + height);
	        
	        let layout = $('body');
	        let westPanel = layout.layout('panel', 'west');

	        var windowWidth = $(window).width(); // 현재 창의 가로 크기 가져오기
	        
	  	      if(isMobile) {
			  	       // 메뉴 축소
			  	  	$('#menu-region').addClass('collapsed');
		  	        westPanel.panel('resize', { width: 1 }); // 패널 너비 줄이기
		  	        windowSizeChk = true;
		  	      	isCollapsed = true;
		  	      $(".top-buttons").removeClass("pdl-260");
		  	      $(".top-buttons").addClass("pdl-60");
	  	      }
	  	      else if (windowWidth <= 768) {
	  	    	  if( windowSizeChk == false ) {
		  	       // 메뉴 축소
		  	          $('#menu-region').addClass('collapsed');
		  	        westPanel.panel('resize', { width: 1 }); // 패널 너비 줄이기
		  	        windowSizeChk = true;
		  	      	isCollapsed = true;
		  	      $(".top-buttons").removeClass("pdl-260");
		  	      $(".top-buttons").addClass("pdl-60");
	  	    	  }
	  	      } else {
		  	    	if( windowSizeChk == true ) {
			  	       // 메뉴 축소
			  	        $('#menu-region').removeClass('collapsed');
			            westPanel.panel('resize', { width: 240 }); // 원래 너비 복원
		  	          	windowSizeChk = false;
		  	        	isCollapsed = false;
		  	        	$(".top-buttons").removeClass("pdl-60");
		  	        	$(".top-buttons").addClass("pdl-260");
		  	    	}
	  	      }

  	      	  $(".layout-expand-west").css("display","none");
	  	      $("#menu-region").css("display","block");
	  	      $("#menu-region").parent().css("display","block");
		  	    
	        layout.layout('resize'); // 레이아웃 전체 리사이즈
	  	      
		  });
	
});

$(function() {
	$("#menu-folding").bind("click", function() {
		//메뉴접기
		$("#main-layout").layout('collapse', 'west');
	});
});

var hotMenuCnt = 0;
function MenuMove(){            
	//console.log(hotMenuCnt);
	//70
	var left_sub = $("#left-submenu").height();
	if($("#west-menu-new div.panel.easyui-fluid div.panel-header div.panel-tool a.panel-tool-collapse").hasClass("panel-tool-expand")){
		//열림
		$("#west-menu-new").css("height","150px");
		$("#left-hotmenu").css("height","100px");
		$("#left-hotmenu").show();
		$("#left-region div.panel.layout-panel.layout-panel-center").css("top","150px");
		$("#left-submenu").css("height",($("#left-submenu").height())+"px");
		//$("#left-region div.panel.layout-panel.layout-panel-center").animate({top:300},'fast');
		hotMenuCnt = 0;
	}else{		
		//닫힘
		$("#hot-menu > li").each(function(index){
			hotMenuCnt += $(this).height();
		});
		if(hotMenuCnt > 259){
			hotMenuCnt = 259;
		}
		$("#west-menu-new").css("height","40px");
		$("#left-hotmenu").css("height","0px");
		
		//$("#left-region div.panel.layout-panel.layout-panel-center").css("top","40px");
		$("#left-region div.panel.layout-panel.layout-panel-center").animate({top:41});
		$("#left-submenu").css("height",($("#left-submenu").height()+130)+"px");
		$("#left-hotmenu").hide();
	}
	
	$("body").click(function(event) {
		 //console.log(event.target.nodeName);
		});  
}

function hideShowMenu2() {
    var panelWidth = $('#main-layout').layout('panel', 'west').panel('options').width;
    var animationSpeed = 400;
    
    if (sessionStorage.getItem('menuStat') === 'open') {
        // 메뉴 닫기
        $("#main-layout").layout('collapse', 'west');
        $("#menuHeader").animate({
            left: -panelWidth
        }, animationSpeed, function () {
            // 메뉴 닫힌 직후, menuHeader 숨기고 menuHeader2 보이기
            $("#menuHeader").hide();
            $("#menuHeader2").show();

            // 메뉴 닫힌 후 등장하는 버튼에 클릭 이벤트 바인딩
            $(".layout-button-right").one('click', function () {
                $("#main-layout").layout('expand', 'west');

                // 메뉴 헤더 변경 (menuHeader2 숨기고 menuHeader 표시)
                $("#menuHeader2").hide();
                $("#menuHeader").css({ display: 'block', left: -panelWidth })
                                .animate({ left: 0 }, animationSpeed);

                sessionStorage.setItem('menuStat', 'open');
            });
        });
        sessionStorage.setItem('menuStat', 'close');
    } else {
        // 메뉴 열기
        $("#main-layout").layout('expand', 'west');
        $("#menuHeader2").hide();
        $("#menuHeader").css({ display: 'block', left: -panelWidth })
                        .animate({ left: 0 }, animationSpeed);
        sessionStorage.setItem('menuStat', 'open');
    }
}



function hideShowMenu () {
      const layout = $('body');
      const westPanel = layout.layout('panel', 'west');

      var windowWidth = $(window).width(); // 현재 창의 가로 크기 가져오기
      if (!isCollapsed) {
	      if (windowWidth <= 768 || isMobile) {
	       	// 메뉴 축소
	          $('#menu-region').addClass('collapsed');
	          westPanel.panel('resize', { width: 1 }); // 패널 너비 줄이기
	          $(".top-buttons").removeClass("pdl-260");
	          $(".top-buttons").addClass("pdl-60");
	      } else {
	       	// 메뉴 축소
	          $('#menu-region').addClass('collapsed');
	          westPanel.panel('resize', { width: 48 }); // 패널 너비 줄이기
	          $(".top-buttons").removeClass("pdl-260");
	          $(".top-buttons").addClass("pdl-60");
	      }
      } else {
          // 메뉴 확장
          $('#menu-region').removeClass('collapsed');
          westPanel.panel('resize', { width: 240 }); // 원래 너비 복원
          $(".top-buttons").removeClass("pdl-60");
          $(".top-buttons").addClass("pdl-260");
        }
      
      layout.layout('resize'); // 레이아웃 전체 리사이즈
      isCollapsed = !isCollapsed;
      
      // content-wrapper margin 업데이트
      if (typeof window.updateContentMargin === 'function') {
          window.updateContentMargin();
      }
      
      $(".layout-expand-west").css("display","none");
      $("#menu-region").css("display","block");
      $("#menu-region").parent().css("display","block");
}

function goToSite(url) {
	if (!url) return;
	window.open(url, "_blank"); // 새 탭에서 열기
}
</script>