/**
 * Auto Login Test Script
 * 
 * Send auto login email with token-based authentication
 */
var autologintest = {
    url: {
        autologin: getUrl("/common/sample/autologintest/autologin.do"),
        sendEmail: getUrl("/common/sample/autologintest/sendEmail.json")
    },
    
    init: function() {
        $("#autologin-layout").fadeIn(300);
        $("#loadingProgressBar").hide();
    }
};

/**
 * Send Auto Login Email
 */
function doSendEmail() {
    var params = {
        userId: $("#email-userId").val(),
        emailAddress: $("#email-address").val(),
        targetUrl: $("#email-targetUrl").val()
    };
    
    if (!params.userId || !params.emailAddress || !params.targetUrl) {
        $.messager.alert(msg.MSG0051, msg.MSG0111, "Warning");
        return;
    }
    
    // Email validation
    var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(params.emailAddress)) {
        $.messager.alert(msg.MSG0051, "Please enter a valid email address.", "Warning");
        return;
    }
    
    $.ajax({
        url: autologintest.url.sendEmail,
        type: "POST",
        data: params,
        dataType: "json",
        success: function(data) {
            var result = "";
            if (data.success) {
                result += "<div class='result-success'>Email sent successfully</div>";
                result += "<div><strong>Recipient:</strong> " + params.emailAddress + "</div>";
                result += "<div><strong>Target URL:</strong> " + params.targetUrl + "</div>";
            } else {
                result += "<div class='result-error'>Email sending failed</div>";
                if (data.message) {
                    result += "<div>" + data.message + "</div>";
                }
            }
            $("#send-email-result").html(result);
        },
        error: function(xhr, status, error) {
            $("#send-email-result").html("<div class='result-error'>Error occurred: " + error + "</div>");
        }
    });
}

$(function() {
    autologintest.init();
    
    // Event binding
    $("#send-email-button").bind("click", doSendEmail);
});
