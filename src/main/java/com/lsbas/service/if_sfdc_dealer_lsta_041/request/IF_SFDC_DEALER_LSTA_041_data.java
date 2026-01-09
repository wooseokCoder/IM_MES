package com.lsbas.service.if_sfdc_dealer_lsta_041.request;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(propOrder = {"REP_NO", "SERI_NO", "DEAL_CODE", "DEAL_NAME", "MODL_CODE", "CLA_TYPE", "CLAIM_TYPE_NM", 
        "WARR_KIND", "WARR_KIND_NM", "MODEL_SERIES", "SUBM_DATE", "INVC_NO", "INVC_DATE", "WAERS", 
        "PART_AMT", "LABO_AMT", "EXTR_AMT", "SUM_AMT"})
public class IF_SFDC_DEALER_LSTA_041_data {

    @XmlElement(name = "REP_NO")
    private String REP_NO;           // Claim No
    @XmlElement(name = "SERI_NO")
    private String SERI_NO;          // Serial No
    @XmlElement(name = "DEAL_CODE")
    private String DEAL_CODE;        // 딜러 코드 (Dealer Code)
    @XmlElement(name = "DEAL_NAME")
    private String DEAL_NAME;        // 딜러명 (Dealer Name)
    @XmlElement(name = "MODL_CODE")
    private String MODL_CODE;        // 모델 (Model)
    @XmlElement(name = "CLA_TYPE")
    private String CLA_TYPE;         // 청구 유형 (Claim Type)
    @XmlElement(name = "CLAIM_TYPE_NM")
    private String CLAIM_TYPE_NM;    // 청구 유형 이름 (Claim Type Name)
    @XmlElement(name = "WARR_KIND")
    private String WARR_KIND;        // WARR_KIND
    @XmlElement(name = "WARR_KIND_NM")
    private String WARR_KIND_NM;     // WARR_KIND_NM
    @XmlElement(name = "MODEL_SERIES")
    private String MODEL_SERIES;     // MODEL_SERIES
    @XmlElement(name = "SUBM_DATE")
    private String SUBM_DATE;        // 제출일 (Submission Date)
    @XmlElement(name = "INVC_NO")
    private String INVC_NO;          // 송장 번호 (Invoice Number)
    @XmlElement(name = "INVC_DATE")
    private String INVC_DATE;        // 송장 날짜 (Invoice Date)
    @XmlElement(name = "WAERS")
    private String WAERS;            // WAERS
    @XmlElement(name = "PART_AMT")
    private String PART_AMT;         // 부분 금액 (Part Amount)
    @XmlElement(name = "LABO_AMT")
    private String LABO_AMT;         // 인건비 (Labor Cost)
    @XmlElement(name = "EXTR_AMT")
    private String EXTR_AMT;         // 추가 금액 (Additional Amount)
    @XmlElement(name = "SUM_AMT")
    private String SUM_AMT;          // 합계 금액 (Total Amount)

    // Getter and Setter methods
    public String getREP_NO() { return REP_NO; }
    public void setREP_NO(String REP_NO) { this.REP_NO = REP_NO; }

    public String getSERI_NO() { return SERI_NO; }
    public void setSERI_NO(String SERI_NO) { this.SERI_NO = SERI_NO; }

    public String getDEAL_CODE() { return DEAL_CODE; }
    public void setDEAL_CODE(String DEAL_CODE) { this.DEAL_CODE = DEAL_CODE; }

    public String getDEAL_NAME() { return DEAL_NAME; }
    public void setDEAL_NAME(String DEAL_NAME) { this.DEAL_NAME = DEAL_NAME; }

    public String getMODL_CODE() { return MODL_CODE; }
    public void setMODL_CODE(String MODL_CODE) { this.MODL_CODE = MODL_CODE; }

    public String getCLA_TYPE() { return CLA_TYPE; }
    public void setCLA_TYPE(String CLA_TYPE) { this.CLA_TYPE = CLA_TYPE; }

    public String getCLAIM_TYPE_NM() { return CLAIM_TYPE_NM; }
    public void setCLAIM_TYPE_NM(String CLAIM_TYPE_NM) { this.CLAIM_TYPE_NM = CLAIM_TYPE_NM; }

    public String getWARR_KIND() { return WARR_KIND; }
    public void setWARR_KIND(String WARR_KIND) { this.WARR_KIND = WARR_KIND; }

    public String getWARR_KIND_NM() { return WARR_KIND_NM; }
    public void setWARR_KIND_NM(String WARR_KIND_NM) { this.WARR_KIND_NM = WARR_KIND_NM; }

    public String getMODEL_SERIES() { return MODEL_SERIES; }
    public void setMODEL_SERIES(String MODEL_SERIES) { this.MODEL_SERIES = MODEL_SERIES; }

    public String getSUBM_DATE() { return SUBM_DATE; }
    public void setSUBM_DATE(String SUBM_DATE) { this.SUBM_DATE = SUBM_DATE; }

    public String getINVC_NO() { return INVC_NO; }
    public void setINVC_NO(String INVC_NO) { this.INVC_NO = INVC_NO; }

    public String getINVC_DATE() { return INVC_DATE; }
    public void setINVC_DATE(String INVC_DATE) { this.INVC_DATE = INVC_DATE; }

    public String getWAERS() { return WAERS; }
    public void setWAERS(String WAERS) { this.WAERS = WAERS; }

    public String getPART_AMT() { return PART_AMT; }
    public void setPART_AMT(String PART_AMT) { this.PART_AMT = PART_AMT; }

    public String getLABO_AMT() { return LABO_AMT; }
    public void setLABO_AMT(String LABO_AMT) { this.LABO_AMT = LABO_AMT; }

    public String getEXTR_AMT() { return EXTR_AMT; }
    public void setEXTR_AMT(String EXTR_AMT) { this.EXTR_AMT = EXTR_AMT; }

    public String getSUM_AMT() { return SUM_AMT; }
    public void setSUM_AMT(String SUM_AMT) { this.SUM_AMT = SUM_AMT; }
}