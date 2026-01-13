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
				menuHtml: ''
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
						//console.log("Select");
						var tab12 = $(this).tabs('getSelected');
						var index12 = $(this).tabs('getTabIndex',tab12);
						//console.log(index12);
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
			
			this.tab.tabs('add', {
				id:       args.menuKey,
				title:    args.menuDesc,
				content:  content,
				cls:      'wui-tab',
				closable: true/*,
				tools:[{
					iconCls:'icon-mini-add',
					handler:function() {
				    	//Hot Menu 추가
				    	jwidget.hotmenu.add(args.menuKey);
					}
				}]*/
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
					console.log(node);
					
					//홈버튼을 누르면 index로 이동
					if(node.text == 'Home') {
						goHome();
						//document.location.href = context + "/";
						return;
					}
					
					//열려있는 것 닫기 - 본인 제외
					if($('#'+node.domId).find(".fa-angle-left").length > 0) {
						$(".fa-angle-left").each(function() { 
							let ele = $(this).parents(".tree-node");
							
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
					$(this).tree('select',node.target);
					mctx.menu('show',{left: e.pageX,top: e.pageY});
				},
				onLoadSuccess: function() {
					//메뉴 권한 없을 경우 설정
					$(".fa-angle-right").parent().removeClass("noAuth");
					$("#left-menu > li > div:not(.tree-level3, .tree-level4)").removeClass("noAuth").addClass("tree-level2");

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
		//선택된 메뉴노드의 ID 반환
		getSelectedId: function() {
			var node = this.getSelected();
			return node.id;
		}
	},
	//-----------------------------------------//
	//좌측 핫메뉴
	hotmenu: {
		consts: {
			TITLE: 'Hot Menu',
			//20160929 박소현
			//ICON:  'ui-icon ui-icon-star',
			ICON : 'ui-icon ui-icon-circle-triangle-e',
			PKEY:  "#left-hotmenu", //패널KEY
			TKEY:  "#hot-menu",     //트리KEY
			CKEY:  "#hot-context",  //컨텍스트메뉴KEY
			HEIGHT:300,
			WIDTH: 200,
			URL: {
				search: getUrl("/common/user/hotmenu/search.json"),
				select: getUrl("/common/user/hotmenu/select.json"),
				save:   getUrl("/common/user/hotmenu/save.json")
			}
		},
		//메뉴객체
		get: function() {
			return $(this.consts.TKEY);
		},
		_filterRows: function(rows) {
			if (rows.length == 0)
				return [];

			var arr = [];
			$.each(rows, function(i,c) {
				//2016/12/12 김영진 -- 핫메뉴 구분자시 표시안함
				if(c.sepaText != "-"){
					arr.push({menuKey: c.id,menuDesc: c.text});
				}
			});
			return arr;
		},
		//저장목록
		getSaveRows: function() {
			var rows = this.get().tree('getRoots');
			return this._filterRows(rows);
		},
		//선택목록
		getCheckRows: function() {
			var row = this.get().tree('getSelected');
			return this._filterRows([row]);
		},
		//핫메뉴 검색
		load: function() {
			var p   = this;
			var url = this.consts.URL;

			//패널생성
			$(this.consts.PKEY).panel({
				title:   this.consts.TITLE,
				iconCls: this.consts.ICON,
				//height:  this.consts.HEIGHT,
				//width:   this.consts.WIDTH,
				collapsible:true,
				fit:true
			});

			$.ajax({
				url: url.search,
		        dataType: 'json',
		        type: 'post',
				success: function(data) {
		        	if (data && data.rows) {
		        		//
		    			var arr = [];
		    			$.each(data.rows, function(i,c) {
		    				arr.push( p.filter(c) );
		    			});

		    			//트리생성
		    			p.create(arr);
		        	}
				}
			});
		},
		//메뉴트리 생성
		create: function(data) {
			//
			var jobj = this;
			var mctx = $(this.consts.CKEY);

			jobj.get().tree({
				fit: true,
				dnd: true,
				data: data,
				onSelect: function(node) {
					if(!node.children && node.enableYn == "Y" && node.progAuth == "1") {
						var a = node.attributes;
						jmenus.go(a.menuKey);
					}
				},
				onContextMenu: function(e,node) {
					e.preventDefault();
					$(this).tree('select',node.target);
					mctx.menu('show',{left: e.pageX,top: e.pageY});
				},
				onDrop:function(target,source,point){
					//순서를 저장한다.
					jobj.sort();
                },
                onBeforeDrop: function(target,source,point) {
                	if (point == 'append')
                		return false;
                	return true;
                }
			});
		},
		//트리형태 데이터 생성
		filter: function(menu) {
			var obj = {
				id  : menu.menuKey,
				text: menu.menuDesc,
				iconCls: menu.iconCls,
				enableYn: menu.enableYn,
				progAuth: menu.progAuth,
				attributes: {
					menuKey: menu.menuKey,
					menuUrl: menu.menuUrl,
					menuDesc: menu.menuDesc,
					parentDesc:menu.parentDesc
				}
			};
			return obj;
		},
		//핫메뉴 순서저장
		sort: function() {
			var p     = this;
			var url   = this.consts.URL;
			var rows  = this.getSaveRows();
			var data  = {};
			data['models'] = $.toJSON(rows);
			//수정상태
			jstatus.update(data);

			$.ajax({
				url: url.save,
		        dataType: 'json',
		        type: 'post',
		        data: data
			});
		},
		//핫메뉴 삭제
		remove: function() {
			var p     = this;
			var url   = this.consts.URL;
			var rows = this.getCheckRows();
			if (rows.length == 0) {
				$.messager.alert(msg.MSG0121,msg.MSG0139,msg.MSG0121);
				return;
			}

			var fn = function(r) {
				if (!r)
					return;

				var data  = {};
				data['models'] = $.toJSON(rows);
				//삭제상태
				jstatus.remove(data);

				$.ajax({
					url: url.save,
			        dataType: 'json',
			        type: 'post',
			        data: data,
			        success: function(data) {
						p.load();
					}
				});
			};
			$.messager.confirm(msg.MSG0123, msg.MSG0123, fn);
		},
		//핫메뉴 추가
		add: function(key) {

			var p     = this;
			var url   = this.consts.URL;
			var data  = {menuKey: key};
			var title = false;

			//이미 있는 메뉴인지 확인
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
				$.messager.alert(msg.MSG0121,'['+title+']은 이미 핫메뉴에 존재합니다.',msg.MSG0121);
				return;
			}
			//등록상태
			jstatus.insert(data);

			$.ajax({
				url: url.save,
		        dataType: 'json',
		        type: 'post',
		        data: data,
				success: function(data) {
					p.load();
				}
			});
		},
		//좌측메뉴의 컨텍스트에서 메뉴추가시 사용(submenu.jsp)
		addByMenu: function() {
			var id = jwidget.submenu.getSelectedId();
			this.add(id);
		},
		//핫메뉴의 컨텍스트에서 메뉴삭제시 사용(hotmenu.jsp)
		delByMenu: function() {
			this.remove();
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
			if(row.pointX == 0 && row.pointY == 0){
				$("#"+pre).dialog({
					closed:  false,
					cache:   false,
					modal:    true,
					width:   (row.width  ? row.width  : 100),
					height:  (row.height ? row.height : 100),
					title:    title,
					content:  content,
					onResize:function(){
						$(this).dialog("center");
					}
				});
			}else{
				$("#"+pre).dialog({
					closed:  false,
					cache:   false,
					modal:    true,
					width:   (row.width  ? row.width  : 100),
					height:  (row.height ? row.height : 100),
					left:    (row.pointX ? row.pointX : 100),
					top:     (row.pointY ? row.pointY : 100),
					title:    title,
					content:  content/*,
					buttons:  buttons*/
				});
			}
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