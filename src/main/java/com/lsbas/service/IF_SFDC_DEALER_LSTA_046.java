package com.lsbas.service;

import javax.jws.WebService;

import com.lsbas.service.if_sfdc_dealer_lsta_046.request.IF_SFDC_DEALER_LSTA_046_request;
import com.lsbas.service.if_sfdc_dealer_lsta_046.response.IF_SFDC_DEALER_LSTA_046_response;

@WebService
public interface IF_SFDC_DEALER_LSTA_046 {
	IF_SFDC_DEALER_LSTA_046_response getService(IF_SFDC_DEALER_LSTA_046_request request);
}