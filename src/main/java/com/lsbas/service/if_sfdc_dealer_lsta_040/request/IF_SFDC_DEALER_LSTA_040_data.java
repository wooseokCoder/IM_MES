package com.lsbas.service.if_sfdc_dealer_lsta_040.request;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(propOrder = {"SR_DIST", "SR_CNTY", "SR_STAT", "DEAL_CODE", "DEAL_NAME","STOR_LOC", "BM_CODE", "BM_NAME"
		,"SM_NAME", "COMI_RECV", "COMI_RECV_DETL","COMI_RECV_CODE", "SERI_NO", "ENGN_NO","UNIT_TYPE", "MODL_CODE"
		,"MODL_SERS","SERI_DESC", "INVO_NO", "INVO_DATE","SHIP_DATE", "PROD_DATE", "RETL_DATE", "USER_TYPE"
		,"FIST_NAME","LAST_NAME","USER_MAIL","USER_TEL","USER_HP","CNTY_FIST","STAT_FIST","CONT_FIST","PHYS_ADDR"
		,"PHYS_STAT","PHYS_CITY","PHYS_ZIP","MAIL_ADDR","MAIL_STAT","MAIL_CITY","MAIL_ZIP","WORK_APPL","CROPS"
		,"PLAN_USAG","LOAD_CODE","LOAD_MODL","LOAD_DATE","BHOE_CODE","BHOE_MODL","BHOE_DATE","MOWR_CODE","MOWR_MODL"
		,"MOWR_DATE","SNOW_CODE","SNOW_MODL","SNOW_DATE","ETC_CODE","ETC_MODL","ETC_DATE","EXPI_DATE_BT"
		,"EXPI_DATE_BZ","EXPI_DATE_EM","UNIT_COMT","COMI_AMOT","COMI_TYPE","COMI_DATE","UPEQ_NO","FINC_REBT"
		,"CASH_FORM","EVET_COPN"
		})
public class IF_SFDC_DEALER_LSTA_040_data {

	@XmlElement(name = "SR_DIST")
	private String SR_DIST;      // Distributor
	
	@XmlElement(name = "SR_CNTY")
	private String SR_CNTY;      // Country
	
	@XmlElement(name = "SR_STAT")
	private String SR_STAT;      // State
	
	@XmlElement(name = "DEAL_CODE")
	private String DEAL_CODE;    // Dealer Code
	
	@XmlElement(name = "DEAL_NAME")
	private String DEAL_NAME;    // Dealer Name
	
	@XmlElement(name = "STOR_LOC")
	private String STOR_LOC;     // Store Location
	
	@XmlElement(name = "BM_CODE")
	private String BM_CODE;      // BM
	
	@XmlElement(name = "BM_NAME")
	private String BM_NAME;      // BM Name
	
	@XmlElement(name = "SM_NAME")
	private String SM_NAME;      // SM Name
	
	@XmlElement(name = "COMI_RECV")
	private String COMI_RECV;    // Commission Receiver
	
	@XmlElement(name = "COMI_RECV_DETL")
	private String COMI_RECV_DETL; // Commission Receiver (Detail)
	
	@XmlElement(name = "COMI_RECV_CODE")
	private String COMI_RECV_CODE; // Commission Receiver Code
	
	@XmlElement(name = "SERI_NO")
	private String SERI_NO;        // Serial number
	
	@XmlElement(name = "ENGN_NO")
	private String ENGN_NO;        // Engine SN
	
	@XmlElement(name = "UNIT_TYPE")
	private String UNIT_TYPE;      // Unit Type
	
	@XmlElement(name = "MODL_CODE")
	private String MODL_CODE;      // Model
	
	@XmlElement(name = "MODL_SERS")
	private String MODL_SERS;      // Series
	
	@XmlElement(name = "SERI_DESC")
	private String SERI_DESC;      // Material Description
	
	@XmlElement(name = "INVO_NO")
	private String INVO_NO;      // Invoice #
	
	@XmlElement(name = "INVO_DATE")
	private String INVO_DATE;      // Invoice Date
	
	@XmlElement(name = "SHIP_DATE")
	private String SHIP_DATE;      // Registered Date
	
	@XmlElement(name = "PROD_DATE")
	private String PROD_DATE;      // Production Date
	
	@XmlElement(name = "RETL_DATE")
	private String RETL_DATE;      // Retail Date
	
	@XmlElement(name = "USER_TYPE")
	private String USER_TYPE;      // User Type
	
	@XmlElement(name = "FIST_NAME")
	private String FIST_NAME;      // First name
	
	@XmlElement(name = "LAST_NAME")
	private String LAST_NAME;      // Last name
	
	@XmlElement(name = "USER_MAIL")
	private String USER_MAIL;      // E-mail
	
	@XmlElement(name = "USER_TEL")
	private String USER_TEL;       // Telephone
	
	@XmlElement(name = "USER_HP")
	private String USER_HP;        // Mobile
	
	@XmlElement(name = "CNTY_FIST")
	private String CNTY_FIST;      // Country of First Use
	
	@XmlElement(name = "STAT_FIST")
	private String STAT_FIST;      // State of First Use
	
	@XmlElement(name = "CONT_FIST")
	private String CONT_FIST;      // County of First Use
	
	@XmlElement(name = "PHYS_ADDR")
	private String PHYS_ADDR;      // Physical address
	
	@XmlElement(name = "PHYS_STAT")
	private String PHYS_STAT;      // Physical State
	
	@XmlElement(name = "PHYS_CITY")
	private String PHYS_CITY;      // Physical City
	
	@XmlElement(name = "PHYS_ZIP")
	private String PHYS_ZIP;      // Physical ZIP
	
	@XmlElement(name = "MAIL_ADDR")
	private String MAIL_ADDR;      // Mailing Address
	
	@XmlElement(name = "MAIL_STAT")
	private String MAIL_STAT;      // Mailing State
	
	@XmlElement(name = "MAIL_CITY")
	private String MAIL_CITY;      // Mailing City
	
	@XmlElement(name = "MAIL_ZIP")
	private String MAIL_ZIP;       // Mailing ZIP
	
	@XmlElement(name = "WORK_APPL")
	private String WORK_APPL;      // Work application
	
	@XmlElement(name = "CROPS")
	private String CROPS;          // Crops
	
	@XmlElement(name = "PLAN_USAG")
	private String PLAN_USAG;      // Plan usage
	
	@XmlElement(name = "LOAD_CODE")
	private String LOAD_CODE;      // Loader
	
	@XmlElement(name = "LOAD_MODL")
	private String LOAD_MODL;      // Loader Model
	
	@XmlElement(name = "LOAD_DATE")
	private String LOAD_DATE;      // Loader Retail Date
	
	@XmlElement(name = "BHOE_CODE")
	private String BHOE_CODE;      // Backhoe
	
	@XmlElement(name = "BHOE_MODL")
	private String BHOE_MODL;      // Backhoe Model
	
	@XmlElement(name = "BHOE_DATE")
	private String BHOE_DATE;      // Backhoe Retail Date
	
	@XmlElement(name = "MOWR_CODE")
	private String MOWR_CODE;      // Mid-Mount Mower
	
	@XmlElement(name = "MOWR_MODL")
	private String MOWR_MODL;      // Mid-Mount Mower Model
	
	@XmlElement(name = "MOWR_DATE")
	private String MOWR_DATE;      // Mid-Mount Mower Retail Date
	
	@XmlElement(name = "SNOW_CODE")
	private String SNOW_CODE;      // Snow blower
	
	@XmlElement(name = "SNOW_MODL")
	private String SNOW_MODL;      // Snow blower Model
	
	@XmlElement(name = "SNOW_DATE")
	private String SNOW_DATE;      // Snow blower Retail Date
	
	@XmlElement(name = "ETC_CODE")
	private String ETC_CODE;       // Etc
	
	@XmlElement(name = "ETC_MODL")
	private String ETC_MODL;       // Etc Model
	
	@XmlElement(name = "ETC_DATE")
	private String ETC_DATE;       // Etc Retail Date
	
	@XmlElement(name = "EXPI_DATE_BT")
	private String EXPI_DATE_BT;   // Expire Date (Powertrain)
	
	@XmlElement(name = "EXPI_DATE_BZ")
	private String EXPI_DATE_BZ;   // Expire Date (Bumper to bumper)
	
	@XmlElement(name = "EXPI_DATE_EM")
	private String EXPI_DATE_EM;   // Expire Date (Emission)
	
	@XmlElement(name = "UNIT_COMT")
	private String UNIT_COMT;      // Unit comment
	
	@XmlElement(name = "COMI_AMOT")
	private String COMI_AMOT;      // Commission Amount (USD)
	
	@XmlElement(name = "COMI_TYPE")
	private String COMI_TYPE;      // Commission Paid type
	
	@XmlElement(name = "COMI_DATE")
	private String COMI_DATE;      // Commission Paid date
	
	@XmlElement(name = "UPEQ_NO")
	private String UPEQ_NO;        // upequNR
	
	@XmlElement(name = "FINC_REBT")
	private String FINC_REBT;      // Financing/Cash Rebate
	
	@XmlElement(name = "CASH_FORM")
	private String CASH_FORM;      // Cash In Lieu Form
	
	@XmlElement(name = "EVET_COPN")
	private String EVET_COPN;      // Event

	public String getSR_DIST() { return SR_DIST; }
	public void setSR_DIST(String SR_DIST) { this.SR_DIST = SR_DIST; }
	
	public String getSR_CNTY() { return SR_CNTY; }
	public void setSR_CNTY(String SR_CNTY) { this.SR_CNTY = SR_CNTY; }
	
	public String getSR_STAT() { return SR_STAT; }
	public void setSR_STAT(String SR_STAT) { this.SR_STAT = SR_STAT; }
	
	public String getDEAL_CODE() { return DEAL_CODE; }
	public void setDEAL_CODE(String DEAL_CODE) { this.DEAL_CODE = DEAL_CODE; }
	
	public String getDEAL_NAME() { return DEAL_NAME; }
	public void setDEAL_NAME(String DEAL_NAME) { this.DEAL_NAME = DEAL_NAME; }
	
	public String getSTOR_LOC() { return STOR_LOC; }
	public void setSTOR_LOC(String STOR_LOC) { this.STOR_LOC = STOR_LOC; }
	
	public String getBM_CODE() { return BM_CODE; }
	public void setBM_CODE(String BM_CODE) { this.BM_CODE = BM_CODE; }
	
	public String getBM_NAME() { return BM_NAME; }
	public void setBM_NAME(String BM_NAME) { this.BM_NAME = BM_NAME; }
	
	public String getSM_NAME() { return SM_NAME; }
	public void setSM_NAME(String SM_NAME) { this.SM_NAME = SM_NAME; }
	
	public String getCOMI_RECV() { return COMI_RECV; }
	public void setCOMI_RECV(String COMI_RECV) { this.COMI_RECV = COMI_RECV; }
	
	public String getCOMI_RECV_DETL() { return COMI_RECV_DETL; }
	public void setCOMI_RECV_DETL(String COMI_RECV_DETL) { this.COMI_RECV_DETL = COMI_RECV_DETL; }
	
	public String getCOMI_RECV_CODE() { return COMI_RECV_CODE; }
	public void setCOMI_RECV_CODE(String COMI_RECV_CODE) { this.COMI_RECV_CODE = COMI_RECV_CODE; }
	
	public String getSERI_NO() { return SERI_NO; }
	public void setSERI_NO(String SERI_NO) { this.SERI_NO = SERI_NO; }
	
	public String getENGN_NO() { return ENGN_NO; }
	public void setENGN_NO(String ENGN_NO) { this.ENGN_NO = ENGN_NO; }
	
	public String getUNIT_TYPE() { return UNIT_TYPE; }
	public void setUNIT_TYPE(String UNIT_TYPE) { this.UNIT_TYPE = UNIT_TYPE; }
	
	public String getMODL_CODE() { return MODL_CODE; }
	public void setMODL_CODE(String MODL_CODE) { this.MODL_CODE = MODL_CODE; }
	
	public String getMODL_SERS() { return MODL_SERS; }
	public void setMODL_SERS(String MODL_SERS) { this.MODL_SERS = MODL_SERS; }
	
	public String getSERI_DESC() { return SERI_DESC; }
	public void setSERI_DESC(String SERI_DESC) { this.SERI_DESC = SERI_DESC; }
	
	public String getINVO_NO() { return INVO_NO; }
	public void setINVO_NO(String INVO_NO) { this.INVO_NO = INVO_NO; }
	public String getINVO_DATE() { return INVO_DATE; }
	public void setINVO_DATE(String INVO_DATE) { this.INVO_DATE = INVO_DATE; }
	
	public String getSHIP_DATE() { return SHIP_DATE; }
	public void setSHIP_DATE(String SHIP_DATE) { this.SHIP_DATE = SHIP_DATE; }
	
	public String getPROD_DATE() { return PROD_DATE; }
	public void setPROD_DATE(String PROD_DATE) { this.PROD_DATE = PROD_DATE; }
	public String getRETL_DATE() { return RETL_DATE; }
	public void setRETL_DATE(String RETL_DATE) { this.RETL_DATE = RETL_DATE; }
	
	public String getUSER_TYPE() { return USER_TYPE; }
	public void setUSER_TYPE(String USER_TYPE) { this.USER_TYPE = USER_TYPE; }
	
	public String getFIST_NAME() { return FIST_NAME; }
	public void setFIST_NAME(String FIST_NAME) { this.FIST_NAME = FIST_NAME; }
	
	public String getLAST_NAME() { return LAST_NAME; }
	public void setLAST_NAME(String LAST_NAME) { this.LAST_NAME = LAST_NAME; }
	
	public String getUSER_MAIL() { return USER_MAIL; }
	public void setUSER_MAIL(String USER_MAIL) { this.USER_MAIL = USER_MAIL; }
	
	public String getUSER_TEL() { return USER_TEL; }
	public void setUSER_TEL(String USER_TEL) { this.USER_TEL = USER_TEL; }
	
	public String getUSER_HP() { return USER_HP; }
	public void setUSER_HP(String USER_HP) { this.USER_HP = USER_HP; }
	
	public String getCNTY_FIST() { return CNTY_FIST; }
	public void setCNTY_FIST(String CNTY_FIST) { this.CNTY_FIST = CNTY_FIST; }
	
	public String getSTAT_FIST() { return STAT_FIST; }
	public void setSTAT_FIST(String STAT_FIST) { this.STAT_FIST = STAT_FIST; }
	
	public String getCONT_FIST() { return CONT_FIST; }
	public void setCONT_FIST(String CONT_FIST) { this.CONT_FIST = CONT_FIST; }
	
	public String getPHYS_ADDR() { return PHYS_ADDR; }
	public void setPHYS_ADDR(String PHYS_ADDR) { this.PHYS_ADDR = PHYS_ADDR; }
	
	public String getPHYS_STAT() { return PHYS_STAT; }
	public void setPHYS_STAT(String PHYS_STAT) { this.PHYS_STAT = PHYS_STAT; }
	
	public String getPHYS_CITY() { return PHYS_CITY; }
	public void setPHYS_CITY(String PHYS_CITY) { this.PHYS_CITY = PHYS_CITY; }
	
	public String getPHYS_ZIP() { return PHYS_ZIP; }
	public void setPHYS_ZIP(String PHYS_ZIP) { this.PHYS_ZIP = PHYS_ZIP; }
	
	public String getMAIL_ADDR() { return MAIL_ADDR; }
	public void setMAIL_ADDR(String MAIL_ADDR) { this.MAIL_ADDR = MAIL_ADDR; }
	
	public String getMAIL_STAT() { return MAIL_STAT; }
	public void setMAIL_STAT(String MAIL_STAT) { this.MAIL_STAT = MAIL_STAT; }
	
	public String getMAIL_CITY() { return MAIL_CITY; }
	public void setMAIL_CITY(String MAIL_CITY) { this.MAIL_CITY = MAIL_CITY; }
	
	public String getMAIL_ZIP() { return MAIL_ZIP; }
	public void setMAIL_ZIP(String MAIL_ZIP) { this.MAIL_ZIP = MAIL_ZIP; }
	
	public String getWORK_APPL() { return WORK_APPL; }
	public void setWORK_APPL(String WORK_APPL) { this.WORK_APPL = WORK_APPL; }
	
	public String getCROPS() { return CROPS; }
	public void setCROPS(String CROPS) { this.CROPS = CROPS; }
	
	public String getPLAN_USAG() { return PLAN_USAG; }
	public void setPLAN_USAG(String PLAN_USAG) { this.PLAN_USAG = PLAN_USAG; }
	
	public String getLOAD_CODE() { return LOAD_CODE; }
	public void setLOAD_CODE(String LOAD_CODE) { this.LOAD_CODE = LOAD_CODE; }
	
	public String getLOAD_MODL() { return LOAD_MODL; }
	public void setLOAD_MODL(String LOAD_MODL) { this.LOAD_MODL = LOAD_MODL; }
	
	public String getLOAD_DATE() { return LOAD_DATE; }
	public void setLOAD_DATE(String LOAD_DATE) { this.LOAD_DATE = LOAD_DATE; }
	
	public String getBHOE_CODE() { return BHOE_CODE; }
	public void setBHOE_CODE(String BHOE_CODE) { this.BHOE_CODE = BHOE_CODE; }
	
	public String getBHOE_MODL() { return BHOE_MODL; }
	public void setBHOE_MODL(String BHOE_MODL) { this.BHOE_MODL = BHOE_MODL; }
	
	public String getBHOE_DATE() { return BHOE_DATE; }
	public void setBHOE_DATE(String BHOE_DATE) { this.BHOE_DATE = BHOE_DATE; }
	
	public String getMOWR_CODE() { return MOWR_CODE; }
	public void setMOWR_CODE(String MOWR_CODE) { this.MOWR_CODE = MOWR_CODE; }
	
	public String getMOWR_MODL() { return MOWR_MODL; }
	public void setMOWR_MODL(String MOWR_MODL) { this.MOWR_MODL = MOWR_MODL; }
	
	public String getMOWR_DATE() { return MOWR_DATE; }
	public void setMOWR_DATE(String MOWR_DATE) { this.MOWR_DATE = MOWR_DATE; }
	
	public String getSNOW_CODE() { return SNOW_CODE; }
	public void setSNOW_CODE(String SNOW_CODE) { this.SNOW_CODE = SNOW_CODE; }
	
	public String getSNOW_MODL() { return SNOW_MODL; }
	public void setSNOW_MODL(String SNOW_MODL) { this.SNOW_MODL = SNOW_MODL; }
	
	public String getSNOW_DATE() { return SNOW_DATE; }
	public void setSNOW_DATE(String SNOW_DATE) { this.SNOW_DATE = SNOW_DATE; }
	
	public String getETC_CODE() { return ETC_CODE; }
	public void setETC_CODE(String ETC_CODE) { this.ETC_CODE = ETC_CODE; }
	
	public String getETC_MODL() { return ETC_MODL; }
	public void setETC_MODL(String ETC_MODL) { this.ETC_MODL = ETC_MODL; }
	
	public String getETC_DATE() { return ETC_DATE; }
	public void setETC_DATE(String ETC_DATE) { this.ETC_DATE = ETC_DATE; }
	
	public String getEXPI_DATE_BT() { return EXPI_DATE_BT; }
	public void setEXPI_DATE_BT(String EXPI_DATE_BT) { this.EXPI_DATE_BT = EXPI_DATE_BT; }
	
	public String getEXPI_DATE_BZ() { return EXPI_DATE_BZ; }
	public void setEXPI_DATE_BZ(String EXPI_DATE_BZ) { this.EXPI_DATE_BZ = EXPI_DATE_BZ; }
	
	public String getEXPI_DATE_EM() { return EXPI_DATE_EM; }
	public void setEXPI_DATE_EM(String EXPI_DATE_EM) { this.EXPI_DATE_EM = EXPI_DATE_EM; }
	
	public String getUNIT_COMT() { return UNIT_COMT; }
	public void setUNIT_COMT(String UNIT_COMT) { this.UNIT_COMT = UNIT_COMT; }
	
	public String getCOMI_AMOT() { return COMI_AMOT; }
	public void setCOMI_AMOT(String COMI_AMOT) { this.COMI_AMOT = COMI_AMOT; }
	
	public String getCOMI_TYPE() { return COMI_TYPE; }
	public void setCOMI_TYPE(String COMI_TYPE) { this.COMI_TYPE = COMI_TYPE; }
	
	public String getCOMI_DATE() { return COMI_DATE; }
	public void setCOMI_DATE(String COMI_DATE) { this.COMI_DATE = COMI_DATE; }
	
	public String getUPEQ_NO() { return UPEQ_NO; }
	public void setUPEQ_NO(String UPEQ_NO) { this.UPEQ_NO = UPEQ_NO; }
	
	public String getFINC_REBT() { return FINC_REBT; }
	public void setFINC_REBT(String FINC_REBT) { this.FINC_REBT = FINC_REBT; }
	
	public String getCASH_FORM() { return CASH_FORM; }
	public void setCASH_FORM(String CASH_FORM) { this.CASH_FORM = CASH_FORM; }
	
	public String getEVET_COPN() { return EVET_COPN; }
	public void setEVET_COPN(String EVET_COPN) { this.EVET_COPN = EVET_COPN; }
}