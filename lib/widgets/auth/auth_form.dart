import 'dart:io';

import 'package:chat_app_flutter/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, File image,
      String password, bool isLogin) _submitAuthForm;
  final bool _isLoading;

  const AuthForm(this._submitAuthForm, this._isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  late String _userEmail;
  String? _userName;
  late String _userPassword;
  File? userImageFile;

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final bool isValid = _formKey.currentState!.validate();
    if (userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image!'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget._submitAuthForm(
        _userEmail.trim(),
        (_userName ?? '').trim(),
        userImageFile!,
        _userPassword.trim(),
        _isLogin,
      );
    }
  }

  void _pickedImage(File image) {
    userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return 'Username must be at least 4 character.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password must be at least 8 character.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(height: 10),
                  if (widget._isLoading) const CircularProgressIndicator(),
                  if (!widget._isLoading)
                    ElevatedButton(
                      onPressed: () {
                        _trySubmit();
                      },
                      child: Text(
                        _isLogin ? "Log in" : 'Sign up',
                      ),
                    ),
                  if (!widget._isLoading)
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'I already have an account',
                      ),
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
