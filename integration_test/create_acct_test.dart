import 'package:myfit/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create Account Screen Integration Tests', () {
    testWidgets(
        'Tap on the Create Account button with no input,' +
            'verify each textField displays an warning',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Taps Create Account Button without any input
      var createAcctButton = find.byKey(Key('Create.createAcctButton'));
      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      // Verify each textField displays a no-input warning.
      expect(find.text('Please provide a value'), findsNWidgets(5));
    });

    testWidgets("Enter invalid First Name, receive a warning.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates First Name textFormField with invalid info
      await tester.enterText(
          find.byKey(Key("Create.firstNameTextField")), '7996');
      await tester.pumpAndSettle();

      // Presses "Enter" - hides keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Taps Create Account button, submitting the info entered
      var createAcctButton = find.byKey(Key('Create.createAcctButton'));
      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      // Verify First Name textFormField provides warning
      expect(find.text('Please provide a valid first name'), findsNWidgets(1));
    });

    testWidgets("Enter invalid Last Name, receive a warning.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates Last Name textFormField with invalid info
      await tester.enterText(find.byKey(Key("Create.lastNameTextField")), '7996');
      await tester.pumpAndSettle();

      // Presses "Enter" - hides keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Taps Create Account button, submitting the info entered
      var createAcctButton = find.byKey(Key('Create.createAcctButton'));
      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      // Verify Last Name textFormField provides warning
      expect(find.text('Please provide a valid last name'), findsNWidgets(1));
    });

    testWidgets("Enter invalid Email, receive a warning.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates Email textFormField with invalid info
      await tester.enterText(
          find.byKey(Key("Create.emailTextField")), 'example');
      await tester.pumpAndSettle();

      // Presses "Enter" - hides keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Taps Create Account button, submitting the info entered
      var createAcctButton = find.byKey(Key('Create.createAcctButton'));
      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      // Verify Email textFormField provides warning
      expect(
          find.text('Please provide a valid email address'), findsNWidgets(1));
    });

    testWidgets("Enter invalid password, receive a warning.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates Password textFormField with invalid info
      await tester.enterText(
          find.byKey(Key("Create.passwordTextField")), 'pass');
      await tester.pumpAndSettle();

      // Presses "Enter" - hides keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Taps Create Account button, submitting the info entered
      var createAcctButton = find.byKey(Key('Create.createAcctButton'));
      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      // Verify password textFormField provides warning
      expect(find.text('Please provide a valid password'), findsNWidgets(1));
    });

    testWidgets("Enter non-matching confirmed password, receive a warning.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates Password textFormField with valid info
      await tester.enterText(
          find.byKey(Key('Create.passwordTextField')), 'password12!');
      await tester.pumpAndSettle();

      // Populates ConfirmPassword textFormField with non-matching info
      await tester.enterText(
          find.byKey(Key("Create.confirmPasswordTextField")), 'pass');
      await tester.pumpAndSettle();

      // Presses "Enter" - hides keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Taps Create Account button, submitting the info entered
      var createAcctButton = find.byKey(Key('Create.createAcctButton'));
      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();

      // Verify ConfirmPassword textFormField provides warning
      expect(find.text('Passwords must match'), findsNWidgets(1));
    });

    testWidgets(
        "US: I can enter my name, email address, and passwords through the" +
            "use of text fields.", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates each textFormField with valid info
      await tester.enterText(
          find.byKey(Key("Create.firstNameTextField")), 'John');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("Create.lastNameTextField")), 'Doe');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('Create.emailTextField')), 'example@email.com');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('Create.passwordTextField')), 'password12!');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('Create.confirmPasswordTextField')), 'password12!');
      await tester.pumpAndSettle();

      // Verify each TextFormField validated and accepted each credential
      expect(find.text('Please provide a value'), findsNWidgets(0));
    });

    testWidgets(
        "US: Once my information has been filled out, I am able to press a button" +
            " to submit my information.", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates each textFormField with valid info
      await tester.enterText(
          find.byKey(Key("Create.firstNameTextField")), 'John');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key("Create.lastNameTextField")), 'Doe');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('Create.emailTextField')), 'example@email.com');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('Create.passwordTextField')), 'password12!');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('Create.confirmPasswordTextField')), 'password12!');
      await tester.pumpAndSettle();

      // Hides keyboard by tapping screen
      await tester.tap(find.byKey(Key('Create.confirmPasswordLabel')));
      await tester.pumpAndSettle();

      // Taps Create Account button, submitting the info entered
      var createAcctButton = find.byKey(Key('Create.createAcctButton'));
      await tester.tap(createAcctButton);
      await tester.pumpAndSettle();
    });

    testWidgets(
        "US: I am able to toggle my password visibility using a button.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Launches Create Account Screen from Welcome
      var createAcctButtonWel = find.byKey(Key('Welcome.createAcctButton'));
      await tester.tap(createAcctButtonWel);
      await tester.pumpAndSettle();

      // Populates PW textFormFields with example password
      await tester.enterText(
          find.byKey(Key('Create.passwordTextField')), 'password12!');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(Key('Create.confirmPasswordTextField')), 'password12!');
      await tester.pumpAndSettle();

      // Toggles each password textFormField visibility
      await tester.tap(find.byKey(Key("Create.pWVisibility")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("Create.confirmPWVisibility")));
      await tester.pumpAndSettle();

      // Verify the entered password is shown
      expect(find.text('password12!'), findsNWidgets(2));

      // Verify the visibility icons changes after tap
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));

      // Toggles each password textFormField visibility again
      await tester.tap(find.byKey(Key("Create.pWVisibility")));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("Create.confirmPWVisibility")));
      await tester.pumpAndSettle();

      // Verify the visibility icons changes after tap
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
    });
  });
}
