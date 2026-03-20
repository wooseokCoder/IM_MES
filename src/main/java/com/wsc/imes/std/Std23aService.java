package com.wsc.imes.std;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.inject.Provider;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
import com.wsc.imes.common.UtilityService;

/**
 * STD23A 휴일관리 Service
 * @author 송우석
 */
@Service
public class Std23aService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std23aService.class);

    // Namespace 상수
    private static final String NS_TSTD_MC_DAILYCAPA = "com.wsc.imes.std.TSTD_MC_DAILYCAPA";
    private static final String NS_TSTD_MC_DAILYCAPA_QUERY = "com.wsc.imes.std.TSTD_MC_DAILYCAPA_QUERY";
    private static final String NS_LSE_HOLIDAY = "com.wsc.imes.std.LSE_HOLIDAY";
    private static final String NS_LSE_HOLIDAY_QUERY = "com.wsc.imes.std.LSE_HOLIDAY_QUERY";
    private static final String NS_LSE_MACHINE = "com.wsc.imes.std.LSE_MACHINE";
    private static final String NS_LSE_MACHINE_QUERY = "com.wsc.imes.std.LSE_MACHINE_QUERY";
    private static final String NS_LSE_MC_WORKTIME = "com.wsc.imes.std.LSE_MC_WORKTIME";
    private static final String NS_LSE_MC_CAPAPLAN = "com.wsc.imes.std.LSE_MC_CAPAPLAN";

    @Autowired
    private CommonDao dao;

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private Provider<SessionComponent> sessionProvider;

    @Autowired
    private UtilityService utilityService;

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

    // ========== 조회 ==========

    /**
     * 날짜별 설비 CAPA 그리드 조회 (QUERY5)
     */
    public Object std23aSer(ParamsMap params) {
        return searchByMapper(NS_TSTD_MC_DAILYCAPA_QUERY, "TSTD_MC_DAILYCAPA_QUERY5", params);
    }

    /**
     * 휴일 목록 조회 (달력 표시용)
     */
    public Object std23aSer1(ParamsMap params) {
        return searchByMapper(NS_LSE_HOLIDAY_QUERY, "LSE_HOLIDAY_QUERY1", params);
    }

    /**
     * 설비 목록 조회 (D0B/D3B 팝업용)
     * DATA_FLAG=0, MC_MGT_FLAG=1 고정
     */
    public Object std23aSer5(ParamsMap params) {
        params.put("dataFlag", "0");
        params.put("mcMgtFlag", "1");
        return searchByMapper(NS_LSE_MACHINE_QUERY, "LSE_MACHINE_QUERY7", params);
    }

    // ========== 내부 헬퍼 ==========

    /**
     * 설비의 요일별 기본 CAPA 계산 (STD23A_SER4)
     * @param pltCode 공장코드
     * @param mcCode  설비코드
     * @param week    요일명 (Sunday, Monday, ... Saturday)
     * @return CAPA 값 (분 단위), 조회 불가 시 0
     */
    private int getDefaultCapa(String pltCode, String mcCode, String week) {
        ParamsMap mcParams = new ParamsMap();
        mcParams.put("mcCode", mcCode);
        mcParams.put("gsPltCode", pltCode);

        // 1. 설비 정보 조회 → MC_SHIFT
        RecordMap machine = (RecordMap) selectByMapper(NS_LSE_MACHINE, "LSE_MACHINE_SER", mcParams);
        if (machine == null || machine.isEmpty()) {
            return 0;
        }

        Object mcShiftObj = machine.get("mcShift");
        int mcShift = 0;
        if (mcShiftObj != null) {
            mcShift = Integer.parseInt(mcShiftObj.toString());
        }
        if (mcShift <= 0) {
            return 0;
        }

        // 2. 근무시간 조회
        ParamsMap wtParams = new ParamsMap();
        wtParams.put("mcCode", mcCode);
        wtParams.put("mcShift", mcShift);
        wtParams.put("gsPltCode", pltCode);

        RecordMap worktime = (RecordMap) selectByMapper(NS_LSE_MC_WORKTIME, "LSE_MC_WORKTIME_SER", wtParams);
        if (worktime == null || worktime.isEmpty()) {
            return 0;
        }

        // 3. 요일에 따라 시간 반환
        double time = 0;
        if ("Sunday".equals(week)) {
            time = toDouble(worktime.get("sunTime"));
        } else if ("Monday".equals(week)) {
            time = toDouble(worktime.get("monTime"));
        } else if ("Tuesday".equals(week)) {
            time = toDouble(worktime.get("tueTime"));
        } else if ("Wednesday".equals(week)) {
            time = toDouble(worktime.get("wedTime"));
        } else if ("Thursday".equals(week)) {
            time = toDouble(worktime.get("thrTime"));
        } else if ("Friday".equals(week)) {
            time = toDouble(worktime.get("friTime"));
        } else if ("Saturday".equals(week)) {
            time = toDouble(worktime.get("satTime"));
        }

        return (int) time;
    }

    /**
     * Object → double 변환 헬퍼
     */
    private double toDouble(Object obj) {
        if (obj == null) return 0;
        try {
            return Double.parseDouble(obj.toString());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    /**
     * yyyyMMdd 문자열 → 요일명 변환
     */
    private String getWeekName(String dateStr) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            Date date = sdf.parse(dateStr);
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
            switch (dayOfWeek) {
                case Calendar.SUNDAY:    return "Sunday";
                case Calendar.MONDAY:    return "Monday";
                case Calendar.TUESDAY:   return "Tuesday";
                case Calendar.WEDNESDAY: return "Wednesday";
                case Calendar.THURSDAY:  return "Thursday";
                case Calendar.FRIDAY:    return "Friday";
                case Calendar.SATURDAY:  return "Saturday";
                default: return "";
            }
        } catch (Exception e) {
            return "";
        }
    }

    /**
     * 요일명 → 체크 여부 확인 (D0B 요일 선택)
     */
    private boolean isDayChecked(ParamsMap params, String weekName) {
        String val = (String) params.get(weekName.toLowerCase());
        if (val == null) {
            val = (String) params.get(weekName);
        }
        return "1".equals(val);
    }

    // ========== 생성/수정/삭제 ==========

    /**
     * CAPA 일괄 생성 (D0B 팝업)
     * 기간/요일/설비 선택 → 날짜별 설비 CAPA 생성
     */
    @Transactional
    public ResultMap std23aInsCapa(ParamsMap params) {
        String pltCode = (String) params.get("gsPltCode");
        String frDate = (String) params.get("frDate");
        String toDate = (String) params.get("toDate");
        String checkZero = (String) params.get("checkZero");
        if (checkZero == null) checkZero = "0";

        // 선택된 설비 목록 (JSON 배열)
        JSONArray mcList = (JSONArray) params.get("modelList");
        if (mcList == null || mcList.size() == 0) {
            return failure("설비를 선택하세요.");
        }

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            Date startDate = sdf.parse(frDate);
            Date endDate = sdf.parse(toDate);

            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);

            int count = 0;

            // 날짜 루프
            while (!cal.getTime().after(endDate)) {
                String dateStr = sdf.format(cal.getTime());
                String weekName = getWeekName(dateStr);

                // 각 설비에 대해
                for (int i = 0; i < mcList.size(); i++) {
                    JSONObject mc = (JSONObject) mcList.get(i);
                    String mcCode = (String) mc.get("mcCode");

                    ParamsMap rowParams = new ParamsMap();
                    rowParams.put("gsPltCode", pltCode);
                    rowParams.put("mcCode", mcCode);
                    rowParams.put("workDate", dateStr);

                    if (isDayChecked(params, weekName)) {
                        // 해당 요일 선택됨 → CAPA 생성/업데이트
                        RecordMap exist = (RecordMap) selectByMapper(
                            NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_SER", rowParams);

                        int defaultCapa = getDefaultCapa(pltCode, mcCode, weekName);
                        rowParams.put("capa", defaultCapa);
                        rowParams.put("scomment", "");

                        if (exist != null && !exist.isEmpty()) {
                            if ("1".equals(checkZero)) {
                                // 삭제 후 재생성
                                deleteByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_DEL2", rowParams);
                                ParamsMap cpParams = new ParamsMap();
                                cpParams.put("gsPltCode", pltCode);
                                cpParams.put("mcCode", mcCode);
                                cpParams.put("mcDate", dateStr);
                                deleteByMapper(NS_LSE_MC_CAPAPLAN, "LSE_MC_CAPAPLAN_DEL3", cpParams);
                                insertByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_INS", rowParams);
                            } else {
                                // 기존 업데이트
                                updateByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_UPD", rowParams);
                            }
                        } else {
                            // 신규 등록
                            insertByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_INS", rowParams);
                        }
                        count++;
                    } else if ("1".equals(checkZero)) {
                        // 해당 요일 미선택 + CHECKZERO → CAPA=0으로 등록
                        RecordMap exist = (RecordMap) selectByMapper(
                            NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_SER", rowParams);
                        if (exist != null && !exist.isEmpty()) {
                            deleteByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_DEL2", rowParams);
                        }
                        insertByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_INS2", rowParams);
                    }
                }

                cal.add(Calendar.DATE, 1);
            }

            // 휴일 날짜의 CAPA를 0으로 일괄 갱신
            ParamsMap holiParams = new ParamsMap();
            holiParams.put("gsPltCode", pltCode);
            updateByMapper(NS_LSE_HOLIDAY, "LSE_HOLIDAY_UPD", holiParams);

            return success(count + "건의 CAPA가 생성되었습니다.");
        } catch (Exception e) {
            logger.error("STD23A_INS_CAPA 오류", e);
            return failure("CAPA 생성 중 오류가 발생했습니다.");
        }
    }

    /**
     * CAPA 기본값 복원 (선택된 행)
     */
    @Transactional
    public ResultMap std23aUpd1(ParamsMap params) {
        String pltCode = (String) params.get("gsPltCode");
        JSONArray rows = (JSONArray) params.get("modelList");
        if (rows == null || rows.size() == 0) {
            return failure("항목을 선택하세요.");
        }

        int count = 0;
        for (int i = 0; i < rows.size(); i++) {
            JSONObject row = (JSONObject) rows.get(i);
            String mcCode = (String) row.get("mcCode");
            String workDate = (String) row.get("workDate");
            String weekName = getWeekName(workDate);

            int defaultCapa = getDefaultCapa(pltCode, mcCode, weekName);

            ParamsMap rowParams = new ParamsMap();
            rowParams.put("gsPltCode", pltCode);
            rowParams.put("mcCode", mcCode);
            rowParams.put("workDate", workDate);
            rowParams.put("capa", defaultCapa);
            rowParams.put("scomment", "");

            updateByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_UPD", rowParams);

            // CAPA 계획 삭제
            ParamsMap cpParams = new ParamsMap();
            cpParams.put("gsPltCode", pltCode);
            cpParams.put("mcCode", mcCode);
            cpParams.put("mcDate", workDate);
            deleteByMapper(NS_LSE_MC_CAPAPLAN, "LSE_MC_CAPAPLAN_DEL3", cpParams);

            count++;
        }

        return success(count + "건의 CAPA가 기본값으로 복원되었습니다.");
    }

    /**
     * 휴일 설정 + CAPA=0 (STD23A_UPD2)
     */
    @Transactional
    public ResultMap std23aUpd2(ParamsMap params) {
        String pltCode = (String) params.get("gsPltCode");
        String holiDate = (String) params.get("holiDate");
        String holiName = (String) params.get("holiName");

        // 1. 휴일 존재 확인
        ParamsMap holiParams = new ParamsMap();
        holiParams.put("gsPltCode", pltCode);
        holiParams.put("holiDate", holiDate);
        holiParams.put("holiName", holiName);

        RecordMap exist = (RecordMap) selectByMapper(NS_LSE_HOLIDAY, "LSE_HOLIDAY_SER", holiParams);
        if (exist == null || exist.isEmpty()) {
            // 2. 휴일 미존재 → 신규 등록
            insertByMapper(NS_LSE_HOLIDAY, "LSE_HOLIDAY_INS", holiParams);
        }

        // 3. 해당 날짜의 모든 설비 CAPA를 0으로 업데이트
        ParamsMap queryParams = new ParamsMap();
        queryParams.put("gsPltCode", pltCode);
        queryParams.put("workDate", holiDate);

        @SuppressWarnings("unchecked")
        List<RecordMap> capaList = (List<RecordMap>) searchByMapper(
            NS_TSTD_MC_DAILYCAPA_QUERY, "TSTD_MC_DAILYCAPA_QUERY1", queryParams);

        if (capaList != null) {
            for (RecordMap capa : capaList) {
                ParamsMap updParams = new ParamsMap();
                updParams.put("gsPltCode", pltCode);
                updParams.put("mcCode", capa.get("mcCode"));
                updParams.put("workDate", holiDate);
                updParams.put("capa", 0);
                updParams.put("scomment", "");
                updateByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_UPD", updParams);
            }
        }

        return success("휴일이 설정되었습니다.");
    }

    /**
     * 휴일 해제 + CAPA 복원 (STD23A_UPD3)
     */
    @Transactional
    public ResultMap std23aUpd3(ParamsMap params) {
        String pltCode = (String) params.get("gsPltCode");
        String holiDate = (String) params.get("holiDate");

        // 1. 휴일 삭제
        ParamsMap holiParams = new ParamsMap();
        holiParams.put("gsPltCode", pltCode);
        holiParams.put("holiDate", holiDate);
        deleteByMapper(NS_LSE_HOLIDAY, "LSE_HOLIDAY_DEL3", holiParams);

        // 2. 해당 날짜의 모든 설비 CAPA 복원
        ParamsMap queryParams = new ParamsMap();
        queryParams.put("gsPltCode", pltCode);
        queryParams.put("workDate", holiDate);

        @SuppressWarnings("unchecked")
        List<RecordMap> capaList = (List<RecordMap>) searchByMapper(
            NS_TSTD_MC_DAILYCAPA_QUERY, "TSTD_MC_DAILYCAPA_QUERY1", queryParams);

        if (capaList != null) {
            String weekName = getWeekName(holiDate);
            for (RecordMap capa : capaList) {
                String mcCode = (String) capa.get("mcCode");
                int defaultCapa = getDefaultCapa(pltCode, mcCode, weekName);

                ParamsMap updParams = new ParamsMap();
                updParams.put("gsPltCode", pltCode);
                updParams.put("mcCode", mcCode);
                updParams.put("workDate", holiDate);
                updParams.put("capa", defaultCapa);
                updParams.put("scomment", "");
                updateByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_UPD", updParams);
            }
        }

        return success("휴일이 해제되었습니다.");
    }

    /**
     * 개별 CAPA 변경 (D2B 팝업, STD23B_UPD4)
     */
    @Transactional
    public ResultMap std23bUpd4(ParamsMap params) {
        updateByMapper(NS_TSTD_MC_DAILYCAPA, "TSTD_MC_DAILYCAPA_UPD", params);
        return success("저장되었습니다.");
    }

}
