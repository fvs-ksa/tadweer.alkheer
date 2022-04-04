import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tadweer_alkheer/providers/users_provider.dart';
import '../widgets/image_input.dart';
import '../models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  final User user;
  final String field;
  EditProfile({this.user, this.field});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File _newImage;
  String _newName;
  final _form = GlobalKey<FormState>();

  // to recieve the selected image
  void _selectImage(File pickedImage) {
    setState(() {
      _newImage = pickedImage;
    });
  }

  //edit
  Future<void> _save() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    String newImageUrl;

    //validate form
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    //to submit form
    _form.currentState.save();

    try {
      if (widget.field == 'Image') {
        //to store image in firebase storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(widget.user.id + '.jpg');

        await ref.putFile(_newImage).whenComplete(() => {});

        //to get a url that can be saved anywhere
        newImageUrl = await ref.getDownloadURL();
      }

      if (newImageUrl == null) {
        newImageUrl = widget.user.imageUrl;
      }
      if (_newName == null) {
        _newName = widget.user.name;
      }

      usersProvider.updateUser(
        User(
          imageUrl: newImageUrl,
          itemsDonated: widget.user.itemsDonated,
          joinDate: widget.user.joinDate,
          name: _newName,
          phoneNumber: widget.user.phoneNumber,
        ),
        widget.user.id,
      );
    } catch (error) {
      print('error$error');
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //conditions
    final isImage = widget.field == 'Image';
    final isProfile = widget.field == 'Profile';
    final isDisabled = (isImage && _newImage == null);
    // (isAmount && _newAmount == null) ||
    // (isPrice && _newPrice == null);

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: <Widget>[
          Divider(),
          Text(isImage
              ? AppLocalizations.of(context).editimage
              : AppLocalizations.of(context).editprofile),
          Divider(),
          if (isImage)
            Column(
              children: <Widget>[],
            ),
          Expanded(
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (isProfile)
                    TextFormField(
                      initialValue: widget.user.name,
                      key: ValueKey('name'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).name,
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newName = value;
                      },
                    ),
                  if (isImage) ImageInput(_selectImage),
                  RaisedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text(AppLocalizations.of(context).save),
                    onPressed: isDisabled ? null : _save,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
