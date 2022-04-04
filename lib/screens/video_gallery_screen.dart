import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/models/gallery_Video.dart';
import 'package:tadweer_alkheer/providers/gallery_video_provider.dart';
import 'package:tadweer_alkheer/widgets/video_grid_view.dart';

class VideoGalleryScreen extends StatelessWidget {
  static const routeName = '/video-gallery';


  @override
  Widget build(BuildContext context) {
    final videosProvider = Provider.of<GalleryVideosProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).videoGallery),),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: FutureBuilder(
          future: videosProvider.fetchVideos(),
          builder: (ctx, videosSnapshot) {
            if (videosSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (videosSnapshot.hasData) {
              List<GalleryVideo> videos = videosSnapshot.data;

              return VideoGridView(videos);
            }
            return Align(
                alignment: Alignment.center,
                child: Text(AppLocalizations.of(context).videoGalleryEmpty));
          },
        ),
      ),
    );
  }
}
