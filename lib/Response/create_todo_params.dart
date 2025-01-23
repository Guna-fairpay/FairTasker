
class CreateTodoParams{
String? todoTitle = '';
String? todoDate = '';
String? todoTime = '';
String? priority = '';
List<int?>? assignedTo = [];
int? selectedUserId;
int? checklistId;
int? categoryId;
int? checkboxValue;
int? configId;
String? taskName = '';
List<int?>? selectedUserGroupId = [];
String? cohortId = '';
String? cohortName = '';
String? vehicleName = '';
int? vehicleStatusId = 0;
int? vehicleStatus = 0;
String? vehicleImage = '';
int? vehicleStatusChecklist;
int? vehicleStatusCategory;
String? customTask = '';
List<Map<String, dynamic>> partList = [];
List<Map<String, dynamic>> supplyList = [];
String? vin = '';
// 'repeatPeriod', eg : daily,weekly,monthly,yearly
String? repeatPeriod = "Doesn't repeat";
  // repeatDay eg:1,2,3 for repeatPeriod = daily
String? repeatDay = '';
  // repeatWeek eg:1,2,3 for repeatPeriod = weekly
String? repeatWeek = '';
  // weekDay eg:["monday","tuesday","wednesday","thursday","friday"] for repeatPeriod =weekly
List<String>? weekDay = [];
  // recur_monthly_type eg:true or false if true required repeatDateMonth, false required repeatMonth and repeatDayMonth for repeatPeriod = monthly
String? recurMonthlyType = '';
  // repeatDateMonth date from 1 to 31 for repeatPeriod = monthly
String? repeatDateMonth = '';
  // repeatMonth eg: first or last for repeatPeriod = monthly
  String? repeatMonth = '';
  // repeatDayMonth eg:monday,tuesday,wednesday… for repeatPeriod = monthly
  String? repeatDayMonth = '';
  // repeatDateYear date from 1 to 31 for repeatPeriod = yearly
  String? repeatDateYear = '';
  // repeatMonthYear eg:January,February… for repeatPeriod = yearly
  String? repeatMonthYear = '';
  // end_type eg:true or false if true required end_at , false => end_after
  String? endType = '';
  // end_at eg:date = 2023-10-06
  String? endAt = '';
  // end_after eg:1,2,3…
  String? endAfter = '';
  String? todoReminder='';
String? userId = '';
List<int>? multipleAddressList;
int? existingUserGroupId;
int? timeSensitive;
String? person = '';
String? personId = '';
String? vendorId = '';
String? vendorName = '';
String? location = '';
String? locationId = '';
String? notes = '';
String? vehicleGroupId = '';
String? vehicleGroupVinNumbers = '';
String? vehicleGroupName = '';
List<VehicleTodoParam>? vehicleTodoParamList = [];

CreateTodoParams({
  this.userId,
  this.todoTitle,
  this.todoDate,
  this.todoTime,
  this.priority,
  this.assignedTo,
  this.cohortId,
  this.cohortName,
  this.vehicleName,
  this.vin,
  this.repeatPeriod,
  this.repeatDay,
  this.repeatWeek,
  this.weekDay,
  this.recurMonthlyType,
  this.repeatDateMonth,
  this.repeatMonth,
  this.repeatDayMonth,
  this.repeatDateYear,
  this.repeatMonthYear,
  this.endType,
  this.endAt,
  this.endAfter,
  this.vehicleGroupVinNumbers,
  this.checklistId,
  this.categoryId,
  this.checkboxValue,
  this.configId,
  this.taskName,
  this.vehicleStatus,
  this.timeSensitive,
  this.vehicleStatusCategory,
  this.vehicleImage,
  this.vehicleTodoParamList
});
}

class DaysPojo{
  String? dayName = "";
  bool? selected = false;
  DaysPojo({this.dayName, this.selected});
}

class MonthsPojo{
  String? monthName = "";
  bool? selected = false;
  MonthsPojo({this.monthName, this.selected});
}
/*"cohort_id":3,"cohort_name":"Share Car","vin":"5YJ3E1EA0JF152479",
"vehicle_name":"2018 TESLA Model 3","vehicle_image":"","vehicle_number":null*/
class VehicleTodoParam{
  int? cohortId = 0;
  String? cohortName = "";
  String? vin = "";
  String? vehicleName = "";
  String? vehicleNumber = "";
  VehicleTodoParam({this.cohortId, this.cohortName, this.vin, this.vehicleName, this.vehicleNumber});

  Map<String, dynamic> toJson() {
    return {
      'cohort_id': cohortId,
      'cohort_name': cohortName,
      'vin': vin,
      'vehicle_name': vehicleName,
      'vehicle_number': vehicleNumber,
    };
  }

  List<Map<String, dynamic>> vehicleTodoParamListToJson(List<VehicleTodoParam> vehicleTodoParamList) {
    return vehicleTodoParamList.map((vehicleTodoParam) => vehicleTodoParam.toJson()).toList();
  }
}

