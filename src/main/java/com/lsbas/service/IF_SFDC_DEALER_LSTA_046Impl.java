package com.lsbas.service;

import javax.jws.WebService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.app.AppService;
import com.wsc.framework.model.ParamsMap;
import com.lsbas.service.if_sfdc_dealer_lsta_046.request.IF_SFDC_DEALER_LSTA_046_data;
import com.lsbas.service.if_sfdc_dealer_lsta_046.request.IF_SFDC_DEALER_LSTA_046_request;
import com.lsbas.service.if_sfdc_dealer_lsta_046.response.IF_SFDC_DEALER_LSTA_046_response;

import java.util.Date;
import java.util.List;
import java.text.*;

@WebService(endpointInterface = "com.lsbas.service.IF_SFDC_DEALER_LSTA_046")
public class IF_SFDC_DEALER_LSTA_046Impl implements IF_SFDC_DEALER_LSTA_046 {
	public static SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
	
	@Autowired
	private AppService appService;
	
	private static final Logger logger = LoggerFactory.getLogger(IF_SFDC_DEALER_LSTA_046Impl.class);
	
	@Override
	public IF_SFDC_DEALER_LSTA_046_response getService(IF_SFDC_DEALER_LSTA_046_request request) {
		Date current = new Date(System.currentTimeMillis());
		logger.info("############# IF_SFDC_DEALER_LSTA_046 START ( {} ) #############", dateFormat.format(current));
		
		String sysId = "IMMES";
		String jobId = "SFDC046";
	    String currDate  = MtronUtil.getCurrentDate();
	    long   workSeq   = 0;
	    String jobFile  = "IF_SFDC_DEALER_LSTA_046";
	    String rsltMsg  = "";
        IF_SFDC_DEALER_LSTA_046_response returnMap = new IF_SFDC_DEALER_LSTA_046_response();
        
        try {
	    	List<IF_SFDC_DEALER_LSTA_046_data> dataList = request.getALERT_LIST();      // 알림 데이터
	    	
	        if(dataList != null) {
	            for(IF_SFDC_DEALER_LSTA_046_data data : dataList) {
	            	try {
		                // required keys
		                if (data.getID() == null || data.getID().trim().isEmpty()) {
		                	throw new IllegalArgumentException("Required key missing: ID is mandatory");
		                }
		                
		                ParamsMap params = new ParamsMap();
		                params.put("sysId"	       , "IMMES");  // 적절한 sysId 값을 넣어야 합니다.
		                params.put("jobId"         , jobId); 
		                params.put("currDate"      , currDate); 
		                params.put("workSeq"       , workSeq); 
		                
		                // data 변수 선언
		                String id = data.getID();
		                String title = MtronUtil.nullToEmpty(data.getTITLE());
		                String body = MtronUtil.nullToEmpty(data.getBODY());
		                String linkUrl = MtronUtil.nullToEmpty(data.getLINK_URL());
		                String user = MtronUtil.nullToEmpty(data.getUSER());
	
		                // 로그 출력
		                logger.debug("##### id:      {}", id);
		                logger.debug("##### title:   {}", title);
		                logger.debug("##### body:    {}", body);
		                logger.debug("##### linkUrl: {}", linkUrl);
		                logger.debug("##### user:    {}", user);
	
		                // params에 저장
		                params.put("ID", id);              // 아이디
		                params.put("TITLE", title);        // 제목
		                params.put("BODY", body);          // 내용
		                params.put("LINK_URL", linkUrl);   // URL
		                params.put("USER", user);          // 사용자 SSO ID
		 
		                // IF_SFDC_DEALER_LSTA_046 메소드 호출
		                appService.IF_SFDC_DEALER_LSTA_046_IFSTS_UPDATE(params);  // 발주헤더 수신 IF 데이터 삽입
	                
	            	}  catch (Exception e) {
	                    // 개별 건 실패해도 로그만 남기고 계속 진행
	                    logger.error("Failed to process NO (IF_SFDC_DEALER_LSTA_046) : {}, Error: {}", data.getID(), e.getMessage());
	                    
	                    String errorMsg = "BORD_NO : " + data.getID() + " - " + e.getMessage();
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
        logger.info("############# IF_SFDC_DEALER_LSTA_046 END ( {} ) #############", dateFormat.format(current));
        
        return returnMap;
    }
 	
}
	   