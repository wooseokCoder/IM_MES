package com.lsbas.service.if_sfdc_dealer_lsta_046.request;

import lombok.Data;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@Data
@XmlType(propOrder = { "ID", "TITLE", "BODY", "LINK_URL", "USER" })

public class IF_SFDC_DEALER_LSTA_046_data {

    private String ID;        // 아이디
    private String TITLE;     // 제목
    private String BODY;      // 내용
    private String LINK_URL;  // URL
    private String USER;      // 사용자 SSO ID

    @XmlElement(name = "ID")
    public String getID() {
        return ID;
    }
    public void setID(String ID) {
        this.ID = ID;
    }

    @XmlElement(name = "TITLE")
    public String getTITLE() {
        return TITLE;
    }
    public void setTITLE(String TITLE) {
        this.TITLE = TITLE;
    }

    @XmlElement(name = "BODY")
    public String getBODY() {
        return BODY;
    }
    public void setBODY(String BODY) {
        this.BODY = BODY;
    }

    @XmlElement(name = "LINK_URL")
    public String getLINK_URL() {
        return LINK_URL;
    }
    public void setLINK_URL(String LINK_URL) {
        this.LINK_URL = LINK_URL;
    }

    @XmlElement(name = "USER")
    public String getUSER() {
        return USER;
    }
    public void setUSER(String USER) {
        this.USER = USER;
    }
    
}