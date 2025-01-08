
class CreateJobParams{
int? jobId;
String? priority = '';
String? taskName = '';
String? taskDate = '';
String? taskStartTime = '';
String? taskEndTime = '';
String? taskDuration = '';
String? taskDescription = '';
String? taskAssignedTo = '';

CreateJobParams({
  this.jobId,
  this.priority,
  this.taskName,
  this.taskDate,
  this.taskStartTime,
  this.taskEndTime,
  this.taskDuration,
  this.taskDescription,
  this.taskAssignedTo
});
}