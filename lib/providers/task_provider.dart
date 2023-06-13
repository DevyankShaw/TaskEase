import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/services.dart';

class TaskProvider with ChangeNotifier {
  late final AccountService _accountService;

  late final DatabaseService _databaseService;

  TaskProvider() {
    _initServices();
  }

  _initServices() {
    _accountService = AccountService();
    _databaseService = DatabaseService();
  }

  Future<void> addTask({required Task taskData}) async {
    try {
      final currentUser = await _accountService.get();

      final updatedTaskData = taskData.copyWith(createdBy: currentUser.$id);

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

  Future<DocumentList> getAllTaskDocuments() async {
    try {
      final documentList = await _databaseService.listDocuments();

      return documentList;
    } catch (e) {
      rethrow;
    }
  }
}