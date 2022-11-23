import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String userImage;
  final bool isMe;

  const MessageBubble(this.message, this.username, this.userImage, this.isMe,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: !isMe ? Radius.circular(1) : Radius.circular(15),
                  bottomRight: isMe ? Radius.circular(1) : Radius.circular(15),
                ),
              ),
              //width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -15,
          left: !isMe ? 5 : null,
          right: isMe ? 5 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
            radius: 15,
          ),
        ),
      ],
    );
  }
}
