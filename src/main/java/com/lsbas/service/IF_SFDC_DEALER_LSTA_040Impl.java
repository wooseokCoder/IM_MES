package com.lsbas.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.jws.WebService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lsbas.service.IF_SFDC_DEALER_LSTA_040;
import com.lsbas.service.if_sfdc_dealer_lsta_040.request.IF_SFDC_DEALER_LSTA_040_data;
import com.lsbas.service.if_sfdc_dealer_lsta_040.request.IF_SFDC_DEALER_LSTA_040_request;
import com.lsbas.service.if_sfdc_dealer_lsta_040.response.IF_SFDC_DEALER_LSTA_040_response;
import com.wsc.common.app.AppService;
import com.wsc.framework.model.ParamsMap;

@WebService(endpointInterface = "com.lsbas.service.IF_SFDC_DEALER_LSTA_040")
public class IF_SFDC_DEALER_LSTA_040Impl implements IF_SFDC_DEALER_LSTA_040 {
	public static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	@Autowired 
	private AppService appService;
	
	private static final Logger logger = LoggerFactory.getLogger(IF_SFDC_DEALER_LSTA_040Impl.class);
	
	@Override
	public IF_SFDC_DEALER_LSTA_040_response getService(IF_SFDC_DEALER_LSTA_040_request request) {
		Date current = new Date(System.currentTimeMillis());
		logger.info("############# IF_SFDC_DEALER_LSTA_040 START ( {} ) #############", dateFormat.format(current));
		
		String sysId = "IMMES";
		String jobId = "SFDC040";
		String currDate = MtronUtil.getCurrentDate();
		long   workSeq  = 0;
		String jobFile  = "IF_SFDC_DEALER_LSTA_040";
	    String rsltMsg  = "";
		IF_SFDC_DEALER_LSTA_040_response response = new IF_SFDC_DEALER_LSTA_040_response();
				
		try {
			List<IF_SFDC_DEALER_LSTA_040_data> dataList = request.getLWS_SR_DATA();

            if(dataList != null) {
                for(IF_SFDC_DEALER_LSTA_040_data data : dataList) {
                	try {
						ParamsMap params = new ParamsMap();
						
						// 컨텍스트 파라미터
						params.put("sysId", "IMMES");
						params.put("jobId", jobId); // Job ID 변경
						params.put("currDate", currDate);
						params.put("workSeq", workSeq);
						
						// 데이터 필드 매핑
						String srDist = MtronUtil.nullToEmpty(data.getSR_DIST());
						String srCnty = MtronUtil.nullToEmpty(data.getSR_CNTY());
						String srStat = MtronUtil.nullToEmpty(data.getSR_STAT());
						String dealCode = MtronUtil.nullToEmpty(data.getDEAL_CODE());
						String dealName = MtronUtil.nullToEmpty(data.getDEAL_NAME());
						String storLoc = MtronUtil.nullToEmpty(data.getSTOR_LOC());
						String bmCode = MtronUtil.nullToEmpty(data.getBM_CODE());
						String bmName = MtronUtil.nullToEmpty(data.getBM_NAME());
						String smName = MtronUtil.nullToEmpty(data.getSM_NAME());
						String comiRecv = MtronUtil.nullToEmpty(data.getCOMI_RECV());
						String comiRecvDetl = MtronUtil.nullToEmpty(data.getCOMI_RECV_DETL());
						String comiRecvCode = MtronUtil.nullToEmpty(data.getCOMI_RECV_CODE());
						String seriNo = MtronUtil.nullToEmpty(data.getSERI_NO());
						String engnNo = MtronUtil.nullToEmpty(data.getENGN_NO());
						String unitType = MtronUtil.nullToEmpty(data.getUNIT_TYPE());
						String modlCode = MtronUtil.nullToEmpty(data.getMODL_CODE());
						String modlSers = MtronUtil.nullToEmpty(data.getMODL_SERS());
						String seriDesc = MtronUtil.nullToEmpty(data.getSERI_DESC());
						String invoNo = MtronUtil.nullToEmpty(data.getINVO_NO());
						String invoDate = MtronUtil.nullToEmpty(data.getINVO_DATE());
						String shipDate = MtronUtil.nullToEmpty(data.getSHIP_DATE());
						String prodDate = MtronUtil.nullToEmpty(data.getPROD_DATE());
						String retlDate = MtronUtil.nullToEmpty(data.getRETL_DATE());
						String userType = MtronUtil.nullToEmpty(data.getUSER_TYPE());
						String fistName = MtronUtil.nullToEmpty(data.getFIST_NAME());
						String lastName = MtronUtil.nullToEmpty(data.getLAST_NAME());
						String userMail = MtronUtil.nullToEmpty(data.getUSER_MAIL());
						String userTel = MtronUtil.nullToEmpty(data.getUSER_TEL());
						String userHp = MtronUtil.nullToEmpty(data.getUSER_HP());
						String cntyFist = MtronUtil.nullToEmpty(data.getCNTY_FIST());
						String statFist = MtronUtil.nullToEmpty(data.getSTAT_FIST());
						String contFist = MtronUtil.nullToEmpty(data.getCONT_FIST());
						String physAddr = MtronUtil.nullToEmpty(data.getPHYS_ADDR());
						String physStat = MtronUtil.nullToEmpty(data.getPHYS_STAT());
						String physCity = MtronUtil.nullToEmpty(data.getPHYS_CITY());
						String physZip = MtronUtil.nullToEmpty(data.getPHYS_ZIP());
						String mailAddr = MtronUtil.nullToEmpty(data.getMAIL_ADDR());
						String mailStat = MtronUtil.nullToEmpty(data.getMAIL_STAT());
						String mailCity = MtronUtil.nullToEmpty(data.getMAIL_CITY());
						String mailZip = MtronUtil.nullToEmpty(data.getMAIL_ZIP());
						String workAppl = MtronUtil.nullToEmpty(data.getWORK_APPL());
						String crops = MtronUtil.nullToEmpty(data.getCROPS());
						String planUsag = MtronUtil.nullToEmpty(data.getPLAN_USAG());
						String loadCode = MtronUtil.nullToEmpty(data.getLOAD_CODE());
						String loadModl = MtronUtil.nullToEmpty(data.getLOAD_MODL());
						String loadDate = MtronUtil.nullToEmpty(data.getLOAD_DATE());
						String bhoeCode = MtronUtil.nullToEmpty(data.getBHOE_CODE());
						String bhoeModl = MtronUtil.nullToEmpty(data.getBHOE_MODL());
						String bhoeDate = MtronUtil.nullToEmpty(data.getBHOE_DATE());
						String mowrCode = MtronUtil.nullToEmpty(data.getMOWR_CODE());
						String mowrModl = MtronUtil.nullToEmpty(data.getMOWR_MODL());
						String mowrDate = MtronUtil.nullToEmpty(data.getMOWR_DATE());
						String snowCode = MtronUtil.nullToEmpty(data.getSNOW_CODE());
						String snowModl = MtronUtil.nullToEmpty(data.getSNOW_MODL());
						String snowDate = MtronUtil.nullToEmpty(data.getSNOW_DATE());
						String etcCode = MtronUtil.nullToEmpty(data.getETC_CODE());
						String etcModl = MtronUtil.nullToEmpty(data.getETC_MODL());
						String etcDate = MtronUtil.nullToEmpty(data.getETC_DATE());
						String expiDateBt = MtronUtil.nullToEmpty(data.getEXPI_DATE_BT());
						String expiDateBz = MtronUtil.nullToEmpty(data.getEXPI_DATE_BZ());
						String expiDateEm = MtronUtil.nullToEmpty(data.getEXPI_DATE_EM());
						String unitComt = MtronUtil.nullToEmpty(data.getUNIT_COMT());
						String comiAmot = MtronUtil.nullToEmpty(data.getCOMI_AMOT());
						String comiType = MtronUtil.nullToEmpty(data.getCOMI_TYPE());
						String comiDate = MtronUtil.nullToEmpty(data.getCOMI_DATE());
						String upeqNo = MtronUtil.nullToEmpty(data.getUPEQ_NO());
						String fincRebt = MtronUtil.nullToEmpty(data.getFINC_REBT());
						String cashForm = MtronUtil.nullToEmpty(data.getCASH_FORM());
						String evetCopn = MtronUtil.nullToEmpty(data.getEVET_COPN());
	
						// 로그 출력
						logger.debug("##### srDist: {}", srDist);
						logger.debug("##### srCnty: {}", srCnty);
						logger.debug("##### srStat: {}", srStat);
						logger.debug("##### dealCode: {}", dealCode);
						logger.debug("##### dealName: {}", dealName);
						logger.debug("##### storLoc: {}", storLoc);
						logger.debug("##### bmCode: {}", bmCode);
						logger.debug("##### bmName: {}", bmName);
						logger.debug("##### smName: {}", smName);
						logger.debug("##### comiRecv: {}", comiRecv);
						logger.debug("##### comiRecvDetl: {}", comiRecvDetl);
						logger.debug("##### comiRecvCode: {}", comiRecvCode);
						logger.debug("##### seriNo: {}", seriNo);
						logger.debug("##### engnNo: {}", engnNo);
						logger.debug("##### unitType: {}", unitType);
						logger.debug("##### modlCode: {}", modlCode);
						logger.debug("##### modlSers: {}", modlSers);
						logger.debug("##### seriDesc: {}", seriDesc);
						logger.debug("##### invoNo: {}", invoNo);
						logger.debug("##### invoDate: {}", invoDate);
						logger.debug("##### shipDate: {}", shipDate);
						logger.debug("##### prodDate: {}", prodDate);
						logger.debug("##### retlDate: {}", retlDate);
						logger.debug("##### userType: {}", userType);
						logger.debug("##### fistName: {}", fistName);
						logger.debug("##### lastName: {}", lastName);
						logger.debug("##### userMail: {}", userMail);
						logger.debug("##### userTel: {}", userTel);
						logger.debug("##### userHp: {}", userHp);
						logger.debug("##### cntyFist: {}", cntyFist);
						logger.debug("##### statFist: {}", statFist);
						logger.debug("##### contFist: {}", contFist);
						logger.debug("##### physAddr: {}", physAddr);
						logger.debug("##### physStat: {}", physStat);
						logger.debug("##### physCity: {}", physCity);
						logger.debug("##### physZip: {}", physZip);
						logger.debug("##### mailAddr: {}", mailAddr);
						logger.debug("##### mailStat: {}", mailStat);
						logger.debug("##### mailCity: {}", mailCity);
						logger.debug("##### mailZip: {}", mailZip);
						logger.debug("##### workAppl: {}", workAppl);
						logger.debug("##### crops: {}", crops);
						logger.debug("##### planUsag: {}", planUsag);
						logger.debug("##### loadCode: {}", loadCode);
						logger.debug("##### loadModl: {}", loadModl);
						logger.debug("##### loadDate: {}", loadDate);
						logger.debug("##### bhoeCode: {}", bhoeCode);
						logger.debug("##### bhoeModl: {}", bhoeModl);
						logger.debug("##### bhoeDate: {}", bhoeDate);
						logger.debug("##### mowrCode: {}", mowrCode);
						logger.debug("##### mowrModl: {}", mowrModl);
						logger.debug("##### mowrDate: {}", mowrDate);
						logger.debug("##### snowCode: {}", snowCode);
						logger.debug("##### snowModl: {}", snowModl);
						logger.debug("##### snowDate: {}", snowDate);
						logger.debug("##### etcCode: {}", etcCode);
						logger.debug("##### etcModl: {}", etcModl);
						logger.debug("##### etcDate: {}", etcDate);
						logger.debug("##### expiDateBt: {}", expiDateBt);
						logger.debug("##### expiDateBz: {}", expiDateBz);
						logger.debug("##### expiDateEm: {}", expiDateEm);
						logger.debug("##### unitComt: {}", unitComt);
						logger.debug("##### comiAmot: {}", comiAmot);
						logger.debug("##### comiType: {}", comiType);
						logger.debug("##### comiDate: {}", comiDate);
						logger.debug("##### upeqNo: {}", upeqNo);
						logger.debug("##### fincRebt: {}", fincRebt);
						logger.debug("##### cashForm: {}", cashForm);
						logger.debug("##### evetCopn: {}", evetCopn);
	
						// params에 저장
						params.put("SR_DIST", srDist);
						params.put("SR_CNTY", srCnty);
						params.put("SR_STAT", srStat);
						params.put("DEAL_CODE", dealCode);
						params.put("DEAL_NAME", dealName);
						params.put("STOR_LOC", storLoc);
						params.put("BM_CODE", bmCode);
						params.put("BM_NAME", bmName);
						params.put("SM_NAME", smName);
						params.put("COMI_RECV", comiRecv);
						params.put("COMI_RECV_DETL", comiRecvDetl);
						params.put("COMI_RECV_CODE", comiRecvCode);
						params.put("SERI_NO", seriNo);
						params.put("ENGN_NO", engnNo);
						params.put("UNIT_TYPE", unitType);
						params.put("MODL_CODE", modlCode);
						params.put("MODL_SERS", modlSers);
						params.put("SERI_DESC", seriDesc);
						params.put("INVO_NO", invoNo);
						params.put("INVO_DATE", invoDate);
						params.put("SHIP_DATE", shipDate);
						params.put("PROD_DATE", prodDate);
						params.put("RETL_DATE", retlDate);
						params.put("USER_TYPE", userType);
						params.put("FIST_NAME", fistName);
						params.put("LAST_NAME", lastName);
						params.put("USER_MAIL", userMail);
						params.put("USER_TEL", userTel);
						params.put("USER_HP", userHp);
						params.put("CNTY_FIST", cntyFist);
						params.put("STAT_FIST", statFist);
						params.put("CONT_FIST", contFist);
						params.put("PHYS_ADDR", physAddr);
						params.put("PHYS_STAT", physStat);
						params.put("PHYS_CITY", physCity);
						params.put("PHYS_ZIP", physZip);
						params.put("MAIL_ADDR", mailAddr);
						params.put("MAIL_STAT", mailStat);
						params.put("MAIL_CITY", mailCity);
						params.put("MAIL_ZIP", mailZip);
						params.put("WORK_APPL", workAppl);
						params.put("CROPS", crops);
						params.put("PLAN_USAG", planUsag);
						params.put("LOAD_CODE", loadCode);
						params.put("LOAD_MODL", loadModl);
						params.put("LOAD_DATE", loadDate);
						params.put("BHOE_CODE", bhoeCode);
						params.put("BHOE_MODL", bhoeModl);
						params.put("BHOE_DATE", bhoeDate);
						params.put("MOWR_CODE", mowrCode);
						params.put("MOWR_MODL", mowrModl);
						params.put("MOWR_DATE", mowrDate);
						params.put("SNOW_CODE", snowCode);
						params.put("SNOW_MODL", snowModl);
						params.put("SNOW_DATE", snowDate);
						params.put("ETC_CODE", etcCode);
						params.put("ETC_MODL", etcModl);
						params.put("ETC_DATE", etcDate);
						params.put("EXPI_DATE_BT", expiDateBt);
						params.put("EXPI_DATE_BZ", expiDateBz);
						params.put("EXPI_DATE_EM", expiDateEm);
						params.put("UNIT_COMT", unitComt);
						params.put("COMI_AMOT", comiAmot);
						params.put("COMI_TYPE", comiType);
						params.put("COMI_DATE", comiDate);
						params.put("UPEQ_NO", upeqNo);
						params.put("FINC_REBT", fincRebt);
						params.put("CASH_FORM", cashForm);
						params.put("EVET_COPN", evetCopn);
						
						// 프로시저 호출 (결과는 프로시저 내부에서 로그로 기록)
						appService.IF_SFDC_DEALER_LSTA_040_IFSTS_UPDATE(params); // 메서드명 변경
						
                	}  catch (Exception e) {
	                    // 개별 건 실패해도 로그만 남기고 계속 진행
	                    logger.error("Failed to process NO (IF_SFDC_DEALER_LSTA_040) : {}, Error: {}", data.getSERI_NO(), e.getMessage());
	                    
	                    String errorMsg = "SERI_NO : " + data.getSERI_NO() + " - " + e.getMessage();
	                    rsltMsg = (errorMsg != null && errorMsg.length() > 400) 
	                              ? errorMsg.substring(0, 400) 
	                              : (errorMsg != null ? errorMsg : "Unknown error");
	                    
	                    ParamsMap params2 = new ParamsMap();
	                    params2.put("sysId"	       , sysId);  // 적절한 sysId 값을 넣어야 합니다.
		                params2.put("jobId"        , jobId); 
		                params2.put("currDate"     , currDate); 
		                params2.put("workSeq"      , workSeq);
		                params2.put("jobFile"      , jobFile);
		                params2.put("rsltMsg"      , rsltMsg);
	                    
	                    appService.IF_SFDC_DEALER_LSTA_ERR_LOG_UPDATE(params2);
	                }
	            	
	            	workSeq++;
                }
            }
			
			response.setO_RESULT("S");
			response.setO_MESSAGE("SUCCESS");
			
		} catch (Exception e) {
			response.setO_RESULT("E");
			response.setO_MESSAGE("ERROR: " + e.getMessage());
		}
		
		current = new Date(System.currentTimeMillis() );
        logger.info("############# IF_SFDC_DEALER_LSTA_040 END ( {} ) #############", dateFormat.format(current));
            
		return response;
    }
	
}