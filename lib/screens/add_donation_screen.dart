import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tadweer_alkheer/models/points.dart';
import 'package:tadweer_alkheer/providers/donations_provider.dart';
import 'package:tadweer_alkheer/providers/users_provider.dart';
import 'package:tadweer_alkheer/screens/donation_done_screen.dart';
import 'package:tadweer_alkheer/widgets/image_input.dart';
import 'package:tadweer_alkheer/widgets/video_input.dart';
import '../models/donation.dart';
import '../models/user.dart' as userModel;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/donation_points_provider.dart';
import '../widgets/location_input.dart';
import '../models/place_location.dart';
import '../services/location_helper.dart';
import 'package:tadweer_alkheer/screens/authn_screen.dart';

class AddDonationScreen extends StatefulWidget {
  static const routeName = '/add-donation';

  @override
  _AddDonationScreenState createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _form = GlobalKey<FormState>();

  File _pickedVideo;
  File _pickedImage;
  PlaceLocation _pickedLocation;
  String _description;
  String _category;
  String _quantity = "0";
  bool _isInit = true;
  DateTime _pickupDateTime;
  bool _isLoading = false;
  var _selectTime;
  var _selectDate;
  String validateMobile;
  String _mobile;
  int _points = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _category = ModalRoute.of(context).settings.arguments as String;
      _isInit = false;
    }
  }

  //List<String> categories = ['Medical', 'Food', 'Education', 'Clothes'];

  // to recieve the selected image
  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

// to receive the selected video
  void _selectVideo(File pickedVideo) {
    setState(() {
      _pickedVideo = pickedVideo;
      if (_pickedVideo == null) return;
    });
  }

  // to add donation points
  void _pointsAdded() {
    setState(() {
      _points = 100 + _points;
      return _points;
    });
  }

  // to recieve the selected location
  void _selectPlace(double lat, double lng) {
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
      );
    });
  }

  //to select date
  Future _presentDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 10)),
    );
    if (date == null) {
      return;
    }

    setState(() {
      _selectDate = date;
    });
  }

  Future _presentTimePicker() async {
    final initialTime = TimeOfDay(hour: 12, minute: 0);
    final time = await showTimePicker(
      context: _selectTime ?? context,
      initialTime: initialTime,
    );
    if (time == null) {
      return;
    }
    setState(() {
      _selectTime = time;
    });
  }

  Future pickDateTime(BuildContext context) async {
    await _presentDatePicker();
    if (_selectDate == null) return;

    await _presentTimePicker();
    if (_selectTime == null) return;
    setState(() {
      _pickupDateTime = DateTime(
        _selectDate.year,
        _selectDate.month,
        _selectDate.day,
        _selectTime.hour,
        _selectTime.minute,
      );
    });
  }

  Future<void> _addDonation() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    //validate form
    final isValid = _form.currentState.validate();
    if (!isValid) {
      _isLoading = false;
      return;
    }

    final user =  FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      //user have to login first!
      Navigator.of(context)
          .pushNamed(AuthnScreen.routeName, arguments: true)
          .then((value) => _addDonation());
      return;
    }

    setState(() {
      _isLoading = true;
    });
    //submit form
    _form.currentState.save();
    final donationsProvider =
        Provider.of<DonationsProvider>(context, listen: false);
    final pointsProvider =
    Provider.of<DonationPointsProvider>(context, listen: false);
    var userData = await _db.collection('users').doc(user.uid).get();

    try {
      // //to store image in firebase storage
      // final ref = FirebaseStorage.instance
      //     .ref()
      //     .child('donation_image')
      //     .child(user.uid + new Random().nextInt(1000000).toString() + '.jpg');
      //
      // await ref.putFile(_pickedImage).whenComplete(() => {});
      // //to get a url that can be saved anywhere
      // final imageUrl = await ref.getDownloadURL();

      var videoUrl;
      if (_pickedVideo != null) {
        //to store video in firebase storage
        // final vidRef = FirebaseStorage.instance
        //     .ref()
        //     .child('donation_video')
        //     .child(
        //         user.uid + new Random().nextInt(1000000).toString() + '.mp4');

        var metadata = SettableMetadata(contentType: 'video/mp4');
        // await vidRef.putFile(_pickedVideo, metadata).whenComplete(() => {});
        // //to get a url that can be saved anywhere
        // videoUrl = await vidRef.getDownloadURL();
      }
      //to get a human readable address
      final address = await LocationHelper.getPlaceAddress(
        _pickedLocation.latitude,
        _pickedLocation.longitude,
      );

      final location = PlaceLocation(
        latitude: _pickedLocation.latitude,
        longitude: _pickedLocation.longitude,
        address: address,
      );

      Donation donation = Donation(
          description: _description,
          category: _category,
          imageUrl: '',
          videoUrl: videoUrl,
          date: DateTime.now(),
          userId: user.uid,
          pickupDateTime: _pickupDateTime,
          quantity: int.parse(_quantity),
          location: location,
          status: "Awaiting Pickup");
      DocumentReference don = await donationsProvider.addDonation(
        donation,
      );
      pointsProvider.addPoints(Point(userId: user.uid,quantity: 100,date: DateTime.now()));
      var updatedUser = userModel.User(
          name: userData.data()['name'],
          joinDate: DateTime.parse(userData.data()['joinDate']),
          imageUrl: userData.data()['imageUrl'],
          videoUrl: userData.data()['videoUrl'],
          phoneNumber: userData.data()['phoneNumber'],
          itemsDonated: userData.data()['itemsDonated'] + 1);

      usersProvider.updateUser(updatedUser, user.uid);
    } catch (error) {
      print('add donation error - $error');
    }
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DonationDoneScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("${AppLocalizations.of(context).additem} - ${_category}"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
//added these lines.

//added this row.
/*
                    Row(
                      children: [
                        ImageInput(_selectImage),
                        VideoInput(_selectVideo),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        AppLocalizations.of(context).pickupdatetimelabel,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => pickDateTime(context),
                      child: Text(
                        _pickupDateTime == null
                            ? AppLocalizations.of(context).selectdatetime
                            : DateFormat('dd/MM/yyyy HH:mm')
                                .format(_pickupDateTime),
                      ),
                    ),\
                  */
                    /*
                    TextFormField(
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).descriptionlabel),
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).descError;
                        }
                        if (value.length < 10) {
                          return AppLocalizations.of(context).least10CharError;
                        }
                        if (value.length > 110) {
                          return AppLocalizations.of(context).most110CharError;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value;
                      },
                    ),
                    */
/*
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 1),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).quantitylabel),
                        style: TextStyle(fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).quantityError;
                          }
                          if (int.parse(value) < 1) {
                            return AppLocalizations.of(context)
                                .least1QuantityError;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _quantity = value;
                        },
                      ),
                    ),
                    */

                    if (_category == "Custom")
                      TextFormField(
                        decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context).itemcategory),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a category';
                          }
                          if (value.length < 2) {
                            return 'This should be at least 2 characters';
                          }
                          if (value.length > 30) {
                            return 'This should be at most 30 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _category = value;
                        },
                      ),


                    LocationInput(_selectPlace),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).phonenumber),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      validator: (val) {
                        if (val.length != 10) {
                          return AppLocalizations.of(context).validateMobile;
                        } else
                          return null;
                      },
                      onSaved: (val) {
                        _mobile = val;
                      },
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).descriptionlabel),
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.multiline,
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (!_isLoading)
            ElevatedButton(
              onPressed: () {
                if (_pickedLocation != null && _mobile != null) {
                  return null;
                } else
                  return _addDonation();
              },
              child: Text(AppLocalizations.of(context).donateitem),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 5.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // <-- Radius
                ),
              ),
            ),
        ],
      ),
    );
  }
}
/*
 /*_pickedImage == null ||
                  _pickupDateTime == null ||
                  */
                  (_pickedLocation == null && _mobile == null
                      ? null
                      : _addDonation
                      ),
*/
