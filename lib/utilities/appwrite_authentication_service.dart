import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'utilities.dart';

class AppwriteAuthenticationService {
  late final Client _client;
  late final Account _account;

  AppwriteAuthenticationService() {
    _client = Client()
      ..setEndpoint(Constants.endPoint) // Your API Endpoint
      ..setProject(Constants.projectId) // Your project ID
      ..setSelfSigned();
    _account = Account(_client);
  }

  Future<Token> createPhoneSession({required String mobileNoWithCountryCode}) {
    try {
      return _account.createPhoneSession(
        userId: ID.unique(),
        phone: mobileNoWithCountryCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> updatePhoneSession(
      {required String userId, required String secret}) {
    try {
      return _account.updatePhoneSession(
        userId: userId,
        secret: secret,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteSession({required String sessionId}) {
    try {
      return _account.deleteSession(sessionId: sessionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> getCurrentSession() {
    try {
      return _account.getSession(sessionId: Constants.current);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> get() {
    try {
      return _account.get();
    } catch (e) {
      rethrow;
    }
  }
}
