import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoInput extends StatefulWidget {
  final Function onSelectVideo;
  VideoInput(this.onSelectVideo);
  @override
  _VideoInputState createState() => _VideoInputState();
}

class _VideoInputState extends State<VideoInput> {
  File _savedVideo;
  File videoThumbnail;
  bool camera;

  //added for the video
  Future<void> _takeVideo() async {
    //final ImageFile = await ImagePicker.pickImage(source: );
    final picker = ImagePicker();

    final videoFile = await picker.getVideo(source: ImageSource.gallery);

    final pickedVideoFile = File(videoFile.path);

    if(pickedVideoFile != null) {
      String thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: pickedVideoFile.path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 35, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );

      videoThumbnail = File(thumbnailPath);
    }

    setState(() {
      //_storedImage = ImageFile;   //old alternative
      _savedVideo = pickedVideoFile;
    });

    widget.onSelectVideo(_savedVideo);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _takeVideo,
      child: Center(
        child: Row(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              color: Color(0xffd3d3d3),
              margin: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.green),
                    borderRadius: BorderRadius.circular(15)),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),

                /// video adding...
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
                child: _savedVideo == null
                    ? Center(child: Icon(Icons.video_camera_back))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          videoThumbnail,
                          fit: BoxFit.cover,
                          width: 35.0,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
