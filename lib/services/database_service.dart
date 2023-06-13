import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../utilities/utilities.dart';
import 'services.dart';

class DatabaseService {
  late final Databases _databases;

  DatabaseService() {
    _databases = Databases(ClientService.client);
  }

  Future<Document> createDocument({
    String databaseId = Constants.taskManagement,
    String collectionId = Constants.tasks,
    required String documentId,
    required Map<dynamic, dynamic> data,
  }) {
    try {
      return _databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentList> listDocuments({
    String databaseId = Constants.taskManagement,
    String collectionId = Constants.tasks,
    List<String>? queries,
  }) {
    try {
      return _databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: queries,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Document> getDocument({
    String databaseId = Constants.taskManagement,
    String collectionId = Constants.tasks,
    required String documentId,
    List<String>? queries,
  }) {
    try {
      return _databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        queries: queries,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Document> updateDocument({
    String databaseId = Constants.taskManagement,
    String collectionId = Constants.tasks,
    required String documentId,
    required Map<dynamic, dynamic> data,
  }) {
    try {
      return _databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteDocument({
    String databaseId = Constants.taskManagement,
    String collectionId = Constants.tasks,
    required String documentId,
  }) {
    try {
      return _databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
