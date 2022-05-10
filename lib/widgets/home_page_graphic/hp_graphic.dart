// Copyright 2022 The myFit Authors. All rights reserved.

import 'dart:io';

import 'package:myfit/util/platform/device_platform.dart';

import '/flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class HPGraphic {
  /// Creates a container which holds different tabs & views.
  ///
  /// [tabs] are typically a list of two or more widgets which are used as tab buttons.
  ///
  /// [views] are typically a list of two or more widgets which are used as tab views.
  ///
  /// NOTE: The length of [tabs] must match the length of [views].
  static ContainedTabBarView tabbedContainer(
      {required BuildContext context,
      required List<Widget> tabs,
      required List<Widget> views}) {
    return ContainedTabBarView(
      tabs: tabs,
      tabBarProperties: TabBarProperties(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 32,
        background: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.secondaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 0.5,
                blurRadius: 2,
                offset: Offset(1, -1),
              ),
            ],
          ),
        ),
        position: TabBarPosition.top,
        alignment: TabBarAlignment.center,
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
      ),
      views: views,
    );
  }

  /// Creates a view to display a default goal.
  ///
  /// [percent] must be between 0.0 and 1.0.
  ///
  /// If [isHealthAppSynced] is set to false, the goal within view
  /// cannot be set until a user synchronizes a health app to myFit.
  static InkWell createView(
      {required Key key,
      required BuildContext context,
      required String goalProgress,
      required String goalProgressInfo,
      required double percent,
      required Function onLongPress,
      required ScrollController scrollController,
      required bool isHealthAppSynced,
      required bool isGoalSet}) {
    var platformHealthName = DevicePlatform.platformHealthName;
    if (!isHealthAppSynced) {
      goalProgress = "$platformHealthName\nNot Sync'd";
      goalProgressInfo = Platform.isIOS
          ? "Sync your myFit App with\na $platformHealthName to set this goal."
          : "Sync your myFit App with\n$platformHealthName to set this goal.";
      percent = 0;
    } else if (!isGoalSet && isHealthAppSynced) {
      goalProgress = "No\nActive\nGoal";
      goalProgressInfo = "Long Press here to set & edit goals.";
      percent = 0;
    }
    return InkWell(
      key: key,
      onLongPress: () => onLongPress(),
      child: Container(
          child: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 25),
              CircularPercentIndicator(
                radius: MediaQuery.of(context).size.width / 2.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: percent,
                center: new Text(
                  goalProgress,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.square,
                backgroundColor: FlutterFlowTheme.secondaryColor,
                progressColor: Colors.green,
              ),
              SizedBox(height: 25),
              Text(goalProgressInfo, style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      )),
    );
  }
}
