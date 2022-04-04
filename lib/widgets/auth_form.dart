import 'dart:io';
import 'package:flutter/material.dart';
import './user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    String name,
    String address, 
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;

  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  String _userEmail = '';
  String _icnumber = '';
  String _userPassword = '';
  String _userName = '';
  String _userAddress = '' ; 
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    // if (_userImageFile == null && !_isLogin) {
    //   Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please pick an image'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _icnumber.trim(),
        _userName.trim(),
        _userAddress.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('icnumber'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: 'ICnumber',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least4 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _icnumber = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('name'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('address'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 20) {
                          return 'Please enter at least 20 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userAddress = value;
                      },
                    ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(_isLogin
                          ? 'create new account'
                          : 'I already have an account'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}