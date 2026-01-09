package com.lsbas.service.if_sfdc_dealer_lsta_040.request;

import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "IF_SFDC_DEALER_LSTA_040Request")
@XmlAccessorType(XmlAccessType.FIELD)
public class IF_SFDC_DEALER_LSTA_040_request {
    
    @XmlElement(name = "LWS_SR_DATA")
    private List<IF_SFDC_DEALER_LSTA_040_data> LWS_SR_DATA;
    
    public List<IF_SFDC_DEALER_LSTA_040_data> getLWS_SR_DATA() {
        return LWS_SR_DATA;
    }
    
    public void setLWS_SR_DATA(List<IF_SFDC_DEALER_LSTA_040_data> LWS_SR_DATA) {
        this.LWS_SR_DATA = LWS_SR_DATA;
    }
}