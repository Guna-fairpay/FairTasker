// TYPES OF TASK
enum TaskType { rental, lead, nonRental, meeting }

const List<String> taskTypes = [
  "Rental Task",
  "Lead Task",
  "Non-Rental Task",
  "Meeting"
];

extension TaskTypeExtension on TaskType {
  String get name => switch (this) {
        TaskType.rental => "Rental Task",
        TaskType.lead => "Lead Task",
        TaskType.nonRental => "Non-Rental Task",
        TaskType.meeting => "Meeting"
      };
}

extension TaskTypeExtensionByInt on int {
  String get taskType => switch (this) {
        1 => "Support",
        2 => "Rental",
        3 => "Lead",
        4 => "NonRental",
        5 => "Meeting",
        _ => "Other"
      };
  }
