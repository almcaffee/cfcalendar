<cfparam name="url.date" default="#DateFormat(Now(),"yyyy-mm-dd")#">

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Calendar</title>

<style type="text/css">
body {
	font-family: sans-serif !important;
	background: #ccc !important;
}
#calendar {
	background: #ccc !important;
	<!---  7 day width --->
	max-width: 620px !important;
	<!-- end 7 day width --->
	padding: 0px 20px 20px 20px !important;
}

.day, .dayView, .outerDay, .innerDay, .dayViewGrey, .outerDayGrey, .innerDayGrey {
	display: inline-block !important;
	text-align: center !important;
	width: 80px !important;
	min-width: 80px !important;
	max-width: 80px !important;
	margin: 0px !important;
	padding: 0px !important;
}
.dayView, .outerDay, .innerDay, .dayViewGrey, .outerDayGrey, .innerDayGrey {
	border: 0px !important;
}
.outerDay, .outerDayGrey, .innerDayGrey {
	color: #999 !important;
}
.innerDay {
	background: #fff;
		color: #555 !important;
}
.outerDay, .outerDayGrey {
	font-size: .7em !important;
	padding: 10px 0 !important;
}
.innerDay, .innerDayGrey {
	font-size: .9em !important;
	font-weight: bold !important;
	padding: 15px 0 !important;
	
}
.day, .dayViewGrey {
	border: 1px solid #ccc !important;

}
.day:hover {
	border: 1px solid #c08e09 !important;
}
.day:hover .outerDay {
	background: #c08e09 !important;
	color: #fff !important;	
}
.day:hover .innerDay {
	background: #fff !important;
	color: #555 !important;	
}
.outerDay {
background: #999 !important;
color: #fff !important;

}
.outerDayGrey {
background: #e9e6e6 !important;

}
</style>

</head>
<body>

<!--- Leading day EQ days of the month in the week from previous month --->
<!--- Trailing day EQ days of the month in the week from next month --->


<!--- Outputs the leading X days Day(date) 1:6 --->
<cffunction name="getStart" returntype="any" output="yes">
  <cfargument name="date" default="2016-01-01">
  
  <!--- --->
  
  <!--- Day one of month of date argument --->
  <cfset startDayOne = CreateDate(DatePart("yyyy",ARGUMENTS.date),DatePart("m",ARGUMENTS.date),1)>
  <!--- Day of week of day one --->
  <cfset StartDayNum = DayOfWeek(startDayOne)>
  <!--- Difference between day one of month and day one of week --->
  <cfset startDayDif = StartDayNum - 1>
  <!--- If day one of month is not day one of week set day one of week
  as a new date that is the difference of days before the day of the week
  of day one and the first day of the week ex: Wed(4) - Sun(1) = 3 leading days
  wednesday is first day of month then the date of sunday is returned
  --->
  <cfif startDayDif GT 0>
   <cfset startDate = DateAdd('d', -startDayDif, startDayOne)>
  <cfelse>
   <cfset startDate = DateAdd('d', startDayDif, startDayOne)>
  </cfif>
  
  <!--- If day one of the month is not Sunday (CFML first day of week) --->
  <cfif startDayDif GT 0>
  
  <!--- Loop from the day of the month of the first leading day in the week to the last day of the month 
  with the current day of the leading month as an index
  --->
  <cfloop from="#DatePart("d",startDate)#" to="#DaysInMonth(startDate)#" index="dateday">
   <cfset thisDate = CreateDate(DatePart("yyyy",startDate),DatePart("m",startDate),dateday)>
   <cfset thisDay = DayOfWeek(thisDate)>
    <div class="dayViewGrey">
      <div class="outerDayGrey"><cfoutput>#HTMLEditFormat(DayOfWeekAsString(thisDay))#</cfoutput></div>
      <div class="innerDayGrey"><cfoutput>#HTMLEditFormat(Day(thisDate))#</cfoutput></div>
    </div>
  </cfloop>
  </cfif>
  
</cffunction>

<!--- Outputs the trailing X days Day(date) 2:7 --->
<cffunction name="getEnd" returntype="any" output="yes">
  <cfargument name="date" default="2016-01-01">
  
  <!--- Last day of month of date argument --->
  <cfset endLastDay = CreateDate(DatePart("yyyy",ARGUMENTS.date),DatePart("m",ARGUMENTS.date),DaysInMonth(ARGUMENTS.date))>
  <!--- Day of week of last day --->
  <cfset endDayNum = DayOfWeek(endLastDay)>
  <!--- # of trailing days --->
  <cfset endDayDif = 7 - endDayNum>
  <!--- If last day of the month is not the last day of the week get last trailing day
  --->
  <cfif endDayDif GT 0>
  <cfset endDate = DateAdd('d', endDayDif, ARGUMENTS.date)>
  <cfelse>
  <cfset endDate = endLastDay>
  </cfif>
  
  <!--- Loop through days of the month 1:N, output days --->
  <cfif endDayDif GT 0>
  <cfloop from="1" to="#endDayDif#" index="dateday">
    <cfset thisDate = CreateDate(DatePart("yyyy",endDate),DatePart("m",endDate),dateday)>
    <cfset thisDay = DayOfWeek(thisDate)>
    <div class="dayViewGrey">
      <div class="outerDayGrey"><cfoutput>#HTMLEditFormat(DayOfWeekAsString(thisDay))#</cfoutput></div>
      <div class="innerDayGrey"><cfoutput>#HTMLEditFormat(Day(thisDate))#</cfoutput></div>
    </div>
  </cfloop>

  </cfif>
  
</cffunction>

<!--- Unused | for future code enhancement --->
<cfset monthArray = ArrayNew(2)>
<cfset monthArray[1] = ["January","31"]>
<cfset monthArray[2] = ["February","28"]>
<cfset monthArray[3] = ["March","31"]>
<cfset monthArray[4] = ["April","30"]>
<cfset monthArray[5] = ["May","31"]>
<cfset monthArray[6] = ["June","30"]>
<cfset monthArray[7] = ["July","31"]>
<cfset monthArray[8] = ["August","31"]>
<cfset monthArray[9] = ["September","30"]>
<cfset monthArray[10] = ["October","31"]>
<cfset monthArray[11] = ["November","30"]>
<cfset monthArray[12] = ["December","31"]>


<!--- Get month variable for calendar header output --->
<cfset displayMonth = DatePart("m",url.date)>
<h2><cfoutput>#HTMLEditFormat(MonthAsString(displayMonth))#</cfoutput></h2>

<div id="calendar">
<!--- Output leading days --->
<cfset startMonth = getStart(url.date)>

<!--- Ouput days in current month --->
<cfloop from="1" to="#DaysInMonth(url.date)#" index="monthDays">
  <cfset thisDate = CreateDate(DatePart("yyyy",url.date),DatePart("m",url.date),monthDays)>
  <cfset thisDay = DayOfWeek(thisDate)>
   <a href="?date=#HTMLEditFormat(thisDate)#" id="<cfoutput>#HTMLEditFormat(DateFormat(thisDate,"yymmdd"))#</cfoutput>" class="day"><div class="dayView">
      <div class="outerDay"><cfoutput>#HTMLEditFormat(DayOfWeekAsString(thisDay))#</cfoutput></div>
      <div class="innerDay"><cfoutput>#HTMLEditFormat(Day(thisDate))#</cfoutput></div>
    </div>
 </a>
</cfloop>

<!--- Output trailing days --->
<cfset endMonth = getEnd(url.date)>
</div>
</body>
</html>
