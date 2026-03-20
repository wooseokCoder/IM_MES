/*
 * ============================================================================
 * 화면명: ORD32A - NG 조립 파일 모델/공정 매핑 관리
 * ============================================================================
 * 설명: TSYS_FILELIST_MASTER 파일 목록 조회 후,
 *       선택 파일에 모델/공정 매핑을 Delete-Insert 패턴으로 저장.
 *
 * 서비스 흐름:
 *   SER  → 파일목록 조회 (Grid1)
 *   SER2 → 선택 파일의 적용 모델/공정 (Grid2, Grid3)
 *   SER3 → 전체 모델/공정 마스터 (D0A 팝업)
 *   INS  → 기존 매핑 삭제 → 선택된 모델/공정 개별 INSERT → 재조회
 *
 * 원본: ProActive ORD32A.cs (BR)
 * @author Claude
 * @since 2026-03-10
 * ============================================================================
 */
package com.wsc.imes.ord;

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
import com.wsc.framework.model.ResultMap;

/**
 * NG 조립 파일 모델/공정 매핑 관리 서비스
 */
@Service
public class Ord32aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Ord32aService.class);

    // ========================================================================
    // Namespace 상수
    // ========================================================================

    /** TSTD_NG_FILE_MODEL 매퍼 (SER, SER2_MODEL, SER3_MODEL, DEL, INS) */
    private static final String NS_MODEL = "com.wsc.imes.ord.TSTD_NG_FILE_MODEL";

    /** TSTD_NG_FILE_PROC 매퍼 (SER2_PROC, SER3_PROC, DEL, INS) */
    private static final String NS_PROC = "com.wsc.imes.ord.TSTD_NG_FILE_PROC";

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
    // ORD32A_SER: 파일목록 조회
    // TSYS_FILELIST_MASTER (LINK_KEY='NG_ASSY_FILE', IS_UPLOAD=1, DATA_FLAG=0)
    // ========================================================================

    public Object ord32aSer(ParamsMap params) {
        logger.debug("ORD32A_SER: pltCode={}", params.get("gsPltCode"));
        return searchByMapper(NS_MODEL, "SER", params);
    }

    // ========================================================================
    // ORD32A_SER2: 선택 파일의 적용 모델 + 공정 조회
    // 반환: { models: [...], procs: [...] }
    // ========================================================================

    public Map<String, Object> ord32aSer2(ParamsMap params) {
        logger.debug("ORD32A_SER2: fileId={}", params.get("fileId"));

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("models", dao.search(NS_MODEL + ".SER2_MODEL", params));
        result.put("procs", dao.search(NS_PROC + ".SER2_PROC", params));
        return result;
    }

    // ========================================================================
    // ORD32A_SER3: 전체 모델 + 전체 공정 마스터 조회 (D0A 팝업용)
    // 반환: { models: [...], procs: [...] }
    // ========================================================================

    public Map<String, Object> ord32aSer3(ParamsMap params) {
        logger.debug("ORD32A_SER3: pltCode={}", params.get("gsPltCode"));

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("models", dao.search(NS_MODEL + ".SER3_MODEL", params));
        result.put("procs", dao.search(NS_PROC + ".SER3_PROC", params));
        return result;
    }

    // ========================================================================
    // ORD32A_INS: 모델/공정 매핑 저장 (Delete-Insert 트랜잭션)
    // AS-IS 흐름:
    //   1. TSTD_NG_FILE_MODEL 전체 삭제 (FILE_ID 단위)
    //   2. TSTD_NG_FILE_PROC 전체 삭제 (FILE_ID 단위)
    //   3. 선택된 모델 행별 INSERT (loop)
    //   4. 선택된 공정 행별 INSERT (loop)
    // ========================================================================

    @SuppressWarnings("unchecked")
    @Transactional
    public ResultMap ord32aIns(ParamsMap params) {
        try {
            String fileId = params.getString("fileId");
            if (fileId == null || fileId.isEmpty()) {
                return failure("파일ID가 없습니다.");
            }

            // 삭제용 파라미터
            ParamsMap delParams = new ParamsMap();
            delParams.put("gsPltCode", params.get("gsPltCode"));
            delParams.put("fileId", fileId);

            // 1. 기존 모델 매핑 전체 삭제
            dao.delete(NS_MODEL + ".DEL", delParams);
            logger.debug("ORD32A_INS: 모델 매핑 삭제 완료 (fileId={})", fileId);

            // 2. 기존 공정 매핑 전체 삭제
            dao.delete(NS_PROC + ".DEL", delParams);
            logger.debug("ORD32A_INS: 공정 매핑 삭제 완료 (fileId={})", fileId);

            // 3. 선택된 모델 행별 INSERT
            List<Map<String, Object>> models = (List<Map<String, Object>>) params.get("models");
            if (models != null) {
                for (int i = 0; i < models.size(); i++) {
                    Map<String, Object> row = models.get(i);
                    ParamsMap insParams = new ParamsMap();
                    insParams.put("gsPltCode", params.get("gsPltCode"));
                    insParams.put("fileId", fileId);
                    insParams.put("model", row.get("model"));
                    insParams.put("gsUserId", params.get("gsUserId"));
                    dao.insert(NS_MODEL + ".INS", insParams);
                }
                logger.debug("ORD32A_INS: 모델 {} 건 등록", Integer.valueOf(models.size()));
            }

            // 4. 선택된 공정 행별 INSERT
            List<Map<String, Object>> procs = (List<Map<String, Object>>) params.get("procs");
            if (procs != null) {
                for (int i = 0; i < procs.size(); i++) {
                    Map<String, Object> row = procs.get(i);
                    ParamsMap insParams = new ParamsMap();
                    insParams.put("gsPltCode", params.get("gsPltCode"));
                    insParams.put("fileId", fileId);
                    insParams.put("procCode", row.get("procCode"));
                    insParams.put("gsUserId", params.get("gsUserId"));
                    dao.insert(NS_PROC + ".INS", insParams);
                }
                logger.debug("ORD32A_INS: 공정 {} 건 등록", Integer.valueOf(procs.size()));
            }

            logger.info("ORD32A_INS 완료: fileId={}", fileId);
            return success("저장되었습니다.");
        } catch (Exception e) {
            logger.error("ORD32A_INS 실패", e);
            return failure("저장 실패: " + e.getMessage());
        }
    }

}
