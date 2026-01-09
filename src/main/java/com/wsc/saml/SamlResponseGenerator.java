package com.wsc.saml;

import org.joda.time.DateTime;
import org.opensaml.core.xml.io.Marshaller;
import org.opensaml.core.xml.io.MarshallerFactory;
import org.opensaml.core.xml.io.MarshallingException;
import org.opensaml.core.xml.schema.XSString;
import org.opensaml.core.xml.schema.impl.XSStringBuilder;
import org.opensaml.core.xml.config.XMLObjectProviderRegistrySupport;
import org.opensaml.core.xml.XMLObject;
import org.opensaml.core.xml.XMLObjectBuilderFactory;
import org.opensaml.saml.saml2.core.*;
import org.opensaml.saml.saml2.core.impl.*;
import org.opensaml.xml.Configuration;

import org.opensaml.xml.util.XMLHelper;
import org.opensaml.xmlsec.keyinfo.KeyInfoGenerator;
import org.opensaml.xmlsec.keyinfo.KeyInfoGeneratorFactory;
import org.opensaml.xmlsec.keyinfo.impl.X509KeyInfoGeneratorFactory;
import org.opensaml.xmlsec.signature.KeyInfo;
import org.opensaml.xmlsec.signature.Signature;
import org.opensaml.xmlsec.signature.support.Signer;
import org.opensaml.xmlsec.signature.support.SignatureConstants;
import org.opensaml.xmlsec.signature.impl.SignatureBuilder;
import org.opensaml.security.credential.BasicCredential;
import org.opensaml.security.credential.Credential;
import org.opensaml.security.x509.BasicX509Credential;
import org.w3c.dom.Element;

import java.security.PrivateKey;
import java.security.cert.X509Certificate;
import java.time.Instant;
import java.util.UUID;

public class SamlResponseGenerator {

    private final BasicCredential signingCredential;

    public SamlResponseGenerator(BasicCredential credential) {
        this.signingCredential = credential;
    }

    public String generate(String username, String audience, String acsUrl, String issuer, String privKey, String cert) throws Exception {
    	
        NameID nameID = new NameIDBuilder().buildObject();
        nameID.setFormat(NameIDType.UNSPECIFIED);
        nameID.setValue(username);

        SubjectConfirmationData confirmationData = new SubjectConfirmationDataBuilder().buildObject();
        confirmationData.setRecipient(acsUrl);
        confirmationData.setNotOnOrAfter(new DateTime().plusMinutes(5));

        SubjectConfirmation confirmation = new SubjectConfirmationBuilder().buildObject();
        confirmation.setMethod(SubjectConfirmation.METHOD_BEARER);
        confirmation.setSubjectConfirmationData(confirmationData);

        Subject subject = new SubjectBuilder().buildObject();
        subject.setNameID(nameID);
        subject.getSubjectConfirmations().add(confirmation);

        Audience audienceObj = new AudienceBuilder().buildObject();
        audienceObj.setAudienceURI(audience);

        AudienceRestriction audienceRestriction = new AudienceRestrictionBuilder().buildObject();
        audienceRestriction.getAudiences().add(audienceObj);

        Conditions conditions = new ConditionsBuilder().buildObject();
        conditions.setNotBefore(new DateTime().minusMinutes(1));
        conditions.setNotOnOrAfter(new DateTime().plusMinutes(5));
        conditions.getAudienceRestrictions().add(audienceRestriction);

        AuthnContextClassRef authnContextClassRef = new AuthnContextClassRefBuilder().buildObject();
        authnContextClassRef.setAuthnContextClassRef(AuthnContext.PASSWORD_AUTHN_CTX);

        AuthnContext authnContext = new AuthnContextBuilder().buildObject();
        authnContext.setAuthnContextClassRef(authnContextClassRef);

        AuthnStatement authnStatement = new AuthnStatementBuilder().buildObject();
        authnStatement.setAuthnInstant(new DateTime());
        authnStatement.setAuthnContext(authnContext);
        
        AttributeStatement attributeStatement = new AttributeStatementBuilder().buildObject();

        Attribute federationIdAttr = new AttributeBuilder().buildObject();
        federationIdAttr.setName("FederationID");
        federationIdAttr.setNameFormat(Attribute.URI_REFERENCE);
        
        XMLObjectBuilderFactory builderFactory = XMLObjectProviderRegistrySupport.getBuilderFactory();

        XSStringBuilder stringBuilder = (XSStringBuilder) builderFactory.getBuilder(XSString.TYPE_NAME);
        if (stringBuilder == null) {
            throw new RuntimeException("OpenSAML 초기화가 되지 않았거나 XSStringBuilder가 등록되지 않았습니다.");
        }

        XSString fedValue = stringBuilder.buildObject(AttributeValue.DEFAULT_ELEMENT_NAME, XSString.TYPE_NAME);
        fedValue.setValue(username);
        
        federationIdAttr.getAttributeValues().add(fedValue);
        attributeStatement.getAttributes().add(federationIdAttr);

        
        Assertion assertion = new AssertionBuilder().buildObject();
        assertion.setID("_" + UUID.randomUUID());
        assertion.setIssueInstant(new DateTime());
        assertion.setIssuer(buildIssuer(issuer));
        assertion.setSubject(subject);
        assertion.setConditions(conditions);
        assertion.getAuthnStatements().add(authnStatement);
        assertion.getAttributeStatements().add(attributeStatement);
        
        
        PrivateKey privateKey = (PrivateKey) KeyLoader.loadPrivateKey(privKey);
        X509Certificate certificate = (X509Certificate) KeyLoader.loadCertificate(cert);
        
        BasicX509Credential cred = new BasicX509Credential(certificate, privateKey);
        cred.setPrivateKey(privateKey);
        cred.setEntityCertificate(certificate);

        KeyInfoGeneratorFactory keyInfoGenFactory = new X509KeyInfoGeneratorFactory();
        ((X509KeyInfoGeneratorFactory) keyInfoGenFactory).setEmitEntityCertificate(true);

        KeyInfoGenerator keyInfoGenerator = keyInfoGenFactory.newInstance();
        KeyInfo keyInfo = keyInfoGenerator.generate((Credential) cred);
        
        
        Signature signature = new SignatureBuilder().buildObject();
        signature.setSigningCredential(cred);
        signature.setSignatureAlgorithm(SignatureConstants.ALGO_ID_SIGNATURE_RSA_SHA1);
        signature.setCanonicalizationAlgorithm(SignatureConstants.ALGO_ID_C14N_EXCL_OMIT_COMMENTS);
        signature.setKeyInfo(keyInfo);
        assertion.setSignature(signature);
        
        Marshaller marshaller = XMLObjectProviderRegistrySupport.getMarshallerFactory().getMarshaller(assertion);
        marshaller.marshall(assertion);

        Signer.signObject(signature);
        
        Response response = new ResponseBuilder().buildObject();
        response.setID("_" + UUID.randomUUID());
        response.setIssueInstant(new DateTime());
        response.setDestination(acsUrl);
        response.setIssuer(buildIssuer(issuer));
        response.setStatus(buildStatus(StatusCode.SUCCESS));
        response.getAssertions().add(assertion);

        Marshaller responseMarshaller = XMLObjectProviderRegistrySupport.getMarshallerFactory().getMarshaller(response);
        Element finalElement = responseMarshaller.marshall(response);

        String samlString = XMLHelper.nodeToString(finalElement);
        
        return samlString;
    }

    private Issuer buildIssuer(String issuerValue) {
        Issuer issuer = new IssuerBuilder().buildObject();
        issuer.setValue(issuerValue);
        return issuer;
    }

    private Status buildStatus(String code) {
        StatusCode statusCode = new StatusCodeBuilder().buildObject();
        statusCode.setValue(code);
        Status status = new StatusBuilder().buildObject();
        status.setStatusCode(statusCode);
        return status;
    }
}

