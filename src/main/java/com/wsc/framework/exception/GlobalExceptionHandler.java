/*
 * @(#)GlobalExceptionHandler.java 1.0 2026/01/23
 *
 * COPYRIGHT (C) 2011 C-NODE, INC.
 * ALL RIGHTS RESERVED.
 */
package com.wsc.framework.exception;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 전역 예외 핸들러 클래스이다.
 * AJAX 요청에서 예외 발생 시 HTTP 500을 반환한다.
 *
 * @author C-NODE
 * @version 1.0 2026/01/23
 */
@ControllerAdvice
@Order(Ordered.HIGHEST_PRECEDENCE)
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);
    private static final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * AJAX 요청인지 확인한다.
     *
     * @param request HTTP 요청
     * @return AJAX 요청 여부
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        String uri = request.getRequestURI();

        // XMLHttpRequest 헤더 확인
        if ("XMLHttpRequest".equals(requestedWith)) {
            return true;
        }

        // Accept 헤더에 application/json 포함 확인
        if (accept != null && accept.contains("application/json")) {
            return true;
        }

        // URL이 .json으로 끝나는 경우
        if (uri != null && uri.endsWith(".json")) {
            return true;
        }

        return false;
    }

    /**
     * 에러 응답 맵을 생성한다.
     *
     * @param message 에러 메시지
     * @param errorCode 에러 코드
     * @return 에러 응답 맵
     */
    private Map<String, Object> createErrorResponse(String message, int errorCode) {
        Map<String, Object> errorResponse = new HashMap<String, Object>();

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("code", errorCode);
        result.put("message", message);

        errorResponse.put("success", false);
        errorResponse.put("error", message);
        errorResponse.put("result", result);

        return errorResponse;
    }

    /**
     * JSON 에러 응답을 전송한다.
     *
     * @param response HTTP 응답
     * @param errorResponse 에러 응답 맵
     * @throws IOException IO 예외
     */
    private void sendJsonErrorResponse(HttpServletResponse response, Map<String, Object> errorResponse)
            throws IOException {
        response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
        response.getWriter().flush();
    }

    /**
     * SQL 예외를 처리한다. (프로시저 에러 포함)
     *
     * @param request HTTP 요청
     * @param response HTTP 응답
     * @param ex SQL 예외
     * @return ModelAndView (AJAX가 아닌 경우) 또는 null
     */
    @ExceptionHandler(SQLException.class)
    public ModelAndView handleSQLException(
            HttpServletRequest request, HttpServletResponse response, SQLException ex) throws IOException {

        log.error("SQL Exception occurred: {}", ex.getMessage(), ex);

        if (isAjaxRequest(request)) {
            String message = "Database error: " + ex.getMessage();
            Map<String, Object> errorResponse = createErrorResponse(message, ex.getErrorCode());
            sendJsonErrorResponse(response, errorResponse);
            return null;
        }

        // AJAX가 아닌 경우 에러 페이지로 이동
        ModelAndView mav = new ModelAndView("error/system");
        mav.addObject("exception", ex);
        mav.addObject("message", ex.getMessage());
        return mav;
    }

    /**
     * Spring DataAccessException을 처리한다. (MyBatis 에러 포함)
     *
     * @param request HTTP 요청
     * @param response HTTP 응답
     * @param ex DataAccess 예외
     * @return ModelAndView (AJAX가 아닌 경우) 또는 null
     */
    @ExceptionHandler(DataAccessException.class)
    public ModelAndView handleDataAccessException(
            HttpServletRequest request, HttpServletResponse response, DataAccessException ex) throws IOException {

        log.error("DataAccess Exception occurred: {}", ex.getMessage(), ex);

        if (isAjaxRequest(request)) {
            // 원인 예외에서 더 상세한 메시지 추출
            String message = ex.getMessage();
            Throwable rootCause = ex.getRootCause();
            if (rootCause != null) {
                message = rootCause.getMessage();
            }

            Map<String, Object> errorResponse = createErrorResponse("Database error: " + message, -1);
            sendJsonErrorResponse(response, errorResponse);
            return null;
        }

        ModelAndView mav = new ModelAndView("error/system");
        mav.addObject("exception", ex);
        mav.addObject("message", ex.getMessage());
        return mav;
    }

    /**
     * ServiceException을 처리한다.
     *
     * @param request HTTP 요청
     * @param response HTTP 응답
     * @param ex Service 예외
     * @return ModelAndView (AJAX가 아닌 경우) 또는 null
     */
    @ExceptionHandler(ServiceException.class)
    public ModelAndView handleServiceException(
            HttpServletRequest request, HttpServletResponse response, ServiceException ex) throws IOException {

        log.error("Service Exception occurred: {}", ex.getMessage(), ex);

        if (isAjaxRequest(request)) {
            Map<String, Object> errorResponse = createErrorResponse(ex.getMessage(), -1);
            sendJsonErrorResponse(response, errorResponse);
            return null;
        }

        ModelAndView mav = new ModelAndView("error/service");
        mav.addObject("exception", ex);
        mav.addObject("message", ex.getMessage());
        return mav;
    }

    /**
     * SystemException을 처리한다.
     *
     * @param request HTTP 요청
     * @param response HTTP 응답
     * @param ex System 예외
     * @return ModelAndView (AJAX가 아닌 경우) 또는 null
     */
    @ExceptionHandler(SystemException.class)
    public ModelAndView handleSystemException(
            HttpServletRequest request, HttpServletResponse response, SystemException ex) throws IOException {

        log.error("System Exception occurred: {}", ex.getMessage(), ex);

        if (isAjaxRequest(request)) {
            Map<String, Object> errorResponse = createErrorResponse(ex.getMessage(), -1);
            sendJsonErrorResponse(response, errorResponse);
            return null;
        }

        ModelAndView mav = new ModelAndView("error/system");
        mav.addObject("exception", ex);
        mav.addObject("message", ex.getMessage());
        return mav;
    }

    /**
     * 일반 Exception을 처리한다.
     *
     * @param request HTTP 요청
     * @param response HTTP 응답
     * @param ex 예외
     * @return ModelAndView (AJAX가 아닌 경우) 또는 null
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(
            HttpServletRequest request, HttpServletResponse response, Exception ex) throws IOException {

        log.error("Unexpected Exception occurred: {}", ex.getMessage(), ex);

        if (isAjaxRequest(request)) {
            String message = ex.getMessage();
            if (message == null || message.isEmpty()) {
                message = "An unexpected error occurred";
            }

            Map<String, Object> errorResponse = createErrorResponse(message, -1);
            sendJsonErrorResponse(response, errorResponse);
            return null;
        }

        ModelAndView mav = new ModelAndView("error/system");
        mav.addObject("exception", ex);
        mav.addObject("message", ex.getMessage());
        return mav;
    }
}
