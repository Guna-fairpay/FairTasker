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
    {'id': 3, 'label': "Fairental ReservationID"},
    {'id': 2, 'label': "Turo Reservation ID"},
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

  static const List<Map<String, dynamic>> editTodoBottomTaps = [
    {"id" : 1, "title" : "Expense"},
    {"id" : 2, "title" : "Next Task"},
    {"id" : 3, "title" : "Check List"},
    {"id" : 4, "title" : "Maintenance Check"},
    {"id" : 5, "title" : "Set Vehicle"},
  ];

  static const List<Map<String, dynamic>> expenseTo = [
    {"id" : 1, "name" : "FairPy"},
    {"id" : 4, "name" : "Cohort"},
  ];

  static const List<Map<String, dynamic>> expenseTaps = [
    {"id" : 1, "title" : "Vehicle"},
    {"id" : 2, "title" : "Person"},
    {"id" : 3, "title" : "Other"},
    {"id" : 4, "title" : "Bill"},
  ];

  static const List<Map<String, dynamic>> sentiments = [
    {"id" : 1, "name" : "Positive"},
    {"id" : 2, "name" : "Neutral"},
    {"id" : 3, "name" : "Negative"},
  ];

}
