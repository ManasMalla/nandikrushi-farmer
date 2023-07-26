import 'package:flutter/material.dart';
import 'package:nandikrushi_farmer/nav_items/video_data.dart';

import '../../domain/entity/video.dart';
import '../../utils/youtube_util.dart';

homeVideoSection(List<Video> videos) {
  return SizedBox(
      height: 110,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {
                var url = "https://www.youtube.com/watch?v=${videoID[index]}";
                YoutubeUtil().launchYoutubeVideo(url);
              },
              child: SizedBox(
                width: 200,
                child: Stack(children: [
                  Image.network(
                    "https://img.youtube.com/vi/${videoID[index]}/hqdefault.jpg",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Container(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                  Center(
                    child: Icon(
                      Icons.play_circle_outline_rounded,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      size: 36,
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
        separatorBuilder: (context, _) {
          return const SizedBox(
            width: 8,
          );
        },
        itemCount: videos.length,
        scrollDirection: Axis.horizontal,
      ));
}
