class VehicleStatusConfig {

  VehicleStatusConfig._();

  static List<Map<String, dynamic>> tripStatusCategories = [
    {
      "id" : 1,
      "name" : "On a trip",
      "slug" : "on-a-trip",
      "count" : 0
    },
    {
      "id" : 2,
      "name" : "Not on a trip",
      "slug" : "not-on-a-trip",
      "count" : 0
    },
    {
      "id" : 3,
      "name" : "Has upcoming trip",
      "slug" : "has-upcoming-trip",
      "count" : 0
    },
    {
      "id" : 4,
      "name" : "No upcoming trip",
      "slug" : "no-upcoming-trip",
      "count" : 0
    },
    {
      "id" : 5,
      "name" : "Next Day",
      "slug" : "next-day",
      "count" : 0
    },
  ];

}

enum VehicleStatusOnPressed {
  last_checklist,
  vehicle_config,
  vehicle_edit,
  vehicle_details,
  date_pickup,
  view_history,
  view_expense,
  add_vehicle,
  view_notes,
  vehicle_page,
}