package com.lsbas.service.if_sfdc_dealer_lsta_041.response;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "IF_SFDC_DEALER_LSTA_041Response")
@XmlAccessorType(XmlAccessType.FIELD)
public class IF_SFDC_DEALER_LSTA_041_response {
    
    @XmlElement(name = "O_RESULT")
    private String O_RESULT;
    
    @XmlElement(name = "O_MESSAGE")
    private String O_MESSAGE;
    
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