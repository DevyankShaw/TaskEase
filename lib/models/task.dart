import '../utilities/utilities.dart';

class Task {
  final String taskId;
  final String taskName;
  final TaskStatus taskStatus;
  final DateTime createdAt;
  final String createdBy;
  final String? remarks;
  final bool? isImportant;
  final DateTime? deadline;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskStatus,
    required this.createdAt,
    required this.createdBy,
    this.remarks,
    this.isImportant,
    this.deadline,
  });
}
