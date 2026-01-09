package com.lsbas.service;

import javax.jws.WebService;

import com.lsbas.service.if_sfdc_dealer_lsta_041.request.IF_SFDC_DEALER_LSTA_041_request;
import com.lsbas.service.if_sfdc_dealer_lsta_041.response.IF_SFDC_DEALER_LSTA_041_response;

@WebService
public interface IF_SFDC_DEALER_LSTA_041 {
    IF_SFDC_DEALER_LSTA_041_response getService(IF_SFDC_DEALER_LSTA_041_request request);
}