package com.wsc.imes.qct;

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
 * QCT06A 자주검사 연계 관리 Service
 * @author 송우석
 */
@Service
public class Qct06aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Qct06aService.class);

    private static final String NS_PARTINS       = "com.wsc.imes.qct.LSE_STD_PARTINS";
    private static final String NS_PARTINS_QUERY = "com.wsc.imes.qct.LSE_STD_PARTINS_QUERY";

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
        return this.sessionProvider.get();
    }

    /** 부품 목록 조회 (ASSY 탭) */
    public Object qct06aSer(ParamsMap params) {
        return searchByMapper(NS_PARTINS_QUERY, "LSE_STD_PARTINS_QUERY1", params);
    }

    /** 검사그룹의 검사항목 조회 */
    public Object qct06aSer2(ParamsMap params) {
        return searchByMapper(NS_PARTINS_QUERY, "LSE_STD_PARTINS_QUERY5", params);
    }

    /** D0A 검사그룹 목록 조회 */
    public Object qct06aSer3(ParamsMap params) {
        return searchByMapper(NS_PARTINS_QUERY, "LSE_STD_PARTINS_QUERY4", params);
    }

    /** 부품의 연계 검사그룹 조회 */
    public Object qct06aSer5(ParamsMap params) {
        return searchByMapper(NS_PARTINS_QUERY, "LSE_STD_PARTINS_QUERY2", params);
    }

    /** LIST 탭 전체 연계 현황 조회 */
    public Object qct06aSer6(ParamsMap params) {
        return searchByMapper(NS_PARTINS_QUERY, "LSE_STD_PARTINS_QUERY3", params);
    }

    /**
     * 연계 등록 (D0A에서 호출)
     * 선택된 검사그룹을 부품에 연계한다.
     * 이미 연계된 그룹은 건너뛴다 (중복 방지).
     */
    @Transactional
    @SuppressWarnings("unchecked")
    public ResultMap qct06aIns(ParamsMap params) {
        List<Map<String, Object>> modelList = (List<Map<String, Object>>) params.get("modelList");
        if (modelList == null || modelList.isEmpty()) {
            return success("처리할 데이터가 없습니다.");
        }

        String partCode = (String) modelList.get(0).get("partCode");

        ParamsMap seqParam = new ParamsMap();
        seqParam.put("gsPltCode", params.get("gsPltCode"));
        seqParam.put("partCode", partCode);

        Map<String, Object> seqRow = (Map<String, Object>) selectByMapper(NS_PARTINS, "LSE_STD_PARTINS_SER3", seqParam);
        int maxSeq = 0;
        if (seqRow != null && seqRow.get("insGrpMax") != null) {
            maxSeq = Integer.parseInt(seqRow.get("insGrpMax").toString());
        }

        for (int i = 0; i < modelList.size(); i++) {
            Map<String, Object> row = modelList.get(i);
            row.put("gsPltCode", params.get("gsPltCode"));
            row.put("gsUserId", params.get("gsUserId"));

            ParamsMap checkParam = new ParamsMap();
            checkParam.put("gsPltCode", params.get("gsPltCode"));
            checkParam.put("partCode", row.get("partCode"));
            checkParam.put("insGrpCode", row.get("insGrpCode"));

            Map<String, Object> existing = (Map<String, Object>) selectByMapper(NS_PARTINS, "LSE_STD_PARTINS_SER", checkParam);
            if (existing == null || existing.isEmpty()) {
                maxSeq++;
                row.put("insGrpSeq", maxSeq);
                insertByMapper(NS_PARTINS, "LSE_STD_PARTINS_INS", row);
            }
        }

        return success("저장되었습니다.");
    }

    /** 순번 수정 */
    @Transactional
    @SuppressWarnings("unchecked")
    public ResultMap qct06aUpd(ParamsMap params) {
        List<Map<String, Object>> modelList = (List<Map<String, Object>>) params.get("modelList");
        if (modelList != null) {
            for (int i = 0; i < modelList.size(); i++) {
                Map<String, Object> row = modelList.get(i);
                row.put("gsPltCode", params.get("gsPltCode"));
                updateByMapper(NS_PARTINS, "LSE_STD_PARTINS_UPD", row);
            }
        }

        return success("저장되었습니다.");
    }

    /** 연계 삭제 */
    @Transactional
    public ResultMap qct06aDel(ParamsMap params) {
        deleteByMapper(NS_PARTINS, "LSE_STD_PARTINS_DEL", params);
        return success("삭제되었습니다.");
    }
}
