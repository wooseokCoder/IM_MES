package com.lsbas.service.if_sfdc_dealer_lsta_038.request;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class IF_SFDC_DEALER_LSTA_038_request {
	private List<IF_SFDC_DEALER_LSTA_038_data> MANUAL_LIST;   // 매뉴얼 Production Info 데이터
	
	public List<IF_SFDC_DEALER_LSTA_038_data> getMANUAL_LIST() {
		return MANUAL_LIST;
	}
	public void setMANUAL_LIST(List<IF_SFDC_DEALER_LSTA_038_data> MANUAL_LIST) {
		this.MANUAL_LIST = MANUAL_LIST;
	}
}