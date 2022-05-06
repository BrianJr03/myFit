// Copyright 2022 The myAPFP Authors. All rights reserved.

import 'dart:async';
import 'dart:io';

import '../../util/platform/device_platform.dart';
import '/firebase/firestore.dart';

import '/util/goals/goal.dart';
import '/util/toasted/toasted.dart';
import '../../util/goals/apfp_goal.dart';
import '/util/health/healthUtil.dart';
import '/util/goals/exercise_time_goal.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import '../set_goals/set_goals_widget.dart';

import '../home_page_graphic/hp_graphic.dart';

import 'package:intl/intl.dart';
import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeWidget extends StatefulWidget {
  /// The user's goal document stream.
  final Stream<DocumentSnapshot<Map<String, dynamic>>> goalStream;

  /// The user's activity document stream.
  final Stream<DocumentSnapshot<Map<String, dynamic>>> activityStream;

  HomeWidget({Key? key, required this.goalStream, required this.activityStream})
      : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  /// Stores a user's activity document snapshots.
  late Map<String, dynamic> _activitySnapshotBackup;

  /// Stores a user's goal document snapshots.
  late Map<String, dynamic> _goalSnapshotBackup;

  /// [ScrollController] for [_apfpGoalsView].
  final _apfpSC = ScrollController();

  /// [ScrollController] for [_calsView].
  final _calViewSC = ScrollController();

  /// [ScrollController] for [_stepsView].
  final _stepsViewSC = ScrollController();

  /// [ScrollController] for [_milesView].
  final _milesViewSC = ScrollController();

  /// [ScrollController] for [_exerciseTimeView].
  final _exerciseTimeViewSC = ScrollController();

  /// Serves as key for the [Scaffold] found in [build].
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Label displayed above the [_goalsTabbedContainer].
  ///
  /// This changes based on which type of goals the user is currently viewing.
  String _goalType = "Daily";

  /// Entrypoint to health API.
  HealthFactory health = HealthFactory();

  /// Indicates if this screen has been disposed of.
  bool _disposed = false;

  bool _isFetchingHealthData = false;

  @override
  void initState() {
    super.initState();
    _fetchHealthData();
    // Refreshes health data every minute
    Timer.periodic(Duration(minutes: 1), (t) {
      _fetchHealthData();
      if (_disposed) {
        t.cancel();
      }
    });
    _listenToGoalStream();
    _listenToActivityStream();
    _checkIfHealthAppSynced();
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
    _apfpSC.dispose();
    _calViewSC.dispose();
    _stepsViewSC.dispose();
    _milesViewSC.dispose();
    _exerciseTimeViewSC.dispose();
  }

  /// This listens to the user's activity document stream.
  ///
  /// Upon any changes to said document, goal progress and the
  /// app's UI is updated accordingly.
  void _listenToActivityStream() {
    widget.activityStream.forEach((element) {
      _activitySnapshotBackup = new Map();
      if (element.data() != null) {
        _activitySnapshotBackup = element.data()!;
      }
      if (mounted) {
        setState(() {
          Goal.userProgressExerciseTime =
              ExerciseGoal.totalTimeInMinutes(_activitySnapshotBackup);
          Goal.userProgressCyclingGoal = APFPGoal.calcGoalSums(
              _activitySnapshotBackup,
              goalType: "Cycling");
          Goal.userProgressRowingGoal = APFPGoal.calcGoalSums(
              _activitySnapshotBackup,
              goalType: "Rowing");
          Goal.userProgressStepMillGoal = APFPGoal.calcGoalSums(
              _activitySnapshotBackup,
              goalType: "Step-Mill");
          Goal.userProgressEllipticalGoal = APFPGoal.calcGoalSums(
              _activitySnapshotBackup,
              goalType: "Elliptical");
          Goal.userProgressResistanceStrengthGoal = APFPGoal.calcGoalSums(
              _activitySnapshotBackup,
              goalType: "Resistance");
          FireStore.updateGoalData({
            "exerciseTimeGoalProgress": Goal.userProgressExerciseTime,
            "calGoalProgress": Goal.userProgressCalGoal,
            "stepGoalProgress": Goal.userProgressStepGoal,
            "mileGoalProgress": Goal.userProgressMileGoal,
            "cyclingGoalProgress": Goal.userProgressCyclingGoal,
            "rowingGoalProgress": Goal.userProgressRowingGoal,
            "stepMillGoalProgress": Goal.userProgressStepMillGoal,
            "ellipticalGoalProgress": Goal.userProgressEllipticalGoal,
            "resistanceStrengthGoalProgress":
                Goal.userProgressResistanceStrengthGoal,
          });
        });
      }
    });
  }

  /// This listens to the user's goal document stream.
  ///
  /// Upon any changes to said document, goal progress and the
  /// app's UI is updated accordingly.
  void _listenToGoalStream() {
    widget.goalStream.forEach((element) {
      _goalSnapshotBackup = new Map();
      if (element.data() != null) {
        _goalSnapshotBackup = element.data()!;
        if (mounted) {
          setState(() {
            _goalType = "Daily";
            Goal.dayOfMonth = _goalSnapshotBackup['dayOfMonth'];
            Goal.isCalGoalSet = _goalSnapshotBackup['isCalGoalSet'];
            Goal.isStepGoalSet = _goalSnapshotBackup['isStepGoalSet'];
            Goal.isMileGoalSet = _goalSnapshotBackup['isMileGoalSet'];
            Goal.isExerciseTimeGoalSet =
                _goalSnapshotBackup['isExerciseTimeGoalSet'];
            Goal.isCyclingGoalSet = _goalSnapshotBackup['isCyclingGoalSet'];
            Goal.isRowingGoalSet = _goalSnapshotBackup['isRowingGoalSet'];
            Goal.isStepMillGoalSet = _goalSnapshotBackup['isStepMillGoalSet'];
            Goal.isEllipticalGoalSet =
                _goalSnapshotBackup['isEllipticalGoalSet'];
            Goal.isResistanceStrengthGoalSet =
                _goalSnapshotBackup['isResistanceStrengthGoalSet'];
            Goal.isHealthAppSynced = _goalSnapshotBackup['isHealthAppSynced'];
            Goal.userCalEndGoal = _goalSnapshotBackup['calEndGoal'].toDouble();
            Goal.userStepEndGoal =
                _goalSnapshotBackup['stepEndGoal'].toDouble();
            Goal.userMileEndGoal =
                _goalSnapshotBackup['mileEndGoal'].toDouble();
            Goal.userExerciseTimeEndGoal =
                _goalSnapshotBackup['exerciseTimeEndGoal'].toDouble();
            Goal.userCyclingEndGoal =
                _goalSnapshotBackup['cyclingEndGoal'].toDouble();
            Goal.userRowingEndGoal =
                _goalSnapshotBackup['rowingEndGoal'].toDouble();
            Goal.userStepMillEndGoal =
                _goalSnapshotBackup['stepMillEndGoal'].toDouble();
            Goal.userEllipticalEndGoal =
                _goalSnapshotBackup['ellipticalEndGoal'].toDouble();
            Goal.userResistanceStrengthEndGoal =
                _goalSnapshotBackup['resistanceStrengthEndGoal'].toDouble();
          });
          Goal.uploadCompletedGoals();
        }
      }
    });
  }

  /// Checks if a user has granted physical activity permissions to myAPFP and
  /// updates the Firestore database accordingly.
  void _checkIfHealthAppSynced() async {
    FireStore.updateGoalData(
        {"isHealthAppSynced": await Permission.activityRecognition.isGranted});
  }

  /// Fetches calories, steps, and miles from the user's health app.
  Future _fetchHealthData() async {
    int steps = 0;
    double cals = 0;
    double miles = 0;
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    List<HealthDataType> dataTypes = [
      HealthDataType.STEPS,
      Platform.isAndroid
          ? HealthDataType.DISTANCE_DELTA // Android
          : HealthDataType.DISTANCE_WALKING_RUNNING, // iOS
    ];
    await HealthFactory.hasPermissions(dataTypes).then((value) async {
      if (value == null || value) {
        if (mounted) {
          setState(() => _isFetchingHealthData = true);
          try {
            List<HealthDataType> calorieTypes = List.empty(growable: true);
            if (Platform.isIOS)
              calorieTypes.add(HealthDataType.BASAL_ENERGY_BURNED);
            calorieTypes.add(HealthDataType.ACTIVE_ENERGY_BURNED);
            var calData = await health.getHealthDataFromTypes(
                midnight, now, calorieTypes);
            var calSet = calData.toSet();
            cals = HealthUtil.getHealthSums(calSet);
            var mileData = await health.getHealthDataFromTypes(midnight, now, [
              Platform.isAndroid
                  ? HealthDataType.DISTANCE_DELTA // Android
                  : HealthDataType.DISTANCE_WALKING_RUNNING, // iOS
            ]);
            var mileSet = mileData.toSet();
            miles = double.parse((HealthUtil.getHealthSums(mileSet) / 1609.344)
                .toStringAsFixed(2));
            await health.getTotalStepsInInterval(midnight, now).then(
                (value) => {if (value != null) steps = value else steps = 0});
          } catch (error) {
            print("Home._fetchHealthData() error: $error");
          }
          setState(() {
            Goal.userProgressCalGoal = cals;
            Goal.userProgressStepGoal = steps.toDouble();
            Goal.userProgressMileGoal = miles;
            _isFetchingHealthData = false;
          });
          FireStore.updateGoalData({
            "calGoalProgress": Goal.userProgressCalGoal,
            "stepGoalProgress": Goal.userProgressStepGoal,
            "mileGoalProgress": Goal.userProgressMileGoal,
          });
        }
      }
    });
  }

  /// Label used above the [_recentAnnouncementGrid].
  Padding _recentAnnouncementsLabel() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            height: MediaQuery.of(context).size.height * 0.06,
            child: AutoSizeText(
              'My Daily Stats',
              style: FlutterFlowTheme.title1,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          )
        ],
      ),
    );
  }

  /// Creates text to be displayed in the [_recentAnnouncementGrid].
  Column _announcementText(String text) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: AutoSizeText(
              text,
              key: Key("Home.announcementText"),
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.bodyText1(Colors.white),
            )),
      ],
    );
  }

  /// Creates a urgent info (!) icon to be displayed next to an
  /// [_announcementText].
  Column _statsContainerIcon(IconData iconData) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsetsDirectional.all(3),
              child: Icon(
                iconData,
                key: Key("Home.infoIcon"),
                color: FlutterFlowTheme.secondaryColor,
                size: 22,
              ))
        ]);
  }

  /// Creates a row that includes an [_statsContainerIcon] and [_announcementText].
  Row _announcementRow(IconData iconData, String text) {
    return Row(
      children: [_statsContainerIcon(iconData), _announcementText(text)],
    );
  }

  Row _syncHealthAppWarning(String dataType) {
    return Row(
      children: [
        _statsContainerIcon(Icons.error),
        AutoSizeText(
          "Sync ${DevicePlatform.platformHealthName} to see $dataType",
          key: Key("Home.announcementText"),
          overflow: TextOverflow.ellipsis,
          style: FlutterFlowTheme.bodyText1(Colors.white),
        ),
      ],
    );
  }

  /// Creates GridView to display recent announcements.
  GridView _recentAnnouncementGrid() {
    var formatter = NumberFormat("###,###", "en_US");
    var time = Goal.userProgressExerciseTime;
    var cals = formatter.format(Goal.userProgressCalGoal);
    var steps = formatter.format(Goal.userProgressStepGoal);
    var miles = Goal.userProgressMileGoal;
    return GridView(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 10,
      ),
      shrinkWrap: true,
      children: [
        _announcementRow(Icons.analytics, "Activity Minutes: $time"),
        Goal.isHealthAppSynced
            ? _announcementRow(Icons.analytics, "Cals Burned: $cals")
            : _syncHealthAppWarning("cals"),
        Goal.isHealthAppSynced
            ? _announcementRow(Icons.analytics, "Steps Taken: $steps")
            : _syncHealthAppWarning("steps"),
        Goal.isHealthAppSynced
            ? _announcementRow(Icons.analytics, "Miles Traveled: $miles")
            : _syncHealthAppWarning("miles")
      ],
    );
  }

  /// Wraps the [_recentAnnouncementGrid], and provides border decoration.
  Container _announcements() {
    return Container(
      key: Key('Home.announcements'),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFBDBDBD),
          width: 2,
        ),
      ),
      child: _recentAnnouncementGrid(),
    );
  }

  /// Label used above [_goalsTabbedContainer].
  Padding _goalTypeLabel() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          MediaQuery.of(context).size.width * 0.04,
          MediaQuery.of(context).size.height * 0.03,
          0,
          0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          AutoSizeText('My $_goalType Goals', style: FlutterFlowTheme.title1),
        ],
      ),
    );
  }

  /// Refreshes health data shown in the health data carousel.
  FFButtonWidget _refreshHealthData() {
    return FFButtonWidget(
      key: Key("Home.refreshHealthData"),
      onPressed: () => _fetchHealthData(),
      text: 'Refresh ${DevicePlatform.platformHealthName} Data',
      options: FFButtonOptions(
        width: MediaQuery.of(context).size.height * 0.4,
        height: 45,
        color: FlutterFlowTheme.secondaryColor,
        textStyle: FlutterFlowTheme.title2,
        borderSide: BorderSide(
          color: FlutterFlowTheme.secondaryColor,
        ),
        borderRadius: 8,
      ),
    );
  }

  /// The view displayed in the 'Time' tab of the [_goalsTabbedContainer].
  InkWell _exerciseTimeView() {
    return HPGraphic.createView(
        key: Key("Home.exerciseView"),
        isGoalSet: (Goal.isExerciseTimeGoalSet),
        isHealthAppSynced: true,
        scrollController: _exerciseTimeViewSC,
        onLongPress: () {
          SetGoalsWidget.launch(context);
        },
        context: context,
        goalProgress:
            "${Goal.isExerciseTimeGoalSet ? Goal.userProgressExerciseTime.toStringAsFixed(0) : 0.toStringAsFixed(0)}\n${progressDelimiter(Goal.userProgressExerciseTime.toStringAsFixed(0))}\n${Goal.userExerciseTimeEndGoal.toStringAsFixed(0)}",
        goalProgressInfo: Goal.isExerciseTimeGoalSet
            ? "Your goal is " +
                "${((Goal.userProgressExerciseTime / Goal.userExerciseTimeEndGoal) * 100) > 100 ? 100 : ((Goal.userProgressExerciseTime / Goal.userExerciseTimeEndGoal) * 100).toStringAsFixed(0)}" +
                "% complete."
            : "Goal not active.",
        percent:
            (Goal.userProgressExerciseTime / Goal.userExerciseTimeEndGoal) > 1.0
                ? 1.0
                : Goal.userProgressExerciseTime / Goal.userExerciseTimeEndGoal);
  }

  /// The view displayed in the 'Calories' tab of the [_goalsTabbedContainer].
  InkWell _calsView() {
    return HPGraphic.createView(
        key: Key("Home.calView"),
        isGoalSet: (Goal.isCalGoalSet),
        isHealthAppSynced: Goal.isHealthAppSynced,
        scrollController: _calViewSC,
        onLongPress: () {
          if (Goal.isHealthAppSynced) {
            SetGoalsWidget.launch(context);
          } else
            Toasted.showToast(
                "Please sync your ${DevicePlatform.platformHealthName} to continue.");
        },
        context: context,
        goalProgress:
            "${Goal.isCalGoalSet ? Goal.userProgressCalGoal.toStringAsFixed(0) : 0.toStringAsFixed(0)}\n${progressDelimiter(Goal.userProgressCalGoal.toStringAsFixed(0))}\n${Goal.userCalEndGoal.toStringAsFixed(0)}",
        goalProgressInfo: Goal.isCalGoalSet
            ? "Your goal is " +
                "${((Goal.userProgressCalGoal / Goal.userCalEndGoal) * 100) > 100 ? 100 : ((Goal.userProgressCalGoal / Goal.userCalEndGoal) * 100).toStringAsFixed(0)}" +
                "% complete."
            : "Goal not active.",
        percent: (Goal.userProgressCalGoal / Goal.userCalEndGoal) > 1.0
            ? 1.0
            : Goal.userProgressCalGoal / Goal.userCalEndGoal);
  }

  /// The view displayed in the 'Steps' tab of the [_goalsTabbedContainer].
  InkWell _stepsView() {
    return HPGraphic.createView(
        key: Key("Home.stepsView"),
        isGoalSet: (Goal.isStepGoalSet),
        isHealthAppSynced: Goal.isHealthAppSynced,
        scrollController: _stepsViewSC,
        onLongPress: () {
          if (Goal.isHealthAppSynced) {
            SetGoalsWidget.launch(context);
          } else
            Toasted.showToast(
                "Please sync your ${DevicePlatform.platformHealthName} to continue.");
        },
        context: context,
        goalProgress:
            "${Goal.isStepGoalSet ? Goal.userProgressStepGoal.toStringAsFixed(0) : 0.toStringAsFixed(0)}\n${progressDelimiter(Goal.userProgressStepGoal.toStringAsFixed(0))}\n${Goal.userStepEndGoal.toStringAsFixed(0)}",
        goalProgressInfo: Goal.isStepGoalSet
            ? "Your goal is " +
                "${((Goal.userProgressStepGoal / Goal.userStepEndGoal) * 100) > 100 ? 100 : ((Goal.userProgressStepGoal / Goal.userStepEndGoal) * 100).toStringAsFixed(0)}" +
                "% complete."
            : "Goal not active.",
        percent: (Goal.userProgressStepGoal / Goal.userStepEndGoal) > 1.0
            ? 1.0
            : Goal.userProgressStepGoal / Goal.userStepEndGoal);
  }

  /// The view displayed in the 'Miles' tab of the [_goalsTabbedContainer].
  InkWell _milesView() {
    return HPGraphic.createView(
        key: Key("Home.mileView"),
        isGoalSet: (Goal.isMileGoalSet),
        isHealthAppSynced: Goal.isHealthAppSynced,
        scrollController: _milesViewSC,
        onLongPress: () {
          if (Goal.isHealthAppSynced) {
            SetGoalsWidget.launch(context);
          } else
            Toasted.showToast(
                "Please sync your ${DevicePlatform.platformHealthName} to continue.");
        },
        context: context,
        goalProgress:
            "${Goal.isMileGoalSet ? Goal.userProgressMileGoal.toStringAsFixed(2) : 0.toStringAsFixed(2)}\n${progressDelimiter(Goal.userProgressMileGoal.toStringAsFixed(0))}\n${Goal.userMileEndGoal.toStringAsFixed(2)}",
        goalProgressInfo: Goal.isMileGoalSet
            ? "Your goal is " +
                "${((Goal.userProgressMileGoal / Goal.userMileEndGoal) * 100) > 100 ? 100 : ((Goal.userProgressMileGoal / Goal.userMileEndGoal) * 100).toStringAsFixed(0)}" +
                "% complete."
            : "Goal not active.",
        percent: (Goal.userProgressMileGoal / Goal.userMileEndGoal) > 1.0
            ? 1.0
            : Goal.userProgressMileGoal / Goal.userMileEndGoal);
  }

  /// Adds a delimiter to separate a user's goal progress and their end goal.
  static String progressDelimiter(String progressStr) {
    String delimiter = "";
    for (int i = 0; i < progressStr.length + 2; i++) {
      delimiter += "-";
    }
    return delimiter;
  }

  /// The tabbed container used with the goals system.
  Padding _goalsTabbedContainer() {
    return Padding(
      key: Key('Home.goalsTabbedContainer'),
      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Color(0xFFBDBDBD),
            width: 2,
          ),
        ),
        child: HPGraphic.tabbedContainer(context: context, tabs: [
          InkWell(key: Key("Home.timeTab"), child: Text('Time')),
          InkWell(key: Key("Home.calsTab"), child: Text('Calories')),
          InkWell(key: Key("Home.stepsTab"), child: Text('Steps')),
          InkWell(key: Key("Home.milesTab"), child: Text('Miles')),
        ], views: [
          _exerciseTimeView(),
          _calsView(),
          _stepsView(),
          _milesView(),
        ]),
      ),
    );
  }

  /// Creates button that allows user to sync a health app to myAPFP.
  FFButtonWidget _syncHealthAppButton() {
    return FFButtonWidget(
      key: Key("Home.syncHealthAppButton"),
      onPressed: () async {
        if (Platform.isAndroid &&
            await Permission.activityRecognition.isGranted) {
          FireStore.updateGoalData({"isHealthAppSynced": true});
          _fetchHealthData();
          Toasted.showToast(
              "${DevicePlatform.platformHealthName} has been synchronized!");
        } else if (Platform.isIOS &&
            await HealthFactory().getHealthDataFromTypes(
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                DateTime.now(),
                [
                  HealthDataType.WORKOUT,
                  HealthDataType.STEPS,
                  HealthDataType.DISTANCE_WALKING_RUNNING,
                  HealthDataType.ACTIVE_ENERGY_BURNED
                ]).then((value) {
              if (value.isEmpty) {
                Toasted.showToast("No relevant activity logged");
                return false;
              } else {
                return true;
              }
            })) {
          FireStore.updateGoalData({"isHealthAppSynced": true});
          _fetchHealthData();
          Toasted.showToast(
              "${DevicePlatform.platformHealthName} has been synchronized!");
        } else {
          Toasted.showToast(
              "Visit Activity tab to sync ${DevicePlatform.platformHealthName}");
        }
      },
      text: 'Sync ${DevicePlatform.platformHealthName}',
      options: FFButtonOptions(
        width: MediaQuery.of(context).size.height * 0.4,
        height: 45,
        color: FlutterFlowTheme.secondaryColor,
        textStyle: FlutterFlowTheme.title2,
        borderSide: BorderSide(
          color: FlutterFlowTheme.secondaryColor,
        ),
        borderRadius: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _recentAnnouncementsLabel(),
            _announcements(),
            _goalTypeLabel(),
            _goalsTabbedContainer(),
            SizedBox(height: 20),
            !_isFetchingHealthData && Goal.isHealthAppSynced
                ? _refreshHealthData()
                : _isFetchingHealthData && Goal.isHealthAppSynced
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      )
                    : _syncHealthAppButton(),
            SizedBox(height: 10)
          ],
        ),
      )),
    );
  }
}
