// Copyright 2022 The myFit Authors. All rights reserved.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  /// Adds the user's account email to the test-users collection.
  static Future<void> addTestUser(String email) {
    return FirebaseFirestore.instance
        .collection('test-users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString()).set({
          "email":FirebaseAuth.instance.currentUser!.email.toString()
        });
  }

  /// Fetches a stream of YouTube playlist ids from Firestore.
  static Stream<QuerySnapshot> getYTPlaylistIDs() {
    return FirebaseFirestore.instance
        .collection('youtube-playlists')
        .snapshots();
  }

  /// Fetches a stream of YouTube video urls from Firestore.
  static Stream<QuerySnapshot> getYTVideoUrls() {
    return FirebaseFirestore.instance.collection('youtube-videos').snapshots();
  }

  /// Fetches the user's activity document in Firestore.
  static DocumentReference<Map<String, dynamic>> getUserActivityDocument() {
    return FirebaseFirestore.instance
        .collection('activity')
        .doc(FirebaseAuth.instance.currentUser!.email.toString());
  }

  /// Creates stream that listens to the user's activity document in Firestore.
  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      createUserActivityStream() {
    return getUserActivityDocument().snapshots();
  }

  /// Updates a user's activity document.
  ///
  /// The [data] is a map where the String key values serves as field names
  /// and any value (dynamic) serves as the field's value.
  static Future<void> updateWorkoutData(Map<String, dynamic> data) {
    return getUserActivityDocument().set(data);
  }

  /// Creates a user's activity document in Firestore.
  static void createUserActivityDocument() async {
    await FirebaseFirestore.instance
        .collection('activity')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set(new Map());
  }

  /// Fetches the user's goal document in Firestore.
  static DocumentReference<Map<String, dynamic>> getGoalDocument() {
    return FirebaseFirestore.instance
        .collection('goals')
        .doc(FirebaseAuth.instance.currentUser!.email.toString());
  }

  /// Creates stream that listens to the user's goal document in Firestore.
  static Stream<DocumentSnapshot<Map<String, dynamic>>> createGoalDocStream() {
    return getGoalDocument().snapshots();
  }

  /// Fetches the user's goal log collection in Firestore.
  static CollectionReference<Map<String, dynamic>> getGoalLogCollection(
      {required String goalType}) {
    return FirebaseFirestore.instance
        .collection('goal-logs')
        .doc(goalType)
        .collection(FirebaseAuth.instance.currentUser!.email.toString());
  }

  /// Deletes all user previously completed daily goals stored in Firestore.
  static void deleteAllCompletedGoals() async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = getGoalLogCollection(goalType: "daily");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Updates a user's goal document.
  ///
  /// The [data] is a map where the String key values serves as field names
  /// and any value (dynamic) serves as the field's value.
  static Future<void> updateGoalData(Map<String, dynamic> data) {
    return getGoalDocument().update(data);
  }

  /// Creates a user's goal document in Firestore.
  ///
  /// The document has all fields set with default field names and values.
  static void createGoalDocument() async {
    await FirebaseFirestore.instance
        .collection('goals')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({
      "isHealthAppSynced": false,
      "isExerciseTimeGoalSet": false,
      "isCalGoalSet": false,
      "isStepGoalSet": false,
      "isMileGoalSet": false,
      "exerciseTimeGoalProgress": 0,
      "exerciseTimeEndGoal": 0,
      "calGoalProgress": 0,
      "calEndGoal": 0,
      "stepGoalProgress": 0,
      "stepEndGoal": 0,
      "mileGoalProgress": 0,
      "mileEndGoal": 0,
      "dayOfMonth": DateTime.now().day
    });
  }
}
