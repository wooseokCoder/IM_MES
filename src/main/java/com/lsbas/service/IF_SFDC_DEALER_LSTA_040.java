package com.lsbas.service;

import javax.jws.WebService;

import com.lsbas.service.if_sfdc_dealer_lsta_040.request.IF_SFDC_DEALER_LSTA_040_request;
import com.lsbas.service.if_sfdc_dealer_lsta_040.response.IF_SFDC_DEALER_LSTA_040_response;

@WebService
public interface IF_SFDC_DEALER_LSTA_040 {
	IF_SFDC_DEALER_LSTA_040_response getService(IF_SFDC_DEALER_LSTA_040_request request);
}