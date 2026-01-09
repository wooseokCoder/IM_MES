package com.wsc.common.ftk;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

//import com.entrust.toolkit.util.Map;
import com.wsc.common.Consts;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;

@Controller
@RequestMapping("/common/ftk/")
public class TokenController extends BaseController {
	
	@Value("#{app['pdi.addr']}")
    public String pdi_path;
	
	@Value("#{app['as.addr']}")
    public String as_path;
	
	@Value("#{app['logi.addr']}")
    public String logi_path;
	
	@Autowired 
	private TokenService service;
	
	@Autowired 
	private CacheComponent cache;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	private ParamsMap getDefaultParams(HttpServletRequest request) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        if (params.containsKey("userId") == false)
        	params.put("userId", params.get("gsUserId"));
        
        String addrType = params.getString("addrType");
        
        params.put("isUsers", Consts.isAddressUsersType(addrType));
        params.put("isGroup", Consts.isAddressGroupType(addrType));
        return params;
	}
	
	// SSO 토큰값 생성
	@ResponseBody
	@RequestMapping(value = "/issue.do")
	public Object issue(HttpServletRequest request,HttpServletResponse response, Model model) {
		RecordMap result = new RecordMap();
		// 로그인 했을때만 생성 가능
		if(getSessionComponent().getLoginReturn()!=null) {
			// 파라메터를 가져온다.
			ParamsMap params = getDefaultParams(request);
			// 파라메터 복호화(Base64디코딩) 후 재설정
			params = service.getDecodeParams(request,params);
			
			// SQL 결과값을 돌려 줄 맵 객체
			result = service.createToken(params);
		}else {
			result.put("result" , "FAIL");
		}
		
		// 뷰이름을 반환한다.
		return result;
	}
	
	// SSO 토큰값 생성
	@ResponseBody
	@RequestMapping(value = "/issuepdi.do")
	public Object issuepdi(HttpServletRequest request,HttpServletResponse response, Model model) {
		
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		RecordMap result = new RecordMap();
			// 파라메터를 가져온다.
			ParamsMap params = getDefaultParams(request);
			// 파라메터 복호화(Base64디코딩) 후 재설정
			params = service.getDecodeParams(request,params);
			params.put("sysId", "LSTA");
			params.put("userId", params.get("userId").toString());
			params.put("issuUrl", "/lspdi/common/ftk/issuepdi.do");
			params.put("rqstUrl", "/lspdi/common/ftk/issuepdi.do");
			// SQL 결과값을 돌려 줄 맵 객체
			result = service.createToken(params);
			
			
			result.put("result" , "SUCCESS");
		// 뷰이름을 반환한다.
		return result;
	}
	
	// SSO 토큰값 생성
	@ResponseBody
	@RequestMapping(value = "/missuepdi.do", method = RequestMethod.POST)
	public Object missuepdi(@RequestBody Map<String, Object> data,HttpServletRequest request,HttpServletResponse response, Model model) {
		
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		RecordMap result = new RecordMap();
			// 파라메터를 가져온다.
//			ParamsMap params = getDefaultParams(request);
	        ParamsMap params = getParams(request, true);
	        
			// 파라메터 복호화(Base64디코딩) 후 재설정
//			params = service.getDecodeParams(request,params);
			params.put("sysId", "LSTA");
			params.put("userId", data.get("userId"));
//			params.put("userId", params.get("userId").toString());
			params.put("issuUrl", "/lspdi/common/ftk/issuepdi.do");
			params.put("rqstUrl", "/lspdi/common/ftk/issuepdi.do");
			// SQL 결과값을 돌려 줄 맵 객체
			result = service.createToken(params);
			
			
			result.put("result" , "SUCCESS");
		// 뷰이름을 반환한다.
		return result;
	}
	
	// AS 토큰값 생성
		@ResponseBody
		@RequestMapping(value = "/missueas.do", method = RequestMethod.POST)
		public Object missueas(@RequestBody Map<String, Object> data,HttpServletRequest request,HttpServletResponse response, Model model) {
			
			response.setHeader("Access-Control-Allow-Origin", "*"); 
			response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
			RecordMap result = new RecordMap();
				// 파라메터를 가져온다.
//				ParamsMap params = getDefaultParams(request);
		        ParamsMap params = getParams(request, true);
		        
				// 파라메터 복호화(Base64디코딩) 후 재설정
//				params = service.getDecodeParams(request,params);
				params.put("sysId", "LSTA");
				params.put("userId", data.get("userId"));
//				params.put("userId", params.get("userId").toString());
				params.put("issuUrl", "/lsas/common/ftk/issuelsas.do");
				params.put("rqstUrl", "/lsas/common/ftk/issuelsas.do");
				// SQL 결과값을 돌려 줄 맵 객체
				result = service.createToken(params);
				
				
				result.put("result" , "SUCCESS");
			// 뷰이름을 반환한다.
			return result;
		}
	
	// SSO 토큰값 검증
	@ResponseBody
	@RequestMapping(value = "/validation.do")
	public Object validation(HttpServletRequest request,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		// 파라메터를 가져온다.
		ParamsMap params = getDefaultParams(request);
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
				
		String msg = "만료된 요청입니다.";
		
		HashMap<String , Object> result = new HashMap<String, Object>();
		Object SqlResult = null;
		
		if(params.get("userId") != null && params.get("ftokenNo") != null) {
			SqlResult = service.validateToken(params);
			result.put("result" , SqlResult);
		}else{
			result.put("result" , "FAIL");
		}
		
		// 뷰이름을 반환한다.
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/validation2.do")
	public Object validation2(HttpServletRequest request,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		// 파라메터를 가져온다.
		ParamsMap params = getDefaultParams(request);
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
				
		String msg = "만료된 요청입니다.";
		
		HashMap<String , Object> result = new HashMap<String, Object>();
		Object SqlResult = null;
		
		if(params.get("userId") != null && params.get("ftokenNo") != null) {
			SqlResult = service.validateToken(params);
			result.put("result" , SqlResult);
			result.put("userId", params.get("userId"));
		}else{
			result.put("result" , "FAIL");
		}
		
		// 뷰이름을 반환한다.
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/validation3.do")
	public Object validation3(HttpServletRequest request,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		// 파라메터를 가져온다.
		ParamsMap params = getDefaultParams(request);
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
				
		String msg = "만료된 요청입니다.";
		
		HashMap<String , Object> result = new HashMap<String, Object>();
		Object SqlResult = null;
		
		if(params.get("userId") != null && params.get("ftokenNo") != null) {
			SqlResult = service.validateToken(params);
			result.put("result" , SqlResult);
			result.put("userId", params.get("userId"));
			result.put("ftokenNo", params.get("ftokenNo"));
		}else{
			result.put("result" , "FAIL");
		}
		
		// 뷰이름을 반환한다.
		return result;
	}
	
	//PDI serialNo update용
	@ResponseBody
	@RequestMapping(value="/pdi_seri_upd")
	public Object pdiSeriNoUpd(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			params.put("ordrNo", params.get("ORDR_NO").toString());
			params.put("itemCode", params.get("ITEM_CD").toString());
			params.put("seriNo", params.get("SERI_NO").toString());
			result = service.seriNoUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/m_pdi_seri_upd",method = RequestMethod.POST)
	public Object mpdiSeriNoUpd(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
//        ParamsMap params = getParams(request);
        ParamsMap params = getParams(request, true);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
//		params = service.getDecodeParams(request,params);
		
//		String id = params.get("userId").toString();
//		String tokenNo = params.get("TOKEN_NO").toString();
//		params.put("userId", id);
//		params.put("ftokenNo", tokenNo);

		params.put("userId"          , data.get("userId")); 
		params.put("ftokenNo"        , data.get("TOKEN_NO"));
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			params.put("ordrNo"          , data.get("ORDR_NO")); 
			params.put("itemCode"        , data.get("ITEM_CD"));
			params.put("seriNo"          , data.get("SERI_NO")); 
//			params.put("ordrNo", params.get("ORDR_NO").toString());
//			params.put("itemCode", params.get("ITEM_CD").toString());
//			params.put("seriNo", params.get("SERI_NO").toString());
			result = service.seriNoUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	//PDI Outbound update용
	@ResponseBody
	@RequestMapping(value="/pdi_outbound_upd")
	public Object pdiOutboundUpd(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			params.put("bolNo", params.get("BOL_NO").toString());
			params.put("actShipDate", params.get("ACT_SHIP_DATE").toString());
			result = service.outboundUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/m_pdi_outbound_upd",method = RequestMethod.POST)
	public Object mpdiOutboundUpd(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
//        ParamsMap params = getParams(request);
        ParamsMap params = getParams(request, true);
        
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
	//	params = service.getDecodeParams(request,params);
		
//		String id = params.get("userId").toString();
//		String tokenNo = params.get("TOKEN_NO").toString();
//		
//		params.put("userId", id);
//		params.put("ftokenNo", tokenNo);
		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			params.put("bolNo"          , data.get("BOL_NO"));
			params.put("actShipDate"    , data.get("ACT_SHIP_DATE"));
//			params.put("bolNo", params.get("BOL_NO").toString());
//			params.put("actShipDate", params.get("ACT_SHIP_DATE").toString());
			result = service.outboundUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	//PDI Outbound Cancel update용
	@ResponseBody
	@RequestMapping(value="/pdi_outbound_upd_cancel")
	public Object pdiOutboundCancelUpd(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			params.put("poNo", params.get("poNo").toString());
//				params.put("poSeq", params.get("poSeq").toString());
			result = service.outboundCancelUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	//PDI AssyNo update용
	@ResponseBody
	@RequestMapping(value="/pdi_assy_upd")
	public Object pdiAssyNoUpd(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			params.put("ordrNo", params.get("ORDR_NO").toString());
			params.put("assyNo", params.get("ASSY_NO").toString());
			params.put("assyDate", params.get("ASSY_DATE").toString());
			result = service.assyNoUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	
	//PDI AssyNo update용 (앱)
	@ResponseBody
	@RequestMapping(value="/m_pdi_assy_upd")
	public Object mpdiAssyNoUpd(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request, true);

		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			params.put("ordrNo"   , data.get("ORDR_NO"));
			params.put("assyNo"   , data.get("ASSY_NO"));
			params.put("assyDate" , data.get("ASSY_DATE"));
			result = service.assyNoUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	//PDI Common IF update용
	@ResponseBody
	@RequestMapping(value="/pdi_if_upd")
	public Object pdiIfUpd(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			if(params.containsKey("TYPE")) params.put("type", params.get("TYPE").toString());
			else params.put("type", "");
			if(params.containsKey("ORDR_NO")) params.put("ordrNo", params.get("ORDR_NO").toString());
			else params.put("ordrNo", "");
			if(params.containsKey("ITEM_CODE")) params.put("itemCode", params.get("ITEM_CODE").toString());
			else params.put("itemCode", "");
			if(params.containsKey("VAR1")) params.put("var1", params.get("VAR1").toString());
			else params.put("var1", "");
			if(params.containsKey("VAR2")) params.put("var2", params.get("VAR2").toString());
			else params.put("var2", "");
			if(params.containsKey("VAR3")) params.put("var3", params.get("VAR3").toString());
			else params.put("var3", "");
			if(params.containsKey("VAR4")) params.put("var4", params.get("VAR4").toString());
			else params.put("var4", "");
			if(params.containsKey("VAR5")) params.put("var5", params.get("VAR5").toString());
			else params.put("var5", "");
			if(params.containsKey("VAR6")) params.put("var6", params.get("VAR6").toString());
			else params.put("var6", "");
			if(params.containsKey("VAR7")) params.put("var7", params.get("VAR7").toString());
			else params.put("var7", "");
			if(params.containsKey("VAR8")) params.put("var8", params.get("VAR8").toString());
			else params.put("var8", "");
			if(params.containsKey("VAR9")) params.put("var9", params.get("VAR9").toString());
			else params.put("var9", "");
			if(params.containsKey("VAR10")) params.put("var10", params.get("VAR10").toString());
			else params.put("var10", "");
			if(params.containsKey("VAR11")) params.put("var11", params.get("VAR11").toString());
			else params.put("var11", "");
			result = service.ifOrdrUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	//PDI Common IF update용(앱)
		@ResponseBody
		@RequestMapping(value="/m_bol_pdi_if_upd")
		public Object mBolPdiIfUpd(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
			// 모든 url 요청에 대한 cors 허용
			response.setHeader("Access-Control-Allow-Origin", "*"); 
			response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
	        // 파라메터를 가져온다.
	        ParamsMap params = getParams(request, true);

			params.put("userId"         , data.get("userId"));
			params.put("ftokenNo"       , data.get("TOKEN_NO2"));
			
			Object SqlResult = service.validateToken2(params);
			RecordMap result = new RecordMap();
			if(SqlResult.equals("SUCCESS")){
				if(data.containsKey("Type")) params.put("type", data.get("Type"));
				else params.put("type", "");
				if(data.containsKey("atchNo")) params.put("ordrNo", data.get("atchNo"));
				else params.put("ordrNo", "");
				if(data.containsKey("itemCode")) params.put("itemCode", data.get("itemCode"));
				else params.put("itemCode", "");
				if(data.containsKey("atchImgNo")) params.put("var1", data.get("atchImgNo"));
				else params.put("var1", "");
				if(data.containsKey("VAR2")) params.put("var2", data.get("VAR2"));
				else params.put("var2", "");
				if(data.containsKey("VAR3")) params.put("var3", data.get("VAR3"));
				else params.put("var3", "");
				if(data.containsKey("VAR4")) params.put("var4", data.get("VAR4"));
				else params.put("var4", "");
				if(data.containsKey("VAR5")) params.put("var5", data.get("VAR5"));
				else params.put("var5", "");
				if(data.containsKey("VAR6")) params.put("var6", data.get("VAR6"));
				else params.put("var6", "");
				if(data.containsKey("VAR7")) params.put("var7", data.get("VAR7"));
				else params.put("var7", "");
				if(data.containsKey("VAR8")) params.put("var8", data.get("VAR8"));
				else params.put("var8", "");
				if(data.containsKey("VAR9")) params.put("var9", data.get("VAR9"));
				else params.put("var9", "");
				if(data.containsKey("VAR10")) params.put("var10", data.get("VAR10"));
				else params.put("var10", "");
				if(data.containsKey("atchImg")) params.put("var11", data.get("atchImg"));
				else params.put("var11", "");
				result = service.ifOrdrUpdate(params);
			} else {
				result.put("result" , "TOKEN FAIL");
			}
	        
			return result;
		}
	
	
	
	//PDI AssyNo update용 (앱)
	@ResponseBody
	@RequestMapping(value="/m_pdi_if_upd")
	public Object mpdiIfUpd(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request, true);

		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			if(data.containsKey("TYPE")) params.put("type", data.get("TYPE"));
			else params.put("type", "");
			if(data.containsKey("ORDR_NO")) params.put("ordrNo", data.get("ORDR_NO"));
			else params.put("ordrNo", "");
			if(data.containsKey("ITEM_CODE")) params.put("itemCode", data.get("ITEM_CODE"));
			else params.put("itemCode", "");
			if(data.containsKey("VAR1")) params.put("var1", data.get("VAR1"));
			else params.put("var1", "");
			if(data.containsKey("VAR2")) params.put("var2", data.get("VAR2"));
			else params.put("var2", "");
			if(data.containsKey("VAR3")) params.put("var3", data.get("VAR3"));
			else params.put("var3", "");
			if(data.containsKey("VAR4")) params.put("var4", data.get("VAR4"));
			else params.put("var4", "");
			if(data.containsKey("VAR5")) params.put("var5", data.get("VAR5"));
			else params.put("var5", "");
			if(data.containsKey("VAR6")) params.put("var6", data.get("VAR6"));
			else params.put("var6", "");
			if(data.containsKey("VAR7")) params.put("var7", data.get("VAR7"));
			else params.put("var7", "");
			if(data.containsKey("VAR8")) params.put("var8", data.get("VAR8"));
			else params.put("var8", "");
			if(data.containsKey("VAR9")) params.put("var9", data.get("VAR9"));
			else params.put("var9", "");
			if(data.containsKey("VAR10")) params.put("var10", data.get("VAR10"));
			else params.put("var10", "");
			if(data.containsKey("VAR11")) params.put("var11", data.get("VAR11"));
			else params.put("var11", "");
			result = service.ifOrdrUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	//PDI Outbound Bol Img update용
	@ResponseBody
	@RequestMapping(value="/pdi_outbound_upd_bol_img")
	public Object pdiOutboundBolImgUpd(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = service.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
//				params.put("poNo", params.get("poNo").toString());
//					params.put("poSeq", params.get("poSeq").toString());
			result = service.outboundBolImgUpdate(params);
		} else {
			result.put("result" , "TOKEN FAIL");
		}
        
		return result;
	}
	
	//LSAS용
	@ResponseBody
	@RequestMapping(value="/m_lsas_if_upd")
	public Object mLsasIfUpd(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request, true);

		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object SqlResult = service.validateToken2(params);
		RecordMap result = new RecordMap();
		if(SqlResult.equals("SUCCESS")){
			if(data.containsKey("VAR1")) params.put("var1", data.get("VAR1"));
			else params.put("var1", "");
			if(data.containsKey("VAR2")) params.put("var2", data.get("VAR2"));
			else params.put("var2", "");
			if(data.containsKey("VAR3")) params.put("var3", data.get("VAR3"));
			else params.put("var3", "");
			if(data.containsKey("VAR4")) params.put("var4", data.get("VAR4"));
			else params.put("var4", "");
			if(data.containsKey("VAR5")) params.put("var5", data.get("VAR5"));
			else params.put("var5", "");
			if(data.containsKey("VAR6")) params.put("var6", data.get("VAR6"));
			else params.put("var6", "");
			if(data.containsKey("VAR7")) params.put("var7", data.get("VAR7"));
			else params.put("var7", "");
			if(data.containsKey("VAR8")) params.put("var8", data.get("VAR8"));
			else params.put("var8", "");
			if(data.containsKey("VAR9")) params.put("var9", data.get("VAR9"));
			else params.put("var9", "");
			if(data.containsKey("VAR10")) params.put("var10", data.get("VAR10"));
			else params.put("var10", "");
			if(data.containsKey("VAR11")) params.put("var11", data.get("VAR11"));
			else params.put("var11", "");
			if(data.containsKey("VAR12")) params.put("var12", data.get("VAR12"));
			else params.put("var12", "");
			if(data.containsKey("VAR13")) params.put("var13", data.get("VAR13"));
			else params.put("var13", "");
			if(data.containsKey("VAR14")) params.put("var14", data.get("VAR14"));
			else params.put("var14", "");
			if(data.containsKey("VAR15")) params.put("var15", data.get("VAR15"));
			else params.put("var15", "");
//				result = service.ifLsas(params);
			result = service.ifLsas(params);
			result.put("checkSF"   , "SUCCESS");
//				params.put("lsas"   , service.ifLsas(params));
		} else {
//				params = null;
			result.put("checkSF"   , "FAIL");
//				params.put("checkSF"   , "FAIL");
		}
        
		return result;
	}

	//TODO
	@RequestMapping(value = "/apiCall.json")
	public String apiCall(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		StringBuffer urlParameters = new StringBuffer();
		StringBuffer urlParameters2 = new StringBuffer();
		String tokenNo = "";
		try {
			URL obj = new URL(pdi_path + "common/ftk/issuelsdp2.do");
			
			//URL obj = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/issuelsdp2.do");
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            urlParameters.append("USER_ID=");
            urlParameters.append(params.get("userId").toString());
            
            // For POST only - START
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(urlParameters.toString().getBytes( StandardCharsets.UTF_8));
            os.flush();
            os.close();
            // For POST only - END

            int responseCode = conn.getResponseCode();
            System.out.println("POST Response Code :: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) { //success
               BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
               String inputLine;
               StringBuffer response = new StringBuffer();
               while ((inputLine = in.readLine()) != null) {
                  response.append(inputLine);
               }
               in.close();
               System.out.println("apiCall result token:" + response.toString());
               String[] rpArr = response.toString().replaceAll("\"", "").split(",");
               
               if(rpArr[1].indexOf("SUCCESS") != -1){
            	   tokenNo = rpArr[0].substring(rpArr[0].indexOf(":")+1);
            	   params.put("token", tokenNo);
            	   //URL obj2 = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/lsdp_ordr_upd");
            	   URL obj2 = new URL(pdi_path + "common/ftk/lsdp_ordr_upd");
            	   HttpURLConnection conn2 = (HttpURLConnection) obj2.openConnection();
            	   conn2.setRequestMethod("POST");
            	   conn2.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            	   conn2.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            	   
            	   urlParameters2.append("\"USER_ID\":\"");
            	   urlParameters2.append(params.get("userId").toString());
            	   urlParameters2.append("\",\"TOKEN_NO\":\"" + tokenNo);
            	   urlParameters2.append("\",\"ORDR_NO\":\"");
            	   urlParameters2.append(params.get("ordr_no").toString());
            	   urlParameters2.append("\",\"ASSY_NO\":\"");
            	   urlParameters2.append(params.get("assy_no").toString());
            	   urlParameters2.append("\",\"TYPE\":\"");
            	   urlParameters2.append(params.get("type").toString());
            	   urlParameters2.append("\",\"SET_VAL\":\"");
            	   urlParameters2.append(params.get("val").toString());
            	   urlParameters2.append("\",\"SET_VAL2\":\"");
            	   urlParameters2.append(params.get("val2").toString());
            	   urlParameters2.append("\",\"SET_VAL3\":\"");
            	   urlParameters2.append(params.get("val3").toString());
            	   urlParameters2.append("\",\"SET_VAL4\":\"");
            	   urlParameters2.append(params.get("val4").toString());
            	   urlParameters2.append("\",\"SET_VAL5\":\"");
            	   urlParameters2.append(params.get("val5").toString());
            	   urlParameters2.append("\",\"SET_VAL6\":\"");
            	   urlParameters2.append(params.get("val6").toString());
            	   urlParameters2.append("\",\"SET_VAL7\":\"");
            	   urlParameters2.append(params.get("val7").toString());
            	   urlParameters2.append("\",\"SET_VAL8\":\"");
            	   urlParameters2.append(params.get("val8").toString());
            	   urlParameters2.append("\",\"SET_VAL9\":\"");
            	   urlParameters2.append(params.get("val9").toString());
            	   urlParameters2.append("\",\"SET_VAL10\":\"");
            	   urlParameters2.append(params.get("val10").toString());
            	   urlParameters2.append("\",\"SET_VAL11\":\"");
            	   urlParameters2.append(params.get("val11").toString());
            	   urlParameters2.append("\",\"SET_VAL12\":\"");
            	   urlParameters2.append(params.get("val12").toString()+"\"");
//            	   System.out.println("apiCall param update:" + urlParameters2.toString());
//            	   service.insert("TmpLogInsert",params);
            	   // For POST only - START
            	   conn2.setDoOutput(true);
            	   OutputStream os2 = conn2.getOutputStream();
            	   os2.write(urlParameters2.toString().getBytes( StandardCharsets.UTF_8));
            	   os2.flush();
            	   os2.close();
            	   // For POST only - END
            	   
            	   int responseCode2 = conn2.getResponseCode();
            	   System.out.println("POST Response Code :: " + responseCode2);
            	   
            	   if (responseCode2 == HttpURLConnection.HTTP_OK) { //success
            		   BufferedReader in2 = new BufferedReader(new InputStreamReader(conn2.getInputStream()));
            		   String inputLine2;
            		   StringBuffer response2 = new StringBuffer();
            		   
            		   while ((inputLine2 = in2.readLine()) != null) {
            			   response2.append(inputLine2);
            		   }
            		   in2.close();
            		   System.out.println("apiCall result update:" + response2.toString());
            		   String[] rpArr2 = response2.toString().replaceAll("\"", "").split(",");
            		   // 모델에 객체를 추가한다.
//            		   params.put("ret", rpArr2[0]);
//            		   service.update("TmpLogUpdate",params);
            		   addObject(model,rpArr2[0]);
            	   }
               }
            } else {
            }
            
		} catch (Exception e){
			System.err.println(e.toString());
		} 
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	// SSO API KEY 생성
 	@RequestMapping(value = "/getApiKey.json")
 	public Object getApiKey(HttpServletRequest request, Model model) {
 		// 파라메터를 가져온다.
 		ParamsMap params = getParams(request);

 		Object result = service.getApiKey(params);
 		
 		// 모델에 객체를 추가한다.
	    addObject(model,result);
 		
	    // 뷰이름을 반환한다.
	    return "jsonView";
 	}
 	
 	//TODO SSO API KEY CALL
	@RequestMapping(value = "/apiKeyCall.json")
	public String apiKeyCall(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		StringBuffer urlParameters = new StringBuffer();
		StringBuffer urlParameters2 = new StringBuffer();
		String tokenNo = "";
		try {
			URL obj = new URL(pdi_path + "common/ftk/issuelsdp2.do");
			
			//URL obj = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/issuelsdp2.do");
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            urlParameters.append("USER_ID=");
            urlParameters.append(params.get("userId").toString());
            
            // For POST only - START
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(urlParameters.toString().getBytes( StandardCharsets.UTF_8));
            os.flush();
            os.close();
            // For POST only - END

            int responseCode = conn.getResponseCode();
            System.out.println("POST Response Code :: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) { //success
               BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
               String inputLine;
               StringBuffer response = new StringBuffer();
               while ((inputLine = in.readLine()) != null) {
                  response.append(inputLine);
               }
               in.close();
               System.out.println("apiKeyCall result token:" + response.toString());
               String[] rpArr = response.toString().replaceAll("\"", "").split(",");
               
               if(rpArr[1].indexOf("SUCCESS") != -1){
            	   tokenNo = rpArr[0].substring(rpArr[0].indexOf(":")+1);
            	   params.put("token", tokenNo);
            	   //URL obj2 = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/lsdp_ordr_upd");
            	   URL obj2 = new URL(pdi_path + "common/ftk/lsdp_ordr_select");
            	   HttpURLConnection conn2 = (HttpURLConnection) obj2.openConnection();
            	   conn2.setRequestMethod("POST");
            	   conn2.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            	   conn2.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            	   
            	   urlParameters2.append("\"USER_ID\":\"");
            	   urlParameters2.append(params.get("userId").toString());
            	   urlParameters2.append("\",\"ORDR_NO\":\"");
            	   urlParameters2.append(params.get("ordr_no").toString());
            	   urlParameters2.append("\",\"API_KEY\":\"");
            	   urlParameters2.append(params.get("api_key").toString());
            	   urlParameters2.append("\",\"TYPE\":\"");
            	   urlParameters2.append(params.get("type").toString());
            	   urlParameters2.append("\",\"SET_VAL\":\"");
            	   urlParameters2.append(params.get("val").toString());
            	   urlParameters2.append("\",\"SET_VAL2\":\"");
            	   urlParameters2.append(params.get("val2").toString());
            	   urlParameters2.append("\",\"SET_VAL3\":\"");
            	   urlParameters2.append(params.get("val3").toString());
            	   urlParameters2.append("\",\"SET_VAL4\":\"");
            	   urlParameters2.append(params.get("val4").toString());
            	   urlParameters2.append("\",\"SET_VAL5\":\"");
            	   urlParameters2.append(params.get("val5").toString());
            	   urlParameters2.append("\",\"SET_VAL6\":\"");
            	   urlParameters2.append(params.get("val6").toString());
            	   urlParameters2.append("\",\"SET_VAL7\":\"");
            	   urlParameters2.append(params.get("val7").toString());
            	   urlParameters2.append("\",\"SET_VAL8\":\"");
            	   urlParameters2.append(params.get("val8").toString());
            	   urlParameters2.append("\",\"SET_VAL9\":\"");
            	   urlParameters2.append(params.get("val9").toString());
            	   urlParameters2.append("\",\"SET_VAL10\":\"");
            	   urlParameters2.append(params.get("val10").toString());
            	   urlParameters2.append("\",\"SET_VAL11\":\"");
            	   urlParameters2.append(params.get("val11").toString()+"\"");
// 	            	   System.out.println("apiCall param update:" + urlParameters2.toString());
// 	            	   service.insert("TmpLogInsert",params);
            	   // For POST only - START
            	   conn2.setDoOutput(true);
            	   OutputStream os2 = conn2.getOutputStream();
            	   os2.write(urlParameters2.toString().getBytes( StandardCharsets.UTF_8));
            	   os2.flush();
            	   os2.close();
            	   // For POST only - END
            	   
            	   int responseCode2 = conn2.getResponseCode();
            	   System.out.println("POST Response Code :: " + responseCode2);
            	   
            	   if (responseCode2 == HttpURLConnection.HTTP_OK) { //success
            		   BufferedReader in2 = new BufferedReader(new InputStreamReader(conn2.getInputStream()));
            		   String inputLine2;
            		   StringBuffer response2 = new StringBuffer();
            		   
            		   while ((inputLine2 = in2.readLine()) != null) {
            			   response2.append(inputLine2);
            		   }
            		   in2.close();
            		   System.out.println("apiKeyCall result update:" + response2.toString());
            		   //String[] rpArr2 = response2.toString().replaceAll("\"", "").split(",");
            		   // 모델에 객체를 추가한다.
// 	            		   params.put("ret", rpArr2[0]);
// 	            		   service.update("TmpLogUpdate",params);
            		   addObject(model,response2.toString());
            	   }
               }
            } else {
            }
            
		} catch (Exception e){
			System.err.println(e.toString());
		} 
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	//TODO
	@RequestMapping(value = "/apiAsCall.json")
	public String apiAsCall(ParamsMap params) {
		String rst = "";
		StringBuffer urlParameters = new StringBuffer();
		StringBuffer urlParameters2 = new StringBuffer();
		String tokenNo = "";
		try {
			URL obj = new URL(as_path + "common/ftk/issuelsdp2.do");
			
			//URL obj = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/issuelsdp2.do");
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            urlParameters.append("USER_ID=");
            urlParameters.append(params.get("userId").toString());
            
            // For POST only - START
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(urlParameters.toString().getBytes( StandardCharsets.UTF_8));
            os.flush();
            os.close();
            // For POST only - END

            int responseCode = conn.getResponseCode();
            System.out.println("POST Response Code :: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) { //success
               BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
               String inputLine;
               StringBuffer response = new StringBuffer();
               while ((inputLine = in.readLine()) != null) {
            	   response.append(inputLine);
               }
               in.close();
               System.out.println("apiAsCall result token:" + response.toString());
               String[] rpArr = response.toString().replaceAll("\"", "").split(",");
               if(rpArr[1].indexOf("SUCCESS") != -1){
            	   tokenNo = rpArr[0].substring(rpArr[0].indexOf(":")+1);
            	   params.put("token", tokenNo);
            	   //URL obj2 = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/lsdp_ordr_upd");
            	   URL obj2 = new URL(as_path + "common/ftk/lsdp_ordr_upd");
            	   HttpURLConnection conn2 = (HttpURLConnection) obj2.openConnection();
            	   conn2.setRequestMethod("POST");
            	   conn2.setRequestProperty("User-Agent", "Mozilla/5.0");
            	   conn2.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            	   urlParameters2.append("\"USER_ID\":\"");
            	   urlParameters2.append(params.get("userId").toString());
            	   urlParameters2.append("\",\"TOKEN_NO\":\"" + tokenNo);
            	   urlParameters2.append("\",\"ORDR_NO\":\"");
            	   urlParameters2.append(params.get("ordr_no").toString());
            	   urlParameters2.append("\",\"ASSY_NO\":\"");
            	   urlParameters2.append(params.get("assy_no").toString());
            	   urlParameters2.append("\",\"TYPE\":\"");
            	   urlParameters2.append(params.get("type").toString());
            	   urlParameters2.append("\",\"SET_VAL\":\"");
            	   urlParameters2.append(params.get("val").toString());
            	   urlParameters2.append("\",\"SET_VAL2\":\"");
            	   urlParameters2.append(params.get("val2").toString());
            	   urlParameters2.append("\",\"SET_VAL3\":\"");
            	   urlParameters2.append(params.get("val3").toString());
            	   urlParameters2.append("\",\"SET_VAL4\":\"");
            	   urlParameters2.append(params.get("val4").toString());
            	   urlParameters2.append("\",\"SET_VAL5\":\"");
            	   urlParameters2.append(params.get("val5").toString());
            	   urlParameters2.append("\",\"SET_VAL6\":\"");
            	   urlParameters2.append(params.get("val6").toString());
            	   urlParameters2.append("\",\"SET_VAL7\":\"");
            	   urlParameters2.append(params.get("val7").toString());
            	   urlParameters2.append("\",\"SET_VAL8\":\"");
            	   urlParameters2.append(params.get("val8").toString());
            	   urlParameters2.append("\",\"SET_VAL9\":\"");
            	   urlParameters2.append(params.get("val9").toString());
            	   urlParameters2.append("\",\"SET_VAL10\":\"");
            	   urlParameters2.append(params.get("val10").toString());
            	   urlParameters2.append("\",\"SET_VAL11\":\"");
            	   urlParameters2.append(params.get("val11").toString()+"\"");
//	            	   System.out.println("apiCall param update:" + urlParameters2.toString());
//	            	   service.insert("TmpLogInsert",params);
            	   // For POST only - START
            	   conn2.setDoOutput(true);
            	   OutputStream os2 = conn2.getOutputStream();
            	   String encodedParams = URLEncoder.encode(urlParameters2.toString(), StandardCharsets.UTF_8.toString());

            	   // 인코딩된 파라미터를 바이트로 변환하여 OutputStream에 씁니다.
            	   os2.write(encodedParams.getBytes(StandardCharsets.UTF_8));
            	   os2.flush();
            	   os2.close();
            	   // For POST only - END
            	   int responseCode2 = conn2.getResponseCode();
            	   System.out.println("POST Response Code :: " + responseCode2);
            	   
            	   if (responseCode2 == HttpURLConnection.HTTP_OK) { //success
            		   BufferedReader in2 = new BufferedReader(new InputStreamReader(conn2.getInputStream()));
            		   String inputLine2;
            		   StringBuffer response2 = new StringBuffer();
            		   
            		   while ((inputLine2 = in2.readLine()) != null) {
            			   response2.append(inputLine2);
            		   }
            		   in2.close();
            		   System.out.println("apiASCall result update:" + response2.toString());
            		   String[] rpArr2 = response2.toString().replaceAll("\"", "").split(",");
            		   // 모델에 객체를 추가한다.
//	            		   params.put("ret", rpArr2[0]);
//	            		   service.update("TmpLogUpdate",params);
            		   //addObject(model,rpArr2[0]);
            		   rst = rpArr2[0];
            	   }
               }
            } else {
            	rst = "Fail";
            }
            
		} catch (Exception e){
			System.err.println(e.toString());
		} 
	    
	    // 뷰이름을 반환한다.
	    return rst;
	}
	
	@RequestMapping(value = "/apiAskeyCall.json")
	public String apiAsKeyCall(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String rst = "";
		StringBuffer urlParameters = new StringBuffer();
		StringBuffer urlParameters2 = new StringBuffer();
		String tokenNo = "";
		try {
			URL obj = new URL(as_path + "common/ftk/issuelsdp2.do");
			
			//URL obj = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/issuelsdp2.do");
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            urlParameters.append("USER_ID=");
            urlParameters.append(params.get("userId").toString());
            
            // For POST only - START
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(urlParameters.toString().getBytes( StandardCharsets.UTF_8));
            os.flush();
            os.close();
            // For POST only - END

            int responseCode = conn.getResponseCode();
            System.out.println("POST Response Code :: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) { //success
               BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
               String inputLine;
               StringBuffer response = new StringBuffer();
               while ((inputLine = in.readLine()) != null) {
            	   response.append(inputLine);
               }
               in.close();
               System.out.println("apiAsCall result token:" + response.toString());
               String[] rpArr = response.toString().replaceAll("\"", "").split(",");
               if(rpArr[1].indexOf("SUCCESS") != -1){
            	   tokenNo = rpArr[0].substring(rpArr[0].indexOf(":")+1);
            	   params.put("token", tokenNo);
            	   //URL obj2 = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/lsdp_ordr_upd");
            	   URL obj2 = new URL(as_path + "common/ftk/lsdp_ordr_upd");
            	   HttpURLConnection conn2 = (HttpURLConnection) obj2.openConnection();
            	   conn2.setRequestMethod("POST");
            	   conn2.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            	   conn2.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            	   urlParameters2.append("\"USER_ID\":\"");
            	   urlParameters2.append(params.get("userId").toString());
            	   urlParameters2.append("\",\"TOKEN_NO\":\"" + tokenNo);
            	   urlParameters2.append("\",\"ORDR_NO\":\"");
            	   urlParameters2.append(params.get("ordr_no").toString());
            	   urlParameters2.append("\",\"ASSY_NO\":\"");
            	   urlParameters2.append(params.get("assy_no").toString());
            	   urlParameters2.append("\",\"TYPE\":\"");
            	   urlParameters2.append(params.get("type").toString());
            	   urlParameters2.append("\",\"SET_VAL\":\"");
            	   urlParameters2.append(params.get("val").toString());
            	   urlParameters2.append("\",\"SET_VAL2\":\"");
            	   urlParameters2.append(params.get("val2").toString());
            	   urlParameters2.append("\",\"SET_VAL3\":\"");
            	   urlParameters2.append(params.get("val3").toString());
            	   urlParameters2.append("\",\"SET_VAL4\":\"");
            	   urlParameters2.append(params.get("val4").toString());
            	   urlParameters2.append("\",\"SET_VAL5\":\"");
            	   urlParameters2.append(params.get("val5").toString());
            	   urlParameters2.append("\",\"SET_VAL6\":\"");
            	   urlParameters2.append(params.get("val6").toString());
            	   urlParameters2.append("\",\"SET_VAL7\":\"");
            	   urlParameters2.append(params.get("val7").toString());
            	   urlParameters2.append("\",\"SET_VAL8\":\"");
            	   urlParameters2.append(params.get("val8").toString());
            	   urlParameters2.append("\",\"SET_VAL9\":\"");
            	   urlParameters2.append(params.get("val9").toString());
            	   urlParameters2.append("\",\"SET_VAL10\":\"");
            	   urlParameters2.append(params.get("val10").toString());
            	   urlParameters2.append("\",\"SET_VAL11\":\"");
            	   urlParameters2.append(params.get("val11").toString()+"\"");
//	            	   System.out.println("apiCall param update:" + urlParameters2.toString());
//	            	   service.insert("TmpLogInsert",params);
            	   // For POST only - START
            	   conn2.setDoOutput(true);
            	   OutputStream os2 = conn2.getOutputStream();
            	   os2.write(urlParameters2.toString().getBytes( StandardCharsets.UTF_8));
            	   os2.flush();
            	   os2.close();
            	   // For POST only - END
            	   int responseCode2 = conn2.getResponseCode();
            	   System.out.println("POST Response Code :: " + responseCode2);
            	   
            	   if (responseCode2 == HttpURLConnection.HTTP_OK) { //success
            		   BufferedReader in2 = new BufferedReader(new InputStreamReader(conn2.getInputStream()));
            		   String inputLine2;
            		   StringBuffer response2 = new StringBuffer();
            		   
            		   while ((inputLine2 = in2.readLine()) != null) {
            			   response2.append(inputLine2);
            		   }
            		   in2.close();
            		   System.out.println("apiASCall result update:" + response2.toString());
            		   String[] rpArr2 = response2.toString().replaceAll("\"", "").split(",");
            		   // 모델에 객체를 추가한다.
//	            		   params.put("ret", rpArr2[0]);
//	            		   service.update("TmpLogUpdate",params);
            		   addObject(model,response2.toString());
            	   }
               }
            } else {
            	rst = "Fail";
            }
            
		} catch (Exception e){
			System.err.println(e.toString());
		} 
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/apiLogiKeyCall.json")
	public String apiLogiKeyCall(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		StringBuffer urlParameters = new StringBuffer();
		StringBuffer urlParameters2 = new StringBuffer();
		String tokenNo = "";
		try {
			URL obj = new URL(logi_path + "common/ftk/issuelslogi.do");
			
			//URL obj = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/issuelsdp2.do");
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            urlParameters.append("USER_ID=");
            urlParameters.append(params.get("userId").toString());
            
            // For POST only - START
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(urlParameters.toString().getBytes( StandardCharsets.UTF_8));
            os.flush();
            os.close();
            // For POST only - END

            int responseCode = conn.getResponseCode();
            System.out.println("POST Response Code :: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) { //success
               BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
               String inputLine;
               StringBuffer response = new StringBuffer();
               while ((inputLine = in.readLine()) != null) {
                  response.append(inputLine);
               }
               in.close();
               System.out.println("apiKeyCall result token:" + response.toString());
               String[] rpArr = response.toString().replaceAll("\"", "").split(",");
               
               if(rpArr[1].indexOf("SUCCESS") != -1){
            	   tokenNo = rpArr[0].substring(rpArr[0].indexOf(":")+1);
            	   params.put("token", tokenNo);
            	   //URL obj2 = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/lsdp_ordr_upd");
            	   URL obj2 = new URL(logi_path + "common/ftk/lslogi_gate_select");
            	   HttpURLConnection conn2 = (HttpURLConnection) obj2.openConnection();
            	   conn2.setRequestMethod("POST");
            	   conn2.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            	   conn2.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            	   
            	   urlParameters2.append("\"USER_ID\":\"");
            	   urlParameters2.append(params.get("userId").toString());
            	   urlParameters2.append("\",\"BOL_NO\":\"");
            	   urlParameters2.append(params.get("bol_no").toString());
            	   urlParameters2.append("\",\"API_KEY\":\"");
            	   urlParameters2.append(params.get("api_key").toString());
            	   urlParameters2.append("\",\"TYPE\":\"");
            	   urlParameters2.append(params.get("type").toString());
            	   urlParameters2.append("\",\"SET_VAL\":\"");
            	   urlParameters2.append(params.get("val").toString());
            	   urlParameters2.append("\",\"SET_VAL2\":\"");
            	   urlParameters2.append(params.get("val2").toString());
            	   urlParameters2.append("\",\"SET_VAL3\":\"");
            	   urlParameters2.append(params.get("val3").toString());
            	   urlParameters2.append("\",\"SET_VAL4\":\"");
            	   urlParameters2.append(params.get("val4").toString());
            	   urlParameters2.append("\",\"SET_VAL5\":\"");
            	   urlParameters2.append(params.get("val5").toString());
            	   urlParameters2.append("\",\"SET_VAL6\":\"");
            	   urlParameters2.append(params.get("val6").toString());
            	   urlParameters2.append("\",\"SET_VAL7\":\"");
            	   urlParameters2.append(params.get("val7").toString());
            	   urlParameters2.append("\",\"SET_VAL8\":\"");
            	   urlParameters2.append(params.get("val8").toString());
            	   urlParameters2.append("\",\"SET_VAL9\":\"");
            	   urlParameters2.append(params.get("val9").toString());
            	   urlParameters2.append("\",\"SET_VAL10\":\"");
            	   urlParameters2.append(params.get("val10").toString());
            	   urlParameters2.append("\",\"SET_VAL11\":\"");
            	   urlParameters2.append(params.get("val11").toString());
            	   urlParameters2.append("\",\"SET_VAL12\":\"");
            	   urlParameters2.append(params.get("val12").toString());
            	   urlParameters2.append("\",\"SET_VAL13\":\"");
            	   urlParameters2.append(params.get("val13").toString());
            	   urlParameters2.append("\",\"SET_VAL14\":\"");
            	   urlParameters2.append(params.get("val14").toString());
            	   urlParameters2.append("\",\"SET_VAL15\":\"");
            	   urlParameters2.append(params.get("val15").toString()+"\"");
// 	            	   System.out.println("apiCall param update:" + urlParameters2.toString());
// 	            	   service.insert("TmpLogInsert",params);
            	   // For POST only - START
            	   conn2.setDoOutput(true);
            	   OutputStream os2 = conn2.getOutputStream();
            	   os2.write(urlParameters2.toString().getBytes( StandardCharsets.UTF_8));
            	   os2.flush();
            	   os2.close();
            	   // For POST only - END
            	   
            	   int responseCode2 = conn2.getResponseCode();
            	   System.out.println("POST Response Code :: " + responseCode2);
            	   
            	   if (responseCode2 == HttpURLConnection.HTTP_OK) { //success
            		   BufferedReader in2 = new BufferedReader(new InputStreamReader(conn2.getInputStream()));
            		   String inputLine2;
            		   StringBuffer response2 = new StringBuffer();
            		   
            		   while ((inputLine2 = in2.readLine()) != null) {
            			   response2.append(inputLine2);
            		   }
            		   in2.close();
            		   System.out.println("apiKeyCall result update:" + response2.toString());
            		   //String[] rpArr2 = response2.toString().replaceAll("\"", "").split(",");
            		   // 모델에 객체를 추가한다.
// 	            		   params.put("ret", rpArr2[0]);
// 	            		   service.update("TmpLogUpdate",params);
            		   addObject(model,response2.toString());
            	   }
               }
            } else {
            }
            
		} catch (Exception e){
			System.err.println(e.toString());
		} 
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	//TODO order management - assyReTransfer
	@RequestMapping(value = "/apiKeyCall2.json")
	public String apiKeyCall2(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		StringBuffer urlParameters = new StringBuffer();
		StringBuffer urlParameters2 = new StringBuffer();
		String tokenNo = "";
		try {
			URL obj = new URL(pdi_path + "common/ftk/issuelsdp2.do");
			
			//URL obj = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/issuelsdp2.do");
            HttpURLConnection conn = (HttpURLConnection) obj.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            urlParameters.append("USER_ID=");
            urlParameters.append(params.get("userId").toString());
            
            // For POST only - START
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(urlParameters.toString().getBytes( StandardCharsets.UTF_8));
            os.flush();
            os.close();
            // For POST only - END

            int responseCode = conn.getResponseCode();
            System.out.println("POST Response Code :: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) { //success
               BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
               String inputLine;
               StringBuffer response = new StringBuffer();
               while ((inputLine = in.readLine()) != null) {
                  response.append(inputLine);
               }
               in.close();
               System.out.println("apiKeyCall result token:" + response.toString());
               String[] rpArr = response.toString().replaceAll("\"", "").split(",");
               
               if(rpArr[1].indexOf("SUCCESS") != -1){
            	   tokenNo = rpArr[0].substring(rpArr[0].indexOf(":")+1);
            	   params.put("token", tokenNo);
            	   //URL obj2 = new URL("http://cnode.iptime.org:8080/lspdi/common/ftk/lsdp_ordr_upd");
            	   URL obj2 = new URL(pdi_path + "common/ftk/lsdp_ordr_assy_retrans");
            	   HttpURLConnection conn2 = (HttpURLConnection) obj2.openConnection();
            	   conn2.setRequestMethod("POST");
            	   conn2.setRequestProperty("User-Agent", request.getHeader("User-Agent"));
            	   conn2.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            	   
            	   urlParameters2.append("\"USER_ID\":\"");
            	   urlParameters2.append(params.get("userId").toString());
            	   urlParameters2.append("\",\"ORDR_NO\":\"");
            	   urlParameters2.append(params.get("ordr_no").toString());
            	   urlParameters2.append("\",\"API_KEY\":\"");
            	   urlParameters2.append(params.get("api_key").toString());
            	   urlParameters2.append("\",\"TYPE\":\"");
            	   urlParameters2.append(params.get("type").toString());
            	   urlParameters2.append("\",\"SET_VAL\":\"");
            	   urlParameters2.append(params.get("val").toString());
            	   urlParameters2.append("\",\"SET_VAL2\":\"");
            	   urlParameters2.append(params.get("val2").toString());
            	   urlParameters2.append("\",\"SET_VAL3\":\"");
            	   urlParameters2.append(params.get("val3").toString());
            	   urlParameters2.append("\",\"SET_VAL4\":\"");
            	   urlParameters2.append(params.get("val4").toString());
            	   urlParameters2.append("\",\"SET_VAL5\":\"");
            	   urlParameters2.append(params.get("val5").toString());
            	   urlParameters2.append("\",\"SET_VAL6\":\"");
            	   urlParameters2.append(params.get("val6").toString());
            	   urlParameters2.append("\",\"SET_VAL7\":\"");
            	   urlParameters2.append(params.get("val7").toString());
            	   urlParameters2.append("\",\"SET_VAL8\":\"");
            	   urlParameters2.append(params.get("val8").toString());
            	   urlParameters2.append("\",\"SET_VAL9\":\"");
            	   urlParameters2.append(params.get("val9").toString());
            	   urlParameters2.append("\",\"SET_VAL10\":\"");
            	   urlParameters2.append(params.get("val10").toString());
            	   urlParameters2.append("\",\"SET_VAL11\":\"");
            	   urlParameters2.append(params.get("val11").toString()+"\"");
// 	            	   System.out.println("apiCall param update:" + urlParameters2.toString());
// 	            	   service.insert("TmpLogInsert",params);
            	   // For POST only - START
            	   conn2.setDoOutput(true);
            	   OutputStream os2 = conn2.getOutputStream();
            	   os2.write(urlParameters2.toString().getBytes( StandardCharsets.UTF_8));
            	   os2.flush();
            	   os2.close();
            	   // For POST only - END
            	   
            	   int responseCode2 = conn2.getResponseCode();
            	   System.out.println("POST Response Code :: " + responseCode2);
            	   
            	   if (responseCode2 == HttpURLConnection.HTTP_OK) { //success
            		   BufferedReader in2 = new BufferedReader(new InputStreamReader(conn2.getInputStream()));
            		   String inputLine2;
            		   StringBuffer response2 = new StringBuffer();
            		   
            		   while ((inputLine2 = in2.readLine()) != null) {
            			   response2.append(inputLine2);
            		   }
            		   in2.close();
            		   System.out.println("apiKeyCall result update:" + response2.toString());
            		   //String[] rpArr2 = response2.toString().replaceAll("\"", "").split(",");
            		   // 모델에 객체를 추가한다.
// 	            		   params.put("ret", rpArr2[0]);
// 	            		   service.update("TmpLogUpdate",params);
            		   addObject(model,response2.toString());
            	   }
               }
            } else {
            }
            
		} catch (Exception e){
			System.err.println(e.toString());
		} 
	    
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
}
