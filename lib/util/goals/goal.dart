// Copyright 2022 The myFit Authors. All rights reserved.

import '/firebase/firestore.dart';
import '/service/notification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Goal {
  /// Stores a [DateTime] instance with current date and time in the local time zone.
  static final _now = DateTime.now();

  /// Stores current day number.
  ///
  /// Example:
  /// - Date: 3/23/2022
  /// - dayOfMonth = 23
  static int dayOfMonth = 0;

  /// Indicates if the user has synchronized a health app to myFit.
  static bool isHealthAppSynced = false;

  /// Stores a user's current daily goal progress for exercise time.
  static double userProgressExerciseTime = 0;

  /// Stores a user's current daily end goal for exercise time.
  static double userExerciseTimeEndGoal = 0;

  /// Indicates if the user has set an exercise time daily goal.
  static bool isExerciseTimeGoalSet = false;

  /// Indicates if the user has completed their daily exercise time goal.
  static bool isExerciseTimeGoalComplete = false;

  /// Stores a user's current daily goal progress for calories burned.
  static double userProgressCalGoal = 0;

  /// Stores a user's current daily end goal for calories burned.
  static double userCalEndGoal = 0;

  /// Indicates if the user has set a calories daily goal.
  static bool isCalGoalSet = false;

  /// Indicates if the user has completed their daily calories goal.
  static bool isCalGoalComplete = false;

  /// Stores a user's current daily goal progress for steps taken.
  static double userProgressStepGoal = 0;

  /// Stores a user's current daily end goal for steps taken.
  static double userStepEndGoal = 0;

  /// Indicates if the user has set a steps daily goal.
  static bool isStepGoalSet = false;

  /// Indicates if the user has completed their daily steps goal.
  static bool isStepGoalComplete = false;

  /// Stores a user's current daily goal progress for miles traveled.
  static double userProgressMileGoal = 0;

  /// Stores a user's current daily end goal for miles traveled.
  static double userMileEndGoal = 0;

  /// Indicates if the user has set a miles daily goal.
  static bool isMileGoalSet = false;

  /// Indicates if the user has completed their daily miles goal.
  static bool isMileGoalComplete = false;

  /// Converts an activity duration string to a [Duration] object.
  ///
  /// Example:
  ///
  /// ```dart
  /// String activityDurationStr = "4 minutes";
  ///
  /// Duration d = convertToDuration(activityDurationStr);
  ///
  /// print(d); // 0:04:00.000000
  /// ```
  static Duration convertToDuration(String activityDurationStr) {
    Duration duration = Duration.zero;
    String value = activityDurationStr.split(' ')[0];
    String unitOfTime = activityDurationStr.split(' ')[1];
    switch (unitOfTime.toUpperCase()) {
      case 'SECONDS':
        duration = Duration(seconds: int.parse(value));
        break;
      case 'MINUTE':
      case 'MINUTES':
        duration = Duration(minutes: int.parse(value));
        break;
      case 'HOUR':
      case 'HOURS':
        duration = Duration(hours: int.parse(value));
        break;
    }
    return duration;
  }

  /// Converts a [Duration] to minutes.
  ///
  /// Example:
  ///
  ///```dart
  /// Duration d = Duration(hours: 3);
  ///
  /// double minutes = toMinutes(d);
  ///
  /// print(d); // 180
  /// ```
  static double toMinutes(Duration goalSum) {
    String hhmmss = goalSum.toString().split('.').first.padLeft(8, "0");
    List<String> hhmmssSplit = hhmmss.split(':');
    return double.parse(hhmmssSplit[0]) * 60 +
        double.parse(hhmmssSplit[1]) +
        double.parse(hhmmssSplit[2]) / 60;
  }

  /// Loops through each activity in [activitySnapshot] and calculates the
  /// total amount of exercise minutes.
  ///
  /// Returns the minute count as a double.
  static double totalTimeInMinutes(Map activitySnapshot) {
    Duration sum = Duration.zero;
    activitySnapshot.forEach((key, value) {
      sum += Goal.convertToDuration(value[2]);
    });
    return Goal.toMinutes(sum);
  }

  /// Sends a local goal completion notification to the user.
  ///
  /// The [type] indicates the payload.
  ///
  /// If the user clicks on a notification, they will be taken to the Completed
  /// Goals screen.
  ///
  /// The [id] specifies how a notification is shown when there is already one present.
  ///
  /// - All completed daily goals have an id of 0.
  ///
  /// If a newer notification has the same id as an older one, the older one
  /// disappears with the newer taking its place.
  ///
  /// As a result, only the newest completed daily will appear in
  /// a user's notification shade.
  static void _notify(String title, String body,
      {int id = 0, String type = "Daily"}) {
    NotificationService.notifications.show(
        id,
        title,
        body,
        NotificationDetails(
            android: AndroidNotificationDetails(NotificationService.channel.id,
                NotificationService.channel.name,
                channelDescription: NotificationService.channel.description,
                importance: Importance.high,
                color: Colors.white,
                playSound: true)),
        payload: type);
  }

  /// Calculates a user's completed goals.
  static void _calculateCompletedGoals() {
    isExerciseTimeGoalComplete = isExerciseTimeGoalSet &&
        (userProgressExerciseTime / userExerciseTimeEndGoal) * 100 >= 100;
    isCalGoalComplete =
        isCalGoalSet && (userProgressCalGoal / userCalEndGoal) * 100 >= 100;
    isStepGoalComplete =
        isStepGoalSet && (userProgressStepGoal / userStepEndGoal) * 100 >= 100;
    isMileGoalComplete =
        isMileGoalSet && (userProgressMileGoal / userMileEndGoal) * 100 >= 100;
  }

  /// Uploads a completed daily goal's stats to the user's goal log collection.
  ///
  /// Once a goal is completed, the associated goal values are reset.
  ///
  /// A user will also receive a local notification informing them of completion.
  static void uploadCompletedGoals() {
    _calculateCompletedGoals();
    if (isExerciseTimeGoalComplete) {
      FireStore.getGoalLogCollection(goalType: "daily").add({
        "Date": "${_now.month}/${_now.day}/${_now.year}",
        "Completed Goal": 'Exercise Time',
        "Info": "$userExerciseTimeEndGoal min of activity",
        "Type": "Daily Goal"
      });
      FireStore.updateGoalData(
          {"exerciseTimeEndGoal": 0.0, "isExerciseTimeGoalSet": false});
      _notify("Daily Goal Completed!",
          "Exercise Time - $userExerciseTimeEndGoal min of activity");
    }
    if (isCalGoalComplete) {
      FireStore.getGoalLogCollection(goalType: "daily").add({
        "Date": "${_now.month}/${_now.day}/${_now.year}",
        "Completed Goal": 'Calories Burned',
        "Info": "$userCalEndGoal calories burned",
        "Type": "Daily Goal"
      });
      FireStore.updateGoalData({
        "calGoalProgress": 0,
        "calEndGoal": 0,
        "isCalGoalSet": false,
      });
      _notify(
          "Daily Goal Completed!", "Calories - $userCalEndGoal cals burned");
    }
    if (isStepGoalComplete) {
      FireStore.getGoalLogCollection(goalType: "daily").add({
        "Date": "${_now.month}/${_now.day}/${_now.year}",
        "Completed Goal": 'Steps',
        "Info": "$userStepEndGoal steps taken",
        "Type": "Daily Goal"
      });
      FireStore.updateGoalData({
        "stepGoalProgress": 0,
        "stepEndGoal": 0,
        "isStepGoalSet": false,
      });
      _notify("Daily Goal Completed!", "Steps - $userStepEndGoal steps taken");
    }
    if (isMileGoalComplete) {
      FireStore.getGoalLogCollection(goalType: "daily").add({
        "Date": "${_now.month}/${_now.day}/${_now.year}",
        "Completed Goal": 'Miles',
        "Info": "$userMileEndGoal miles traveled",
        "Type": "Daily Goal"
      });
      FireStore.updateGoalData({
        "mileGoalProgress": 0,
        "mileEndGoal": 0,
        "isMileGoalSet": false,
      });
      _notify(
          "Daily Goal Completed!", "Miles - $userMileEndGoal miles traveled");
    }
  }

  /// Checks if [dayOfMonth] is equal to the current day.
  ///
  /// If not, the associated field in Firestore is updated.
  static void updateDayOfMonth() {
    if (dayOfMonth != _now.day) {
      FireStore.updateGoalData({"dayOfMonth": _now.day});
    }
  }
}
