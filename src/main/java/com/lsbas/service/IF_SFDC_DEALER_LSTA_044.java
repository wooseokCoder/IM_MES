package com.lsbas.service;

import javax.jws.WebService;

import com.lsbas.service.if_sfdc_dealer_lsta_044.request.IF_SFDC_DEALER_LSTA_044_request;
import com.lsbas.service.if_sfdc_dealer_lsta_044.response.IF_SFDC_DEALER_LSTA_044_response;

@WebService
public interface IF_SFDC_DEALER_LSTA_044 {
	IF_SFDC_DEALER_LSTA_044_response getService(IF_SFDC_DEALER_LSTA_044_request request);
}