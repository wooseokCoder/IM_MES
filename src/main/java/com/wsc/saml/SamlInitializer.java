package com.wsc.saml;

import org.apache.xml.security.Init;
import org.opensaml.core.config.InitializationService;

public class SamlInitializer {
	public static void initialize() throws Exception {
        try {
        	Init.init();

            InitializationService.initialize();
        } catch (Exception e) {
            throw new RuntimeException("OpenSAML 초기화 실패", e);
        }
    }
}

