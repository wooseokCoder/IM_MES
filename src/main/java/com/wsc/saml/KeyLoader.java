package com.wsc.saml;

import org.apache.commons.io.IOUtils;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;


public class KeyLoader {
    public static PrivateKey loadPrivateKey(String path) throws Exception {
        InputStream is = KeyLoader.class.getClassLoader().getResourceAsStream(path);
        String key = IOUtils.toString(new InputStreamReader(is, StandardCharsets.UTF_8));
        key = key.replaceAll("-----\\w+ PRIVATE KEY-----", "").replaceAll("\\s", "");
        byte[] decoded = Base64.getDecoder().decode(key);
        return KeyFactory.getInstance("RSA").generatePrivate(new PKCS8EncodedKeySpec(decoded));
    }

    public static X509Certificate loadCertificate(String path) throws Exception {
        InputStream is = KeyLoader.class.getClassLoader().getResourceAsStream(path);
        return (X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(is);
    }
}

