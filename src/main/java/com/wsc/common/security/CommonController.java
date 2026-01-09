package com.wsc.common.security;

import java.io.IOException;
import java.util.Base64;
import java.util.Base64.Encoder;
import java.util.HashMap;
import java.util.List;

import javax.inject.Provider;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

//import com.mysql.fabric.xmlrpc.base.Param;
import com.wsc.common.app.AppService;
import com.wsc.common.ftk.TokenService;
import com.wsc.common.mail.MailService;
import com.wsc.common.model.Menu;
import com.wsc.common.model.User;
import com.wsc.common.user.MenuService;
import com.wsc.common.user.UserService;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;
import com.wsc.framework.utils.MailUtils;
import com.wsc.framework.utils.RandomUtils;

@Controller
public class CommonController extends BaseController {
	
	@Autowired
	private UserService service;
	@Autowired
	private MenuService menuService;
	@Autowired 
	private TokenService tkService;
	@Autowired 
	private AppService appService;	
	@Autowired 
	private MailService mailService;
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

	@RequestMapping(value = {"/","/index*"})
	public String index(HttpServletRequest request, HttpServletResponse response, Model model) {
		//[WSC2.0] [2015.04 LSH] �긽�떒�젙蹂� �꽕�젙
		initParams(model);
		//EaiUtils.Cont();
		
		Object result = service.search("getUserType", initParams(model));
    	System.out.println("result::::::::::" + result.toString());
    	String sobj = result.toString();
    	sobj = sobj.replace("[", "");
    	sobj = sobj.replace("]", "");
    	Object result2 = service.search("getUserGroup", initParams(model));
    	String sobj2 = result2.toString();
    	sobj2 = sobj2.replace("[", "");
    	sobj2 = sobj2.replace("]", "");
    	
		model.addAttribute("userType", sobj);
		model.addAttribute("userGroup", sobj2);
		
		// dash_type에 따른 index 화면 분기
		User user = (User) model.asMap().get("user");
		String userDashType = user != null ? user.getDashType() : null;
		String indexType = "index"; // 기본값
		
		if(userDashType == null || userDashType.equals("")) {
			// dash_type이 없을 경우 기본 화면
			indexType = "index";
		}
		else if(userDashType.equals("DT01")) {
			// dash_type이 DT01인 경우 기본 index
			indexType = "index";
		}
		else if(userDashType.equals("DT02")) {
			// dash_type이 DT02인 경우 대시보드 화면
			indexType = "index02";
		}
		else {
			// 그 외의 경우 기본 화면
			indexType = "index";
		}
		
		return indexType;
		
	}
	
	@RequestMapping(value = {"/iframeTest"})
	public String indexTest(HttpServletRequest request, Model model) {
		//[WSC2.0] [2015.04 LSH] �긽�떒�젙蹂� �꽕�젙
		initParams(model);
		//EaiUtils.Cont();
		
		Object result = service.search("getUserType", initParams(model));
    	System.out.println("result::::::::::" + result.toString());
    	String sobj = result.toString();
    	sobj = sobj.replace("[", "");
    	sobj = sobj.replace("]", "");
    	Object result2 = service.search("getUserGroup", initParams(model));
    	String sobj2 = result2.toString();
    	sobj2 = sobj2.replace("[", "");
    	sobj2 = sobj2.replace("]", "");
    	
		model.addAttribute("userType", sobj);
		model.addAttribute("userGroup", sobj2);
		

        return "iframeTest";
		//return "index";
	}

	
	@RequestMapping(value = {"/menuOverEvent"})
	public String menuOverEvent(Model model) {
		//[WSC2.0] [2015.04 LSH] �긽�떒�젙蹂� �꽕�젙
		//initParams(model);
		return "menuOverEvent";
	}

	@RequestMapping("/logout")
	public String logout() {
		return "login";
		//return "redirect:/login.do";
	}

	@RequestMapping("/smsreturn")
	public String smsreturn() {
		return "smsreturn";
		//return "redirect:/smsreturn.do";
	}

	@RequestMapping("/loginhelp")
	public String loginhelp() {
		return "loginhelp";
	}
	
	@RequestMapping("/loginTableau")
	public String loginTableau() {

	       // 뷰이름을 반환한다.
	    return "loginTableau";
	}
	
	@RequestMapping("/ReportView")
	public String ReportView() {
		return "ReportView";
	}

	@RequestMapping("/denied")
	public String denied() {
		return "denied";
	}

	@RequestMapping(value="/sitemap.do")
	public String sitemap(Model model) {
		//[WSC2.0] [2015.04 LSH] �긽�떒�젙蹂� �꽕�젙
		initParams(model);
		return "sitemap";
	}

	@RequestMapping(value={"/login*","/login*.do"}, method=RequestMethod.GET)
	public String loginA(HttpServletRequest request, Model model) {
		model.addAttribute(new User());
		
		String uri = request.getRequestURI();
	    String viewName = uri.substring(uri.lastIndexOf("/") + 1).split("\\.")[0];

	    return viewName;  
	}
	
	@RequestMapping(value="/login_sso")
	public String loginsso(HttpServletRequest request ,HttpServletResponse response, Model model) {
		
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = tkService.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		Object token = appService.select("mTokenCheck", params);
		model.addAttribute("ssoUserId", id);
		if(token.equals("SUCCESS")) model.addAttribute("token", "Y");
		else model.addAttribute("token", "N");
		
		if(params.containsKey("MENU")) {
			String menu = params.get("MENU").toString(); 
			//Cookie
			Cookie setCookie = new Cookie("im_mesMenu", menu);
			setCookie.setPath("/");
			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
			response.addCookie(setCookie);
		}
        
		return "loginsso";
	}
	
	//Email 승인용
	@RequestMapping(value="/retnEmail")
	public String retnEmail(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		//response.setHeader("Access-Control-Allow-Origin", "*"); 
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = tkService.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		System.out.println("****************************["+id+"]****************************");
		System.out.println("****************************["+tokenNo+"]****************************");
		Object token = appService.select("mTokenCheck", params);
		model.addAttribute("ssoUserId", id);
		if(token.equals("SUCCESS")) model.addAttribute("token", "Y");
		else model.addAttribute("token", "N");
	    
		if(params.containsKey("MENU")) {
			String menu = params.get("MENU").toString(); 
			//Cookie
			System.out.println("****************************["+menu+"]****************************");
			Cookie setCookie = new Cookie("im_mesMenu", menu);
			setCookie.setPath("/");
			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
			response.addCookie(setCookie);
		}
        
		if(params.containsKey("ORDR_NO")) {
			String ordrNo = params.get("ORDR_NO").toString(); 
			//Cookie
			Cookie setCookie = new Cookie("retnOrdr", ordrNo);
			setCookie.setPath("/");
			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
			response.addCookie(setCookie);
		}
		
		return "loginsso";
	}
	
	//Email 수신거부 페이지 
	@RequestMapping(value="/unsubscribe")
	public String unsubscribeEmail(HttpServletRequest request, Model model) {
		// 모든 url 요청에 대한 cors 허용
		//response.setHeader("Access-Control-Allow-Origin", "*"); 
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = tkService.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		String type = params.get("type").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
//		System.out.println("****************************["+id+"]****************************");
//		System.out.println("****************************["+tokenNo+"]****************************");
		Object token = appService.select("mTokenCheck", params);
		model.addAttribute("ssoUserId", id);
		if(token.equals("SUCCESS")){
			model.addAttribute("token", "Y");
			model.addAttribute("type", type);
			model.addAttribute("userId", id);
			model.addAttribute("sysid", "IMMES");
			return "unsubscribeMail";
		}
		else {
			model.addAttribute("token", "N");
		}
		
		return "loginsso";
	}
	//2021-04-20 메일 수신거부 업데이트
	@RequestMapping(value="/update_main")
	public void updateMail(HttpServletRequest request ,HttpServletResponse response, Model model) {
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = tkService.getDecodeParams(request,params);

		String type = params.get("type").toString();
		String userId = params.get("userId").toString();
		String sysId = params.get("sysId").toString();
		

		
		service.select("unsubscribeMail", params);
		

		
		return;
	}
	
	//Email 승인용
	@RequestMapping(value="/ndaEmail")
	public String nadEmail(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		//response.setHeader("Access-Control-Allow-Origin", "*"); 
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = tkService.getDecodeParams(request,params);
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		HttpSession session = request.getSession();
		session.setAttribute("tempId", params.get("TEMP_ID").toString());
		System.out.println("****************************["+id+"]****************************");
		System.out.println("****************************["+tokenNo+"]****************************");
		Object token = tkService.select("validateToken2", params);
		
		model.addAttribute("ssoUserId", id);
		if(token.equals("SUCCESS")) model.addAttribute("token", "Y");
		else model.addAttribute("token", "N");
	    
		if(params.containsKey("MENU")) {
			String menu = params.get("MENU").toString(); 
			//Cookie
			System.out.println("****************************["+menu+"]****************************");
			Cookie setCookie = new Cookie("im_mesMenu", menu);
			setCookie.setPath("/");
			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
			response.addCookie(setCookie);
		}
		
		return "loginsso";
	}
	
	@RequestMapping(value="/security_check")
	public String securityCheck() {
		return "login";
	}
	
	
	@RequestMapping(value="/changeoldid")
	public String changeOldId(HttpServletRequest request ,HttpServletResponse response, Model model) {
		ParamsMap params = getParams(request);
		System.out.println("TEST"+params);
		model.addAttribute("gsLang", params.get("lang"));
		Object result = service.select("getSelectOldId", params); 
	    model.addAttribute("userId", params.get("userId"));  // ← userId 추가
		model.addAttribute("getSelectOldId",result); //
		return "changeoldid";
	}
	
	@RequestMapping(value={"/changePassword*","/changePassword*.do","/changepassword"})
	public String changePassword(HttpServletRequest request ,HttpServletResponse response, Model model) {
		ParamsMap params = getParams(request);
		System.out.println("TEST"+params);
		model.addAttribute("gsLang", params.get("lang"));
		Object result = service.select("getSelectOldId", params); 
	    model.addAttribute("userId", params.get("userId"));  // ← userId 추가
		model.addAttribute("getSelectOldId",result); //
		
		String uri = request.getRequestURI();
	    String viewName = uri.substring(uri.lastIndexOf("/") + 1).split("\\.")[0];
	    
	    if(!viewName.isEmpty() && viewName.equals("changepassword")) {
	    	viewName = "changePassword";
	    }
	    
	    return viewName;
		//return "changePassword";
	}
	
	@RequestMapping(value="/canvastest")
	public String canvastest() {
		return "canvastest";
	}

	@RequestMapping(value="/frame")
	public String frame(Model model) {
		//[WSC2.0] [2015.04 LSH] �긽�떒�젙蹂� �꽕�젙
		initParams(model);

		//�봽�젅�엫�럹�씠吏� �뿬遺�
		model.addAttribute("frameYn", "Y");

		return "frame";
	}

	@RequestMapping(value="/menu.json")
	public String menu(Model model) {

		ParamsMap params = getParams();
		List<Menu> menus = null;
		String    parent = params.getString("parent");


		if (getSessionComponent().getMenus() != null) {
			menus = getSessionComponent().getMenus();
		}

		else {
			menus = menuService.searchMenuTree(params);
	    	getSessionComponent().saveMenus(menus);
		}


		if (BaseUtils.empty(parent) == false) {

			for (Menu m : menus) {
				if (parent.equals(m.getMenuKey())) {
					model.addAttribute("menu", m);
					break;
				}
			}
		}
		else {
			model.addAttribute("menus", menus);
		}
		return "jsonView";
	}
	
	@RequestMapping(value="/exhibitionRegist")
	public String exhibitionRegist(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
//		System.out.println(params.get("code"));
		Object result = service.search("getExhbnStates", params);
		model.addAttribute("getStates", result);
//		model.addAttribute("test", "1111");
//		addObject(model, result);
		
		return "exhibitionRegist";
	}
	
	@RequestMapping(value = "/getCouponInfo.json")
	public String getCouponInfo(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.select("getCouponInfo", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/getMailCheck.json")
	public String getMailCheck(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.select("getMailCheck", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/saveCustInfo.json")
	public String saveCustInfo(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        //쿠폰번호생성
        //LS-전시회코드-뒷6자리 숫자 알파벳 난수생성
        String ramdomCode = RandomUtils.excuteGenerate();
        String couponCode = "LS-" + params.get("code").toString() + "-" + ramdomCode;
        params.put("couponNo", couponCode);
        HashMap<String, String> result = (HashMap<String, String>) service.select("saveCustInfo", params);
        
        //개발path
        //String path = "http://52.40.215.183:8080/lsdp_data/upload/image/exhbn/"+result.get("exhbnCode")+".png";
        //운영path
        String path = "https://dealerportal.lstractorusa.com/lsdp_data/upload/image/exhbn/"+result.get("exhbnCode")+".png";
        
        //메일양식
	    String bordText = MailUtils.CouponMailForm(result.get("exhbnName"), couponCode, result.get("exhbnEndDate"), path);
	    //메일제목
	    String mailTitle = result.get("exhbnName") + " Coupon!!";
	    
	    params.put("mail_to", params.get("email").toString());
	    params.put("bordTitle",  mailTitle);
	    params.put("bordText", bordText);
	    try {
	    	mailService.couponMail(params);
	    } catch (IOException e) {
	    	// TODO Auto-generated catch block
	    	e.printStackTrace();
	    }
	    
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/getCouponCnt.json")
	public String getCouponCnt(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.select("getCouponCnt", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/getStates.json")
	public String getStates(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
		Object result = service.search("getExhbnStates2", params);

		model.addAttribute("getStates", result);
        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/rejectEmail")
	public String rejectEmail(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        // 파라메터 복호화(Base64디코딩) 후 재설정
     	params = tkService.getDecodeParams(request,params);
     	
     	String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		String rejectMail = params.get("REJECT_MAIL").toString();
		String passTitle = params.get("PASS_TITLE").toString();
		String gpNo = params.get("GP_NO").toString();
		String bolNo = params.get("BOL_NO").toString();
		String PassDate = params.get("Pass_Date").toString();
		String PassTime = params.get("Pass_Time").toString();
		String GATE_USE = params.get("GATE_USE").toString();
		
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		params.put("Cmail", rejectMail);
		params.put("passTitle", passTitle);
		params.put("gpNo", gpNo);
		params.put("bolNo", bolNo);
		params.put("PassDate", PassDate);
		params.put("PassTime", PassTime);
		params.put("GateToUse", GATE_USE);
		
		model.addAttribute("userId", id);
		model.addAttribute("ftokenNo", tokenNo);
		model.addAttribute("Cmail", rejectMail);
		model.addAttribute("passTitle", passTitle);
		model.addAttribute("gpNo", gpNo);
		model.addAttribute("bolNo", bolNo);
		model.addAttribute("PassDate", PassDate);
		model.addAttribute("PassTime", PassTime);
		model.addAttribute("GateToUse", GATE_USE);
		

	    
        // 모델에 객체를 추가한다.
        addObject(model, "A rejection email has been sent.");
        
        // 뷰이름을 반환한다.
        return "rejectEmail";
	}
	
	//페이팔 오픈
	@RequestMapping(value = "/paypal")
	public String paypal(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	//여기서부터
    	return "paypal";
	}
	//Email 승인용
	@RequestMapping(value="/retailEmail")
	public String retailEmail(HttpServletRequest request ,HttpServletResponse response, Model model) {
		// 모든 url 요청에 대한 cors 허용
		//response.setHeader("Access-Control-Allow-Origin", "*"); 
	    // 파라메터를 가져온다.
	    ParamsMap params = getParams(request);
	    
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = tkService.getDecodeParams(request,params);
		
		
		String id = params.get("userId").toString();
		String tokenNo = params.get("TOKEN_NO").toString();
		System.out.println("****************************"+id+"****************************");
		
		params.put("userId", id);
		params.put("ftokenNo", tokenNo);
		HttpSession session = request.getSession();
		System.out.println("****************************["+id+"]****************************");
		System.out.println("****************************["+tokenNo+"]****************************");
		Object token = appService.select("mTokenCheck", params);
		
		model.addAttribute("ssoUserId", id);
		
		if(token.equals("SUCCESS")) model.addAttribute("token", "Y");
		else model.addAttribute("token", "N");
	    
		if(params.containsKey("MENU")) {
			String menu = params.get("MENU").toString(); 
			//Cookie
			System.out.println("****************************["+menu+"]****************************");
			Cookie setCookie = new Cookie("im_mesMenu", menu);
			setCookie.setPath("/");
			setCookie.setMaxAge(60*60); // 기간을 하루로 지정
			response.addCookie(setCookie);
		}
		
		return "loginsso";
	}
	
	@RequestMapping(value={"/mobileLogin*","/mobileLogin*.do"}, method=RequestMethod.GET)
	public String mobileLogin(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
		ParamsMap params = getParams(request);
		
		String retURL = params.getString("retURL");
		model.addAttribute("retURL", retURL);
				
		model.addAttribute(new User());
		
		String uri = request.getRequestURI();
	    String viewName = uri.substring(uri.lastIndexOf("/") + 1).split("\\.")[0];
	    
	    return viewName;
	}
	
	@RequestMapping(value = "/insertLog.json")
	public String insertLog(HttpServletRequest request, Model model) {
		
		initParams(model);

		logSaveSF(request, model);
		
		return "jsonView";
	}
	
	
	
}
