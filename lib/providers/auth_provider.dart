import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';

import '../utilities/utilities.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  Token? _token;

  User? get currentUser => _currentUser;

  Token? get token => _token;

  late AppwriteAuthenticationService _authService;

  late final _getFutureLoggedInUser = _getLoggedInUser();

  AuthProvider() {
    if (kIsWeb && SharedPreference.instance.containsKey(Constants.userToken)) {
      final userToken =
          SharedPreference.instance.getString(Constants.userToken)!;
      _authService = AppwriteAuthenticationService.web(jwt: userToken);
    } else {
      _authService = AppwriteAuthenticationService();
    }
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
      if (kIsWeb) {
        await SharedPreference.instance.remove(Constants.userToken);
      } else {
        final currentSession = await _authService.getCurrentSession();

        await _authService.deleteSession(
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
      final jsonWebToken = await _authService.createJWT();

      jwt = jsonWebToken.jwt;
    } catch (error, stackTrace) {
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }

    return jwt;
  }

  Future<void> loginWithJWT({required String jwt}) async {
    try {
      _authService = AppwriteAuthenticationService.web(jwt: jwt);

      await _getLoggedInUser();
    } catch (error, stackTrace) {
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }

  Future<bool> isLoggedIn() async {
    await _getFutureLoggedInUser;
    return _currentUser != null;
  }
}
