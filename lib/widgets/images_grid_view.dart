import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tadweer_alkheer/models/gallery_image.dart';
import 'package:tadweer_alkheer/screens/zoom_image_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImagesGridView extends StatelessWidget {
  List<GalleryImage> images;

  ImagesGridView(List<GalleryImage> list){
    this.images = list;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            GalleryImage image = images[index];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ZoomImageScreen(image)),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network(
                images[index].imageUrl,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.black38,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(images[index].description,
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
