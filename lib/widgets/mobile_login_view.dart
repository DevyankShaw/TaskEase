import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../utilities/utilities.dart';

class MobileLoginView extends StatelessWidget {
  const MobileLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Selector<AuthProvider, Token?>(
            selector: (_, authProvider) => authProvider.token,
            builder: (_, token, __) {
              return token != null
                  ? const InputMobileOtpView()
                  : const InputMobileNoView();
            },
          ),
        ),
      ),
    );
  }
}

class InputMobileNoView extends StatefulWidget {
  const InputMobileNoView({super.key});

  @override
  State<InputMobileNoView> createState() => _InputMobileNoViewState();
}

class _InputMobileNoViewState extends State<InputMobileNoView> {
  late final _mobileNoController = TextEditingController();

  late final _formKey = GlobalKey<FormState>();
  late final _authProvider = context.read<AuthProvider>();

  @override
  void dispose() {
    _mobileNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _mobileNoController,
            decoration: const InputDecoration(
              label: Text('Mobile No'),
              hintText: 'Enter Mobile No',
              prefixText: '+91',
            ),
            maxLength: 10,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Mobile No';
              } else if (value.length != 10) {
                return 'Mobile no is invalid';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _generateOtp(),
            icon: const Icon(Icons.phonelink_outlined),
            label: const Text('Log In'),
          )
        ],
      ),
    );
  }

  Future<void> _generateOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final mobileNo = _mobileNoController.value.text.trim();

        await _authProvider.generateOtp(
          countryCode: '+91',
          mobileNo: mobileNo,
        );
      } catch (error, stackTrace) {
        showErrorMessage(context, message: error.toString());
        debugPrint('Error $error occurred at stackTrace $stackTrace');
      }
    }
  }
}

class InputMobileOtpView extends StatefulWidget {
  const InputMobileOtpView({super.key});

  @override
  State<InputMobileOtpView> createState() => _InputMobileOtpViewState();
}

class _InputMobileOtpViewState extends State<InputMobileOtpView> {
  late final _mobileOtpController = TextEditingController();

  late final _formKey = GlobalKey<FormState>();
  late final _authProvider = context.read<AuthProvider>();

  @override
  void dispose() {
    _mobileOtpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _mobileOtpController,
            decoration: const InputDecoration(
              label: Text('Mobile OTP'),
              hintText: 'Enter Mobile OTP',
            ),
            maxLength: 6,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Mobile OTP';
              } else if (value.length != 6) {
                return 'Mobile otp is invalid';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _loginWithOtp(),
            icon: const Icon(Icons.login_outlined),
            label: const Text('Submit'),
          )
        ],
      ),
    );
  }

  Future<void> _loginWithOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final secret = _mobileOtpController.value.text.trim();

        await _authProvider.loginWithOtp(
          secret: secret,
        );
      } catch (error, stackTrace) {
        showErrorMessage(context, message: error.toString());
        debugPrint('Error $error occurred at stackTrace $stackTrace');
      }
    }
  }
}
