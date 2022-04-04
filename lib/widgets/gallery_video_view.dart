import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tadweer_alkheer/models/gallery_Video.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GalleryVideoView extends StatefulWidget {
  final GalleryVideo video;

  GalleryVideoView(this.video);

  @override
  _GalleryVideoViewState createState() => _GalleryVideoViewState();
}

class _GalleryVideoViewState extends State<GalleryVideoView> {
  var thumbnailPath;
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 10;

  String _tempDir;
  String filePath;

  _getThumbnail (String url) async {
    getTemporaryDirectory().then((d) async {
      _tempDir = d.path;
      final thumbnail = await VideoThumbnail.thumbnailFile(
          video:  widget.video.videoUrl,
          thumbnailPath: _tempDir,
          imageFormat: _format,
          quality: _quality,
      );

      setState(() {
        print('my thumbnail path: $thumbnail');
        final file = File(thumbnail);
        filePath = file.path;
      });
    }
    );
}

  @override
  Widget build(BuildContext context) {
    if(widget.video.videoUrl.isNotEmpty && filePath == null){
      _getThumbnail(widget.video.videoUrl);
      return Image.asset(
        "assets/images/placeholder.png",
      );
    }

    return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Image.file(
        File(filePath),
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black38
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.video.description,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Align(
          alignment: Alignment.center,
          child: Icon(Icons.play_circle,
            color: Colors.white,
            size: 52.0,)
      ),
    ],
    );
  }
}
