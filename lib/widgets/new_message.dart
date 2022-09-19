import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = '';
  final _controller = new TextEditingController();

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.fromLTRB(15, 8, 8, 20),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Send a message ...'),
          onChanged: (value) {
            setState(() {
              _enteredMessage = value;
            });
          },
          onEditingComplete:
              _enteredMessage.trim().isEmpty ? null : _sendMessage,
        )),
        IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send)),
      ]),
    );
  }
}
