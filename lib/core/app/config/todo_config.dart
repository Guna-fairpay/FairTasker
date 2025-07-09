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

}