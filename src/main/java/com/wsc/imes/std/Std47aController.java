/*
 * ============================================================================
 * 화면명: STD47A - 작업표준서(조립)
 * ============================================================================
 * 설명: 작업표준서 등록 및 조회
 * 원본: ProActive STD47A.cs, STD47A_M0A.cs
 * 작성일: 2026-03-03
 * ============================================================================
 */
package com.wsc.imes.std;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * 작업표준서(조립) 컨트롤러
 *
 * @author AI Assistant
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/std")
public class Std47aController extends BaseController {

    @Autowired
    private Std47aService service;

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
     * 작업표준서(조립) 화면 오픈
     */
    @RequestMapping(value = "/std47a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);  // 권한 변수 설정 (RET, INS, UPD, DEL)
        return "imes/std/std47a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 모델 트리 조회 (STD47A_SER)
     * 원본: STD47A.STD47A_SER() → TSTD_MODEL_QUERY2, QUERY2_1, QUERY2_2
     */
    @RequestMapping(value = "/std47a/STD47A_SER.json")
    public String std47aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std47aSer(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * LEVEL2 노드 Lazy Load — 특정 모델의 공정그룹(LEVEL3) 조회 (STD47A_SER_LEVEL3)
     * LEVEL2 노드(모델번호) 펼치기 시점에 호출됨
     * 파라미터: plants, modelNo
     */
    @RequestMapping(value = "/std47a/STD47A_SER_LEVEL3.json")
    public String std47aSerLevel3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std47aSerLevel3(params);

        addObject(model, result);

        return "jsonView";
    }

    /**
     * 작업표준서 리스트 조회 (STD47A_SER2)
     * 원본: STD47A.STD47A_SER2() → TSYS_FILELIST_MASTER_QUERY6
     */
    @RequestMapping(value = "/std47a/STD47A_SER2.json")
    public String std47aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.std47aSer2(params);

        addObject(model, result);

        return "jsonView";
    }
}
