print <<'HTML';
<script src="datepair.js"></script>
	<script src="jquery.datepair.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/scripts.js"></script>
	<script>
		$('#datepairExample .time').timepicker({
	        	'showDuration': true,
	        	'timeFormat': 'g:ia'
		});

		$('#datepairExample .date').datepicker({
	        	'format': 'm/d/yyyy',
	        	'autoclose': true
		});

		$('#datepairExample').datepair();

		//__________BUTTON_AJAX_CALLER_DEFINITION

$(document).ready(function(){

	function sendData( controller, ext, action ){
		var inputs = document.getElementsByTagName("input");
		var options = document.getElementsByTagName("option");
		var urlRequest = "";
		//TODO USE loop if not checkbox, while for checkbox goes a separate forEach which readout just the checked one like idName='checked'
		[].forEach.call(inputs, function(v,i){
		if( Boolean(v) == true ){

			//if( v.type == 'checkbox' && v.checked  ){
			if( v.type == 'checkbox' ){
				if( v.checked ){
				
					urlRequest = urlRequest + v.getAttribute('id') + "='checked' &";
				}
			} else {	
				var attrId = v.getAttribute("id") !== null ? v.getAttribute("id") : "none";
				var id = Boolean( document.getElementById(attrId) ) == true ? document.getElementById(attrId) : "none";
				var valOfId;
			
				valOfId = Boolean( attrId ) == true ? id.value : "placeholder";

	
	
				// attrId is id of tag-node and should have the name of params which are used in the back-end pm-modules	
				urlRequest = urlRequest + attrId + "=" + valOfId + "&";
				
			}
		}

		});

		[].forEach.call( options, function(v,i){ 
			if(v.selected){
				urlRequest = urlRequest + v.getAttribute("name") + "=" + v.value + "&"; 
			}
		});
		
		localStorage.setItem("params", action + "|" + urlRequest);
		urlRequest = controller + "." + ext + "?" + "action=" + action + "&" + urlRequest;
		// OUTPUT CREATED URL, CHECK - CAUSE IT LOST IN THE JAVASCRIPT-CONSOLE. REASON: RELOAD OF THE DOCUMENT 
		document.getElementsByTagName("pre")[0].textContent = urlRequest;
		
		// Using alert to stop the page-reload by some actions, which delete some dbg-outputs 

		//alert (" URL : " + urlRequest);

		$.ajax({
			type: "GET",
			url: urlRequest,
			success: function(msg){
				
				//alert( "Data Saved: " + typeof msg );
				console.log(msg);

				localStorage.setItem("data", JSON.stringify(msg));
				localStorage.setItem( "button_id", action);
				
				var actionId = document.getElementById(action);
				var myTestMsg = [[2,2,2,2,2], [3,3,3,3,3]];			

	
				if( actionId.getAttribute("loadDataTables")){
					//alert("TEST");
					//var dtObj;
					//dtObj && typeof dtObj == "object" ? dtObj.destroy() : dtObj = "placeholder";
					//jQuery("#showinformations").dataTable();
					localStorage.setItem("dtData", JSON.stringify(msg));
					
					/* REINITIALISATION OF DATATABLE DOESN'T WORK SO ANGULAR DO THE JOB - CREATING A HTML-TABLE */
					//var dtObj = jQuery("#showinformations").dataTable({
						//"aaData": msg,
						//"aaData":myTestMsg	
					//});
					
					//dtObj.destroy();

				}	
				
				if(actionId.getAttribute("alertMessage") == "yes" ) {
					alert(localStorage.getItem("data"));
				} 
				
				if (actionId.getAttribute("show-answer-in-table") == "no") {
					//localStorage.setItem("data", "");
					alert("test");
				}
							
				if( actionId.getAttribute("reload") == "yes" ){
					//alert("reloadable");
					document.location.reload();
				} 
			},
				error: function(error){
				alert("error: " + error);
			}
		});
	}

	//sendData( "div" );


		function defClickEvent(clickNode, controller, extension){
			$(clickNode).click(function(e){
				e.preventDefault();
				
				var inpts = document.getElementsByTagName("input");

				[].forEach.call(inpts, function(v,i){ 
					localStorage.setItem(v.getAttribute("id"), v.value);
				});	
				var pmName = $(this).attr('id');
				//alert("click success: " + pmName);
				sendData( controller , extension, pmName );
			});
		}
	

		function populateDataTable( clickNode, controller, extension ){
			$(clickNode).click(function(e){
				e.preventDefault();
				
				var inpts = document.getElementsByTagName("input");

				[].forEach.call(inpts, function(v,i){ 
					localStorage.setItem(v.getAttribute("id"), v.value);
				});	
				
				var pmName = $(this).attr('id');
				//alert("click success: " + pmName);
				sendData( controller , extension, pmName );
			});
		}


		defClickEvent(".btn", "http://172.17.0.2/cgi-bin/ONLINERESERVATION/controller", "cgi");

		var aaDt = [];

		var tmp_cache =	JSON.parse( localStorage.getItem("dtData") );

		tmp_cache.map( ( v, i )=>{
				v[v.length] = "<input type='checkbox' id='checkedContId_" + v[0] +"'  />";
				aaDt.push(v);
		});

		jQuery("#showinformations").dataTable({
			//"aaData": JSON.parse(localStorage.getItem("dtData")) 
			"aaData": aaDt 
		});
});


		/*****  Angular-Start *****/

		var app = angular.module('myApp', []);

		app.controller('myCtrl', function($scope, $http){
		
	
		$scope.myCl = ["success", "warning","danger"];
		
		/*
		$scope.rows = [
				// capacity of object, number of object, timearea  
				[ "2", "6", "2017-09-09 9:33", "success"],
				[ "3", "3", "2017-09-09 9:33", "warning"],
				[ "4", "7", "2017-09-09 9:33", "danger"]
			];

		
		$scope.rows2 = [
				// capacity of object, number of object, timearea  
				[ "2", "6", "2017-09-09 9:33"],
				[ "3", "3", "2017-09-09 9:33"],
				[ "4", "7", "2017-09-09 9:33"]
			];
		*/

		var sended = localStorage.getItem("data");
		
		if(sended){
			typeof sended == "object" ? $scope.rows2 = localStorage.getItem("data") : $scope.rows2 = JSON.parse(localStorage.getItem("data"));
		}
		
		localStorage.getItem("makeOpt") == "yes" ? $scope.options = $scope.rows2 : $scope.options = "";
		
		var inp = document.getElementsByTagName("input");
		
		$scope.inpt = new Array();	
		
		[].forEach.call( inp, function(v,i){
			var id = v.getAttribute("id");
			$scope.inpt[id] = localStorage.getItem(id);;
			
		});

		var bttn_id = localStorage.getItem("button_id");

		$scope.mkrow = 'false';
		
		if( bttn_id.match("showreservations") ){
			localStorage.setItem("makeOpt", "no");
			$scope.head2 = "All reservations";	
			$scope.headers = [ "reservation-ID", "container-ID", "capacity", "persons", "reservation at", "reservation until" ];
			localStorage.setItem("headerMem", JSON.stringify($scope.headers));
						
		} else if ( bttn_id.match("showcapacities")){
			localStorage.setItem("makeOpt", "no");
			$scope.head2 = "All capacities";	
			$scope.headers = [ "container-ID", "capacity", "reservation allowed at", "reservation allowed until", "" ];
			localStorage.setItem("headerMem", JSON.stringify($scope.headers));

		} else if ( bttn_id.match("checkreservations")) {
			
			$scope.head = "Check if reservation is possible";
			localStorage.setItem("headerMem2", JSON.stringify([ "container-ID", "capacity", "reservation allowed at", "reservation allowed until" ]));
			localStorage.setItem("makeOpt", "yes");
			//alert(JSON.stringify($scope.options));
			$scope.mkrow = 'true';
			$scope.headers2 = JSON.parse(localStorage.getItem("headerMem2"));

		} 

		else {
			$scope.head = "Check if reservation is possible";
			$scope.headers = JSON.parse(localStorage.getItem("headerMem"));
			localStorage.setItem("makeOpt", "yes");
			//alert(JSON.stringify($scope.options));
			$scope.mkrow = 'true';
			$scope.headers2 = JSON.parse(localStorage.getItem("headerMem2"));
		}
		

		//alert(JSON.stringify($scope.options));
		//console.log(" |||  " + JSON.stringify( $scope.rows2 ));
		//___ANGULAR_SERVICE_AJAX_CALLS
		/*
		var contrUrl = "http://172.17.0.2/cgi-bin/ONLINERESERVATION/controller.cgi";
		$http({
	        	method : "GET",
		        url : contrUrl + "?action=contain-id&"
	    	}).then(function mySuccess(response) {
			$scope.options = response.data;
                	console.log(JSON.stringify(response.data));
		}, function myError(response) {
        		$scope.cont = response.statusText;
                	console.log(JSON.stringify(response.statusText));
		});
		*/
	});
		

	</script>
HTML
