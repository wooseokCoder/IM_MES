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

/**
 * STD23A 휴일관리 Controller
 * @author 송우석
 */
@Controller
@RequestMapping("/imes/std")
public class Std23aController extends BaseController {

    @Autowired
    private Std23aService service;

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

    // ========== View 매핑 ==========

    /** 메인 화면 */
    @RequestMapping(value = "/std23a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/std/std23a";
    }

    /** D0B 팝업: CAPA 생성 */
    @RequestMapping(value = "/std23a_d0b.do")
    public String openD0b(HttpServletRequest request, Model model) {
        return "imes/std/std23a_d0b";
    }

    /** D1B 팝업: 휴일설정 */
    @RequestMapping(value = "/std23a_d1b.do")
    public String openD1b(HttpServletRequest request, Model model) {
        return "imes/std/std23a_d1b";
    }

    /** D2B 팝업: CAPA 변경 */
    @RequestMapping(value = "/std23a_d2b.do")
    public String openD2b(HttpServletRequest request, Model model) {
        return "imes/std/std23a_d2b";
    }

    // ========== API 매핑 ==========

    /** 날짜별 설비 CAPA 그리드 조회 */
    @RequestMapping(value = "/std23a/STD23A_SER.json")
    public String std23aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23aSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /** 휴일 목록 조회 (달력 표시용) */
    @RequestMapping(value = "/std23a/STD23A_SER1.json")
    public String std23aSer1(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23aSer1(params);
        addObject(model, result);
        return "jsonView";
    }

    /** 설비 목록 조회 (D0B 팝업용) */
    @RequestMapping(value = "/std23a/STD23A_SER5.json")
    public String std23aSer5(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23aSer5(params);
        addObject(model, result);
        return "jsonView";
    }

    /** CAPA 일괄 생성 (D0B) */
    @RequestMapping(value = "/std23a/STD23A_INS_CAPA.json")
    public String std23aInsCapa(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        Object result = service.std23aInsCapa(params);
        addObject(model, result);
        return "jsonView";
    }

    /** CAPA 기본값 복원 */
    @RequestMapping(value = "/std23a/STD23A_UPD1.json")
    public String std23aUpd1(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        Object result = service.std23aUpd1(params);
        addObject(model, result);
        return "jsonView";
    }

    /** 휴일 설정 + CAPA=0 */
    @RequestMapping(value = "/std23a/STD23A_UPD2.json")
    public String std23aUpd2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23aUpd2(params);
        addObject(model, result);
        return "jsonView";
    }

    /** 휴일 해제 + CAPA 복원 */
    @RequestMapping(value = "/std23a/STD23A_UPD3.json")
    public String std23aUpd3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23aUpd3(params);
        addObject(model, result);
        return "jsonView";
    }

    /** 개별 CAPA 변경 (D2B) */
    @RequestMapping(value = "/std23a/STD23B_UPD4.json")
    public String std23bUpd4(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23bUpd4(params);
        addObject(model, result);
        return "jsonView";
    }

}
