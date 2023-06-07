import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';

import '../services/services.dart';
import '../utilities/utilities.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  Token? _token;

  User? get currentUser => _currentUser;

  Token? get token => _token;

  late AccountService _accountService;

  late FunctionService _functionService;

  late final _getFutureLoggedInUser = _getLoggedInUser();

  AuthProvider() {
    _initServices();
    _getFutureLoggedInUser;
  }

  _initServices() {
    _accountService = AccountService();
    _functionService = FunctionService();
  }

  Future<void> generateOtp({
    required String countryCode,
    required String mobileNo,
  }) async {
    try {
      final token = await _accountService.createPhoneSession(
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
      await _accountService.updatePhoneSession(
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
      final user = await _accountService.get();

      _currentUser = user;
      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await SharedPreference.instance.remove(Constants.userToken);
      } else {
        final currentSession = await _accountService.getCurrentSession();

        await _accountService.deleteSession(
          sessionId: currentSession.$id,
        );

        _token = null;
      }

      _currentUser = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> generateJWT() async {
    String? jwt;

    try {
      final jsonWebToken = await _accountService.createJWT();

      jwt = jsonWebToken.jwt;
    } catch (error, stackTrace) {
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }

    return jwt;
  }

  Future<void> loginWithJWT({
    required String userToken,
    required String deviceToken,
  }) async {
    try {
      ClientService.init(userToken: userToken);

      _initServices();

      await _getLoggedInUser();

      // Cache userToken/jwt to redirect to home instead of login if user refreshes the browser
      await SharedPreference.instance.setString(Constants.userToken, userToken);

      // Send notification to the logged in mobile
      final data = {
        "messageFor": Constants.mobile,
        "token": deviceToken,
      };

      await _functionService.createExecution(
        functionId: Constants.triggerFcm,
        data: jsonEncode(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendNotificationToWeb({
    required String token,
    required String userToken,
    required String deviceToken,
  }) async {
    try {
      // Send notification to scanned qr web
      final data = {
        "messageFor": Constants.web,
        "token": token,
        "userToken": userToken,
        "deviceToken": deviceToken,
      };

      await _functionService.createExecution(
        functionId: Constants.triggerFcm,
        data: jsonEncode(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    await _getFutureLoggedInUser;
    return _currentUser != null;
  }
}
