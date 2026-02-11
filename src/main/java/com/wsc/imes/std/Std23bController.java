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
 * STD23B 휴일관리 Controller
 * @author 송우석
 */
@Controller
@RequestMapping("/imes/std")
public class Std23bController extends BaseController {

    @Autowired
    private Std23bService service;

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
    @RequestMapping(value = "/std23b.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/std/std23b";
    }

    // ========== API 매핑 ==========

    /** 휴일 목록 조회 (그리드+달력) */
    @RequestMapping(value = "/std23b/STD23B_SER.json")
    public String std23bSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23bSer(params);
        addObject(model, result);
        return "jsonView";
    }

    /** 휴일 설정 + CAPA=0 */
    @RequestMapping(value = "/std23b/STD23B_UPD2.json")
    public String std23bUpd2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23bUpd2(params);
        addObject(model, result);
        return "jsonView";
    }

    /** 휴일 해제 + CAPA 복원 */
    @RequestMapping(value = "/std23b/STD23B_UPD3.json")
    public String std23bUpd3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        Object result = service.std23bUpd3(params);
        addObject(model, result);
        return "jsonView";
    }

}
