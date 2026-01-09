package com.lsbas.service;

import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.jaxws.EndpointImpl;
import org.apache.cxf.bus.spring.SpringBus;
import org.apache.cxf.ws.policy.AssertionBuilderRegistryImpl;
import org.apache.cxf.endpoint.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CxfConfig {

    @Bean
    public SpringBus cxf() {
        SpringBus springBus = new SpringBus();
        
        // SpringBus에 설정된 Extension을 처리하려면
        // 실제 Extension을 등록하는 부분을 따로 처리해야 할 수 있습니다.
        // 예를 들어, SpringBus의 `bus`를 사용하는 방법을 사용해야 할 수 있습니다.
        
        return springBus;
    }

    // AssertionBuilderRegistryImpl과 관련된 설정이 필요하면 별도로 Bean을 추가할 수 있습니다.
    @Bean
    public AssertionBuilderRegistryImpl assertionBuilderRegistry() {
        return new AssertionBuilderRegistryImpl();
    }
/*    @Bean
    public EndpointImpl SO_04Endpoint() {
        // EndpointImpl을 사용하여 게시
        EndpointImpl endpoint = new EndpointImpl(cxf(), new IF_EPRO_SO_04Impl());
        endpoint.publish("/services/IF_EPRO_SO_04");

        System.out.println("Published IF_EPRO_SO_04Service at /services/IF_EPRO_SO_04");

        return endpoint;  // EndpointImpl을 반환
    }
    @Bean
    public EndpointImpl SO_11Endpoint() {
        // EndpointImpl을 사용하여 게시
        EndpointImpl endpoint = new EndpointImpl(cxf(), new IF_EPRO_SO_11Impl());
        endpoint.publish("/services/IF_EPRO_SO_11");

        System.out.println("Published IF_EPRO_SO_11Service at /services/IF_EPRO_SO_11");

        return endpoint;  // EndpointImpl을 반환
    }*/
}