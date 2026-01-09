package com.lsbas.service;

import javax.jws.WebService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.app.AppService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.saml.SamlSsoController;
import com.lsbas.service.if_sfdc_dealer_lsta_038.request.IF_SFDC_DEALER_LSTA_038_data;
import com.lsbas.service.if_sfdc_dealer_lsta_038.request.IF_SFDC_DEALER_LSTA_038_request;
import com.lsbas.service.if_sfdc_dealer_lsta_038.response.IF_SFDC_DEALER_LSTA_038_response;

import java.util.Date;
import java.util.List;
import java.text.*;

@WebService(endpointInterface = "com.lsbas.service.IF_SFDC_DEALER_LSTA_038")
@Service
public class IF_SFDC_DEALER_LSTA_038Impl implements IF_SFDC_DEALER_LSTA_038 {
	public static SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
	
	@Autowired 
	private AppService appService;
	
	private static final Logger logger = LoggerFactory.getLogger(IF_SFDC_DEALER_LSTA_038Impl.class);
	
	@Override
	public IF_SFDC_DEALER_LSTA_038_response getService(IF_SFDC_DEALER_LSTA_038_request request) {
		Date current = new Date(System.currentTimeMillis());
		logger.info("############# IF_SFDC_DEALER_LSTA_038 START ( {} ) #############", dateFormat.format(current));

		String sysId = "IMMES";
		String jobId = "SFDC038";
	    String currDate = MtronUtil.getCurrentDate();
	    long   workSeq  = 0;
	    String jobFile  = "IF_SFDC_DEALER_LSTA_038";
	    String rsltMsg  = "";
        IF_SFDC_DEALER_LSTA_038_response returnMap = new IF_SFDC_DEALER_LSTA_038_response();
        
        try {
        	List<IF_SFDC_DEALER_LSTA_038_data> dataList = request.getMANUAL_LIST();      // 매뉴얼 데이터

        	if(dataList != null) {
	            for(IF_SFDC_DEALER_LSTA_038_data data : dataList) {
	            	try {
		                // required keys
		                if (data.getNO() == null || data.getNO().trim().isEmpty()) {
		                	throw new IllegalArgumentException("Required key missing: NO is mandatory");
		                }
		                
		                ParamsMap params = new ParamsMap();
		                params.put("sysId"	       , "IMMES");  // 적절한 sysId 값을 넣어야 합니다.
		                params.put("jobId"         , jobId); 
		                params.put("currDate"      , currDate); 
		                params.put("workSeq"       , workSeq);
		                
		                // data 변수 선언
		                String no = data.getNO();
		                String title = MtronUtil.nullToEmpty(data.getTITLE());
		                String description = MtronUtil.nullToEmpty(data.getDESCRIPTION());
		                String area = MtronUtil.nullToEmpty(data.getAREA());
		                String type = MtronUtil.nullToEmpty(data.getTYPE());
		                String language = MtronUtil.nullToEmpty(data.getLANGUAGE());
		                String serise = MtronUtil.nullToEmpty(data.getSERISE());
		                String model = MtronUtil.nullToEmpty(data.getMODEL());
		                String createdBy = MtronUtil.nullToEmpty(data.getCREATED_BY());
		                String fileNo = MtronUtil.nullToEmpty(data.getFILE_NO());
		                String fileName = MtronUtil.nullToEmpty(data.getFILE_NAME());
		                String fileSize = MtronUtil.nullToEmpty(data.getFILE_SIZE());
		                String fileUrl = MtronUtil.nullToEmpty(data.getFILE_URL());
		                String fileDownloadUrl = MtronUtil.nullToEmpty(data.getFILE_DOWNLOAD_URL());
	
		                // 로그 출력
		                logger.debug("##### no: {}", no);
		                logger.debug("##### title: {}", title);
		                logger.debug("##### description: {}", description);
		                logger.debug("##### area: {}", area);
		                logger.debug("##### type: {}", type);
		                logger.debug("##### language: {}", language);
		                logger.debug("##### serise: {}", serise);
		                logger.debug("##### model: {}", model);
		                logger.debug("##### createdBy: {}", createdBy);
		                logger.debug("##### fileNo: {}", fileNo);
		                logger.debug("##### fileName: {}", fileName);
		                logger.debug("##### fileSize: {}", fileSize);
		                logger.debug("##### fileUrl: {}", fileUrl);
		                logger.debug("##### fileDownloadUrl: {}", fileDownloadUrl);
	
		                // params에 저장
		                params.put("NO"               , no);                // 순번
		                params.put("TITLE"            , title);             // TITLE
		                params.put("DESCRIPTION"      , description);       // DESCRIPTION
		                params.put("AREA"             , area);              // 영역
		                params.put("TYPE"             , type);              // 타입
		                params.put("LANGUAGE"         , language);          // 언어 코드
		                params.put("SERISE"           , serise);            // 시리즈
		                params.put("MODEL"            , model);             // 모델
		                params.put("CREATED_BY"       , createdBy);         // 생성자
		                params.put("FILE_NO"          , fileNo);            // 파일 아이디
		                params.put("FILE_NAME"        , fileName);          // 파일 명
		                params.put("FILE_SIZE"        , fileSize);          // 파일 사이즈
		                params.put("FILE_URL"         , fileUrl);           // 파일 URL
		                params.put("FILE_DOWNLOAD_URL", fileDownloadUrl);   // 파일 다운로드 URL
		                
		                // IF_SFDC_DEALER_LSTA_038 메소드 호출
		                appService.IF_SFDC_DEALER_LSTA_038_IFSTS_UPDATE(params);  // 발주헤더 수신 IF 데이터 삽입
		                
	            	}  catch (Exception e) {
	                    // 개별 건 실패해도 로그만 남기고 계속 진행
	                    logger.error("Failed to process NO (IF_SFDC_DEALER_LSTA_038) : {}, Error: {}", data.getNO(), e.getMessage());
	                    
	                    String errorMsg = "BORD_NO : " + data.getNO() + " - " + e.getMessage();
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
        logger.info("############# IF_SFDC_DEALER_LSTA_038 END ( {} ) #############", dateFormat.format(current));
        
        return returnMap;
    }
	
}
	   