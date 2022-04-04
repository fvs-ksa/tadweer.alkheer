import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/models/gallery_image.dart';
import 'package:tadweer_alkheer/providers/gallery_image_provider.dart';
import 'package:tadweer_alkheer/widgets/images_grid_view.dart';

class ImageGalleryScreen extends StatelessWidget {
  static const routeName = '/image-gallery';


  @override
  Widget build(BuildContext context) {
    final imagesProvider = Provider.of<GalleryImagesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).imageGallery),),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: FutureBuilder(
          future: imagesProvider.fetchImages(),
          builder: (ctx, imagesSnapshot) {
            if (imagesSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (imagesSnapshot.hasData) {
              List<GalleryImage> images = imagesSnapshot.data;

              return ImagesGridView(images);
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
