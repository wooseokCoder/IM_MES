package com.wsc.framework.utils;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;

public class MailUtils {
	public static String MailTitle(Map<String, Object> mainInfo) {
		//Your Order #1712923 has been Created!
		StringBuffer title = new StringBuffer();
		
		String ordrStat = (String) mainInfo.get("ORDR_STAT");
		if(ordrStat.equals("200")) {
			title.append("Your Order #"+mainInfo.get("ORDR_NO")+" has been Created!");
		}else if(ordrStat.equals("300")) {
			title.append("Your Order #"+mainInfo.get("ORDR_NO")+" has been Reviewed!");
		}else if(ordrStat.equals("400")) {
			title.append("Your Order #"+mainInfo.get("ORDR_NO")+" has been Confirmed!");
		}else if(ordrStat.equals("500")) {
			title.append("Your Order #"+mainInfo.get("ORDR_NO")+" has been Scheduled!");
		}else if(ordrStat.equals("550")) {
			// 2022-09-13 ORDR_NO -> BOL_NO 변경
			title.append("Your Order #"+mainInfo.get("BOL_NO")+" has been Shipped!");
		}else if(ordrStat.equals("600")) {
			title.append("Your Order #"+mainInfo.get("ORDR_NO")+" has been Completed!");
		}else if(ordrStat.equals("RETAIL_MAIL")) {
			title.append("Retailed Order #"+mainInfo.get("ORDR_NO")+" has been Confirmed!");
		}else if(ordrStat.equals("INVOICE_MAIL")) {
			title.append("Your Invoice #"+mainInfo.get("INV_FILE_INFO")+" has been Completed!");
		}else if(ordrStat.equals("DEALER_PAIED")) {
			title.append("Order #"+mainInfo.get("ordrNo")+" has been Paid!");
		}else if(ordrStat.equals("DEALER_PAIED_MULTI")) {
			title.append("Payment Group # "+mainInfo.get("payChkDealInvNo") +" has been Paid!");
		}
		
		return title.toString();
		
	}

	public static String MailForm(Map<String, Object> mainInfo, List<Map<String, Object>> trInfo, List<Map<String, Object>> attaInfo, List<Map<String, Object>> adpInfo
							, List<Map<String, Object>> tropInfo, List<Map<String, Object>> attaopInfo, List<Map<String, Object>> discInfo) {
		
		String ordrStat = (String) mainInfo.get("ORDR_STAT");
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");

		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");

		//상위 타이틀		
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:130px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/lsta_logo2.png\"><br><span style=\"padding-left:10px; font-size: 12px; color:#6E6E6E;\">Excel In Your Field&trade;</span>");
		content.append("		</div>");

		if(ordrStat.equals("200")) {
			content.append("		<div>");
			content.append("			<img style=\"width:1370px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a1.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Your Order #"+mainInfo.get("ORDR_NO")+" has been Created!</p>");
			content.append("			<p style=\"font-size:15px;\">Hello <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			content.append("			<br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\">Final Pricing subject to change upon approval.</td>");
			content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
			content.append("					</tr>");
			content.append("				</table>");
			
			content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :discInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}			
			content.append("				</table>");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
			content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
			content.append("						</th>");
			content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
			content.append("					</tr>");
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c1.jpg\">");
			content.append("						<span style=\"vertical-align: top;\">Your order will ship to: </span></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_ADDRESS1")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_CITY")+" "+mainInfo.get("SHIP_TO_ZIP")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_COUNTRY_NM")+"<br><br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
			//2021-04-19 오더생성 메일 거부
//			content.append("					<tr style='border-bottom: 1px solid lightgray; height:45px;'>");
//			content.append("						<th style=\"color:#0174DF; text-align:center\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=CREATE&auth=TOKEN_VAL' >");
//			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//			content.append("						</th>");
//			content.append("					</tr>");
			content.append("				</table>");
			//2021-04-21 오더생성 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
			content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=CREATE&auth=TOKEN_VAL' >");
			content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=CREATE&auth=TOKEN_VAL' >");
			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("						<div>");
			content.append("					</div>");
			content.append("				</div>");
			content.append("			</div>");
			content.append("		</div>");
			
		}else if(ordrStat.equals("300")) { 
			content.append("		<div>");
			content.append("			<img style=\"width:1370px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a2.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Your Order #"+mainInfo.get("ORDR_NO")+" has been Reviewed!</p>");
			content.append("			<p style=\"font-size:15px;\">Hello <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			content.append("			<br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\">Final Pricing subject to change upon approval.</td>");
			content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
			content.append("					</tr>");
			content.append("				</table>");
			
			content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :discInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}			
			content.append("				</table>");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
			content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
			content.append("						</th>");
			content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
			content.append("					</tr>");
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c1.jpg\">");
			content.append("						<span style=\"vertical-align: top;\">Your order will ship to: </span></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_ADDRESS1")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_CITY")+" "+mainInfo.get("SHIP_TO_ZIP")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_COUNTRY_NM")+"<br><br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
//			//2021-04-20 리뷰 메일 거부
//			content.append("					<tr>");
//			content.append("						<th style=\"color:#0174DF; text-align:left\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=REVIEW&auth=TOKEN_VAL' >");
//			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//			content.append("						</th>");
//			content.append("					</tr>");
			content.append("				</table>");
			//2021-04-21 리뷰 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
			content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=REVIEW&auth=TOKEN_VAL' >");
			content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=REVIEW&auth=TOKEN_VAL' >");
			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("						<div>");
			content.append("					</div>");
			content.append("				</div>");
			content.append("			</div>");
			content.append("		</div>");
			
		}else if(ordrStat.equals("400")) {
			
			content.append("		<div>");
			content.append("			<img style=\"width:1370px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a3.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Your Order #"+mainInfo.get("ORDR_NO")+" has been Confirmed!</p></br>");
			content.append("			<p style=\"font-size:15px;\">Hello <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			/*content.append("			<p style=\"font-size:15px;\">Your Order would be shipped <span style=\"color:#FE2E2E;\">"+mainInfo.get("DATE1")+" ~ "+mainInfo.get("DATE2")+"</span>,</p>");*/
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			if(mainInfo.get("PAY_METH").equals("YZ00")) {
				content.append("		<br>");
				content.append("        <table style=\"width:55%; border-collapse:collapse;\">");
				content.append("        	<tr>");
				content.append("            	<th style=\"text-align:left; padding:8px; width:30%;\">Proforma Invoice #</th>");
				content.append("                <td style=\"padding:8px;\">" + mainInfo.get("PROF_INV_NO") + "</td>");
				content.append("            </tr>");
				content.append("        </table>");
				content.append("		<br><p style=\"font-size:15px;\">We have received the deposit for the above order and have confirmed the order.</p>");
			}
			content.append("			<br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\">To change a confirmed order, please contact your Business Manager.</td>");
			content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
			content.append("					</tr>");
			content.append("				</table>");
			
			content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :discInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}			
			content.append("				</table>");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
			content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
			content.append("						</th>");
			content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
			content.append("					</tr>");
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c1.jpg\">");
			content.append("						<span style=\"vertical-align: top;\">Your order will ship to: </span></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_ADDRESS1")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_CITY")+" "+mainInfo.get("SHIP_TO_ZIP")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_COUNTRY_NM")+"<br><br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
//			//2021-04-20 컨펌 메일 거부
//			content.append("					<tr>");
//			content.append("						<th style=\"color:#0174DF; text-align:left\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=CONFIRM&auth=TOKEN_VAL' >");
//			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//			content.append("						</th>");
//			content.append("					</tr>");
			content.append("				</table>");
			//2021-04-21 컨펌 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
			content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=CONFIRM&auth=TOKEN_VAL' >");
			content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=CONFIRM&auth=TOKEN_VAL' >");
			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("						<div>");
			content.append("					</div>");
			content.append("				</div>");
			content.append("			</div>");
			content.append("		</div>");
			
		}else if(ordrStat.equals("500")) {
			
			content.append("		<div>"); 																	
			content.append("			<img style=\"width:1350px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a4.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Your Order #"+mainInfo.get("ORDR_NO")+" has been Scheduled!</p>");
			content.append("			<p style=\"font-size:25px; font-weight:bold; color:#3B0B0B; margin-top:10px;\">");
			content.append("				<img style=\"width:30px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c3.jpg\"><span style=\"vertical-align: top;\">Expected Shipping Date: "+mainInfo.get("REQR_DELI_DATE_FM")+"</span>");
			content.append("			</p>");
			content.append("			<p style=\"font-size:15px;\">Hello <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			content.append("			<br><br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			//content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\">Final Pricing subject to change upon approval.</td>");
			content.append("						<td colspan=\"4\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
			content.append("					</tr>");
			content.append("				</table>");
			
			content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :discInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}			
			content.append("				</table>");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
			content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
			content.append("						</th>");
			content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
			content.append("					</tr>");
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c1.jpg\">");
			content.append("						<span style=\"vertical-align: top;\">Your order will ship to: </span></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_ADDRESS1")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_CITY")+" "+mainInfo.get("SHIP_TO_ZIP")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_COUNTRY_NM")+"<br><br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
//			//2021-04-20 레디투쉽 메일 거부
//			content.append("					<tr>");
//			content.append("						<th style=\"color:#0174DF; text-align:left\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=READY&auth=TOKEN_VAL' >");
//			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//			content.append("						</th>");
//			content.append("					</tr>");
			content.append("				</table>");			
			//2021-04-21 레디투쉽 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
			content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=READY&auth=TOKEN_VAL' >");
			content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=READY&auth=TOKEN_VAL' >");
			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("						<div>");
			content.append("					</div>");
			content.append("				</div>");
			content.append("			</div>");
			content.append("		</div>");
			
		}else if(ordrStat.equals("550")) {
			
			content.append("		<div>"); 																	
			content.append("			<img style=\"width:1370px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a6.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Your truck is on the way!</p>");
			//Your Order #"+mainInfo.get("ORDR_NO")+" has been Scheduled!
			content.append("			<p style=\"font-size:25px; font-weight:bold; color:#3B0B0B; margin-top:10px;\">");
			content.append("				<img style=\"width:30px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c3.jpg\"><span style=\"vertical-align: top;\">Expected Delivery Date: "+mainInfo.get("SHIP_DATE")+"</span>");
			content.append("			</p>");
			content.append("			<br><p style=\"font-size:15px;\">Hello <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			content.append("			<br><br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:110%;\">");
			content.append("					<tr>");
			content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\">Dealer PO: "+mainInfo.get("DEAL_PO_NO")+"</td>");
			content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
			content.append("					</tr>");
			content.append("				</table>");
			content.append("				<table style=\"width:110%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Order#</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Payment Method</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ORDR_NO")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("PAY_METH_NM")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ORDR_NO")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("PAY_METH_NM")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ORDR_NO")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("PAY_METH_NM")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ORDR_NO")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("PAY_METH_NM")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ORDR_NO")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("PAY_METH_NM")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}	
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c1.jpg\">");
			content.append("						<span style=\"vertical-align: top;\">Your order will ship to: </span></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_ADDRESS1")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_CITY")+" "+mainInfo.get("SHIP_TO_ZIP")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_COUNTRY_NM")+"<br><br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
//			//2021-04-20 쉽드 메일 거부
//			content.append("					<tr>");
//			content.append("						<th style=\"color:#0174DF; text-align:left\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=SHIP&auth=TOKEN_VAL' >");
//			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//			content.append("						</th>");
//			content.append("					</tr>");
			content.append("				</table>");
			//2021-04-21 쉽드 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
			content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=SHIP&auth=TOKEN_VAL' >");
			content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=SHIP&auth=TOKEN_VAL' >");
			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("						<div>");
			content.append("					</div>");
			content.append("		       </div>");
			content.append("			</div>");
			content.append("		</div>");
			
		}else if(ordrStat.equals("600")) {
			content.append("		<div>");
			content.append("			<img style=\"width:1370px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a5.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Your Order #"+mainInfo.get("ORDR_NO")+" has been Completed!</p>");
			content.append("			<p style=\"font-size:15px;\">Hello <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			content.append("			<br><br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			// PO 넘버 추가
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\">your invoice is ready to print!</td>");
			content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
			content.append("					</tr>");
			content.append("				</table>");
			
			content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :discInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}			
			content.append("				</table>");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
			content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
			content.append("						</th>");
			content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
			content.append("					</tr>");
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c1.jpg\">");
			content.append("						<span style=\"vertical-align: top;\">Your order will ship to: </span></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_ADDRESS1")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_CITY")+" "+mainInfo.get("SHIP_TO_ZIP")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_COUNTRY_NM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
//			//2021-04-20 컴플리트 메일 거부
//			content.append("					<tr>");
//			content.append("						<th style=\"color:#0174DF; text-align:left\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=COMP&auth=TOKEN_VAL' >");
//			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//			content.append("						</th>");
//			content.append("					</tr>");
			content.append("				</table>");
			//2021-04-21 컴플리트 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
			content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=COMP&auth=TOKEN_VAL' >");
			content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=COMP&auth=TOKEN_VAL' >");
			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("						<div>");
			content.append("					</div>");
			content.append("				</div>");
			content.append("			</div>");
			content.append("		</div>");
		}else if(ordrStat.equals("RETAIL_MAIL")) { 
			content.append("		<div>");
			content.append("			<img style=\"width:1370px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a3.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Retailed Order #"+mainInfo.get("ORDR_NO")+" has been Confirmed!</p>");
			content.append("			<p style=\"font-size:15px;\">Dealer : <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_CODE")+" - "+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			content.append("			<p style=\"font-size:15px;\">Ware House : "+mainInfo.get("SHIP_LOC_CODE")+"</p>");
			content.append("			<p style=\"font-size:15px;\">Ship To : "+mainInfo.get("SHIP_TO_ADDRESS1")+", "+mainInfo.get("SHIP_TO_CITY")+", "+mainInfo.get("SHIP_TO_COUNTRY_NM")+"</p>");
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			content.append("			<br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("					</tr>");
			}			
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
			content.append("				</table>");
			//2021-04-21 리뷰 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px; width:85%;'>");
			content.append("					</div>");
			content.append("				</div>");
			content.append("			</div>");
			content.append("		</div>");
			
		}else if(ordrStat.equals("INVOICE_MAIL")) {
			content.append("		<div>");
			content.append("			<img style=\"width:1370px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a5.jpg\">");
			content.append("		</div>");
			
			
			content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Your Invocie #"+mainInfo.get("INV_FILE_INFO")+" has been Completed!</p>");
			content.append("			<p style=\"font-size:15px;\">Hello <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span>,</p>");
			content.append("			<p style=\"font-size:15px;\">For more information, please access the dealer portal.</p>");
			content.append("			<br><br><p>[Order Summary]</p>");
			content.append("		<div style=\"width:90%;\">");
			// PO 넘버 추가
			content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\"><a style=\"text-decoration:none\" href=\"http://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/Invoice&decorate=no&output=pdf&p_inv_no="+mainInfo.get("INV_NO_TOKEN")+"\">your invoice is ready to print!</a></td>");
			content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
			content.append("					</tr>");
			content.append("				</table>");
			
			content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
			content.append("					<tr>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
			content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
			content.append("					</tr>");
			for(Map<String, Object> mapInfo :trInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :adpInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :tropInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :attaopInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}
			for(Map<String, Object> mapInfo :discInfo) {
				content.append("					<tr>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
				content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:12px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
				content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:12px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
				content.append("					</tr>");
			}			
			content.append("				</table>");
			content.append("				<table style=\"width:85%;\">");
			content.append("					<tr>");
			content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
			content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
			content.append("						</th>");
			content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
			content.append("					</tr>");
			content.append("				</table>");
			content.append("				<table style=\"width:85%; text-align:left;\">");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c1.jpg\">");
			content.append("						<span style=\"vertical-align: top;\">Your order will ship to: </span></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_ADDRESS1")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_CITY")+" "+mainInfo.get("SHIP_TO_ZIP")+"</th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"text-align:left;\">"+mainInfo.get("SHIP_TO_COUNTRY_NM")+"<br></th>");
			content.append("					</tr>");
			content.append("					<tr>");
			content.append("						<th style=\"color:#0174DF; text-align:left\">");
			content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
			content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
			content.append("						</th>");
			content.append("					</tr>");
//			//2021-04-20 컴플리트 메일 거부
//			content.append("					<tr>");
//			content.append("						<th style=\"color:#0174DF; text-align:left\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=COMP&auth=TOKEN_VAL' >");
//			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//			content.append("						</th>");
//			content.append("					</tr>");
			content.append("				</table>");
			//2021-04-21 컴플리트 메일 거부
			content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
			content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//			content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=COMP&auth=TOKEN_VAL' >");
			content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=COMP&auth=TOKEN_VAL' >");
			content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("						<div>");
			content.append("					</div>");
			content.append("				</div>");
			content.append("			</div>");
			content.append("		</div>");
		}
		else if(ordrStat.equals("DEALER_PAIED")) {
			content.append("    <div id=\"createdCon\" style=\"margin-top:30px; width:1200px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("        <p style=\"font-size:30px; font-weight:600; color:#0174DF;\">Order #" + mainInfo.get("ordrNo") + " has entered deposit information for 「Cash In Advance」</p>");
			content.append("        <br><p style=\"font-size:20px; margin-bottom: 14px; font-weight:600;\">Dealer Name : " + mainInfo.get("dealCode") + " - "  +mainInfo.get("dealName") + "</p>");
			content.append("        <br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">1. View the information in <a style=\"text-decoration:underline\" href=\"https://dealerportal.lstractorusa.com\">Dealer Portal.</a>" + "</p>");
			content.append("        <div style=\"width:100%;\">");
			content.append("            <div style=\"font-weight:500;\">");
			content.append("                <table style=\"width:40%; border-collapse:collapse; border: 1px solid #ddd;\">");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Proforma Invoice #</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("profInvNo") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">PO Number</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("ordrNo") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">PO Amount</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("poTotalAmt") + "</td>");
			content.append("                    </tr>");
			
			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Group #</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">");
			content.append("                            <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">" + mainInfo.get("payChkDealInvNo") + "</a>");
			content.append("                            <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">");
/* 개발 프린트
 			content.append("                            <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">" + mainInfo.get("payChkDealInvNo") + "</a>");
			content.append("                            <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">");
*/
			content.append("                                <img style=\"width:18px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp/resources/images/printer.png\">");
			content.append("                            </a>");
			content.append("                        </td>");
			content.append("                    </tr>");

            content.append("                    <tr>");
            content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Method</th>");
            content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("paymMethChk") + "</td>");
            content.append("                    </tr>");
            if ("Check".equals(mainInfo.get("paymMethChk"))) {
            content.append("                    <tr>");
            content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Check No</th>");
            content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("paymMethChkNo") + "</td>");
            content.append("                    </tr>");
            }
			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Amount</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealAmt") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment User</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealId") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Date</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealDate") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Time</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealTime") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; height:72px; font-size: 12px;\">Dealer Remark</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd; height:72px;\">" + mainInfo.get("payMentRemk") + "</td>");
			content.append("                    </tr>");

			content.append("                </table>");
			content.append("            </div>");
			content.append("        </div>");
			content.append("        <br><br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">2. Check the account deposit history (FAGLL03)" + "</p>");
			content.append("        <br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">3. Compare the deposit details with Dealer Portal and proceed to process the advance payment. (ZFIR0003_RG)" + "</p>");
			content.append("        <br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">4. Enter the result of the advance payment into 【Dealer portal】." + "</p>");
			content.append("        <p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px; text-indent: 30px;\">( ▶ Select Order (Multiple) > Enter Amount > Select date and time > Save )" + "</p>");
			
			content.append("        <div style='border-top: 2px solid lightgray; height:45px; margin-top:20px;'>");
			content.append("            <div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
			content.append("                <a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=DEALER_PAIED&auth=" + mainInfo.get("token") + "' >");
			content.append("                <span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("            <div>");
			content.append("        </div>");
			content.append("    </div>");
		}
		else if(ordrStat.equals("DEALER_PAIED_MULTI")) {
			content.append("    <div id=\"createdCon\" style=\"margin-top:30px; width:1300px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
			content.append("        <p style=\"font-size:30px; font-weight:600; color:#0174DF;\">Payment Group # " + mainInfo.get("payChkDealInvNo")  + " has entered deposit information for 「Cash In Advance」</p>");
			content.append("        <br><p style=\"font-size:20px; margin-bottom: 14px; font-weight:600;\">Dealer Name : " + mainInfo.get("dealCode") + " - "  +mainInfo.get("dealName") + "</p>");
			content.append("        <br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">1. View the information in <a style=\"text-decoration:underline\" href=\"https://dealerportal.lstractorusa.com\">Dealer Portal.</a></p>");
			content.append("        <div style=\"width:100%;\">");
			content.append("            <div style=\"font-weight:500;\">");
			content.append("                <table style=\"width:40%; border-collapse:collapse; border: 1px solid #ddd;\">");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Total PO Amount</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("poTotalAmt") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Group #</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">");
			content.append("                            <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">" + mainInfo.get("payChkDealInvNo") + "</a>");
			content.append("                            <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">");
/* 개발 프린트
			content.append("                            <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">" + mainInfo.get("payChkDealInvNo") + "</a>");
			content.append("                            <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">");
*/
			content.append("                                <img style=\"width:18px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp/resources/images/printer.png\">");
			content.append("                            </a>");
			content.append("                        </td>");
			content.append("                    </tr>");

            content.append("                    <tr>");
            content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Method</th>");
            content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("paymMethChk") + "</td>");
            content.append("                    </tr>");
            if ("Check".equals(mainInfo.get("paymMethChk"))) {
            content.append("                    <tr>");
            content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Check No</th>");
            content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("paymMethChkNo") + "</td>");
            content.append("                    </tr>");
            }
			
			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Amount</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealAmt") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment User</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealId") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Date</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealDate") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; font-size: 12px;\">Payment Time</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd;\">" + mainInfo.get("payChkDealTime") + "</td>");
			content.append("                    </tr>");

			content.append("                    <tr>");
			content.append("                        <th style=\"text-align:left; font-weight:500; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:30%; height:72px; font-size: 12px;\">Dealer Remark</th>");
			content.append("                        <td style=\"padding:8px; font-weight:500; border-bottom: 1px solid #ddd; height:72px;\">" + mainInfo.get("payMentRemk") + "</td>");
			content.append("                    </tr>");

			content.append("                </table>");
			content.append("            </div>");
			content.append("        </div>");

			String profInvNoList = (String) mainInfo.get("profInvNoList");
			String profInvNoListEnc = (String) mainInfo.get("profInvNoListEnc");

			if (profInvNoList != null && !profInvNoList.isEmpty()
			    && profInvNoListEnc != null && !profInvNoListEnc.isEmpty()) {

			    String[] profInvArr = profInvNoList.split(",");
			    String[] profInvEncArr = profInvNoListEnc.split(",");

			    int len = Math.min(profInvArr.length, profInvEncArr.length);

			    content.append("        <div style=\"margin-top: 30px; font-weight:500; font-size:15px;\">");

			    for (int i = 0; i < len; i++) {
			        String profNo = profInvArr[i];
			        String profNoEnc = profInvEncArr[i];

			        content.append("            <div style=\"margin-bottom:8px; display: flex; align-items: center;\">");
			        content.append("                <span style=\"margin-right: 10px;\">Proforma Invoice # - </span>");
			        content.append("                <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">" + profNo + "</a>");
			        content.append("                <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">");
/* 개발 프린트			     
     				content.append("                <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">" + profNo + "</a>");
			        content.append("                <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">");
*/
			        content.append("                    <img style=\"width:18px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp/resources/images/printer.png\">");
			        content.append("                </a>");
			        content.append("            </div>");
			    }

			    content.append("        </div>");
			}

			content.append("        <br><br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">2. Check the account deposit history (FAGLL03)</p>");
			content.append("        <br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">3. Compare the deposit details with Dealer Portal and proceed to process the advance payment. (ZFIR0003_RG)</p>");
			content.append("        <br><p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px;\">4. Enter the result of the advance payment into 【Dealer portal】.</p>");
			content.append("        <p style=\"font-size:18px; font-weight:500; margin-top: -10px; margin-bottom: 14px; text-indent: 30px;\">( ▶ Select Order (Multiple) > Enter Amount > Select date and time > Save )</p>");

			content.append("        <div style='border-top: 2px solid lightgray; height:45px; margin-top:20px;'>");
			content.append("            <div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
			content.append("                <a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=DEALER_PAIED&auth=" + mainInfo.get("token") + "' >");
			content.append("                <span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
			content.append("            </div>");
			content.append("        </div>");
			content.append("    </div>");
			
		}

		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		
		
		return content.toString();
	}
	
	
	public static String MailReviewTitle(Map<String, Object> mainInfo) {
		StringBuffer title = new StringBuffer();
		title.append(mainInfo.get("ORDR_NO")+" was reviewed ("+mainInfo.get("BM_NAME")+" - "+mainInfo.get("DEAL_CODE")+" - "+mainInfo.get("DEAL_NAME")+")");
		
		return title.toString();
	}
	
	public static String MailReviewForm(Map<String, Object> mainInfo, List<Map<String, Object>> trInfo, List<Map<String, Object>> attaInfo, List<Map<String, Object>> adpInfo
			, List<Map<String, Object>> tropInfo, List<Map<String, Object>> attaopInfo, List<Map<String, Object>> discInfo) {
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		
		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		
		//상위 타이틀		
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:130px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/lsta_logo2.png\"><br><span style=\"padding-left:10px; font-size: 12px; color:#6E6E6E;\">Excel In Your Field&trade;</span>");
		content.append("		</div>");
		
		
		content.append("		<div>");
		content.append("			<img style=\"width:1350px; margin-left: -8px; height:auto; margin-top:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/a2.jpg\">");
		content.append("		</div>");
		
		content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">"+mainInfo.get("ORDR_NO")+" was reviewed</p>");
		content.append("			<p style=\"font-size:15px;\">Dealer : <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span></p>");
		content.append("			<br><p>[Order Summary]</p>");
		
		content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("				<table style=\"width:85%;\">");
		content.append("					<tr>");
		content.append("						<td colspan=\"2\" style=\"text-align:left; border:0px;\"></td>");
		content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
		content.append("					</tr>");
		content.append("				</table>");
		
		content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
		content.append("					<tr>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
		content.append("					</tr>");
		for(Map<String, Object> mapInfo :trInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		for(Map<String, Object> mapInfo :attaInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		for(Map<String, Object> mapInfo :adpInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		for(Map<String, Object> mapInfo :tropInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		for(Map<String, Object> mapInfo :attaopInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		for(Map<String, Object> mapInfo :discInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}			
		content.append("				</table>");
		content.append("				<table style=\"width:85%;\">");
		content.append("					<tr>");
		content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
		content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
		content.append("						</th>");
		content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
		content.append("					</tr>");
		content.append("				</table>");
		content.append("				<table style=\"width:85%; text-align:left;\">");
		content.append("					<tr>");
		content.append("						<th style=\"text-align:left;\">Remark(Dealer) :</th>");
		content.append("					</tr>");
		content.append("					<tr>");
		content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_DEAL")+"<br></th>");
		content.append("					</tr>");
		content.append("					<tr>");
		content.append("						<th style=\"text-align:left;\">Remark(LSTA) :</th>");
		content.append("					</tr>");
		content.append("					<tr>");
		content.append("						<th style=\"text-align:left;\">"+mainInfo.get("REMK_BM")+"<br></th>");
		content.append("					</tr>");
		content.append("					<tr>");
		content.append("						<th style=\"color:#0174DF; text-align:left\">");
		content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com/lsdp\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
		content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
		content.append("						</th>");
		content.append("					</tr>");
//		//2021-04-20 리뷰 메일 거부
//		content.append("					<tr>");
//		content.append("						<th style=\"color:#0174DF; text-align:left\">");
//		content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=REVIEW&auth=TOKEN_VAL' >");
//		content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//		content.append("						</th>");
//		content.append("					</tr>");
		content.append("				</table>");
		//2021-04-21 리뷰 메일 거부
		content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
		content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//		content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=REVIEW&auth=TOKEN_VAL' >");
		content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=REVIEW&auth=TOKEN_VAL' >");
		content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
		content.append("						<div>");
		content.append("					</div>");
		
		content.append("			</div>");
		content.append("		</div>");
		
		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		
		
		return content.toString();
		}
	
	
	
	public static String MailReturnTitle(Map<String, Object> mainInfo) {
		StringBuffer title = new StringBuffer();
		title.append("ReturnOrder - "+mainInfo.get("ORDR_NO")+" Waiting for Approval ("+mainInfo.get("BM_NAME")+" - "+mainInfo.get("DEAL_CODE")+" - "+mainInfo.get("DEAL_NAME")+")");
		
		return title.toString();
	}
	
	public static String MailRejectTitle(Map<String, Object> mainInfo) {
		StringBuffer title = new StringBuffer();
		title.append("ReturnOrder - "+mainInfo.get("ORDR_NO")+"Rejected ("+mainInfo.get("BM_NAME")+" - "+mainInfo.get("DEAL_CODE")+" - "+mainInfo.get("DEAL_NAME")+")");
		
		return title.toString();
	}
	
	
	public static String MailRetnReviewForm(Map<String, Object> mainInfo, List<Map<String, Object>> trInfo, List<Map<String, Object>> attaInfo, String flg) {
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		
		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		
		//상위 타이틀		
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:130px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/lsta_logo2.png\"><br><span style=\"padding-left:10px; font-size: 12px; color:#6E6E6E;\">Excel In Your Field&trade;</span>");
		content.append("		</div>");
		content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		if("A".equals(flg)) {
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">"+mainInfo.get("ORDR_NO")+"  have been requesting approval.</p>");
		} else {
			content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">"+mainInfo.get("ORDR_NO")+"  have been Rejected.</p>");
		}
		content.append("			<p style=\"font-size:15px;\">Dealer : <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span></p>");
		content.append("			<br><p>[Order Summary]</p>");
		
		content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("				<table style=\"width:85%;\">");
		content.append("					<tr>");
		content.append("						<td colspan=\"1\" style=\"text-align:left; border:0px;\"></td>");
		content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
//		content.append("						<td style=\"text-align: center;width: 107px;\"><a href='https://dealerportal.lstractorusa.com/lsdp/'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 95px;text-: center;border-radius: 5px 5px 5px 5px;text-decoration: none;\"><span class='l-btn-left'><span class='l-btn-text'>Details</span></span></a></td>");
		//		content.append("						<td style=\"text-align: center;width: 107px;\"><a href='http://cnode.iptime.org:30/lsdp/retnEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 95px;text-: center;border-radius: 5px 5px 5px 5px;text-decoration: none;\"><span class='l-btn-left'><span class='l-btn-text'>Details</span></span></a></td>");
//		content.append("						<td style=\"text-align: center;width: 107px;\"><a href='http://52.40.215.183:8080/lsdp/retnEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 145px;text-: center;border-radius: 5px 5px 5px 5px;text-decoration: none;\"><span class='l-btn-left'><span class='l-btn-text'>Go to Detail</span></span></a></td>");
//		content.append("						<td style=\"text-align: center;width: 107px;\"><a href='https://dealerportal.lstractorusa.com/lsdp/retnEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 145px;text-: center;border-radius: 5px 5px 5px 5px;text-decoration: none;\"><span class='l-btn-left'><span class='l-btn-text'>Go to Detail</span></span></a></td>");
		content.append("					</tr>");                                                     
		content.append("				</table>");
		
		content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
		content.append("					<tr>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
		content.append("					</tr>");
		for(Map<String, Object> mapInfo :trInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		for(Map<String, Object> mapInfo :attaInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		content.append("				</table>");
		content.append("				<table style=\"width:85%;\">");
		content.append("					<tr>");
		content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
		content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
		content.append("						</th>");
		content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
		content.append("					</tr>");
		content.append("				</table>");
		content.append("               <div style=\"text-align:center;width:980px;\">");
		content.append("              <a href=\"https://dealerportal.lstractorusa.com/lsdp/retnEmail?auth=TOKEN_VAL\" id=\"regist-button\" style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 145px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\" target=\"_blank\"><span class=\"l-btn-left\"><span class=\"l-btn-text\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Go to Detail&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>        </div>");	
		content.append("				<table style=\"width:85%; text-align:left;\">");
		content.append("					<tr>");
		content.append("						<th style=\"color:#0174DF; text-align:left\">");
		content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com/lsdp\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
		content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
		content.append("						</th>");
		content.append("					</tr>");
//		//2021-04-20 리턴 메일 거부
//		content.append("					<tr>");
//		content.append("						<th style=\"color:#0174DF; text-align:left\">");
//		content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=RETURN&auth=TOKEN_VAL' >");
//		content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
//		content.append("						</th>");
//		content.append("					</tr>");
		content.append("				</table>");
		//2021-04-21 리턴 메일 거부
		content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
		content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
//		content.append("							<a style=\"text-decoration:none\" href='http://52.40.215.183:8080/lsdp/unsubscribe?type=RETURN&auth=TOKEN_VAL' >");
		content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=RETURN&auth=TOKEN_VAL' >");
		content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
		content.append("						<div>");
		content.append("					</div>");
		
		content.append("			</div>");
		content.append("		</div>");
		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		
		
		return content.toString();
	}
	
	public static String CouponMailForm(String name, String couponNo, String expDate, String path) {
		
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:700px; height:auto;\" src=\""+path+"\">");
		content.append("		</div>");
		content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:700px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("			<p style=\"font-size:25px; text-align: center; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; \">Thank you for your request<br><br><br>[Coupon Information]</p><br>");
		content.append("			<p style=\"font-size:25px; text-align: center; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; \"><span style='background-color:yellow'>"+couponNo+"</span></p><br>");
		content.append("			<p style=\"font-size:25px; text-align: center; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; \">"+name + " coupon expires in "+ expDate +"</p>");
		content.append("			<div style=\"padding-left:20px; padding-top: 50px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("				<table style=\"width:85%; text-align:left;\">");
		content.append("					<tr>");
		content.append("						<th style=\"color:#0174DF; text-align:left\">");
		content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://p-lsta-alb-1682534392.us-west-2.elb.amazonaws.com/lsdp_data/upload/mail/c2.jpg\">");
		content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
		content.append("						</th>");
		content.append("					</tr>");
		content.append("				</table>");
		content.append("			</div>");
		content.append("		</div>");
		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		return content.toString();
	}
	
	public static String MailNdaTitle(Map<String, Object> mainInfo, String flg, String applId) {
		StringBuffer title = new StringBuffer();
		if("P01".equals(flg)) {
			title.append("LS Dealer Application : Waiting to Work( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("P02".equals(flg)){
			title.append("LS Dealer Application : Waiting to Review( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("P03".equals(flg)){
			title.append("LS Dealer Application : Waiting to Documents( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("P04".equals(flg)){
			title.append("LS Dealer Application : Reviewed( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("P05".equals(flg)){
			title.append("LS Dealer Application : Waiting for Approval( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("P06".equals(flg)){
			title.append("LS Dealer Application : Waiting for Documents( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("P07".equals(flg)){
			title.append("LS Dealer Application : Rejected( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("P08".equals(flg)){
			title.append("LS Dealer Pre-application : Approved( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("PreCmpt".equals(flg)){
			title.append("LS Dealer Application : Ready for Assessment( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R01".equals(flg)){
			title.append("LS Dealer Application : Waiting to Work( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R02".equals(flg)){
			title.append("LS Dealer Application : Waiting to Review for documents" + "( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R03".equals(flg)){
			title.append("LS Dealer Application : Waiting to Documents( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R04".equals(flg)){
			title.append("LS Dealer Application : Reviewed( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R05".equals(flg)){
			title.append("LS Dealer Application : Waiting for Approval( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R06".equals(flg)){
			title.append("LS Dealer Application : Waiting for Documents( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R07".equals(flg)){
			title.append("LS Dealer Application : Rejected( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("R08".equals(flg)){
			title.append("LS Dealer Application : Approved( " + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") + " )");
		} else if("M01".equals(flg)){
			title.append("Welcome new LS Tractor dealer, " + mainInfo.get("deal_ship"));
		} else if("M02".equals(flg)){
			title.append("New dealer has been approved.( " + mainInfo.get("deal_ship") + " )");
		}
		return title.toString();
	}
	
	public static String MailNdaPreForm(Map<String, Object> mainInfo, List<Map<String, Object>> applList, String flg, String applId, String applIdView, String pwd) {
		
		
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		
		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		
		//상위 타이틀		
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:130px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/lsta_logo2.png\">");
		content.append("		</div>");
		content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		if("P01".equals(flg)) {
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" have been ready.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("lsta_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-weight: 400; \">Your application have been ready.</p>");
			content.append("		<p style=\"font-weight: 400; margin-bottom: 10px;\">Please access the link and fill out the application form.</p>");
		} else if("P02".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" have been Submitted.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Dealer )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("deal_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
		} else if("P03".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" have been Waiting For additional documents.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Type</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_type") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("lsta_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-weight: 400; \">Your application needs to be Reviewed.</p>");
			content.append("		<p style=\"font-weight: 400; margin-bottom: 10px;\">Please access the link and complete the application form.</p>");
		} else if("P04".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" was reviewed.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Type</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_type") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("lsta_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-weight: 400; \">Your application was reviewed.</p>");
			content.append("		<p style=\"font-weight: 400; margin-bottom: 10px;\">We'll let you know once the pre-approval is approved.</p>");
		} else if("P05".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" have been requesting approval.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Type</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_type") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
		} else if("P06".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" have been requesting Additional documents.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Type</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_type") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Approver )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("appr_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
		} else if("P07".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" was rejected.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Type</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_type") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Approver )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("appr_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
		} else if("P08".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Pre-application - "+mainInfo.get("temp_id")+" was approved.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Type</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_type") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Approver )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("appr_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
		} else if("PreCmpt".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" was ready for assessment.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + " - " + mainInfo.get("deal_ship") +"</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Location Address</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; \">" + mainInfo.get("biz_loc_addr") + " " + mainInfo.get("biz_city") + " " + mainInfo.get("biz_stat") + " " + mainInfo.get("biz_zip")+ " " + mainInfo.get("biz_coty") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Principal owner</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; \">" + mainInfo.get("prcl_ownr")  + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Tel#</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; padding: 5px 0; width: 500px; padding: 5px 20px;\">" + "<a href=\"tel:" + mainInfo.get("biz_tel") + "\" style=\"color: black;\">" + mainInfo.get("biz_tel") + "</a></td>");
			content.append("			</tr>");
			content.append("			<tr>");
			String website = (String) mainInfo.get("web_site");
			if (website != null && !website.isEmpty() && !website.startsWith("https://")) {
			    website = "https://" + website;
			}
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">Website</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; padding: 5px 0; width: 500px; padding: 5px 20px;\">" + "<a style='color: black;' href=\"" + website + "\" target=\"_blank\">" + mainInfo.get("web_site") + "</a>" + "</td>");
			content.append("			</tr>");
			if(!mainInfo.get("sale_tel").equals("")){
				content.append("			<tr>");
				content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-bottom: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Sales Manager</td>");
				content.append("				<td style=\"border-bottom: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("sale_mang") + " : " + "<a style='color: black;' href=\"tel:" + mainInfo.get("sale_tel") + "\">" + mainInfo.get("sale_tel") + "</a>, " + "<a style='color: black;' href=\"mailto:" + mainInfo.get("sale_mail") + "\">" + mainInfo.get("sale_mail") + "</a>" +"</td>");
				content.append("			</tr>");
			} if(!mainInfo.get("part_tel").equals("")){
				content.append("			<tr>");
				content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-bottom: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Parts Manager</td>");
				content.append("				<td style=\"border-bottom: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("part_mang") + " : " + "<a style='color: black;' href=\"tel:" + mainInfo.get("part_tel") + "\">" + mainInfo.get("part_tel") + "</a>, " + "<a style='color: black;' href=\"mailto:" + mainInfo.get("part_mail") + "\">" + mainInfo.get("part_mail") + "</a>" + "</td>");
				content.append("			</tr>");
			} if(!mainInfo.get("svc_tel").equals("")){
				content.append("			<tr>");
				content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-bottom: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Service Manager</td>");
				content.append("				<td style=\"border-bottom: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("svc_mang") + " : " + "<a style='color: black;' href=\"tel:" + mainInfo.get("svc_tel") + "\">" + mainInfo.get("svc_tel") + "</a>, "  + "<a style='color: black;' href=\"mailto:" + mainInfo.get("svc_mail") + "\">" + mainInfo.get("svc_mail") + "</a>" +  "</td>");
				content.append("			</tr>");
			}
			content.append("		</table>");
/*			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");*/
			} else if("R01".equals(flg)) {
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" have been ready.</p>");
		} else if("R02".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+"'s documents Have been Submitted.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Dealer )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("deal_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:400; color:#0174DF;\">Application Status : </p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; margin-bottom: 40px; max-width: 766px; font-size: 15px;\">");
			content.append("			<colgroup>");
			content.append("				<col width='10%'>");
			content.append("				<col width='70%'>");
			content.append("				<col width='15%'>");
			content.append("			</colgroup>");
			for(Map<String, Object> newApplList: applList) {
				if(newApplList.get("applId").toString().equals("F17")){
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("Documents") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				} else {
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				}
			}
			content.append("		</table>");
		} else if("R03".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+"'s "+applIdView+" Requesting additional documents.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("lsta_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-weight: 400; \">Your application needs additional documents.</p>");
			content.append("		<p style=\"font-weight: 400; margin-bottom: 10px;\">Please access the link and complete the application form.</p>");
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:400; color:#0174DF;\">Application Status : </p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; margin-bottom: 40px; max-width: 766px; font-size: 15px;\">");
			content.append("			<colgroup>");
			content.append("				<col width='10%'>");
			content.append("				<col width='70%'>");
			content.append("				<col width='15%'>");
			content.append("			</colgroup>");
			for(Map<String, Object> newApplList: applList) {
				if(newApplList.get("applId").toString().equals("F13")){
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				} else {
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				}
			}
			content.append("		</table>");
		} else if("R04".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" has been reviewed.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("lsta_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-weight: 400; \">Your application has been reviewed.</p>");
			content.append("		<p style=\"font-weight: 400; margin-bottom: 10px;\">We’ll let you know once the final approval is complete.</p>");
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:400; color:#0174DF;\">Application Status : </p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; margin-bottom: 40px; max-width: 766px; font-size: 15px;\">");
			content.append("			<colgroup>");
			content.append("				<col width='10%'>");
			content.append("				<col width='70%'>");
			content.append("				<col width='15%'>");
			content.append("			</colgroup>");
			for(Map<String, Object> newApplList: applList) {
				if(newApplList.get("applId").toString().equals("F13")){
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				} else {
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF;\"><span style=\\\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				}
			}
			content.append("		</table>");
		} else if("R05".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" have been requesting approval.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:400; color:#0174DF;\">Application Status : </p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; margin-bottom: 40px; max-width: 766px; font-size: 15px;\">");
			content.append("			<colgroup>");
			content.append("				<col width='10%'>");
			content.append("				<col width='70%'>");
			content.append("				<col width='15%'>");
			content.append("			</colgroup>");
			for(Map<String, Object> newApplList: applList) {
				if(newApplList.get("applId").toString().equals("F17")){
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				} else {
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				}
			}
			content.append("		</table>");
		} else if("R06".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" Requesting additional documents.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Approver )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("appr_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:400; color:#0174DF;\">Application Status : </p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; margin-bottom: 40px; max-width: 766px; font-size: 15px;\">");
			content.append("			<colgroup>");
			content.append("				<col width='10%'>");
			content.append("				<col width='70%'>");
			content.append("				<col width='15%'>");
			content.append("			</colgroup>");
			for(Map<String, Object> newApplList: applList) {
				if(newApplList.get("applId").toString().equals("F17")){
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				} else {
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				}
			}
			content.append("		</table>");
		} else if("R07".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" was rejected.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#ff0000;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Approver )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("appr_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:400; color:#0174DF;\">Application Status : </p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; margin-bottom: 40px; max-width: 766px; font-size: 15px;\">");
			content.append("			<colgroup>");
			content.append("				<col width='10%'>");
			content.append("				<col width='70%'>");
			content.append("				<col width='15%'>");
			content.append("			</colgroup>");
			for(Map<String, Object> newApplList: applList) {
				if(newApplList.get("applId").toString().equals("F17")){
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				} else {
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				}
			}
			content.append("		</table>");
		} else if("R08".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">Dealer Application - "+mainInfo.get("temp_id")+" was approved.</p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership ( Legal Name )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">DBA ( if applicable )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_dba") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Application Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealer E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Temporary ID</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("temp_id") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Status</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; color:#0174DF;\">" + mainInfo.get("appl_stat") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Remarks( LSTA Internal )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("lsta_inte_remk") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Remarks( Approver )</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">" + mainInfo.get("appr_remk") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
			content.append("		<p style=\"color: #919191; font-style: italic; margin: 10px 0; text-align: right; max-width: 766px; font-weight: 400;\">Last Updated by " + mainInfo.get("last_user") + " at " + mainInfo.get("last_date") +"</p>");
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:400; color:#0174DF;\">Application Status : </p>");
			content.append("		<table style=\"border-spacing: 0; margin-top: 20px; margin-bottom: 40px; max-width: 766px; font-size: 15px;\">");
			content.append("			<colgroup>");
			content.append("				<col width='10%'>");
			content.append("				<col width='70%'>");
			content.append("				<col width='15%'>");
			content.append("			</colgroup>");
			for(Map<String, Object> newApplList: applList) {
				if((newApplList.get("applId").toString().equals("F13") && newApplList.size() == 12) || (newApplList.get("applId").toString().equals("F17"))){
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\\\"margin-bottom:0px;\\\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; border-bottom: 1px solid #CCCCCC;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				} else {
					content.append("		<tr>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; text-align: center;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("applIdView") + "</span></td>");
					content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; white-space: pre;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("codeDesc") + "</span></td>");
					if(newApplList.get("STAT").equals("Needs review")){
						content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
					} else {
						if(newApplList.get("STAT").toString().equals("Reviewed")){
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0; font-weight: 600; color: #0174DF;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						} else {
							content.append("			<td style=\"border-top: 1px solid #CCCCCC; padding: 5px 0;\"><span style=\"margin-bottom:0px;\">" + newApplList.get("STAT") +"</span></td>");
						}
					}
					content.append("		</tr>");
				}
			}
			content.append("		</table>");
		} else if("M01".equals(flg)){
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("biz_now") + "</p><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("prcl_ownr") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("deal_ship") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("biz_loc_addr") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("biz_city") + ", " + mainInfo.get("biz_stat") + " " + mainInfo.get("biz_zip") +"</p><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\"> Dear " + mainInfo.get("prcl_ownr") +"</p><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">It is with great pleasure that I welcome you to the LS Tractor family! We’re pleased to</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">have you on our team and look forward to working with you. In anticipation of this day</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">the LS support teams have completed your onboarding procedures to ensure that you’ll</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">have a seamless experience during the next few weeks.</p><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">Please keep your Business Manager’s contact information handy as he is your key</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">liaison to LS Tractor. He will answer questions, set up product and service training,</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">provide industry retail data for your territory, assist with selecting tractors and</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">implements for your first order and provide a broad variety of other support.</p><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">By now you’ve received an email that included your dealer number and Dealer Portal</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">instructions.  The Dealer Portal contains virtually all the information you’ll need to keep</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">your dealership running smoothly, including product training videos, marketing support,</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">co-op information, pricing and programs, and lots of other useful information. I</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">encourage you to spend time learning your way around and exploring all its features.</p><br/>");
//			content.append("		<p style=\"font-size:15px; font-weight: 300;\">Within the next few days, I’ll call you to personally introduce myself and get to know you</p>");
//			content.append("		<p style=\"font-size:15px; font-weight: 300;\">and your dealership. And remember, you and your team have an open invitation to visit</p>");
//			content.append("		<p style=\"font-size:15px; font-weight: 300;\">our Battleboro, NC headquarters any time to meet our teams.</p><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">We appreciate your confidence and will work hard to keep earning your trust every day.</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">Thanks again for joining our LS Tractor family!</p><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300; padding-bottom: 10px;\">Best Regards,</p>");
//			content.append("		<img style=\"height:100px;\" src='http://52.40.215.183:8080/lsdp_data/upload/real" + mainInfo.get("filePath") + "/" + mainInfo.get("saveName") + "' alt='Sign Image'/><br/>");
			content.append("		<img style=\"height:100px;\" src='https://dealerportal.lstractorusa.com/lsdp_data/upload/real" + mainInfo.get("filePath") + "/" + mainInfo.get("saveName") + "' alt='Sign Image'/><br/>");
			content.append("		<p style=\"font-size:15px; font-weight: 300; padding-top: 10px;\">" + mainInfo.get("ext_chr01") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("ext_chr02") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("ext_chr03") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300; padding-top: 10px;\">" + mainInfo.get("ext_chr04") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("ext_chr05") + "</p>");
			content.append("		<p style=\"font-size:15px; font-weight: 300;\">" + mainInfo.get("ext_chr06") + "</p>");
		} else if("M02".equals(flg)){
			content.append("		<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">New dealer has been approved.</p>");
			content.append("		<table style=\"border-spacing: 0; margin: 20px 0; font-size: 15px;\">");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Dealership Name</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("deal_ship") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Business Manager</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_bm") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">E-Mail</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appl_mail") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Phone</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("biz_tel") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Address</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("biz_loc_addr") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px;\">Approval Date</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; padding: 5px 20px;\">" + mainInfo.get("appr_date") + "</td>");
			content.append("			</tr>");
			content.append("			<tr>");
			content.append("				<td style=\"background: #F2F2F2; font-family: 'Amazon Ember',Arial,sans-serif!important; border-left: none; border-top: 1px solid #CCCCCC; border-right: none; padding: 5px 20px; border-bottom: 1px solid #CCCCCC;\">Dealer Code</td>");
			content.append("				<td style=\"border-top: 1px solid #CCCCCC; border-right: none; border-left: 1px solid #CCCCCC;  padding: 5px 0; width: 500px; border-bottom: 1px solid #CCCCCC; padding: 5px 20px;\">" + mainInfo.get("deal_code") + "</td>");
			content.append("			</tr>");
			content.append("		</table>");
		}
		/*content.append("			<p style=\"font-size:15px;\">Dealer : <span style=\"color:#FE2E2E;\">"+mainInfo.get("DEAL_NAME")+"</span></p>");
		content.append("			<br><p>[Order Summary]</p>");
		
		content.append("			<div style=\"padding-left:20px; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("				<table style=\"width:85%;\">");
		content.append("					<tr>");
		content.append("						<td colspan=\"1\" style=\"text-align:left; border:0px;\"></td>");
		content.append("						<td colspan=\"2\" style=\"text-align:right; border:0px;\">Currency: "+mainInfo.get("PAY_CURR")+"</td>");
		content.append("						<td style=\"text-align: center;width: 107px;\"><a href='http://52.40.215.183:8080/lsdp/retnEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 145px;text-: center;border-radius: 5px 5px 5px 5px;text-decoration: none;\"><span class='l-btn-left'><span class='l-btn-text'>Go to Application</span></span></a></td>");
		content.append("					</tr>");                                                     
		content.append("				</table>");
		
		content.append("				<table style=\"width:85%;margin-top:15px;border:1px solid #424242;border-bottom:0px;border-right:0px;border-collapse:collapse;\" class=\"Mtable\">");
		content.append("					<tr>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Catalog</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Model</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Description</th>");
		content.append("						<th style=\"background-color:#E5F3FF;text-align:center;font-size:14px;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px;\">Price</th>");
		content.append("					</tr>");
		for(Map<String, Object> mapInfo :trInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		for(Map<String, Object> mapInfo :attaInfo) {
		content.append("					<tr>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_TYPE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_CODE_NM")+"</td>");
		content.append("						<td style=\"border-bottom:1px solid #424242; border-right:1px solid #424242; text-align:center; font-size:14px;  padding:8px;\">"+mapInfo.get("ITEM_NAME")+"</td>");
		content.append("						<td style=\"text-align:right;border-bottom:1px solid #424242;border-right:1px solid #424242;padding:8px; font-size:14px;\">"+mapInfo.get("ITEM_AMT_FM")+"</td>");
		content.append("					</tr>");
		}
		content.append("				</table>");
		content.append("				<table style=\"width:85%;\">");
		content.append("					<tr>");
		content.append("						<th style=\"font-size: 12px; color: white; text-align: right;\" colspan=\"3\">");
		content.append("							<img style=\"width:110px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/b1.jpg\">");
		content.append("						</th>");
		content.append("						<th style=\"color:#0174DF; width:230px; text-align:right;\">"+mainInfo.get("GROS_AMT_FM")+"</th>");
		content.append("					</tr>");
		content.append("				</table>");
		content.append("				<table style=\"width:85%; text-align:left;\">");
		content.append("					<tr>");
		content.append("						<th style=\"color:#0174DF; text-align:left\">");
		content.append("							<a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com/lsdp\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp_data/upload/mail/c2.jpg\">");
		content.append("							<span style=\"vertical-align: super;\">https://dealerportal.lstractorusa.com</a></span>");
		content.append("						</th>");
		content.append("					</tr>");
		content.append("				</table>");
		content.append("					<div style='border-top: 2px solid lightgray; height:45px;'>");
		content.append("						<div style=\"color:#0174DF; text-align:center; margin-top:20px;\">");
		content.append("							<a style=\"text-decoration:none\" href='http://dealerportal.lstractorusa.com/lsdp/unsubscribe?type=RETURN&auth=TOKEN_VAL' >");
		content.append("							<span style=\"vertical-align: super;\"> Unsubscribe from all future emails </a></span>");
		content.append("						<div>");
		content.append("					</div>");
		content.append("			</div>");*/
		content.append("		</div>");
		//content.append("        <a href='http://localhost:8080/lsdp/ndaEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 200px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\"><span class='l-btn-left'><span class='l-btn-text'>Go to Application</span></span></a>");
		if("M01".equals(flg)){
			content.append("		<p style=\"color: #919191; font-style: italic; margin-top: 40px; text-align: center; max-width: 580px; font-weight: 400;\"> " + mainInfo.get("ext_chr07") + "</p>");
			content.append("		<p style=\"color: #919191; font-style: italic; text-align: center; max-width: 580px; font-weight: 400;\">" + mainInfo.get("ext_chr08") + "</p>");
		} else if("M02".equals(flg)){
			content.append("		<a href='https://dealerportal.lstractorusa.com' style=\"display: block; margin-bottom: 10px;\">https://dealerportal.lstractorusa.com</a>");
//			content.append("		<a href='http://52.40.215.183:8080/lsdp/' style=\"display: block; margin-bottom: 10px;\">https://dealerportal.lstractorusa.com/</a>");
			content.append("		<p style=\"font-weight: 600;\">LS TRACTOR USA</p>");
			content.append("		<p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p>");
			content.append("		<p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p>");
		}else {
			content.append("        <br/>");
			if("P01".equals(flg)){
				content.append("        <div style=\"width:980px;\">");
				content.append("		<a href='https://dealerportal.lstractorusa.com' style=\"display: block; margin-bottom: 10px;\">https://dealerportal.lstractorusa.com/</a>");
//				content.append("		<a href='http://52.40.215.183:8080/lsdp/' style=\"display: block; margin-bottom: 10px;\">https://dealerportal.lstractorusa.com/</a>");
				content.append("        <p style=\"font-weight:600;\">Access ID : "+mainInfo.get("temp_id")+"</p>");
				content.append("        <p style=\"font-weight:600;\">Password : "+pwd+"</p>");
				content.append("        </div>");
				content.append("        <div style=\"text-align:center;width:980px;\">");
				content.append("        <a href='https://dealerportal.lstractorusa.com/lsdp/ndaEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 200px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Register Now&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
//				content.append("        <a href='http://52.40.215.183:8080/lsdp/ndaEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 200px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Register Now&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
				content.append("        </div>");
				content.append("        <br/><br/>");
				content.append("		<p style=\"font-weight: 600;\">LS TRACTOR USA</p>");
				content.append("		<p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p>");
				content.append("		<p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p>");
			} else if("PreCmpt".equals(flg)){
				content.append("        <div style=\"text-align:center;width:980px;\">");
//				content.append("        <a href='https://dealerportal.lstractorusa.com/lsdp/ndaEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 200px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Go to Application&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
//				content.append("        <a href='http://52.40.215.183:8080/lsdp/ndaEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 200px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Go to Application&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
				content.append("        </div>");
				content.append("        <br/><br/>");
				content.append("		<p style=\"font-weight: 600;\">LS TRACTOR USA</p>");
				content.append("		<p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p>");
				content.append("		<p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p>");
			} else {
				content.append("        <div style=\"text-align:center;width:980px;\">");
				content.append("        <a href='https://dealerportal.lstractorusa.com/lsdp/ndaEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 200px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Go to Application&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
//				content.append("        <a href='http://52.40.215.183:8080/lsdp/ndaEmail?auth=TOKEN_VAL'  id='regist-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 200px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 300px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Go to Application&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
				content.append("        </div>");
				content.append("        <br/><br/>");
				content.append("		<a href='https://dealerportal.lstractorusa.com/lsdp/' style=\"display: block; margin-bottom: 10px;\">https://dealerportal.lstractorusa.com/</a>");
//				content.append("		<a href='http://52.40.215.183:8080/lsdp/' style=\"display: block; margin-bottom: 10px;\">https://dealerportal.lstractorusa.com/</a>");
				content.append("		<p style=\"font-weight: 600;\">LS TRACTOR USA</p>");
				content.append("		<p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p>");
				content.append("		<p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p>");
			}
		}
		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		
		
		return content.toString();
	}
	
	
	public static String MailPassTitle(String mailId) {
		StringBuffer title = new StringBuffer();
			title.append("LSTA Gate Pass has been issued (" + mailId + " )");
		return title.toString();
	}
	
	public static String MailPassForm(String mailId,String Cmail,String PassDate,String PassTime,String gpNo,String GateToUse,String BolNo) {		
		
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		
		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		
		//상위 타이틀		
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:130px; height:auto;\" src=\"https://scm.lstractorusa.com/lslogi_data/upload/mail/lsta_logo2.png\">");
		content.append("		</div>");
		content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">LSTA Gate Pass has been issued (" + mailId + ")</p>");
		content.append("		</div>");
		content.append("        <br/>");
		content.append("			<p style=\"font-weight: 600; font-size:25px;\">Will be going on the &nbsp;&nbsp;"+ PassDate +" "+ PassTime+"</p>");
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Gate Pass No&nbsp;:&nbsp;&nbsp;</span>"+gpNo);
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Gate To Use&nbsp;:&nbsp;&nbsp;</span>"+GateToUse);
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Container No&nbsp;:&nbsp;&nbsp;</span>");
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Bol No&nbsp;:&nbsp;&nbsp;</span>"+BolNo);
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Invoice&nbsp;:&nbsp;&nbsp;</span>");
		content.append("        <br/>");
		content.append("        <br/>");
//		content.append("			<span class='l-btn-text'>Check:&nbsp;&nbsp;</span><a href='http://35.155.122.34:8080/lslogi/gatepasscheck.do?gpNo=" + gpNo + "' style=\"display: inline-block; margin-bottom: 10px;\">http://35.155.122.34:8080/lslogi/gatepasscheck</a>");
		content.append("			<span class='l-btn-text'>Check&nbsp;:&nbsp;&nbsp;</span><a href='https://scm.lstractorusa.com/lslogi/gatepasscheck.do?gpNo=" + gpNo + "' style=\"display: inline-block; margin-bottom: 10px;\">https://scm.lstractorusa.com/lslogi/gatepasscheck</a>");
		content.append("        <br/>");
//		content.append("			<span class='l-btn-text'>Print:&nbsp;&nbsp;</span><a href='http://35.155.122.34:8080/lslogi/gatepasscheckprint.do?gpNo=" + gpNo + "' style=\"display: inline-block; margin-bottom: 10px;\">http://35.155.122.34:8080/lslogi/gatepasscheckprint</a>");
		content.append("			<span class='l-btn-text'>Print&nbsp;:&nbsp;&nbsp;</span><a href='https://scm.lstractorusa.com/lslogi/gatepasscheckprint.do?gpNo=" + gpNo + "' style=\"display: inline-block; margin-bottom: 10px;\">https://scm.lstractorusa.com/lslogi/gatepasscheckprint</a>");
		content.append("        <br/>");
		content.append("        <br/>");
//		content.append("        <a href='http://localhost:8080/lsdp/rejectEmail?auth=TOKEN_VAL' id='reject-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 150px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 200px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reject&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
//		content.append("        <a href='http://52.40.215.183:8080/lsdp/rejectEmail?auth=TOKEN_VAL' id='reject-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 150px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 200px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reject&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
		content.append("        <a href='https://dealerportal.lstractorusa.com/lsdp/rejectEmail?auth=TOKEN_VAL' id='reject-button' style=\"line-height: 35px;background: #002658;color: #fff;border-color: #244a87;display: inline-block;font-weight: 600;height: 35px;width: 150px;border-radius: 5px 5px 5px 5px;text-decoration: none; text-align: center; margin: 0 300px 25px 200px;\"><span class='l-btn-left'><span class='l-btn-text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reject&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span></a>");
		content.append("        <br/>");
		content.append("			<p style=\"font-weight: 600;\">LS TRACTOR USA</p>");
		content.append("			<p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p>");
		content.append("			<p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p>");
		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		
		
		return content.toString();
	}
	
	public static String MailRejectTitle(String mailId) {
		StringBuffer title = new StringBuffer();
			title.append("LSTA Gate Pass has been rejected (" + mailId + " )");
		return title.toString();
	}
	
	public static String MailRejectForm(String mailId,String Cmail,String PassDate,String PassTime,String gpNo,String GateToUse,String BolNo,String Reason) {
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		
		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		
		//상위 타이틀		
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:130px; height:auto;\" src=\"https://scm.lstractorusa.com/lslogi_data/upload/mail/lsta_logo2.png\">");
		content.append("		</div>");
		content.append("		<div id=\"createdCon\" style=\"margin-top:30px; width:980px; height:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		content.append("			<p style=\"font-size:30px;  font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; color:#0174DF;\">LSTA Gate Pass has been rejected (" + mailId + ")</p>");
		content.append("		</div>");
		content.append("        <br/>");
		content.append("			<p style=\"font-weight: 600; font-size:25px;\">Date : &nbsp;&nbsp;"+ PassDate +" "+ PassTime+"</p>");
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Gate Pass No&nbsp;:&nbsp;&nbsp;</span>"+gpNo);
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Gate To Use&nbsp;:&nbsp;&nbsp;</span>"+GateToUse);
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Container No&nbsp;:&nbsp;&nbsp;</span>");
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Bol No&nbsp;:&nbsp;&nbsp;</span>"+BolNo);
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Invoice&nbsp;:&nbsp;&nbsp;</span>");
		content.append("        <br/>");
		content.append("			<span class='l-btn-text'>Reason&nbsp;:&nbsp;&nbsp;</span>"+Reason);
		content.append("        <br/>");
		content.append("        <br/>");
//		content.append("			<span class='l-btn-text'>Check:&nbsp;&nbsp;</span><a href='http://35.155.122.34:8080/lslogi/gatepasscheck.do?gpNo=" + mailId + "' style=\"display: inline-block; margin-bottom: 10px;\">http://35.155.122.34:8080/lslogi/gatepasscheck</a>");
//		content.append("			<span class='l-btn-text'>Check&nbsp;:&nbsp;&nbsp;</span><a href='https://scm.lstractorusa.com/lslogi/gatepasscheck.do?gpNo=" + gpNo + "' style=\"display: inline-block; margin-bottom: 10px;\">https://scm.lstractorusa.com/lslogi/gatepasscheck</a>");
//		content.append("        <br/>");
//		content.append("			<span class='l-btn-text'>Print:&nbsp;&nbsp;</span><a href='http://35.155.122.34:8080/lslogi/gatepasscheckprint.do?gpNo=" + mailId + "' style=\"display: inline-block; margin-bottom: 10px;\">http://35.155.122.34:8080/lslogi/gatepasscheckprint</a>");
//		content.append("			<span class='l-btn-text'>Print&nbsp;:&nbsp;&nbsp;</span><a href='https://scm.lstractorusa.com/lslogi/gatepasscheckprint.do?gpNo=" + gpNo + "' style=\"display: inline-block; margin-bottom: 10px;\">https://scm.lstractorusa.com/lslogi/gatepasscheckprint</a>");
//		content.append("        <br/>");
//		content.append("        <br/>");
		content.append("        <br/>");
		content.append("			<p style=\"font-weight: 600;\">LS TRACTOR USA</p>");
		content.append("			<p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p>");
		content.append("			<p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p>");
		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		
		return content.toString();
	}
	
	public static String ProformaMailTitle(String ordrNo) {
		StringBuffer title = new StringBuffer();
			title.append("LSTA Proforma Invoice (" + ordrNo + " )");
		return title.toString();
	}

	
	public static String ProformaMailForm(String profNo, String profNo_token) {
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		
		content.append("</head>");
		content.append("<body>");
		content.append("	<div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");
		
		//상위 타이틀		
		content.append("		<div style=\"width:100%;\">");
		content.append("			<img style=\"width:130px; height:auto;\" src=\"https://scm.lstractorusa.com/lslogi_data/upload/mail/lsta_logo2.png\">");
		content.append("		</div>");
		content.append("		<table>");
		content.append("		    <tr>");
		content.append("		    	<td colspan=\"2\" style=\"font-size:24px; width: 95%;\"><p>Your Proforma Invoice is ready to print!</p><br></td>");
		content.append("		    </tr>");
		content.append("			<br>");
		
		content.append("		    <tr>");
		content.append("		    	<td colspan=\"2\" style=\"padding-top: 10px; font-size:15px; line-height:1.5; font-weight:500; width: 90%; min-width: 350px; max-width: 803px;\">");
		content.append("		    		<p style=\"margin: 10px 0 0 0;\">&nbsp;One or more of your wholegoods orders have been planned for production. ");
		content.append("		    		Because these orders have Cash in Advance payment terms, payment must be arranged before the load can be scheduled for delivery or pickup.</p>");
		content.append("		    		<p style=\"margin: 0 0 0 0;\">Please see the below proforma invoice(s) that may be used as reference. They may be viewed individually or as a group.</p>");
		content.append("		    	</td>");
		content.append("		    </tr>");
		
		content.append("			<tr>");
		content.append("				<td style=\"font-size:15px; width: 25px;\">Proforma Invoice # - <a style=\"text-decoration: underline; color: #642EFE;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no="+ profNo_token +"\">"+profNo+"</td>");
		content.append("				<td style=\"font-size:15px;\"><a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no="+ profNo_token +"\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp/resources/images/printer.png\"></td>");
/* 개발 프린트
		content.append("				<td style=\"font-size:15px; width: 25px;\">Proforma Invoice # - <a style=\"text-decoration: underline; color: #642EFE;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no="+ profNo_token +"\">"+profNo+"</td>");
		content.append("				<td style=\"font-size:15px;\"><a style=\"text-decoration:none\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no="+ profNo_token +"\"><img style=\"width:18px; height:auto; margin-right:10px;\" src=\"https://dealerportal.lstractorusa.com/lsdp/resources/images/printer.png\"></td>");
*/
		content.append("			</tr>");
		
		content.append("		    <tr>");
		content.append("		    	<td colspan=\"2\" style=\"padding-top: 10px; font-size:15px; line-height:1.5; font-weight:500; width: 90%; min-width: 350px; max-width: 780px;\">");
		content.append("		    		<p style=\"margin: 10px 0 0 0;\">&nbsp;Please log into the LS Dealer Portal and visit the Order Progress screen to provide payment details for these orders.</p>");
		content.append("		    		<p style=\"margin: 0 0 0 0;\">Note that payment must be provided for the entire planned load in order to proceed with production. ");
		content.append("		    		If it is necessary to make changes to the planned load or if you have questions about the amounts, please contact your Sales Support Specialist.</p>");
		content.append("		    	</td>");
		content.append("		    </tr>");
		
		content.append("			<tr>");
		content.append("				<td colspan=\"2\"><br><p style=\"font-weight: 600;\">*Serial No may change depending on production schedule and material condition.</p></td>");
		content.append("			</tr>");
		content.append("			<tr>");
		content.append("				<td colspan=\"2\"><p style=\"font-weight: 600;\">*This proforma invoice is valid for 5 business days from the date of issuance.</p></td>");
		content.append("			</tr>");
		content.append("			<tr>");
		content.append("				<td colspan=\"2\"><p style=\"font-weight: 600;\">*If payment is not received prior to expiration it may result in cancellation of the </p></td>");
		content.append("			</tr>");
		content.append("			<tr>");
		content.append("				<td colspan=\"2\"><p style=\"font-weight: 600; text-indent: 15px;\">proforma invoice and assigned unit(s) to be reallocated to the next order in line.</p><br><br></td>");
		content.append("			</tr>");
		content.append("			<tr>");
		content.append("				<td colspan=\"2\"><p style=\"font-weight: 600;\">LS TRACTOR USA</p></td>");
		content.append("			</tr>");
		content.append("			<tr>");
		content.append("				<td colspan=\"2\"><p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p></td>");
		content.append("			</tr>");
		content.append("			<tr>");
		content.append("				<td colspan=\"2\"><p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p></td>");
		content.append("			</tr>");
		content.append("		</table>");
		content.append("	</div>");
		content.append("</body>");
		content.append("</html>");
		
		return content.toString();
	}
	public static String ProformaMailTitleMulti(Map<String, Object> mainInfo) {
		StringBuffer title = new StringBuffer();
		title.append("LSTA Proforma Invoice (" + mainInfo.get("payChkDealInvNo") + " )");
		return title.toString();
	}
	public static String ProformaMailFormMulti(Map<String, Object> mainInfo) {
		StringBuffer content = new StringBuffer();
		
		content.append("<!DOCTYPE html>");
		content.append("<html>");
		content.append("<head>");
		content.append("<meta charset=\"UTF-8\">");
		content.append("<title>created</title>");
		content.append("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css\">");
		content.append("</head>");
		content.append("<body>");
		content.append("  <div style=\"width:100%; height:auto; margin:auto; font-family: 'Amazon Ember',Arial,sans-serif!important; font-weight:600; font-size:15px;\">");

		content.append("    <div style=\"width:100%;\">");
		content.append("      <img style=\"width:130px; height:auto;\" src=\"https://scm.lstractorusa.com/lslogi_data/upload/mail/lsta_logo2.png\">");
		content.append("    </div>");

		content.append("    <div style=\"width:100%;\">");
		content.append("      <div class=\"row\" style=\"margin-top:10px;\">");
		content.append("        <div class=\"cell\" style=\"font-size:24px;\"><p>Your Proforma Invoice is ready to print!</p></div>");
		content.append("      </div>");

		content.append("      <div class=\"row\" style=\"margin-top:10px;\">");
		content.append("        <div class=\"cell\" style=\"font-size:15px; line-height:1.5; font-weight:500; width: 90%; min-width: 350px; max-width: 803px;\">");
		content.append("          <p>");
		content.append("            &nbsp;One or more of your wholegoods orders have been planned for production. ");
		content.append("            Because these orders have Cash in Advance payment terms, payment must be arranged before the load can be scheduled for delivery or pickup. ");
		content.append("          </p>");
		content.append("          <p style=\"\">");
		content.append("           Please see the below proforma invoice(s) that may be used as reference. They may be viewed individually or as a group. ");
		content.append("          </p>");
		content.append("        </div>");
		content.append("      </div>");

		
		content.append("      <div class=\"row\" style=\"margin-top:10px;\">");
		content.append("        <div class=\"cell\" style=\"width:90%; max-width: 803px; border:1px solid #ddd; border-collapse:collapse;min-width: 350px;\">");

		content.append("          <div class=\"row\" style=\"display:flex;\">");
		content.append("            <div class=\"cell\" style=\"text-align:left; font-weight:600; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:130px; font-size:15px;\">Total PO Amount</div>");
		content.append("            <div class=\"cell\" style=\"padding:8px; font-weight:600; border-bottom: 1px solid #ddd; flex:1;\">" + mainInfo.get("poTotalAmt") + "</div>");
		content.append("          </div>");

		content.append("          <div class=\"row\" style=\"display:flex;\">");
		content.append("            <div class=\"cell\" style=\"text-align:left; font-weight:600; padding:8px; background-color:#F2F2F2; border-bottom: 1px solid #ddd; width:130px; font-size:15px;\">Payment Group #</div>");
		content.append("            <div class=\"cell\" style=\"padding:8px; font-weight:600; border-bottom: 1px solid #ddd; flex:1;\">");
		content.append("              <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">" + mainInfo.get("payChkDealInvNo") + "</a>");
		content.append("              <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">");
/* 개발 프린트
		content.append("              <a style=\"text-decoration: underline; color: #642EFE; margin-right: 10px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">" + mainInfo.get("payChkDealInvNo") + "</a>");
		content.append("              <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + mainInfo.get("profInvNoListEnc2") + "\">");
*/
		content.append("                <img style=\"width:18px; height:auto;\" src=\"https://dealerportal.lstractorusa.com/lsdp/resources/images/printer.png\">");
		content.append("              </a>");
		content.append("            </div>");
		content.append("          </div>");

		content.append("        </div>");
		content.append("      </div>");

		String profInvNoList = (String) mainInfo.get("profInvNoList");
		String profInvNoListEnc = (String) mainInfo.get("profInvNoListEnc");

		if (profInvNoList != null && !profInvNoList.isEmpty()
		        && profInvNoListEnc != null && !profInvNoListEnc.isEmpty()) {

		    String[] profInvArr = profInvNoList.split(",");
		    String[] profInvEncArr = profInvNoListEnc.split(",");

		    int len = Math.min(profInvArr.length, profInvEncArr.length);

		    content.append("      <div class=\"row\" style=\"padding-top:23px; font-size:15px; font-weight: 500;\">");

		    for (int i = 0; i < len; i++) {
		        String profNo = profInvArr[i];
		        String profNoEnc = profInvEncArr[i];

		        content.append("        <div style=\"margin-bottom:8px; display: flex; align-items: center; min-height: 22px; margin-left:9px;\">"); // min-height 추가
		        content.append("          <span style=\"margin-right: 10px; white-space: nowrap;\">Proforma Invoice # - </span>");
		        content.append("          <div style=\"display: flex; align-items: center; gap: 8px;\">");
		        content.append("            <a style=\"text-decoration: underline; color: #642EFE; white-space: nowrap; width:125px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">" + profNo + "</a>");
		        content.append("            <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">");
/* 개발 프린트
		        content.append("            <a style=\"text-decoration: underline; color: #642EFE; white-space: nowrap; width:125px;\" href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">" + profNo + "</a>");
		        content.append("            <a href=\"https://dealerportal.lstractorusa.com:8081/jasperserver/flow.html?_flowId=viewReportFlow&standAlone=true&ParentFolderUri=/reports/lspd&reportUnit=/reports/lsdp/PInvoice_dev&decorate=no&output=pdf&p_ordr_no=" + profNoEnc + "\">");
*/
		        content.append("              <img style=\"width:18px; height:auto; display: inline-block; vertical-align: middle;\" src=\"https://dealerportal.lstractorusa.com/lsdp/resources/images/printer.png\">");
		        content.append("            </a>");
		        content.append("          </div>");
		        content.append("        </div>");
		    }

		    content.append("      </div>");
		}

		content.append("      <div class=\"row\" style=\"margin-top:25px;\">");
		content.append("        <div class=\"cell\" style=\"font-size:15px; line-height:1.5; font-weight:500; width:90%; min-width: 350px; max-width: 780px;\">");
		content.append("          <p style=\"margin-top:10px;\">");
		content.append("            &nbsp;Please log into the LS Dealer Portal and visit the Order Progress screen ");
		content.append("            to provide payment details for these orders. ");
		content.append("          </p>");
		content.append("          <p style=\"\">");
		content.append("            Note that payment must be provided for the entire planned load in order to proceed with production. ");
		content.append("            If it is necessary to make changes to the planned load ");
		content.append("            or if you have questions about the amounts, please contact your Sales Support Specialist.");
		content.append("          </p>");
		content.append("        </div>");
		content.append("      </div>");

		
		content.append("		<div style=\"width: 90%; min-width: 350px; max-width: 803px;\">");
		content.append("      		<div class=\"row\" style=\"margin-top:20px;\"><p style=\"font-weight: 600;\">*Serial No may change depending on production schedule and material condition.</p></div>");
		content.append("      		<div class=\"row\"><p style=\"font-weight: 600;\">*This proforma invoice is valid for 5 business days from the date of issuance.</p></div>");
		content.append("      		<div class=\"row\"><p style=\"font-weight: 600;\">*If payment is not received prior to expiration it may result in cancellation of the proforma invoice and assigned unit(s) to be reallocated to the next order in line.</p></div>");
		content.append("      		<div class=\"row\"><p style=\"font-weight: 600; text-indent: 15px;\"></p><br><br></div>");
		content.append("      		<div class=\"row\"><p style=\"font-weight: 600;\">LS TRACTOR USA</p></div>");
		content.append("      		<div class=\"row\"><p style=\"font-weight: 400;\">6900 CORPORATION PARKWAY,</p></div>");
		content.append("      		<div class=\"row\"><p style=\"font-weight: 400;\">BATTLEBORO, NC 27809</p></div>");
		content.append("		</div>");
		content.append("    </div>");

		content.append("  </div>");
		content.append("</body>");
		content.append("</html>");


		return content.toString();
	}
}
