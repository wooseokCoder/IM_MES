package com.wsc.common.sample;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import org.codehaus.jackson.map.ObjectMapper;
import com.lsbas.service.IF_SFDC_DEALER_LSTA_038;
import com.lsbas.service.if_sfdc_dealer_lsta_038.request.IF_SFDC_DEALER_LSTA_038_data;
import com.lsbas.service.if_sfdc_dealer_lsta_038.request.IF_SFDC_DEALER_LSTA_038_request;
import com.lsbas.service.if_sfdc_dealer_lsta_038.response.IF_SFDC_DEALER_LSTA_038_response;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

/**
 * WSDL Test Controller
 */
@Controller
@RequestMapping("/common/sample")
public class WsdlTestController extends BaseController {
	
	@Autowired 
	private javax.inject.Provider<SessionComponent> sessionProvider;
	
	@Autowired
	private WsdlTestService service;
	
	@Autowired(required = false)
	private IF_SFDC_DEALER_LSTA_038 ifSfdcDealerLsta038Service;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	/**
	 * WSDL Test 페이지 오픈
	 */
	@RequestMapping(value = "/wsdltest.do")
	public String open(HttpServletRequest request, Model model) {
		return super.open(request, model);
	}
	
	/**
	 * 서비스별 SOAP XML 템플릿 조회
	 */
	@RequestMapping(value = "/wsdltest/getSoapTemplate.json")
	public String getSoapTemplate(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String serviceName = params.get("serviceName") != null ? params.get("serviceName").toString() : "";
		
		if (serviceName.isEmpty()) {
			model.addAttribute("success", false);
			model.addAttribute("message", "Service name is required");
			return "jsonView";
		}
		
		try {
			String soapTemplate = generateSoapTemplate(serviceName);
			model.addAttribute("success", true);
			model.addAttribute("soapTemplate", soapTemplate);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("success", false);
			model.addAttribute("message", "Error generating SOAP template: " + e.getMessage());
		}
		
		return "jsonView";
	}
	
	/**
	 * SOAP XML 템플릿 생성
	 */
	private String generateSoapTemplate(String serviceName) throws Exception {
		StringBuilder soap = new StringBuilder();
		soap.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service.lsbas.com/\">\n");
		soap.append("   <soapenv:Header/>\n");
		soap.append("   <soapenv:Body>\n");
		soap.append("      <ser:getService>\n");
		soap.append("         <!--Optional:-->\n");
		soap.append("         <arg0>\n");
		
		java.util.Map<String, Object> jsonTemplate = generateTemplate(serviceName);
		
		// JSON 템플릿을 SOAP XML로 변환
		for (java.util.Map.Entry<String, Object> entry : jsonTemplate.entrySet()) {
			String listKey = entry.getKey();
			Object value = entry.getValue();
			
			if (value instanceof java.util.List) {
				soap.append("            <!--Zero or more repetitions:-->\n");
				soap.append("            <").append(listKey).append(">\n");
				
				@SuppressWarnings("unchecked")
				java.util.List<java.util.Map<String, String>> dataList = (java.util.List<java.util.Map<String, String>>) value;
				if (!dataList.isEmpty()) {
					java.util.Map<String, String> dataTemplate = dataList.get(0);
					for (java.util.Map.Entry<String, String> fieldEntry : dataTemplate.entrySet()) {
						soap.append("               <!--Optional:-->\n");
						soap.append("               <").append(fieldEntry.getKey()).append(">").append(fieldEntry.getValue()).append("</").append(fieldEntry.getKey()).append(">\n");
					}
				}
				
				soap.append("            </").append(listKey).append(">\n");
			}
		}
		
		soap.append("         </arg0>\n");
		soap.append("      </ser:getService>\n");
		soap.append("   </soapenv:Body>\n");
		soap.append("</soapenv:Envelope>");
		
		return soap.toString();
	}
	
	/**
	 * 서비스별 Request 템플릿 생성 (JSON 형태, 내부용)
	 */
	private java.util.Map<String, Object> generateTemplate(String serviceName) throws Exception {
		java.util.Map<String, Object> template = new java.util.LinkedHashMap<String, Object>();
		
		if ("IF_SFDC_DEALER_LSTA_038".equals(serviceName)) {
			template.put("MANUAL_LIST", java.util.Arrays.asList(createDataTemplate(com.lsbas.service.if_sfdc_dealer_lsta_038.request.IF_SFDC_DEALER_LSTA_038_data.class)));
		} else if ("IF_SFDC_DEALER_LSTA_040".equals(serviceName)) {
			template.put("LWS_SR_DATA", java.util.Arrays.asList(createDataTemplate(com.lsbas.service.if_sfdc_dealer_lsta_040.request.IF_SFDC_DEALER_LSTA_040_data.class)));
		} else if ("IF_SFDC_DEALER_LSTA_041".equals(serviceName)) {
			template.put("LWS_WR_DATA", java.util.Arrays.asList(createDataTemplate(com.lsbas.service.if_sfdc_dealer_lsta_041.request.IF_SFDC_DEALER_LSTA_041_data.class)));
		} else if ("IF_SFDC_DEALER_LSTA_044".equals(serviceName)) {
			template.put("LWS_WR_DATA", java.util.Arrays.asList(createDataTemplate(com.lsbas.service.if_sfdc_dealer_lsta_044.request.IF_SFDC_DEALER_LSTA_044_data.class)));
		} else if ("IF_SFDC_DEALER_LSTA_046".equals(serviceName)) {
			template.put("LWS_WR_DATA", java.util.Arrays.asList(createDataTemplate(com.lsbas.service.if_sfdc_dealer_lsta_046.request.IF_SFDC_DEALER_LSTA_046_data.class)));
		}
		
		return template;
	}
	
	/**
	 * 리플렉션을 사용하여 클래스의 필드 정보로 템플릿 생성
	 */
	private java.util.Map<String, String> createDataTemplate(Class<?> clazz) {
		java.util.Map<String, String> template = new java.util.LinkedHashMap<String, String>();
		
		try {
			// XmlType의 propOrder를 우선 사용하여 순서 보장
			javax.xml.bind.annotation.XmlType xmlType = clazz.getAnnotation(javax.xml.bind.annotation.XmlType.class);
			if (xmlType != null && xmlType.propOrder() != null && xmlType.propOrder().length > 0) {
				// propOrder에 있는 필드명들을 순서대로 추가
				for (String propName : xmlType.propOrder()) {
					if (!"##default".equals(propName)) {
						template.put(propName, "?");
					}
				}
			} else {
				// propOrder가 없으면 getter 메서드로부터 필드명 추출
				java.lang.reflect.Method[] methods = clazz.getMethods();
				for (java.lang.reflect.Method method : methods) {
					String methodName = method.getName();
					if (methodName.startsWith("get") && methodName.length() > 3 && 
						method.getParameterCount() == 0 && 
						method.getReturnType() == String.class) {
						
						String fieldName = methodName.substring(3); // "get" 제거
						// 필드명이 대문자로 시작하는 경우 그대로 사용 (예: NO, TITLE 등)
						if (fieldName.matches("^[A-Z][A-Z0-9_]*") || fieldName.matches("^[A-Z]$")) {
							if (!template.containsKey(fieldName)) {
								template.put(fieldName, "?");
							}
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return template;
	}
	
	/**
	 * SOAP XML을 JSON Map으로 파싱
	 */
	private java.util.Map<String, Object> parseSoapXmlToJson(String soapXml, String serviceName) throws Exception {
		java.util.Map<String, Object> result = new java.util.LinkedHashMap<String, Object>();
		
		try {
			javax.xml.parsers.DocumentBuilderFactory factory = javax.xml.parsers.DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true);
			javax.xml.parsers.DocumentBuilder builder = factory.newDocumentBuilder();
			org.w3c.dom.Document doc = builder.parse(new java.io.ByteArrayInputStream(soapXml.getBytes("UTF-8")));
			
			// SOAP Body에서 arg0 찾기
			org.w3c.dom.NodeList bodyList = doc.getElementsByTagNameNS("http://schemas.xmlsoap.org/soap/envelope/", "Body");
			if (bodyList.getLength() > 0) {
				org.w3c.dom.Node body = bodyList.item(0);
				org.w3c.dom.NodeList arg0List = ((org.w3c.dom.Element) body).getElementsByTagName("arg0");
				
				if (arg0List.getLength() > 0) {
					org.w3c.dom.Element arg0 = (org.w3c.dom.Element) arg0List.item(0);
					org.w3c.dom.NodeList childNodes = arg0.getChildNodes();
					
					// arg0의 첫 번째 자식 요소 찾기 (MANUAL_LIST, LWS_SR_DATA, LWS_WR_DATA 등)
					for (int i = 0; i < childNodes.getLength(); i++) {
						org.w3c.dom.Node node = childNodes.item(i);
						if (node.getNodeType() == org.w3c.dom.Node.ELEMENT_NODE) {
							org.w3c.dom.Element element = (org.w3c.dom.Element) node;
							String elementName = element.getLocalName() != null ? element.getLocalName() : element.getNodeName();
							
							// 리스트 엘리먼트 내부의 데이터 파싱
							java.util.List<java.util.Map<String, String>> dataList = new java.util.ArrayList<java.util.Map<String, String>>();
							org.w3c.dom.NodeList dataNodes = element.getChildNodes();
							
							java.util.Map<String, String> dataMap = new java.util.LinkedHashMap<String, String>();
							for (int j = 0; j < dataNodes.getLength(); j++) {
								org.w3c.dom.Node dataNode = dataNodes.item(j);
								if (dataNode.getNodeType() == org.w3c.dom.Node.ELEMENT_NODE) {
									org.w3c.dom.Element dataElement = (org.w3c.dom.Element) dataNode;
									String fieldName = dataElement.getLocalName() != null ? dataElement.getLocalName() : dataElement.getNodeName();
									String fieldValue = dataElement.getTextContent() != null ? dataElement.getTextContent().trim() : "";
									// "?" 값도 빈 문자열로 처리하지 않고 그대로 저장
									if (!fieldValue.isEmpty() || fieldValue.equals("?")) {
										dataMap.put(fieldName, fieldValue);
									} else {
										dataMap.put(fieldName, "");
									}
								}
							}
							
							if (!dataMap.isEmpty()) {
								dataList.add(dataMap);
								result.put(elementName, dataList);
							}
							break; // 첫 번째 리스트만 처리
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Failed to parse SOAP XML: " + e.getMessage());
		}
		
		return result;
	}
	
	/**
	 * WSDL 서비스 호출 테스트
	 */
	@RequestMapping(value = "/wsdltest/callService.json")
	public String callService(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		String serviceName = params.get("serviceName") != null ? params.get("serviceName").toString() : "";
		String requestData = params.get("requestData") != null ? params.get("requestData").toString() : "";
		
		if (serviceName.isEmpty() || requestData.isEmpty()) {
			model.addAttribute("success", false);
			model.addAttribute("message", "Missing required parameters: serviceName and requestData");
			return "jsonView";
		}
		
		try {
			// SOAP XML을 JSON Map으로 변환
			java.util.Map<String, Object> jsonMap = parseSoapXmlToJson(requestData, serviceName);
			
			ObjectMapper objectMapper = new ObjectMapper();
			Object result = null;
			
			if ("IF_SFDC_DEALER_LSTA_038".equals(serviceName)) {
				
				// Request 객체 생성
				IF_SFDC_DEALER_LSTA_038_request wsdlRequest = new IF_SFDC_DEALER_LSTA_038_request();
				List<IF_SFDC_DEALER_LSTA_038_data> dataList = new ArrayList<IF_SFDC_DEALER_LSTA_038_data>();
				
				@SuppressWarnings("unchecked")
				java.util.List<java.util.Map<String, Object>> manualList = 
					(java.util.List<java.util.Map<String, Object>>) jsonMap.get("MANUAL_LIST");
				
				if (manualList != null) {
					for (java.util.Map<String, Object> dataMap : manualList) {
						IF_SFDC_DEALER_LSTA_038_data data = new IF_SFDC_DEALER_LSTA_038_data();
						if (dataMap.containsKey("NO")) data.setNO(String.valueOf(dataMap.get("NO")));
						if (dataMap.containsKey("TITLE")) data.setTITLE(String.valueOf(dataMap.get("TITLE")));
						if (dataMap.containsKey("DESCRIPTION")) data.setDESCRIPTION(String.valueOf(dataMap.get("DESCRIPTION")));
						if (dataMap.containsKey("AREA")) data.setAREA(String.valueOf(dataMap.get("AREA")));
						if (dataMap.containsKey("TYPE")) data.setTYPE(String.valueOf(dataMap.get("TYPE")));
						if (dataMap.containsKey("LANGUAGE")) data.setLANGUAGE(String.valueOf(dataMap.get("LANGUAGE")));
						if (dataMap.containsKey("SERISE")) data.setSERISE(String.valueOf(dataMap.get("SERISE")));
						if (dataMap.containsKey("MODEL")) data.setMODEL(String.valueOf(dataMap.get("MODEL")));
						if (dataMap.containsKey("CREATED_BY")) data.setCREATED_BY(String.valueOf(dataMap.get("CREATED_BY")));
						if (dataMap.containsKey("FILE_NO")) data.setFILE_NO(String.valueOf(dataMap.get("FILE_NO")));
						if (dataMap.containsKey("FILE_NAME")) data.setFILE_NAME(String.valueOf(dataMap.get("FILE_NAME")));
						if (dataMap.containsKey("FILE_SIZE")) data.setFILE_SIZE(String.valueOf(dataMap.get("FILE_SIZE")));
						if (dataMap.containsKey("FILE_URL")) data.setFILE_URL(String.valueOf(dataMap.get("FILE_URL")));
						if (dataMap.containsKey("FILE_DOWNLOAD_URL")) data.setFILE_DOWNLOAD_URL(String.valueOf(dataMap.get("FILE_DOWNLOAD_URL")));
						dataList.add(data);
					}
				}
				
				wsdlRequest.setMANUAL_LIST(dataList);
				
				// 서비스 호출
				if (ifSfdcDealerLsta038Service != null) {
					IF_SFDC_DEALER_LSTA_038_response response = ifSfdcDealerLsta038Service.getService(wsdlRequest);
					result = response;
				} else {
					model.addAttribute("success", false);
					model.addAttribute("message", "Service " + serviceName + " is not available");
					return "jsonView";
				}
			} else {
				model.addAttribute("success", false);
				model.addAttribute("message", "Service " + serviceName + " is not supported yet");
				return "jsonView";
			}
			
			model.addAttribute("success", true);
			model.addAttribute("message", "Service call completed");
			model.addAttribute("serviceName", serviceName);
			model.addAttribute("result", result);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("success", false);
			model.addAttribute("message", "Error: " + e.getMessage());
		}
		
		return "jsonView";
	}
}

