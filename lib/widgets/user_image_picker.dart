//image picker and here you will add the video
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  File _pickedVideo;
  bool camera;
  void _pickImage() async {
    //ImagePicker.pickImage(source: null);

    final picker = ImagePicker();

    //wait for the user to make a decision first
    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text(AppLocalizations.of(context).addpicture),
              content: Text(AppLocalizations.of(context).fromcameraorgallery),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    camera = true;
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).camera),
                ),
                TextButton(
                  onPressed: () {
                    camera = false;
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).gallery),
                ),
              ],
            ));
    final pickedImage = await picker.getImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
    );

//can use dialog to make user pick between gallery and camera
    final pickedImageFile =
        File(pickedImage.path); // requires import 'dart:io';
    setState(() {
      _pickedImage = pickedImageFile;
    });

    widget.imagePickFn(pickedImageFile);
  }
// from here you can add the vdieo
  //// video player

  void _pickVideo() async {
    //ImagePicker.pickVideo(source: null);

    final picker = ImagePicker();

    //wait for the user to make a decision first
    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text(AppLocalizations.of(context).addpicture),
              content: Text(AppLocalizations.of(context).fromcameraorgallery),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    camera = true;
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).camera),
                ),
                TextButton(
                  onPressed: () {
                    camera = false;
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).gallery),
                ),
              ],
            ));
    final pickedImage = await picker.getImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
    );

//can use dialog to make user pick between gallery and camera
    final pickedImageFile =
        File(pickedImage.path); // requires import 'dart:io';
    setState(() {
      _pickedVideo = pickedImageFile;
    });

    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Add Image'),
            textColor: Theme.of(context).primaryColor),
      ],
    );
  }
}
