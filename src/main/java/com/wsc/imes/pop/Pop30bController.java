/*
 * ============================================================================
 * 화면명: POP30B - 실적관리 조립
 * ============================================================================
 * 설명: 조립 실적 조회, 등록, 수정 및 POP30A 서비스 재사용
 * 작성일: 2026-03-18
 * ============================================================================
 *
 * URL 매핑:
 * - 화면 오픈: /imes/pop/pop30b.do
 *
 * POP30B BIZ (11개):
 * - /imes/pop/pop30b/POP30B_SER.json      (조회)
 * - /imes/pop/pop30b/POP30B_SER2.json     (조회2)
 * - /imes/pop/pop30b/POP30B_SER3.json     (조회3)
 * - /imes/pop/pop30b/POP30B_SER4.json     (조회4)
 * - /imes/pop/pop30b/POP30B_SER5.json     (조회5)
 * - /imes/pop/pop30b/POP30B_SER6.json     (조회6)
 * - /imes/pop/pop30b/POP30B_UPD.json      (수정 - @RequestBody)
 * - /imes/pop/pop30b/POP30B_INS.json      (등록 - @RequestBody)
 * - /imes/pop/pop30b/POP30B_INS_1.json    (등록1 - @RequestBody)
 * - /imes/pop/pop30b/POP30B_INS2.json     (등록2)
 * - /imes/pop/pop30b/POP30B_INS3.json     (등록3 - @RequestBody)
 *
 * POP30A BIZ 참조 (9개):
 * - /imes/pop/pop30b/POP30A_SER_INIT.json (초기 작업자 조회)
 * - /imes/pop/pop30b/POP30A_SER16.json    (조회16)
 * - /imes/pop/pop30b/POP30A_SER17.json    (조회17)
 * - /imes/pop/pop30b/POP30A_SER19.json    (조회19)
 * - /imes/pop/pop30b/POP30A_SER20.json    (조회20)
 * - /imes/pop/pop30b/POP30A_SER21.json    (조회21)
 * - /imes/pop/pop30b/POP30A_SER22.json    (조회22)
 * - /imes/pop/pop30b/POP30A_SER_A.json    (조회A)
 * - /imes/pop/pop30b/POP30A_INS_A.json    (등록A)
 * ============================================================================
 */
package com.wsc.imes.pop;

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
 * 실적관리 조립 컨트롤러
 *
 * @author MES
 * @since 2026-03-18
 */
@Controller
@RequestMapping("/imes/pop")
public class Pop30bController extends BaseController {

    @Autowired
    private Pop30bService pop30bService;

    @Autowired
    private Pop30aService pop30aService;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseService getService() {
        return this.pop30bService;
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return this.sessionProvider.get();
    }

    // ========================================================================
    // 화면 열기
    // ========================================================================

    /**
     * 실적관리 조립 화면 오픈
     */
    @RequestMapping(value = "/pop30b.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/pop/pop30b";
    }

    // ========================================================================
    // POP30B 조회 (6개)
    // ========================================================================

    /**
     * POP30B 조회 (POP30B_SER)
     */
    @RequestMapping(value = "/pop30b/POP30B_SER.json")
    public String pop30bSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 조회2 (POP30B_SER2)
     */
    @RequestMapping(value = "/pop30b/POP30B_SER2.json")
    public String pop30bSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bSer2(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 조회3 (POP30B_SER3)
     */
    @RequestMapping(value = "/pop30b/POP30B_SER3.json")
    public String pop30bSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bSer3(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 조회4 (POP30B_SER4)
     */
    @RequestMapping(value = "/pop30b/POP30B_SER4.json")
    public String pop30bSer4(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bSer4(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 조회5 (POP30B_SER5)
     */
    @RequestMapping(value = "/pop30b/POP30B_SER5.json")
    public String pop30bSer5(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bSer5(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 조회6 (POP30B_SER6)
     */
    @RequestMapping(value = "/pop30b/POP30B_SER6.json")
    public String pop30bSer6(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bSer6(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // POP30B 수정 (1개)
    // ========================================================================

    /**
     * POP30B 수정 (POP30B_UPD)
     * <p>
     * JS에서 JSON.stringify()로 전송하므로 @RequestBody로 파싱
     * </p>
     */
    @RequestMapping(value = "/pop30b/POP30B_UPD.json")
    public String pop30bUpd(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        Object result = pop30bService.pop30bUpd(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // POP30B 등록 (4개)
    // ========================================================================

    /**
     * POP30B 등록 (POP30B_INS)
     * <p>
     * JS에서 JSON.stringify()로 detail rows 전송
     * </p>
     */
    @RequestMapping(value = "/pop30b/POP30B_INS.json")
    public String pop30bIns(@RequestBody Map<String, Object> body,
                            HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        Object result = pop30bService.pop30bIns(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 등록1 (POP30B_INS_1)
     * <p>
     * JS에서 JSON.stringify()로 detail rows 전송
     * </p>
     */
    @RequestMapping(value = "/pop30b/POP30B_INS_1.json")
    public String pop30bIns1(@RequestBody Map<String, Object> body,
                             HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        if (body != null) {
            params.putAll(body);
        }
        Object result = pop30bService.pop30bIns1(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 등록2 (POP30B_INS2)
     */
    @RequestMapping(value = "/pop30b/POP30B_INS2.json")
    public String pop30bIns2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        Object result = pop30bService.pop30bIns2(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30B 등록3 (POP30B_INS3)
     */
    @RequestMapping(value = "/pop30b/POP30B_INS3.json")
    public String pop30bIns3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        Object result = pop30bService.pop30bIns3(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // POP30A 서비스 참조 - 조회 (8개)
    // ========================================================================

    /**
     * 초기 작업자 조회 (POP30A_SER_INIT 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_SER_INIT.json")
    public String pop30aSerInit(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30aService.pop30aSerInitWorker(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30A 조회16 (POP30A_SER16 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_SER16.json")
    public String pop30aSer16(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30aService.pop30aSer16(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30A 조회17 (POP30A_SER17 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_SER17.json")
    public String pop30aSer17(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30aService.pop30aSer17(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30A 조회19 (POP30A_SER19 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_SER19.json")
    public String pop30aSer19(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30aService.pop30aSer19(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30A 조회20 (POP30A_SER20 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_SER20.json")
    public String pop30aSer20(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30aService.pop30aSer20(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30A 조회21 (POP30A_SER21 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_SER21.json")
    public String pop30aSer21(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30aService.pop30aSer21(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * POP30A 조회22 (POP30A_SER22 재사용)
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/pop30b/POP30A_SER22.json")
    public String pop30aSer22(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> result = pop30aService.pop30aSer22(params);

        // Map 키들을 model에 직접 넣어서 JSON 최상위 레벨로 노출
        model.addAttribute("rows", result.get("rows"));
        model.addAttribute("hasMaster", result.get("hasMaster"));
        if (result.get("insmNo") != null) {
            model.addAttribute("insmNo", result.get("insmNo"));
        }
        if (result.get("insGrpCode") != null) {
            model.addAttribute("insGrpCode", result.get("insGrpCode"));
        }

        return "jsonView";
    }

    /**
     * 검사그룹 이미지 조회 - QCT05A 방식 (TO_BASE64 → imgData)
     */
    @RequestMapping(value = "/pop30b/POP30B_D4A_IMG.json")
    public String pop30bD4aImg(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Map<String, Object> imgRow = (Map<String, Object>) pop30bService.selectInsGrpImg(params);
        if (imgRow != null && imgRow.get("insImgBase64") != null) {
            model.addAttribute("imgData", imgRow.get("insImgBase64"));
        }
        return "jsonView";
    }

    /**
     * POP30A 조회A (POP30A_SER_A 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_SER_A.json")
    public String pop30aSerA(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30aService.pop30aSerA(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // POP30A 서비스 참조 - 등록 (1개)
    // ========================================================================

    /**
     * POP30A 등록A (POP30A_INS_A 재사용)
     */
    @RequestMapping(value = "/pop30b/POP30A_INS_A.json")
    public String pop30aInsA(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        Object result = pop30aService.pop30aInsA(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // POP30B 전용 팝업 검색 (2개)
    // ========================================================================

    /**
     * 비가동코드 목록 조회 - WorkIdle 공통 팝업
     * AS-IS: POP32A_IDLE → TSTD_IDLECODE_SER2
     */
    @RequestMapping(value = "/pop30b/idleCodeSearch.json")
    public String pop30bIdleCodeSearch(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bIdleCodeSearch(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 작업장(설비) 검색 - POP30B 전용
     * AS-IS: ChangeCellMc → LSE_MACHINE_QUERY2
     */
    @RequestMapping(value = "/pop30b/mcSearch.json")
    public String pop30bMcSearch(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bMcSearch(params);
        addObject(model, result);
        return "jsonView";
    }

    /**
     * 작업자(사원) 검색 - POP30B 전용
     * AS-IS: ChangeEmp → TSTD_EMPLOYEE_QUERY6
     */
    @RequestMapping(value = "/pop30b/empSearch.json")
    public String pop30bEmpSearch(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bEmpSearch(params);
        addObject(model, result);
        return "jsonView";
    }

    // ========================================================================
    // POP30B_D4A 자주검사 팝업 전용
    // ========================================================================

    /**
     * D4A 작업지시 정보 조회 (팝업 상단 라벨용)
     */
    @RequestMapping(value = "/pop30b/POP30B_D4A_WO_INFO.json")
    public String pop30bD4aWoInfo(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = pop30bService.pop30bD4aWoInfo(params);
        addObject(model, result);
        return "jsonView";
    }

}
