package com.lsbas.service;

import javax.jws.WebService;

import com.lsbas.service.if_sfdc_dealer_lsta_038.request.IF_SFDC_DEALER_LSTA_038_request;
import com.lsbas.service.if_sfdc_dealer_lsta_038.response.IF_SFDC_DEALER_LSTA_038_response;

@WebService
public interface IF_SFDC_DEALER_LSTA_038 {
	IF_SFDC_DEALER_LSTA_038_response getService(IF_SFDC_DEALER_LSTA_038_request request);
}