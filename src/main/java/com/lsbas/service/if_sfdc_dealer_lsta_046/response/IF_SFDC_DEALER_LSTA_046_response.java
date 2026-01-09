package com.lsbas.service.if_sfdc_dealer_lsta_046.response;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class IF_SFDC_DEALER_LSTA_046_response {
	private String O_RESULT;
	private String O_MESSAGE;
	
	   // Getter & Setter Methods
    public String getO_RESULT() {
        return O_RESULT;
    }

    public void setO_RESULT(String O_RESULT) {
        this.O_RESULT = O_RESULT;
    }

    public String getO_MESSAGE() {
        return O_MESSAGE;
    }

    public void setO_MESSAGE(String O_MESSAGE) {
        this.O_MESSAGE = O_MESSAGE;
    }

}