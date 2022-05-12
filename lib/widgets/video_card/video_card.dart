import 'package:intl/intl.dart';

import '../exercise_video/exercise_video_widget.dart';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final String videoType;

  const VideoCard({Key? key, required this.video, required this.videoType})
      : super(key: key);

  String _videoInfo() {
    DateTime? publishDate = video.publishDate;
    String views = NumberFormat.compact().format(video.engagement.viewCount);
    if (videoType == "ytVid")
      return '${video.author} • $views views • ${timeago.format(publishDate!)}';
    return '${video.author} • Playlist';
  }

  @override
  Widget build(BuildContext context) {
    String duration = video.duration.toString()..substring(0, 7);
    if (video.duration!.inMinutes < 59) {
      duration = duration.substring(2, 7);
    }
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideoWidget(video: video),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(video.thumbnails.highResUrl,
                  height: 220.0, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                bottom: 8.0,
                right: 8.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    duration,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: Text(video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 15.0))),
                      SizedBox(height: 5),
                      Flexible(
                        child: Text(_videoInfo(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 14.0)),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
