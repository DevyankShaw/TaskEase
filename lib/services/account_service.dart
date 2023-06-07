import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../utilities/utilities.dart';
import 'services.dart';

class AccountService {
  late final Account _account;

  AccountService() {
    _account = Account(ClientService.client);
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

  Future<Jwt> createJWT() {
    try {
      return _account.createJWT();
    } catch (e) {
      rethrow;
    }
  }
}
