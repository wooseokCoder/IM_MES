package com.wsc.saml;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.PrivateKey;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.wsc.common.code.CacheComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

import org.opensaml.core.config.InitializationException;
import org.opensaml.core.config.InitializationService;
import org.opensaml.security.credential.AbstractCredential;
import org.opensaml.security.credential.BasicCredential;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Controller
@RequestMapping("/saml")
public class SamlSsoController extends BaseController {
	
	@Autowired 
	private SamlSsoService SamlSsoService;
	
	@Autowired 
	private CacheComponent cache;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return null;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
    @Value("#{app['sfdc.mobile.addr']}")
    private String SFDC_MOBILE_URL;
    
    private static final Logger logger = LoggerFactory.getLogger(SamlSsoController.class);
	
	@RequestMapping(value = "/ssoservice.do")
	public String open(HttpServletRequest request, HttpServletResponse response, Model model) throws IOException {
		ParamsMap params = getParams(request);
		Object result = SamlSsoService.select("selectSalesforceInfo",params);
		model.addAttribute("gsUserId", params.get("gsUserId"));
		model.addAttribute("selectClient",result);
		
		String contextPath = request.getContextPath();
		
		response.sendRedirect(contextPath + "/saml/idp/sso?iframeNm="+params.getString("iframeNm")+"&target="+params.getString("target"));
		return super.getViewName();
	}
	
	@RequestMapping("/idp/login-to-salesforce")
	public void startSso(HttpServletRequest request, HttpServletResponse response) throws IOException {
		ParamsMap params = getParams(request);
		
	    String email = (String) params.get("gsUserId");
	    String contextPath = request.getContextPath();
	    
	    if (email == null) {
	    	response.sendRedirect(contextPath + "/login");
	    } else {
	    	response.sendRedirect(contextPath + "/saml/idp/sso?iframeNm="+params.getString("iframeNm")+"&target="+params.getString("target"));
	    }
	}
	
	@RequestMapping("/idp/sso")
	public void sso(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ParamsMap params = getParams(request);
		String userId = (String) params.get("gsUserId");
		
		String contextPath = request.getContextPath();
		
        if (userId == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }
        
        String audience = "";
        String acsUrl   = "";
        String issuer   = "";
        String idSfdc   = "";
        String privKey  = "";
        String cert     = "";
        
        Map<String, Object> ssoInfo = (Map<String, Object>) SamlSsoService.select("selectSalesforceInfo", params);

        if (ssoInfo == null || ssoInfo.isEmpty()) {
            System.out.println("SSO 정보가 없습니다.");
        } else {
            audience = (String) ssoInfo.get("audience");
            acsUrl   = (String) ssoInfo.get("acsUrl");
            issuer   = (String) ssoInfo.get("issuer");
            idSfdc   = (String) ssoInfo.get("idSfdc");
            privKey  = (String) ssoInfo.get("privKey");
            cert     = (String) ssoInfo.get("cert");
        }
        
        // OpenSAML 초기화
        SamlInitializer.initialize();
        
        // 키 로딩
        PrivateKey privateKey = (PrivateKey) KeyLoader.loadPrivateKey(privKey);
        X509Certificate certificate = (X509Certificate) KeyLoader.loadCertificate(cert);
        BasicCredential credential = new BasicCredential(certificate.getPublicKey(), privateKey);
        
        // SAML 응답 생성
        SamlResponseGenerator generator = new SamlResponseGenerator(credential);
        String samlXml = generator.generate(idSfdc, audience, acsUrl, issuer, privKey, cert);
        String encoded = Base64.getEncoder().encodeToString(samlXml.getBytes(StandardCharsets.UTF_8));
        
        // HTML Form POST
        String targetUrl = params.getString("target").isEmpty() ? acsUrl : params.getString("target");
        String iframeNm = params.getString("iframeNm").isEmpty() ? "_blank" : params.getString("iframeNm");
        System.out.println("targetUrl : " + targetUrl);
        response.setContentType("text/html");
        response.getWriter().write(String.format(
        	    "<html><body onload='document.forms[0].submit()'>"
        	  + "<form method='post' id='samlPoster' action='" + targetUrl + "' target='"+iframeNm+"'>"
        	  + "<input type='hidden' name='SAMLResponse' id='SAMLResponse' value='%s'/>"
        	  + "</form>"
        	  + "</body></html>",
        	  encoded));
	}
	
	@RequestMapping("/idp/sso-silent")
	public void ssoSilent(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ParamsMap params = getParams(request);
		Object info = SamlSsoService.select("selectSfdcInfo",params);
		String sfdcFlag = null;
		String userEmail = null;
		if (info instanceof java.util.Map) {
			java.util.Map map = (java.util.Map) info;
			Object flag = map.get("sfdcFlag");
			if (flag != null) sfdcFlag = String.valueOf(flag);

			Object id = map.get("idSfdc");
			if (id != null) userEmail = String.valueOf(id);
		}
		if (sfdcFlag == null || !"Y".equalsIgnoreCase(sfdcFlag)) {
			response.setStatus(HttpServletResponse.SC_NO_CONTENT);
			return;
		}
		if (userEmail == null || userEmail.trim().isEmpty()) {
			response.setStatus(HttpServletResponse.SC_NO_CONTENT);
			return;
		}
		
		// OpenSAML 초기화
		SamlInitializer.initialize();
		
		// 키 로딩
		PrivateKey privateKey = (PrivateKey) KeyLoader.loadPrivateKey("certification/lsbas_private.key");
		X509Certificate certificate = (X509Certificate) KeyLoader.loadCertificate("certification/lsbas_cert.pem");
		BasicCredential credential = new BasicCredential(certificate.getPublicKey(), privateKey);
		
		String audience = "https://dealerportaldev.lstractorusa.com/lsbas";
		String acsUrl   = "https://lsmtron--fs.sandbox.my.site.com/PartnerPortal/login";
		String issuer   = "https://dealerportal.lstractorusa.com/lsbas";
		String privKey  = "certification/lsbas_private.key";
        String cert     = "certification/lsbas_cert.pem";
        
		// SAML 응답 생성
		SamlResponseGenerator generator = new SamlResponseGenerator(credential);
		String samlXml = generator.generate(userEmail, audience, acsUrl, issuer, privKey, cert);
		String encoded = Base64.getEncoder().encodeToString(samlXml.getBytes(StandardCharsets.UTF_8));
		
		// HTML Form POST
		response.setContentType("text/html");
		response.getWriter().write(String.format(
		    "<html><body onload='document.forms[0].submit()'>"
		  + "<form method='post' id='samlPoster' action='" + acsUrl + "'>"
		  + "<input type='hidden' name='SAMLResponse' id='SAMLResponse' value='%s'/>"
		  + "</form></body></html>",
		  encoded));
	}
	
	@RequestMapping("/sessionCheck")
    public ResponseEntity<Map<String, Object>> checkSession(HttpServletRequest request) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date current = new Date(System.currentTimeMillis() );
		logger.info("############# SFDC SSO START ( {} ) #############", dateFormat.format(current));
		
		ParamsMap params = getParams(request);
		
        Map<String, Object> result = new HashMap<String, Object>();

        boolean isValid = false;
        
        if (isValid) {
            result.put("status", "valid");
        } else {
            try {
            	String audience = "";
                String acsUrl   = "";
                String issuer   = "";
                String idSfdc   = "";
                String privKey  = "";
                String cert     = "";
                
                Map<String, Object> ssoInfo = (Map<String, Object>) SamlSsoService.select("selectSalesforceInfo", params);

                if (ssoInfo == null || ssoInfo.isEmpty()) {
                    System.out.println("SSO 정보가 없습니다.");
                } else {
                    audience = (String) ssoInfo.get("audience");
                    acsUrl   = (String) ssoInfo.get("acsUrl");
                    issuer   = (String) ssoInfo.get("issuer");
                    idSfdc   = (String) ssoInfo.get("idSfdc");
                    privKey  = (String) ssoInfo.get("privKey");
                    cert     = (String) ssoInfo.get("cert");
                }
                
                logger.debug("##### audience : {}", audience);
                logger.debug("##### acsUrl : {}", acsUrl);
                logger.debug("##### issuer : {}", issuer);
                logger.debug("##### idSfdc : {}", idSfdc);
                
                // OpenSAML 초기화
                SamlInitializer.initialize();
                
                // 키 로딩
                PrivateKey privateKey = (PrivateKey) KeyLoader.loadPrivateKey(privKey);
                X509Certificate certificate = (X509Certificate) KeyLoader.loadCertificate(cert);
                BasicCredential credential = new BasicCredential(certificate.getPublicKey(), privateKey);
                
                // SAML 응답 생성
                SamlResponseGenerator generator = new SamlResponseGenerator(credential);
                String samlXml = generator.generate(idSfdc, audience, acsUrl, issuer, privKey, cert);
                String encoded = Base64.getEncoder().encodeToString(samlXml.getBytes(StandardCharsets.UTF_8));
                
                result.put("status", "expired");
                result.put("samlResponse", encoded);
                result.put("acsUrl", acsUrl);
                
                logger.debug("##### samlResponse : {}", encoded);

            } catch (Exception e) {
                e.printStackTrace();
                result.put("status", "error");
            }
        }
        
        current = new Date(System.currentTimeMillis() );
        logger.info("############# SFDC SSO END ( {} ) #############", dateFormat.format(current));
        
        return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
    }
	
	@RequestMapping("/idp/mobileSso")
	public void mobileSso(HttpServletRequest request, HttpServletResponse response) throws Exception {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date current = new Date(System.currentTimeMillis() );
		logger.info("############# SFDC MOBILE SSO START ( {} ) #############", dateFormat.format(current));
		
		ParamsMap params = getParams(request);
		String userId = (String) params.get("gsUserId");
		
		String contextPath = request.getContextPath();
		
        if (userId == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }
        
        String audience = "";
        String acsUrl   = "";
        String issuer   = "";
        String idSfdc   = "";
        String privKey  = "";
        String cert     = "";
        
        Map<String, Object> ssoInfo = (Map<String, Object>) SamlSsoService.select("selectSalesforceInfo", params);

        if (ssoInfo == null || ssoInfo.isEmpty()) {
            System.out.println("SSO 정보가 없습니다.");
        } else {
            audience = (String) ssoInfo.get("audience");
            acsUrl   = (String) ssoInfo.get("acsUrlMobile");
            issuer   = (String) ssoInfo.get("issuer");
            idSfdc   = (String) ssoInfo.get("idSfdc");
            privKey  = (String) ssoInfo.get("privKey");
            cert     = (String) ssoInfo.get("cert");
        }
        logger.debug("##### audience : {}", audience);
        logger.debug("##### acsUrl : {}", acsUrl);
        logger.debug("##### issuer : {}", issuer);
        logger.debug("##### idSfdc : {}", idSfdc);
        
        // OpenSAML 초기화
        SamlInitializer.initialize();
        
        // 키 로딩
        PrivateKey privateKey = (PrivateKey) KeyLoader.loadPrivateKey(privKey);
        X509Certificate certificate = (X509Certificate) KeyLoader.loadCertificate(cert);
        BasicCredential credential = new BasicCredential(certificate.getPublicKey(), privateKey);
        
        // SAML 응답 생성
        SamlResponseGenerator generator = new SamlResponseGenerator(credential);
        String samlXml = generator.generate(idSfdc, audience, acsUrl, issuer, privKey, cert);
        String encoded = Base64.getEncoder().encodeToString(samlXml.getBytes(StandardCharsets.UTF_8));
        
        // HTML Form POST
        String targetUrl = params.getString("target").isEmpty() ? acsUrl : params.getString("target");
        
        String retUrl = params.getString("retURL").isEmpty() ? acsUrl : params.getString("retURL");
        if (retUrl.endsWith("mobile-home")) {
        	retUrl += "?dpId="+userId;
		}
        
        response.setContentType("text/html");
        response.getWriter().write(String.format(
        	    "<html><body onload='document.forms[0].submit()'>"
        	  + "<form method='post' id='samlPoster' action='" + targetUrl + "' target='_self'>"
        	  + "<input type='hidden' name='SAMLResponse' id='SAMLResponse' value='%s'/>"
        	  + "<input type='hidden' name='RelayState' value='" + retUrl + "'/>"
        	  + "</form>"
        	  + "</body>"
        	  + "</html>",
        	  encoded));
        
        logger.debug("##### samlResponse : {}", encoded);
        
        current = new Date(System.currentTimeMillis() );
        logger.info("############# SFDC MOBILE SSO END ( {} ) #############", dateFormat.format(current));
	}
	
}

