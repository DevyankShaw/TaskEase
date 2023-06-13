import '../../utilities/utilities.dart';

class TaskData {
  final String mode;
  final String? documentId;

  TaskData({
    this.mode = Constants.add,
    this.documentId,
  });
}
