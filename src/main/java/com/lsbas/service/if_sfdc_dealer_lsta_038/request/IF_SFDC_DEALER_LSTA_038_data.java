package com.lsbas.service.if_sfdc_dealer_lsta_038.request;

import lombok.Data;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@Data
@XmlType(propOrder = {
	"NO", "TITLE", "DESCRIPTION", "AREA", "TYPE", 
	"LANGUAGE", "SERISE", "MODEL", "CREATED_BY", 
	"FILE_NO", "FILE_NAME", "FILE_SIZE", 
	"FILE_URL", "FILE_DOWNLOAD_URL"
})

public class IF_SFDC_DEALER_LSTA_038_data {

    private String NO;                 // 순번
    private String TITLE;              // TITLE
    private String DESCRIPTION;        // DESCRIPTION
    private String AREA;               // 영역
    private String TYPE;               // 타입
    private String LANGUAGE;           // 언어 코드
    private String SERISE;             // 시리즈
    private String MODEL;              // 모델 (적용모델, 콤마 구분자)
    private String CREATED_BY;         // 생성자
    private String FILE_NO;            // 파일 아이디
    private String FILE_NAME;          // 파일 명
    private String FILE_SIZE;          // 파일 사이즈
    private String FILE_URL;           // 파일 URL
    private String FILE_DOWNLOAD_URL;  // 파일 다운로드 URL

    @XmlElement(name = "NO")
    public String getNO() {
        return NO;
    }
    public void setNO(String NO) {
        this.NO = NO;
    }

    @XmlElement(name = "TITLE")
    public String getTITLE() {
        return TITLE;
    }
    public void setTITLE(String TITLE) {
        this.TITLE = TITLE;
    }

    @XmlElement(name = "DESCRIPTION")
    public String getDESCRIPTION() {
        return DESCRIPTION;
    }
    public void setDESCRIPTION(String DESCRIPTION) {
        this.DESCRIPTION = DESCRIPTION;
    }

    @XmlElement(name = "AREA")
    public String getAREA() {
        return AREA;
    }
    public void setAREA(String AREA) {
        this.AREA = AREA;
    }

    @XmlElement(name = "TYPE")
    public String getTYPE() {
        return TYPE;
    }
    public void setTYPE(String TYPE) {
        this.TYPE = TYPE;
    }

    @XmlElement(name = "LANGUAGE")
    public String getLANGUAGE() {
        return LANGUAGE;
    }
    public void setLANGUAGE(String LANGUAGE) {
        this.LANGUAGE = LANGUAGE;
    }

    @XmlElement(name = "SERISE")
    public String getSERISE() {
        return SERISE;
    }
    public void setSERISE(String SERISE) {
        this.SERISE = SERISE;
    }

    @XmlElement(name = "MODEL")
    public String getMODEL() {
        return MODEL;
    }
    public void setMODEL(String MODEL) {
        this.MODEL = MODEL;
    }

    @XmlElement(name = "CREATED_BY")
    public String getCREATED_BY() {
        return CREATED_BY;
    }
    public void setCREATED_BY(String CREATED_BY) {
        this.CREATED_BY = CREATED_BY;
    }

    @XmlElement(name = "FILE_NO")
    public String getFILE_NO() {
        return FILE_NO;
    }
    public void setFILE_NO(String FILE_NO) {
        this.FILE_NO = FILE_NO;
    }

    @XmlElement(name = "FILE_NAME")
    public String getFILE_NAME() {
        return FILE_NAME;
    }
    public void setFILE_NAME(String FILE_NAME) {
        this.FILE_NAME = FILE_NAME;
    }

    @XmlElement(name = "FILE_SIZE")
    public String getFILE_SIZE() {
        return FILE_SIZE;
    }
    public void setFILE_SIZE(String FILE_SIZE) {
        this.FILE_SIZE = FILE_SIZE;
    }

    @XmlElement(name = "FILE_URL")
    public String getFILE_URL() {
        return FILE_URL;
    }
    public void setFILE_URL(String FILE_URL) {
        this.FILE_URL = FILE_URL;
    }

    @XmlElement(name = "FILE_DOWNLOAD_URL")
    public String getFILE_DOWNLOAD_URL() {
        return FILE_DOWNLOAD_URL;
    }
    public void setFILE_DOWNLOAD_URL(String FILE_DOWNLOAD_URL) {
        this.FILE_DOWNLOAD_URL = FILE_DOWNLOAD_URL;
    }
    
}