package com.lsbas.service.if_sfdc_dealer_lsta_046.request;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class IF_SFDC_DEALER_LSTA_046_request {
	private List<IF_SFDC_DEALER_LSTA_046_data> ALERT_LIST;   // 알림 정보 리스트
	
	public List<IF_SFDC_DEALER_LSTA_046_data> getALERT_LIST() {
		return ALERT_LIST;
	}
	public void setALERT_LIST(List<IF_SFDC_DEALER_LSTA_046_data> ALERT_LIST) {
		this.ALERT_LIST = ALERT_LIST;
	}
}