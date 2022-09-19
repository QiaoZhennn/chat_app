import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitAuthForm(String email,String password, String username, File? image,
      bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String image_url = '';
        if (image != null) {
          final ref = FirebaseStorage.instance.ref().child('user_image').child(userCredential.user!.uid + '.jpg');
          await ref.putFile(image).whenComplete(() {});
          image_url = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user!.uid)
            .set({'username': username, 'email': email, 'image_url':image_url});
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      String message = "An error occured, please check your credentials";
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).colorScheme.error,
      ));
    } catch (err) {
      print(err.runtimeType.toString() + err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
