package com.lsbas.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.jws.WebService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.lsbas.service.IF_SFDC_DEALER_LSTA_041;
import com.lsbas.service.if_sfdc_dealer_lsta_041.request.IF_SFDC_DEALER_LSTA_041_data;
import com.lsbas.service.if_sfdc_dealer_lsta_041.request.IF_SFDC_DEALER_LSTA_041_request;
import com.lsbas.service.if_sfdc_dealer_lsta_041.response.IF_SFDC_DEALER_LSTA_041_response;
import com.wsc.common.app.AppService;
import com.wsc.framework.model.ParamsMap;

@WebService(endpointInterface = "com.lsbas.service.IF_SFDC_DEALER_LSTA_041")
public class IF_SFDC_DEALER_LSTA_041Impl implements IF_SFDC_DEALER_LSTA_041 {
	public static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	@Autowired 
	private AppService appService;
	
	private static final Logger logger = LoggerFactory.getLogger(IF_SFDC_DEALER_LSTA_041Impl.class);
	
	@Override
	public IF_SFDC_DEALER_LSTA_041_response getService(IF_SFDC_DEALER_LSTA_041_request request) {
		Date current = new Date(System.currentTimeMillis());
		logger.info("############# IF_SFDC_DEALER_LSTA_041 START ( {} ) #############", dateFormat.format(current));
		
		String sysId = "IMMES";
		String jobId = "SFDC041";
		String currDate = MtronUtil.getCurrentDate();
		long   workSeq  = 0;
		String jobFile  = "IF_SFDC_DEALER_LSTA_041";
	    String rsltMsg  = "";
		IF_SFDC_DEALER_LSTA_041_response response = new IF_SFDC_DEALER_LSTA_041_response();
		
		try {
			List<IF_SFDC_DEALER_LSTA_041_data> dataList = request.getLWS_WR_DATA();

			if(dataList != null) {
				for(IF_SFDC_DEALER_LSTA_041_data data : dataList) {
					try {
						ParamsMap params = new ParamsMap();
						
						// 컨텍스트 파라미터
						params.put("sysId", "IMMES");
						params.put("jobId", jobId);
						params.put("currDate", currDate);
						params.put("workSeq", workSeq);
						
						// 데이터 필드 매핑
						String repNo = MtronUtil.nullToEmpty(data.getREP_NO());
						String seriNo = MtronUtil.nullToEmpty(data.getSERI_NO());
						String dealCode = MtronUtil.nullToEmpty(data.getDEAL_CODE());
						String dealName = MtronUtil.nullToEmpty(data.getDEAL_NAME());
						String modlCode = MtronUtil.nullToEmpty(data.getMODL_CODE());
						String claType = MtronUtil.nullToEmpty(data.getCLA_TYPE());
						String claimTypeNm = MtronUtil.nullToEmpty(data.getCLAIM_TYPE_NM());
						String warrKind = MtronUtil.nullToEmpty(data.getWARR_KIND());
						String warrKindNm = MtronUtil.nullToEmpty(data.getWARR_KIND_NM());
						String modelSeries = MtronUtil.nullToEmpty(data.getMODEL_SERIES());
						String submDate = MtronUtil.nullToEmpty(data.getSUBM_DATE());
						String invcNo = MtronUtil.nullToEmpty(data.getINVC_NO());
						String invcDate = MtronUtil.nullToEmpty(data.getINVC_DATE());
						String waers = MtronUtil.nullToEmpty(data.getWAERS());
						String partAmt = MtronUtil.nullToEmpty(data.getPART_AMT());
						String laboAmt = MtronUtil.nullToEmpty(data.getLABO_AMT());
						String extrAmt = MtronUtil.nullToEmpty(data.getEXTR_AMT());
						String sumAmt = MtronUtil.nullToEmpty(data.getSUM_AMT());
	
						// 로그 출력
						logger.debug("##### repNo: {}", repNo);
						logger.debug("##### seriNo: {}", seriNo);
						logger.debug("##### dealCode: {}", dealCode);
						logger.debug("##### dealName: {}", dealName);
						logger.debug("##### modlCode: {}", modlCode);
						logger.debug("##### claType: {}", claType);
						logger.debug("##### claimTypeNm: {}", claimTypeNm);
						logger.debug("##### warrKind: {}", warrKind);
						logger.debug("##### warrKindNm: {}", warrKindNm);
						logger.debug("##### modelSeries: {}", modelSeries);
						logger.debug("##### submDate: {}", submDate);
						logger.debug("##### invcNo: {}", invcNo);
						logger.debug("##### invcDate: {}", invcDate);
						logger.debug("##### waers: {}", waers);
						logger.debug("##### partAmt: {}", partAmt);
						logger.debug("##### laboAmt: {}", laboAmt);
						logger.debug("##### extrAmt: {}", extrAmt);
						logger.debug("##### sumAmt: {}", sumAmt);
	
						// params에 저장
						params.put("REP_NO", repNo);
						params.put("SERI_NO", seriNo);
						params.put("DEAL_CODE", dealCode);
						params.put("DEAL_NAME", dealName);
						params.put("MODL_CODE", modlCode);
						params.put("CLA_TYPE", claType);
						params.put("CLAIM_TYPE_NM", claimTypeNm);
						params.put("WARR_KIND", warrKind);
						params.put("WARR_KIND_NM", warrKindNm);
						params.put("MODEL_SERIES", modelSeries);
						params.put("SUBM_DATE", submDate);
						params.put("INVC_NO", invcNo);
						params.put("INVC_DATE", invcDate);
						params.put("WAERS", waers);
						params.put("PART_AMT", partAmt);
						params.put("LABO_AMT", laboAmt);
						params.put("EXTR_AMT", extrAmt);
						params.put("SUM_AMT", sumAmt);
						
						// 프로시저 호출 (결과는 프로시저 내부에서 로그로 기록)
						appService.IF_SFDC_DEALER_LSTA_041_IFSTS_UPDATE(params);
						
					}  catch (Exception e) {
	                    // 개별 건 실패해도 로그만 남기고 계속 진행
	                    logger.error("Failed to process NO (IF_SFDC_DEALER_LSTA_041) : {}, Error: {}", data.getREP_NO(), e.getMessage());
	                    
	                    String errorMsg = "REP_NO : " + data.getREP_NO() + " - " + e.getMessage();
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
        logger.info("############# IF_SFDC_DEALER_LSTA_41 END ( {} ) #############", dateFormat.format(current));
        
		return response;
    }
	
}