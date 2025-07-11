mixin ToDoConfig {

  static List<int> dropCheckInCarRental = [209, 211];
  static List<int> pickCheckOutCarRental = [210, 212];

  static const List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  static const List<Map<String, dynamic>> customOptions = [
    {'id': 1, 'label': "Custom Link"},
    {'id': 3, 'label': "Fairental ReservationID"},
    {'id': 2, 'label': "Turo Reservation ID"},
  ];

  static const List<Map<String, dynamic>> recurringOptions = [
    {'id': 0, 'label': "Doesn't repeat"},
    {'id': 1, 'label': "Daily"},
    {'id': 2, 'label': "Weekly"},
    {'id': 3, 'label': "Monthly"},
    {'id': 4, 'label': "Yearly"},
  ];

  static const List<Map<String, dynamic>> months = [
    {'month': 'January'},
    {'month': 'February'},
    {'month': 'March'},
    {'month': 'April'},
    {'month': 'May'},
    {'month': 'June'},
    {'month': 'July'},
    {'month': 'August'},
    {'month': 'September'},
    {'month': 'October'},
    {'month': 'November'},
    {'month': 'December'},
  ];

  static const List<Map<String, dynamic>> cleanCarDurations = [
    {"id" : 1, "value" : 60},
    {"id" : 2, "value" : 45},
    {"id" : 3, "value" : 30},
    {"id" : 4, "value" : 15},
  ];

  static const List<Map<String, dynamic>> meetingMode = [
    {'id': 0, 'name': 'Select Mode'},
    {'id': 1, 'name': 'Online'},
    {'id': 2, 'name': 'Person'},
  ];

  static const List<Map<String, dynamic>> meetingDuration = [
    {'id': 0, 'name': 'Select Duration'},
    {'id': 1, 'name': '00:15'},
    {'id': 2, 'name': '00:30'},
    {'id': 3, 'name': '00:45'},
    {'id': 4, 'name': '01:00'},
    {'id': 5, 'name': '01:15'},
    {'id': 6, 'name': '01:30'},
    {'id': 7, 'name': '01:45'},
    {'id': 8, 'name': '02:00'},
    {'id': 9, 'name': '02:15'},
    {'id': 10, 'name': '02:30'},
  ];

  static Map<String, dynamic> defaultMeetingDuration = meetingDuration.firstWhere((element) => element['id'] == 2);

}