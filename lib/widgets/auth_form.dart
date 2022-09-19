import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username, File? image,
      bool isLogin, BuildContext ctx) submitFn;
  bool _isLoading = false;
  AuthForm(this.submitFn, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String? _email = '';
  String? _username = '';
  String? _password = '';
  File? _userImageFile;

  void _pickImage(File? image) {
    _userImageFile = image;
  }
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_email!.trim(), _password!.trim(),  _username!.trim(),_userImageFile,
          _isLogin, context);
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
                children: [
                  if (!_isLogin)
                    UserImagePicker(_pickImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'invalid email';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'invalid username';
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _username = value;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'invalid password';
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _password = value;
                    },
                    onEditingComplete: _trySubmit,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child:
                          _isLogin ? const Text('Login') : const Text('Signup'),
                    ),
                  if (!widget._isLoading)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: _isLogin
                            ? const Text('Create new account')
                            : const Text('Already have an account')),
                ],
              )),
        )),
      ),
    );
  }
}
