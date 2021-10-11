print <<'HTML';

<div class="row">
		<div class="col-md-12">
			
			<div class="page-header">
				<h1>
					<small>Timereservation-management-system for different objects like tables, rooms, ...</small>
				</h1>
			</div>
			<div class="form-horizontal" role="form" id="datepairExample">
			
					<div style="float:left; margin-right: 5px;">
						<input value="{{inpt['startDate']}}" placeholder="{{inpt['startDate']}}" style="float:left;" type="email" class="form-control date start" id="startDate">
					
				
			
					 
				
						<input value="{{inpt['startTime']}}" type="text" placeholder="{{inpt['startTime']}}" class="form-control time start ui-timepicker-input" style="float:left;margin-right: 5px;" id="startTime" autocomplete="off">  
					</div> 
						 
				
					<div style="float:left; margin-right: 5px;">  
						<input value="{{inpt['endDate']}}" placeholder="{{inpt['endDate']}}" style="float:left;" type="email" class="form-control date end" id="endDate">
					
						<input value="{{inpt['endTime']}}" type="text" placeholder="{{inpt['endTime']}}" class="form-control time end ui-timepicker-input" id="endTime" style="float:loaft" autocomplete="off"> 
					</div> 

					<div style="float:left; margin-right: 5px;">  
						<input value="{{inpt['persQuantity']}}" type="text" placeholder="{{inpt['persQuantity']}}" class="form-control" style="float:loaft" id="persQuantity"  autocomplete="off">
						<br><label>you can choose a container-id</label>
						<select id="containerIDs">
							<!-- AVOID TO LIST THE MESSAGE "RESERVATION DONE" AS DATA -->
							<option name="contIDs" ng-if="options[0].indexOf('Reservation') == -1" ng-repeat="o in options track by ( o.id + $index )">{{o[0]}}</option>
						</select> 
					</div>  

 
				<div class="form-group">
				</div>

				

				<div class="form-group">
					<div class="col-sm-offset-0 col-sm-10">
						 
						<button reload="yes" id="checkreservations" class="btn btn-default" style="margin-right: 5px;">
							Check reservation-possibilities	
						</button>
						
						<button reload="yes" alertMessage="yes" show-answer-in-table="no"  id="makereservation" class="btn btn-default">
							Make reservation	
						</button>




					</div>
				</div>
			</div>
		</div>
	</div>

			<h3>{{head}}</h3>
			
			<table class="table table-hover table-condensed table-bordered">
				<thead>
					<tr>
						<th ng-repeat="h in headers2">
							{{h}}	
						</th>
					</tr>
				</thead>
				<tbody>
					<tr ng-if="rows2[0].indexOf('Reservation') == -1 && mkrow == 'true'" ng-repeat="r2 in rows2 track by ( r2.id + $index )"  class="{{ myCl[$index % 2] }}">
					
						<td ng-repeat="td in r2 track by ( m.id + $index )" >
							{{td}}	
						</td>
					</tr>
				</tbody>
			</table>

	<br>
	<div class="row">
		
		<div class="col-md-9">
						 
			<button reload="yes" loadDataTables="yes" id="showreservations" class="btn btn-default" style="margin-right: 5px;">
				show reservations	
			</button>


			<button reload="yes" loadDataTables="yes" id="showcapacities" class="btn btn-default" style="margin-right: 5px;">
				show capacities	
			</button>

			<button alertMessage="yes" id="createnewcapacity" class="btn btn-default">
				Create new capacity	
			</button>

			<button alertMessage="yes" id="deletecapacity" class="btn btn-default">
				Delete capacity	
			</button>

			<br><br>
			
			<h3>{{head2}}</h3>
			<table id="showinformations" class="table table-hover table-condensed table-bordered">
				<thead><tr>
					<th ng-repeat="h in headers">{{h}}</th>

				</tr></thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
HTML
