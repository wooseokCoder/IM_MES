package com.lsbas.service.if_sfdc_dealer_lsta_044.request;

import lombok.Data;

import java.math.BigDecimal;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@Data
@XmlType(propOrder = { 
    "DEAL_ID", "DEAL_NAME", "EVAL_DATE", 
    "EVAL_STAF", "EVAL_SCOR", "EVAL_LINK" 
})

public class IF_SFDC_DEALER_LSTA_044_data {

    private String DEAL_ID;     // 딜러 임시ID
    private String DEAL_NAME;   // 딜러명
    private String EVAL_DATE;   // 평가일자
    private String EVAL_STAF;   // 평가자(SM Name)
    private String EVAL_SCOR; // 평가점수 (DECIMAL 10,0)
    private String EVAL_LINK;   // 평가서 링크URL

    @XmlElement(name = "DEAL_ID")
    public String getDEAL_ID() {
        return DEAL_ID;
    }
    public void setDEAL_ID(String DEAL_ID) {
        this.DEAL_ID = DEAL_ID;
    }

    @XmlElement(name = "DEAL_NAME")
    public String getDEAL_NAME() {
        return DEAL_NAME;
    }
    public void setDEAL_NAME(String DEAL_NAME) {
        this.DEAL_NAME = DEAL_NAME;
    }

    @XmlElement(name = "EVAL_DATE")
    public String getEVAL_DATE() {
        return EVAL_DATE;
    }
    public void setEVAL_DATE(String EVAL_DATE) {
        this.EVAL_DATE = EVAL_DATE;
    }

    @XmlElement(name = "EVAL_STAF")
    public String getEVAL_STAF() {
        return EVAL_STAF;
    }
    public void setEVAL_STAF(String EVAL_STAF) {
        this.EVAL_STAF = EVAL_STAF;
    }

    @XmlElement(name = "EVAL_SCOR")
    public String getEVAL_SCOR() {
        return EVAL_SCOR;
    }
    public void setEVAL_SCOR(String EVAL_SCOR) {
        this.EVAL_SCOR = EVAL_SCOR;
    }

    @XmlElement(name = "EVAL_LINK")
    public String getEVAL_LINK() {
        return EVAL_LINK;
    }
    public void setEVAL_LINK(String EVAL_LINK) {
        this.EVAL_LINK = EVAL_LINK;
    }
    
}