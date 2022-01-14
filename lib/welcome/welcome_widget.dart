import 'package:apfp/firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:open_mail_app/open_mail_app.dart';
import '../create_account/create_account_widget.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../log_in_page/log_in_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

void main() {
  //Locking app to portrait orientation.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APFP',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(),
      home: WelcomeWidget(),
    );
  }
}

class WelcomeWidget extends StatefulWidget {
  WelcomeWidget({Key? key}) : super(key: key);

  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
      curve: Curves.easeIn,
      trigger: AnimationTrigger.onPageLoad,
      duration: 300,
      delay: 50,
      fadeIn: true,
    ),
  };

  List<String>? adminEmails = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  Future<FirebaseApp> _initFirebaseApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
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

  SafeArea _routeUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/images/BSU_APFP_logo.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200,
              fit: BoxFit.fitWidth,
            ).animated([animationsMap['imageOnPageLoadAnimation']]),
            _welcomeText(),
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: _contactText(),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
              child: _logInButton(),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: _createAccountButton(),
            )
          ],
        ),
      ),
    );
  }

  Row _showInitializingAppDialog() {
    return new Row(children: [
      CircularProgressIndicator(),
      Container(
          margin: EdgeInsets.only(left: 7), child: Text("Initializing App..."))
    ]);
  }

  Text _welcomeText() {
    return Text(
      'Welcome!',
      style: TextStyle().copyWith(
        fontSize: 48,
      ),
    );
  }

  void getAdminEmails() {
    FireStore.getAdminEmails().then((value) {
      value.docs
        ..forEach((element) {
          adminEmails!.add(element["email"]);
        });
    });
  }

  Text _contactText() {
    return Text.rich(
      TextSpan(
          text: 'This app is intended for members of the Adult Physical' +
              ' Fitness Program at Ball State University.' +
              ' If you do not have an account, you can contact an administrator by ',
          style: FlutterFlowTheme.subtitle1,
          children: <InlineSpan>[
            TextSpan(
                text: '\nclicking here.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.secondaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    EmailContent email = EmailContent(
                        to: adminEmails,
                        subject: 'APFP Membership',
                        body: 'Hello, how can I become a member?');
                    OpenMailAppResult result =
                        await OpenMailApp.composeNewEmailInMailApp(
                            nativePickerTitle: 'Select an email app to compose',
                            emailContent: email);

                    // If no mail apps found, show error
                    if (!result.didOpen && !result.canOpen) {
                      showNoMailAppsDialog(context);

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
    );
  }

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
        width: 170,
        height: 50,
        color: Color(0xFFBA0C2F),
        textStyle: FlutterFlowTheme.title2,
        elevation: 2,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: 12,
      ),
    );
  }

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
        width: 250,
        height: 50,
        color: Colors.white,
        textStyle: TextStyle()
            .copyWith(fontSize: 24, color: FlutterFlowTheme.primaryColor),
        elevation: 2,
        borderSide: BorderSide(
          color: FlutterFlowTheme.secondaryColor,
          width: 3,
        ),
        borderRadius: 12,
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _initFirebaseApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              getAdminEmails();
              return _routeUI();
            }
            return Center(child: _showInitializingAppDialog());
          }),
    );
  }
}
