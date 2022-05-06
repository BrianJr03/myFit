import 'package:intl/intl.dart';

import '../exercise_video/exercise_video_widget.dart';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  const VideoCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String duration = video.duration.toString();
    duration = duration.substring(0, 7);
    if (video.duration!.inMinutes < 59) {
      duration = duration.substring(2, 7);
    }
    String views = NumberFormat.compact().format(video.engagement.viewCount);
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
                      Flexible(
                        child: Text(
                            '${video.author} • $views views • ${timeago.format(video.publishDate!)}',
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
