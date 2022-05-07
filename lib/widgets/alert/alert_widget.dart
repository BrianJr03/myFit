// Copyright 2022 The myAPFP Authors. All rights reserved.

import '/main.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';

class AlertWidget extends StatefulWidget {
  /// Alert Title.
  final String title;

  /// Alert description.
  final String description;

  AlertWidget({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {

  /// Serves as key for the [Scaffold] found in [build].
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// When pressed, the user is taken back to Settings
  InkWell _backButton() {
    return InkWell(
      onTap: () async {
        Navigator.pop(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            duration: Duration(milliseconds: 125),
            reverseDuration: Duration(milliseconds: 125),
            child: NavBarPage(initialPage: 1),
          ),
        );
      },
      child: Text('< Back to Announcements', style: FlutterFlowTheme.subtitle2),
    );
  }

  /// Creates title label.
  Text _announcementTitle(String text) {
    return Text(
      text,
      style: FlutterFlowTheme.title1,
    );
  }

  /// Creates paragraph body.
  Text _announcementParagraph(String text) {
    return Text(
      text,
      style: FlutterFlowTheme.bodyText1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 25, 15, 0),
                  child: _backButton(),
                ),
                Padding(
                  key: Key('Alert.title'),
                  padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                  child: _announcementTitle(widget.title),
                ),
                Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8),
                    child: SingleChildScrollView(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 100),
                        child: Padding(
                          key: Key('Alert.description'),
                          padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                          child: _announcementParagraph(widget.description),
                        )))
              ],
            ),
          ),
        ));
  }
}
