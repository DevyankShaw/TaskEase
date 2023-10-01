import 'package:appwrite_hackathon/screens/screens.dart';
import 'package:appwrite_hackathon/utilities/utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appwrite_hackathon/main.dart' as hackathon;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Auth Mobile Test',
    (tester) async {
      await hackathon.main(); // Build our app and trigger a frame.
      await tester
          .pumpAndSettle(); // Finish animations and scheduled microtasks
      await tester.pump(const Duration(seconds: 4)); // Wait some time

      // Find mobile no view widgets
      final imageAssetMobileNo =
          find.byKey(const Key(Constants.imageAsset));
      final countryCodeDropdown =
          find.byKey(const Key(Constants.countryCodeDropdown));
      final mobileNoTextField =
          find.byKey(const Key(Constants.mobileNoTextField));
      final getOtpButton = find.byKey(const Key(Constants.getOtpButton));

      // Verify mobile no view widgets
      expect(imageAssetMobileNo, findsOneWidget);
      expect(countryCodeDropdown, findsOneWidget);
      expect(mobileNoTextField, findsOneWidget);
      expect(getOtpButton, findsOneWidget);

      // Enter mobile no
      await tester.enterText(mobileNoTextField, '9681631530');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      // Tap get otp button
      await tester.tap(getOtpButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 20));

      // Find mobile otp view widgets
      final imageAssetMobileOtp =
          find.byKey(const Key(Constants.imageAsset));
      final mobileOtpTextField =
          find.byKey(const Key(Constants.mobileOtpTextField));
      final submitOtpButton =
          find.byKey(const Key(Constants.submitOtpButton));
      final allowButton = find.text(Constants.allow);

      // Verify mobile otp view widgets
      expect(imageAssetMobileOtp, findsOneWidget);
      expect(mobileOtpTextField, findsOneWidget);
      expect(submitOtpButton, findsOneWidget);
      expect(allowButton, findsOneWidget);

      // Allow mobile otp
      await tester.tap(allowButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      // Tap submit otp button
      await tester.tap(submitOtpButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(HomeScreen), findsOneWidget);
    },
    timeout: Timeout.none,
  );
}
