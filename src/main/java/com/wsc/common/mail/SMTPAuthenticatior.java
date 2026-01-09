package com.wsc.common.mail;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

import org.springframework.beans.factory.annotation.Value;

public class SMTPAuthenticatior extends Authenticator{
    private String smtp_id;
    private String smtp_pw;
    
	public SMTPAuthenticatior(String _id, String _pw){
		//super();
		smtp_id = _id;
		smtp_pw = _pw;
	}
 
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(smtp_id, smtp_pw);
    }
}
