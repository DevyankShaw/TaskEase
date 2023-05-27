import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utilities/utilities.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  Token? _token;

  User? get currentUser => _currentUser;

  Token? get token => _token;

  late final AppwriteAuthenticationService _authService;

  late final _getFutureLoggedInUser = _getLoggedInUser();

  AuthProvider() {
    _authService = AppwriteAuthenticationService();
    _getFutureLoggedInUser;
  }

  Future<void> generateOtp({
    required String countryCode,
    required String mobileNo,
  }) async {
    try {
      final token = await _authService.createPhoneSession(
        mobileNoWithCountryCode: '$countryCode$mobileNo',
      );

      _token = token;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithOtp({
    required String secret,
  }) async {
    try {
      await _authService.updatePhoneSession(
        userId: _token?.userId ?? '',
        secret: secret,
      );

      await _getLoggedInUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _getLoggedInUser() async {
    try {
      final user = await _authService.get();

      _currentUser = user;
      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }

  Future<void> logout() async {
    try {
      final currentSession = await _authService.getCurrentSession();

      await _authService.deleteSession(
        sessionId: currentSession.$id,
      );

      _currentUser = null;
      _token = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    await _getFutureLoggedInUser;
    return _currentUser != null;
  }
}
