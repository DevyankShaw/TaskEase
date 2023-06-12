import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../utilities/utilities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  String? _countryCode;
  bool _generatingOtp = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _mobileNoController.dispose();
    super.dispose();
  }

  _init() async {
    _countryCode = await getCountryPhoneCode();
    setState(() {});
  }

  Future<String> getCountryPhoneCode() async {
    var response = await http.get(Uri.parse('http://ip-api.com/json'));
    var jsonResponse = json.decode(response.body);
    final isoCode = jsonResponse['countryCode'];
    return countryList
        .singleWhere(
          (element) => element.isoCode == isoCode,
          orElse: () => countryList.first,
        )
        .phoneCode;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadAsset(assetName: 'login.png'),
            Row(
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 107, height: 60),
                  child: DropdownButtonFormField<String?>(
                    value: _countryCode,
                    items: countryList.map<DropdownMenuItem<String>>(
                      (country) {
                        return DropdownMenuItem<String>(
                          value: country.phoneCode,
                          child: Text(country.phoneCode),
                        );
                      },
                    ).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _countryCode = value!;
                      });
                    },
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextFormField(
                    controller: _mobileNoController,
                    decoration: const InputDecoration(
                      label: Text('Mobile No'),
                      hintText: 'Enter Mobile No',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Mobile No';
                      } else if (_countryCode == '91' && value.length != 10) {
                        return 'Mobile no is invalid';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _generatingOtp
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: () => _generateOtp(),
                    icon: const Icon(Icons.phonelink_outlined),
                    label: const Text('Get OTP'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 40)),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> _generateOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _generatingOtp = true;
        });

        final mobileNo = _mobileNoController.value.text.trim();

        await _authProvider.generateOtp(
          countryCode: '+$_countryCode',
          mobileNo: mobileNo,
        );
      } catch (error, stackTrace) {
        setState(() {
          _generatingOtp = false;
        });
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

  bool _loggingIn = false;

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            loadAsset(assetName: 'otp.png'),
            TextFormField(
              controller: _mobileOtpController,
              decoration: const InputDecoration(
                label: Text('Mobile OTP'),
                hintText: 'Enter Mobile OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
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
            _loggingIn
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: () => _loginWithOtp(),
                    icon: const Icon(Icons.login_outlined),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 40)),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> _loginWithOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _loggingIn = true;
        });

        final secret = _mobileOtpController.value.text.trim();

        await _authProvider.loginWithOtp(
          secret: secret,
        );
      } catch (error, stackTrace) {
        setState(() {
          _loggingIn = false;
        });
        showErrorMessage(context, message: error.toString());
        debugPrint('Error $error occurred at stackTrace $stackTrace');
      }
    }
  }
}
