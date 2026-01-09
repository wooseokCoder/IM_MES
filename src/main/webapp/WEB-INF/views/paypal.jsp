<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- @(#)user.jsp 1.0 2014/08/12                                            --%>
<%--                                                                        --%>
<%-- COPYRIGHT (C) 2011 C-NODE, INC.                                        --%>
<%-- ALL RIGHTS RESERVED.                                                   --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<%-- paypal 화면이다.                                         					--%>
<%--                                                                        --%>
<%-- @author C-NODE                                                         --%>
<%-- @version 1.0 2023/10/05                                                --%>
<%-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<!-- JAVASCRIPT AND STYLE INCLUDE -->
<!-- BUSINESS JAVASCRIPT -->
<link rel="shortcut icon" href="<%=request.getContextPath() %>/resources/images/favicon.ico">
<title><spring:message code="system.title"/></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/js/include/jquery-ui.min.css" />" />
<script src="<c:url value="/resources/js/include/jquery.min.js" />"></script>
<script src="<c:url value="/resources/js/include/jquery-ui.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/js/paypal.js?v=0112" />"></script>
<!-- <script src="https://www.paypal.com/sdk/js?client-id=AUaHvNMKPcBr9HkQuu6zd_R-i8G0JVHGdfGvwe3mYmxOKJPauCUSRgtQ5nXcUXhveFcj1TkHfcrLV6-1&components=buttons"></script> -->
<script src="https://www.paypal.com/sdk/js?client-id=AbwRpiwsJBPC4pOnsfbSjQEo3PeuafM5c7xzfU-JToQC5X7tnWg1SdeZfDimD2r_f85KjanUE3CtBoNA&components=buttons"></script>
<script>
paypal.Buttons({
	style: {
		layout: 'vertical',
		color:  'gold',
		shape:  'rect',
		label:  'paypal',
		disableMaxWidth: true
	},
	createOrder: function (data, actions) {
        const originalAmount = parseFloat(document.querySelector("#amount").value);
        const paypalFee = originalAmount * 0.0349 + 0.49;
        const totalAmount = originalAmount + paypalFee;
        const totalAmountRounded = totalAmount.toFixed(2);
        const description = document.getElementById("description").value;
        return actions.order.create({
        	purchase_units: [
            	{ 
            		amount: { currency_code: "USD", value: totalAmountRounded },
            		description : description
            	},
            ],
        });
    },
    onApprove: function (data, actions) {
        return actions.order.capture().then(function (orderData) {
          // Full available details
          console.log(
            "Capture result",
            orderData,
            JSON.stringify(orderData, null, 2)
          );

          // Show a success message within this page, for example:
          const element = document.getElementById("result-message");
          element.innerHTML = "";
          //element.innerHTML = "<h3>Thank you for your payment!</h3>";
          element.innerHTML  = "<h1 style='color: #333; font-size: 24px; font-weight: bold;'>Transaction " + orderData.status + "</h1>";
          element.innerHTML += "<h2 style='color: #666; font-size: 20px;'>PaymentID: " + orderData.id + "<br><br>Thank you for your payment! </h2>";
          element.innerHTML += "<p style='color: #777; font-size: 18px; margin-top: 20px;'>Please print or note down your payment ID for your records. <br>You can close this window now.</p>";
          /*resultMessage(
          	'<h1 style="color: #333; font-size: 24px; font-weight: bold;">Transaction ${transaction.status}</h1>
            <h2 style="color: #666; font-size: 20px;">PaymentID: ${transaction.id}<br><br>Thank you for your payment! </h2>
            <p style="color: #777; font-size: 18px; margin-top: 20px;">Please print or note down your payment ID for your records. <br>You can close this window now.</p>
            ',
          );*/

          // Or go to another URL:  actions.redirect('thank_you.html');
        });
    },
	onError: function (err) {
        console.log(err);
    },
}).render('#paypal-button-container');

function resultMessage(message) {
  const container = document.querySelector("#result-message");
  container.innerHTML = message;
}
</script>
<style>
/*body, html{
    height: 100%;
}
.paypal_main {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100%;
}*/
		body, html {
            height: 100%;    
            margin: 0;       
            font-family: '-apple-system', 'BlinkMacSystemFont', 'San Francisco', 'Helvetica Neue', Arial, sans-serif;
            background-color: #f7f7f7;
            display: flex;
            justify-content: center;  
            align-items: center;      
            padding: 20px;
        }

        .main-container {
            max-width: 800px;
            width: 100%;
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        .logo-container img {
            width: 200px;
            margin-bottom: 25px;
        }

        h2, p {
            color: #555;
            margin: 10px 0;
        }

        label {
            font-weight: 500;
            margin-bottom: 8px;
            color: #777;
        }

        input {
            width: 90%; 
            margin: 0 auto; 
            padding: 20px 25px;
            border-radius: 10px;
            border: 1px solid #d1d1d1;
            font-size: 1.2rem;
            transition: all 0.3s;
            outline: none;
            box-shadow: none;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path d="M12 22c5.523 0 10-4.477 10-10s-4.477-10-10-10-10 4.477-10 10 4.477 10 10 10zm0-2v-16c4.418 0 8 3.582 8 8s-3.582 8-8 8zm-8-8c0-4.418 3.582-8 8-8v16c-4.418 0-8-3.582-8-8z"/></svg>');
            background-repeat: no-repeat;
            background-size: 20px 20px;
            background-position: 10px center;
            padding-left: 45px;
            background-color: #f9f9f9;
        }


        input:hover, input:focus {
            border-color: #b0b0b0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        #paypal-button-container {
            margin-top: 25px;
            border-radius: 12px;
            overflow: hidden;
        }

        #result-message {
            color: #555;
            border: 1px solid #d1d1d1;
            padding: 14px;
            border-radius: 8px;
            background-color: #f7f7f7;
            margin-top: 18px;
        }
        
        .amount-input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        
        .fee-info-container {
            text-align: right;
            margin-top: 20px;
        }

        .fee-display,
        .total-display {
            color: #333;
            font-size: 16px;
            margin: 5px 0;
        }

        .paypal-fees-link {
            display: inline-block;
            margin-top: 10px;
            text-decoration: none;
            color: #0070ba;
            font-weight: bold;
        }

        .paypal-fees-link:hover {
            text-decoration: underline;
        }
</style>
</head>
<body style="overflow: hidden;">
	<!-- [LAYOUT] start -->
	<input type="hidden" name="openYn" id="openYn" value="<%= request.getAttribute("openYn") %>"/>
	<div class="main-container">
        <div class="logo-container">
            <img src="<%=request.getContextPath() %>/resources/images/logo-dark.svg" alt="LS Tractor USA Logo">
        </div>
        <h2>Secure Online Payments for the Dealer Portal</h2>
        <p>Enter the amount for your dealership payment and continue to the PayPal checkout.</p><br>
        <div style="position: relative;">
            <span style="position: absolute; left: 35px; top: 21px; font-size: large;">$</span>
            <input type="number" id="amount" oninput="updateTotalAmount()" class="input" style="padding-left: 50px;"
                placeholder="e.g. 100.00">
        </div><br><br>
        <label for="description">Description:</label>
        <input type="text" id="description" placeholder="e.g. Dealer Business Name">
        <br><br>
        <div class="fee-info-container">
            <div>
                <label for="paypal_fee" class="fee-display">PayPal Fee:$</label>
                <span id="paypal_fee">0.00</span>
            </div>
            <div>
                <label for="total_amount" class="total-display">Total Amount (including fee):$</label>
                <span id="total_amount">0.00</span>
            </div>
            <!-- Link to PayPal fees page -->
            <a href="https://www.paypal.com/us/webapps/mpp/merchant-fees" class="paypal-fees-link" target="_blank">View
                PayPal Fees</a>
        </div>
        <br><br><br>
        <hr>

        <div id="paypal-button-container"></div>
        <p id="result-message"></p>
        <!-- footer message -->
        <p style="text-align: center; font-size: 12px; color: #777;">Are you finding the fees for PayPal a bit higher? Reach out to our friendly accounting team at (252) 984-0700 or email accounting@lstractorusa.com. We offer hassle-free payment options like ACH transfers, domestic wire transfers, and various integrations - all without any transaction fees.</p>
    </div>
	<!-- <div class="paypal_main">
		<div id="paypal-button-container" style="max-width:1000px;"></div>
	</div> -->
</body>
</html>