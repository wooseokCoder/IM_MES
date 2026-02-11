package com.wsc.imes.std;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

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
import com.wsc.imes.common.UtilityService;

/**
 * STD23B 휴일관리 Service
 * @author 송우석
 */
@Service
public class Std23bService extends BaseService {

    private static final Logger logger = LoggerFactory.getLogger(Std23bService.class);

    private static final String NS_TSTD_MC_DAILYCAPA = "com.wsc.imes.std.TSTD_MC_DAILYCAPA";
    private static final String NS_TSTD_MC_DAILYCAPA_QUERY = "com.wsc.imes.std.TSTD_MC_DAILYCAPA_QUERY";
    private static final String NS_LSE_HOLIDAY = "com.wsc.imes.std.LSE_HOLIDAY";
    private static final String NS_LSE_HOLIDAY_QUERY = "com.wsc.imes.std.LSE_HOLIDAY_QUERY";
    private static final String NS_LSE_MACHINE = "com.wsc.imes.std.LSE_MACHINE";
    private static final String NS_LSE_MC_WORKTIME = "com.wsc.imes.std.LSE_MC_WORKTIME";

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
     * 휴일 목록 조회 (그리드+달력 공용)
     */
    public Object std23bSer(ParamsMap params) {
        return searchByMapper(NS_LSE_HOLIDAY_QUERY, "LSE_HOLIDAY_QUERY1", params);
    }

    // ========== 휴일 설정/해제 ==========

    /**
     * 휴일 설정 + 해당일 설비 CAPA=0
     */
    @Transactional
    public ResultMap std23bUpd2(ParamsMap params) {
        String pltCode = (String) params.get("gsPltCode");
        String holiDate = (String) params.get("holiDate");
        String holiName = (String) params.get("holiName");

        ParamsMap holiParams = new ParamsMap();
        holiParams.put("gsPltCode", pltCode);
        holiParams.put("holiDate", holiDate);
        holiParams.put("holiName", holiName);

        RecordMap exist = (RecordMap) selectByMapper(NS_LSE_HOLIDAY, "LSE_HOLIDAY_SER", holiParams);
        if (exist == null || exist.isEmpty()) {
            insertByMapper(NS_LSE_HOLIDAY, "LSE_HOLIDAY_INS", holiParams);
        }

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
     * 휴일 해제 + CAPA 복원
     */
    @Transactional
    public ResultMap std23bUpd3(ParamsMap params) {
        String pltCode = (String) params.get("gsPltCode");
        String holiDate = (String) params.get("holiDate");

        ParamsMap holiParams = new ParamsMap();
        holiParams.put("gsPltCode", pltCode);
        holiParams.put("holiDate", holiDate);
        deleteByMapper(NS_LSE_HOLIDAY, "LSE_HOLIDAY_DEL3", holiParams);

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

    // ========== 내부 헬퍼 ==========

    /**
     * 설비의 요일별 기본 CAPA 계산
     */
    private int getDefaultCapa(String pltCode, String mcCode, String week) {
        ParamsMap mcParams = new ParamsMap();
        mcParams.put("mcCode", mcCode);
        mcParams.put("gsPltCode", pltCode);

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

        ParamsMap wtParams = new ParamsMap();
        wtParams.put("mcCode", mcCode);
        wtParams.put("mcShift", mcShift);
        wtParams.put("gsPltCode", pltCode);

        RecordMap worktime = (RecordMap) selectByMapper(NS_LSE_MC_WORKTIME, "LSE_MC_WORKTIME_SER", wtParams);
        if (worktime == null || worktime.isEmpty()) {
            return 0;
        }

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

    private double toDouble(Object obj) {
        if (obj == null) return 0;
        try {
            return Double.parseDouble(obj.toString());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

}
