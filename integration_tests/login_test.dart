import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:apfp/welcome/welcome_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // TODO: Complete user story once screen is implemented:
  // US: If I have forgotten my password, there is a button
  // I can press to take me through the password reset process.

  group('Login Screen Integration Tests', () {
    testWidgets(
        "US: I can enter my email address and password through text fields." +
            "These fields are labeled.", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Login Screen from Welcome
      var loginButton_wel = find.byKey(Key('Welcome.loginButton'));
      await tester.tap(loginButton_wel);
      await tester.pumpAndSettle();

      // Populates each textformfield with valid info
      await tester.enterText(find.byKey(Key("Login.emailTextField")), 'John');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("Login.passwordTextField")), 'Doe');
      await tester.pumpAndSettle();

      // Verify each textfield holds user input
      expect(find.text('John'), findsNWidgets(1));
      expect(find.text('Doe'), findsNWidgets(1));
    });

    testWidgets("US: I can toggle my password visibility through a button.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Login Screen from Welcome
      var loginButton_wel = find.byKey(Key('Welcome.loginButton'));
      await tester.tap(loginButton_wel);
      await tester.pumpAndSettle();

      // Populates password textformfield with valid password
      await tester.enterText(
          find.byKey(Key("Login.passwordTextField")), 'password12!');
      await tester.pumpAndSettle();

      // Toggles password textfieldform visibility
      await tester.tap(find.byKey(Key("Login.passwordVisibiltyIcon")));
      await tester.pumpAndSettle();

      // Verify password textfield input is visible
      expect(find.text('password12!'), findsNWidgets(1));

      // Toggles password textfieldform visibility again
      await tester.tap(find.byKey(Key("Login.passwordVisibiltyIcon")));
      await tester.pumpAndSettle();
    });

    testWidgets(
        "US: Once my information has been entered, I can press a button" +
            "to attempt to log in.", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Login Screen from Welcome
      var loginButton_wel = find.byKey(Key('Welcome.loginButton'));
      await tester.tap(loginButton_wel);
      await tester.pumpAndSettle();

      // Populates each textformfield with valid info
      await tester.enterText(
          find.byKey(Key("Login.emailTextField")), 'example@email.com');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("Login.passwordTextField")), 'password12!');
      await tester.pumpAndSettle();

      // Taps Login button
      var loginButton = find.byKey(Key('Login.loginInButton'));
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    });
  });
}
