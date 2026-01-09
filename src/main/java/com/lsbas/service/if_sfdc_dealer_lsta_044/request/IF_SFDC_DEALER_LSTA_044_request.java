package com.lsbas.service.if_sfdc_dealer_lsta_044.request;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class IF_SFDC_DEALER_LSTA_044_request {
	private List<IF_SFDC_DEALER_LSTA_044_data> EVAL_LIST;   // 딜러 평가 정보
	
	public List<IF_SFDC_DEALER_LSTA_044_data> getEVAL_LIST() {
		return EVAL_LIST;
	}
	public void setEVAL_LIST(List<IF_SFDC_DEALER_LSTA_044_data> EVAL_LIST) {
		this.EVAL_LIST = EVAL_LIST;
	}
}