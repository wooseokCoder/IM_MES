package com.wsc.framework.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;

import com.wsc.framework.model.ParamsMap;

import kr.co.lscns.SD.WGBC.DT_SD1890_WGBC;
import kr.co.lscns.SD.WGBC.DT_SD1890_WGBCPDI_MAST;
import kr.co.lscns.SD.WGBC.DT_SD1890_WGBC_response;
import kr.co.lscns.SD.WGBC.SD1890_WGBC_SOProxy;
import kr.co.lscns.SD.WPCS.DT_SD0980_WPCS;
import kr.co.lscns.SD.WPCS.DT_SD0980_WPCS_responseGT_ORDER_INFO;
import kr.co.lscns.SD.WPCS.SD0980_WPCS_SOBindingStub;
import kr.co.lscns.SD.WPCS.SD0980_WPCS_SOProxy;
import kr.co.lscns.SD.WPCS.SD0980_WPCS_SOServiceLocator;



public class SoapUtils {
	/**
	 * Z_SD_RFC_DP_RECEV_ORD : LSTA->ERP : LSTA 완제품 주문정보
	 */
	public static void zSdRfcDpRecevOrdr() {
		URL url;
		
		try {
			url = new URL(null, "http://10.15.4.71:50000/dir/wsdl?p=ic/bfe07b49b4ae3286a2bd2389c853feee");
			StringBuffer xml = new StringBuffer();
			xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			xml.append("<wsdl:definitions name=\"SD0980_WPCS_SO\"");
			xml.append("	targetNamespace=\"http://lscns.co.kr/SD/WPCS\"");
			xml.append("	xmlns:p1=\"http://lscns.co.kr/SD/WPCS\"");
			xml.append("	xmlns:wsp=\"http://schemas.xmlsoap.org/ws/2004/09/policy\"");
			xml.append("	xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\"");
			xml.append("	xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\">");
			xml.append("	<wsdl:documentation />");
			xml.append("	<wsp:UsingPolicy wsdl:required=\"true\" />");
			xml.append("	<wsp:Policy wsu:Id=\"OP_SD0980_WPCS_SO\" />");
			xml.append("	<wsdl:types>");
			xml.append("		<xsd:schema targetNamespace=\"http://lscns.co.kr/SD/WPCS\"");
			xml.append("			xmlns=\"http://lscns.co.kr/SD/WPCS\"");
			xml.append("			xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">");
			xml.append("			<xsd:element name=\"MT_SD0980_WPCS\" type=\"DT_SD0980_WPCS\" />");
			xml.append("			<xsd:element name=\"MT_SD0980_WPCS_response\"");
			xml.append("				type=\"DT_SD0980_WPCS_response\" />");
			xml.append("			<xsd:complexType name=\"DT_SD0980_WPCS_response\">");
			xml.append("				<xsd:annotation>");
			xml.append("					<xsd:appinfo source=\"http://sap.com/xi/VersionID\">af1ad51eac8811e6b135000000461b76");
			xml.append("					</xsd:appinfo>");
			xml.append("				</xsd:annotation>");
			xml.append("				<xsd:sequence>");
			xml.append("					<xsd:element name=\"GT_ORDER_INFO\" minOccurs=\"0\"");
			xml.append("						maxOccurs=\"unbounded\">");
			xml.append("						<xsd:annotation>");
			xml.append("							<xsd:appinfo source=\"http://sap.com/xi/TextID\">375f017b4ee111e6ca3f28b2bd899076");
			xml.append("							</xsd:appinfo>");
			xml.append("						</xsd:annotation>");
			xml.append("						<xsd:complexType>");
			xml.append("							<xsd:sequence>");
			xml.append("								<xsd:element name=\"WPC_PO_NO\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">375f01774ee111e6902528b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"PART_NO\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">375f01784ee111e694d028b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"ORDER_NO\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">126604d84eea11e6cf3028b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"PART_NO2\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">5169e1244f2311e6a19728b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"INVOICE\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">5169e1254f2311e6ae7728b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"SITECD\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">126604d94eea11e6952528b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"STATUS\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">126604da4eea11e6c33728b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"ORDER_QTY\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">126604db4eea11e6b48a28b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"CHG_QTY\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">60dcd1b57db211e684e200ff1090f709");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"QTY\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">126604dc4eea11e6b43628b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("								<xsd:element name=\"DUEDATE\" type=\"xsd:string\"");
			xml.append("									minOccurs=\"0\">");
			xml.append("									<xsd:annotation>");
			xml.append("										<xsd:appinfo source=\"http://sap.com/xi/TextID\">126604dd4eea11e6cfb528b2bd899076");
			xml.append("										</xsd:appinfo>");
			xml.append("									</xsd:annotation>");
			xml.append("								</xsd:element>");
			xml.append("							</xsd:sequence>");
			xml.append("						</xsd:complexType>");
			xml.append("					</xsd:element>");
			xml.append("				</xsd:sequence>");
			xml.append("			</xsd:complexType>");
			xml.append("			<xsd:complexType name=\"DT_SD0980_WPCS\">");
			xml.append("				<xsd:annotation>");
			xml.append("					<xsd:appinfo source=\"http://sap.com/xi/VersionID\">a5bfee96ac8811e6887b000000461b76");
			xml.append("					</xsd:appinfo>");
			xml.append("				</xsd:annotation>");
			xml.append("				<xsd:sequence>");
			xml.append("					<xsd:element name=\"SITECD\" type=\"xsd:string\">");
			xml.append("						<xsd:annotation>");
			xml.append("							<xsd:appinfo source=\"http://sap.com/xi/TextID\">369fe3bd4ee411e6c9f628b2bd899076");
			xml.append("							</xsd:appinfo>");
			xml.append("						</xsd:annotation>");
			xml.append("					</xsd:element>");
			xml.append("					<xsd:element name=\"FROM_DATE\" type=\"xsd:string\">");
			xml.append("						<xsd:annotation>");
			xml.append("							<xsd:appinfo source=\"http://sap.com/xi/TextID\">369fe3be4ee411e6af5828b2bd899076");
			xml.append("							</xsd:appinfo>");
			xml.append("						</xsd:annotation>");
			xml.append("					</xsd:element>");
			xml.append("					<xsd:element name=\"TO_DATE\" type=\"xsd:string\"");
			xml.append("						minOccurs=\"0\">");
			xml.append("						<xsd:annotation>");
			xml.append("							<xsd:appinfo source=\"http://sap.com/xi/TextID\">369fe3bf4ee411e6b9b828b2bd899076");
			xml.append("							</xsd:appinfo>");
			xml.append("						</xsd:annotation>");
			xml.append("					</xsd:element>");
			xml.append("					<xsd:element name=\"WPC_PO_NO\" type=\"xsd:string\"");
			xml.append("						minOccurs=\"0\">");
			xml.append("						<xsd:annotation>");
			xml.append("							<xsd:appinfo source=\"http://sap.com/xi/TextID\">369fe3c04ee411e6b82428b2bd899076");
			xml.append("							</xsd:appinfo>");
			xml.append("						</xsd:annotation>");
			xml.append("					</xsd:element>");
			xml.append("					<xsd:element name=\"MATNR\" type=\"xsd:string\"");
			xml.append("						minOccurs=\"0\">");
			xml.append("						<xsd:annotation>");
			xml.append("							<xsd:appinfo source=\"http://sap.com/xi/TextID\">369fe3c14ee411e68b5b28b2bd899076");
			xml.append("							</xsd:appinfo>");
			xml.append("						</xsd:annotation>");
			xml.append("					</xsd:element>");
			xml.append("				</xsd:sequence>");
			xml.append("			</xsd:complexType>");
			xml.append("		</xsd:schema>");
			xml.append("	</wsdl:types>");
			xml.append("	<wsdl:message name=\"MT_SD0980_WPCS\">");
			xml.append("		<wsdl:documentation />");
			xml.append("		<wsdl:part name=\"MT_SD0980_WPCS\" element=\"p1:MT_SD0980_WPCS\" />");
			xml.append("	</wsdl:message>");
			xml.append("	<wsdl:message name=\"MT_SD0980_WPCS_response\">");
			xml.append("		<wsdl:documentation />");
			xml.append("		<wsdl:part name=\"MT_SD0980_WPCS_response\"");
			xml.append("			element=\"p1:MT_SD0980_WPCS_response\" />");
			xml.append("	</wsdl:message>");
			xml.append("	<wsdl:portType name=\"SD0980_WPCS_SO\">");
			xml.append("		<wsdl:documentation />");
			xml.append("		<wsdl:operation name=\"SD0980_WPCS_SO\">");
			xml.append("			<wsdl:documentation />");
			xml.append("			<wsp:Policy>");
			xml.append("				<wsp:PolicyReference URI=\"#OP_SD0980_WPCS_SO\" />");
			xml.append("			</wsp:Policy>");
			xml.append("			<wsdl:input message=\"p1:MT_SD0980_WPCS\" />");
			xml.append("			<wsdl:output message=\"p1:MT_SD0980_WPCS_response\" />");
			xml.append("		</wsdl:operation>");
			xml.append("	</wsdl:portType>");
			xml.append("	<wsdl:binding name=\"SD0980_WPCS_SOBinding\"");
			xml.append("		type=\"p1:SD0980_WPCS_SO\">");
			xml.append("		<soap:binding style=\"document\"");
			xml.append("			transport=\"http://schemas.xmlsoap.org/soap/http\"");
			xml.append("			xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" />");
			xml.append("		<wsdl:operation name=\"SD0980_WPCS_SO\">");
			xml.append("			<soap:operation");
			xml.append("				soapAction=\"http://sap.com/xi/WebService/soap1.1\"");
			xml.append("				xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" />");
			xml.append("			<wsdl:input>");
			xml.append("				<soap:body use=\"literal\"");
			xml.append("					xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" />");
			xml.append("			</wsdl:input>");
			xml.append("			<wsdl:output>");
			xml.append("				<soap:body use=\"literal\"");
			xml.append("					xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" />");
			xml.append("			</wsdl:output>");
			xml.append("		</wsdl:operation>");
			xml.append("	</wsdl:binding>");
			xml.append("	<wsdl:service name=\"SD0980_WPCS_SOService\">");
			xml.append("		<wsdl:port name=\"HTTP_Port\"");
			xml.append("			binding=\"p1:SD0980_WPCS_SOBinding\">");
			xml.append("			<soap:address");
			xml.append("				location=\"http://10.15.4.71:50000/XISOAPAdapter/MessageServlet?senderParty=&amp;senderService=LSTA_DEV&amp;receiverParty=&amp;receiverService=&amp;interface=SD0980_WPCS_SO&amp;interfaceNamespace=http%3A%2F%2Flscns.co.kr%2FSD%2FWPCS\"");
			xml.append("				xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" />");
			xml.append("		</wsdl:port>");
			xml.append("	</wsdl:service>");
			xml.append("</wsdl:definitions>");
			
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
	        conn.setDoOutput(true);
	        conn.setRequestMethod("POST");
	        // Header 영역에 쓰기
	        conn.addRequestProperty("Content-Type", "text/xml");
	        
	        // BODY 영역에 쓰기
	        OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
	        wr.write(xml.toString());
	        wr.flush();
	        
	        String inputLine = null;
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            System.out.println("======================================================================================");
            while ((inputLine = in.readLine()) != null) {
            	System.out.println("zSdRfcDpRecevOrdr"+inputLine);
            	}
                in.close();
                wr.close();
                System.out.println("======================================================================================");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static DT_SD0980_WPCS_responseGT_ORDER_INFO[] zWpcRecevOrdinfo(ParamsMap params) {
		System.out.println("dddddddddddddddddddddddddddd"+params.get("gsUserId").toString());
		DT_SD0980_WPCS INSD0980 = new DT_SD0980_WPCS();
		DT_SD0980_WPCS_responseGT_ORDER_INFO[] OUTSD0980 = null;
		
		INSD0980.setSITECD(params.get("userId").toString());
		INSD0980.setFROM_DATE(params.get("stDate").toString()); 
		INSD0980.setTO_DATE(params.get("edDate").toString());
		INSD0980.setWPC_PO_NO(" ");
		INSD0980.setMATNR(" ");
		
		
		
		try {
			
			SD0980_WPCS_SOProxy PROSD0980 = new SD0980_WPCS_SOProxy();
			OUTSD0980 = PROSD0980.SD0980_WPCS_SO(INSD0980);
			
			System.out.println("======================================================================================2");
			System.out.println("OUTSD0980::"+OUTSD0980);
			System.out.println("OUTSD0980Length::"+OUTSD0980.length);
			for(int i=0; i < OUTSD0980.length; i++) {
				System.out.println("SITECD:"+OUTSD0980[i].getSITECD()+"		STATUS:"+OUTSD0980[i].getSTATUS());
			}
			System.out.println("======================================================================================2");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return OUTSD0980;
	}
	
	public static DT_SD1890_WGBC_response zMmRfcLstaWgbcShipconf(ParamsMap params) {
		DT_SD1890_WGBCPDI_MAST INSD1890 = new DT_SD1890_WGBCPDI_MAST();
		DT_SD1890_WGBC_response OUTSD0980 = null;
		INSD1890.setSHIP_LOC(params.get("shipLoc").toString());
		String act_date = params.get("actDate").toString();		
		String[] act_temp = act_date.split("\\.");
		act_date = act_temp[2]+act_temp[0]+act_temp[1];
		INSD1890.setACT_SHIP_DATE(act_date);
		
		String ship_post_date = params.get("postDate").toString();		
		String[] ship_post_temp = ship_post_date.split("\\.");
		ship_post_date = ship_post_temp[2]+ship_post_temp[0]+ship_post_temp[1];
		INSD1890.setWADAT_IST(ship_post_date);
		
		INSD1890.setORDR_NO_SAP(params.get("sapPoNo").toString());
		INSD1890.setORDR_NO(params.get("poNo").toString());
		INSD1890.setBOL_NO(params.get("bolNo").toString());
		INSD1890.setASSY_NO(params.get("assyNo").toString());
		INSD1890.setITEM_CODE_01(params.get("itemCode01").toString());
		INSD1890.setSERI_NO_01(params.get("seriNo01").toString());
		INSD1890.setITEM_CODE_02(params.get("itemCode02").toString());
		INSD1890.setSERI_NO_02(params.get("seriNo02").toString());
		INSD1890.setITEM_CODE_03(params.get("itemCode03").toString());
		INSD1890.setSERI_NO_03(params.get("seriNo03").toString());
		INSD1890.setITEM_CODE_04(params.get("itemCode04").toString());
		INSD1890.setSERI_NO_04(params.get("seriNo04").toString());
		INSD1890.setITEM_CODE_05(params.get("itemCode05").toString());
		INSD1890.setSERI_NO_05(params.get("seriNo05").toString());
		INSD1890.setITEM_CODE_06(params.get("itemCode06").toString());
		INSD1890.setSERI_NO_06(params.get("seriNo06").toString());
		INSD1890.setITEM_CODE_07(params.get("itemCode07").toString());
		INSD1890.setSERI_NO_07(params.get("seriNo07").toString());
		INSD1890.setITEM_CODE_08(params.get("itemCode08").toString());
		INSD1890.setSERI_NO_08(params.get("seriNo08").toString());
		INSD1890.setITEM_CODE_09(params.get("itemCode09").toString());
		INSD1890.setSERI_NO_09(params.get("seriNo09").toString());
		INSD1890.setITEM_CODE_10(params.get("itemCode10").toString());
		INSD1890.setSERI_NO_10(params.get("seriNo10").toString());
		
		System.out.println("shipLoc : "+INSD1890.getSHIP_LOC());
		System.out.println("actDate : "+INSD1890.getACT_SHIP_DATE());
		System.out.println("postDate : "+INSD1890.getWADAT_IST());
		System.out.println("sapPoNo : "+INSD1890.getORDR_NO_SAP());
		System.out.println("poNo : "+INSD1890.getORDR_NO());
		System.out.println("bolNo : "+INSD1890.getBOL_NO());
		System.out.println("assyNo : "+INSD1890.getASSY_NO());
		System.out.println("itemCode01 : "+INSD1890.getITEM_CODE_01());
		System.out.println("seriNo01 : "+INSD1890.getSERI_NO_01());
		System.out.println("itemCode02 : "+INSD1890.getITEM_CODE_02());
		System.out.println("seriNo02 : "+INSD1890.getSERI_NO_02());
		System.out.println("itemCode03 : "+INSD1890.getITEM_CODE_03());
		System.out.println("seriNo03 : "+INSD1890.getSERI_NO_03());
		System.out.println("itemCode04 : "+INSD1890.getITEM_CODE_04());
		System.out.println("seriNo04 : "+INSD1890.getSERI_NO_04());
		System.out.println("itemCode05 : "+INSD1890.getITEM_CODE_05());
		System.out.println("seriNo05 : "+INSD1890.getSERI_NO_05());
		System.out.println("itemCode06 : "+INSD1890.getITEM_CODE_06());
		System.out.println("seriNo06 : "+INSD1890.getSERI_NO_06());
		System.out.println("itemCode07 : "+INSD1890.getITEM_CODE_07());
		System.out.println("seriNo07 : "+INSD1890.getSERI_NO_07());
		System.out.println("itemCode08 : "+INSD1890.getITEM_CODE_08());
		System.out.println("seriNo08 : "+INSD1890.getSERI_NO_08());
		System.out.println("itemCode09 : "+INSD1890.getITEM_CODE_09());
		System.out.println("seriNo09 : "+INSD1890.getSERI_NO_09());
		System.out.println("itemCode10 : "+INSD1890.getITEM_CODE_10());
		System.out.println("seriNo10 : "+INSD1890.getSERI_NO_10());
		
		DT_SD1890_WGBC IN2SD1890 = new DT_SD1890_WGBC();
		IN2SD1890.setPDI_MAST(INSD1890);
		
		try {
			
			SD1890_WGBC_SOProxy PROSD1890 = new SD1890_WGBC_SOProxy();
			OUTSD0980 = PROSD1890.SD1890_WGBC_SO(IN2SD1890);
			System.out.println("======================================================================================");
			System.out.println("DELI_NO_SAP:"+OUTSD0980.getDELI_NO_SAP());
			System.out.println("o_RESULT : "+OUTSD0980.getO_RESULT());
			System.out.println("o_MESSAGE : "+OUTSD0980.getO_MESSAGE());
			System.out.println("======================================================================================");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return OUTSD0980;
	}
}
