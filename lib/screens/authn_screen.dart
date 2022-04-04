// login page.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/screens/tabs_screen.dart';
import '../providers/users_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart' as TKDUser;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthnScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _AuthnScreenState createState() => _AuthnScreenState();
}

class _AuthnScreenState extends State<AuthnScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;
  var _isLogin = true;
  var _isDonor = true;

  String _userName = '';

  File _userImageFile;
  UserCredential authResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      _isDonor = ModalRoute.of(context).settings.arguments as bool;
      _isInit = false;
    }
  }

  //for phone auth
  String verId;
  String phone;
  bool codeSent = false;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submitAuthForm() async {
    final isValid = _formKey.currentState.validate();

    setState(() {
      _isLoading = false;
    });

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      phone = '+966' + phone.substring(1);

      try {
        setState(() {
          _isLoading = true;
        });
        if (_isLogin) {
          //login with existing
          loginVerifyPhone();
        } else {
          signupVerifyPhone();
        }
      } on PlatformException catch (err) {
        var message = "An error occured, please check credentials";
        if (err.message != null) {
          message = err.message;
        }
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> loginVerifyPhone() async {
    var usersProvider = Provider.of<UsersProvider>(context, listen: false);

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = phone;
    print("Debug sssssssssssssssssssssssssssssssssssssssssssssssssssssss");
    print(phone);

    String type = _isDonor ? "donor" : "driver";

    var snapShot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: number)
        .where('type', isEqualTo: type)
        .get();

    if (snapShot.docs.length > 0) {
      isValidUser = true;
      print("Debug iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
    } else {
      snapShot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: number)
          .get();
      if (snapShot.docs.length > 0) {
        print("its old version user");

        //update its profile to be donor by default
        final usersProvider =
            Provider.of<UsersProvider>(context, listen: false);
        final document = snapShot.docs[0];
        var users = snapShot.docs
            .map((doc) => TKDUser.User.fromMap(doc.data(), doc.id))
            .toList();

        var user = users[0];

        user.type = type;

        usersProvider.updateUser(
          user,
          document.id,
        );

        isValidUser = true;
      }
    }

    if (isValidUser) {
      print("Debug mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (phoneAuthCredential) async {
            authResult = await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential);
            print("Debug kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
            // final snackBar = SnackBar(content: Text("Login .......Success"));
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);

            //User Logged In, Return to Prev. Screen!
            Navigator.pop(context);

            // Navigator.of(context).pushReplacementNamed(
            //   TabsScreen.routeName,
            // );

            if (authResult != null) {
              //redirect
              setState(() {
                _isLoading = false;
              });
            }
          },
          verificationFailed: (Exception e) {
            final snackBar = SnackBar(
                content: Text("${e.toString()} Login was Unsuccessful"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          codeSent: (verificationId, [forceResendingToken]) {
            setState(() {
              codeSent = true;
              verId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              verId = verificationId;
            });
          },
          timeout: Duration(seconds: 60));
    } else {
      final snackBar = SnackBar(
        content: Text(
          (AppLocalizations.of(context).accountnotexist),
        ),
        backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> signupVerifyPhone() async {
    var usersProvider = Provider.of<UsersProvider>(context, listen: false);
    UserCredential authResult;

    //first we will check if a user with this cell number exists
    var isExistingUser = false;
    var number = phone.trim();

    final snapShot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: number)
        .get();

    if (snapShot.docs.length > 0) {
      isExistingUser = true;
    }

    if (isExistingUser) {
      final snackBar =
          SnackBar(content: Text(AppLocalizations.of(context).userexists));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _isLoading = false;
    } else {
      print("Check 000000000000000000000000000000");
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (phoneAuthCredential) async {
            authResult = await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential);
            final snackBar = SnackBar(content: Text("Signup Success"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pushReplacementNamed(
              TabsScreen.routeName,
            );

            //if (authResult != null) {
            var imageUrl = "";

            print("Check 111111111111111111111111");

            if (_userImageFile != null) {
              //upload image to Firebase Storeage
              final ref = FirebaseStorage.instance
                  .ref()
                  .child('user_image')
                  .child(authResult.user.uid + '.jpg');

              await ref.putFile(_userImageFile).whenComplete(() => {});
              imageUrl =
                  await ref.getDownloadURL(); //get an url to the stored image

            }
            //store registration details in firestore database
            print("2222222222222");
            await //add user to the users collection
                usersProvider
                    .addUser(
                        TKDUser.User(
                          phoneNumber: phone.trim(),
                          name: _userName.trim(),
                          imageUrl: null,
                          itemsDonated: 0,
                          completedTasks: 0,
                          joinDate: DateTime.now(),
                          type: "donor",
                        ),
                        authResult.user.uid)
                    .then((value) => {
                          //then move to authorised area
                          setState(() {
                            _isLoading = false;
                          })
                        })
                    .catchError((onError) => {
                          debugPrint(
                              'Error saving user to db.' + onError.toString())
                        });
            print("3333333333333333333333333333333333333333");
            //}
          },
          verificationFailed: (Exception e) {
            final snackBar = SnackBar(content: Text("${e.toString()}"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          codeSent: (verificationId, [forceResendingToken]) {
            setState(() {
              codeSent = true;
              verId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              verId = verificationId;
            });
          },
          timeout: Duration(seconds: 60));
    }
  }

  Future<void> loginVerifyPin(String pin) async {
    // phoneAuthCredential  =
    //     PhoneAuthProvider.getCredential(verificationId: verId, smsCode: pin);

    try {
      await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: verId, smsCode: pin));
      // final snackBar = SnackBar(content: Text("Login Success"));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    } on Exception catch (e) {
      final snackBar = SnackBar(
        content: Text("Incorrect OTP"),
        backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AuthnScreen(),
        ),
        (route) => false,
      );
    }
  }

  Future<void> signupVerifyPin(String pin) async {
    // phoneAuthCredential  =
    //     PhoneAuthProvider.getCredential(verificationId: verId, smsCode: pin);
    var usersProvider = Provider.of<UsersProvider>(context, listen: false);

    try {
      authResult = await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: verId, smsCode: pin));
      // final snackBar = SnackBar(content: Text("Signup Success"));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pushReplacementNamed(
        TabsScreen.routeName,
      );
      if (authResult != null) {
        var imageUrl = "";

        print("Check Piin 111111111111111111111111");

        if (_userImageFile != null) {
          //upload image to Firebase Storeage
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child(authResult.user.uid + '.jpg');

          await ref.putFile(_userImageFile).whenComplete(() => null);
          imageUrl =
              await ref.getDownloadURL(); //get an url to the stored image

        }
        //store registration details in firestore database
        print("check pin 2222222222222");
        var currentUser =  FirebaseAuth.instance.currentUser;
        await //add user to the users collection
            usersProvider
                .addUser(
                    TKDUser.User(
                      phoneNumber: phone.trim(),
                      name: _userName.trim(),
                      imageUrl: null,
                      itemsDonated: 0,
                      completedTasks: 0,
                      joinDate: DateTime.now(),
                      type: "donor",
                    ),
                    currentUser.uid)
                .then((value) => {
                      //then move to authorised area
                      setState(() {
                        _isLoading = false;
                      })
                    })
                .catchError((onError) => {
                      debugPrint(
                          'Error saving user to db.' + onError.toString())
                    });
        print("check pin3333333333333333333333333333333333333333");
      }
    } on Exception catch (e) {
      final snackBar = SnackBar(
        content: Text("Incorrect OTP"),
        backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AuthnScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("CodeSent: {$codeSent}");
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Center(
            child: Text(
          'Tadweer Al Khair',
          textAlign: TextAlign.center,
        )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/splash_1.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.6,
                  fit: BoxFit.scaleDown,

                  //fit: BoxFit.cover,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //if (!_isLogin && !codeSent) UserImagePicker(_pickedImage),

                    if (!_isLogin && !codeSent)
                      TextFormField(
                        key: ValueKey('name'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).name,
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return AppLocalizations.of(context).validicnumber;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    if (_isLogin)
                      SizedBox(
                        height: 50,
                      ),
                    codeSent
                        ? OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 30,
                            style: TextStyle(fontSize: 20),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              if (_isLogin) {
                                loginVerifyPin(pin);
                              } else {
                                signupVerifyPin(pin);
                              }
                            },
                            onChanged: (pin) {
                              if (pin.length == 6) {
                                print("Changed: " + pin);
                              }
                            },
                          )
                        : TextFormField(
                            key: ValueKey('phonenumber'),
                            enableSuggestions: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context).phonenumberlabel,
                              suffixIcon: Icon(
                                Icons.smartphone,
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length != 10) {
                                return AppLocalizations.of(context)
                                    .verifyphonenum;
                              }
                              if (!value.startsWith('0')) {
                                return AppLocalizations.of(context)
                                    .verifyphonenum2;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value.trim();
                            },
                          ),
                    // IntlPhoneField(
                    //     decoration: InputDecoration(
                    //         labelText: AppLocalizations.of(context)
                    //             .phonenumberlabel,
                    //         border: OutlineInputBorder(
                    //             borderSide: BorderSide())),
                    //     initialCountryCode: 'SA',
                    //     onChanged: (phoneNumber) {
                    //       setState(() {
                    //         phone = phoneNumber.completeNumber;
                    //       });
                    //     },
                    //   ),

                    SizedBox(
                      height: 12,
                    ),
                    if (_isLoading) CircularProgressIndicator(),
                    if (!_isLoading)
                      ElevatedButton(
                        child: Text(_isLogin
                            ? AppLocalizations.of(context).login
                            : AppLocalizations.of(context).register),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.6, 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: /* phone == null ? null : */ _submitAuthForm,
                      ),
                    if (!_isLoading && _isLogin && _isDonor)
                      ElevatedButton(
                        child: Text(AppLocalizations.of(context).newaccount),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.6, 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                    if (!_isLoading && !_isLogin)
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context).haveaccount,
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    SizedBox(
                      height: 100,
                    ),
                    /*

                    if (!_isLoading && _isLogin)
                      ElevatedButton(
                        child: RichText(
                          //textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: AppLocalizations.of(context).loginas,
                            ),
                            TextSpan(
                                text: _isDonor
                                    ? AppLocalizations.of(context).driver
                                    : AppLocalizations.of(context).donor,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ),
                        //  Text(_isDonor
                        //     ? AppLocalizations.of(context).loginas + " " +  AppLocalizations.of(context).driver
                        //     : AppLocalizations.of(context).loginas + " " +  AppLocalizations.of(context).donor),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.5, 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isDonor = !_isDonor;
                          });
                        },
                      ),
                    */
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
