// Copyright 2022 The myAPFP Authors. All rights reserved.

import '../../provider/theme_provider.dart';
import '/main.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';

import '/util/app_info/app_info.dart';

import '../log_in_page/log_in_page_widget.dart';

import '../create_account/create_account_widget.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_animations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myFit',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.system,
      home: WelcomeWidget(),
    );
  }
}

class WelcomeWidget extends StatefulWidget {
  WelcomeWidget({Key? key}) : super(key: key);

  /// Takes user to Welcome screen.
  static void returnToWelcome(BuildContext context) async {
    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        duration: Duration(milliseconds: 125),
        reverseDuration: Duration(milliseconds: 125),
        child: WelcomeWidget(),
      ),
    );
  }

  /// Only called from the log out button in Settings.
  ///
  /// After logging out, the user is taken to Welcome without
  /// a [PageTransition] effect.
  static void logOutToWelcome(BuildContext context) async {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeWidget(),
      ),
      (r) => false,
    );
  }

  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  /// Map to be used in page load animations.
  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
      curve: Curves.easeIn,
      trigger: AnimationTrigger.onPageLoad,
      duration: 1,
      delay: 50,
      fadeIn: true,
    ),
  };

  late bool _isLightTheme;
  late Color _textColor;

  /// Serves as key for the [Scaffold] found in [build].
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    AppInfo.init();
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  /// Initializes FirebaseApp and sends the user to Home if
  /// their email has been verified.
  Future<FirebaseApp> _initFirebaseApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    if (await isUserEmailVerified()) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NavBarPage(initialPage: 0),
        ),
        (r) => false,
      );
    }
    return firebaseApp;
  }

  /// Returns bool indicating email verification status.
  Future<bool> isUserEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    user!.reload().then((_) => user.getIdToken(true));
    return user.emailVerified;
  }

  /// Returns APFP logo.
  Widget _apfpLogo() {
    return Image.asset(
      'assets/images/running_logo_2.png',
      width: 100,
      height: 100,
      fit: BoxFit.fitWidth,
    ).animated([animationsMap['imageOnPageLoadAnimation']]);
  }

  /// Returns a row containing a loading message and [CircularProgressIndicator].
  ///
  /// This is displayed while the FirebaseApp initializes upon startup.
  Row _loadingSplash() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Loading myFit...",
                  style: TextStyle(fontSize: 20, color: _textColor)),
              SizedBox(height: 50),
              CircularProgressIndicator(),
            ])
      ],
    );
  }

  /// Animated 'Welcome' text.
  SizedBox _welcomeAnimated() {
    List<Color> colorizeColors = _isLightTheme
        ? [
            FlutterFlowTheme.primaryColor,
            FlutterFlowTheme.secondaryColor,
            FlutterFlowTheme.tertiaryColor
          ]
        : [
            FlutterFlowTheme.tertiaryColor,
            FlutterFlowTheme.secondaryColor,
            FlutterFlowTheme.tertiaryColor
          ];
    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Open Sans',
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText('Welcome!',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
              textAlign: TextAlign.center),
        ],
        isRepeatingAnimation: false,
      ),
    );
  }

  /// Text shown detailing how to contact an APFP admin.
  Padding _contactAdminText() {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        child: AutoSizeText.rich(
          TextSpan(
              text: 'This app is intended for anyone who wants a bit of fitness in their lives.' +
                  ' If you would like to do so, you can contact a developer by ',
              style: FlutterFlowTheme.subtitle1(_textColor),
              children: <InlineSpan>[
                TextSpan(
                    text: '\nclicking here.',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isLightTheme
                            ? FlutterFlowTheme.secondaryColor
                            : Colors.lightBlue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        EmailContent email = EmailContent(
                            to: ["thaballa79@gmail.com"],
                            subject: 'myFit',
                            body: 'Hello, ');
                        OpenMailAppResult result =
                            await OpenMailApp.composeNewEmailInMailApp(
                                nativePickerTitle:
                                    'Select an email app to compose',
                                emailContent: email);

                        // If no mail apps found, show error
                        if (!result.didOpen && !result.canOpen) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Open Mail App"),
                                content: Text("No mail apps installed"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );

                          // iOS: if multiple mail apps found, show dialog to select.
                          // There is no native intent/default app system in iOS so
                          // you have to do it yourself.
                        } else if (!result.didOpen && result.canOpen) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return MailAppPickerDialog(
                                mailApps: result.options,
                              );
                            },
                          );
                        }
                      })
              ]),
          textAlign: TextAlign.center,
          maxLines: 6,
        ));
  }

  /// Sends user to the login screen when pressed.
  FFButtonWidget _logInButton() {
    return FFButtonWidget(
      key: Key("Welcome.loginButton"),
      onPressed: () async {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LogInPageWidget(),
          ),
          (r) => false,
        );
      },
      text: 'Log In',
      options: FFButtonOptions(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 50,
        color: Color(0xFFBA0C2F),
        textStyle: FlutterFlowTheme.title2,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: 12,
      ),
    );
  }

  /// Sends user to the create account screen when pressed.
  FFButtonWidget _createAccountButton() {
    return FFButtonWidget(
      key: Key("Welcome.createAcctButton"),
      onPressed: () async {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAccountWidget(),
          ),
          (r) => false,
        );
      },
      text: 'Create Account',
      options: FFButtonOptions(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 50,
        color: Colors.white,
        textStyle: FlutterFlowTheme.title2,
        borderSide: BorderSide(
          color: FlutterFlowTheme.secondaryColor,
          width: 3,
        ),
        borderRadius: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isLightTheme =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    _textColor = _isLightTheme ? Colors.black : Colors.white;
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder(
          future: _initFirebaseApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _apfpLogo(),
                    _welcomeAnimated(),
                    _contactAdminText(),
                    _logInButton(),
                    _createAccountButton(),
                    Text(
                        "${AppInfo.name} | v${AppInfo.version} ${kDebugMode ? "- debug" : ""}",
                        style: FlutterFlowTheme.bodyText1(_textColor))
                  ],
                ),
              );
            }
            return Center(child: _loadingSplash());
          }),
    );
  }
}
