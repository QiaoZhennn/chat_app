import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = snapshot.data?.docs;
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              reverse: true,
              itemCount: chatDocs == null ? 0 : chatDocs.length,
              itemBuilder: ((context, index) => MessageBubble(
                  chatDocs![index]['text'],
                  chatDocs[index]['userId'] == user.uid,
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                  ValueKey(chatDocs[index].id))));
        });
  }
}
