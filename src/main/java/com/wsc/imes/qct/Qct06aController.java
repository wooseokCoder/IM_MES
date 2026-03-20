package com.wsc.imes.qct;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.ResultMap;

/**
 * QCT06A 자주검사 연계 관리 Controller
 * @author 송우석
 */
@Controller
@RequestMapping("/imes/qct")
public class Qct06aController extends BaseController {

    @Autowired
    private Qct06aService service;

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

    /** 메인 화면 (조립/리스트 탭 통합) */
    @RequestMapping(value = "/qct06a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/qct/qct06a";
    }

    /** D0A 팝업 화면 */
    @RequestMapping(value = "/qct06a_d0a.do")
    public String openD0a(HttpServletRequest request, Model model) {
        return "imes/qct/qct06a_d0a";
    }

    /** 부품 목록 조회 (ASSY 탭) */
    @RequestMapping(value = "/qct06a/QCT06A_SER.json")
    @ResponseBody
    public Object qct06aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        return service.qct06aSer(params);
    }

    /** 검사그룹의 검사항목 조회 */
    @RequestMapping(value = "/qct06a/QCT06A_SER2.json")
    @ResponseBody
    public Object qct06aSer2(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        return service.qct06aSer2(params);
    }

    /** D0A 검사그룹 목록 조회 */
    @RequestMapping(value = "/qct06a/QCT06A_SER3.json")
    @ResponseBody
    public Object qct06aSer3(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        return service.qct06aSer3(params);
    }

    /** 부품의 연계 검사그룹 조회 */
    @RequestMapping(value = "/qct06a/QCT06A_SER5.json")
    @ResponseBody
    public Object qct06aSer5(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        return service.qct06aSer5(params);
    }

    /** LIST 탭 전체 연계 현황 조회 */
    @RequestMapping(value = "/qct06a/QCT06A_SER6.json")
    @ResponseBody
    public Object qct06aSer6(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);
        return service.qct06aSer6(params);
    }

    /** 연계 등록 (D0A에서 호출) */
    @RequestMapping(value = "/qct06a/QCT06A_INS.json", method = RequestMethod.POST)
    @ResponseBody
    public ResultMap qct06aIns(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        return service.qct06aIns(params);
    }

    /** 순번 수정 */
    @RequestMapping(value = "/qct06a/QCT06A_UPD.json", method = RequestMethod.POST)
    @ResponseBody
    public ResultMap qct06aUpd(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        return service.qct06aUpd(params);
    }

    /** 연계 삭제 */
    @RequestMapping(value = "/qct06a/QCT06A_DEL.json", method = RequestMethod.POST)
    @ResponseBody
    public ResultMap qct06aDel(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request, true);
        return service.qct06aDel(params);
    }
}
