// Copyright 2022 The myAPFP Authors. All rights reserved.

import '/util/toasted/toasted.dart';
import '/util/validator/validator.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import '/firebase/firestore.dart';

import '/widgets/confirmation_dialog/confirmation_dialog.dart';

import 'package:flutter/material.dart';

class SetGoalsWidget extends StatefulWidget {
  SetGoalsWidget({Key? key}) : super(key: key);

  /// Takes user to Set Goals screen.
  static void launch(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetGoalsWidget(),
      ),
    );
  }

  @override
  _SetGoalsWidgetState createState() => _SetGoalsWidgetState();
}

class _SetGoalsWidgetState extends State<SetGoalsWidget> {
  /// Controls the [CircularProgressIndicator] loading animation of a button.
  bool _loadingButton = false;

  /// Indicates if the 'APFP' goal textFields are shown.
  bool _isAPFPGoalsDisplayed = false;

  /// Used to validate the current input of the Exercise Time textField.
  final _exerciseFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Cycling textField.
  final _cyclingFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Rowing textField.
  final _rowingFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Step Mill textField.
  final _stepMillFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Calories textField.
  final _caloriesFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Miles textField.
  final _milesFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Steps textField.
  final _stepFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Elliptical textField.
  final _ellipticalFormKey = GlobalKey<FormState>();

  /// Used to validate the current input of the Resistance/Strength textField.
  final _resistanceStrengthFormKey = GlobalKey<FormState>();

  /// Serves as key for the [Scaffold] found in [build].
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// [TextEditingController] for the Exercise Time textField.
  TextEditingController? _exerciseGoalController = TextEditingController();

  /// [TextEditingController] for the Calories textField.
  TextEditingController? _caloriesGoalController = TextEditingController();

  /// [TextEditingController] for the Miles textField.
  TextEditingController? _milesGoalController = TextEditingController();

  /// [TextEditingController] for the Steps textField.
  TextEditingController? _stepGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getStoredEndGoals();
  }

  @override
  void dispose() {
    super.dispose();
    _exerciseGoalController!.dispose();
    _caloriesGoalController!.dispose();
    _milesGoalController!.dispose();
    _stepGoalController!.dispose();
  }

  /// Set's [contr]'s text to an end goal value in Firestore, based on
  /// what's passed to [fieldName].
  void setText(MapEntry<String, dynamic> element, String fieldName,
      TextEditingController? contr) {
    if (element.key == fieldName) {
      if (element.value == 0.0) {
        contr!.text = '';
      } else if (fieldName == "mileEndGoal") {
        contr!.text = element.value.toStringAsFixed(1);
      } else {
        contr!.text = element.value.round().toString();
      }
    }
  }

  /// Fetches the user's end goals from Firestore.
  void _getStoredEndGoals() async {
    var doc = await FireStore.getGoalDocument().get();
    var docEntries = doc.data()!.entries;
    docEntries.forEach((element) {
      setText(element, 'exerciseTimeEndGoal', _exerciseGoalController);
      setText(element, "calEndGoal", _caloriesGoalController);
      setText(element, "mileEndGoal", _milesGoalController);
      setText(element, "stepEndGoal", _stepGoalController);
    });
  }

  /// Creates a label.
  Text _label({required String text, TextStyle? style}) {
    return Text(text, style: style);
  }

  /// When pressed, the user is taken back to Settings.
  InkWell _goBackButton() {
    return InkWell(
        key: Key("SetGoal.goBackBTN"),
        onTap: () => Navigator.pop(context),
        child: Text('< Go Back', style: FlutterFlowTheme.subtitle2));
  }

  /// Creates a button that allows a user to set a goal.
  ///
  /// [formKey] is used to validate the associated goal's textField.
  ///
  /// [onTap] is executed when a user presses the button.
  FFButtonWidget _setGoalButton(GlobalKey<FormState> formKey, Function onTap,
      {required Key key}) {
    return FFButtonWidget(
      key: key,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          FocusScope.of(context).unfocus();
          setState(() {
            _loadingButton = true;
          });
          onTap();
          Toasted.showToast("Goal has been set");
          setState(() => _loadingButton = false);
        }
      },
      text: 'Set Goal',
      options: FFButtonOptions(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        color: FlutterFlowTheme.secondaryColor,
        textStyle: FlutterFlowTheme.title2,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: 12,
      ),
      loading: _loadingButton,
    );
  }

  /// Creates a button that allows a user to reset a goal.
  ///
  /// [onTap] is executed when a user presses the button.
  ///
  /// A [ConfirmationDialog] is shown allowing a user to confirm their decision.
  Expanded _deleteGoalIcon({required Function onTap}) {
    return Expanded(
        child: InkWell(
            onTap: () {
              ConfirmationDialog.showConfirmationDialog(
                  context: context,
                  title: Text('Reset Goal'),
                  content: Text('Are you sure you want to reset this goal?'),
                  onSubmitTap: () {
                    onTap();
                    Navigator.of(context).pop();
                    Toasted.showToast("Goal has been reset");
                  },
                  onCancelTap: () => Navigator.of(context).pop(),
                  submitText: "Reset",
                  cancelText: "Back");
            },
            child: Icon(
              Icons.delete,
              size: 45,
              color: FlutterFlowTheme.secondaryColor,
            )));
  }

  /// Creates a textField to be used to enter end goals.
  ///
  /// [allowDoubleAsInput] dictates whether or not a [_goalTextField] can
  /// receive a [double] as input. Reserved for the miles [_goalTextField].
  Padding _goalTextField(
      {required Key key,
      required String hintText,
      required TextEditingController contr,
      String unitOfMeasure = "min",
      String goalType = "Daily",
      bool allowDoubleAsInput = false}) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        child: new TextFormField(
          key: key,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please provide a value";
            }
            if (!allowDoubleAsInput && !Validator.isPositiveInt(value)) {
              return "Integers (1+) only";
            } else if (allowDoubleAsInput &&
                !Validator.isPositiveNumber(value)) {
              return "Numbers (1+) only";
            }
            int minimum = 0;
            int maximum = 0;
            switch ("$goalType $unitOfMeasure") {
              case "Daily calories":
                minimum = 1800;
                maximum = 6000;
                break;
              case "Daily steps":
                minimum = 100;
                maximum = 15000;
                break;
              case "Daily mile(s)":
                minimum = 1;
                maximum = 30;
                break;
              case "Daily min":
                minimum = 10;
                maximum = 240;
                break;
            }
            if (double.parse(value) < minimum) {
              return "$minimum $unitOfMeasure is minimum";
            }
            if (double.parse(value) > maximum) {
              return "$maximum $unitOfMeasure is max limit";
            }
            return null;
          },
          controller: contr,
          obscureText: false,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: FlutterFlowTheme.bodyText1,
        ),
      ),
    );
  }

  /// Based on [_isAPFPGoalsDisplayed], this will return a list of widgets
  /// associated with daily regular goals or 'APFP' goals.
  List<Widget> _dailyGoalsUI() {
    return [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15, 30, 0, 5),
        child: _label(text: 'Exercise Goal', style: FlutterFlowTheme.title3),
      ),
      Form(
        key: _exerciseFormKey,
        child: Row(
          children: [
            _goalTextField(
                hintText: "Total Minutes",
                contr: _exerciseGoalController!,
                key: Key("SetGoal.exerciseGoalTextField_daily")),
            _setGoalButton(_exerciseFormKey, () async {
              await FireStore.updateGoalData({
                "exerciseTimeEndGoal":
                    double.parse(_exerciseGoalController!.text.toString()),
                "isExerciseTimeGoalSet": true
              });
            }, key: Key("SetGoal.setExerciseGoalBTN_daily")),
            _deleteGoalIcon(onTap: () async {
              await FireStore.updateGoalData({
                "exerciseTimeEndGoal": 0.0,
                "isExerciseTimeGoalSet": false
              }).then((value) {
                _exerciseGoalController!.text = '';
              });
            })
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15, 30, 0, 5),
        child: _label(text: 'Calories Goal', style: FlutterFlowTheme.title3),
      ),
      Form(
        key: _caloriesFormKey,
        child: Row(
          children: [
            _goalTextField(
                hintText: "Calories",
                contr: _caloriesGoalController!,
                unitOfMeasure: "calories",
                goalType: "Daily",
                key: Key("SetGoal.calGoalTextField_daily")),
            _setGoalButton(_caloriesFormKey, () async {
              await FireStore.updateGoalData({
                "calEndGoal":
                    double.parse(_caloriesGoalController!.text.toString()),
                "isCalGoalSet": true
              });
            }, key: Key("SetGoal.setCalGoalBTN_daily")),
            _deleteGoalIcon(onTap: () async {
              await FireStore.updateGoalData(
                  {"calEndGoal": 0.0, "isCalGoalSet": false}).then((value) {
                _caloriesGoalController!.text = '';
              });
            })
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15, 30, 0, 5),
        child: _label(text: 'Miles Goal', style: FlutterFlowTheme.title3),
      ),
      Form(
        key: _milesFormKey,
        child: Row(
          children: [
            _goalTextField(
                hintText: "Miles",
                contr: _milesGoalController!,
                unitOfMeasure: "mile(s)",
                goalType: "Daily",
                key: Key("SetGoal.mileGoalTextField_daily"),
                allowDoubleAsInput: true),
            _setGoalButton(_milesFormKey, () async {
              await FireStore.updateGoalData({
                "mileEndGoal": double.parse(
                    double.parse(_milesGoalController!.text.toString())
                        .toStringAsFixed(1)),
                "isMileGoalSet": true
              });
            }, key: Key("SetGoal.setMileGoalBTN_daily")),
            _deleteGoalIcon(onTap: () async {
              await FireStore.updateGoalData(
                  {"mileEndGoal": 0.0, "isMileGoalSet": false}).then((value) {
                _milesGoalController!.text = '';
              });
            })
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15, 30, 0, 5),
        child: _label(text: 'Steps Goal', style: FlutterFlowTheme.title3),
      ),
      Form(
        key: _stepFormKey,
        child: Row(
          children: [
            _goalTextField(
                hintText: "Steps",
                contr: _stepGoalController!,
                unitOfMeasure: "steps",
                goalType: "Daily",
                key: Key("SetGoal.stepGoalTextField_daily")),
            _setGoalButton(_stepFormKey, () async {
              await FireStore.updateGoalData({
                "stepEndGoal":
                    double.parse(_stepGoalController!.text.toString()),
                "isStepGoalSet": true
              });
            }, key: Key("SetGoal.setStepGoalBTN_daily")),
            _deleteGoalIcon(onTap: () async {
              await FireStore.updateGoalData(
                  {"stepEndGoal": 0.0, "isStepGoalSet": false}).then((value) {
                _stepGoalController!.text = '';
              });
            })
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 20, 0, 20),
                    child: _goBackButton(),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15, 20, 0, 0),
                      child: _label(
                          text: 'Daily Goals', style: FlutterFlowTheme.title1)),
                  Column(
                    children: _dailyGoalsUI(),
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  SizedBox(height: 25),
                ]),
          ))),
    );
  }
}
