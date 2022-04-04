import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tadweer_alkheer/models/gallery_image.dart';

class ZoomImageScreen extends StatelessWidget {
  static const routeName = '/zoom-image';
  GalleryImage image;

  ZoomImageScreen(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image.description),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(image.imageUrl),
      ),
    );
  }

}