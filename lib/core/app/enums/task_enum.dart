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
