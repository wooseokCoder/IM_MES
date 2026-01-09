/**
 * WSDL Test JavaScript
 */

var wsdltest = {
	
	init: function() {
		this.bindEvents();
		this.hideLoading();
	},
	
	bindEvents: function() {
		// Service 선택 변경 이벤트
		$("#service-name").bind("change", function() {
			wsdltest.onServiceChange();
		});
		
		// Call Service 버튼 클릭 이벤트
		$("#call-service-button").bind("click", function() {
			wsdltest.callService();
		});
	},
	
	onServiceChange: function() {
		var serviceName = $("#service-name").val();
		if (!serviceName || serviceName === "") {
			$("#request-data").val("");
			return;
		}
		
		// 서버에서 SOAP XML 템플릿 가져오기
		$("#request-data").val("Loading template...");
		
		$.ajax({
			url: getUrl("/common/sample/wsdltest/getSoapTemplate.json"),
			type: "POST",
			data: {
				serviceName: serviceName
			},
			dataType: "json",
			success: function(response) {
				if (response.success && response.soapTemplate) {
					$("#request-data").val(response.soapTemplate);
				} else {
					$("#request-data").val("");
					if (response.message) {
						$.messager.alert("Warning", response.message, "warning");
					}
				}
			},
			error: function(xhr, status, error) {
				$("#request-data").val("");
				$.messager.alert("Error", "Failed to load template: " + error, "error");
			}
		});
	},
	
	hideLoading: function() {
		$("#loadingProgressBar").hide();
		$("#wsdltest-layout").show();
	},
	
	callService: function() {
		var serviceName = $("#service-name").val();
		var requestData = $("#request-data").val();
		
		if (!serviceName || serviceName === "") {
			$.messager.alert("Error", "Please select a service name.", "error");
			return;
		}
		
		if (!requestData || requestData.trim() === "") {
			$.messager.alert("Error", "Please enter request data.", "error");
			return;
		}
		
		// SOAP XML 기본 유효성 검사 (Envelope 태그 확인)
		if (requestData.indexOf("<soapenv:Envelope") === -1 && requestData.indexOf("<soap:Envelope") === -1) {
			$.messager.alert("Warning", "The request data does not appear to be valid SOAP XML.", "warning");
		}
		
		// 결과 영역 초기화
		$("#wsdl-test-result").html("Calling service...").removeClass("result-success result-error");
		
		// AJAX 요청
		$.ajax({
			url: getUrl("/common/sample/wsdltest/callService.json"),
			type: "POST",
			data: {
				serviceName: serviceName,
				requestData: requestData
			},
			dataType: "json",
			success: function(response) {
				if (response.success) {
					var resultHtml = '<div class="result-success">Success</div>';
					resultHtml += '<div>Service: ' + response.serviceName + '</div>';
					resultHtml += '<div>Message: ' + response.message + '</div>';
					if (response.result) {
						resultHtml += '<div><strong>Response:</strong></div>';
						resultHtml += '<div>' + JSON.stringify(response.result, null, 2) + '</div>';
					}
					$("#wsdl-test-result").html(resultHtml).addClass("result-success");
				} else {
					var resultHtml = '<div class="result-error">Error</div>';
					resultHtml += '<div>Message: ' + response.message + '</div>';
					$("#wsdl-test-result").html(resultHtml).addClass("result-error");
				}
			},
			error: function(xhr, status, error) {
				var resultHtml = '<div class="result-error">Error</div>';
				resultHtml += '<div>Status: ' + status + '</div>';
				resultHtml += '<div>Error: ' + error + '</div>';
				if (xhr.responseText) {
					try {
						var errorResponse = JSON.parse(xhr.responseText);
						resultHtml += '<div>Message: ' + errorResponse.message + '</div>';
					} catch (e) {
						resultHtml += '<div>Response: ' + xhr.responseText + '</div>';
					}
				}
				$("#wsdl-test-result").html(resultHtml).addClass("result-error");
			}
		});
	}
};

$(function() {
	wsdltest.init();
});

