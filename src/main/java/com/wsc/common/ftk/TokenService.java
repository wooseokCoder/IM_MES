package com.wsc.common.ftk;

import java.util.Base64;
import java.util.List;
import java.util.Base64.Decoder;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;

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

@Service
@SuppressWarnings({"unchecked","rawtypes"})
public class TokenService extends BaseService {
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
	
	@Transactional
	public RecordMap createToken(ParamsMap params) {
		
		RecordMap result = null;
		// 발급된 토큰 저장
		result = (RecordMap) dao.select("createToken",params);
		
		return result;
	}
	
	@Transactional
	public Object validateToken(ParamsMap params) {
		
		Object token = null;
		// 토큰 검증
		token = dao.select("validateToken",params);
		
		return token;
	}
	
	@Transactional
	public Object validateToken2(ParamsMap params) {
		
		Object token = null;
		// 토큰 검증
		token = dao.select("validateToken2",params);
		
		return token;
	}
	
	@Transactional
	public RecordMap seriNoUpdate(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("seriNoUpdate",params);
		
		return result;
	}
	
	@Transactional
	public RecordMap outboundUpdate(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("outBoundUpdate",params);
		
		return result;
	}
	
	@Transactional
	public RecordMap outboundCancelUpdate(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("outBoundCancelUpdate",params);
		
		return result;
	}
	
	@Transactional
	public RecordMap assyNoUpdate(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("assyNoUpdate",params);
		
		return result;
	}
	
	@Transactional
	public RecordMap ifOrdrUpdate(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("ifOrdrUpdate",params);
		
		return result;
	}
	
	@Transactional
	public RecordMap outboundBolImgUpdate(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("outboundBolImgUpdate",params);
		
		return result;
	}
	
	@Transactional
	public RecordMap ifLsas(ParamsMap params) {
		
		RecordMap result = null;
		// 토큰 검증
		result = (RecordMap)dao.select("ifLsas",params);
		
		return result;
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
			params.put("sysId"   , params.get("SYS_ID")   !=null ? params.get("SYS_ID").toString()   : "IMMES" );
			params.put("userId"  , params.get("USER_ID")  !=null ? params.get("USER_ID").toString()  : ""     );
			params.put("issuUrl" , request.getRequestURI());
			params.put("rqstUrl" , params.get("RQST_URL") !=null ? params.get("RQST_URL").toString() : ""     );
			params.put("rqstDttm", params.get("RQST_DTTM")!=null ? params.get("RQST_DTTM").toString(): ""     );
			params.put("ftokenNo", params.get("FTOKEN_NO")!=null ? params.get("FTOKEN_NO").toString(): null   );
		
			params.put("ORDR_NO" , params.get("ORDR_NO")!=null ? params.get("ORDR_NO").toString() : null);
			params.put("ITEM_CD" , params.get("ITEM_CD")!=null ? params.get("ITEM_CD").toString() : null);
			params.put("SERI_NO" , params.get("SERI_NO")!=null ? params.get("SERI_NO").toString() : null);
			params.put("BOL_NO"  , params.get("BOL_NO") !=null ? params.get("BOL_NO").toString() : null);
			params.put("TEMP_ID" , params.get("TEMP_ID")!=null ? params.get("TEMP_ID").toString() : null);
			params.put("ACT_SHIP_DATE" , params.get("ACT_SHIP_DATE")!=null ? params.get("ACT_SHIP_DATE").toString() : null);
			params.put("REJECT_MAIL"   , params.get("REJECT_MAIL")!=null ? params.get("REJECT_MAIL").toString() : null);
			params.put("PASS_TITLE"    , params.get("PASS_TITLE")!=null ? params.get("PASS_TITLE").toString() : null);
			params.put("GP_NO"         , params.get("GP_NO")!=null ? params.get("GP_NO").toString() : null);
			params.put("Pass_Date"     , params.get("Pass_Date")!=null ? params.get("Pass_Date").toString() : null);
			params.put("Pass_Time"     , params.get("Pass_Time")!=null ? params.get("Pass_Time").toString() : null);
			params.put("GateToUse"     , params.get("GateToUse")!=null ? params.get("GateToUse").toString() : null);
		}catch(Exception e){
			return params;
		}
				
		return params;
	}
	
	@Transactional
	public RecordMap getApiKey(ParamsMap params) {
		
		RecordMap result = null;
		// 발급된 토큰 저장
		result = (RecordMap) dao.select("getApiKey",params);
		
		return result;
	}
}
