// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Task _$$_TaskFromJson(Map<String, dynamic> json) => _$_Task(
      taskId: json['task_id'] as String,
      taskName: json['task_name'] as String,
      taskStatus: $enumDecode(_$TaskStatusEnumMap, json['task_status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
      remarks: json['remarks'] as String?,
      isImportant: json['is_important'] as bool? ?? false,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
    );

Map<String, dynamic> _$$_TaskToJson(_$_Task instance) => <String, dynamic>{
      'task_id': instance.taskId,
      'task_name': instance.taskName,
      'task_status': _$TaskStatusEnumMap[instance.taskStatus]!,
      'created_at': instance.createdAt.toIso8601String(),
      'created_by': instance.createdBy,
      'remarks': instance.remarks,
      'is_important': instance.isImportant,
      'deadline': instance.deadline?.toIso8601String(),
    };

const _$TaskStatusEnumMap = {
  TaskStatus.notStarted: 'notStarted',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.underReview: 'underReview',
  TaskStatus.completed: 'completed',
};
