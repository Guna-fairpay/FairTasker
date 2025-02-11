class AddToDoConfig {
  AddToDoConfig._();

  static const List<String> priorities = [
    'High - On Time',
    'Medium',
    'Low',
    'Feature'
  ];

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
    {'id': 2, 'label': "Turo Reservation ID"},
    {'id': 3, 'label': "Getaround ReservationID"}
  ];

  static const List<Map<String, dynamic>> recurringOptions = [
    {'id': 1, 'label': "Doesn't repeat"},
    {'id': 2, 'label': "Daily"},
    {'id': 3, 'label': "Weekly"},
    {'id': 4, 'label': "Monthly"},
    {'id': 1, 'label': "Yearly"},
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
}
