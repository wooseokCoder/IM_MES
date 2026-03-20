/*
 * ============================================================================
 * 화면명: POP56A - 불량메일 발신자 관리
 * ============================================================================
 * 설명: 불량메일 수신자 등록/삭제, 발신자 설정 저장
 * 원본: ProActive POP56A.cs (CUBIZ_BR\BPOP\POP56A.cs)
 * 작성일: 2026-03-07
 * ============================================================================
 *
 * 메서드명 규칙: AS-IS 원본 메서드명 유지 (camelCase 변환)
 * - POP56A_SER  -> pop56aSer  (수신자 목록 조회)
 * - POP56A_INS  -> pop56aIns  (수신자 등록)
 * - POP56A_DEL  -> pop56aDel  (수신자 삭제)
 * - POP56A_SAVE_CONFIG -> pop56aSaveConfig (발신자 설정 저장)
 */
package com.wsc.imes.pop;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.model.ResultMap;

/**
 * 불량메일 발신자 관리 서비스
 * <p>
 * 2-Grid 구조:
 * Grid1(전동 E) / Grid2(유압 P) 수신자 목록 관리
 * + 발신자 설정 저장 (TSYS_CONF)
 * </p>
 *
 * @author MES
 * @since 2026-03-07
 */
@Service
public class Pop56aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Pop56aService.class);

    // ========================================================================
    // Namespace 상수
    // ========================================================================
    /** TSTD_NG_MAIL_EMP CRUD (QUERY1, SER, INS, UPD, UDE, CONF_UPSERT) */
    private static final String NS = "com.wsc.imes.pop.TSTD_NG_MAIL_EMP";

    /** SysConfig 조회 (search) */
    private static final String NS_CONF = "com.wsc.imes.common.SysConfig";

    @Autowired
    private CommonDao dao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Override
    protected BaseDao getDao() {
        return this.dao;
    }

    @Override
    protected MessageSource getMessageSource() {
        return this.messageSource;
    }

    @Override
    protected SessionComponent getSessionComponent() {
        return sessionProvider.get();
    }

    // ========================================================================
    // loadNgMailConfig: TSYS_CONF에서 NG_MAIL_E, NG_MAIL_P 로딩
    // Controller open()에서 호출하여 model에 담아 JSP로 전달
    // ========================================================================

    /**
     * 불량메일 발신자 설정 로딩
     * <p>
     * TSYS_CONF에서 NG_MAIL_E, NG_MAIL_P 설정값을 조회하여
     * Map으로 반환한다.
     * </p>
     *
     * @param params gsPltCode(공장코드) 포함
     * @return NG_MAIL_E, NG_MAIL_P 설정값 Map
     */
    @SuppressWarnings("unchecked")
    public Map<String, String> loadNgMailConfig(ParamsMap params) {
        Map<String, String> configMap = new HashMap<String, String>();
        configMap.put("NG_MAIL_E", "");
        configMap.put("NG_MAIL_P", "");
        configMap.put("NG_MAIL_E_NAME", "");
        configMap.put("NG_MAIL_P_NAME", "");

        try {
            // TSYS_CONF에서 SYS 섹션 전체 조회
            List<RecordMap> confList = (List<RecordMap>) searchByMapper(NS_CONF, "search", params);
            if (confList != null) {
                for (int i = 0; i < confList.size(); i++) {
                    RecordMap conf = confList.get(i);
                    String confName = (String) conf.get("confName");
                    String confValue = (String) conf.get("confValue");
                    if ("NG_MAIL_E".equals(confName)) {
                        configMap.put("NG_MAIL_E", confValue != null ? confValue : "");
                    } else if ("NG_MAIL_P".equals(confName)) {
                        configMap.put("NG_MAIL_P", confValue != null ? confValue : "");
                    }
                }
            }

            // 발신자 사원코드 → 사원명 변환 (SYS_USER 조회)
            String empCodeE = configMap.get("NG_MAIL_E");
            if (empCodeE != null && empCodeE.trim().length() > 0) {
                String empNameE = getEmpName(params.getString("gsPltCode"), empCodeE);
                configMap.put("NG_MAIL_E_NAME", empNameE);
            }
            String empCodeP = configMap.get("NG_MAIL_P");
            if (empCodeP != null && empCodeP.trim().length() > 0) {
                String empNameP = getEmpName(params.getString("gsPltCode"), empCodeP);
                configMap.put("NG_MAIL_P_NAME", empNameP);
            }
        } catch (Exception e) {
            logger.warn("NG_MAIL 설정 로딩 실패 (기본값 사용)", e);
        }

        return configMap;
    }

    /**
     * 사원코드로 사원명 조회 (SYS_USER)
     * <p>
     * 발신자 설정 화면 오픈 시 EMP_CODE → EMP_NAME 변환용
     * </p>
     *
     * @param pltCode 공장코드
     * @param empCode 사원코드
     * @return 사원명 (없으면 빈문자열)
     */
    private String getEmpName(String pltCode, String empCode) {
        try {
            ParamsMap empParams = new ParamsMap();
            empParams.put("gsPltCode", pltCode);
            empParams.put("empCode", empCode);
            RecordMap result = (RecordMap) selectByMapper(NS, "GET_EMP_NAME", empParams);
            if (result != null && result.get("empName") != null) {
                return (String) result.get("empName");
            }
        } catch (Exception e) {
            logger.warn("사원명 조회 실패: empCode={}", empCode);
        }
        return "";
    }

    // ========================================================================
    // POP56A_SER: 수신자 목록 조회
    // 원본: POP56A.POP56A_SER() -> QUERY1
    // 전동(E) + 유압(P) 전체 목록 반환, JS에서 분배
    // ========================================================================

    /**
     * 수신자 목록 조회
     * <p>
     * DATA_FLAG=0인 활성 수신자 전체 조회.
     * JS에서 prodType 기준으로 Grid1(E)/Grid2(P)에 분배한다.
     * </p>
     *
     * @param params gsPltCode(공장코드)
     * @return 수신자 목록 (prodType: E/P)
     */
    public Object pop56aSer(ParamsMap params) {
        logger.debug("POP56A_SER: pltCode={}", params.get("gsPltCode"));
        return searchByMapper(NS, "QUERY1", params);
    }

    // ========================================================================
    // POP56A_INS: 수신자 등록
    // 원본: POP56A.POP56A_INS()
    // 1) SER(존재확인)
    // 2) 존재하면 UPD(재활성화), 없으면 INS(신규등록)
    // 3) QUERY1로 목록 재조회하여 반환
    // ========================================================================

    /**
     * 수신자 등록
     * <p>
     * 1. 존재 확인 (SER)
     * 2. 이미 존재하면 재활성화 (UPD: DATA_FLAG=0)
     * 3. 존재하지 않으면 신규 등록 (INS)
     * 4. 등록 후 해당 prodType 포함 전체 목록 반환 (JS에서 분배)
     * </p>
     *
     * @param params empCode(사원코드), prodType(제품유형 E/P)
     * @return 등록 결과 + 갱신된 목록
     */
    @Transactional
    public ResultMap pop56aIns(ParamsMap params) {
        try {
            String empCode = params.getString("empCode");
            String prodType = params.getString("prodType");

            if (empCode == null || empCode.trim().length() == 0) {
                return failure("사원코드를 입력하세요.");
            }
            if (prodType == null || prodType.trim().length() == 0) {
                return failure("제품유형이 지정되지 않았습니다.");
            }

            // 1) 존재 확인
            RecordMap existing = (RecordMap) selectByMapper(NS, "SER", params);

            if (existing != null && !existing.isEmpty()) {
                // 이미 존재 - DATA_FLAG 확인
                Object dataFlagObj = existing.get("dataFlag");
                String dataFlag = dataFlagObj != null ? String.valueOf(dataFlagObj) : "";

                if ("0".equals(dataFlag)) {
                    // 이미 활성 상태 - 중복 등록 불가
                    return failure("이미 등록된 사원입니다.");
                }

                // 2) 삭제된 사원 재활성화
                updateByMapper(NS, "UPD", params);
                logger.info("POP56A_INS 재활성화: empCode={}, prodType={}", empCode, prodType);
            } else {
                // 3) 신규 등록
                insertByMapper(NS, "INS", params);
                logger.info("POP56A_INS 신규등록: empCode={}, prodType={}", empCode, prodType);
            }

            // 4) 갱신된 목록 반환
            Object rows = searchByMapper(NS, "QUERY1", params);
            ResultMap result = success("등록되었습니다.");
            result.put("rows", rows);
            return result;
        } catch (Exception e) {
            logger.error("POP56A_INS 실패", e);
            return failure("등록 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP56A_DEL: 수신자 삭제
    // 원본: POP56A.POP56A_DEL()
    // 논리삭제 (DATA_FLAG=2)
    // ========================================================================

    /**
     * 수신자 삭제 (논리삭제)
     * <p>
     * DATA_FLAG=2로 설정하여 논리 삭제 처리.
     * </p>
     *
     * @param params empCode(사원코드), prodType(제품유형 E/P)
     * @return 삭제 결과
     */
    @Transactional
    public ResultMap pop56aDel(ParamsMap params) {
        try {
            String empCode = params.getString("empCode");
            String prodType = params.getString("prodType");

            if (empCode == null || empCode.trim().length() == 0) {
                return failure("삭제할 사원코드가 없습니다.");
            }

            // 논리삭제 (DATA_FLAG=2)
            updateByMapper(NS, "UDE", params);
            logger.info("POP56A_DEL: empCode={}, prodType={}", empCode, prodType);

            return success("삭제되었습니다.");
        } catch (Exception e) {
            logger.error("POP56A_DEL 실패", e);
            return failure("삭제 실패: " + e.getMessage());
        }
    }

    // ========================================================================
    // POP56A_SAVE_CONFIG: 발신자 설정 저장
    // 원본: acInfo.SysConfig.SetSysConfigByServer()
    // TSYS_CONF에 NG_MAIL_E, NG_MAIL_P 저장
    // ========================================================================

    /**
     * 발신자 설정 저장
     * <p>
     * TSYS_CONF에 NG_MAIL_E(전동 발신자), NG_MAIL_P(유압 발신자) 값을 UPSERT.
     * </p>
     *
     * @param params empE(전동 발신자), empP(유압 발신자)
     * @return 저장 결과
     */
    @Transactional
    public ResultMap pop56aSaveConfig(ParamsMap params) {
        try {
            String empE = params.getString("empE");
            String empP = params.getString("empP");

            // NG_MAIL_E 저장
            ParamsMap confParams = new ParamsMap();
            confParams.put("gsPltCode", params.get("gsPltCode"));
            confParams.put("gsUserId", params.get("gsUserId"));
            confParams.put("confSection", "SYS");

            // 전동(E) 발신자
            confParams.put("confName", "NG_MAIL_E");
            confParams.put("confValue", empE != null ? empE : "");
            insertByMapper(NS, "CONF_UPSERT", confParams);

            // 유압(P) 발신자
            confParams.put("confName", "NG_MAIL_P");
            confParams.put("confValue", empP != null ? empP : "");
            insertByMapper(NS, "CONF_UPSERT", confParams);

            logger.info("POP56A_SAVE_CONFIG: NG_MAIL_E={}, NG_MAIL_P={}", empE, empP);
            return success("발신자 설정이 저장되었습니다.");
        } catch (Exception e) {
            logger.error("POP56A_SAVE_CONFIG 실패", e);
            return failure("설정 저장 실패: " + e.getMessage());
        }
    }
}
