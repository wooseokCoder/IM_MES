package com.lsbas.service.if_sfdc_dealer_lsta_041.request;

import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "IF_SFDC_DEALER_LSTA_041Request")
@XmlAccessorType(XmlAccessType.FIELD)
public class IF_SFDC_DEALER_LSTA_041_request {
    
    @XmlElement(name = "LWS_WR_DATA")
    private List<IF_SFDC_DEALER_LSTA_041_data> LWS_WR_DATA;
    
    public List<IF_SFDC_DEALER_LSTA_041_data> getLWS_WR_DATA() {
        return LWS_WR_DATA;
    }
    
    public void setLWS_WR_DATA(List<IF_SFDC_DEALER_LSTA_041_data> LWS_WR_DATA) {
        this.LWS_WR_DATA = LWS_WR_DATA;
    }
}