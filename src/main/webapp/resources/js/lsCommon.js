var Utils = {
		/**
		 * Utils 널 체크
		 * @author kwk
		 * @version 1.0 2018/09/14 
		 */
		isNull:function(obj){
	    	if (typeof obj === "undefined" || obj === "null" || obj === "" || (typeof obj === "string" && obj.trim() === "") || obj === null) {
	            return true;
	        } else {
	            return false;
	        }
		},
		isEmail:function(d){
			var re3 = /[@]/gi;
		    return re3.test(d);
		},
		isTelNo:function(d){
			var re = /^\d{3}-\d{3,4}-\d{4}$/;
		    return re.test(d);
		},
		isLeng30:function(d){
			var re = Utils.isNull(d) ? 31 : d.length;
			if(re <= 30){
				return true;	
			}else{
				return false;
			}
		},
		isStick:function(d){
			var re3 = /[-]/gi;
		    return re3.test(d);
		}
}


//multi search pop
var multiListPop = {
		targetBtn: null,
		popOpenChk: false,
		openMultiListPop: function(target) {
			multiListPop.targetBtn = target.currentTarget;
			let rect = target.currentTarget.getBoundingClientRect();
			let $div = $("#multi-serach-pop");
			
			let selData = $(multiListPop.targetBtn).parent().children("input[type=hidden]").val();
			if(selData != '') {
				selData = selData.replace(/,/g, '\n');
			}
			
			$("#s_multiNo").val(selData);
			$div.css("display","block");
			$div.css("top", rect.top + 26);
			$div.css("left", rect.left);
			
			multiListPop.popOpenChk = true;
			
			// 문서 전체 클릭 이벤트
			document.addEventListener('click', function (event) {
			    // popup 영역을 클릭했거나, popup 내부 요소를 클릭했다면 그대로 둠
				if(multiListPop.popOpenChk) {
				    if (document.getElementById("multi-serach-pop").contains(event.target) 
				    		|| multiListPop.targetBtn.contains(event.target)) {
				      return;
				    }
	
				    // popup 외부를 클릭한 경우 display none
				    multiListPop.closeMultiListPop();
				    multiListPop.popOpenChk = false;
				}
			});
		},
		saveListPop: function(target) {
			let eleId = $(multiListPop.targetBtn).parent().children("input[type=hidden]").attr("id");
			if(eleId == 'h_multiList') {
				multiListPop.saveMultiList(target);
			} else if(eleId == 'h_userIdList') {
				multiListPop.saveUserIdList(target);
			}
		},
		saveMultiList: function(target) {
			var multiText = $("#s_multiNo").val();
			var multiText1 = multiText.replace(/\s/gi, ",");     // 모든 공백을 쉼표로 변환
			var regExp = /[\{\}\[\]\/?.;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
			var multiText2 = multiText1.replace(regExp, "");
			var multiNo;
			var ngFlg = true;
			var multiList;
			if (multiText2.indexOf(",") != -1) {
				multiNo = multiText2.split(",");
			} else {
				multiNo = multiText2;
			}
			if(multiNo == "" || multiNo == undefined) ngFlg = false;
			else {
				if(Array.isArray(multiNo)) {
					multiNo = multiNo.filter(function(item) {
						return item !== null && item !== undefined && item !== '';
					});
					multiList = multiNo.join(',');
				} else {
					multiList = multiNo;
				}
				if(multiNo.length > 1000){
					if(typeof $.messager !== 'undefined' && typeof msg !== 'undefined') {
						$.messager.alert(msg.MSG0121,msg.MSG0087,msg.MSG0121);
					} else {
						alert('Too many items entered. Maximum 1000 items allowed.');
					}
					return;
				}
			}
			if(ngFlg == false || multiList === undefined){
				$(multiListPop.targetBtn).parent().children("input[type=hidden]").val('');
				// textbox도 초기화
				var $textbox = $(multiListPop.targetBtn).parent().children("input.easyui-textbox");
				if($textbox.length > 0 && $textbox.data('textbox')) {
					$textbox.textbox("setValue", "");
				} else if($textbox.length > 0) {
					$textbox.val("");
				}
				alert('The wrong number was entered!!');
				$("#multi-serach-pop").css("display","none");
				$(multiListPop.targetBtn).css('background-color', 'white');
				multiListPop.popOpenChk = false;
			}else{
				$(multiListPop.targetBtn).parent().children("input[type=hidden]").val(multiList);
				// textbox에도 값 설정
				var $textbox = $(multiListPop.targetBtn).parent().children("input.easyui-textbox");
				if($textbox.length > 0 && $textbox.data('textbox')) {
					$textbox.textbox("setValue", multiList);
				} else if($textbox.length > 0) {
					$textbox.val(multiList);
				}
				$(multiListPop.targetBtn).css('background-color', '#9e9c9c');
				$("#multi-serach-pop").css("display","none");
				multiListPop.popOpenChk = false;
			}
		},
		deleteMultiListPop: function(target) {
			$("#s_multiNo").val('');
			$(multiListPop.targetBtn).parent().children("input[type=hidden]").val('');
			// textbox도 초기화
			var $textbox = $(multiListPop.targetBtn).parent().children("input.easyui-textbox");
			if($textbox.length > 0 && $textbox.data('textbox')) {
				$textbox.textbox("setValue", "");
			} else if($textbox.length > 0) {
				$textbox.val("");
			}
			$(multiListPop.targetBtn).css('background-color', 'white');
			
			$("#multi-serach-pop").css("display","none");
			multiListPop.popOpenChk = false;
		},
		closeMultiListPop: function(target) {
			$("#multi-serach-pop").css("display","none");
			multiListPop.popOpenChk = false;
		},

		openPoListPop: function(target) {
			multiListPop.targetBtn = target.currentTarget;
			let rect = target.currentTarget.getBoundingClientRect();
			let $div = $("#multi-serach-pop");
			
			let selData = $(multiListPop.targetBtn).parent().children("input[type=hidden]").val();
			if(selData != '') {
				selData = selData.replace(/,/g, '\n');
			}
			
			$("#s_poNo").val(selData);
			$div.css("display","block");
			$div.css("top", rect.top + 26);
			$div.css("left", rect.left);
			
			multiListPop.popOpenChk = true;
			
			// 문서 전체 클릭 이벤트
			document.addEventListener('click', function (event) {
			    // popup 영역을 클릭했거나, popup 내부 요소를 클릭했다면 그대로 둠
				if(multiListPop.popOpenChk) {
				    if (document.getElementById("multi-serach-pop").contains(event.target) 
				    		|| multiListPop.targetBtn.contains(event.target)) {
				      return;
				    }
	
				    // popup 외부를 클릭한 경우 display none
				    multiListPop.closePoListPop();
				    multiListPop.popOpenChk = false;
				}
			});
		},
		deletePoListPop: function(target) {
			$("#s_poNo").val('');
			$(multiListPop.targetBtn).parent().children("input[type=hidden]").val('');
			$(multiListPop.targetBtn).css('background-color', 'white');
			$("#multi-serach-pop").css("display","none");
			multiListPop.popOpenChk = false;
		},
		closePoListPop: function(target) {
			$("#multi-serach-pop").css("display","none");
			multiListPop.popOpenChk = false;
		},
		saveUserIdList: function(target) {
			var poText = $("#s_poNo").val();
			var poText1 = poText.replace(/\s/gi, ",");     // 모든 공백을 쉼표로 치환
			// 쉼표를 제외한 특수문자는 허용 (dev.admin, hu@man 등)
			var poText2 = poText1;
			var pono;
			var ngFlg = true;
			var userIdList;
			if (poText2.indexOf(",") != -1) {
				pono = poText2.split(",");
			} else {
				pono = poText2;
			}
			if(pono == "" || pono == undefined) ngFlg = false;
			else {
				if(Array.isArray(pono)) {
					pono = pono.filter(function(item) {
						return item !== null && item !== undefined && item !== '';
					});
					userIdList = pono.join(',');
				} else {
					userIdList = pono;
				}
				if(pono.length > 1000){
					if(typeof $.messager !== 'undefined' && typeof msg !== 'undefined') {
						$.messager.alert(msg.MSG0216,msg.MSG0415,msg.MSG0216);
					} else {
						alert('Too many items entered. Maximum 1000 items allowed.');
					}
					return;
				}
			}
			if(ngFlg == false || userIdList === undefined){
				$(multiListPop.targetBtn).parent().children("input[type=hidden]").val('');
				alert('The wrong number was entered!!');
				$("#multi-serach-pop").css("display","none");
				$(multiListPop.targetBtn).css('background-color', 'white');
				multiListPop.popOpenChk = false;
			}else{
				$(multiListPop.targetBtn).parent().children("input[type=hidden]").val(userIdList);
				$(multiListPop.targetBtn).css('background-color', '#9e9c9c');
				$("#multi-serach-pop").css("display","none");
				multiListPop.popOpenChk = false;
			}
		}
}