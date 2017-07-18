<!-- <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Provider</title>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

<script type="text/javascript">
	var listOfLoginFields = [];

	function makeXmlHttpRequestAndGetResponse(parameters, functionName) {
		var response = "";
		var xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.open("POST", "/Forms/Controller", true); //this is synchronous to avoid having too many connections open

		xmlHttpReq.setRequestHeader('Content-Type',
				'application/x-www-form-urlencoded');

		xmlHttpReq.onreadystatechange = function() {
			if (xmlHttpReq.readyState == 4 && xmlHttpReq.status == 200) {
				functionName(xmlHttpReq.responseText.toString());
			}
		};
		xmlHttpReq.send(parameters);
		success = "no";
	}

	function getProviderList() {
		document.getElementById("demo6").innerHTML = "";
		document.getElementById("demo7").innerHTML = "";
		document.getElementById("mfaDetailsForm").style.visibility = 'hidden';
		document.getElementById("mfaDetailsForm").style.display = 'none';
		document.getElementById("demo3").innerHTML = "";
		document.getElementById("searchSiteString").readOnly = 'true';

		var siteString = $("#searchSiteString").val();
		var buttonSearchSite = $("#SearchForSite").val();
		var parameters = "button=" + buttonSearchSite + "&siteString="
				+ siteString;
		makeXmlHttpRequestAndGetResponse(parameters, parseSiteDetailsAndDisplay);
	}

	function parseSiteDetailsAndDisplay(responseSiteList) {
		var json_obj = $.parseJSON(responseSiteList);
		if (json_obj.provider) {
			document.getElementById("demo3").innerHTML = JSON
					.stringify(json_obj.provider);
			var provider = json_obj.provider;
			for (i in provider) {
				var name = provider[i].name;
				var provider_id = provider[i].id;
				var selectTag = document.getElementById("siteList-select");
				var option = document.createElement("option");
				option.text = name;
				option.value = String(provider_id);
				selectTag.add(option);
			}
			var selectTag = document.getElementById("siteList-select");
			var option = document.createElement("option");
			option.text = "Choose a Bank";
			option.value = "default";
			option.selected = "selected";
			selectTag.add(option);
			document.getElementById("siteList-select").style.visibility = 'visible';
			document.getElementById("siteList-select").style.display = 'block';
			document.getElementById("GetLoginForm").style.visibility = 'visible';
			document.getElementById("GetLoginForm").style.display = 'block';
		}
		document.getElementById("viewRespBanks").style.visibility = 'visible';
		document.getElementById("viewRespBanks").style.display = 'block';

	}

	function getLoginForm() {
		var e = document.getElementById("siteList-select");
		var id = e.options[e.selectedIndex].value;/* 
																document.getElementById("test").innerHTML = id; */
		var buttonGetForm = $("#GetLoginForm").val();
		var parameters = "button=" + buttonGetForm + "&provider_id=" + id;
		makeXmlHttpRequestAndGetResponse(parameters, parseLoginFormResponse);
	}

	function parseLoginFormResponse(responseSiteList) {
		var json_obj = $.parseJSON(responseSiteList);

		if (json_obj.login) {
			var login = json_obj.login
			/* 			document.getElementById("demo10").innerHTML = JSON
			 .stringify(json_obj.login); */

			for (j in login) {
				var label = login[j].label;
				var type = login[j].type;
				var id = login[j].id;

				if (type != "option") {
					var para = document.createElement("p");
					document.getElementById('demo6').appendChild(para);
					var loginField = document.createElement("INPUT");
					loginField.setAttribute("type", type);
					loginField.setAttribute("name", label.replace(" ", ""));
					loginField.setAttribute("id", label.replace(" ", ""));
					loginField.setAttribute("placeholder", "Enter " + label);
					loginField.setAttribute("class", "form-control");
					document.getElementById('demo6').appendChild(loginField);

					var itemLabel = document.createElement("Label");
					itemLabel.setAttribute("for", loginField);
					itemLabel.innerHTML = label + ":&nbsp" + " ";
					document.getElementById('demo6').insertBefore(itemLabel,
							loginField);
					var linebreak = document.createElement("br");
					document.getElementById('demo6').appendChild(linebreak);
					var para = document.createElement("p");
					document.getElementById('demo6').appendChild(para);
				} else {
					var option = login[i].option;
					var para1 = document.createElement("p");
					para1.innerHTML = label;
					document.getElementById('demo6').appendChild(para1);
					for (k in option) {
						var linebreak = document.createElement("br");
						var radioInput = document.createElement("INPUT");/* 
																																				document.getElementById("test").innerHTML = option[k].displayText; */
						var radioInput = document.createElement("INPUT");
						radioInput.setAttribute('type', 'radio');
						radioInput.setAttribute('name', 'option');
						radioInput.setAttribute('value', option[k].displayText);

						var itemLabel = document.createElement("Label");
						itemLabel.setAttribute("for", radioInput);
						itemLabel.setAttribute("style", "margin-left:10px")
						itemLabel.innerHTML = " " + option[k].displayText;
						document.getElementById('demo6').appendChild(itemLabel);
						document.getElementById('demo6').insertBefore(
								radioInput, itemLabel);

						document.getElementById('demo6').appendChild(linebreak);

					}
				}
			}

			var submit = document.createElement("span");
			submit.innerHTML = "<input type = 'button' id ='addItemApi' style='margin-top:20px' class='btn button' value = 'Submit'>";
			document.getElementById("demo6").appendChild(submit);
			document.getElementById("mfaDetailsForm").style.visibility = 'visible';
			document.getElementById("mfaDetailsForm").style.display = 'block';

		}
	}
</script>
</head>
<body>
	<h3 style="margin: 25px">Login Form App</h3>
	<form class="form-inline" id="cobLoginForm" role="form"
		style="margin: 20px">
		<fieldset>
			<legend>Cobrand Login</legend>


			<label for="cobUrl">Rest URL:</label> <input type="text"
				class="form-control" name="cobUrl" id="cobUrl" style="width: 500px"
				placeholder="Enter Rest URL"> <br> <br>
			<div class="form-group">
				<label for="username">Cobrand Login:</label> <input type="text"
					class="form-control" name="username" id="username"
					placeholder="Enter cobrand Login">
			</div>
			<div class="form-group">
				<label for="password">Cobrand Password:</label> <input
					type="password" class="form-control" name="password" id="password"
					placeholder="Enter cobrand Password">
			</div>

			<div class="form-group">
				<label style="visibility: hidden" id="cobTokenLabel" for="cobToken">CobSessionToken:</label>
				<input type="text" style="visibility: hidden" class="form-control"
					name="cobToken" id="cobToken" placeholder="Enter cobsessiontoken">
			</div>
			<br>
			<p></p>
			<br>
			<button type="button" name="cobLogin" id="cobLogin"
				class="btn button" value="cobLogin" onclick="validateCobloginForm()">Login</button>

			<button type="button" id="viewRespCoblogin" class="btn btn-info"
				data-toggle="collapse" data-target="#demo"
				style="margin-left: 150px; margin-top: 20px; visibility: hidden">View
				Response</button>
			<div style="margin-left: 500px; margin-top: 10px">
				<textarea id="demo" class="collapse" rows="4" cols="100"
					style="margin-top: 0px">
   
    </textarea>
			</div>

		</fieldset>
	</form>

	<form class="form-inline" id="userLoginForm" role="form"
		style="margin: 20px">
		<!-- style="visibility: hidden; display: none"> -->
		<fieldset>
			<legend>User Login</legend>
			<div class="form-group">
				<label for="userID"> Login:</label> <input type="text"
					class="form-control" name="userId" id="userId"
					placeholder="Enter Login">
			</div>
			<div class="form-group">
				<label for="password">Password:</label> <input type="password"
					class="form-control" name="userPass" id="userPass"
					placeholder="Enter Password">
			</div>

			<div class="form-group" id="addUserSessionTokenHere">
				<label id="userSessionLabel" style="visibility: hidden"
					for="searchForSite">UserSessionToken:</label>
			</div>
			<br> <br>
			<button type="button" name="userLogin" id="userLogin"
				value="userLogin" class="btn button" onclick="validateUserInfo()">Login</button>

			<button type="button" id="viewRespUserSession" class="btn btn-info"
				data-toggle="collapse" data-target="#demo1"
				style="margin-left: 150px; margin-top: 20px; visibility: hidden">View
				Response</button>
			<div style="margin-left: 500px; margin-top: 10px">
				<textarea id="demo1" class="collapse" rows="4" cols="100"
					style="margin-top: 0px">
   
    </textarea>
			</div>
		</fieldset>
	</form>


	<form class="form-inline" id="searchBankForm" role="form"
		style="margin: 20px">
		<fieldset>
			<legend> Search Provider</legend>
			<div class="form-group">
				<label for="searchForSite">Search Provider</label> <input
					type="text" class="form-control" name="searchSiteString"
					id="searchSiteString" placeholder="Enter Name">
			</div>

			<button type="button" name="SearchForSite" id="SearchForSite"
				value="SearchForSite" class="btn button" onclick="getProviderList()">Search</button>

			<br>
			<button type="button" id="viewRespBanks" class="btn button"
				data-toggle="collapse" data-target="#demo3"
				style="visibility: hidden; display: none; margin-top: 20px">View
				Response</button>
			<br>
			<div>
				<textarea id="demo3" class="collapse" rows="4" cols="100"
					style="margin-top: 0px"></textarea>
			</div>
			<br> <select name="siteList-select" id="siteList-select"
				class="selectBank" style="visibility: hidden; display: none">
				<option value="" selected="selected">Choose a Bank</option>
			</select> <br>
			<button type="button" name="GetLoginForm" id="GetLoginForm"
				value="GetLoginForm" class="btn button" onclick="getLoginForm()"
				style="visibility: hidden; display: none">Submit</button>
			<p id="test"></p>

		</fieldset>

	</form>
	<form class="form-inline" id="mfaDetailsForm" role="form"
		style="visibility: hidden; display: none; margin: 20px">
		<fieldset>

			<div id="demo6"></div>
			<div id="demo7"></div>
			<button type="button" class="btn btn-info" id="viewRespMfa"
				data-toggle="collapse" data-target="#demo10"
				style="visibility: hidden; display: none">View Response</button>
			<div>
				<textarea id="demo10" class="collapse" rows="4" cols="100"
					style="margin-top: 0px; visibility: hidden; display: none">
    </textarea>
			</div>
		</fieldset>
	</form>
</body>
</html>
