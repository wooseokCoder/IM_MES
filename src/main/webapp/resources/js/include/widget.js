/*
 * @(#)widget.js 1.0 2014/08/0
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */

/**
 * UI 컴포넌트를 지원하는 스크립트이다.
 *
 * @author C-NODE
 * @version 1.0 2014/08/01
 */

//메뉴데이터
var jmenus = {
	//========================================================//
	// 메뉴목록 및 상위메뉴맵
	//--------------------------------------------------------//
	MENUS  : false, //메뉴목록
	MMAP   : {},    //메뉴맵
	TMAP   : {},    //최상위메뉴맵
	_find: function(key, map) {
		if (!map)
			return false;
		for (var p in map) {
			if (p == key)
				return map[p];
		}
		return false;
	},
	get: function() {
		return this.MENUS;
	},
	//특정메뉴KEY의 최상위메뉴 찾기
	getMap: function(key) {
		return this._find(key, this.TMAP);
	},
	//특정메뉴KEY의 메뉴 찾기
	getMenu: function(key) {
		return this._find(key, this.MMAP);
	},
	init: function(menus) {
    	this.MENUS = menus;
    	this.TMAP  = {};
    	this.MMAP  = {};
    	//메뉴맵 생성
    	this.build(this.MENUS);
	},
	build: function(menus, root) {
		if (!menus ||
			 menus.length == 0)
			return;
		var m = this;
		$.each(menus, function(i,c) {
			if (!root ||
				 c.menuLevel == 1)
				root = c;
			m.TMAP[c.menuKey] = root;
			m.MMAP[c.menuKey] = c;
			if (c.subs)
				m.build(c.subs, root);
		});
	},
	//========================================================//
	// 메뉴링크 열기(탭열기)
	//--------------------------------------------------------//
	go: function(key, param) {
		param = typeof param !== 'undefined' ? param : "test";
		var tabYn = gconsts.TAB_PANEL;
		var obj   = jmenus.getMenu(key);
		var url   = obj.menuUrl;
		var desc  = obj.menuDesc;
		var pDesc = obj.parentDesc;
		var type  = obj.procType;
		var flag  = "link"; //tab, link
		if (url == "#")
			return;

		//탭패널 사용가능이고 탭방식인 경우
		if (tabYn == 'Y' &&
			type  == 'T')
			flag  = "tab";

		//링크방식인 경우
		if (flag == "link") {
			window.open(url);
			/*
			jmenus.submit({
				key: key,
				url: url,
				desc: desc,
				pDesc:pDesc,
				link: getUrl(url)
			});
			*/
			//return 'jmenus.move(\''+ menu.menuUrl+ '\');';
			return;
		}

		//탭이 없는 경우
		if (jwidget.tabs.exist() == false) {
			jmenus.submit({
				key: key,
				url: url,
				desc: desc,
				pDesc:pDesc,
				link: getUrl(jwidget.tabs.consts.URL)
			});
		    return;
		}
		
		//탭이 있는 경우 탭생성
		jwidget.tabs.create({
			menuKey:  key,
			menuUrl:  url,
			menuDesc: desc,
			parentDesc:pDesc,
			customParam: param // param 값을 전달
		});
		if(url == '/mdp/dealerinventory.do' || url == '/mdp/openorderreport.do'  || url == '/mdp/warrantystatus.do' 
			|| url == '/mdp/dealerNamesRetailList.do' || url == '/mdp/wholesalelist.do') {
			var form = $("#menu-form");
			form.find("[name=dealCode]").val( param );
		    form.attr("action", obj.link );
		    form.attr("target", "_self");
//		    form.submit();
		}
	},
	goBlankTab: function(params) {
		//통합검색
		let navUrl = params.path || "/global-search/" + encodeURIComponent(params.value);
		let navKey = params.title || "Search";
		let navDesc = params.title || "Search";
		
		if (jwidget.tabs.exist() == false) {
			jmenus.submit({
				key: navKey,
				url: navUrl,
				desc : navDesc,
				pDesc : navDesc,
				link: getUrl(jwidget.tabs.consts.URL)
			});
		    return;
		}
		
		//탭이 있는 경우 탭생성
		jwidget.tabs.create({
			menuKey: navKey,
			menuUrl:  navUrl,
			menuDesc : navDesc,
			parentDesc : navDesc,
			customParam: params // param 값을 전달
		});
	},
	//========================================================//
	// 메뉴링크 열기(페이지이동)
	//--------------------------------------------------------//
	move: function( url ) {
		if (url == "#")
			return;
		top.location.href = getUrl(url);
	},
	//========================================================//
	// 메뉴링크 폼이동(페이지이동)
	//--------------------------------------------------------//
	submit: function( obj,param ) {
		//console.log(obj.pDesc );
		var form = $("#menu-form");
		form.find("[name=menuKey]" ).val( obj.key  );
		form.find("[name=menuUrl]" ).val( obj.url  );
		form.find("[name=menuDesc]").val( obj.desc );
		form.find("[name=parentDesc]").val( obj.pDesc );
	    form.attr("action", obj.link );
	    form.attr("target", "_self");
	    form.submit();
	},

	//========================================================//
	// 메뉴링크 스크립트
	//--------------------------------------------------------//
	getLink: function(menu) {
		return "jmenus.go('"+menu.menuKey+"');";
	}
	//========================================================//
};
var tabsMenuDesc = '';
var jwidget = {
	//-----------------------------------------//
	//상단메뉴 컨트롤
		menu: {
			consts: {
				KEY: "#main-navbar-collapse",
				MID: "main-navbar-collapse-m",
				SID: "main-navbar-collapse-s",
				URL: "/menu.json",
				buttons: [],
				linkHtml: '',
				menuHtml: '',
				// ── 헤더 드롭다운 메뉴 설정 ──────────────────────────
				// submenuKey     : 좌측 메뉴에서 숨기고, 헤더 드롭다운의 소스로 사용할 메뉴 KEY
				// myAccountMenuKey : 드롭다운 목록에서 숨길 메뉴 KEY (사용자 아이콘 클릭으로 직접 열림)
				//   - DEAL   : 딜러 사용자가 아이콘 클릭 시 열리는 메뉴
				//   - NODEAL : 딜러 외 사용자가 아이콘 클릭 시 열리는 메뉴
				// 관련 코드: north.jsp - buildAccountDropdown(), myAccountMenu()
				//           widget.js - submenu.rebuild()
				// ─────────────────────────────────────────────────────
				submenuKey : "LS007",
				myAccountMenuKey : {
					DEAL : "LS603",
					NODEAL : "LS605"
				}
			},
			//메뉴 로딩 및 탭패널 생성
			load: function( args ) {
				var m = this;
				var o = $(this.consts.KEY);

				if (!o ||
					!o.length ||
					 o.length == 0)
					return;

				$.ajax({
					url: getUrl(m.consts.URL),
			        dataType: 'json',
			        type: 'post',
					success: function(data) {

					if (!data || !data.menus)
			        		return;

			        	//메뉴데이터 저장
			        	jmenus.init( data.menus );

			        	//상단메뉴패널 생성
		        		m.create();

		        		//계정 드롭다운 메뉴 생성
		        		if (typeof buildAccountDropdown === 'function') {
		        			buildAccountDropdown();
		        		}

		        		if (!args){
		        			//jwidget.submenu.load('LS001');
		        			//jwidget.submenu.load('LSTA');
		        			jwidget.submenu.load(null);
		        			return;
		        		}

		        		//좌측서브메뉴 생성
						jwidget.submenu.load(args.menuKey);

						if (args.callback) {
		        			args.callback();
		        		}
		        		else {
		           			//중앙탭패널 생성
		        			jwidget.tabs.create(args);
		        		}
					},
					error: function() {
						console.error("Failed to load menu data");
					}
				});
			},
			//상단메뉴패널 생성
			create: function() {

				//메뉴패널 레이어 ID
				var layer = this.consts.KEY;
				//메뉴데이터 가져오기
				var menus = jmenus.get();
				//메뉴구조 HTML WRITE
				this.write(menus, layer);

				//메뉴패널 생성
				//var menuObj = $("#"+ layer).panel({border:false});

				//BBUG.TEST : 메뉴가 있는 panel의 size 처리는 가능함...
				// 메뉴 배경은 <div id="top-menu-m" style="width: 1018px;background-color: #000000;" 으로 가능할껀데... 어디에서 처리해야하나???
				//$("#"+ layer).panel('resize',{width:600});


				//메뉴버튼 생성
				$.each(this.consts.buttons, function(i, o) {
					var auth = o.progAuth;
					var type = o.type;
					var mid  = o.id;
					var sid  = o.sub;
					var cfg  = {};

					//권한이 없을 경우
					if (auth == '0')
						cfg['disabled'] = true;
					if (type=='linkbutton')
						cfg['plain'] = true;
					if (type=='menubutton')
						cfg['menu'] = '#'+ sid;

					//[WSC2.0] [2015.04.16 LSH] 메뉴의 아이콘설정 적용
					if (o.iconCls)
						cfg['iconCls'] = o.iconCls;

					if      (o.type=='linkbutton') $("#"+mid).linkbutton(cfg);
					else if (o.type=='menubutton') $("#"+mid).menubutton(cfg);
				});
			},
			//메뉴 HTML WRITE
			write: function(menus, layer) {

				var obj = this;
				var str = '';
				//링크메뉴 생성
				str = obj.createHtml({
					thisObj:  obj,
					level:    0,
					list:     menus,
					layer:    layer,
					callback: obj.buildLink
				});

				//WRITE
				$(obj.consts.KEY).html( str );

				//다운메뉴 생성
				$.each(menus, function(i,c) {

					if (!obj.existList(c.subs))
						return;

					var s = obj.createHtml({
						thisObj:  obj,
						level:    1,
						list:     c.subs,
						layer:    obj.consts.SID+'-'+c.menuKey,
						callback: obj.buildMenu
					});
					//str += s;
					$("#"+jmenus.getMenu(c.menuKey).menuKey).append(s);
				});
			},
			//메뉴 HTML 생성
			createHtml: function(args) {
				var obj = args.thisObj;

				if (!obj.existList(args.list))
					return '';

				// BBUG.CHG : 상단 메뉴 배경 변경 추가 - ;background-color:#FE2E2E;
				var str = '<ul '
					    + (args.level <= 1 ? ' id="'+args.layer+'"' : '')
					    + (args.level >= 1 ? ' class="dropdown-menu"' : '')
				        + (args.level == 0 ? ' class="nav navbar-nav" style="color:#ffffff;">' : '>');

				$.each(args.list, function(i,c) {
					str += args.callback({
						thisObj: obj,
						level:   args.level,
						menu:    c,
						childs:  c.subs,
						childYn: obj.existList(c.subs),
						mid:     obj.consts.MID+'-'+c.menuKey,
						sid:     obj.consts.SID+'-'+c.menuKey
					});
				});
				str += '</ul>';

				return str;
			},
			buildLink: function(args) {
				//console.log(args);
				//2017/02/20 김영진 -- 하위권환여부(권한이 없으면 미출력)
				if(args.level == 0 && args.menu.chileCnt == 0){
					return '';
				}

				var lnk = jmenus.getLink(args.menu);
				var txt = args.menu.menuDesc;
				// BBUG.CHG : 상단 메뉴 폰트색상 변경 추가 - style="color:#ffffff"
				//2016/09/29 김영진 수정 -- data-toggle=\"dropdown\" 마우스 오버로만 작동
				var str = '<li id=\"'+args.menu.menuKey+'\" class=\"dropdown\"><a href="#" class=\"dropdown-toggle\" data-toggle=\"dropdown\" onclick="'+lnk+'">'+txt+'</a></li>';

				args.menu['type'] = (args.childYn ? 'menubutton' : 'linkbutton');
				args.menu['id'  ] = args.mid;
				args.menu['sub' ] = args.sid;

				args.thisObj.consts.buttons.push(args.menu);

				return str;
			},
			buildMenu: function(args) {

				var lnk = jmenus.getLink(args.menu);
				var txt = args.menu.menuDesc;
				var str = '';
				var icon = args.menu.iconCls; //2016/09/29 김영진 수정 --아이콘 추가
				//console.log(args.menu);
				//하위노드가 있으면( 서브 메뉴 중에...
				if (args.childYn) {
					/*str += '<li>';
					str += '<span>'+args.menu.menuDesc+'</span>';

					str += args.thisObj.createHtml({
						thisObj:  args.thisObj,
						level:    2,
						list:     args.childs,
						layer:    args.sid,
						callback: args.thisObj.buildMenu
					});
					str += '</li>';*/
					//20180806 박민혁 -- 2단메뉴
					str += '<li class="dropdown-submenu">';
					str += '<a href="#"><i class="drowpdown-menu-icon fa '+icon+'"></i>'+txt+'</a>';

					str += args.thisObj.createHtml({
						thisObj:  args.thisObj,
						level:    2,
						list:     args.childs,
						layer:    args.sid,
						callback: args.thisObj.buildMenu
					});
					str += '</li>';
				}
				//하위노드가 없으면( 서브 메뉴 중에...
				else {
					//console.log(args.menu);
					var cfg = '';
					//권한이 없을 경우
					//cfg = 'disabled:true';
					//2016/12/12 김영진 -- 상단메뉴 구분자 추가
					if(args.menu.sepaText == "-"){
						str += '<li style="width:90%;height:1px;background-color:#cdcdcd;margin:0 auto;"></li>';
					//2016/09/29 김영진 수정 화면 권한이 없거나 페이지가 비활성화일때.
					}else if(args.menu.progAuth == '0' || args.menu.progAuth == null || args.menu.enableYn == "N" || args.menu.enableYn == null){
						if(icon != null){
							str += '<li data-options="'+cfg+'" class="noAuth"><i class="drowpdown-menu-icon fa '+icon+'"></i>'+txt+'</li>';
						}else{
							str += '<li data-options="'+cfg+'" class="noAuth">'+txt+'</li>';
						}
					}else{
						// BBUG.TEST : 서브 메뉴 중 하위가 없으연...style="color:#ff0000"
						if(icon != null){
							str += '<li data-options="'+cfg+'"><a href="javascript:'+lnk+'" style="color:#000000;position:relative;"><i class="drowpdown-menu-icon fa '+icon+'"></i>'+txt+'</a></li>';
						}else{
							str += '<li data-options="'+cfg+'"><a href="javascript:'+lnk+'" style="color:#000000">'+txt+'</a></li>';
						}
					}
				}
				return str;
			},
			existList: function(list) {
				return (list &&
						list.length &&
						list.length > 0);
			}
		},

	//-----------------------------------------//
	//중앙탭패널 컨트롤
	tabs: {
		consts: {
			KEY: "#wui-tabs",
			URL: "/frame.do"
		},
		tab: false,
		exist: function() {
			if (this.tab)
				return true;
			return false;
		},
		//Home 탭 생성 (닫기 불가, /homeContent.do를 iframe으로 로딩)
		createHome: function() {
			// 탭 위젯 초기화 (create 호출로 위임)
			this.create({});

			if (!this.tab) return;

			// Home 탭이 이미 있으면 무시
			if (this.tab.tabs('exists', 'Home')) return;

			var iframeUrl = getUrl('/homeContent.do');
			this.tab.tabs('add', {
				id:       'HOME',
				title:    'Home',
				content:  '<iframe scrolling="yes" frameborder="0" id="iframe-HOME" name="iframe-HOME" src="' + iframeUrl + '" class="wui-iframe tap-iframe" onload="windowResizing();"></iframe>',
				cls:      'wui-tab',
				closable: false
			});
		},
		//중앙탭 패널추가
		create: function( args ) {
			if ($(this.consts.KEY).length <= 0)
				return;

			if (this.tab == false) {
				this.tab = $(this.consts.KEY);
				//탭생성
				this.tab.tabs({
					fit: true,
					//탭선택시 좌측메뉴 보여주기
					onSelect: function(title, index) {
						var panel = $(this).tabs('getTab', index);
						var popts = panel.panel('options');
						//좌측서브메뉴 트리 생성
						jwidget.submenu.load(popts.id);

						// 새로고침 복원용: 활성 탭 저장 (Home이면 제거)
						if (popts.id === 'HOME') {
							sessionStorage.removeItem('activeTab');
							// Home 탭 팝업 re-center (hidden 상태에서 열린 팝업 보정)
							setTimeout(function() {
								try {
									var f = document.getElementById('iframe-HOME');
									if (f && f.contentWindow && f.contentWindow.$) {
										var $f = f.contentWindow.$;
										$f('[id^="popup-"]').each(function() {
											try {
												if (!$f(this).dialog('options').closed) {
													$f(this).dialog('center');
												}
											} catch(e) {}
										});
									}
								} catch(e) {}
							}, 100);
						} else {
							sessionStorage.setItem('activeTab', popts.id);
						}
					},
					//탭을 모두 닫을시에 메인 index로 가게해준다. 2017 05-31 박상후
					onClose: function(title,index){
						//alert("call");
						if($(this).find(".tabs li").length==0){
							//$(location).attr('href', context + "/lsdpw/index.do");
							$(location).attr('href', context + "/index.do");
						}
						
					},
					onBeforeClose: function(title, index){
						var ordrObj;
						var block = $(".panel.wui-tab");
						for(var i=0; i < block.length; i++){
							var dbView = block[i];
							if($(dbView).css("display") == 'block'){
								var frame = $(dbView).find("iframe");
								ordrObj = $(frame)[0].contentWindow;
							}
						}
						
						//외부 경로일 경우 접근 오류
						if(frame.attr("src") == '' || frame.attr("src").indexOf("http") > -1) {
							return true;
						}
						
						var ordrYn = ordrObj.$("#ordrCrtTab").val();
						ordrObj.$("#ordrIndex").val(index);
						if(ordrYn == 'Y'){
							ordrObj.doOrdrClose();
							return false;
						}else{
							return true;
						}
						
					}
					/*,
					onAdd: function(title, index) {
						debugger;
					    const tab = $(this).tabs('getTab', index);
					    const iframe = tab.find('iframe[data-src]');
					    
					    if (iframe.length > 0) {
					    	setTimeout(function() {
						      const src = iframe.data('src');
						      iframe.attr('src', src);
					    	}, 500); // 0.5초~1초 정도 여유
					     }
					 }*/
				});
			}
			if (!args)
				return;
			if (jutils.empty(args.menuDesc))
				return;
			
//			if (args.menuDesc == 'Dealer Retail List' || args.menuDesc == 'Dealer Wholesale List' || args.menuDesc == 'Dealer Open Order Report'
//				|| args.menuDesc == 'Dealer Inventory List' || args.menuDesc == 'Dealer Warranty Status'){
//				//탭패널이 없는경우 탭패널 추가
//				this.add(args);
//			}else{
//				//탭패널이 있는경우 탭패널 선택
//				if (this.active(args.menuDesc)){
//					return;
//				}
//				//탭패널이 없는경우 탭패널 추가
//				this.add(args);
//			}
			
			//탭패널이 있는경우 탭패널 선택
			//if (this.existsTabById(args.menuKey)) {
			if (this.active(args.menuDesc)) {
				let iframeUrl = getUrl(args.menuUrl);
				
				//let reg = /[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/ ]/gim;
				//let iframeNm = args.menuKey.replace(reg, "");
				
				let iframeNm = fnMenuKeyReplace(args.menuKey);
				
				$("#iframe-"+ iframeNm).attr("src", iframeUrl);
				
				return;
			}
			
			//탭패널이 없는경우 탭패널 추가
			this.add(args);
			
		},
		getMenuSubData: function(args) {
			let menuObject = new Object();
			$.ajax({
				url: getUrl("/common/user/menu/searchMenu.json"),
		        dataType: 'json',
		        data: {
		        	windowId: args.menuKey,
		        	menuKey: args.menuKey,
		        	menuDesc: args.menuDesc,
		        	menuUrl: args.menuUrl,
		        	parentDesc: args.parentDesc
		        },
		        type: 'post',
		        async: false,
				success: function(data) {
					//menuMsg = data.menuMsg;
					menuObject = data;
					
				}
			});
			console.log(menuObject);
			
			return menuObject;
		},
		//중앙탭의 패널 추가
		add: function(args) {
			//let menuObject = jwidget.tabs.getMenuSubData(args);
			
			/*var content = ''
				+ '<iframe '
				+ 'scrolling="yes" '
				+ 'frameborder="0" '
				+ 'src="'+ getUrl(args.menuUrl) +'" '
				+ 'class="wui-iframe">'
				+'</iframe>';*/
			
			var rootMenu = jmenus.getMap(args.menuKey);
			
			var curMenu = jmenus.getMenu(args.menuKey);
			var parentMenu = jmenus.getMap(curMenu.parentKey); //부모
			
			let navTxt = "";
			let pKey = curMenu.parentKey;
			
			if(pKey != rootMenu.parentKey) {
				for (var n=0;n<5;n++) {
					var pMenu = jmenus.getMenu(pKey);
					if(pMenu.parentKey == rootMenu.parentKey) {
						//navTxt += ( "&nbsp;>&nbsp;"+ pMenu.menuDesc );
						
						navTxt =  navTxt == '' ? pMenu.menuDesc : pMenu.menuDesc + "&nbsp;>&nbsp;"+ navTxt;
						break;
					}
					//navTxt += ( "&nbsp;>&nbsp;"+ pMenu.menuDesc );
					navTxt = navTxt == '' ? pMenu.menuDesc : pMenu.menuDesc + "&nbsp;>&nbsp;" + navTxt;
					
					pKey = pMenu.parentKey;
				}
			}
			else {
				//navTxt += ( "&nbsp;>&nbsp;"+ parentMenu.menuDesc );
				navTxt = parentMenu.menuDesc;
			}
			
			let iconCls = args.iconCls == null || args.iconCls == '' ? 'default' : args.iconCls;
			
			let iframeNm = "iframe-" + fnMenuKeyReplace(args.menuKey);
			
			let iframeUrl = ( args.menuUrl == "" ||  args.menuUrl.indexOf("http") > -1 ) ? args.menuUrl : getUrl(args.menuUrl);
			
			var content = ''
				/*
					+ '<div class="topnav_sty" style="display: flex; align-items: center; padding: 10px;">'
					+ '<div class="topnav_div ' + iconCls +'" style="display:flex; flex: 1; margin: 0 10px; color: #000000; font-size: 15px; font-weight: 400; align-items: center; justify-content:space-between;">'
					+ '		<div style="flex: 1;">'
					+ '			Home&nbsp;>&nbsp;' + navTxt + '&nbsp;>&nbsp;<b>' + args.menuDesc + '</b>'
					+ '		</div>'
					+ '		<div id="topnavSubMsgDiv" class="topnavSubMsg" style="color:'+menuObject.msgFontColor+'; text-align: right;"><b><span id="s_topnavSubMsg">' + menuObject.menuMsg + '</span></b></div>'
					+ '</div>'
					+ '</div>'
				*/
				
				+ '<iframe '
				+ 'scrolling="yes" '
				+ 'frameborder="0" '
				+ 'id="' + iframeNm + '" '
				+ 'name="' + iframeNm + '" '
				+ 'src="'+ iframeUrl +'" '
				//+ 'data-src="'+ iframeUrl +'" '
				+ 'class="wui-iframe tap-iframe" onload="windowResizing();">'
				+'</iframe>';
			
			tabsMenuDesc = args.menuDesc;
			
			console.log("tt : " + tabsMenuDesc);
			
			// 이미 즐겨찾기에 있는 메뉴인지 확인 → 없을 때만 추가 버튼 표시
			var _hotTools = [];
			var _isHot = false;
			try {
				$.ajax({
					url: jwidget.hotmenu.consts.URL.select,
					dataType: 'json', type: 'post',
					data: {menuKey: args.menuKey},
					async: false,
					success: function(d) {
						if (d && d.rows && d.rows.menuKey) _isHot = true;
					}
				});
			} catch(e) {}
			if (!_isHot) {
				_hotTools = [{
					iconCls:'icon-mini-add',
					handler:function() {
						jwidget.hotmenu.add(args.menuKey);
					}
				}];
			}

			this.tab.tabs('add', {
				id:       args.menuKey,
				title:    args.menuDesc,
				content:  content,
				cls:      'wui-tab',
				closable: true,
				tools:    _hotTools
			});
			
			// Add language link inside tabs-wrap (only for LANG_ADMIN group)
			setTimeout(function() {
				// Check permission: groupIdC === 'LANG_ADMIN'
				if(typeof groupIdC !== 'undefined' && groupIdC === 'LANG_ADMIN') {
					var tabsWrap = this.tab.find('.tabs-header .tabs-wrap');
					if(tabsWrap.length > 0) {
						// Check if language link already exists
						if(tabsWrap.find('#tabs-language-link').length === 0) {
							// Set tabs-wrap to display flex for inline layout
							tabsWrap.css('display', 'flex');
							tabsWrap.css('align-items', 'center');
							var languageLink = $('<div id="tabs-language-link" style="display: inline-block; margin-left: 10px; padding: 5px 10px; background-color: #f5f5f5; border: 1px solid #ddd; border-radius: 3px; cursor: pointer; color: #337ab7; font-size: 13px; vertical-align: middle; white-space: nowrap;">language</div>');
							// Click event handler to call langTextSave in iframe
							languageLink.on('click', function() {
								var tabPanel = this.tab.tabs('getSelected');
								if(tabPanel && tabPanel.length > 0) {
									var tabId = tabPanel.panel('options').id;
									var iframe = tabPanel.find('iframe.wui-iframe');
									if(iframe.length > 0) {
										// Try to call langTextSave in iframe with retry logic
										var tryCallIframe = function(retryCount) {
											retryCount = retryCount || 0;
											try {
												var iframeWindow = iframe[0].contentWindow;
												if(iframeWindow && iframeWindow.$ && iframeWindow.langTextSave) {
													// Check if text_menuKey exists in iframe
													var menuKeyVal = iframeWindow.$("#text_menuKey").val();
													if(menuKeyVal) {
														iframeWindow.langTextSave();
													} else if(retryCount < 10) {
														// Retry if iframe is still loading
														setTimeout(function() {
															tryCallIframe(retryCount + 1);
														}, 300);
													} else {
														$.messager.alert("Error", "메뉴 키를 찾을 수 없습니다. 페이지가 완전히 로드될 때까지 기다려주세요.", 'error');
													}
												} else if(retryCount < 10) {
													// Retry if iframe is still loading
													setTimeout(function() {
														tryCallIframe(retryCount + 1);
													}, 300);
												} else {
													$.messager.alert("Error", "언어 저장 기능을 사용할 수 없습니다. 페이지가 완전히 로드될 때까지 기다려주세요.", 'error');
												}
											} catch(e) {
												if(retryCount < 10) {
													setTimeout(function() {
														tryCallIframe(retryCount + 1);
													}, 300);
												} else {
													$.messager.alert("Error", "언어 저장 기능을 사용할 수 없습니다.", 'error');
												}
											}
										};
										tryCallIframe(0);
									} else {
										$.messager.alert("Error", "페이지를 찾을 수 없습니다.", 'error');
									}
								}
							}.bind(this));
							tabsWrap.append(languageLink);
						}
					}
				}
			}.bind(this), 100);
			
			$('.icon-mini-add').tooltip({content:'Hot Menu 추가'});
			
			//salesforce SSO
			/*
			if(salesforceYn) {
				window.location.href = getUrl("/saml/ssoservice.do?target=" + iframeNm);
			}
			*/
			
		},
		//탭정보 가져오기
		titleGet: function(desc) {
			tabsMenuDesc = args.menuDesc;
		},
		//중앙탭의 특정패널 선택
		active: function(desc) {
			if (this.tab.tabs('exists', desc)) {
				this.tab.tabs('select', desc);
				return true;
			}
			return false;
		},
		getInfo: function() {
			//var tab = $(this).tab.tabs('getSelected');
			//var index = $(this).tab.tabs('getTabIndex',tab);
			//console.log($(this).tab);
			//var index = this.tab.tabs('getTabIndex', $('#tab-1'));
			//var tab = $(this).tabs('getSelected');
			//var tab = this.tab.tabs('getSelected');
			//var tab = this.tab;
			console.log(this.tab);
			console.log(this.tab.tabs);
			return true;
		},
		//tab id로 확인
		existsTabById: function(id) {
			let rtDt = false;
		    var allTabs = this.tab.tabs('tabs'); // 모든 탭(panel) 가져오기
	        for (var i = 0; i < allTabs.length; i++) {
	            var opts = allTabs[i].panel('options');
	            
	            if (opts.id === id) {
	                var index = this.tab.tabs('getTabIndex', allTabs[i]);
	                this.tab.tabs('select', index);
	                rtDt = true;
	                break;
	            }
	        }
		    return rtDt;
		}
	},
	//-----------------------------------------//
	//좌측 서브메뉴
	submenu: {
		consts: {
			//TITLE: 'Menu', //상단 메뉴 제거
			//20160929 박소현
			//ICON:  'ui-icon ui-icon-star',
			ICON : 'ui-icon ui-icon-circle-triangle-e',
			PKEY:  "#left-submenu", //패널KEY
			TKEY:  "#left-menu",    //트리KEY
			CKEY:  "#left-context", //컨텍스트메뉴KEY
			HEIGHT:400,
			WIDTH: 200
		},
		panel: false,
		tree:  false,
		mctx:  false,
		menu:  false,
		exist: function() {
			if (this.tree && this.tree.length > 0)
				return true;
			return false;
		},
		//메뉴 로딩
		load: function(key) { //LSTA
			//var data = jmenus.getMap(key);
			var data;
			if(key == null) {
				data = jmenus.MENUS;
			}
			else {
				//data = jmenus.getMap(key);
				data = jmenus.MENUS;
			}
			
			//데이터가 유효하지 않으면 중단
			if (!data) return;

			var menu = this.menu;
			//동일한 메뉴그룹인 경우 SKIP
			if (data && menu && data.menuKey == menu.menuKey)
				return;

			//패널생성
			if (this.panel == false) {
				this.panel = $(this.consts.PKEY);
				this.panel.panel({
					title:   this.consts.TITLE,
					iconCls: this.consts.ICON,
					//height:  this.consts.HEIGHT,
					//width:   this.consts.WIDTH,
					collapsible:true,
					fit:true
				});
			}

			//트리생성
			//2016/09/29  김영진 주석 --서브메뉴 최상단 부모 삭제
			/*if (this.tree == false) {
				this.tree = $(this.consts.TKEY);
				this.mctx = $(this.consts.CKEY);
				var p = this;
				this.tree.tree({
					fit: true,
					onSelect: function(node){
						if(!node.children) {
							var a = node.attributes;
							jmenus.go(a.menuKey);
						}
					},
					onContextMenu: function(e,node) {
						e.preventDefault();
						$(this).tree('select',node.target);
						p.mctx.menu('show',{left: e.pageX,top: e.pageY});
					}
				});
			}
			//데이터 백업
			this.menu = data;
			//트리데이터 로드
			this.tree.tree('loadData', this.rebuild([this.menu])); */
			//console.log(this.menu = data);
			this.menu = data;
			//트리생성
			this.rebuild([this.menu]);

		},
		//메뉴객체
		get: function() {
			return $(this.consts.TKEY);
		},
		//메뉴트리 생성
		create: function(data) {
			var jobj = this;
			var mctx = $(this.consts.CKEY);

			jobj.get().tree({
				fit: true,
				data: data,
				onSelect: function(node) {
					if(!node) return;

					//홈버튼을 누르면 index로 이동
					if(node.text == 'Home') {
						goHome();
						//document.location.href = context + "/";
						return;
					}
					
					//열려있는 것 닫기 - 본인 및 즐겨찾기 제외
					if($('#'+node.domId).find(".fa-angle-left").length > 0) {
						$(".fa-angle-left").each(function() {
							let ele = $(this).parents(".tree-node");
							// 즐겨찾기 상위메뉴는 접지 않음
							if (ele.attr("id") === '_hotmenu_parent') return;
							
							let levelNum = ele.attr("class").match(/tree-level(\d+)/);

							if( ele.attr("id") != node.domId && 
								 ele.hasClass("tree-level"+node.attributes.menuLevel) )
								//|| (ele.hasClass("newType") && !ele.hasClass("tree-level3") && !ele.hasClass("tree-level4") && node.attributes.menuLevel == '2') ) ) 
								{
								if(ele.css("display") != 'none') {
									ele.click();
								}
								if($(this).hasClass("fa-angle-left")) {
									$(this).removeClass('fa-angle-left');
									$(this).addClass('fa-angle-right');
								}
							}
							else if(ele.attr("id") != node.domId && 
									( //(node.attributes.menuLevel == '2' && ele.hasClass("newType") ) 
											//(ele.hasClass("tree-level"+node.attributes.menuLevel)) || 
											( node.attributes.menuLevel < ( levelNum ? parseInt(levelNum[1], 10) : 0 ) ) 
									)
									) {
								$(this).removeClass('fa-angle-left');
								$(this).addClass('fa-angle-right');
							}
						});
					}
					
					//20180820 박민혁 서브메뉴 3단 상위메뉴 링크 안함
					if((node.attributes.menuLevel == 2 || node.attributes.menuLevel == 3) && node.attributes.submenuYn == "Y") return;
					if(!node.children && node.enableYn == "Y" && node.progAuth == "1") {
						var a = node.attributes;
						jmenus.go(a.menuKey);
						return;
					}
					
					var a = node.attributes;
					jmenus.go(a.menuKey);
					return;
					
				},

				onContextMenu: function(e,node) {
					e.preventDefault();
					// 즐겨찾기 하위메뉴(직접 삽입 HTML)는 easyui tree 노드가 아니므로 node=null
					if (!node) return;
					// submenuYn='Y'인 상위메뉴는 제외
					var attr = node.attributes || {};
					if (attr.submenuYn === 'Y') return;

					// 기존 하이라이트 제거 후 현재 노드만 하이라이트
					$(this).find('.tree-node-selected').removeClass('tree-node-selected');
					$(node.target).addClass('tree-node-selected');
					// 컨텍스트 메뉴에서 선택한 노드 참조 저장
					jwidget.submenu._contextNode = node;
					mctx.menu('show',{left: e.pageX,top: e.pageY});
				},
				onLoadSuccess: function() {
					//메뉴 권한 없을 경우 설정
					$(".fa-angle-right").parent().removeClass("noAuth");
					$("#left-menu > li > div:not(.tree-level3, .tree-level4)").removeClass("noAuth").addClass("tree-level2");

					// 메뉴 트리 로드 완료 후 즐겨찾기(LS099) 하위 로드
					jwidget.hotmenu.load();

					//메뉴에 마우스를 올렸을 때, 메뉴의 텍스트가 잘렸다면 다 보여주기
					//툴팁형
					/*
				    jobj.get().find('.tree-title').each(function () {
				        const text = $(this).text();
				        $(this).tooltip({
				          content: text,
				          position: 'right',
				          trackMouse: true,
			        	  onShow: function () {
		        		    const tip = $(this).tooltip('tip');
		        		    
		        		    // 사용자 정의 클래스 추가
		        		    tip.addClass('menu-tooltip');
		        		  }
				        });
				      });
				    */
				   
					//div 이용
					let hoverTimer;
					let isHovering = false;

					function showHoverPopup($li) {
					    // 기존 호버 제거 (다른 li에서 넘어온 경우 포함)
					    $(".tree-node.menuHover").removeClass("menuHover");
					    const $treeNode = $li.find(".tree-node");
					    const text = $li.find(".tree-title").text();
					    
					    const parentOffset = $treeNode.offset();
					    const offset = $li.find(".tree-title").offset();
					    
					    const $title = $li.find(".tree-title");
					    
					    const treeRect = $treeNode[0].getBoundingClientRect();
					    const titleRect = $title[0].getBoundingClientRect();
					    
					    let parentWidth = parseFloat($treeNode.css("width"));
					    let width = parseFloat($li.find(".tree-title").css("width"));
					    let pdl = $li.find(".tree-title").css("padding-left");

					    if ( (parentOffset.left + parentWidth - 50) < offset.left + width) {
					        $treeNode.addClass("menuHover");

					        $('#hoverTextPopup')
					            .text(text)
					            .css({
					                top: treeRect.top,
					                left: titleRect.left,
					                display: 'block',
					                height: $treeNode.css("height"),
					                fontSize: $li.find(".tree-title").css("font-size"),
					                fontWeight: $li.find(".tree-title").css("font-weight"),
					                padding: $treeNode.css("padding"),
					                paddingLeft: 0,
					                marginLeft: pdl,
					                color: '#ffef74'
					            });
					    } else {
					        $('#hoverTextPopup').hide();
					    }
					}

					function handleMouseEnter($li) {
					    clearTimeout(hoverTimer);
					    isHovering = true;
					    showHoverPopup($li); 
					}

					function handleMouseLeave() {
					    isHovering = false;
					    hoverTimer = setTimeout(() => {
					        if (!isHovering) {
					            $(".tree-node.menuHover").removeClass("menuHover");
					            $('#hoverTextPopup').hide();
					        }
					    }, 150);
					}

					$("#left-menu li")
					    .on("mouseenter", function () {
							//메뉴가 줄어들어있으면 동작 안하도록
							if(isCollapsed) {
								return;
							}
					        handleMouseEnter($(this));
					    })
					    .on("mouseleave", function () {
							//메뉴가 줄어들어있으면 동작 안하도록
							if(isCollapsed) {
								return;
							}
					        handleMouseLeave();
					    });

					$("#hoverTextPopup")
					    .on("mouseenter", () => {
					        clearTimeout(hoverTimer);
					        isHovering = true;
					    })
					    .on("mouseleave", () => {
					        handleMouseLeave();
					    });
					
					$("#left-submenu").on("scroll", function () {
						//handleMouseLeave();
						isHovering = false;
						$(".tree-node.menuHover").removeClass("menuHover");
			            $('#hoverTextPopup').hide();
						
					});
				  }
				
			});

			//아이콘 숨기기
			$(".tree-level3").each(function() {
				$(this).find(".tree-icon").eq(0).hide();
			});
			
			$(".tree-level4").each(function() {
				$(this).find(".tree-icon").eq(0).hide();
			});
			
		},
		rebuild: function( menus ) {
			console.log(menus);
			var p   = this;
			var arr = [];

			if (!menus) return;

			if(menus.length == 1) {
				$.each(menus, function(ii,d) {
					if (!d || !Array.isArray(d)) return; // 데이터 유효성 체크

					//2016/12/12 김영진 -- 좌측메뉴 구분자시 표시안함
					d.forEach(function(c,i) {
						// 드롭다운 전용 메뉴는 좌측 메뉴에서 숨김 (설정: jwidget.menu.consts.submenuKey)
						if(c.menuKey == jwidget.menu.consts.submenuKey) return;
						if(c.enableYn == "Y") {
							if(c.menuLevel == "1" || c.progAuth == "1") {
							if(c.sepaText != "-"){
								//3단메뉴
								//if(c.menuLevel != 1 && c.subs){
								if(c.subs){
									arr.push( p.filter(c) );
									for(j=0;j<c.subs.length;j++){
										arr.push( p.filter(c.subs[j]) );
										
										if(c.subs[j].subs){
											for(k=0;k<c.subs[j].subs.length;k++){
												arr.push( p.filter(c.subs[j].subs[k]) );
											}
										}
									}
								}
								else {
									arr.push( p.filter(c) );
								}
							}
							}
						}
						
					});
					
					
				});
				
			}
			else {
				$.each(menus, function(i,c) {
					//2016/12/12 김영진 -- 좌측메뉴 구분자시 표시안함
					if(c.sepaText != "-"){
						//3단메뉴
						if(c.menuLevel != 1 && c.subs){
							arr.push( p.filter(c) );
							for(j=0;j<c.subs.length;j++){
								arr.push( p.filter(c.subs[j]) );
								
								if(c.subs[j].subs){
									for(k=0;k<c.subs[j].subs.length;k++){
										arr.push( p.filter(c.subs[j].subs[k]) );
									}
								}
							}
						}
						else {
							arr.push( p.filter(c) );
						}
					}
				});
			}
			
			if(arr[0]){
				return p.create(arr);
			}
			return;
		},
		filter: function(menu) {
			var submenuYn = 'N';
			var parentKey = '';
			//if(menu.menuLevel != 1 && menu.subs){
			if(menu.subs){
				submenuYn = 'Y';
				/*if(menu.menuLevel == 2 && menu.subs){
					menu.enableYn = 'N';
				}*/
			}
			//if(menu.menuLevel ==3 || menu.menuLevel == 4){
			if(menu.menuLevel ==2 || menu.menuLevel == 3){
				parentKey = menu.parentKey
			}
			var obj = {
				id  : menu.menuKey,
				text: menu.menuDesc,
				//state: "closed",
				iconCls   : menu.iconCls,
				enableYn  : menu.enableYn,
				progAuth  : menu.progAuth,
				attributes: {
					menuKey: menu.menuKey,
					menuUrl: menu.menuUrl,
					menuDesc: menu.menuDesc,
					parentDesc:menu.parentDesc,
					//menuLevel:menu.menuLevel,
					menuLevel:menu.menuLevel+1,
					submenuYn: submenuYn,
					parentKey: parentKey
				}
			};
			/*if (menu.subs) {
				//obj['state'] = "open";
				//obj['children'] = this.rebuild( menu.subs );
				this.rebuild( menu.subs );
				return;
			}*/
			
			/*
			if(menu.menuLevel == 1){
				this.rebuild( menu.subs );
				return;
			}
			*/
			return obj;
		},
		//선택된 메뉴노드 반환
		getSelected: function() {
			//2016/10/24  박민혁 핫메뉴 수정
			//return this.tree.tree('getSelected');
			return this.get().tree('getSelected');
		},
		//선택된 메뉴노드의 ID 반환 (컨텍스트 메뉴에서 우클릭한 노드 우선)
		_contextNode: null,
		getSelectedId: function() {
			var node = this._contextNode || this.getSelected();
			this._contextNode = null; // 사용 후 초기화
			return node ? node.id : null;
		}
	},
	//-----------------------------------------//
	//좌측 핫메뉴 (#left-menu 트리 내부에 동일 구조로 삽입)
	hotmenu: {
		consts: {
			PARENT_ID: 'HOTMENU',   // 즐겨찾기 상위메뉴 DOM용 ID
			URL: {
				search: getUrl("/common/user/hotmenu/search.json"),
				select: getUrl("/common/user/hotmenu/select.json"),
				save:   getUrl("/common/user/hotmenu/save.json")
			}
		},
		// 핫메뉴 조회 → #left-menu 첫 번째 <li> 앞에 삽입
		load: function() {
			var p = this;
			$.ajax({
				url: this.consts.URL.search,
				dataType: 'json',
				type: 'post',
				success: function(data) {
					if (data && data.rows) {
						p._render(data.rows);
					} else {
						p._render([]);
					}
				}
			});
		},
		// #left-menu 내부에 즐겨찾기 상위+하위 메뉴 <li> 삽입
		_render: function(rows) {
			var pid = this.consts.PARENT_ID;
			var $tree = $('#left-menu');

			// 메뉴 트리가 아직 생성되지 않았으면 무시
			if ($tree.children('li').length === 0) return;

			// 기존 펼침 상태 저장 (fa-angle-left = 펼침)
			var wasOpen = $('#_hotmenu_parent .tree-submenu-icon-angle-right').hasClass('fa-angle-left');

			// 기존 즐겨찾기 노드 제거
			$tree.find('.' + pid + '-item').remove();

			// 상위메뉴 <li> (tree-level2 스타일, submenuOpen 연동)
			var arrowCls = wasOpen ? 'fa-angle-left' : 'fa-angle-right';
			var parentHtml =
				'<li class="' + pid + '-item" style="background-color:#0d121e;">' +
					'<div id="_hotmenu_parent" onclick="submenuOpen(\'' + pid + '\',\'_hotmenu_parent\')" class="tree-node tree-level2">' +
						'<span class="tree-indent"></span>' +
						'<span class="tree-icon" style="width:18px;"><img src="' + context + '/resources/images/tit_icons/bookmark.png" style="width:16px;height:16px;vertical-align:middle;"></span>' +
						'<span class="tree-title">즐겨찾기</span>' +
						'<span class="tree-icon fa ' + arrowCls + ' tree-submenu-icon-angle-right"></span>' +
					'</div>' +
				'</li>';
			$tree.prepend(parentHtml);

			// 하위메뉴 <li> (tree-level3 스타일, 클래스에 PARENT_ID 부여)
			var childDisplay = wasOpen ? 'display:block;' : '';
			for (var i = 0; i < rows.length; i++) {
				var c = rows[i];
				var menuKey = c.menuKey || '';
				var menuDesc = c.menuDesc || '';

				var childHtml =
					'<li class="' + pid + '-item" style="background-color:#0d121e;">' +
						'<div class="tree-node tree-level3 ' + pid + '" data-menukey="' + menuKey + '" style="' + childDisplay + '">' +
							'<span class="tree-indent"></span>' +
							'<span class="tree-icon fa " style="display:none;"></span>' +
							'<span class="tree-title">' + menuDesc + '</span>' +
						'</div>' +
					'</li>';

				// 상위메뉴 바로 뒤에 순서대로 삽입
				$tree.find('.' + pid + '-item:last').after(childHtml);
			}

			// 하위메뉴 클릭 이벤트 바인딩
			$tree.find('div.tree-node.' + pid).off('click').on('click', function() {
				var key = $(this).data('menukey');
				if (key) jmenus.go(key);
			});

			// 마우스 오버/아웃
			$tree.find('div.tree-node.' + pid)
				.off('mouseenter mouseleave')
				.on('mouseenter', function() { $(this).addClass('tree-node-hover'); })
				.on('mouseleave', function() { $(this).removeClass('tree-node-hover'); });

			// 하위메뉴 우클릭 → 즐겨찾기 삭제 컨텍스트 메뉴
			$tree.find('div.tree-node.' + pid).off('contextmenu').on('contextmenu', function(e) {
				e.preventDefault();
				e.stopPropagation();
				jwidget.hotmenu._contextMenuKey = $(this).data('menukey');
				$('#hotmenu-context').menu('show', {left: e.pageX, top: e.pageY});
			});
		},
		_contextMenuKey: null,
		// 핫메뉴 추가
		add: function(key) {
			var p = this;
			var url = this.consts.URL;
			var data = {menuKey: key};
			var title = false;

			// 이미 있는 메뉴인지 확인
			$.ajax({
				url: url.select,
				dataType: 'json',
				type: 'post',
				data: data,
				async: false,
				success: function(data) {
					if (data && data.rows && data.rows.menuKey) {
						title = data.rows.menuDesc;
					}
				}
			});

			if (title) {
				$.messager.alert(msg.MSG0051, '[' + title + ']은 이미 즐겨찾기에 존재합니다.', msg.MSG0051);
				return;
			}

			// 등록상태
			jstatus.insert(data);

			$.ajax({
				url: url.save,
				dataType: 'json',
				type: 'post',
				data: data,
				success: function(result) {
					// 추가 후 펼침 상태 보장 (load→_render에서 wasOpen 감지)
					$('#_hotmenu_parent .tree-submenu-icon-angle-right')
						.removeClass('fa-angle-right').addClass('fa-angle-left');
					// 즐겨찾기 재조회
					p.load();
					// 해당 탭의 즐겨찾기 미니버튼 숨김
					var $tabs = jwidget.tabs.tab;
					if ($tabs) {
						var selTab = $tabs.tabs('getSelected');
						if (selTab) {
							var idx = $tabs.tabs('getTabIndex', selTab);
							$tabs.find('.tabs-header li').eq(idx).find('.tabs-p-tool').hide();
						}
					}
				}
			});
		},
		// 좌측메뉴 컨텍스트에서 메뉴추가
		addByMenu: function() {
			var id = jwidget.submenu.getSelectedId();
			if (id) this.add(id);
		},
		// 즐겨찾기 삭제 (컨텍스트 메뉴에서 호출)
		delByContext: function() {
			var p = this;
			var key = this._contextMenuKey;
			if (!key) return;
			this._contextMenuKey = null;

			var rows = [{menuKey: key, menuDesc: key}];
			var data = {};
			data['models'] = $.toJSON(rows);
			jstatus.remove(data);

			$.ajax({
				url: p.consts.URL.save,
				dataType: 'json',
				type: 'post',
				data: data,
				success: function(result) {
					p.load();
				}
			});
		},
		delByMenu: function() {
			this.delByContext();
		}
	},
	//-----------------------------------------//
	//사이트맵
	sitemap: {
		//메뉴 로딩
		load: function(key) {

			var jobj  = this;
			var panel = $(key);

			//메뉴 전체 목록
			var list = jmenus.get();

			$.each(list, function(i,m) {

				var html = $('<div class="sitemap-menu">' + jobj.write(m, true) + '</div>');

				panel.append(html);

				//html.panel({
				//	width: 300,
				//	height: 500,
				//	title: m.menuDesc
				//});
			});
		},
		write: function( menu, isRoot ) {

			if (!menu)
				return '';

			var jobj = this;
			var leaf = true;
			var auth = false;
			var desc = menu.menuDesc;
			var html = '';

			if (menu.subs &&
				menu.subs.length > 0)
				leaf = false;
			if (menu.progAuth == '1')
				auth = true;


			//권한이 있을 경우에만 링크설정
			if (auth && leaf)
				desc = '<a href="#" onclick="'+jmenus.getLink(menu)+'">'+desc+'</a>';

			if (isRoot)
				html += '<h3>'+desc+'</h3>';
			else
				html += '<span>'+desc+'</span>';

			if (!leaf) {
				html += '<ul>';
				$.each(menu.subs, function(i,m) {
					html += '<li>'+jobj.write(m)+'</li>';
				});
				html += '</ul>';
			}
			return html;
		}
	},
	//-----------------------------------------//
	//메인팝업 컨트롤
	popup: {
		consts: {
			KEY: "popup-dialog",
			PRE: "popup-",
			URL: "/common/board/popup/load.json",
			//TODO 팝업활성 여부(개발시엔 false로 운영시 true로 변경할것)
			USABLE: true
		},
		//팝업로드
		load: function() {

			//팝업비활성일 경우 SKIP 할것.
			if (this.consts.USABLE == false)
				return;

			var p = this;
			$.ajax({
				url: getUrl(this.consts.URL),
		        dataType: 'json',
		        type: 'post',
		        data: {notAnyMore : "Y"},
				success: function(data) {
		        	if (data && data.rows) {
		    			$.each(data.rows, function(i,c) {
		    				p.open(c);
		    			});
		        	}
		        	
		        	jwidget.popup.load_dash();
				}
			});
		},
		//대시보드 공지 팝업 로드
		load_dash: function() {
			var p = this;
			$.ajax({
				url: getUrl(this.consts.URL),
		        dataType: 'json',
		        type: 'post',
		        data: {notAnyMore : "N"},
				success: function(data) {
		        	if (data && data.rows) {
		    			$.each(data.rows, function(i,c) {
		    				popupList[i] = c;
		    			});
		    			
		    			//대시보드 공지 함수
		    			if(document.getElementById("notiTit") != null && data.rows.length > 0) {
		    				$("#notiTit").text(popupList[0].bordTitle);
		    			}
		        	}
				}
			});
		},
		//팝업게시
		open: function(row) {
			//비활성일 경우 SKIP
			if (row.useFlag == 'N')
				return;
			//접근불가일 경우 SKIP
			if (row.enable == false)
				return;

			var cookie = true;
			var key = this.consts.KEY;
			var pre = this.consts.PRE + row.bordNo;

			//미리보기인 경우 쿠키확인 제외
			if (row.preview)
				cookie = false;

			//쿠키 체크이면서 쿠키가 설정되어 있을경우 SKIP
			if (cookie && getCookie(pre) != "")
				return;

			if ($("#"+pre).length == 0) {
				$("#"+key).append('<div id="'+pre+'" style="border-top-width:1px"></div>');
			}

			var openCls = row.openCls;
			var bordGrup = row.bordGrup;
			var bordNo = row.bordNo;
			var title   = row.bordTitle;
			var type   = row.bordType;
			//대시보드 팝업 더이상 안보기
			if(openCls == "Y") {
				var content = '<div class="wui-popup dash-pop" >'
			        + row.bordText
			        + '</div>'
			        + "<div class=\"pop_style\" style=\"width:"+((row.width  ? row.width  : 100) - 24)+"px; margin-bottom: 7px; padding-bottom: 36px;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" onclick=\"javascript:doNomoreSeeClose('"+bordGrup+"','"+bordNo+"','"+pre+"','"+type+"')\"/>Not any more&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" onclick=\"javascript:doCookieOneDayClose('"+pre+"')\"/>No more today&nbsp;&nbsp;<a href=\"javascript:doCookieClose('"+pre+"')\" class=\"easyui-linkbutton btn_close\">Close</a></div>";
		
			} else {
				var content = '<div class="wui-popup dash-pop" >'
			        + row.bordText
			        + '</div>'
			        + "<div class=\"pop_style\" style=\"width:"+((row.width  ? row.width  : 100) - 24)+"px; margin-bottom: 7px; padding-bottom: 36px;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" onclick=\"javascript:doCookieOneDayClose('"+pre+"')\"/>No more today&nbsp;&nbsp;<a href=\"javascript:doCookieClose('"+pre+"')\" class=\"easyui-linkbutton btn_close\">Close</a></div>";
		
			}
			var buttons = [];
			//쿠키체크인 경우
			if (cookie) {
				/*buttons.push({checkbox:true,text:'하루동안숨김', handler:function(){
					//하루동안 쿠키설정(utilities.js)
					setCookie(pre, "Y", 1);
					$("#"+pre).dialog('close');
				}});*/
				buttons.push({type:'checkbox'})

			}
			buttons.push({text:'Close', handler:function(){
					$("#"+pre).dialog('close');
				}
			});
			$("#"+pre).dialog({
				closed:  false,
				cache:   false,
				modal:    true,
				width:   (row.width  ? row.width  : 100),
				height:  (row.height ? row.height : 100),
				title:    title,
				content:  content,
				onOpen: function(){
					$(this).dialog("center");
				},
				onResize: function(){
					$(this).dialog("center");
				}
			});
		}
	}

};

function doNomoreSeeClose(Grup, No, pre, type) {
	
	$.ajax({
		url: getUrl('/common/board/popup/insertTarget.json'),
        dataType: 'json',
        data: {
        	bordNo   : No,
        	bordGrup : Grup,
        	bordType : type
        },
        type: 'post',
		success: function(data) {
        	
		}
	});
	$("#"+pre).dialog('close');
}

function doCookieOneDayClose(pre){
	setCookie(pre, "Y", 1);
	$("#"+pre).dialog('close');
}

function doCookieClose(pre){
	$("#"+pre).dialog('close');
}

function fnMenuKeyReplace(strName) {
	let reg = /[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/ ]/gim;
	let iframeNm = strName.replace(reg, "");
	return iframeNm;
}

// ============================================================================
// GridHeaderMenu — datagrid/treegrid 헤더 컨텍스트 메뉴 공통 모듈
// ============================================================================
//
// 사용법:
//   GridHeaderMenu('#my-grid');                                     // datagrid 기본
//   GridHeaderMenu('#my-grid', { exportFileName: '사원목록' });      // 파일명 지정
//   GridHeaderMenu('#my-tree', { type: 'treegrid', excel: false }); // treegrid
//
// 옵션:
//   type           : 'datagrid' — 'datagrid' 또는 'treegrid'
//   sort           : true  — 오름차순/내림차순/정렬초기화
//   columnToggle   : true  — 컬럼 숨기기/표시
//   autoFit        : true  — 전체 컬럼 자동크기
//   rownumbers     : true  — 행번호 표시/숨김
//   excel          : true  — 엑셀(CSV)로 저장
//   reset          : true  — 초기화
//   exportFileName : '데이터' — CSV 파일명 접두어
// ============================================================================
function GridHeaderMenu(selector, opts) {
    opts = $.extend({
        type: 'datagrid',
        sort: true,
        columnToggle: true,
        autoFit: true,
        rownumbers: true,
        excel: true,
        reset: true,
        exportFileName: '데이터'
    }, opts);

    var $grid = $(selector);
    if (!$grid.length) return;

    var type = opts.type;  // 'datagrid' 또는 'treegrid'

    // 인스턴스별 고유 ID (여러 그리드 동시 사용 시 충돌 방지)
    var menuId = selector.replace(/[^a-zA-Z0-9]/g, '') + '-hctx';

    // 상태
    var currentField = '';
    var hiddenColumns = {};
    var originalWidths = null;
    var _originalData = null;
    var _internalLoad = false;
    var _rownumbersHidden = false;
    var _sortDataRef = null;  // 정렬 시 사용된 data 객체 참조 (페이징 이벤트 구분용)
    var _autoFitActive = false;     // autoFit 적용 상태 플래그
    var _originalFitColumns = null; // autoFit 전 fitColumns 설정 (resetGrid에서 복원용)

    // --------------------------------------------------
    // 기존 콜백 체이닝 (사용자 콜백 보존)
    // --------------------------------------------------
    var dgOpts = $grid[type]('options');
    var _origOnLoadSuccess = dgOpts.onLoadSuccess;
    var _origOnResizeColumn = dgOpts.onResizeColumn;

    // 헤더 우클릭: DOM 직접 바인딩 (datagrid/treegrid 모두 동작)
    $grid[type]('getPanel').on('contextmenu.ghm', '.datagrid-header td[field]', function(e) {
        e.preventDefault();
        currentField = $(this).attr('field');
        showMenu(e.pageX, e.pageY);
    });

    dgOpts.onLoadSuccess = function(data) {
        // 행번호 숨김 상태 유지
        if (_rownumbersHidden) {
            $grid[type]('getPanel').find('.datagrid-td-rownumber').hide();
        }
        // 정렬/초기화 내부 loadData 시에는 원본 유지
        if (_internalLoad) {
            _internalLoad = false;
        } else if (_originalData) {
            // 페이징 이벤트(동일 data 객체)는 _originalData 유지,
            // 새로운 검색(다른 data 객체)은 _originalData 초기화
            var currentData = $grid[type]('getData');
            if (_sortDataRef !== currentData) {
                _originalData = null;
                _sortDataRef = null;
            }
        }
        // autoFit 적용 상태이면 table width auto + overflow-x 재적용
        // (셀 너비는 EasyUI stylesheet가 유지하므로 재적용 불필요)
        if (_autoFitActive) {
            var _panel = $grid[type]('getPanel');
            _panel.find('.datagrid-header table, .datagrid-body table').css('width', 'auto');
            var _dgData = $.data($grid[0], 'datagrid');
            if (_dgData && _dgData.dc && _dgData.dc.body2) {
                _dgData.dc.body2.css('overflow-x', '');
            }
        }
        // 기존 콜백 호출
        if (_origOnLoadSuccess) _origOnLoadSuccess.apply(this, arguments);
    };

    dgOpts.onResizeColumn = function(field, width) {
        // 수동 리사이즈 시 autoFit 상태 해제 (stale 캐시 방지)
        _autoFitActive = false;
        if (_origOnResizeColumn) _origOnResizeColumn.apply(this, arguments);
    };

    // --------------------------------------------------
    // 공통 비교 함수
    // --------------------------------------------------
    function compareValues(a, b, field, order) {
        var va = a[field], vb = b[field];
        if (va == null) va = '';
        if (vb == null) vb = '';
        if (va !== '' && vb !== '' && !isNaN(va) && !isNaN(vb)) {
            return order === 'asc' ? Number(va) - Number(vb) : Number(vb) - Number(va);
        }
        va = String(va).toLowerCase();
        vb = String(vb).toLowerCase();
        if (va < vb) return order === 'asc' ? -1 : 1;
        if (va > vb) return order === 'asc' ? 1 : -1;
        return 0;
    }

    // --------------------------------------------------
    // 트리 데이터 유틸리티
    // --------------------------------------------------
    // 깊은 복사 (정렬 전 원본 보존용)
    function deepCloneTree(arr) {
        return JSON.parse(JSON.stringify(arr));
    }

    // 재귀 정렬 (형제 노드끼리만 정렬, 부모-자식 관계 유지)
    function sortTreeRecursive(nodes, field, order) {
        if (!nodes || !nodes.length) return;
        nodes.sort(function(a, b) { return compareValues(a, b, field, order); });
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].children) sortTreeRecursive(nodes[i].children, field, order);
        }
    }

    // 트리를 flat 행 배열로 변환 (엑셀 내보내기용)
    function flattenTree(nodes, result, depth) {
        if (!nodes) return;
        depth = depth || 0;
        for (var i = 0; i < nodes.length; i++) {
            var row = $.extend({}, nodes[i]);
            row._depth = depth;
            result.push(row);
            if (nodes[i].children) flattenTree(nodes[i].children, result, depth + 1);
        }
    }

    // datagrid: flat rows 가져오기, treegrid: flat rows 가져오기
    function getAllRows() {
        if (type === 'treegrid') {
            var data = $grid[type]('getData');
            var rows = [];
            flattenTree(data, rows, 0);
            return rows;
        } else {
            var data = $grid[type]('getData');
            // clientPagerFilter 사용 시 originalRows에 전체 데이터 보관됨
            return data.originalRows || data.rows || [];
        }
    }

    // --------------------------------------------------
    // 메뉴 표시
    // --------------------------------------------------
    function showMenu(x, y) {
        var $old = $('#' + menuId);
        if ($old.length) {
            try { $old.menu('destroy'); } catch(e) {}
            $old.remove();
        }

        var h = '<div id="' + menuId + '" style="width:170px;">';

        // 정렬 
        // 정렬 기능은 헤더 클릭으로 대체함으로 
        if (false && opts.sort) {
            h += '<div id="' + menuId + '-sort-asc">오름차순 정렬</div>';
            h += '<div id="' + menuId + '-sort-desc">내림차순 정렬</div>';
            h += '<div id="' + menuId + '-sort-reset">정렬 초기화</div>';
            h += '<div class="menu-sep"></div>';
        }

        // 컬럼 숨기기/표시
        if (opts.columnToggle) {
            h += '<div id="' + menuId + '-hide-col">컬럼 숨기기</div>';
            h += '<div class="menu-sep"></div>';
            h += '<div><span>컬럼 표시</span><div>';
            var columns = $grid[type]('getColumnFields');
            for (var i = 0; i < columns.length; i++) {
                var f = columns[i];
                var colOpt = $grid[type]('getColumnOption', f);
                if (!colOpt) continue;
                var isHidden = colOpt.hidden === true;
                var check = isHidden ? '&nbsp;&nbsp;&nbsp;&nbsp;' : '&#10003; ';
                h += '<div id="' + menuId + '-col-' + f + '">' + check + (colOpt.title || f) + '</div>';
            }
            h += '</div></div>';
            h += '<div class="menu-sep"></div>';
        }

        // 자동크기
        if (opts.autoFit) {
            h += '<div id="' + menuId + '-fit-columns">전체 컬럼 자동크기</div>';
        }

        // 행번호
        if (false && opts.rownumbers) {
            h += '<div id="' + menuId + '-toggle-rownumbers">' + (_rownumbersHidden ? '행번호 표시' : '행번호 숨기기') + '</div>';
        }

        if (opts.autoFit || opts.rownumbers) {
            h += '<div class="menu-sep"></div>';
        }

        // 엑셀
        if (opts.excel) {
            h += '<div id="' + menuId + '-excel">엑셀로 저장</div>';
            h += '<div class="menu-sep"></div>';
        }

        // 초기화
        if (opts.reset) {
            h += '<div id="' + menuId + '-reset">초기화</div>';
        }

        h += '</div>';
        $('body').append(h);

        var colPrefix = menuId + '-col-';

        $('#' + menuId).menu({
            onClick: function(item) {
                var id = item.target.id || '';
                if      (id === menuId + '-sort-asc')            sortColumn('asc');
                else if (id === menuId + '-sort-desc')           sortColumn('desc');
                else if (id === menuId + '-sort-reset')          sortReset();
                else if (id === menuId + '-hide-col')            hideColumn();
                else if (id === menuId + '-fit-columns')         autoFitColumns();
                else if (id === menuId + '-toggle-rownumbers')   toggleRownumbers();
                else if (id === menuId + '-excel')               exportExcel();
                else if (id === menuId + '-reset')               resetGrid();
                else if (id.indexOf(colPrefix) === 0)            toggleColumn(id.substring(colPrefix.length));
            }
        });

        $('#' + menuId).menu('show', { left: x, top: y });
    }

    // --------------------------------------------------
    // 클라이언트 정렬
    // --------------------------------------------------
    function sortColumn(order) {
        if (!currentField) return;
        var field = currentField;

        if (type === 'treegrid') {
            var data = $grid[type]('getData');
            // 원본 보존 (최초 1회, 깊은 복사)
            if (!_originalData) _originalData = deepCloneTree(data);
            sortTreeRecursive(data, field, order);
            _internalLoad = true;
            $grid[type]('loadData', data);
        } else {
            var data = $grid[type]('getData');
            // clientPagerFilter 사용 시 originalRows에 전체 데이터 보관됨
            var allRows = data.originalRows || data.rows;
            if (!_originalData) {
                _originalData = [];
                for (var k = 0; k < allRows.length; k++) _originalData.push(allRows[k]);
            }
            allRows.sort(function(a, b) { return compareValues(a, b, field, order); });
            _sortDataRef = data;
            _internalLoad = true;
            $grid[type]('loadData', data);
        }
    }

    // --------------------------------------------------
    // 정렬 초기화
    // --------------------------------------------------
    function sortReset() {
        if (!_originalData) return;
        _internalLoad = true;
        if (type === 'treegrid') {
            $grid[type]('loadData', _originalData);
        } else {
            var data = $grid[type]('getData');
            if (data.originalRows) {
                // clientPagerFilter 사용 시: originalRows를 정렬 전 상태로 복원
                data.originalRows = _originalData;
                $grid[type]('loadData', data);
            } else {
                $grid[type]('loadData', { total: _originalData.length, rows: _originalData });
            }
        }
        _sortDataRef = null;
        _originalData = null;
    }

    // --------------------------------------------------
    // 컬럼 숨기기/표시
    // --------------------------------------------------
    function hideColumn() {
        if (!currentField) return;
        $grid[type]('hideColumn', currentField);
        hiddenColumns[currentField] = true;
    }

    function toggleColumn(field) {
        var colOpt = $grid[type]('getColumnOption', field);
        if (colOpt && colOpt.hidden) {
            $grid[type]('showColumn', field);
            delete hiddenColumns[field];
        } else {
            $grid[type]('hideColumn', field);
            hiddenColumns[field] = true;
        }
    }

    // --------------------------------------------------
    // 전체 컬럼 자동크기 (로우 데이터 기준)
    // --------------------------------------------------
    function autoFitColumns() {
        var panel = $grid[type]('getPanel');
        var rows = getAllRows();
        var columns = $grid[type]('getColumnFields');
        var _dgOpts = $grid[type]('options');

        // EasyUI 내부 스타일시트 접근 (datagrid 기준 — treegrid도 datagrid 상속)
        var dgData = $.data($grid[0], 'datagrid');
        var ss = dgData.ss;

        // 원본 폭 + fitColumns 설정 저장 (최초 1회)
        if (!originalWidths) {
            originalWidths = {};
            for (var k = 0; k < columns.length; k++) {
                var o = $grid[type]('getColumnOption', columns[k]);
                if (o) originalWidths[columns[k]] = { width: o.width, boxWidth: o.boxWidth, deltaWidth: o.deltaWidth };
            }
            _originalFitColumns = _dgOpts.fitColumns;
        }

        // Phase 1: 너비 계산 (측정용 span — ord14a calcColumnWidths 패턴)
        var $m = $('<span>').css({
            visibility: 'hidden', position: 'absolute',
            whiteSpace: 'nowrap', fontSize: '14px'
        }).appendTo('body');

        for (var i = 0; i < columns.length; i++) {
            var field = columns[i];
            var opt = $grid[type]('getColumnOption', field);
            if (!opt || opt.hidden) continue;

            // 헤더 너비 (bold, +24px 여유)
            $m.css('fontWeight', '700').text(opt.title || field);
            var maxW = $m.outerWidth() + 24;

            // 데이터 너비 (normal, +16px 여유) — 포맷터 적용
            $m.css('fontWeight', 'normal');
            for (var j = 0; j < rows.length; j++) {
                var val = rows[j][field];
                if (val == null) continue;
                var display = opt.formatter ? opt.formatter(val, rows[j], j) : String(val);
                // HTML 포맷터 (체크박스 등): 렌더링 후 측정 / 일반 텍스트: 텍스트로 측정
                if (display.indexOf('<') >= 0) {
                    $m.html(display);
                } else {
                    $m.text(display);
                }
                var w = $m.outerWidth() + 16;
                if (w > maxW) maxW = w;
            }

            // 컬럼 옵션 업데이트
            var newW = Math.max(maxW, 50);
            var delta = opt.deltaWidth || ((opt.boxWidth != null) ? (opt.width - opt.boxWidth) : 0);
            opt.width = newW;
            opt.boxWidth = newW - delta;
            opt.deltaWidth = delta;
        }

        $m.remove();

        // Phase 2: 너비 적용 (EasyUI _5f5 내부 패턴)
        // fitColumns 비활성화 (비례 재분배 방지)
        _dgOpts.fitColumns = false;

        // ★ table-layout: fixed → ss.set() → table-layout: auto 토글
        // body/footer 테이블에 이 토글이 있어야 stylesheet 변경이 즉시 반영됨
        var btables = dgData.dc.view.find('table.datagrid-btable, table.datagrid-ftable');
        btables.css('table-layout', 'fixed');
        for (var i = 0; i < columns.length; i++) {
            var opt = $grid[type]('getColumnOption', columns[i]);
            if (opt && !opt.hidden && opt.cellClass) {
                ss.set('.' + opt.cellClass, opt.boxWidth ? opt.boxWidth + 'px' : 'auto');
            }
        }
        btables.css('table-layout', 'auto');

        // table width auto (ord14a 패턴 — EasyUI 100% 스트레칭 방지)
        panel.find('.datagrid-header table, .datagrid-body table').css('width', 'auto');
        // 가로 스크롤 활성화 (fitColumns 그리드에서 overflow-x:hidden 해제)
        if (dgData.dc && dgData.dc.body2) {
            dgData.dc.body2.css('overflow-x', '');
        }
        _autoFitActive = true;
    }

    // --------------------------------------------------
    // 행번호 표시/숨김
    // --------------------------------------------------
    function toggleRownumbers() {
        var panel = $grid[type]('getPanel');
        if (_rownumbersHidden) {
            panel.find('.datagrid-td-rownumber').show();
            _rownumbersHidden = false;
        } else {
            panel.find('.datagrid-td-rownumber').hide();
            _rownumbersHidden = true;
        }
    }

    // --------------------------------------------------
    // 엑셀(CSV)로 저장
    // --------------------------------------------------
    function exportExcel() {
        if (typeof XLSX === 'undefined') {
            alert('엑셀 라이브러리가 로드되지 않았습니다.');
            return;
        }

        var rows = getAllRows();

        // frozen 컬럼 + non-frozen 컬럼 모두 수집
        var frozenCols = $grid[type]('getColumnFields', true) || [];
        var normalCols = $grid[type]('getColumnFields', false) || [];
        var columns = frozenCols.concat(normalCols);

        // 표시 중인 컬럼만 수집
        var visibleCols = [];
        for (var i = 0; i < columns.length; i++) {
            var colOpt = $grid[type]('getColumnOption', columns[i]);
            if (colOpt && !colOpt.hidden) {
                visibleCols.push({ field: columns[i], title: colOpt.title || columns[i], formatter: colOpt.formatter });
            }
        }
        if (visibleCols.length === 0) return;

        // 표시 너비 계산 (한글 2배)
        function getDisplayWidth(str) {
            var w = 0;
            str = String(str);
            for (var i = 0; i < str.length; i++) {
                w += str.charCodeAt(i) > 127 ? 2 : 1;
            }
            return w;
        }

        // 워크시트 생성
        var ws = {};
        var colWidths = [];

        // 헤더 (s:1 = 볼드 흰색 글자 + 파란 배경 + 테두리)
        for (var c = 0; c < visibleCols.length; c++) {
            var cellRef = XLSX.utils.encode_cell({ r: 0, c: c });
            // <br>, <br/>, <br /> 태그를 줄바꿈으로 변환
            var headerTitle = visibleCols[c].title.replace(/<br\s*\/?>/gi, '\n');
            ws[cellRef] = { v: headerTitle, t: 's', s: 1 };
            // 너비 계산은 가장 긴 줄 기준
            var lines = headerTitle.split('\n');
            var maxLineWidth = 0;
            for (var li = 0; li < lines.length; li++) {
                var lw = getDisplayWidth(lines[li]);
                if (lw > maxLineWidth) maxLineWidth = lw;
            }
            colWidths[c] = maxLineWidth;
        }

        // 데이터
        for (var r = 0; r < rows.length; r++) {
            for (var c = 0; c < visibleCols.length; c++) {
                var raw = rows[r][visibleCols[c].field];
                var val = raw;
                // formatter 적용 후 HTML이면 원본값, 텍스트면 변환값
                if (visibleCols[c].formatter && raw != null) {
                    var formatted = String(visibleCols[c].formatter(raw, rows[r], r));
                    val = (formatted.indexOf('<') !== -1) ? raw : formatted;
                }
                if (val == null) val = '';

                var cellRef = XLSX.utils.encode_cell({ r: r + 1, c: c });
                if (typeof val === 'number') {
                    ws[cellRef] = { v: val, t: 'n' };
                } else {
                    ws[cellRef] = { v: String(val), t: 's' };
                }

                // 너비 계산 (성능: 최대 100행 샘플링)
                if (r < 100) {
                    var dw = getDisplayWidth(val);
                    if (dw > colWidths[c]) colWidths[c] = dw;
                }
            }
        }

        // 범위 설정
        ws['!ref'] = XLSX.utils.encode_range({
            s: { r: 0, c: 0 },
            e: { r: rows.length, c: visibleCols.length - 1 }
        });

        // 컬럼 너비 설정 (최소 8, 최대 50)
        ws['!cols'] = [];
        for (var c = 0; c < colWidths.length; c++) {
            ws['!cols'].push({ wch: Math.max(8, Math.min(50, colWidths[c] + 2)) });
        }

        // 워크북 생성 및 다운로드
        var wb = { SheetNames: ['Sheet1'], Sheets: { 'Sheet1': ws } };
        var fileName = opts.exportFileName + '_' + new Date().toISOString().slice(0, 10).replace(/-/g, '') + '.xlsx';
        var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });

        function s2ab(s) {
            var buf = new ArrayBuffer(s.length);
            var view = new Uint8Array(buf);
            for (var i = 0; i < s.length; i++) view[i] = s.charCodeAt(i) & 0xFF;
            return buf;
        }

        saveAs(new Blob([s2ab(wbout)], { type: 'application/octet-stream' }), fileName);
    }

    // --------------------------------------------------
    // 초기화
    // --------------------------------------------------
    function resetGrid() {
        var panel = $grid[type]('getPanel');

        // 숨긴 컬럼 복원
        for (var field in hiddenColumns) {
            if (hiddenColumns.hasOwnProperty(field)) {
                $grid[type]('showColumn', field);
            }
        }
        hiddenColumns = {};

        // 원본 컬럼 폭 + fitColumns 설정 복원
        if (originalWidths) {
            var dgData = $.data($grid[0], 'datagrid');
            var ss = dgData.ss;
            var columns = $grid[type]('getColumnFields');
            // 컬럼 옵션 복원
            for (var i = 0; i < columns.length; i++) {
                var opt = $grid[type]('getColumnOption', columns[i]);
                var orig = originalWidths[columns[i]];
                if (opt && orig) {
                    opt.width = orig.width;
                    opt.boxWidth = orig.boxWidth;
                    opt.deltaWidth = orig.deltaWidth;
                }
            }
            // ★ table-layout 토글로 stylesheet 즉시 반영 (EasyUI _5f5 패턴)
            var btables = dgData.dc.view.find('table.datagrid-btable, table.datagrid-ftable');
            btables.css('table-layout', 'fixed');
            for (var i = 0; i < columns.length; i++) {
                var opt = $grid[type]('getColumnOption', columns[i]);
                if (opt && opt.cellClass) {
                    ss.set('.' + opt.cellClass, opt.boxWidth ? opt.boxWidth + 'px' : 'auto');
                }
            }
            btables.css('table-layout', 'auto');
            originalWidths = null;
            // fitColumns 원본 설정 복원
            var _dgOpts = $grid[type]('options');
            if (_originalFitColumns !== null) {
                _dgOpts.fitColumns = _originalFitColumns;
                _originalFitColumns = null;
            }
            // table width 원복 + fitColumns 재적용
            panel.find('.datagrid-header table, .datagrid-body table').css('width', '');
            if (_dgOpts.fitColumns) {
                $grid[type]('fixColumnSize');
            }
            _autoFitActive = false;
        }

        // 정렬 원본 복원
        if (_originalData) {
            if (type === 'treegrid') {
                $grid[type]('loadData', _originalData);
            } else {
                $grid[type]('loadData', { total: _originalData.length, rows: _originalData });
            }
            _originalData = null;
        }

        // 행번호 표시
        panel.find('.datagrid-td-rownumber').show();
        _rownumbersHidden = false;
    }
}