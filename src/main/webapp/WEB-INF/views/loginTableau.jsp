<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tableau Login</title>
</head>
<body>
	<h1>Tableau Login</h1>
	<button type="button" onclick="sendRequest()">Tableau Login</button>
	<p id="text"></p>
</body>

<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<script>
	function sendRequest(){
		$.ajax({
			url : "https://us-east-1.online.tableau.com/api/3.11/auth/signin",
			type : "post",
			data : {
             	"credentials": {
             		"personalAccessTokenName": "LSDP_DASH01",
             		"personalAccessTokenSecret": "I1JJOJLSRSm2cfuyUag3SQ==:a3aVetMD8HgdJjKfGFSfqihwSee8KlYW",
             		"site": {
             			"contentUrl": "lstractor"
             		}
             	}
             },
			dataType : "text",
			success : function(result){
				document.getElementById("text").innerHTML = result;
			}
		});
	}
</script>
</html>
