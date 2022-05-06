// Copyright 2022 The myAPFP Authors. All rights reserved.

import 'dart:async';

import 'package:getwidget/getwidget.dart';

import '/widgets/video_card/video_card.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/util/internet_connection/internet.dart';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AtHomeExercisesWidget extends StatefulWidget {
  /// The APFP YouTube url collection stream.
  final Stream<QuerySnapshot<Object?>> videoStream;

  /// The APFP YouTube playlist id collection stream.
  final Stream<QuerySnapshot<Object?>> playlistStream;

  AtHomeExercisesWidget(
      {Key? key, required this.playlistStream, required this.videoStream})
      : super(key: key);

  @override
  _AtHomeExercisesWidgetState createState() => _AtHomeExercisesWidgetState();
}

class _AtHomeExercisesWidgetState extends State<AtHomeExercisesWidget> {
  /// Serves as key for the [Scaffold] found in [build].
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Returns true if all YouTube videos are loaded.
  bool _isVideosLoaded = false;

  /// Backup of APFP YouTube video urls.
  List<Widget> _videoBackup = [];

  /// Backup of APFP YouTube playlist ids.
  List<Widget> _playlistBackup = [];

  /// A list of exercise YouTube videos.
  List<Widget> _videoList = [];

  /// A list of aerobic exercise YouTube videos.
  List<Widget> _aerobicVideos = [];

  /// A list of muscular exercise YouTube videos.
  List<Widget> _muscularVideos = [];

  /// A list of cardio exercise YouTube videos.
  List<Widget> _cardioVideos = [];

  /// A list of balance exercise YouTube videos.
  List<Widget> _balanceVideos = [];

  /// Index associated with the selected radio button within [_radioButtonsCard].
  ///
  /// Default value is 1 which corresponds to the "Time" radio button.
  int _groupValue = 0;

  @override
  void initState() {
    super.initState();
    preloadAllVideos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Returns the header text which is displayed at the top of the
  /// Exercises screen.
  List<Padding> _paddedHeaderText() {
    return [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          AutoSizeText(
            'At-Home Exercises',
            key: Key('Exercises.header'),
            style: FlutterFlowTheme.title1,
            overflow: TextOverflow.fade,
          )
        ]),
      ),
      Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 4, 24, 10),
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
                child: Column(
              children: [
                Text(
                    "These are exercise videos that can be enjoyed at home." +
                        " Be sure to always practice safety.",
                    style: TextStyle(fontSize: 20)),
                _radioButtonsCard()
              ],
            ))
          ]))
    ];
  }

  /// Preloads all YouTube videos if the user is connected to the internet.
  ///
  /// If there is no internet connection, this method will be called recursively until
  /// one is established.
  void preloadAllVideos() async {
    if (mounted) {
      await (Internet.isConnected()).then((value) async => {
            if (value)
              {
                setState(() {
                  _populateVideos();
                  _populatePlaylists();
                })
              }
            else
              {Timer(Duration(seconds: 1), preloadAllVideos)}
          });
      _isVideosLoaded = true;
    }
  }

  /// Adds each video url from the video stream to [_videoList].
  void _populateVideos() {
    widget.videoStream.forEach((snapshot) {
      for (Widget element in _videoBackup) {
        if (_videoList.contains(element)) {
          _videoList.remove(element);
        }
      }
      _videoBackup.clear();
      _aerobicVideos.clear();
      _muscularVideos.clear();
      _cardioVideos.clear();
      _balanceVideos.cast();
      snapshot.docs.forEach((document) {
        _preloadVideo(url: document["url"], type: document["type"]);
      });
    });
  }

  /// Adds each playlist id from the video stream to [_videoList].
  void _populatePlaylists() {
    widget.playlistStream.forEach((snapshot) {
      for (Widget element in _playlistBackup) {
        if (_videoList.contains(element)) {
          _videoList.remove(element);
        }
      }
      _playlistBackup.clear();
      snapshot.docs.forEach((document) {
        _preloadPlaylist(id: document["id"], type: document["type"]);
      });
    });
  }

  /// Converts a YouTube url into a [_videoCard] and adds it to [_videoList].
  void _preloadVideo({required String url, required String type}) async {
    YoutubeExplode yt = YoutubeExplode();
    Video video = await yt.videos.get(url);
    VideoCard videoCard = VideoCard(video: video);
    _addVideoToList(videoCard, type);
    _videoBackup.add(videoCard);
    yt.close();
  }

  /// Converts a YouTube playlist id into a [_videoCard] and adds it to [_videoList].
  void _preloadPlaylist({required String id, required String type}) async {
    YoutubeExplode yt = YoutubeExplode();
    Playlist playlist = await yt.playlists.get(id);
    await for (Video video in yt.playlists.getVideos(playlist.id)) {
      VideoCard videoCard = VideoCard(video: video);
      _addVideoToList(videoCard, type);
      _playlistBackup.add(videoCard);
    }
    yt.close();
  }

  /// Adds a video card to [_videoList].
  void _addVideoToList(VideoCard videoCard, String type) {
    if (mounted) {
      _videoList.add(videoCard);
      switch (type) {
        case "aerobic":
          setState(() => {_aerobicVideos.add(videoCard)});
          break;
        case "muscular":
          setState(() => {_muscularVideos.add(videoCard)});
          break;
        case "cardio":
          setState(() => {_cardioVideos.add(videoCard)});
          break;
        case "balance":
          setState(() => {_balanceVideos.add(videoCard)});
          break;
      }
    }
  }

  /// Returns the associated [_goalCard] list based on [_groupValue].
  List<Widget> _getVideoList() {
    switch (_groupValue) {
      case 1:
        return _aerobicVideos;
      case 2:
        return _muscularVideos;
      case 3:
        return _cardioVideos;
      case 4:
        return _balanceVideos;
    }
    return _videoList;
  }

  /// A [GFCard] containing 'Time', 'Cals', 'Steps', 'Miles'
  /// and 'APFP' radio buttons.
  ///
  /// Allows the user to chose which type of completed goals are displayed.
  GFCard _radioButtonsCard() {
    return GFCard(
        color: FlutterFlowTheme.secondaryColor,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Text("All",
                    style: TextStyle(color: FlutterFlowTheme.tertiaryColor)),
                SizedBox(height: 5),
                GFRadio(
                  type: GFRadioType.square,
                  size: 20,
                  value: 0,
                  groupValue: _groupValue,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = int.parse(value.toString());
                    });
                  },
                  inactiveIcon: null,
                  activeBorderColor: FlutterFlowTheme.secondaryColor,
                  radioColor: FlutterFlowTheme.secondaryColor,
                ),
              ],
            ),
            Column(
              children: [
                Text("Aerobic",
                    style: TextStyle(color: FlutterFlowTheme.tertiaryColor)),
                SizedBox(height: 5),
                GFRadio(
                  type: GFRadioType.square,
                  size: 20,
                  value: 1,
                  groupValue: _groupValue,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = int.parse(value.toString());
                    });
                  },
                  inactiveIcon: null,
                  activeBorderColor: FlutterFlowTheme.secondaryColor,
                  radioColor: FlutterFlowTheme.secondaryColor,
                ),
              ],
            ),
            Column(
              children: [
                Text("Muscular",
                    style: TextStyle(color: FlutterFlowTheme.tertiaryColor)),
                SizedBox(height: 5),
                GFRadio(
                  type: GFRadioType.square,
                  size: 20,
                  value: 2,
                  groupValue: _groupValue,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = int.parse(value.toString());
                    });
                  },
                  inactiveIcon: null,
                  activeBorderColor: FlutterFlowTheme.secondaryColor,
                  radioColor: FlutterFlowTheme.secondaryColor,
                ),
              ],
            ),
            Column(
              children: [
                Text("Cardio",
                    style: TextStyle(color: FlutterFlowTheme.tertiaryColor)),
                SizedBox(height: 5),
                GFRadio(
                  type: GFRadioType.square,
                  size: 20,
                  value: 3,
                  groupValue: _groupValue,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = int.parse(value.toString());
                    });
                  },
                  inactiveIcon: null,
                  activeBorderColor: FlutterFlowTheme.secondaryColor,
                  radioColor: FlutterFlowTheme.secondaryColor,
                ),
              ],
            ),
            Column(
              children: [
                Text("Balance",
                    style: TextStyle(color: FlutterFlowTheme.tertiaryColor)),
                SizedBox(height: 5),
                GFRadio(
                  type: GFRadioType.square,
                  size: 20,
                  value: 4,
                  groupValue: _groupValue,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = int.parse(value.toString());
                    });
                  },
                  inactiveIcon: null,
                  activeBorderColor: FlutterFlowTheme.secondaryColor,
                  radioColor: FlutterFlowTheme.secondaryColor,
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _paddedHeaderText()[0],
                _paddedHeaderText()[1],
                !_isVideosLoaded
                    ? Text("Loading Videos...",
                        style: FlutterFlowTheme.subtitle3)
                    : Text("Video Count: ${_getVideoList().length}",
                        style: FlutterFlowTheme.subtitle3),
                SizedBox(height: 10)
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: _getVideoList(),
            ),
          ]),
        )));
  }
}
