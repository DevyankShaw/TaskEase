import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/services.dart';
import '../utilities/utilities.dart';

class TaskProvider with ChangeNotifier {
  late final AccountService _accountService;

  late final DatabaseService _databaseService;

  DocumentList? _documentList;

  DocumentList? get documentList => _documentList;

  User? _currentUser;

  late final _getFutureCurrentUser = _getCurrentUser();

  bool _hasReachedMax = false;

  bool get hasReachedMax => _hasReachedMax;

  TaskProvider() {
    _initServices();
    _getFutureCurrentUser;
  }

  _initServices() {
    _accountService = AccountService();
    _databaseService = DatabaseService();
  }

  Future<void> _getCurrentUser() async {
    try {
      _currentUser = await _accountService.get();
    } catch (error, stackTrace) {
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }

  Future<void> addTask({required Task taskData}) async {
    try {
      await _getFutureCurrentUser;

      final updatedTaskData = taskData.copyWith(createdBy: _currentUser!.$id);

      await _databaseService.createDocument(
        documentId: ID.unique(),
        data: updatedTaskData.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask({
    required String documentId,
    required Task taskData,
  }) async {
    try {
      await _databaseService.updateDocument(
        documentId: documentId,
        data: taskData.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask({required String documentId}) async {
    try {
      await _databaseService.deleteDocument(documentId: documentId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllTaskDocuments({bool reset = false}) async {
    try {
      if (reset) {
        // Initial loader will show
        _documentList = null;
        _hasReachedMax = false;
        notifyListeners();
      }

      if (_hasReachedMax) {
        return;
      }

      await _getFutureCurrentUser;

      final queries = [
        Query.equal('created_by', _currentUser!.$id),
        Query.limit(kIsWeb ? 20 : 10),
        Query.offset(_documentList?.documents.length ?? 0),
      ];

      final documentList =
          await _databaseService.listDocuments(queries: queries);

      _documentList = DocumentList(
        total: documentList.total,
        documents: List.of(_documentList?.documents ?? [])
          ..addAll(documentList.documents),
      );
      _hasReachedMax = documentList.documents.isEmpty;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllSearchFilterTaskDocuments({
    String? enteredTaskName,
    List<TaskStatus>? selectedTaskStatus,
  }) async {
    try {
      _documentList = null;
      _hasReachedMax = false;
      notifyListeners();

      await _getFutureCurrentUser;

      final queries = [
        if (enteredTaskName?.isNotEmpty ?? false)
          Query.search('task_name', enteredTaskName!),
        if (selectedTaskStatus?.isNotEmpty ?? false)
          Query.equal(
            'task_status',
            selectedTaskStatus!.map((status) => status.name).toList(),
          ),
        Query.equal('created_by', _currentUser!.$id),
      ];

      final documentList =
          await _databaseService.listDocuments(queries: queries);

      _documentList = documentList;
      _hasReachedMax = documentList.documents.length == documentList.total;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<Task> getTask({required String documentId}) async {
    try {
      final document =
          await _databaseService.getDocument(documentId: documentId);

      return Task.fromJson(document.data);
    } catch (e) {
      rethrow;
    }
  }
}
