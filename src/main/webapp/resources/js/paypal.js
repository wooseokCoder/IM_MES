/**
 * 페이팔을 처리하는 스크립트이다.
 */

$(function() {
	/*
	setTimeout(function (){
		serveChk = setInterval( function () {
			var chkUrl = "";
			if(host.substring(0,5) == 'check' || host.substring(0,5) == 'monit') {
				chkUrl = 'https://monitoring.lstractor.co.kr/lsmd/index.do';
			} else if(host.substring(0,2) == '35') {
				chkUrl = 'http://35.155.122.34:8080/lsmd/index.do';
			} else {
				chkUrl = 'http://localhost:8080/lsmd/index.do';
			}
			$.get(chkUrl, function() {
		        //console.log('success');
				if(reloadYn == 'Y') {
					reloadYn = 'N';
					reloadDashboardData();
				}
		    })
		    .fail(function() {
		    	console.log('failure');
		    	var contents = "";
		    	contents += '<li style="display:flex;align-items:center;justify-content:center;"><p style="color:#002658;font-size:100px;font-weight:bold;">서비스 점검중 입니다.</p>';
				contents += '</li>';
		    	$(".bxslider").html(contents);
		    	if(reloadYn == 'N') clearInterval(timer);
		    	reloadYn = 'Y';
		    	if(vidWin == undefined || vidWin.closed == true) {
		    		
		    	} else {
		    		if(vidWin.closed == false) {
		    			//console.log("video end");
		    			//vidWin.close();
		    		}
		    	}
		    });
		}, 10000);
		
		reloadDashboardData();
	}, 100);*/
});

function calculatePayPalFee(amount) {
	const percentageFee = 3.49 / 100; 
	const fixedFee = 0.49; 
	return (amount * percentageFee) + fixedFee;
}

function updateTotalAmount() {
	const originalAmount = parseFloat(document.querySelector("#amount").value);
	if (isNaN(originalAmount)) return; 

	const paypalFee = calculatePayPalFee(originalAmount);
	const totalAmount = originalAmount + paypalFee;

	document.querySelector("#paypal_fee").textContent = paypalFee.toFixed(2);
	document.querySelector("#total_amount").textContent = totalAmount.toFixed(2);
}
