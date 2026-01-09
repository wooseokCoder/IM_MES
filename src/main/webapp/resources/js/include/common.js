/*
 * @(#)common.js 1.0 2014/08/01
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */

/**
 * 공통 기능을 지원하는 스크립트이다.
 *
 * @author C-NODE
 * @version 1.0 2014/08/01
 */
var jcommon = {};
var jcombo  = {};
var jutils  = {};
var ehelp = {}; //ehelp 화면을 위한 값 20161026 김원국

//모든 화면에서 초기에 호출시 사용되는 함수
jcommon.init = function() {

	$("#home-button").bind("click", function(e) {
		top.location = context + "/index.do";
	});
	$("#help-button").bind("click", function(e) {
		var emenukey = "00001";
		$('.panel.wui-tab').each(function(index){
			if($(this).css('display') == 'block'){
				emenukey = $(this).children('div').prop('id');
			}
		});
		$("#eHelpMenuKey").val(emenukey);
		$("#ehelp").dialog('open');
		$('input:radio[name=chkinfoView]:input[value=manu]').prop("checked", true);
		doEHelpMove();
		doLangSettingPopEHelpPage();
	});
	$("#stmap-button").bind("click", function(e) {
		top.location = context + "/sitemap.do";
	});
	$("#mypage-button").bind("click", function(e) {
		alert('준비중입니다.');
		//window.location = context + "/mypage.do";
	});
	$("#logout-button").bind("click", function(e) {
		window.location = context + "/logout.do";
	});

	$('#ehelp').dialog({
	    title: tit.TITLE0031,
	    iconCls: 'icon-search',
	    width: 800,
	    height: 768,
	    closed: true,
	    modal: true,
	    resizable: true
	});

	$('#ehelpUpdate').dialog({
	    title: tit.TITLE0031,
	    iconCls: 'icon-search',
	    width: 800,
	    height: 768,
	    closed: true,
	    modal: true,
	    resizable: true
	});
	/*
    var options = $.datepicker.regional["ko"];
    options.showOn          = "button";
    options.buttonText      = "달력";
    options.buttonImage     = "";
    options.buttonImageOnly = true;
    options.changeYear      = true;
    options.changeMonth     = true;
    options.showButtonPanel = true;

    $.datepicker.setDefaults(options);
    */
};
$.extend($.fn.validatebox.defaults.rules, {
    fixLength: {
        validator: function(value, param){
            return value.length == param[0];
        },
        message: 'Please enter a {0} characters.'
    }
});

//for debugging
jcommon.printobject = function(obj) {
	alert ( jcommon.toString(obj) );
};

jcommon.toString = function(obj) {
    var arr = [];
    if ($.isArray(obj)) {
        $.each(obj, function(key, val) {
            arr.push( $.isPlainObject(val) ? jcommon.toString(val) : val );
        });
        return "[" + arr.join(",")+"]";
    } else {
        $.each(obj, function(key, val) {
            var next = key + ": ";
            next += $.isPlainObject(val) ? jcommon.toString(val) : val;
            arr.push( next );
        });
        return "{" +  arr.join(",") + "}";
    }
};

//단계콤보의 상위단계 선택시 처리
jcombo.select = function(rec) {
	var options = $(this).combobox('options');
	var child   = options.child;  //단계콤보인 경우
	if (child) {
		child = eval(child);
		$('#'+child.id).combobox('clear');
		$('#'+child.id).combobox('reload');
	}
};

jcombo.loader = function(param, success, error) {

	var group   = $(this).attr("codeGrup");
	var options = $(this).combobox('options');
	var params  = options.params;
	var parent  = options.parent; //단계콤보인 경우

	//[WSC2.0] [2015.04.14 LSH] 첫번째항목 설정기능 추가
	var first   = options.first;  //첫번째에 위치할 항목 (value,text)

	//[WSC2.0] [2015.05.20 LSH] 옵션표시 객체함수 설정
	var fnObject = function(item) {
		return {
            value: item.codeCd,
            text:  item.codeName
        };
	};
	if (options.fn)
		fnObject = options.fn;

	if (params)
	    params = eval(params);
	else
		params = {};

	if (group)
		params['codeGrup'] = group;

	if (parent) {
		parent = eval(parent);

		var value = $('#'+parent.id).combobox('getValue');
		params[parent.name] = value;
	}
    $.ajax({
        url: getUrl('/common/code/code.json'),
        dataType: 'json',
        type: 'post',
        data: params,
        success: function(data){

        	if (!data)
        		return;
        	if (!data.rows)
        		return;

            var items = $.map(data.rows, fnObject);

        	//[WSC2.0] [2015.04.14 LSH] 첫번째항목 설정기능 추가
            if (first) {
            	items.unshift(first);
            }
            success(items);
        },
        error: function(){
            error.apply(this, {});
        }
    });
};

jcombo.gloader = function(param, success, error) {

	var url   = $(this).combobox('options').codeUrl;
	var group = $(this).combobox('options').codeGrup;

	if (!url)
		url = "/common/code/code.json";


    $.ajax({
        url: getUrl(url),
        dataType: 'json',
        type: 'post',
        data: {
        	codeGrup: group
        },
        success: function(data){

        	if (!data)
        		return;
        	if (!data.rows)
        		return;

            var items = $.map(data.rows, function(item){
                return {
                    value: item.codeCd,
                    text: item.codeName
                };
            });

            success(items);
        },
        error: function(){
            error.apply(this, {});
        }
    });
};

jcombo.load = function(args, flg) {

	var flag   = (flg ? flg : 1);
	var items  = [];
	var params = {};

	if (typeof args == 'string') {
		params.codeGrup = args;
	}
	else {
		params = args;
	}

    $.ajax({
        url: getUrl('/common/code/code.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: params,
        success: function(data){
        	if (!data)
        		return;
        	if (!data.rows)
        		return;

            items = $.map(data.rows, function(item) {

            	if (flag == 9)
            		return item;

            	var obj = {value:'', text:''};

            	switch(flag) {
            		case 1: obj = {value: item.codeCd,   text: item.codeName}; break;
            		case 2: obj = {value: item.codeCd,   text: item.codeName+ '['+item.codeCd+']'};   break;
            		case 3: obj = {value: item.codeCd,   text: item.codeCd};   break;
            		case 4: obj = {value: item.codeName, text: item.codeName}; break;
            	}
            	return obj;
            });
        },
        error: function(){
        }
    });
    return items;
};

jcommon.toHtml = function(data, idPrefix) {

	idPrefix = idPrefix || '';

	for(var p in data) {
		var obj = $('#'+idPrefix+p);

		if (!obj)
			continue;

	    obj.html(data[p]);
	}
};

jcommon.clear = function(idPrefix) {

	if (jutils.empty(idPrefix))
		return;

	$('span[id^='+idPrefix+']').each(function() {
		$(this).html("");
	});
};

jcommon.setText = function(arr, data) {

	$.each(arr, function(i,a) {
		var obj = $('#'+a);

		if (!obj ||
			obj.length == 0)
			return;

		if (data) {
			if (data[a] && data[a].length > 0)
				obj.html(data[a]);
		}
		else {
			obj.html("");
		}
	});
};

//빈값체크
jutils.empty = function(val) {
	if (typeof val == "array") {
		if (val.length>0)
			return false;
		return true;
	}
	if (!val)
		return true;
	if (val == null)
		return true;
	if (val == 'undefined')
		return true;
	if (val == '')
		return true;

	return false;
};


jutils.escapeJson  = function(val) {
	val = JSON.stringify(val);
	val = val.replace(/\\r\\n/g , "");
	val = val.replace(/\\n/g    , "");
	val = val.replace(/"{/      , "{");
	val = val.replace(/}"/      , "}");
	val = val.replace(/\\"/g    , "\"");

	var obj = $.parseJSON(val);

	//jcommon.printobject(obj);

	return obj;
};


jutils.formatFileSize = function (bytes) {
    if (typeof bytes !== 'number') {
        return '';
    }
    if (bytes >= 1000000000) {
        return (bytes / 1000000000).toFixed(2) + ' GB';
    }
    if (bytes >= 1000000) {
        return (bytes / 1000000).toFixed(2) + ' MB';
    }
    return (bytes / 1000).toFixed(2) + ' KB';
};

jutils.byteString = function(str) {
	var len = 0;
	if (!str || !str.length)
		return 0;

	for (var i=0; i<str.length; i++) {
		var c = escape(str.charAt(i));
		if      (c.length == 1)         len++;
		else if (c.indexOf("%u") != -1) len += 2;
		else if (c.indexOf("%")  != -1) len += c.length / 3;
	}
	return len;
};

//객체를 값이 있는 항목의 querystring 문자열로 변환한다.
jutils.toQueryString = function(obj) {

	//escape(encodeURIComponent(s))

	if (!obj ||
	    typeof obj != "object")
	    return "";

    var s = "";
    for (var p in obj) {
        if (!isEmpty( obj[p] )) {
        	s += (s.length==0 ? "?" : "&");
            s += p + "=" + obj[p];
        }
    }
    return s;
};

//내용의 바이트 체크
jutils.checkMaxBytes = function(s, maxkb) {
	var l = s.bytes();
	var m = maxkb * 1024;

	if (l > m) {
		// show error message
		$.messager.show({
			title: 'Error',
			msg: "내용크기("+l+" BYTE)가 최대크기("+m+" BYTE)를 초과합니다."
		});
		return false;
	}
	return true;
};
//숫자 3자리수마다 , 를 입력한다.
jutils.formatMoney = function(val) {
	var minus = false;

	if(typeof val == 'number')
		val = val+"";

    if(val.indexOf("-") != -1)
        minus = true;

    var sMoney = val.replace(/(,|-)/g,"");
    var tMoney = "";

	if (isNaN(sMoney)){
		return "0";
	}

    var rMoney = "";
    var rCheck = false;
    if(sMoney.indexOf(".") != -1){
        rMoney = sMoney.substring(sMoney.indexOf("."));
  		sMoney = sMoney.substring(0, sMoney.indexOf("."));
  		rCheck = true;
    }

    var len = sMoney.length;

    if ( sMoney.length <= 3 ) return sMoney;

    for(var i = 0; i < len; i++){
        if(i != 0 && ( i % 3 == len % 3) ) tMoney += ",";
        if(i < len ) tMoney += sMoney.charAt(i);
    }
    if(minus) tMoney = "-" + tMoney;
    if(rCheck) tMoney = tMoney + rMoney;

    return tMoney;
};

//객체 배열의 중복여부를 체크한다.
jutils.duplicateObject = function(rows, field) {

	var arr = $.extend(true, [], rows);
	arr.sort(function(a,b) {
		var v1 = a[field];
		var v2 = b[field];
		return v1 > v2 ? 1 : v1 < v2 ? -1 : 0;
	});

	var dup = [];

	$.each(arr, function(i,r) {
		if (i == (arr.length-1))
			return;
		if (r[field]=="")
			return;
		if (arr[i+1][field] == r[field])
			dup.push(r[field]);
	});
	return (dup.length == 0 ? false : dup);
};

$.fn.serializeObject = function() {
    var o = {};
    var a = this.serializeArray();

    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

$.fn.toForm = function(data) {
    var f = $(this);

	for(var p in data) {
		var obj = f.find('[name="'+p+'"]');

		if (!obj)
			continue;

	    obj.each(function(i) {
			if (this.type == 'checkbox' ||
				this.type == 'radio') {
		    	if (this.value == data[p])
		    		this.checked = true;
			}
			else {
				$(this).val(data[p]);
			}
	    });
	}
};

$.fn.getFormValue = function(name) {
    var f = $(this);
    var o = f.find('[name="'+name+'"]');
    if (o)
    	return o.val();
    return null;
};

//그리드 에디터에 콤보그리드 사용설정
$.extend($.fn.datagrid.defaults.editors, {
	combogrid: {
		init: function(container, options){
			var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container);
			input.combogrid(options);
			return input;
		},
		destroy: function(target){
			$(target).combogrid('destroy');
		},
		getValue: function(target){
			return $(target).combogrid('getValue');
		},
		setValue: function(target, value){
			$(target).combogrid('setValue', value);
		},
		resize: function(target, width){
			$(target).combogrid('resize',width);
		}
	}
});

function doEHelpMove(){
	if($('input:radio[name=chkinfoView]:checked').val() == 'memo'){
		$("#ehelpmanu").hide();
		$("#ehelpmemo").show();
		document.eHelpSend.action=getUrl("/ehelpmemo.do");
		document.eHelpSend.target="ehelp-meno-frame";
		document.eHelpSend.submit();
	}else{
		$("#ehelpmanu").show();
		$("#ehelpmemo").hide();
		document.eHelpSend.action=getUrl("/ehelpmanu.do");
		document.eHelpSend.target="ehelp-manu-frame";
		document.eHelpSend.submit();
	}
}

/**
 * 화면 언어 추출 후 DB에 언어 셋팅
 * 1)각 화면 객체에서 data-item 이라는 Custom dataset을 설정을 해놓은다.
 * 2)SYSTEM 그룹에 속해있을경우 네비게이션 바를 선택하여서 저장을 한다.
 * 3)화면/용어관리에 들어가서 각 랭기지에 맞게 셋팅후 언어를 바꾸어 주면 된다.
 * ※ 예제 화면은 알림방에 만들어 놓았다.
 */
function langTextSave(){
	var items = document.querySelectorAll('[data-item]');
	var terninfo = new Object();
	var ternarray = new Array();
	var menuKeyVal = $("#text_menuKey").val();
	if(!menuKeyVal || menuKeyVal.trim() === ''){
		$.messager.alert("Error", "메뉴 키가 설정되지 않았습니다.", 'error');
		return false;
	}
	$(items).each(function( index ) {
		var items = $(this).data("item");//해당 item 코드
		terninfo = {itemGrp:menuKeyVal
				   ,itemId:items
				   ,itemNm:$(this).text().trim()};
		ternarray.push(terninfo);
		  /* 변경하는 부분 */
		  /*$(this).contents().filter(function(){

			  this.innerHTML = $(this).html().replace($(this).text().trim(),"조회");
		  });*/
	});
	var JSonStr = JSON.stringify(ternarray);
	var chkternarray = ternarray;

	/* 코드 중복 체크 로직 */
	for(var i = 0; i < ternarray.length; i++){
		for(var j = 0; j < chkternarray.length; j++){
			if(i != j){
				if(ternarray[i].itemId == chkternarray[j].itemId){
					$.messager.alert("Error", ternarray[j].itemId+"코드가 중복됩니다.", 'error');
					return false;
				}
			}
		}
	}

    $.ajax({
        url: getUrl('/common/code/screenterm/screenInsert.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {data:JSonStr},
        success: function(data){
        	//
        	if(data.rows == 'ZERO'){
        		$.messager.alert("Info","저장 항목이 없습니다.");
        	}else if(data.rows == 'OK'){
        		$.messager.alert("Info","저장 완료 하였습니다.");
        	}else if(data.rows == 'ERR'){
        		$.messager.alert('error',"에러 입니다.");
        	}else{
        		$.messager.alert('error',"에러 입니다.");
        	}

        },
        error: function(){
        	$.messager.alert('error',"에러 입니다.");
        }
    });
}

//TODO 수정중
function langTextPopSave(){
	var items = document.querySelectorAll('[data-popup]');
	var terninfo = new Object();
	var ternarray = new Array();
	console.log("menukey : " + $("#text_menuKey").val());
	$(items).each(function( index ) {
		var items = $(this).data("popup");//해당 item 코드
		terninfo = {itemGrp:$("#text_menuKey").val()
				   ,itemId:items
				   ,itemNm:$(this).text().trim()};
		//console.log(terninfo);
		ternarray.push(terninfo);
		  /* 변경하는 부분 */
		  /*$(this).contents().filter(function(){

			  this.innerHTML = $(this).html().replace($(this).text().trim(),"조회");
		  });*/
	});
	var JSonStr = JSON.stringify(ternarray);
	var chkternarray = ternarray;

	/* 코드 중복 체크 로직 */
	for(var i = 0; i < ternarray.length; i++){
		for(var j = 0; j < chkternarray.length; j++){
			if(i != j){
				if(ternarray[i].itemId == chkternarray[j].itemId){
					$.messager.alert("Error", ternarray[j].itemId+"코드가 중복됩니다.", 'error');
				}
			}
		}
	}

   $.ajax({
        url: getUrl('/common/code/screenterm/screenInsert.json'),
        dataType: 'json',
        async: false,
        type: 'post',
        data: {data:JSonStr},
        success: function(data){
        	//
        	if(data.rows == 'ZERO'){
        		$.messager.alert("Info","저장 항목이 없습니다.");
        	}else if(data.rows == 'OK'){
        		$.messager.alert("Info","저장 완료 하였습니다.");
        	}else if(data.rows == 'ERR'){
        		$.messager.alert('error',"에러 입니다.");
        	}else{
        		$.messager.alert('error',"에러 입니다.");
        	}

        },
        error: function(){
        	$.messager.alert('error',"에러 입니다.");
        }
    });
}

/* 화면 시작 하자 마자 불러온다 */
function doLangSettingPage(){
		var items = document.querySelectorAll('[data-item]');
		$.ajax({
			url: getUrl('/common/code/screenterm/selectLangNm.json'),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {itemKey:$("#text_menuKey").val()},
			success: function(data){
				for(var i = 0; i < data.rows.length; i++){

					$(items).each(function( index ) {
						var items = $(this).data("item");//해당 item 코드
						if(items == data.rows[i].itemId){
							this.innerHTML = data.rows[i].itemNm.replace("<br>", "\n").replace("<br>", "\n").replace("<br>", "\n");;
						}
					});
				}
			},
			error: function(){
			}
		});
}

/* 테이블 로딩후 불러온다.*/
function doLangSettingTable(){
	if(locale != 'en') {
		var items = document.querySelectorAll('[data-item]');
		$.ajax({
	        url: getUrl('/common/code/screenterm/selectLangNm.json'),
	        dataType: 'json',
	        async: false,
	        type: 'post',
	        data: {itemKey:$("#text_menuKey").val()},
	        success: function(data){
	        	for(var i = 0; i < data.rows.length; i++){
	            	$(items).each(function( index ) {
	    	      		var items = $(this).data("item");//해당 item 코드
	    	      		if(items == data.rows[i].itemId){
	    	      			if(data.rows[i].ITEM_NM.indexOf("<br>") > -1) {
	    	      				var _item = $(this).html();
	    	      				var _idxItem = data.rows[i].ITEM_NM.substr(0, data.rows[i].ITEM_NM.indexOf("<br>"));
	    	      				_idxItem = ">" + _idxItem;
	    	      				var _left = _item.substr(0, _item.indexOf(_idxItem));
	    	      				_left = _left + ">";
	    	      				var _idxItem2 = data.rows[i].ITEM_NM.substr(data.rows[i].ITEM_NM.indexOf("<br>")+4);
	    	      				_idxItem2 = _idxItem2 + "<";
	    	      				var _right = _item.substr(_item.indexOf(data.rows[i].ITEM_NM.substr(data.rows[i].ITEM_NM.indexOf("<br>")+4) + "<")+_idxItem2.length);
	    	      				_right = "<" + _right;
	    	      				var _center = data.rows[i].itemNm.replace("<br>", "\n").replace("<br>", "\n").replace("<br>", "\n");
	    	      				this.innerHTML = _left + _center + _right;
	    	      			} else {
	    	      				this.innerHTML = $(this).html().replace($(this).text().trim(),data.rows[i].itemNm);
	    	      			}
	    	      		}
	            	});
	        	}
	        },
	        error: function(){
	        }
	    });
	}
}

/* 화면 시작 하자 마자 불러온다 - 팝업 */
function doLangSettingPopPage(){
	if(locale != 'en') {
		var items = document.querySelectorAll('[data-popup]');
		$.ajax({
			url: getUrl('/common/code/screenterm/selectLangNm.json'),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {itemKey:$("#text_menuKey").val()},
			success: function(data){
				//
				for(var i = 0; i < data.rows.length; i++){

					$(items).each(function( index ) {
						var items = $(this).data("popup");//해당 item 코드
						//
						if(items == data.rows[i].itemId){
							//console.log(data.rows[i].itemNm);
							this.innerHTML = data.rows[i].itemNm;
						}
					});
				}
			},
			error: function(){
			}
		});
	}
}

/* 테이블 로딩후 불러온다. - 팝업*/
function doLangSettingPopTable(){
	if(locale != 'en') {
		var items = document.querySelectorAll('[data-popup]');
		//
		$.ajax({
			url: getUrl('/common/code/screenterm/selectLangNm.json'),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {itemKey:$("#text_menuKey").val()},
			success: function(data){
				//
				for(var i = 0; i < data.rows.length; i++){

					$(items).each(function( index ) {

						var item = $(this).data("popup");//해당 item 코드
						//
						if(item == data.rows[i].itemId){
							this.innerHTML = $(this).html().replace($(this).text().trim(),data.rows[i].itemNm);
						}
					});
				}
			},
			error: function(){
			}
		});
	}
}


/* 화면 시작 하자 마자 불러온다 - 팝업 */
function doLangSettingPopEHelpPage(){
	if(locale != 'en') {
		var items = document.querySelectorAll('[data-popup]');
		$.ajax({
			url: getUrl('/common/code/screenterm/selectLangNm.json'),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {itemKey:$("#text_ehelp_menuKey").val(),
				itemGrp:$("#text_menuKey").val()},
				success: function(data){
					for(var i = 0; i < data.rows.length; i++){

						$(items).each(function( index ) {
							var items = $(this).data("popup");//해당 item 코드
							if(items == data.rows[i].itemId){
								this.innerHTML = data.rows[i].itemNm;
							}
						});
					}
				},
				error: function(){
				}
		});
	}
}

function doLangSettingPopEHelpTable(){
	if(locale != 'en') {
		var items = document.querySelectorAll('[data-popup]');
		//
		$.ajax({
			url: getUrl('/common/code/screenterm/selectLangNm.json'),
			dataType: 'json',
			async: false,
			type: 'post',
			data: {itemKey:$("#text_ehelp_menuKey").val()},
			success: function(data){
				for(var i = 0; i < data.rows.length; i++){

					$(items).each(function( index ) {

						var item = $(this).data("popup");//해당 item 코드
						if(item == data.rows[i].itemId){
							//console.log(data.rows[i].itemId);
							this.innerHTML = $(this).html().replace($(this).text().trim(),data.rows[i].itemNm);
						}
					});
				}
			},
			error: function(){
			}
		});
	}
}

function formatNumber(value,row,index){
	var d = $.number(value);
	return d;
}

function ThzhotspotPosition(evt, el, hotspotsize, percent) {
	  var left = el.offset().left;
	  var top = el.offset().top;
	  var hotspot = hotspotsize ? hotspotsize : 0;
	  if (percent) {
	    x = (evt.pageX - left - (hotspot / 2)) / el.outerWidth() * 100;
	    y = (evt.pageY - top - (hotspot / 2)) / el.outerHeight() * 100;
	  } else {
	    x = (evt.pageX - left - (hotspot / 2)) + 20 ;
	    y = (evt.pageY - top - (hotspot / 2)) + 20;
	  }

	  return {
	    x: x,
	    y: y
	  };
	}

function submenuOpen(key, id){
	var item = "."+key;
	var icon = "#"+id;
	$(item).toggle();
	$(icon+' .tree-submenu-icon-angle-right').toggleClass('fa-angle-right');
	$(icon+' .tree-submenu-icon-angle-right').toggleClass('fa-angle-left');
	$(".tree-level4").hide();
}

function submenuOpen2(key, id){
	var icon = "#"+id;
	$("."+key).toggle();
	$(icon+' .tree-submenu-icon-angle-right').toggleClass('fa-angle-right');
	$(icon+' .tree-submenu-icon-angle-right').toggleClass('fa-angle-left');
}

function chkAuthBtn(id) {
	//console.log("id : ", id);
	if($(id).hasClass('l-btn-disabled')){
		//$(id).hide();
		//console.log("false");
		return false;
	} else {
		//$(id).css('display','inline-block');
		//console.log("true");
		return true;
	}
}