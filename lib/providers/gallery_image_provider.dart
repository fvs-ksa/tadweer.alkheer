import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/gallery_image.dart';
import '../locator.dart';
import '../services/crud_model.dart';

class GalleryImagesProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<GalleryImage> images;

  GalleryImagesProvider() {
    _crudeModel.setpath('galleryImages');
  }

  Future<List<GalleryImage>> fetchImages() async {
    var result = await _crudeModel.ref.get();

    images = result.docs
        .map((doc) => GalleryImage.fromMap(doc.data()))
        .toList();

    return images;
  }

}