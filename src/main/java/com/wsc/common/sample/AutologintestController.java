package com.wsc.common.sample;

import javax.inject.Provider;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.ftk.TokenService;
import com.wsc.common.mail.MailService;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.model.RecordMap;

/**
 * Auto Login Test Controller
 */
@Controller
@RequestMapping("/common/sample")
public class AutologintestController extends BaseController {
	
	@Autowired 
	private AutologintestService service;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	
	@Autowired
	private TokenService tkService;
	
	@Autowired
	private MailService mailService;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	/**
	 * Auto Login Test 페이지 오픈
	 */
	@RequestMapping(value = "/autologintest.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}
	
	/**
	 * 자동 로그인 테스트 (실제 로그인 처리)
	 */
	@RequestMapping(value = "/autologintest/autologin.do")
	public String autoLogin(HttpServletRequest request, HttpServletResponse response, Model model) {
		ParamsMap params = getParams(request);
		
		// 파라메터 복호화(Base64디코딩) 후 재설정
		params = tkService.getDecodeParams(request, params);
		
		if (params.containsKey("userId") && params.containsKey("TOKEN_NO")) {
			String id = params.get("userId").toString();
			String tokenNo = params.get("TOKEN_NO").toString();
			
			params.put("userId", id);
			params.put("ftokenNo", tokenNo);
			
			HttpSession session = request.getSession();
			if (params.containsKey("TEMP_ID")) {
				session.setAttribute("tempId", params.get("TEMP_ID").toString());
			}
			
			Object token = tkService.select("validateToken2", params);
			
			model.addAttribute("ssoUserId", id);
			if (token != null && token.equals("SUCCESS")) {
				model.addAttribute("token", "Y");
				
				// MENU가 있으면 im_mesMenu 쿠키에 저장
				if (params.containsKey("MENU")) {
					String menu = params.get("MENU").toString();
					Cookie setCookie = new Cookie("im_mesMenu", menu);
					setCookie.setPath("/");
					setCookie.setMaxAge(60*60); // 기간을 1시간으로 지정
					response.addCookie(setCookie);
				}
				
				return "loginsso";
			} else {
				model.addAttribute("token", "N");
				model.addAttribute("message", "Auto login failed: Token validation failed");
			}
		} else {
			model.addAttribute("token", "N");
			model.addAttribute("message", "Auto login failed: Missing parameters");
		}
		
		return "common/sample/autologintestresult";
	}
	
	/**
	 * 자동 로그인 메일 발송
	 */
	@RequestMapping(value = "/autologintest/sendEmail.json")
	public String sendEmail(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		String userId = params.get("userId") != null ? params.get("userId").toString() : "";
		String emailAddress = params.get("emailAddress") != null ? params.get("emailAddress").toString() : "";
		String targetUrl = params.get("targetUrl") != null ? params.get("targetUrl").toString() : "";
		
		if (userId.isEmpty() || emailAddress.isEmpty() || targetUrl.isEmpty()) {
			model.addAttribute("success", false);
			model.addAttribute("message", "Missing required parameters");
			return "jsonView";
		}
		
		try {
			// 1. 토큰 생성
			params.put("sysId", "IMMES");
			params.put("issuUrl", "/common/sample/autologintest.do");
			params.put("rqstUrl", "/common/sample/autologintest/autologin.do");
			
			RecordMap tokenResult = (RecordMap) service.select("createTokenForTest", params);
			if (tokenResult == null || tokenResult.get("TOKEN_NO") == null) {
				model.addAttribute("success", false);
				model.addAttribute("message", "Token creation failed");
				return "jsonView";
			}
			
			String tokenNo = tokenResult.get("TOKEN_NO").toString();
			
			// 2. URL 경로로 메뉴 키 찾기 (lsdp 방식)
			String menuKey = null;
			try {
				ParamsMap menuParams = new ParamsMap();
				menuParams.put("sysId", "IMMES");
				menuParams.put("menuUrl", targetUrl);
				Object result = service.select("getMenuKeyByUrl", menuParams);
				if (result != null) {
					menuKey = result.toString();
				}
			} catch (Exception e) {
				// 메뉴 키를 찾지 못한 경우 URL 경로 사용
				e.printStackTrace();
			}
			
			// 메뉴 키를 찾았으면 메뉴 키 사용, 없으면 URL 경로 사용
			String goMenu = (menuKey != null && !menuKey.isEmpty()) ? menuKey : targetUrl;
			
			// 3. 메일 HTML 생성 (TOKEN_VAL은 MailService에서 교체됨)
			String mailSubject = "Auto Login Link - " + userId;
			String mailBody = generateAutoLoginEmailHtml(request, userId, targetUrl);
			
			// 4. 메일 발송
			ParamsMap mailParams = new ParamsMap();
			mailParams.put("mail_to2", emailAddress);
			mailParams.put("bordTitle2", mailSubject);
			mailParams.put("bordText2", mailBody);
			mailParams.put("mail_cc2", "");
			mailParams.put("mail_bcc2", "");
			mailParams.put("user_id", userId);
			mailParams.put("token", tokenNo);
			mailParams.put("goMenu", goMenu); // 메뉴 키 또는 URL 경로를 MENU로 전달
			mailParams.put("tempId", ""); // MailService에서 사용하는 tempId 파라미터 추가
			mailParams.put("mailId", ""); // MailService에서 사용하는 mailId 파라미터 추가 (NullPointerException 방지)
			
			mailService.lstaNdaMail(mailParams);
			
			model.addAttribute("success", true);
			model.addAttribute("message", "Email sent successfully");
			model.addAttribute("emailAddress", emailAddress);
			model.addAttribute("targetUrl", targetUrl);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("success", false);
			model.addAttribute("message", "Error: " + e.getMessage());
		}
		
		return "jsonView";
	}
	
	/**
	 * 자동 로그인 메일 HTML 생성
	 */
	private String generateAutoLoginEmailHtml(HttpServletRequest request, String userId, String targetUrl) {
		StringBuffer content = new StringBuffer();
		
		// Base URL 생성
		String scheme = request.getScheme();
		String serverName = request.getServerName();
		int serverPort = request.getServerPort();
		String contextPath = request.getContextPath();
		
		String baseUrl = scheme + "://" + serverName;
		if ((scheme.equals("http") && serverPort != 80) || (scheme.equals("https") && serverPort != 443)) {
			baseUrl += ":" + serverPort;
		}
		baseUrl += contextPath;
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>Auto Login</title>");
		content.append("</head>");
		content.append("<body style=\"font-family: Arial, sans-serif; padding: 20px; background-color: #f5f5f5;\">");
		content.append("<div style=\"max-width: 600px; margin: 0 auto; background-color: white; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);\">");
		
		content.append("<h1 style=\"color: #002658; margin-bottom: 20px;\">Auto Login Link</h1>");
		content.append("<p style=\"color: #666; margin-bottom: 20px;\">Hello, <strong>" + userId + "</strong></p>");
		content.append("<p style=\"color: #666; margin-bottom: 20px;\">Click the button below to automatically log in and access the following page:</p>");
		content.append("<p style=\"color: #666; margin-bottom: 30px;\"><strong>Target Page:</strong> " + targetUrl + "</p>");
		
		// 자동 로그인 링크 생성 (TOKEN_VAL은 MailService에서 교체됨)
		String autoLoginUrl = baseUrl + "/common/sample/autologintest/autologin.do?auth=TOKEN_VAL";
		
		content.append("<div style=\"text-align: center; margin: 30px 0;\">");
		content.append("<a href=\"" + autoLoginUrl + "\" target=\"_self\" style=\"display: inline-block; padding: 15px 30px; background-color: #002658; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;\">Go to Application</a>");
		content.append("</div>");
		
		content.append("<p style=\"color: #999; font-size: 12px; margin-top: 30px;\">This link will expire after a certain period. If you did not request this email, please ignore it.</p>");
		
		content.append("</div>");
		content.append("</body>");
		content.append("</html>");
		
		return content.toString();
	}
}
