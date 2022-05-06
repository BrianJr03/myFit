// Copyright 2022 The myAPFP Authors. All rights reserved.

import 'dart:async';

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

  /// A list of APFP YouTube video urls.
  List<String> videoURLs = [];

  /// Backup of APFP YouTube video urls.
  List<Widget> videoBackup = [];

  /// A list of APFP YouTube playlist ids.
  List<String> playlistIDs = [];

  /// Backup of APFP YouTube playlist ids.
  List<Widget> playlistBackup = [];

  /// A list of APFP YouTube videos available for viewing.
  List<Widget> videoList = [];

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
                child: Text(
                    'These are just a few of my fav songs.' +
                        '\n(this screen is to be deleted soon)',
                    key: Key('Exercises.description'),
                    style: FlutterFlowTheme.bodyText1))
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

  /// Adds each video url from the video stream to [videoList].
  void _populateVideos() {
    widget.videoStream.forEach((snapshot) {
      for (Widget element in videoBackup) {
        if (videoList.contains(element)) {
          videoList.remove(element);
        }
      }
      videoBackup.clear();
      snapshot.docs.forEach((document) {
        _preloadVideo(document["url"]);
      });
    });
  }

  /// Adds each playlist id from the video stream to [videoList].
  void _populatePlaylists() {
    widget.playlistStream.forEach((snapshot) {
      for (Widget element in playlistBackup) {
        if (videoList.contains(element)) {
          videoList.remove(element);
        }
      }
      playlistBackup.clear();
      snapshot.docs.forEach((document) {
        _preloadPlaylist(document["id"]);
      });
    });
  }

  /// Converts a YouTube url into a [_videoCard] and adds it to [videoList].
  void _preloadVideo(String url) async {
    YoutubeExplode yt = YoutubeExplode();
    Video video = await yt.videos.get(url);
    VideoCard videoCard = VideoCard(video: video);
    _addVideoToList(videoCard);
    videoBackup.add(videoCard);
    yt.close();
  }

  /// Converts a YouTube playlist id into a [_videoCard] and adds it to [videoList].
  void _preloadPlaylist(String id) async {
    YoutubeExplode yt = YoutubeExplode();
    Playlist playlist = await yt.playlists.get(id);
    await for (Video video in yt.playlists.getVideos(playlist.id)) {
      VideoCard videoCard = VideoCard(video: video);
      _addVideoToList(videoCard);
      playlistBackup.add(videoCard);
    }
    yt.close();
  }

  /// Adds a video card to [videoList].
  void _addVideoToList(VideoCard videoCard) {
    if (mounted) {
      setState(() {
        videoList.add(videoCard);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
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
                    : Text("Video Count: ${videoList.length}",
                        style: FlutterFlowTheme.subtitle3),
                SizedBox(height: 10)
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: videoList,
            ),
          ]),
        )));
  }
}
