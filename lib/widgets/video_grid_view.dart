import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/gallery_Video.dart';
import 'package:tadweer_alkheer/screens/play_video_screen.dart';
import 'package:tadweer_alkheer/widgets/gallery_video_view.dart';

class VideoGridView extends StatelessWidget {
  List<GalleryVideo> videos;

  VideoGridView(this.videos);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: videos.length,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayVideoScreen()),
            );
          },
          child: GalleryVideoView(videos[index]),
        );
      },
    );
  }


}
