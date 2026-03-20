/*
 * ============================================================================
 * 화면명: ORD32A - NG 조립 파일 모델/공정 매핑 관리
 * ============================================================================
 * 설명: TSYS_FILELIST_MASTER에서 NG_ASSY_FILE 파일 목록을 조회하고,
 *       각 파일에 적용할 모델(TSTD_NG_FILE_MODEL)과
 *       공정(TSTD_NG_FILE_PROC) 매핑을 관리한다.
 *       첨부파일(acAttachFileControl) 영역은 별도 개발자가 구현.
 *
 * 화면 구조:
 *   - 상단 좌: Grid1 (파일목록)
 *   - 상단 우: 첨부파일 영역 (reserved)
 *   - 하단 좌: Grid2 (적용 모델)
 *   - 하단 우: Grid3 (적용 공정)
 *   - D0A 팝업: 모델/공정 편집 (4 grids)
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - ORD32A_SER  → ord32aSer  (파일목록 조회)
 * - ORD32A_SER2 → ord32aSer2 (선택 파일의 모델/공정 조회)
 * - ORD32A_SER3 → ord32aSer3 (전체 모델/전체 공정 조회, D0A용)
 * - ORD32A_INS  → ord32aIns  (모델/공정 매핑 저장)
 *
 * 원본: ProActive ORD32A.cs, ORD32A_M0A.cs, ORD32A_D0A.cs
 * @author Claude
 * @since 2026-03-10
 * ============================================================================
 */
package com.wsc.imes.ord;

import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * NG 조립 파일 모델/공정 매핑 관리 컨트롤러
 */
@Controller
@RequestMapping("/imes/ord")
public class Ord32aController extends BaseController {

    @Autowired
    private Ord32aService service;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseService getService() {
        return this.service;
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return this.sessionProvider.get();
    }

    // ========================================================================
    // 화면 열기
    // ========================================================================

    /**
     * 메인 화면
     */
    @RequestMapping(value = "/ord32a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/ord/ord32a";
    }

    // ========================================================================
    // ORD32A_SER: 파일목록 조회 (Grid1)
    // TSYS_FILELIST_MASTER (LINK_KEY='NG_ASSY_FILE', IS_UPLOAD=1, DATA_FLAG=0)
    // ========================================================================

    @RequestMapping(value = "/ord32a/ORD32A_SER.json")
    public String ord32aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.ord32aSer(params);
        model.addAttribute("rows", result);
        return "jsonView";
    }

    // ========================================================================
    // ORD32A_SER2: 선택 파일의 모델 + 공정 조회 (Grid2, Grid3)
    // ========================================================================

    @RequestMapping(value = "/ord32a/ORD32A_SER2.json")
    public String ord32aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = service.ord32aSer2(params);
        model.addAttribute("models", result.get("models"));
        model.addAttribute("procs", result.get("procs"));
        return "jsonView";
    }

    // ========================================================================
    // ORD32A_SER3: 전체 모델 + 전체 공정 마스터 조회 (D0A 팝업)
    // ========================================================================

    @RequestMapping(value = "/ord32a/ORD32A_SER3.json")
    public String ord32aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = service.ord32aSer3(params);
        model.addAttribute("models", result.get("models"));
        model.addAttribute("procs", result.get("procs"));
        return "jsonView";
    }

    // ========================================================================
    // ORD32A_INS: 모델/공정 매핑 저장 (Delete-Insert 패턴)
    // JSON body: { fileId, models: [{model},...], procs: [{procCode},...] }
    // ========================================================================

    @RequestMapping(value = "/ord32a/ORD32A_INS.json")
    public String ord32aIns(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        Object result = service.ord32aIns(params);
        addObject(model, result);
        return "jsonView";
    }

}
