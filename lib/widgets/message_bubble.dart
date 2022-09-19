import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this._message, this.isMe, this._username, this._userImage, this.key);
  final String _message;
  final bool isMe;
  final Key? key;
  final String _username;
  final String _userImage;

  @override
  Widget build(BuildContext context) {
    ;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: isMe
                      ? Colors.grey[300]
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: !isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(12))),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    _username,
                    style: TextStyle(
                        color: isMe ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            child: _userImage.isEmpty ? Icon(Icons.person) : null,
            backgroundImage: _userImage.isEmpty ? null : NetworkImage(_userImage),)
            ),
      ],
    );
  }
}
