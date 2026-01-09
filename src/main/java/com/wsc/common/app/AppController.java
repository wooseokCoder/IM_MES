package com.wsc.common.app;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.Map;

import javax.imageio.ImageIO;
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

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.common.user.PasswordService;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;

import groovy.util.logging.Log4j;

@Log4j
@Controller
@RequestMapping("/app")
public class AppController extends BaseController {
	@Value("#{app['sarImg.upload.path']}")
    public String darImg_path;
	
	@Autowired
	private CommonDao dao;
	
	@Autowired 
	private PasswordService passwordService;
	
	@Autowired 
	private AppService appService;
	
	@Autowired 
	private AppService service; //
	
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
	
	//Version Check
	@ResponseBody
	@RequestMapping(value = "/versionCheck", method = RequestMethod.POST)
	public ParamsMap versionCheck(@RequestBody Map<String, Object> data, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		
		ParamsMap params = getParams(request, true);
		params.put("sysId"      , "IMMES");
		params.put("type"       , data.get("type"));
		params.put("app"        , data.get("app"));
		params.put("and"        , data.get("and"));
		params.put("ios"        , data.get("ios"));
		params.put("verData"    , appService.search("versionCheck", params));

		return params;
	}
	
	//app에서 로그인
	@ResponseBody
	@RequestMapping(value = "/login",  method = RequestMethod.POST)
	public ParamsMap login(@RequestBody Map<String, Object> info, HttpServletRequest request, HttpServletResponse response, Model model) {
		ParamsMap params = getParams(request, true);
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");

		SimpleDateFormat format = new SimpleDateFormat ("yyyyMMdd");
		Date today = new Date();

		params.put("sysId"      ,   "IMMES" );
		params.put("userId"     ,   info.get("user_id"));
		params.put("gsUserId"   ,   info.get("user_id"));
		params.put("userPwd"    ,   info.get("user_pwd"));
		params.put("oldPw"      ,   info.get("user_pwd"));
		params.put("progId"     ,   "/app/login");
    	params.put("clientIp"   ,  	request.getRemoteAddr());
    	params.put("clientName" ,	request.getRemoteUser());
    	params.put("clientAgent",  	request.getHeader("User-Agent"));
    	params.put("loginDate"  ,  	format.format(today));
    	params.put("userInfo"   ,   appService.login(params, request));
    	
		return params;
	}
	
	//Menu Check
	@ResponseBody
	@RequestMapping(value = "/menucheck", method = RequestMethod.POST)
	public ParamsMap mMenucheck(@RequestBody Map<String, Object> data, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		
		ParamsMap params = getParams(request, true);
		params.put("sysId"      , "IMMES"                 );
		params.put("userType"   , data.get("userType"   ));
		params.put("userId"     , data.get("userId"     ));
		params.put("ftokenNo"   , data.get("TOKEN_NO"   ));
		
		Object chkToken = null;
        chkToken = appService.select("mTokenCheck", params);
        if(chkToken.equals("SUCCESS")) {
        	params.put("menuData"       , appService.search("menuCheck", params));
        	params.put("checkSF"        , appService.search("getSucc", params));
        }else{
        	params.put("checkSF"        , appService.search("getFail", params));
		}
        
		return params;
	}
	
	//Search
	@ResponseBody
	@RequestMapping(value = "/lsasSearch", method = RequestMethod.POST)
	public ParamsMap mlsasSearch(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request, true);

		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object chkToken = null;
        chkToken = appService.select("mTokenCheck", params);
        if(chkToken.equals("SUCCESS")) {
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
			if(data.containsKey("VAR16")) params.put("var16", data.get("VAR16"));
			else params.put("var16", "");
			if(data.containsKey("VAR17")) params.put("var17", data.get("VAR17"));
			else params.put("var17", "");
			if(data.containsKey("VAR18")) params.put("var18", data.get("VAR18"));
			else params.put("var18", "");
			if(data.containsKey("VAR19")) params.put("var19", data.get("VAR19"));
			else params.put("var19", "");
			if(data.containsKey("VAR20")) params.put("var20", data.get("VAR20"));
			else params.put("var20", "");
			
			params.put("searchData"       , appService.search("ifLsasApp", params));
			params.put("checkSF"   , "SUCCESS");
        }else {
        	params.put("checkSF"   , "FAIL");
		}
		return params;
	}
	
	@ResponseBody
	@RequestMapping(value = "/openPage", method = RequestMethod.POST)
	public ParamsMap mOpenPage(@RequestBody Map<String, Object> data, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		
		ParamsMap params = getParams(request, true);
		params.put("sysId"      , "IMMES"                 );
		if(data.containsKey("val1")) params.put("val1", data.get("val1"));
		else params.put("val1", "");
		if(data.containsKey("val2")) params.put("val2", data.get("val2"));
		else params.put("val2", "");
		if(data.containsKey("val3")) params.put("val3", data.get("val3"));
		else params.put("val3", "");
		if(data.containsKey("val4")) params.put("val4", data.get("val4"));
		else params.put("val4", "");
		if(data.containsKey("val5")) params.put("val5", data.get("val5"));
		else params.put("val5", "");
		if(data.containsKey("val6")) params.put("val6", data.get("val6"));
		else params.put("val6", "");
		if(data.containsKey("val7")) params.put("val7", data.get("val7"));
		else params.put("val7", "");
		if(data.containsKey("val8")) params.put("val8", data.get("val8"));
		else params.put("val8", "");
		if(data.containsKey("val9")) params.put("val9", data.get("val9"));
		else params.put("val9", "");
		if(data.containsKey("val10")) params.put("val10", data.get("val10"));
		else params.put("val10", "");
		if(data.containsKey("val11")) params.put("val11", data.get("val11"));
		else params.put("val11", "");
		if(data.containsKey("val12")) params.put("val12", data.get("val12"));
		else params.put("val12", "");
		if(data.containsKey("val13")) params.put("val13", data.get("val13"));
		else params.put("val13", "");
		if(data.containsKey("val14")) params.put("val14", data.get("val14"));
		else params.put("val14", "");
		if(data.containsKey("val15")) params.put("val15", data.get("val15"));
		else params.put("val15", "");
		
		params.put("userId"     , data.get("userId"     ));
		params.put("ftokenNo"   , data.get("TOKEN_NO"   ));
		
		
		Object chkToken = null;
        chkToken = appService.select("mTokenCheck", params);
        if(chkToken.equals("SUCCESS")) {
        	params.put("openData"       , appService.select("openCreation", params));
        	//comboData
    		params.put("val2"       , "SO_STAT"); 
        	params.put("statData"       , appService.search("mGetSysCode", params));
    		params.put("val2"       , "SO_TYPE"); 
        	params.put("typeData"       , appService.search("mGetSysCode", params));
    		params.put("val2"       , "SO_METD"); 
        	params.put("metdData"       , appService.search("mGetSysCode", params));
    		params.put("val2"       , "ISUE_LEVL");
        	params.put("levelData"      , appService.search("mGetSysCode", params));
    		params.put("val2"       , "SO_POST");
        	params.put("posiData"       , appService.search("mGetSysCode", params));
    		params.put("val2"       , "AREA_CODE");
        	params.put("areaData"       , appService.search("mGetSysCode", params));
    		params.put("val2"       , "ITEM_UNIT");
        	params.put("unitData"       , appService.search("mGetSysCode", params));
        	params.put("nameData"       , appService.search("getNameCombo", params));
        	
        	params.put("checkSF"        , appService.search("getSucc", params));
        }else{
        	params.put("checkSF"        , appService.search("getFail", params));
		}
        
		return params;
	}
	
	@ResponseBody
	@RequestMapping(value = "/darDataCheck", method = RequestMethod.POST)
	public Object darDataCheck(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request, true);

		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object chkToken = null;
        chkToken = appService.select("mTokenCheck", params);
        RecordMap result = new RecordMap();
        if(chkToken.equals("SUCCESS")) {
		params.put("sysId"       , "IMMES");
    		if(data.containsKey("userId"))   params.put("userId"      , data.get("userId"     )); 
			else params.put("userId", "");                                                      
			if(data.containsKey("oper"))     params.put("oper"        , data.get("oper"       )); 
			else params.put("oper", "");                                                      
			if(data.containsKey("darNo"))    params.put("darNo"       , data.get("darNo"      )); 
			else params.put("darNo", "");
			if(data.containsKey("dealer"))   params.put("dealCode"    , data.get("dealer"     )); 
			else params.put("dealCode", "");
			if(data.containsKey("dealName")) params.put("dealName"    , data.get("dealName"   )); 
			else params.put("dealName", "");
			if(data.containsKey("dealType")) params.put("dealType"    , data.get("dealType"   )); 
			else params.put("dealType", "");
			if(data.containsKey("assName"))  params.put("assName"     , data.get("assName"    )); 
			else params.put("assName", "");
			if(data.containsKey("assDate"))  params.put("assDate"     , data.get("assDate"    )); 
			else params.put("assDate", "");			
			result = service.darDataCheck(params);
			result.put("checkSF"   , "SUCCESS");
        }else {
			result.put("checkSF"   , "FAIL");
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/darSave", method = RequestMethod.POST)
	public Object darSave(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) throws Exception  {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request, true);

		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object chkToken = null;
        chkToken = appService.select("mTokenCheck", params);
        RecordMap result = new RecordMap();
        if(chkToken.equals("SUCCESS")) {
		params.put("sysId"       , "IMMES"                 );
    		if(data.containsKey("userId"))   params.put("userId"      , data.get("userId"     )); 
			else params.put("userId", "");                                                      
			if(data.containsKey("oper"))     params.put("oper"        , data.get("oper"       )); 
			else params.put("oper", "");                                                      
			if(data.containsKey("darNo"))    params.put("darNo"       , data.get("darNo"      )); 
			else params.put("darNo", "");
			if(data.containsKey("darRev"))   params.put("darRev"      , data.get("darRev"      )); 
			else params.put("darRev", "");
			if(data.containsKey("evalYear")) params.put("evalYear"    , data.get("evalYear"   )); 
			else params.put("evalYear", "");
			if(data.containsKey("dealer"))   params.put("dealCode"    , data.get("dealer"     )); 
			else params.put("dealCode", "");
			if(data.containsKey("dealName")) params.put("dealName"    , data.get("dealName"   )); 
			else params.put("dealName", "");
			if(data.containsKey("evalSeq"))  params.put("evalSeq"     , data.get("evalSeq"      )); 
			else params.put("evalSeq", "1");
			if(data.containsKey("dealType")) params.put("dealType"    , data.get("dealType"   )); 
			else params.put("dealType", "");
			if(data.containsKey("assName"))  params.put("assName"     , data.get("assName"    )); 
			else params.put("assName", "");
			if(data.containsKey("assDate"))  params.put("assDate"     , data.get("assDate"    )); 
			else params.put("assDate", "");
			if(data.containsKey("evalTot"))  params.put("evalTot"     , data.get("evalTot"    )); 
			else params.put("evalTot", "");
			if(data.containsKey("evalGrad")) params.put("evalGrad"    , data.get("evalGrad"    )); 
			else params.put("evalGrad", "");
			if(data.containsKey("histRemk")) params.put("histRemk"    , data.get("histRemk"    )); 
			else params.put("histRemk", "");
			if(data.containsKey("progStat")) params.put("progStat"    , data.get("progStat"    )); 
			else params.put("progStat", "1");
			if(data.containsKey("sign1"))    params.put("sign1"       , data.get("sign1"   ));
			else params.put("sign1", "");
			if(data.containsKey("sign2"))    params.put("sign2"       , data.get("sign2"   ));
			else params.put("sign2", "");
			if(data.containsKey("sign3"))    params.put("sign3"       , data.get("sign3"   ));
			else params.put("sign3", "");
			if(data.containsKey("sign4"))    params.put("sign4"       , data.get("sign4"   ));
			else params.put("sign4", "");
			if(data.containsKey("sign5"))    params.put("sign5"       , data.get("sign5"   ));
			else params.put("sign5", "");                            
			if(data.containsKey("sign6"))    params.put("sign6"       , data.get("sign6"   ));
			else params.put("sign6", "");                            
			if(data.containsKey("sign7"))    params.put("sign7"       , data.get("sign7"   ));
			else params.put("sign7", "");                            
			if(data.containsKey("sign8"))    params.put("sign8"       , data.get("sign8"   ));
			else params.put("sign8", "");                            
			if(data.containsKey("sign9"))    params.put("sign9"       , data.get("sign9"   ));
			else params.put("sign9", "");                            
			if(data.containsKey("sign10"))   params.put("sign10"      , data.get("sign10"   ));
			else params.put("sign10", "");                          
			if(data.containsKey("sign11"))   params.put("sign11"      , data.get("sign11"   ));
			else params.put("sign11", "");                          
			if(data.containsKey("sign12"))   params.put("sign12"      , data.get("sign12"   ));
			else params.put("sign12", "");
			
			Object chkSave = null;
			chkSave = service.lsasDarSave(params);
			result.put("saveMsg"   , chkSave);
			result.put("checkSF"   , "SUCCESS");
			
			//img save
			Map<String, Object> resultMap = (Map<String, Object>)chkSave;
			params.add("atchNo", resultMap.get("atchNo"));
			params.add("atchSeq", resultMap.get("atchSeq"));
			String atchNo  =  (String) params.get("atchNo");
			String atchSeq =  (String) params.get("atchSeq");
			String[] imageArr = {(String) params.get("sign1"), (String) params.get("sign2"), (String) params.get("sign3"), (String) params.get("sign4"), (String) params.get("sign5"), (String) params.get("sign6"), (String) params.get("sign7"), (String) params.get("sign8"), (String) params.get("sign9"), (String) params.get("sign10"), (String) params.get("sign11"), (String) params.get("sign12")};
			for(int i=0; i < 12; i++){
				if(imageArr[i].equals("")){
					
				} else {
					String darImg = atchNo + "_" + atchSeq + "_" + (i+1);
					String imageData = imageArr[i];
					String base64Data = imageData.split(",")[1];
					
					byte[] decodedBytes = Base64.getDecoder().decode(base64Data);
					ByteArrayInputStream bis = new ByteArrayInputStream(decodedBytes);
					BufferedImage image = ImageIO.read(bis);

					File outputFile = new File(darImg_path+"/"+darImg+".png");
					if(outputFile.exists()) {
						if(outputFile.delete()) {
							System.out.println(darImg+" File delete succeed.");
							ImageIO.write(image, "png", outputFile);
						} else {
							System.out.println(darImg+" Failed to delete file.");
						}
					} else {
						ImageIO.write(image, "png", outputFile);
					}
				}
			}
        }else {
			result.put("checkSF"   , "FAIL");
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/openDarEvalPage", method = RequestMethod.POST)
	public ParamsMap mOpenDarEvalPage(@RequestBody Map<String, Object> data, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
		
		ParamsMap params = getParams(request, true);
		params.put("sysId"      , "IMMES"                 );
		if(data.containsKey("val1"))  params.put("val1",  data.get("val1"));
		else params.put("val1", "");
		if(data.containsKey("val2"))  params.put("val2",  data.get("val2"));
		else params.put("val2", "");
		if(data.containsKey("val3"))  params.put("val3",  data.get("val3"));
		else params.put("val3", "");
		if(data.containsKey("val4"))  params.put("val4",  data.get("val4"));
		else params.put("val4", "");
		if(data.containsKey("val5"))  params.put("val5",  data.get("val5"));
		else params.put("val5", "");
		if(data.containsKey("val6"))  params.put("val6",  data.get("val6"));
		else params.put("val6", "");
		if(data.containsKey("val7"))  params.put("val7",  data.get("val7"));
		else params.put("val7", "");
		if(data.containsKey("val8"))  params.put("val8",  data.get("val8"));
		else params.put("val8", "");
		if(data.containsKey("val9"))  params.put("val9",  data.get("val9"));
		else params.put("val9", "");
		if(data.containsKey("val10")) params.put("val10", data.get("val10"));
		else params.put("val10", "");
		if(data.containsKey("val11")) params.put("val11", data.get("val11"));
		else params.put("val11", "");
		if(data.containsKey("val12")) params.put("val12", data.get("val12"));
		else params.put("val12", "");
		if(data.containsKey("val13")) params.put("val13", data.get("val13"));
		else params.put("val13", "");
		if(data.containsKey("val14")) params.put("val14", data.get("val14"));
		else params.put("val14", "");
		if(data.containsKey("val15")) params.put("val15", data.get("val15"));
		else params.put("val15", "");
		
		params.put("userId"     , data.get("userId"     ));
		params.put("ftokenNo"   , data.get("TOKEN_NO"   ));
		
		Object chkToken = null;
        chkToken = appService.select("mTokenCheck", params);
        if(chkToken.equals("SUCCESS")) {
        	params.put("openData"       , appService.select("openDarEval", params));
        	params.put("val2"           , "DAR_EVAL_LIST");
        	params.put("openData2"      , appService.search("openDarEval", params));
        	
        	params.put("checkSF"        , appService.search("getSucc", params));
        }else{
        	params.put("checkSF"        , appService.search("getFail", params));
		}
        
		return params;
	}
	
	@ResponseBody
	@RequestMapping(value = "/darEvalSave", method = RequestMethod.POST)
	public Object darEvalSave(@RequestBody Map<String, Object> data, HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		response.setHeader("Access-Control-Allow-Origin", "*"); 
		response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request, true);

		params.put("userId"         , data.get("userId"));
		params.put("ftokenNo"       , data.get("TOKEN_NO"));
		
		Object chkToken = null;
        chkToken = appService.select("mTokenCheck", params);
        RecordMap result = new RecordMap();
        if(chkToken.equals("SUCCESS")) {
		params.put("sysId"       , "IMMES"                 );
    		if(data.containsKey("userId"))   params.put("userId"      , data.get("userId"     )); 
			else params.put("userId", "");                                                 
			if(data.containsKey("darNo"))    params.put("darNo"       , data.get("darNo"      )); 
			else params.put("darNo", "");
			if(data.containsKey("darRev"))   params.put("darRev"      , data.get("darRev"     )); 
			else params.put("darRev", "");
			if(data.containsKey("evalYear")) params.put("evalYear"    , data.get("evalYear"   )); 
			else params.put("evalYear", "");
			if(data.containsKey("dealer"))   params.put("dealCode"    , data.get("dealer"     )); 
			else params.put("dealCode", "");
			if(data.containsKey("evalSeq"))  params.put("evalSeq"     , data.get("evalSeq"    )); 
			else params.put("evalSeq", "1");
			if(data.containsKey("dealType")) params.put("dealType"    , data.get("dealType"   )); 
			else params.put("dealType", "");
			if(data.containsKey("clasCode")) params.put("clasCode"    , data.get("clasCode"   )); 
			else params.put("clasCode", "");
			if(data.containsKey("itemNo"))   params.put("itemNo"      , data.get("itemNo"     )); 
			else params.put("itemNo", "");
			if(data.containsKey("itemEval")) params.put("itemEval"    , data.get("itemEval"   )); 
			else params.put("itemEval", "");
			if(data.containsKey("rsltRemk")) params.put("rsltRemk"    , data.get("rsltRemk"   )); 
			else params.put("rsltRemk", "");
			if(data.containsKey("delYn"))    params.put("delYn"       , data.get("delYn"      )); 
			else params.put("delYn", "");
			if(data.containsKey("rsltYn"))   params.put("rsltYn"      , data.get("rsltYn"      )); 
			else params.put("rsltYn", "");
			
			Object chkSave = null;
			chkSave = service.lsasDarEvalSave(params);
			result.put("saveMsg"   , chkSave);
			result.put("checkSF"   , "SUCCESS");
        }else {
			result.put("checkSF"   , "FAIL");
		}
		return result;
	}

}
