/*
 * ============================================================================
 * 화면명: MAT02A - 재고정보 조회
 * ============================================================================
 * 설명: 재고정보 조회 (조회 전용)
 *       4종 재고(일반/판매오더/고객특별/공급업체특별) 통합 조회
 * 원본: ProActive MAT02A.cs, MAT02A_M0A.cs
 * 작성일: 2026-03-03
 * ============================================================================
 */
package com.wsc.imes.mat;

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
 * 재고정보 조회 컨트롤러
 *
 * @author MES
 * @version 1.0
 */
@Controller
@RequestMapping("/imes/mat")
public class Mat02aController extends BaseController {

    @Autowired
    private Mat02aService service;

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
     * 재고정보 조회 메인 화면
     */
    @RequestMapping(value = "/mat02a.do")
    public String open(HttpServletRequest request, Model model) {
        super.open(request, model);
        return "imes/mat/mat02a";
    }

    // ========================================================================
    // 조회
    // ========================================================================

    /**
     * 재고정보 조회 (MAT02A_SER)
     * AS-IS: MAT02A.MAT02A_SER
     *   → TSAP_STOCK_COMM_QUERY1 / ORDER_QUERY1 / CVND_QUERY1 / MVND_QUERY1
     *   → DataSet.Merge() 방식으로 결과 통합
     */
    @RequestMapping(value = "/mat02a/MAT02A_SER.json")
    public String mat02aSer(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.mat02aSer(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

    /**
     * 도면 파일 목록 조회
     * AS-IS: POP30A_SER16 (IF_PLM_FILE_INFO WHERE CAT_CODE='2' AND ORD_NO=PART_CODE)
     * 파일 경로(DRAW2D_FILE_DIR) 확정 후 다운로드 기능 추가 예정
     */
    @RequestMapping(value = "/mat02a/drawFileList.json")
    public String drawFileList(HttpServletRequest request, Model model) {
        ParamsMap params = getParams(request);

        Object result = service.drawFileList(params);

        model.addAttribute("rows", result);

        return "jsonView";
    }

}
