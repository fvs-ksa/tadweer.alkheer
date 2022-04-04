import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/gallery_Video.dart';
import '../locator.dart';
import '../services/crud_model.dart';

class GalleryVideosProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<GalleryVideo> videos;

  GalleryVideosProvider() {
    _crudeModel.setpath('galleryVideos');
  }

  Future<List<GalleryVideo>> fetchVideos() async {
    var result = await _crudeModel.ref.get();

    videos = result.docs
        .map((doc) => GalleryVideo.fromMap(doc.data()))
        .toList();

    return videos;
  }

}