# SUMMARY_DEPENDENCIES.md - IM_MES 의존성 목록

> 작성자: 송우석
> 빌드 방식: Eclipse JDT (Maven/Gradle 미사용), JAR 수동 관리
> JAR 경로: `src/main/webapp/WEB-INF/lib/`

---

## 1. 핵심 프레임워크

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| spring-core                         | 3.2.8.RELEASE  | Spring 핵심 IoC/DI 컨테이너             |
| spring-beans                        | 3.2.8.RELEASE  | Bean 정의 및 생성                       |
| spring-context                      | 3.2.8.RELEASE  | ApplicationContext, 이벤트, i18n        |
| spring-context-support              | 3.2.8.RELEASE  | 캐시, 메일, 스케줄링 등 통합 지원       |
| spring-expression                   | 3.2.8.RELEASE  | SpEL (Spring Expression Language)       |
| spring-web                          | 3.2.8.RELEASE  | 웹 기본 지원, Servlet 통합              |
| spring-webmvc                       | 3.2.8.RELEASE  | Spring MVC (DispatcherServlet, Controller) |
| spring-aop                          | 3.2.8.RELEASE  | AOP (관점 지향 프로그래밍)              |
| spring-jdbc                         | 3.2.8.RELEASE  | JDBC 추상화, DataSource 관리            |
| spring-orm                          | 3.2.8.RELEASE  | ORM 통합 (MyBatis 연동)                |
| spring-tx                           | 3.2.8.RELEASE  | 트랜잭션 관리 (@Transactional)          |

---

## 2. 데이터베이스 및 ORM

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| mybatis                             | 3.2.3          | SQL 매퍼 프레임워크                     |
| mybatis-spring                      | 1.2.1          | MyBatis-Spring 통합                     |
| mysql-connector-java                | 8.0.30         | MySQL JDBC 드라이버                     |
| mysql-connector-j                   | 9.1.0          | MySQL JDBC 드라이버 (신규 버전)         |
| ojdbc14                             | 10.2.0.4.0     | Oracle JDBC 드라이버                    |
| commons-dbcp                        | 1.4            | 데이터베이스 커넥션 풀                  |
| commons-pool                        | 1.5.4          | 오브젝트 풀링 (DBCP 의존)              |

---

## 3. 로깅

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| log4j                               | 1.2.15         | Log4j 1.x (레거시)                     |
| log4j-api                           | 2.17.1         | Log4j 2.x API                          |
| log4j-core                          | 2.17.1         | Log4j 2.x 코어 구현                    |
| log4j-1.2-api                       | 2.17.1         | Log4j 1.x → 2.x 브릿지                |
| log4j-slf4j-impl                    | 2.17.1         | SLF4J → Log4j 2.x 바인딩              |
| slf4j-api                           | 1.6.6          | SLF4J 로깅 파사드                       |
| slf4j-log4j12                       | 1.6.6          | SLF4J → Log4j 1.x 바인딩 (레거시)     |
| jcl-over-slf4j                      | 1.6.6          | Commons Logging → SLF4J 리다이렉트     |
| commons-logging                     | 1.1.3          | Apache Commons Logging                  |
| log4jdbc-log4j2-jdbc4.1             | 1.16           | SQL 로깅 (Log4j2 기반)                 |
| log4jdbc-remix                      | 0.2.7          | SQL 로깅 (레거시)                       |
| log4jdbc4                           | 1.2            | SQL 로깅                                |

---

## 4. 웹서비스 (SOAP / CXF)

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| cxf-core                            | 3.0.3          | Apache CXF 핵심 런타임                  |
| cxf-rt-frontend-jaxws               | 3.0.3          | JAX-WS 프론트엔드                       |
| cxf-rt-frontend-simple              | 3.0.3          | Simple 프론트엔드                       |
| cxf-rt-transports-http              | 3.0.3          | HTTP 트랜스포트                         |
| cxf-rt-bindings-soap                | 3.0.3          | SOAP 바인딩                             |
| cxf-rt-bindings-xml                 | 3.0.3          | XML 바인딩                              |
| cxf-rt-databinding-jaxb             | 3.0.3          | JAXB 데이터 바인딩                      |
| cxf-rt-databinding-aegis            | 3.0.3          | Aegis 데이터 바인딩                     |
| cxf-rt-javascript                   | 3.0.3          | JavaScript 클라이언트 생성              |
| cxf-rt-wsdl                         | 3.0.3          | WSDL 처리                               |
| cxf-rt-ws-addr                      | 3.0.3          | WS-Addressing                           |
| cxf-rt-ws-policy                    | 3.0.3          | WS-Policy                               |
| cxf-tools-common                    | 3.0.3          | CXF 도구 공통                           |
| cxf-tools-java2ws                   | 3.0.3          | Java → WSDL 생성                       |
| cxf-tools-validator                 | 3.0.3          | WSDL 유효성 검증                        |
| cxf-tools-wsdlto-core               | 3.0.3          | WSDL → Java 코드 생성 (코어)           |
| cxf-tools-wsdlto-databinding-jaxb   | 3.0.3          | WSDL → Java (JAXB 바인딩)              |
| cxf-tools-wsdlto-frontend-jaxws     | 3.0.3          | WSDL → Java (JAX-WS 프론트엔드)        |
| axis                                | (버전 미표기)  | Apache Axis SOAP 클라이언트 (레거시)    |
| jaxrpc                              | (버전 미표기)  | JAX-RPC API                             |
| saaj                                | (버전 미표기)  | SOAP with Attachments API               |
| wsdl4j                              | (버전 미표기)  | WSDL 파싱 라이브러리                    |
| neethi                              | 3.0.3          | WS-Policy 프레임워크                    |

---

## 5. SAML / 보안

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| opensaml-core                       | 3.4.6          | OpenSAML 핵심                           |
| opensaml-saml-api                   | 3.4.6          | SAML API 정의                           |
| opensaml-saml-impl                  | 3.4.6          | SAML 구현체                             |
| opensaml-security-api               | 3.4.6          | 보안 API (서명, 암호화)                 |
| opensaml-soap-api                   | 3.4.6          | SAML SOAP 바인딩 API                    |
| opensaml-xmlsec-api                 | 3.4.6          | XML 보안 API                            |
| opensaml-xmlsec-impl                | 3.4.6          | XML 보안 구현                           |
| openws                              | 1.5.4          | OpenWS (SAML 메시징 지원)               |
| xmltooling                          | 1.1.0          | XML 도구 라이브러리 (SAML 의존)         |
| xmlsec                              | 2.1.4          | Apache XML Security (서명, 암호화)      |
| java-support                        | 7.5.1          | Shibboleth Java 유틸리티                |

---

## 6. JSON 처리

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| jackson-core-asl                    | 1.9.13         | Jackson 1.x 코어 (레거시)              |
| jackson-mapper-asl                  | 1.9.13         | Jackson 1.x 매퍼 (레거시)              |
| jackson-core                        | 2.13.5         | Jackson 2.x 코어 스트리밍 API          |
| jackson-databind                    | 2.13.5         | Jackson 2.x 오브젝트 매핑              |
| jackson-annotations                 | 2.13.5         | Jackson 2.x 어노테이션                 |
| json-simple                         | 1.1            | 경량 JSON 파서                          |

---

## 7. 리포트 및 Excel

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| jasperreports                       | 5.6.0          | PDF/리포트 생성 엔진                    |
| itext                               | 2.1.7          | PDF 생성 (JasperReports 의존)           |
| iTextAsian                          | (버전 미표기)  | iText 아시아 폰트 지원 (한국어/중국어)  |
| poi                                 | 3.17           | Apache POI 코어 (Excel 처리)            |
| poi-ooxml                           | 3.17           | POI OOXML (xlsx 지원)                   |
| poi-ooxml-schemas                   | 3.17           | POI OOXML 스키마                        |
| poi-examples                        | 3.17           | POI 예제                                |
| poi-excelant                        | 3.17           | POI ExcelAnt (Ant 태스크)               |
| poi-scratchpad                      | 3.17           | POI Scratchpad (ppt, doc 등)            |
| jxls-core                           | 1.0.5          | JXLS 템플릿 기반 Excel 생성            |
| jxls-reader                         | 1.0.5          | JXLS Excel 읽기                         |
| xmlbeans                            | 2.3.0          | XMLBeans (POI OOXML 의존)               |
| pdfbox-app                          | 2.0.20         | Apache PDFBox (PDF 읽기/처리)           |

---

## 8. Apache Commons

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| commons-beanutils                   | 1.8.3          | JavaBean 유틸리티                       |
| commons-codec                       | 1.5            | 인코딩/디코딩 (Base64, Hex 등)          |
| commons-collections                 | 3.2.1          | 컬렉션 프레임워크 확장                  |
| commons-collections4                | 4.4            | 컬렉션 프레임워크 확장 (4.x)           |
| commons-dbcp                        | 1.4            | 데이터베이스 커넥션 풀                  |
| commons-digester                    | 2.0            | XML → 오브젝트 매핑 (설정 파싱)        |
| commons-discovery                   | 0.2            | 서비스/리소스 검색                      |
| commons-fileupload                  | 1.2.2          | 파일 업로드 처리 (레거시)               |
| commons-fileupload                  | 1.5            | 파일 업로드 처리 (신규)                 |
| commons-io                          | 2.4            | I/O 유틸리티                            |
| commons-jexl                        | 2.0.1          | JEXL 표현식 언어 (JXLS 의존)            |
| commons-lang                        | 2.6            | 문자열/날짜/숫자 유틸리티               |
| commons-pool                        | 1.5.4          | 오브젝트 풀링                           |

---

## 9. AOP / 바이트코드

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| aspectjrt                           | 1.6.10         | AspectJ 런타임                          |
| aspectjweaver                       | 1.6.10         | AspectJ 위빙 (AOP 프록시)              |
| aopalliance                         | 1.0            | AOP Alliance 인터페이스                 |
| cglib-nodep                         | 2.2.2          | 바이트코드 생성 (Spring 프록시)         |

---

## 10. 캐시

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| ehcache                             | 2.8.3          | EHCache 인메모리 캐시                   |

---

## 11. XML 처리

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| dom4j                               | 1.6.1          | DOM4J XML 파서 (레거시)                 |
| dom4j                               | 2.1.3          | DOM4J XML 파서 (신규)                   |
| xercesImpl                          | 2.12.2         | Apache Xerces XML 파서                  |
| xml-apis                            | 1.0.b2         | XML API (레거시)                        |
| xml-apis                            | 1.4.01         | XML API                                 |
| xml-resolver                        | 1.2            | XML 카탈로그 리졸버                     |
| xmlschema-core                      | 2.2.0          | XML Schema 처리 (CXF 의존)             |
| woodstox-core-asl                   | 4.4.1          | StAX XML 파서 (고성능)                  |

---

## 12. HTTP 클라이언트

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| okhttp                              | 5.0.0-alpha.14 | OkHttp HTTP 클라이언트                  |
| okio-jvm                            | 3.9.0          | Okio I/O 라이브러리 (OkHttp 의존)      |
| kotlin-stdlib                       | 1.9.23         | Kotlin 표준 라이브러리 (OkHttp 의존)   |

---

## 13. 기타

| 라이브러리                          | 버전           | 용도                                    |
|-------------------------------------|----------------|-----------------------------------------|
| jstl                                | 1.2            | JSP 표준 태그 라이브러리                |
| javax.inject                        | 1              | JSR-330 의존성 주입 어노테이션          |
| annotations                         | 13.0           | JetBrains Annotations (@NotNull 등)     |
| guava                               | 22.0           | Google Guava 유틸리티                   |
| groovy-all                          | 2.0.1          | Groovy 스크립트 (JasperReports 의존)    |
| joda-time                           | 2.14.0         | 날짜/시간 라이브러리                    |
| lombok                              | 1.16.20        | 보일러플레이트 코드 생성 (@Getter 등)   |
| mail                                | (버전 미표기)  | JavaMail API (이메일 발송)              |
| metrics-core                        | 3.0.2          | Dropwizard Metrics (성능 측정)          |
| picon-inspien                       | 1.8            | Inspien 연동 라이브러리                 |
| client                              | (버전 미표기)  | 커스텀 클라이언트 라이브러리            |

---

## 14. 중복/다중 버전 라이브러리 (주의)

동일 라이브러리의 여러 버전이 공존하여 클래스 충돌 가능성이 있는 항목:

| 라이브러리               | 버전 1         | 버전 2         | 권장 조치                      |
|--------------------------|----------------|----------------|--------------------------------|
| mysql-connector          | 8.0.30         | 9.1.0          | 구버전 제거 검토               |
| jackson (core/mapper)    | 1.9.13 (1.x)   | 2.13.5 (2.x)   | 1.x 제거 검토                  |
| dom4j                    | 1.6.1          | 2.1.3          | 구버전 제거 검토               |
| commons-fileupload       | 1.2.2          | 1.5            | 구버전 제거 검토               |
| log4j                    | 1.2.15 (1.x)   | 2.17.1 (2.x)   | 1.x 제거 (브릿지로 대체 완료) |
| xml-apis                 | 1.0.b2         | 1.4.01         | 구버전 제거 검토               |
| commons-logging          | 1.1.3 + 무버전 | -              | 무버전 JAR 제거 검토           |
| slf4j-log4j12            | 1.6.6          | (log4j-slf4j-impl 2.17.1과 충돌) | slf4j-log4j12 제거 검토 |

---

## 15. 프론트엔드 라이브러리 (정적 리소스)

경로: `src/main/webapp/resources/`

| 라이브러리               | 버전           | 용도                                    |
|--------------------------|----------------|-----------------------------------------|
| jQuery                   | (min 포함)     | DOM 조작, AJAX, 이벤트 처리             |
| jQuery UI                | 1.11.4         | UI 위젯 (datepicker, dialog 등)         |
| EasyUI                   | 1.4            | 데이터그리드, 콤보박스 등 UI 컴포넌트   |
| CKEditor                 | 4.4.7          | 리치 텍스트 에디터                      |
| Daum Editor              | 7.5.9          | 다음 에디터                             |
| Summernote               | (master)       | 리치 텍스트 에디터                      |
| Font Awesome             | 4.7.0          | 아이콘 폰트                            |
| FullCalendar             | 2.1.1          | 달력 UI 컴포넌트                        |
| Light Slider             | -              | 이미지 슬라이더                         |
| Uploader                 | 3.1            | 파일 업로드 컴포넌트                    |
| Chart.js                 | (bundle 포함)  | 차트 라이브러리                         |
| ECharts                  | (min)          | Apache ECharts 차트 라이브러리          |

---

## 16. 총 JAR 수 요약

| 카테고리                 | JAR 수 |
|--------------------------|--------|
| Spring Framework         | 11     |
| Apache CXF (SOAP)       | 19     |
| SAML / 보안              | 11     |
| 데이터베이스 / ORM       | 7      |
| 로깅                     | 12     |
| JSON 처리                | 6      |
| 리포트 / Excel           | 13     |
| Apache Commons           | 14     |
| AOP / 바이트코드         | 4      |
| XML 처리                 | 8      |
| HTTP 클라이언트          | 3      |
| 기타                     | 12     |
| **합계**                 | **약 120개** |
