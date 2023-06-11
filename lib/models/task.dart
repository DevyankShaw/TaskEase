import '../utilities/utilities.dart';

class Task {
  final String taskId;
  final String taskName;
  final TaskStatus taskStatus;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final String? remarks;
  final List<String>? attachments;
  final bool? isImportant;
  final DateTime? deadline;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskStatus,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.remarks,
    this.attachments,
    this.isImportant,
    this.deadline,
  });
}
