import 'package:appwrite_hackathon/main.dart' as app;
import 'package:appwrite_hackathon/screens/home_screen.dart';
import 'package:appwrite_hackathon/utilities/utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'Patrol Auth Mobile Test',
    nativeAutomation: true,
    ($) async {
      await app.main(); // Build our app and trigger a frame.
      await $.pumpAndSettle(); // Finish animations and scheduled microtasks
      await $.pump(const Duration(seconds: 20)); // Wait some time

      // Verify mobile no view widgets
      expect($(const Key(Constants.imageAsset)), findsOneWidget);
      expect($(const Key(Constants.countryCodeDropdown)), findsOneWidget);
      expect($(const Key(Constants.mobileNoTextField)), findsOneWidget);
      expect($(const Key(Constants.getOtpButton)), findsOneWidget);

      // Enter mobile no
      await $.enterText(
          $(const Key(Constants.mobileNoTextField)), '9681631530');

      // Tap get otp button
      await $.tap($(const Key(Constants.getOtpButton)));
      await $.pump(const Duration(seconds: 10)); // Wait some time

      // Verify mobile otp view widgets
      expect($(const Key(Constants.imageAsset)), findsOneWidget);
      expect($(const Key(Constants.mobileOtpTextField)), findsOneWidget);
      expect($(const Key(Constants.submitOtpButton)), findsOneWidget);

      // Allow mobile otp
      await $.native.tap(Selector(text: Constants.allow));

      // Tap submit otp button
      await $.tap($(const Key(Constants.submitOtpButton)));

      expect($(HomeScreen), findsOneWidget);
    },
    timeout: Timeout.none,
  );
}
