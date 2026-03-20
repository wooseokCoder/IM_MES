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
						$.messager.alert(msg.MSG0049,msg.MSG0095,msg.MSG0049);
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
						$.messager.alert(msg.MSG0049,msg.MSG0095,msg.MSG0049);
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

// ============================================================================
// EasyUI datagrid 공통 설정
// ============================================================================

// 클라이언트 정렬 기본 활성화
$.fn.datagrid.defaults.remoteSort = false;

// loadData 오버라이드: 새 데이터 로드 시 이전 정렬 상태 자동 초기화
// - _sortSkipReset 플래그: 명시적 건너뜀 (정렬 재로드)
// - 동일 data 참조: 페이지 변경 시 자동 감지하여 건너뜀
(function() {
    var _origLoadData = $.fn.datagrid.methods.loadData;
    $.fn.datagrid.methods.loadData = function(jq, data) {
        jq.each(function() {
            var g = $.data(this, 'datagrid');
            if (g && g.options && g.options._sortResetEnabled) {
                if (!g.options._sortSkipReset) {
                    // 동일 참조 = 페이지 변경 또는 정렬 재로드 → 초기화 건너뜀
                    var sameRef = g.data && (g.data === data ||
                        (data && data.originalRows && g.data.originalRows === data.originalRows));
                    if (!sameRef) {
                        g.options.sortName = null;
                        g.options.sortOrder = 'asc';
                    }
                }
                delete g.options._sortSkipReset;
            }
        });
        return _origLoadData.call(this, jq, data);
    };
})();

/**
 * 그리드 정렬 3단계 토글 활성화 (asc → desc → 정렬해제)
 * - datagrid 생성 후 호출 ($(window).load 또는 consts.init 마지막)
 * - 모든 컬럼에 sortable:true 자동 적용 (sortable:false 명시 컬럼 제외)
 * - onBeforeSortColumn으로 3번째 클릭 시 정렬 취소 및 원본 복원
 * - 새 데이터 로드 시 정렬 상태 및 화살표 자동 초기화
 * - 페이징 그리드 자동 감지: _allRows(jQuery data) 또는 originalRows(clientPagerFilter) 패턴
 *
 * @param {string} gridId - 그리드 셀렉터 (예: '#search-grid')
 */
function enableGridSortReset(gridId) {
    var $grid = $(gridId);
    var _isTree = !!$.data($grid[0], 'treegrid');
    var gtype = _isTree ? 'treegrid' : 'datagrid';
    var _originalRows = null;   // datagrid용: flat 배열
    var _originalTree = null;   // treegrid용: 깊은 복사본
    var _prevSort = { field: null, order: null };

    var opts = $grid[gtype]('options');
    // treegrid: 정렬 함수는 datagrid options에서 핸들러를 읽으므로 별도 참조 필요
    var dgOpts = _isTree ? $grid.datagrid('options') : opts;
    opts._sortResetEnabled = true;
    opts.remoteSort = false;
    dgOpts.remoteSort = false;  // URL 있는 그리드도 클라이언트 사이드 정렬 사용

    // null-safe 기본 비교 함수 (null/undefined 안전, 숫자 자동 감지)
    var _defaultSorter = function(a, b) {
        if (a == null) a = '';
        if (b == null) b = '';
        if (a !== '' && b !== '' && !isNaN(a) && !isNaN(b)) {
            return Number(a) - Number(b);
        }
        a = String(a).toLowerCase();
        b = String(b).toLowerCase();
        return a < b ? -1 : (a > b ? 1 : 0);
    };

    // 모든 컬럼에 sortable:true + null-safe sorter 자동 적용 (명시 설정 컬럼 제외)
    var allCols = [].concat(opts.columns || [], opts.frozenColumns || []);
    for (var i = 0; i < allCols.length; i++) {
        for (var j = 0; j < allCols[i].length; j++) {
            if (allCols[i][j].sortable !== false) {
                allCols[i][j].sortable = true;
                if (!allCols[i][j].sorter) {
                    allCols[i][j].sorter = _defaultSorter;
                }
            }
        }
    }

    // ── treegrid 전용 유틸리티 ──
    // 형제 노드끼리 재귀 정렬 (부모-자식 계층 유지)
    function sortTreeRecursive(nodes, field, order) {
        if (!nodes || !nodes.length) return;
        var sorter = _defaultSorter;
        var col = $grid[gtype]('getColumnOption', field);
        if (col && col.sorter) sorter = col.sorter;
        nodes.sort(function(a, b) {
            return sorter(a[field], b[field]) * (order === 'asc' ? 1 : -1);
        });
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].children) sortTreeRecursive(nodes[i].children, field, order);
        }
    }

    // ── 페이징 헬퍼 (datagrid 전용) ──
    // 전체 행 배열 참조 (페이징 그리드만 존재)
    function getAllRows() {
        if (_isTree) return null;  // treegrid는 페이징 미사용
        // Pattern 1: _allRows (jQuery data 방식)
        var a = $grid.data('_allRows');
        if (a) return a;
        // Pattern 2: originalRows (clientPagerFilter 방식)
        try {
            var d = $grid.datagrid('getData');
            if (d && d.originalRows) return d.originalRows;
        } catch(e) {}
        return null;
    }

    // pager UI 강제 동기화 (로컬 clientPagerFilter가 pageNumber 미전달해도 동작)
    function syncPager() {
        try {
            var pager = $grid.datagrid('getPager');
            if (pager && pager.length) {
                pager.pagination('refresh', {
                    pageNumber: opts.pageNumber,
                    pageSize: opts.pageSize
                });
            }
        } catch(e) {}
    }

    // 페이징 데이터 재로드 (loadFilter 재실행 → 페이지 슬라이싱)
    function reloadPager() {
        opts._sortSkipReset = true;
        var a = $grid.data('_allRows');
        if (a) { $grid.datagrid('loadData', a); syncPager(); return; }
        try {
            var d = $grid.datagrid('getData');
            if (d && d.originalRows) { $grid.datagrid('loadData', d); syncPager(); return; }
        } catch(e) {}
    }

    // 원본 복원
    function restoreOriginal() {
        if (_isTree) {
            // treegrid: 깊은 복사본으로 복원
            if (!_originalTree) return;
            $grid.treegrid('loadData', JSON.parse(JSON.stringify(_originalTree)));
            return;
        }
        if (!_originalRows) return;
        opts._sortSkipReset = true;
        // Pattern 1: _allRows
        var a = $grid.data('_allRows');
        if (a) {
            var r = _originalRows.slice();
            $grid.data('_allRows', r);
            $grid.datagrid('loadData', r);
            syncPager();
            return;
        }
        // Pattern 2: originalRows
        try {
            var d = $grid.datagrid('getData');
            if (d && d.originalRows) {
                d.originalRows = _originalRows.slice();
                $grid.datagrid('loadData', d);
                syncPager();
                return;
            }
        } catch(e) {}
        // 비페이징
        $grid.datagrid('loadData', _originalRows.slice());
    }

    // onBeforeLoad 래핑: AJAX load() 시 정렬 상태 초기화
    var origOnBeforeLoad = opts.onBeforeLoad;
    opts.onBeforeLoad = function(params) {
        opts.sortName = null;
        opts.sortOrder = 'asc';
        if (origOnBeforeLoad) return origOnBeforeLoad.call(this, params);
    };

    // onLoadSuccess 래핑: 새 데이터 로드 시 원본 행 저장 + 화살표 제거
    var origOnLoadSuccess = opts.onLoadSuccess;
    opts.onLoadSuccess = function(data) {
        if (!opts.sortName) {
            // sortName이 null = 새 데이터 로드 (정렬/페이지변경 아님)
            if (_isTree) {
                _originalTree = JSON.parse(JSON.stringify($grid.treegrid('getData')));
            } else {
                var allRows = getAllRows();
                _originalRows = allRows ? allRows.slice() : $grid.datagrid('getRows').slice();
            }
            _prevSort = { field: null, order: null };
            $grid[gtype]('getPanel').find('div.datagrid-cell')
                .removeClass('datagrid-sort-asc datagrid-sort-desc');
        }
        if (origOnLoadSuccess) origOnLoadSuccess.call(this, data);
    };

    // 정렬 화살표 수동 설정 (onBeforeSortColumn에서 return false 시 사용)
    function setSortArrow(sort, order) {
        var panel = $grid[gtype]('getPanel');
        panel.find('div.datagrid-cell')
            .removeClass('datagrid-sort-asc datagrid-sort-desc');
        if (sort) {
            var col = $grid[gtype]('getColumnOption', sort);
            if (col && col.cellClass) {
                panel.find('div.' + col.cellClass)
                    .addClass('datagrid-sort-' + order);
            }
        }
    }

    // onBeforeSortColumn: 정렬 처리
    // treegrid: datagrid 정렬 함수가 datagrid options에서 핸들러를 읽으므로 dgOpts에 설정
    var _sortHandler = function(sort, order) {
        // 같은 컬럼 desc 후 다시 클릭 → 정렬 해제
        if (sort === _prevSort.field && _prevSort.order === 'desc') {
            _prevSort = { field: null, order: null };
            opts.sortName = null;
            opts.sortOrder = 'asc';
            dgOpts.sortName = null;
            dgOpts.sortOrder = 'asc';
            opts.pageNumber = 1;
            setSortArrow(null);
            restoreOriginal();
            return false;
        }

        _prevSort = { field: sort, order: order };

        // treegrid: 재귀 정렬
        if (_isTree) {
            if (!_originalTree) _originalTree = JSON.parse(JSON.stringify($grid.treegrid('getData')));
            var data = JSON.parse(JSON.stringify($grid.treegrid('getData')));
            sortTreeRecursive(data, sort, order);
            opts.sortName = sort;
            opts.sortOrder = order;
            dgOpts.sortName = sort;
            dgOpts.sortOrder = order;
            $grid.treegrid('loadData', data);
            setSortArrow(sort, order);
            return false;
        }

        // 페이징 그리드: 전체 데이터 정렬 후 재페이징
        var allRows = getAllRows();
        if (allRows) {
            var col = $grid.datagrid('getColumnOption', sort);
            var sorter = (col && col.sorter) || _defaultSorter;
            allRows.sort(function(r1, r2) {
                return sorter(r1[sort], r2[sort]) * (order === 'asc' ? 1 : -1);
            });

            // 정렬 상태 유지하며 재로드 (페이지 1로 이동)
            opts.sortName = sort;
            opts.sortOrder = order;
            opts.pageNumber = 1;
            reloadPager();
            setSortArrow(sort, order);
            return false;
        }

        // 비페이징 그리드: EasyUI 기본 정렬 사용
    };
    opts.onBeforeSortColumn = _sortHandler;
    dgOpts.onBeforeSortColumn = _sortHandler;  // treegrid: datagrid 정렬 함수가 읽는 옵션
}

/**
 * EasyUI datagrid 클라이언트 사이드 페이징 공통 필터
 * - pagination:true인 그리드의 loadFilter에 지정
 * - enableGridSortReset()과 자동 연동 (전체 데이터 정렬 + 재페이징)
 * - onBeforePageChange 콜백 지원 (페이지 변경 전 실행, 예: 셀 편집 종료)
 *
 * 사용법:
 *   $('#grid').datagrid({
 *       pagination: true,
 *       pageSize: 100,
 *       loadFilter: clientPagerFilter,
 *       onBeforePageChange: function() { ... }  // 선택사항
 *   });
 */
function clientPagerFilter(data) {
    if ($.isArray(data)) {
        data = { total: data.length, rows: data };
    }
    var dg = $(this);
    var opts = dg.datagrid('options');
    var pager = dg.datagrid('getPager');
    if (!data.originalRows) {
        data.originalRows = data.rows;
    }
    pager.pagination({
        total: data.originalRows.length,
        pageNumber: opts.pageNumber,
        pageSize: opts.pageSize,
        onSelectPage: function(pageNum, pageSize) {
            if (typeof opts.onBeforePageChange === 'function') {
                opts.onBeforePageChange();
            }
            opts.pageNumber = pageNum;
            opts.pageSize = pageSize;
            pager.pagination('refresh', {
                pageNumber: pageNum,
                pageSize: pageSize
            });
            opts._sortSkipReset = true;
            dg.datagrid('loadData', data);
        }
    });
    data.total = data.originalRows.length;
    var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
    var end = start + parseInt(opts.pageSize);
    data.rows = data.originalRows.slice(start, end);
    return data;
}