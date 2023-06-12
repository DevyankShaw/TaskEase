import '../utilities/utilities.dart';
import 'models.dart';

class TaskData {
  final String mode;
  final Task? data;

  TaskData({
    this.mode = Constants.add,
    this.data,
  });
}
