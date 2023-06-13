import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../utilities/utilities.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  @JsonSerializable(explicitToJson: true)
  factory Task({
    @JsonKey(name: 'task_name') required String taskName,
    @JsonKey(name: 'task_status') required TaskStatus taskStatus,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'is_important') @Default(false) bool isImportant,
    @JsonKey(name: 'deadline') DateTime? deadline,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
