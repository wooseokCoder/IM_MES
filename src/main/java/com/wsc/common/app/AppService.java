package com.wsc.common.app;

import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.Base64.Decoder;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.common.user.UserLogService;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;

@Service
public class AppService extends BaseService {
	
	@Autowired
	private CommonDao dao;
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired 
	private UserLogService userlogService;

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
	
	public Object searchUserGroup(ParamsMap params) {
		return searchByName("UserGroup", params);
	}
	
	public ParamsMap getDecodeParams(HttpServletRequest request,ParamsMap params) {
		// 파라메터 중 Base64 인코딩으로 넘어오는 auth 파라메터
		String authParam = params.get("auth")!=null?params.get("auth").toString():"";
		
		// 아파치 코덱으로 Base64 디코딩 진행
		try{
			Decoder decoder = Base64.getDecoder();
			byte[] decodedBytes = decoder.decode(authParam);
			String decodeString = new String(decodedBytes);
		
			// 디코딩 완료된 파라메터 문자열 파라미터 값 수 만큼 분리
			String[] decodeStringArray = decodeString.split("&");
			
			// 반복문으로 디코딩한 파라메터를 params 객체에 설정 , 키값만 넘어온 경우에도 공백으로 추가
			for(String decodeAuthParam : decodeStringArray) {
				String[] param = decodeAuthParam.split("=");
				if(param.length == 2) {
					params.put(param[0],param[1]);
				}else if(param.length == 1) {
					params.put(param[0],"");
				}else {
					// 파라미터 오류케이스 발생시 처리 한다면..
				}
			}
			
			//마이바티스에서 사용할 변수로 설정
//			params.put("sysId"   , params.get("SYS_ID")   !=null ? params.get("SYS_ID").toString()   : "LSDP" );
//			params.put("userId"  , params.get("USER_ID")  !=null ? params.get("USER_ID").toString()  : ""     );
			params.put("issuUrl" , request.getRequestURI());
			params.put("rqstUrl" , params.get("RQST_URL") !=null ? params.get("RQST_URL").toString() : ""     );
			params.put("rqstDttm", params.get("RQST_DTTM")!=null ? params.get("RQST_DTTM").toString(): ""     );
			params.put("ftokenNo", params.get("FTOKEN_NO")!=null ? params.get("FTOKEN_NO").toString(): null   );
		
		}catch(Exception e){
			return params;
		}
				
		return params;
	}
	
	@Transactional
	public Object login(ParamsMap params, HttpServletRequest request) {
		Object result;
		Object checkPw;
		result  = dao.select("userInfo", params);
		checkPw = dao.select("appCheckPassword", params);
		if(checkPw.equals("O")){
			userlogService.insert(params);
		} 	
		return result;
	}
	
	@Transactional
	public RecordMap darDataCheck(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("darDataCheck",params);
		
		return result;
	}
	
	@Transactional
	public Object lsasDarSave(ParamsMap params) {
		
		Object result = null;
		// 토큰 검증
		result = dao.select("lsasDarSave",params);
		
		return result;
	}
	
	@Transactional
	public Object lsasDarEvalSave(ParamsMap params) {
		
		Object result = null;
		// 토큰 검증
		result = dao.select("lsasDarEvalSave",params);
		
		return result;
	}
	
	@Transactional
	public String getUUID() {
	    String result = null;
	    try {
	        result = (String) dao.select("getUUID");
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return result;
	}
	
	@Transactional
	public String getIfIdNo(ParamsMap params) {
	    String result = null;
	    try {
	        result = (String) dao.select("getIfIdNo",params);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return result;
	}
	
	
	@Transactional
	public int IF_SFDC_DEALER_LSTA_040_IFSTS_UPDATE(ParamsMap params) {
		return dao.update("IF_SFDC_DEALER_LSTA_040_IFSTS_UPDATE", params);
	}

	@Transactional
	public int IF_SFDC_DEALER_LSTA_041_IFSTS_UPDATE(ParamsMap params) {
		return dao.update("IF_SFDC_DEALER_LSTA_041_IFSTS_UPDATE", params);
	}
	
	@Transactional
	public int IF_SFDC_DEALER_LSTA_038_IFSTS_UPDATE(ParamsMap params) {
		return dao.update("IF_SFDC_DEALER_LSTA_038_IFSTS_UPDATE", params);
	}
	
	@Transactional
	public int IF_SFDC_DEALER_LSTA_044_IFSTS_UPDATE(ParamsMap params) {
		return dao.update("IF_SFDC_DEALER_LSTA_044_IFSTS_UPDATE", params);
	}
	
	@Transactional
	public int IF_SFDC_DEALER_LSTA_046_IFSTS_UPDATE(ParamsMap params) {
		return dao.update("IF_SFDC_DEALER_LSTA_046_IFSTS_UPDATE", params);
	}
	
	@Transactional
	public int IF_SFDC_DEALER_LSTA_ERR_LOG_UPDATE(ParamsMap params) {
		return dao.update("IF_SFDC_DEALER_LSTA_ERR_LOG_UPDATE", params);
	}
	
}
