package com.lsbas.service;

import javax.jws.WebService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.app.AppService;
import com.wsc.framework.model.ParamsMap;
import com.lsbas.service.if_sfdc_dealer_lsta_044.request.IF_SFDC_DEALER_LSTA_044_data;
import com.lsbas.service.if_sfdc_dealer_lsta_044.request.IF_SFDC_DEALER_LSTA_044_request;
import com.lsbas.service.if_sfdc_dealer_lsta_044.response.IF_SFDC_DEALER_LSTA_044_response;

import java.util.Date;
import java.util.List;
import java.text.*;

@WebService(endpointInterface = "com.lsbas.service.IF_SFDC_DEALER_LSTA_044")
public class IF_SFDC_DEALER_LSTA_044Impl implements IF_SFDC_DEALER_LSTA_044 {
	public static SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
	
	@Autowired 
	private AppService appService;
	
	private static final Logger logger = LoggerFactory.getLogger(IF_SFDC_DEALER_LSTA_044Impl.class);
	
	@Override
	public IF_SFDC_DEALER_LSTA_044_response getService(IF_SFDC_DEALER_LSTA_044_request request) {
		Date current = new Date(System.currentTimeMillis());
		logger.info("############# IF_SFDC_DEALER_LSTA_044 START ( {} ) #############", dateFormat.format(current));
		
		String sysId = "IMMES";
		String jobId = "SFDC044";
	    String currDate  = MtronUtil.getCurrentDate();
	    long   workSeq   = 0;
	    String jobFile  = "IF_SFDC_DEALER_LSTA_044";
	    String rsltMsg  = "";
        IF_SFDC_DEALER_LSTA_044_response returnMap = new IF_SFDC_DEALER_LSTA_044_response();
        
        try {
	    	List<IF_SFDC_DEALER_LSTA_044_data> dataList = request.getEVAL_LIST();      // 딜러평가 정보 데이터
	    	
	        if(dataList != null) {
	            for(IF_SFDC_DEALER_LSTA_044_data data : dataList) {
	                try {
		                // required keys
		                if (data.getDEAL_ID() == null || data.getDEAL_ID().trim().isEmpty()) {
		                	throw new IllegalArgumentException("Required key missing: DEAL_ID is mandatory");
		                }
		                
		                ParamsMap params = new ParamsMap();
		                params.put("sysId"	       , "IMMES");  // 적절한 sysId 값을 넣어야 합니다.
		                params.put("jobId"         , jobId); 
		                params.put("currDate"      , currDate); 
		                params.put("workSeq"       , workSeq); 
		                
		                // data 변수 선언
		                String dealId   = data.getDEAL_ID();
		                String dealName = MtronUtil.nullToEmpty(data.getDEAL_NAME());
		                String evalDate = MtronUtil.nullToEmpty(data.getEVAL_DATE());
		                String evalStaf = MtronUtil.nullToEmpty(data.getEVAL_STAF());
		                String evalScor = MtronUtil.nullToEmpty(data.getEVAL_SCOR());
		                String evalLink = MtronUtil.nullToEmpty(data.getEVAL_LINK());
	
		                // 로그 출력
		                logger.debug("##### dealId:   {}", dealId);
		                logger.debug("##### dealName: {}", dealName);
		                logger.debug("##### evalDate: {}", evalDate);
		                logger.debug("##### evalStaf: {}", evalStaf);
		                logger.debug("##### evalScor: {}", evalScor);
		                logger.debug("##### evalLink: {}", evalLink);
	
		                // params에 저장
		                params.put("DEAL_ID",   dealId);      // 딜러 임시ID
		                params.put("DEAL_NAME", dealName);    // 딜러명
		                params.put("EVAL_DATE", evalDate);    // 평가일자
		                params.put("EVAL_STAF", evalStaf);    // 평가자(SM Name)
		                params.put("EVAL_SCOR", evalScor);    // 평가점수
		                params.put("EVAL_LINK", evalLink);    // 평가서 링크URL
		                
		                // IF_SFDC_DEALER_LSTA_044 메소드 호출
		                appService.IF_SFDC_DEALER_LSTA_044_IFSTS_UPDATE(params);  // 발주헤더 수신 IF 데이터 삽입
		                
	            	}  catch (Exception e) {
	                    // 개별 건 실패해도 로그만 남기고 계속 진행
	                    logger.error("Failed to process NO (IF_SFDC_DEALER_LSTA_044) : {}, Error: {}", data.getDEAL_ID(), e.getMessage());
	                    
	                    String errorMsg = "DEAL_ID : " + data.getDEAL_ID() + " - " + e.getMessage();
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
	        
	        returnMap.setO_RESULT("S");
	        returnMap.setO_MESSAGE("SUCCESS");
	        
        } catch (Exception e) {
        	returnMap.setO_RESULT("E");
        	returnMap.setO_MESSAGE("ERROR: " + e.getMessage());
		}
        
        current = new Date(System.currentTimeMillis() );
        logger.info("############# IF_SFDC_DEALER_LSTA_044 END ( {} ) #############", dateFormat.format(current));
        
        return returnMap;
    }
 	
}
	   