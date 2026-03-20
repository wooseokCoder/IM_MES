/**
 * 이미지 컨텍스트 메뉴 공통 모듈
 *
 * 이미지에 대한 우클릭 컨텍스트 메뉴(잘라내기/복사/붙여넣기/삭제/불러오기/저장)를 제공한다.
 * 메뉴 div는 자동 생성되므로 JSP에 별도 HTML을 넣지 않아도 된다.
 *
 * 모드별 활성화:
 *   - edit: 전체 항목 활성 (이미지 유무/클립보드 상태에 따라 개별 제어)
 *   - readonly: 복사, 저장만 활성 (잘라내기/붙여넣기/삭제/불러오기 비활성)
 *
 * === 사용법 1: 단순 img 요소 (targetSelector 지정) ===
 *
 *   var imgMenu = new ImgContextMenu({
 *       menuId: 'img-context-menu',
 *       mode: 'edit',
 *       targetSelector: '#group-image',          // img 요소 셀렉터
 *       containerSelector: '#image-container',    // img를 감싸는 컨테이너 (빈 영역 우클릭용)
 *       onImageChange: function(b64) { ... },     // 이미지 변경 시 추가 처리
 *       isEnabled: function() { return true; },   // 메뉴 활성 여부 판단
 *       getFileName: function() { return 'image.png'; }
 *   });
 *
 * === 사용법 2: 커스텀 대상 (기존 방식 — 수동 show 호출) ===
 *
 *   var imgMenu = new ImgContextMenu({
 *       menuId: 'img-context-menu',
 *       mode: 'edit',
 *       getImageBase64: function(cb) { cb(base64OrNull); },
 *       setImageData: function(b64OrNull) { ... },
 *       getFileName: function() { return 'image.png'; }
 *   });
 *   imgMenu.show(e, hasImg);
 *
 * === 공통 API ===
 *
 *   imgMenu.clearClipboard();  // 클립보드 초기화 (조회/탭전환 시)
 *   imgMenu.destroy();         // 메뉴 및 리소스 정리
 *
 * @author 송우석
 */
var ImgContextMenu = (function() {

    // 메뉴 높이 캐시 (메뉴ID별)
    var _menuHeightCache = {};

    // 메뉴 HTML 템플릿
    var _MENU_ITEMS = [
        {action: 'cut',    text: '잘라내기'},
        {action: 'copy',   text: '복사'},
        {action: 'paste',  text: '붙여넣기'},
        {action: 'delete', text: '삭제'},
        {action: '_sep'},
        {action: 'load',   text: '불러오기'},
        {action: 'save',   text: '저장'}
    ];

    /**
     * ImgContextMenu 생성자
     * @param opts 옵션 객체
     */
    function ImgContextMenu(opts) {
        if (!opts || !opts.menuId) {
            throw new Error('ImgContextMenu: menuId는 필수입니다.');
        }

        this.menuId = opts.menuId;
        this.mode = opts.mode || 'readonly';
        this.maxFileSize = opts.maxFileSize || (2 * 1024 * 1024);

        // 단순 img 요소 바인딩용 옵션
        this.targetSelector = opts.targetSelector || null;
        this.containerSelector = opts.containerSelector || null;
        this.onImageChange = opts.onImageChange || null;
        this.isEnabled = opts.isEnabled || function() { return true; };

        // 콜백 함수 (targetSelector 지정 시 기본 구현 제공)
        if (this.targetSelector) {
            var self = this;
            this.getImageBase64 = opts.getImageBase64 || function(cb) {
                self._defaultGetImageBase64(cb);
            };
            this.setImageData = opts.setImageData || function(b64) {
                self._defaultSetImageData(b64);
            };
        } else {
            this.getImageBase64 = opts.getImageBase64 || function(cb) { cb(null); };
            this.setImageData = opts.setImageData || function() {};
        }
        this.getFileName = opts.getFileName || function() { return 'image.png'; };

        // 내부 상태
        this._clipboard = null;
        this._fileInput = null;
        this._fileInputId = '_imgCtxMenu_file_' + this.menuId;

        // 메뉴 항목 ID 접두사 (메뉴ID 기반으로 유니크하게)
        this._prefix = this.menuId.replace(/-/g, '_') + '_';

        // 메뉴 div 자동 생성 (DOM에 없으면)
        this._ensureMenu();

        // 메뉴 이벤트 바인딩
        this._bindMenuItems();

        // targetSelector/containerSelector 자동 바인딩
        this._bindTarget();
    }

    // ========================================================================
    // 메뉴 자동 생성
    // ========================================================================

    /**
     * menuId에 해당하는 메뉴 div가 DOM에 없으면 자동 생성
     */
    ImgContextMenu.prototype._ensureMenu = function() {
        if ($('#' + this.menuId).length > 0) return;

        var html = '<div id="' + this.menuId + '" class="easyui-menu" data-options="hideOnUnhover:false">';
        for (var i = 0; i < _MENU_ITEMS.length; i++) {
            var item = _MENU_ITEMS[i];
            if (item.action === '_sep') {
                html += '<div class="menu-sep"></div>';
            } else {
                html += '<div data-action="' + item.action + '">' + item.text + '</div>';
            }
        }
        html += '</div>';

        var $menu = $(html).appendTo('body');
        $.parser.parse($menu);
    };

    // ========================================================================
    // targetSelector 자동 바인딩
    // ========================================================================

    /**
     * targetSelector/containerSelector에 contextmenu 이벤트 자동 바인딩
     */
    ImgContextMenu.prototype._bindTarget = function() {
        if (!this.targetSelector) return;

        var self = this;

        // img 요소에 contextmenu 바인딩
        $(this.targetSelector).off('contextmenu.imgCtx').on('contextmenu.imgCtx', function(e) {
            if (!self.isEnabled()) return;
            var hasImg = _isImgVisible(this);
            self.show(e, hasImg);
        });

        // 컨테이너 빈 영역에도 contextmenu 바인딩
        if (this.containerSelector) {
            var targetSel = this.targetSelector;
            $(this.containerSelector).off('contextmenu.imgCtx').on('contextmenu.imgCtx', function(e) {
                if (!self.isEnabled()) return;
                // img 요소 위에서는 위 핸들러가 처리
                if ($(e.target).is(targetSel)) return;
                var imgEl = $(targetSel)[0];
                var hasImg = imgEl ? _isImgVisible(imgEl) : false;
                self.show(e, hasImg);
            });
        }
    };

    /**
     * targetSelector img 요소에서 base64 추출 (기본 구현)
     */
    ImgContextMenu.prototype._defaultGetImageBase64 = function(cb) {
        var imgEl = $(this.targetSelector)[0];
        if (imgEl && _isImgVisible(imgEl) && imgEl.src) {
            var src = imgEl.src;
            var idx = src.indexOf(',');
            cb(idx >= 0 ? src.substring(idx + 1) : null);
        } else {
            cb(null);
        }
    };

    /**
     * targetSelector img 요소에 base64 세팅 (기본 구현)
     */
    ImgContextMenu.prototype._defaultSetImageData = function(b64) {
        var imgEl = $(this.targetSelector)[0];
        if (!imgEl) return;
        if (b64) {
            imgEl.src = 'data:image/png;base64,' + b64;
            imgEl.style.display = 'block';
        } else {
            imgEl.src = '';
            imgEl.style.display = 'none';
        }
        if (this.onImageChange) this.onImageChange(b64);
    };

    // ========================================================================
    // 메뉴 이벤트
    // ========================================================================

    /**
     * 메뉴 항목에 클릭 이벤트 바인딩
     */
    ImgContextMenu.prototype._bindMenuItems = function() {
        var self = this;
        var $menu = $('#' + this.menuId);
        if ($menu.length === 0) return;

        $menu.menu({
            onClick: function(item) {
                var action = $(item.target).attr('data-action');
                if (!action) return;

                if (action === 'cut') self._doCut();
                else if (action === 'copy') self._doCopy();
                else if (action === 'paste') self._doPaste();
                else if (action === 'delete') self._doDelete();
                else if (action === 'load') self._doLoad();
                else if (action === 'save') self._doSave();
            }
        });
    };

    /**
     * 컨텍스트 메뉴 표시
     * @param e  contextmenu 이벤트 객체
     * @param hasImg  현재 대상에 이미지가 있는지 여부 (boolean)
     */
    ImgContextMenu.prototype.show = function(e, hasImg) {
        e.preventDefault();

        var $menu = $('#' + this.menuId);
        if ($menu.length === 0) return;

        // 모드별 + 이미지 유무에 따른 메뉴 항목 활성화 설정
        if (this.mode === 'readonly') {
            this._setMenuItem('cut', false);
            this._setMenuItem('copy', hasImg);
            this._setMenuItem('paste', false);
            this._setMenuItem('delete', false);
            this._setMenuItem('load', false);
            this._setMenuItem('save', hasImg);
        } else {
            this._setMenuItem('cut', hasImg);
            this._setMenuItem('copy', hasImg);
            this._setMenuItem('paste', !!this._clipboard);
            this._setMenuItem('delete', hasImg);
            this._setMenuItem('load', true);
            this._setMenuItem('save', hasImg);
        }

        this._showMenuAbove(e);
    };

    /**
     * 메뉴를 마우스 커서 위쪽에 표시 (하단 잘림 방지)
     */
    ImgContextMenu.prototype._showMenuAbove = function(e) {
        var $menu = $('#' + this.menuId);
        var menuH = _menuHeightCache[this.menuId];
        if (!menuH) {
            $menu.menu('show', {left: -9999, top: -9999});
            menuH = $menu.outerHeight();
            _menuHeightCache[this.menuId] = menuH;
            $menu.menu('hide');
        }
        var top = e.pageY - menuH;
        if (top < 0) top = e.pageY;
        $menu.menu('show', {left: e.pageX, top: top});
    };

    /**
     * 메뉴 항목 활성/비활성 설정
     */
    ImgContextMenu.prototype._setMenuItem = function(action, enabled) {
        var $menu = $('#' + this.menuId);
        var $item = $menu.find('[data-action="' + action + '"]');
        if ($item.length === 0) return;

        if (enabled) {
            $menu.menu('enableItem', $item[0]);
        } else {
            $menu.menu('disableItem', $item[0]);
        }
    };

    // ========================================================================
    // 메뉴 액션 구현
    // ========================================================================

    /** 잘라내기: 클립보드에 복사 + 이미지 제거 */
    ImgContextMenu.prototype._doCut = function() {
        var self = this;
        this.getImageBase64(function(b64) {
            if (b64) {
                self._clipboard = b64;
                self.setImageData(null);
            }
        });
    };

    /** 복사: 클립보드에 복사 */
    ImgContextMenu.prototype._doCopy = function() {
        var self = this;
        this.getImageBase64(function(b64) {
            if (b64) {
                self._clipboard = b64;
            }
        });
    };

    /** 붙여넣기: 클립보드 이미지를 대상에 반영 */
    ImgContextMenu.prototype._doPaste = function() {
        if (!this._clipboard) {
            $.messager.alert(_getTitle('WARNING'), '클립보드에 이미지가 없습니다.', 'warning');
            return;
        }
        this.setImageData(this._clipboard);
    };

    /** 삭제: 대상에서 이미지 제거 */
    ImgContextMenu.prototype._doDelete = function() {
        this.setImageData(null);
    };

    /** 불러오기: 파일 선택 다이얼로그 */
    ImgContextMenu.prototype._doLoad = function() {
        var self = this;
        var fileInput = document.getElementById(this._fileInputId);
        if (!fileInput) {
            fileInput = document.createElement('input');
            fileInput.type = 'file';
            fileInput.id = this._fileInputId;
            fileInput.accept = 'image/*';
            fileInput.style.display = 'none';
            fileInput.onchange = function() {
                self._handleFileSelected(this);
            };
            document.body.appendChild(fileInput);
        }
        fileInput.value = '';
        fileInput.click();
    };

    /** 파일 선택 후 이미지 반영 */
    ImgContextMenu.prototype._handleFileSelected = function(input) {
        if (!input.files || input.files.length === 0) return;
        var file = input.files[0];
        var self = this;

        if (file.size > this.maxFileSize) {
            var sizeMB = Math.floor(this.maxFileSize / (1024 * 1024));
            $.messager.alert(_getTitle('WARNING'),
                '이미지 파일은 ' + sizeMB + 'MB 이하만 가능합니다.', 'warning');
            return;
        }

        var reader = new FileReader();
        reader.onload = function(e) {
            var dataUrl = e.target.result;
            var idx = dataUrl.indexOf(',');
            var b64 = (idx >= 0) ? dataUrl.substring(idx + 1) : dataUrl;
            self.setImageData(b64);
        };
        reader.readAsDataURL(file);
    };

    /** 저장: 이미지 파일 다운로드 */
    ImgContextMenu.prototype._doSave = function() {
        var self = this;
        this.getImageBase64(function(b64) {
            if (!b64) return;

            var fileName = self.getFileName();
            var binary = atob(b64);
            var bytes = new Uint8Array(binary.length);
            for (var i = 0; i < binary.length; i++) {
                bytes[i] = binary.charCodeAt(i);
            }
            var blob = new Blob([bytes], {type: 'image/png'});
            var url = URL.createObjectURL(blob);
            var link = document.createElement('a');
            link.href = url;
            link.download = fileName;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
        });
    };

    // ========================================================================
    // 외부 API
    // ========================================================================

    /** 클립보드 초기화 (조회/탭전환 시 호출) */
    ImgContextMenu.prototype.clearClipboard = function() {
        this._clipboard = null;
    };

    /** 모드 변경 */
    ImgContextMenu.prototype.setMode = function(mode) {
        this.mode = mode;
    };

    /** 콜백 업데이트 (대상 행/이미지 변경 시) */
    ImgContextMenu.prototype.updateCallbacks = function(opts) {
        if (opts.getImageBase64) this.getImageBase64 = opts.getImageBase64;
        if (opts.setImageData) this.setImageData = opts.setImageData;
        if (opts.getFileName) this.getFileName = opts.getFileName;
    };

    /** 메뉴 및 파일 input 정리 */
    ImgContextMenu.prototype.destroy = function() {
        var fileInput = document.getElementById(this._fileInputId);
        if (fileInput) {
            document.body.removeChild(fileInput);
        }
        if (this.targetSelector) {
            $(this.targetSelector).off('contextmenu.imgCtx');
        }
        if (this.containerSelector) {
            $(this.containerSelector).off('contextmenu.imgCtx');
        }
        this._clipboard = null;
        _menuHeightCache[this.menuId] = null;
    };

    // ========================================================================
    // 내부 유틸리티
    // ========================================================================

    /** img 요소에 이미지가 표시되고 있는지 판단 */
    function _isImgVisible(el) {
        return el && el.style.display !== 'none' && el.src && el.src.indexOf('data:') >= 0;
    }

    /** 다국어 타이틀 가져오기 */
    function _getTitle(key) {
        if (typeof tit !== 'undefined') {
            if (key === 'WARNING') return (typeof msg !== 'undefined' && msg.MSG0051) || '경고';
        }
        if (key === 'WARNING') return '경고';
        return '';
    }

    return ImgContextMenu;

})();
