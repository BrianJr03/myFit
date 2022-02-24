# myAPFP App
This is a developing application created for members of the Adult Physical Fitness Program at Ball State University. Members will be able to view announcements sent by administrators of the APFP, access at-home exercise videos, and log activity that can be shared with administrators, all in one easy-to-use application. 

At this time, functionality is limited to application navigation, account creation and log-in for approved APFP members, exercise videos dynamically pulled from YouTube, pulling previous announcements from a database, and logging and sharing daily activity. Users that are signed into the app may also receive push notifications from administrators regarding important information sent out by the APFP. Push notifications are currently only functional on Android devices.

## How to Run
This application is in development and may be prone to bugs/issues/crashes. Run application at own risk.
1. Install Flutter SDK and an emulator of your choice (or offload to a physical device. Some features are not yet available on iOS emulators or devices).
2. In your code editor, attach a running emulator or a physical device to the project.
3. Find the root of the project in `lib/main.dart`. Run the main() method, which will run the application on your emulator or device. You can also use `flutter run` in a shell, with additional arguments to customize the configuration.

Instructions for how to install Flutter SDK can be found [here](https://docs.flutter.dev/get-started/install). If you have trouble running the Flutter application, try running the following command in your terminal to download packages: `flutter pub get`. If you run into trouble with your Flutter installation, try running `flutter doctor` to verify that your Flutter SDK is properly installed.

If you have trouble running on an iOS device or emulator, ensure that you have the CocoaPods manager installed, which manages dependencies for Xcode projects. Instructions for how to install can be found [here](https://guides.cocoapods.org/using/getting-started.html). Once CocoaPods is installed, you can install the pods for this project by setting the directory to `ios` and running `pod install`. Other CocoaPods commands can be used for troubleshooting, such as `pod outdated` and `pod update`, but only when the directory is set to `ios`. Ensure that your version of the app has been signed with an Apple account, which can be done through Xcode. A Developer account is not required to run the app, but an account must be used to sign the app.

*Most warnings generated by the application are thrown by packages that are used by external dependencies. Most of these warnings appear in Xcode when running on iOS, but this code is maintained by the publishers of the package and is updated whenever the packages are retrieved. Do not modify.*

## API and SDK Documentation
As a hybrid application, this project uses multiple SDKs and external APIs. Versions and attributions are listed below.

  ### [Flutter](https://flutter.dev/)
  - Flutter is an open source framework by Google for building beautiful, natively compiled, multi-platform applications from a single codebase.
  - Application tested using Flutter SDK version `2.5.3` at time of writing.
  - Flutter is powered by **Dart**, which provides the language and runtimes that power Flutter apps. Application tested using Dart version `2.5.3` at time of writing.

  ### [Firebase](https://firebase.google.com/) and [Firestore](https://firebase.google.com/docs/firestore)
  - Firebase is a Google platform to assist with developing mobile and web applications. It can help to serve as a back end for applications without the requirement of managing servers.
  - Cloud Firestore is a database feature within Firebase. It allows for storage of data in collections for easy retrieval by clients.
  - Versions for all used dependencies:
    - Firebase Core: `1.7.0`
    - Firebase Auth: `3.1.3`
    - Firebase Messaging: `10.0.0`
    - Firebase Analytics: `8.0.2`
    - Cloud Firestore: `2.5.3`

  ### [YouTube Explode Dart](https://pub.dev/packages/youtube_explode_dart)
  - YouTube Explode is an API used to collect data from YouTube and display YouTube players within the application. This Dart package allows us to implement YouTube Explode methods within our application.
  - At the time of its implementation, the YouTube Explode Dart version is `1.10.8`.
  - Information regarding the licensing of this package can be found in the `licenses` directory.


## Code Structure
Below is information regarding code structure, written to give a better understanding of how the app works and what practices were used in the development of this application.
### Widgets and Components: `lib/components` and `lib/widgets`
The .dart files contained within these directories store widgets that are used throughout the application. Widgets are Flutter's way of building parts of an app, and widgets can be combined, modified, and customized to fit a given need in the application. 

Each of the screens in the application is developed as a widget. Widgets contain various core functions, such as **initState()** and **build()** , which initialize and build the widget for use in the application. Custom methods can also be defined within these classes. In our application, each of these classes' methods has one of two purposes: collect backend data/perform backend task, or return a named child widget. Shown below is an example of each of the types of methods in these directories:

An example of a method that *returns an identifiable Flutter widget*:
```
InkWell _goBackToAllVideos() {
    return InkWell(
        onTap: () async {
          _lockPortait();
          Navigator.pop(context);
        },
        child: Text('< Back to All Videos',
            textAlign: TextAlign.start, style: FlutterFlowTheme.subtitle2));
  }
```

An example of a method that *performs backend logic*:
```
Future<void> checkInternetConnection() async {
    if (await Internet.isConnected()) {
      _internetConnected = true;
      Toasted.showToast("Connected to the Internet.");
    } else {
      _internetConnected = false;
      Toasted.showToast("Please connect to the Internet.");
    }
  }
```

All of the files within these two directories follow these conventions. Exploration throughout the files will reveal the purpose of each function and what purpose they serve on that respective page. Classes can also store member variables, which are made use of throughout the application.

### Firebase/Firestore Data Collection
This project uses Firebase/Firestore as a user authorization and database service. Methods for Firebase user authentication are located in `lib/firebase/fire_auth.dart`, while methods related to data in the Firestore database are located in `lib/firebase/firestore.dart`. These classes are implemented in areas throughout the application where Firestore and Firebase are required. 

### Testing
Implemented testing for the application thus far is included in the `test` and `integration_test` directories. At this point in time, there may be a specific configuration that must be reached in the application before some of the tests may succeed. Instructions are embedded in each of the files where additional configuration is required. 

### iOS and Android Configuration Files
The iOS and Android configuration files for this project are located in `ios` and `android` respectively. These directories contain mostly Flutter-generated code that allows the single codebase to be compiled on either the iOS or Android platforms. Some information in these files is specific to this project.

*A note about Firebase/Firestore configuration*: When pulling the code from this repository, the required **GoogleServices-Info.plist** file for iOS and **google-services.json** file for Android Firebase configuration are not included. These files are not tracked due to vulnerabilities created by uploading this file to a public repository. These files must be added to the project in order for the app to run. For Android, **the google-services.json** file can be placed in the `android/app` directory. For iOS, the **GoogleServices-Info.plist** file must be added to the `ios/Runner` directory *through Xcode*. If this file is not added to the project through Xcode, it will not be recognized and the application will not be able to perform Firebase/Firestore functions.

### Assets
All assets for the application are included in this directory.

### Licenses
The `licenses` directory contains information regarding licensing of packages and is growing as the app develops.
