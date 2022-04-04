import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoView extends StatefulWidget {
  final String videoUrl;

  VideoView(this.videoUrl);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  var thumbnailPath;
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 10;

  String _tempDir;
  String filePath;

  _getThumbnail (String url) async {
    getTemporaryDirectory().then((d) async {
      _tempDir = d.path;
      final thumbnail = await VideoThumbnail.thumbnailFile(
          video:  widget.videoUrl,
          thumbnailPath: _tempDir,
          imageFormat: _format,
          quality: _quality);

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
    if(widget.videoUrl.isNotEmpty && filePath == null){
      _getThumbnail(widget.videoUrl);
    }

    return Center(
      child: Row(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            color: Colors.green,
            margin: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15)),
              /// video adding...
              width: 90,
              height: 90,
              child:  filePath == null || filePath.isEmpty
                  ? Center(child: Icon(Icons.video_camera_back, color: Colors.white,))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(filePath),
                        fit: BoxFit.cover,
                        width: 10,
                        height: 10,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
