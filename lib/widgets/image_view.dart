import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:path_provider/path_provider.dart' as syspaths;

class ImageView extends StatefulWidget {
  final String imageUrl;

  ImageView(this.imageUrl);

  @override
  _ImageViewState createState() => _ImageViewState();

}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
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
              width: 90,
              height: 90,
              child: widget.imageUrl.isEmpty
                  ? Center(child: Icon(Icons.add_a_photo, color: Colors.white,))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FadeInImage(
                        width: 10,
                        height: 10,
                        //placeholder appears for afew minutes while the image loads
                        placeholder: AssetImage(
                            'assets/images/placeholder.png'),
                        image: NetworkImage(widget.imageUrl),

                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/placeholder.png",
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
